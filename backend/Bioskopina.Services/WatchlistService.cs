using AutoMapper;
using Bioskopina.Model.Requests;
using Bioskopina.Model.SearchObjects;
using Bioskopina.Services.Database;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Bioskopina.Services
{
    public class WatchlistService : BaseCRUDService<Model.Watchlist, Database.Watchlist, WatchlistSearchObject, WatchlistInsertRequest, WatchlistUpdateRequest>, IWatchlistService
    {
        public WatchlistService(BioskopinaContext context, IMapper mapper) : base(context, mapper)
        {

        }

        public override IQueryable<Watchlist> AddFilter(IQueryable<Watchlist> query, WatchlistSearchObject? search = null)
        {
            if(search?.UserId != null)
            {
                query = query.Where(watchlist => watchlist.UserId == search.UserId);
            }

            return base.AddFilter(query, search);
        }
    }
}
