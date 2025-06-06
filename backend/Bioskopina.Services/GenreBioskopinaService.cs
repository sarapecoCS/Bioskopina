﻿using AutoMapper;
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
    public class GenreBioskopinaService : BaseCRUDService<Model.GenreBioskopina, Database.GenreBiskopina, GenreBioskopinaSearchObject, GenreBioskopinaInsertRequest, GenreBioskopinaUpdateRequest>, IGenreBioskopinaService
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
            var set = _context.Set<Database.GenreBiskopina>();
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

            var entities = newGenres.Select(insert => _mapper.Map<Database.GenreBiskopina>(insert));
            _context.GenreMovies.AddRange(entities);
            await _context.SaveChangesAsync();

            return true;
        }

        public override IQueryable<Database.GenreBiskopina> AddFilter(IQueryable<Database.GenreBiskopina> query, GenreBioskopinaSearchObject? search = null)
        {
            if (search?.MovieId != null)
                query = query.Where(x => x.MovieId == search.MovieId);

            return base.AddFilter(query, search);
        }
    }
}
