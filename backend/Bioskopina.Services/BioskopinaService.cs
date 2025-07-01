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
                query = query.Where(x => x.TitleEn.StartsWith(search.Title));
            }

            if (!string.IsNullOrWhiteSpace(search?.FTS))
            {
                query = query.Where(x => x.TitleEn.Contains(search.FTS) );
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
                .Include(m => m.Ratings)
                .Include(m => m.GenreMovies)         
                .ThenInclude(gm => gm.Genre)         
                .ToListAsync();

            var sortedMovies = movieList
                .OrderByDescending(m => m.Score)
                .Take(5)
                .ToList();

            var popularM = new List<PopularBioskopinaData>();

            foreach (var m in sortedMovies)
            {
                popularM.Add(new PopularBioskopinaData()
                {
                    BioskopinaTitleEN = m.TitleEn,
                    imageUrl = m.ImageUrl,
                    Score = (decimal)m.Score,
                    Director = m.Director,
                    NumberOfRatings = m.Ratings.Count,
                    Genres = m.GenreMovies.Select(gm => gm.Genre.Name).ToList()  
                });
            }

            return popularM;
        }

        public async Task<Model.Bioskopina> Update(int id, BioskopinaUpdateRequest request)
        {
            var entity = await _context.Bioskopina
                .Include(m => m.GenreMovies) // include existing genres
                .FirstOrDefaultAsync(m => m.Id == id);

            if (entity == null) throw new Exception("Entity not found");

            // Map non-genre properties from request to entity
            _mapper.Map(request, entity);

            // Fetch Genre entities for the requested genre IDs
            var genres = await _context.Genres
                .Where(g => request.GenreIds.Contains(g.Id))
                .ToListAsync();

            // Clear current genre associations
            entity.GenreMovies.Clear();

            // Add updated genre associations
            foreach (var genre in genres)
            {
                entity.GenreMovies.Add(new Database.GenreBioskopina
                {
                    GenreId = genre.Id,
                    Genre = genre,
                    Movies = entity
                });
            }

            await _context.SaveChangesAsync();

            return _mapper.Map<Model.Bioskopina>(entity);
        }


        public async Task<Model.Bioskopina> Insert(BioskopinaInsertRequest request)
        {
            var entity = _mapper.Map<Database.Bioskopina>(request);

            // Load the Genre entities from the database based on the IDs in request
            var genres = await _context.Genres
                .Where(g => request.GenreIds.Contains(g.Id))
                .ToListAsync();

            // Map genres to the join entity and add to movie's GenreMovies collection
            foreach (var genre in genres)
            {
                entity.GenreMovies.Add(new Database.GenreBioskopina
                {
                    GenreId = genre.Id,
                    Genre = genre,
                    Movies = entity
                });
            }

            _context.Bioskopina.Add(entity);
            await _context.SaveChangesAsync();

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
