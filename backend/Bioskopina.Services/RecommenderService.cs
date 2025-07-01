using AutoMapper;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading;
using System.Threading.Tasks;
using Bioskopina.Model.Requests;
using Bioskopina.Model.SearchObjects;
using Bioskopina.Services.Database;
using Microsoft.EntityFrameworkCore;
using Microsoft.ML;
using Bioskopina.Model;
using Microsoft.ML.Trainers;

namespace Bioskopina.Services
{
    public class RecommenderService : BaseCRUDService<Model.Recommender, Database.Recommender, RecommenderSearchObject, RecommenderInsertRequest, RecommenderUpdateRequest>, IRecommenderService
    {
        protected readonly IMapper _mapper;
        private readonly BioskopinaContext _context;

        static readonly object isLocked = new object();
        static MLContext mlContext = null;
        static ITransformer model = null;
        static PredictionEngine<BioskopinaRecommendation, CoBioskopinaPrediction> predictionEngine = null;

        public RecommenderService(IMapper mapper, BioskopinaContext context) : base(context, mapper)
        {
            _mapper = mapper;
            _context = context;
        }

        public async Task<Model.Recommender?> GetById(int movieId, CancellationToken cancellationToken = default)
        {
            var entity = await _context.Recommenders.FirstOrDefaultAsync(r => r.MovieId == movieId, cancellationToken);
            return entity == null ? null : _mapper.Map<Model.Recommender>(entity);
        }

        public List<Model.Bioskopina> Recommend(int movieId)
        {
            lock (isLocked)
            {
                if (mlContext == null || model == null)
                {
                    mlContext = new MLContext();
                    var lists = _context.Lists
                        .Include(l => l.BioskopinaLists)
                        .Where(l => l.BioskopinaLists.Count > 1)
                        .ToList();

                    var data = new List<BioskopinaRecommendation>();

                    foreach (var list in lists)
                    {
                        var movieIds = list.BioskopinaLists.Select(bl => bl.MovieId).Distinct().ToList();
                        foreach (var movieA in movieIds)
                        {
                            foreach (var movieB in movieIds)
                            {
                                if (movieA != movieB)
                                {
                                    data.Add(new BioskopinaRecommendation
                                    {
                                        MovieId = (uint)movieA,
                                        CoMovieId = (uint)movieB,
                                        Label = 1f
                                    });
                                }
                            }
                        }
                    }

                    if (!data.Any())
                        throw new Exception("Not enough data to train the recommendation model.");

                    var trainingDataView = mlContext.Data.LoadFromEnumerable(data);
                    var options = new MatrixFactorizationTrainer.Options
                    {
                        MatrixColumnIndexColumnName = nameof(BioskopinaRecommendation.MovieId),
                        MatrixRowIndexColumnName = nameof(BioskopinaRecommendation.CoMovieId),
                        LabelColumnName = nameof(BioskopinaRecommendation.Label),
                        LossFunction = MatrixFactorizationTrainer.LossFunctionType.SquareLossOneClass,
                        Alpha = 0.01,
                        Lambda = 0.025,
                        NumberOfIterations = 100,
                        C = 0.00001
                    };

                    var pipeline = mlContext.Recommendation().Trainers.MatrixFactorization(options);
                    model = pipeline.Fit(trainingDataView);
                    predictionEngine = mlContext.Model.CreatePredictionEngine<BioskopinaRecommendation, CoBioskopinaPrediction>(model);
                }
            }

            var allMovies = _context.Bioskopina.Where(m => m.Id != movieId).ToList();
            var scoredMovies = new List<(Database.Bioskopina Movie, float Score)>();

            foreach (var movie in allMovies)
            {
                var prediction = predictionEngine.Predict(new BioskopinaRecommendation
                {
                    MovieId = (uint)movieId,
                    CoMovieId = (uint)movie.Id
                });
                scoredMovies.Add((movie, prediction.Score));
            }

            return _mapper.Map<List<Model.Bioskopina>>(
                scoredMovies.OrderByDescending(m => m.Score)
                           .Take(3)
                           .Select(m => m.Movie)
                           .ToList());
        }

        public async Task CreateNewRecommendation(List<Database.Recommender> results, CancellationToken cancellationToken = default)
        {
            var existingRecommendations = await _context.Recommenders.ToListAsync();
            var moviesCount = await _context.Bioskopina.CountAsync(cancellationToken);
            var recommendationCount = await _context.Recommenders.CountAsync();

            if (recommendationCount != 0)
            {
                if (recommendationCount > moviesCount)
                {
                    for (int i = 0; i < moviesCount; i++)
                    {
                        existingRecommendations[i].MovieId = results[i].MovieId;
                        existingRecommendations[i].CoMovieId1 = results[i].CoMovieId1;
                        existingRecommendations[i].CoMovieId2 = results[i].CoMovieId2;
                        existingRecommendations[i].CoMovieId3 = results[i].CoMovieId3;
                    }

                    for (int i = moviesCount; i < recommendationCount; i++)
                    {
                        _context.Recommenders.Remove(existingRecommendations[i]);
                    }
                }
                else
                {
                    for (int i = 0; i < recommendationCount; i++)
                    {
                        existingRecommendations[i].MovieId = results[i].MovieId;
                        existingRecommendations[i].CoMovieId1 = results[i].CoMovieId1;
                        existingRecommendations[i].CoMovieId2 = results[i].CoMovieId2;
                        existingRecommendations[i].CoMovieId3 = results[i].CoMovieId3;
                    }
                    var num = results.Count - recommendationCount;

                    if (num > 0)
                    {
                        for (int i = results.Count - num; i < results.Count; i++)
                        {
                            await _context.Recommenders.AddAsync(results[i]);
                        }
                    }
                }
            }
            else
            {
                await _context.Recommenders.AddRangeAsync(results);
            }
        }

        public async Task<PagedResult<Model.Recommender>> TrainMovieModelAsync(CancellationToken cancellationToken = default)
        {
            var movies = await _context.Bioskopina.ToListAsync(cancellationToken);
            var numberOfRecords = await _context.BioskopinaLists.CountAsync(cancellationToken);

            if (movies.Count > 4 && numberOfRecords > 8)
            {
                List<Database.Recommender> recommendList = new List<Database.Recommender>();

                foreach (var m in movies)
                {
                    var recommendedMovies = Recommend(m.Id);
                    var resultRecommend = new Database.Recommender()
                    {
                        MovieId = m.Id,
                        CoMovieId1 = recommendedMovies[0].Id,
                        CoMovieId2 = recommendedMovies[1].Id,
                        CoMovieId3 = recommendedMovies[2].Id
                    };
                    recommendList.Add(resultRecommend);
                }

                await CreateNewRecommendation(recommendList, cancellationToken);
                await _context.SaveChangesAsync(cancellationToken);

                var mappedResult = _mapper.Map<List<Model.Recommender>>(recommendList);
                var pagedResult = new PagedResult<Model.Recommender>
                {
                    TotalCount = mappedResult.Count,
                    Items = mappedResult
                };

                return pagedResult;
            }
            else
            {
                throw new Exception("Not enough data to generate recommendations.");
            }
        }

        public async Task DeleteAllRecommendations(CancellationToken cancellationToken = default)
        {
            var allRecommenders = await _context.Recommenders.ToListAsync(cancellationToken);
            _context.Recommenders.RemoveRange(allRecommenders);
            await _context.SaveChangesAsync(cancellationToken);
        }

        public async Task CreateOrUpdateRecommendationsAsync(List<Database.Recommender> newRecommendations, CancellationToken cancellationToken = default)
        {
            var existingRecommendations = await _context.Recommenders.ToListAsync(cancellationToken);
            var moviesCount = await _context.Bioskopina.CountAsync(cancellationToken);

            if (existingRecommendations.Count == 0)
            {
                await _context.Recommenders.AddRangeAsync(newRecommendations, cancellationToken);
                return;
            }

            foreach (var rec in newRecommendations)
            {
                var existing = existingRecommendations.FirstOrDefault(r => r.MovieId == rec.MovieId);
                if (existing != null)
                {
                    existing.CoMovieId1 = rec.CoMovieId1;
                    existing.CoMovieId2 = rec.CoMovieId2;
                    existing.CoMovieId3 = rec.CoMovieId3;
                }
                else
                {
                    await _context.Recommenders.AddAsync(rec, cancellationToken);
                }
            }

            var movieIds = newRecommendations.Select(r => r.MovieId).ToHashSet();
            var toRemove = existingRecommendations.Where(r => !movieIds.Contains(r.MovieId)).ToList();

            if (toRemove.Any())
                _context.Recommenders.RemoveRange(toRemove);
        }
    }
}