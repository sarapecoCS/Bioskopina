using Bioskopina.Model;
using Bioskopina.Model.Requests;
using Bioskopina.Model.SearchObjects;
using Bioskopina.Services;
using Microsoft.AspNetCore.Mvc;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace Bioskopina.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class BioskopinaListController : BaseCRUDController<BioskopinaList, BioskopinaListSearchObject, BioskopinaListInsertRequest, BioskopinaListUpdateRequest>
    {
        private readonly IBioskopinaListService _service;

        public BioskopinaListController(IBioskopinaListService service)
            : base(service)
        {
            _service = service;
        }

        [HttpPut("UpdateLists/{movieId}")]
        public async Task<bool> UpdateListsForMovies(int movieId, [FromBody] List<BioskopinaListInsertRequest> newLists)
        {
            return await _service.UpdateListsForMovies(movieId, newLists);
        }
    }
}
