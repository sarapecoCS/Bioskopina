using Bioskopina.Model;
using Bioskopina.Model.Requests;
using Bioskopina.Model.SearchObjects;
using Bioskopina.Services;
using Microsoft.AspNetCore.Mvc;

namespace Bioskopina.Controllers
{
    [ApiController]
    public class WatchlistController : BaseCRUDController<Model.Watchlist, WatchlistSearchObject, WatchlistInsertRequest, WatchlistUpdateRequest>
    {
        public WatchlistController(IWatchlistService service) : base(service)
        {

        }

        [ApiExplorerSettings(IgnoreApi = true)]
        public override Task<Watchlist> Update(int id, [FromBody] WatchlistUpdateRequest update)
        {
            return base.Update(id, update);
        }
    }
}