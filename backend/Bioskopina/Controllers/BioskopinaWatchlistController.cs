using Bioskopina.Model.Requests;
using Bioskopina.Model.SearchObjects;
using Bioskopina.Services;
using Microsoft.AspNetCore.Mvc;

namespace Bioskopina.Controllers
{
    [ApiController]
    public class BioskopinaWatchlistController : BaseCRUDController<Model.BWatchlist, BioskopinaWatchlistSearchObject, BioskopinaWatchlistInsertRequest, BioskopinaWatchlistUpdateRequest>
    {
        public BioskopinaWatchlistController(IBioskopinaWatchlistService service) : base(service)
        {

        }
    }
}