using AutoMapper;
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
    public class BioskopinaWatchlistService : BaseCRUDService<Model.BWatchlist, Database.BioskopinaWatchlist, BioskopinaWatchlistSearchObject, BioskopinaWatchlistInsertRequest, BioskopinaWatchlistUpdateRequest>, IBioskopinaWatchlistService
    {
        public BioskopinaWatchlistService(BioskopinaContext context, IMapper mapper) : base(context, mapper)
        {

        }

        public virtual IQueryable<BioskopinaWatchlist> AddFilter(IQueryable<BioskopinaWatchlist> query, BioskopinaWatchlistSearchObject? search = null)
        {
            if (search?.MovieId!= null)
            {
                query = query.Where(mWatchlist => mWatchlist.MovieId == search.MovieId);
            }

            if (search?.WatchlistId != null)
            {
                query = query.Where(mWatchlist => mWatchlist.WatchlistId == search.WatchlistId);
            }


            //if (search?.NewestFirst != null)
            //{
            //    query = query.OrderByDescending(mWatchlist => mWatchlist.Id);
            //}

            return base.AddFilter(query, search);
        }

        public override IQueryable<BioskopinaWatchlist> AddInclude(IQueryable<BioskopinaWatchlist> query, BioskopinaWatchlistSearchObject? search = null)
        {
            // Always include related data
            query = query
                .Include(x => x.Movie)      // Will map to Bioskopina
                .Include(x => x.Watchlist);

            // Optional: Include genres if requested
            if (search?.GenresIncluded == true)
            {
                query = query.Include(x => x.Movie)
                             .ThenInclude(m => m.GenreMovies)
                             .ThenInclude(gm => gm.Genre);
            }

            return query;
        }
    }
}
