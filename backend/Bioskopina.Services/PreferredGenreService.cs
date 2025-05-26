using AutoMapper;
using Bioskopina.Model;
using Bioskopina.Model.Requests;
using Bioskopina.Model.SearchObjects;
using Bioskopina.Services.Database;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Bioskopina.Services
{
    public class PreferredGenreService : BaseCRUDService<Model.PreferredGenre, Database.PreferredGenre, PreferredGenreSearchObject, PreferredGenreInsertRequest, PreferredGenreUpdateRequest>, IPreferredGenreService
    {
        public PreferredGenreService(BioskopinaContext context, IMapper mapper) : base(context, mapper)
        {
        }

        public override IQueryable<Database.PreferredGenre> AddFilter(IQueryable<Database.PreferredGenre> query, PreferredGenreSearchObject? search = null)
        {
            if(search?.UserId != null)
            {
                query = query.Where(pg => pg.UserId == search.UserId);
            }

            return base.AddFilter(query, search);
        }

        public async Task<bool> DeleteByUserId(int userId)
        {
            var set = _context.Set<Database.PreferredGenre>();

            var entityList = await set.Where(pg => pg.UserId == userId).ToListAsync();

            if (entityList.Count() != 0)
            {
                set.RemoveRange(entityList);

                await _context.SaveChangesAsync();

                return true;
            }

            return false;
        }

        public async Task<bool> UpdatePrefGenresForUser(int userId, List<PreferredGenreInsertRequest> newPrefGenres)
        {
            await DeleteByUserId(userId);

            var entities = newPrefGenres.Select(insert => _mapper.Map<Database.PreferredGenre>(insert));

            _context.PreferredGenres.AddRange(entities);

            await _context.SaveChangesAsync();

            return true;
        }
    }
}
