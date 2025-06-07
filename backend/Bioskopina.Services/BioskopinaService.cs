using AutoMapper;
using Bioskopina.Model;
using Bioskopina.Model.Requests;
using Bioskopina.Model.SearchObjects;
using Bioskopina.Services.Database;
using Microsoft.EntityFrameworkCore;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Bioskopina.Services
{
    public class BioskopinaService
        : BaseCRUDService<Model.Bioskopina, Database.Bioskopina, BioskopinaSearchObject, BioskopinaInsertRequest, BioskopinaUpdateRequest>, IBioskopinaService
    {
        protected BioskopinaContext _context;

        public BioskopinaService(BioskopinaContext context, IMapper mapper)
            : base(context, mapper)
        {
            _context = context;
        }

        public override IQueryable<Database.Bioskopina> AddFilter(IQueryable<Database.Bioskopina> query, BioskopinaSearchObject? search = null)
        {
            if (!string.IsNullOrWhiteSpace(search?.Title))
            {
                query = query.Where(x => x.TitleEn.StartsWith(search.Title) || x.TitleYugo.StartsWith(search.Title));
            }

            if (!string.IsNullOrWhiteSpace(search?.FTS))
            {
                query = query.Where(x => x.TitleEn.Contains(search.FTS) || x.TitleYugo.Contains(search.FTS));
            }

            if (search?.NewestFirst == true)
            {
                query = query.OrderByDescending(x => x.Id);
            }

            if (search?.Id != null)
            {
                query = query.Where(x => x.Id == search.Id);
            }

            if (search?.TopFirst == true)
            {
                query = query.OrderByDescending(m => m.Ratings.Count).ThenByDescending(m => m.Score);
            }

            if (search?.Ids != null)
            {
                query = query.Where(m => search.Ids.Contains(m.Id));
            }

            if (search?.GenreIds != null)
            {
                foreach (var genreId in search.GenreIds)
                {
                    query = query.Where(m => m.GenreMovies.Any(g => g.GenreId == genreId));
                }
            }

            if (search?.GetEmptyList == true)
            {
                query = query.Where(m => false);
            }

            return base.AddFilter(query, search);
        }

        public override IQueryable<Database.Bioskopina> AddInclude(IQueryable<Database.Bioskopina> query, BioskopinaSearchObject? search = null)
        {
            if (search?.GenresIncluded == true)
            {
                query = query.Include(x => x.GenreMovies)
                             .ThenInclude(g => g.Genre);
            }

            return base.AddInclude(query, search);
        }

        public async Task<List<PopularBioskopinaData>> GetMostPopularMovie()
        {
            var movieList = await _context.Bioskopina
                                          .OrderByDescending(b => b.Ratings.Count)
                                          .ThenByDescending(b => b.Score)
                                          .Take(5)
                                          .ToListAsync();

            var popularM = new List<PopularBioskopinaData>();

            foreach (var m in movieList)
            {
                popularM.Add(new PopularBioskopinaData()
                {
                    BioskopinaTitleEN = m.TitleEn,
                    BioskopinaTitleYugo = m.TitleYugo,
                    imageUrl = m.ImageUrl,
                    Score = (decimal)m.Score,
                    Director = m.Director,
                    NumberOfRatings = _context.Ratings.Count(r => r.MovieId == m.Id)
                });
            }

            return popularM;
        }

        public async Task<Model.Bioskopina> Update(int id, BioskopinaUpdateRequest request)
        {
            var entity = await _context.Bioskopina.FindAsync(id);
            if (entity == null) throw new Exception("Entity not found");

            // Manually update properties OR use AutoMapper:
            _mapper.Map(request, entity);

            await _context.SaveChangesAsync();

            // Map back to your API model
            return _mapper.Map<Model.Bioskopina>(entity);
        }

        public async Task<Model.Bioskopina> Insert(BioskopinaInsertRequest request)
        {
            // Map the insert request to the database entity
            var entity = _mapper.Map<Database.Bioskopina>(request);

            // Add the new entity to the context
            _context.Bioskopina.Add(entity);

            // Save changes asynchronously
            await _context.SaveChangesAsync();

            // Map the saved entity back to the API model and return
            return _mapper.Map<Model.Bioskopina>(entity);
        }

        // Delete method
        public async Task DeleteMovieAsync(int movieId)
        {
            var movie = await _context.Bioskopina
                .Include(m => m.BioskopinaWatchlists)
                .FirstOrDefaultAsync(m => m.Id == movieId);

            if (movie == null)
                throw new KeyNotFoundException("Movie not found.");

            if (movie.BioskopinaWatchlists.Any())
            {
                _context.BioskopinaWatchlists.RemoveRange(movie.BioskopinaWatchlists);
            }

            _context.Bioskopina.Remove(movie);
            await _context.SaveChangesAsync();
        }


    }
}
