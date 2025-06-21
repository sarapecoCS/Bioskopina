using AutoMapper;
using Bioskopina.Model.Requests;
using Bioskopina.Model.SearchObjects;
using Bioskopina.Services.Database;
using Microsoft.EntityFrameworkCore;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Bioskopina.Services
{
    public class BioskopinaListService : BaseCRUDService<Model.BioskopinaList, Database.BioskopinaList, BioskopinaListSearchObject, BioskopinaListInsertRequest, BioskopinaListUpdateRequest>, IBioskopinaListService
    {
        protected BioskopinaContext _context;
        protected readonly IMapper _mapper;

        public BioskopinaListService(BioskopinaContext context, IMapper mapper)
            : base(context, mapper)
        {
            _context = context;
            _mapper = mapper;
        }

        public override IQueryable<Database.BioskopinaList> AddFilter(IQueryable<Database.BioskopinaList> query, BioskopinaListSearchObject? search = null)
        {
            if (search?.Id != null)
                query = query.Where(bList => bList.Id == search.Id);

            if (search?.MovieId != null)
                query = query.Where(bList => bList.MovieId == search.MovieId);

            if (search?.ListId != null)
                query = query.Where(bList => bList.ListId == search.ListId);

            if (search?.GetRandom == true)
                query = query.OrderBy(bList => Guid.NewGuid()).Take(1);

            return base.AddFilter(query, search);
        }

        public override IQueryable<Database.BioskopinaList> AddInclude(IQueryable<Database.BioskopinaList> query, BioskopinaListSearchObject? search = null)
        {
            if (search?.IncludeMovie == true)
            {
                query = query.Include(bList => bList.Movie)
                             .Include(bList => bList.List);
            }

            return base.AddInclude(query, search);
        }
        

        public async Task<bool> UpdateListsForMovies(int movieId, List<BioskopinaListInsertRequest> newLists)
        {
            await DeleteByMovieId(movieId);

            var entities = newLists.Select(insert => _mapper.Map<Database.BioskopinaList>(insert));
            await _context.BioskopinaLists.AddRangeAsync(entities);
            await _context.SaveChangesAsync();

            return true;
        }

        public async Task<bool> DeleteByMovieId(int movieId)
        {
            var set = _context.Set<Database.BioskopinaList>();
            var entityList = await set.Where(bList => bList.MovieId == movieId).ToListAsync();

            if (entityList.Any())
            {
                set.RemoveRange(entityList);
                await _context.SaveChangesAsync();
                return true;
            }

            return false;
        }
    }
}
