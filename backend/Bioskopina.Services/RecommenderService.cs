using AutoMapper;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
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
        static MLContext mlContext = null;
        static object isLocked = new object();
        static ITransformer model = null;

        public RecommenderService(IMapper mapper, BioskopinaContext context) : base(context, mapper)
        {
            _mapper = mapper;
            _context = context;
        }

        public async Task<Model.Recommender?> GetById(int movieId, CancellationToken cancellationToken = default)
        {
            var entity = await _context.Recommenders.FirstOrDefaultAsync(r => r.MovieId == movieId, cancellationToken);

            if (entity is null)
                return null;

            return _mapper.Map<Model.Recommender>(entity);
        }

        public List<Model.Bioskopina> Recommend(int movieId)
        {
            lock (isLocked)
            {
                if (mlContext == null)
                {
                    mlContext = new MLContext();

                    var tmpData = _context.Watchlists.Include(w => w.BioWatchlists).ToList();

                    var data = new List<BioskopinaRecommendation>();

                    foreach (var x in tmpData)
                    {
                        if (x.BioWatchlists.Count > 1)
                        {
                            var distinctItemId = x.BioWatchlists.Select(y => y.MovieId).ToList();

                            distinctItemId?.ForEach(y =>
                            {
                                var relatedItems = x.BioWatchlists.Where(z => z.MovieId != y);

                                foreach (var z in relatedItems)
                                {
                                    data.Add(new BioskopinaRecommendation()
                                    {
                                        MovieId = (uint)y,
                                        CoMovieId = (uint)z.MovieId,
                                    });
                                }
                            });
                        }
                    }

                    var trainData = mlContext.Data.LoadFromEnumerable(data);

                    MatrixFactorizationTrainer.Options options = new MatrixFactorizationTrainer.Options();
                    options.MatrixColumnIndexColumnName = nameof(BioskopinaRecommendation.MovieId);
                    options.MatrixRowIndexColumnName = nameof(BioskopinaRecommendation.CoMovieId);
                    options.LabelColumnName = "Label";
                    options.LossFunction = MatrixFactorizationTrainer.LossFunctionType.SquareLossOneClass;
                    options.Alpha = 0.01;
                    options.Lambda = 0.025;
                    options.NumberOfIterations = 100;
                    options.C = 0.00001;

                    var est = mlContext.Recommendation().Trainers.MatrixFactorization(options);

                    model = est.Fit(trainData);
                }
            }

            var movies = _context.Bioskopina.Where(x => x.Id != movieId).ToList();

            var predictionResult = new List<Tuple<Database.Bioskopina, float>>();

            foreach (var m in movies)
            {
                var predictionengine = mlContext.Model.CreatePredictionEngine<BioskopinaRecommendation, CoBioskopinaPrediction>(model);
                var prediction = predictionengine.Predict(
                                     new BioskopinaRecommendation()
                                     {
                                         MovieId = (uint)movieId,
                                         CoMovieId = (uint)m.Id 
                                     });

                predictionResult.Add(new Tuple<Database.Bioskopina, float>(m, prediction.Score));
            }

            var finalResult = predictionResult.OrderByDescending(x => x.Item2).Select(x => x.Item1).Take(3).ToList();

            return _mapper.Map<List<Model.Bioskopina>>(finalResult);
        }

        public async Task<PagedResult<Model.Recommender>> TrainMovieModelAsync(CancellationToken cancellationToken = default)
        {
            var movies = await _context.Bioskopina.ToListAsync(cancellationToken);
            var numberOfRecords = await _context.BioskopinaWatchlists.CountAsync(cancellationToken);

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
                await _context.SaveChangesAsync();

                return _mapper.Map<PagedResult<Model.Recommender>>(recommendList);
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
    }
}
