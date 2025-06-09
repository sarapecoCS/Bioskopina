using AutoMapper;
using Bioskopina.Model;
using Bioskopina.Model.Requests;
using Bioskopina.Model.SearchObjects;
using Bioskopina.Services.Database;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Stripe;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Bioskopina.Services
{

    public class GenreBioskopinaService : BaseCRUDService<Model.GenreBioskopina, Database.GenreBioskopina, GenreBioskopinaSearchObject, GenreBioskopinaInsertRequest, GenreBioskopinaUpdateRequest>, IGenreBioskopinaService
    {
        protected BioskopinaContext _context;
        protected IMapper _mapper;

        public GenreBioskopinaService(BioskopinaContext context, IMapper mapper) : base(context, mapper)
        {
            _context = context;
            _mapper = mapper;
        }

        public async Task<bool> DeleteByMovieId(int movieId)
        {
            var set = _context.Set<Database.GenreBioskopina>();
            var list = await set.Where(x => x.MovieId == movieId).ToListAsync();

            if (list.Any())
            {
                set.RemoveRange(list);
                await _context.SaveChangesAsync();
                return true;
            }

            return false;
        }

        public async Task<bool> UpdateGenresForMovie(int movieId, List<GenreBioskopinaInsertRequest> newGenres)
        {
            await DeleteByMovieId(movieId);

            var entities = newGenres.Select(insert => _mapper.Map<Database.GenreBioskopina>(insert));
            _context.GenreBioskopina.AddRange(entities);
            await _context.SaveChangesAsync();

            return true;
        }


        public override async Task<Model.GenreBioskopina> GetById(int id)
        {
            var entity = await _context.GenreBioskopina
                .Include(x => x.Genre) 
                .FirstOrDefaultAsync(x => x.Id == id);

            if (entity == null)
                return default;

            return _mapper.Map<Model.GenreBioskopina>(entity);
        }

        public override IQueryable<Database.GenreBioskopina> AddFilter(IQueryable<Database.GenreBioskopina> query, GenreBioskopinaSearchObject? search = null)
        {
            if (search?.MovieId != null)
                query = query.Where(x => x.MovieId == search.MovieId);

            return base.AddFilter(query, search);
        }
        public async Task<List<Model.GenreBioskopina>> GetGenresByMovie(int movieId)
        {
            var entities = await _context.GenreBioskopina
                .Include(g => g.Genre)
                .Where(g => g.MovieId == movieId)
                .ToListAsync();

            
            var models = entities.Select(e => new Model.GenreBioskopina
            {
                Id = e.Id,
                MovieId = e.MovieId,
                GenreId = e.GenreId,
                Genre = new Model.Genre
                {
                    Id = e.Genre.Id,
                    Name = e.Genre.Name
                }
                
            }).ToList();

            return models;
        }



    }
}
