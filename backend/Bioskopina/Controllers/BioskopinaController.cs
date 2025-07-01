using Bioskopina.Model;
using Bioskopina.Model.Requests;
using Bioskopina.Model.SearchObjects;
using Bioskopina.Services;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Bioskopina.Model;
using Bioskopina.Services.Database;

namespace Bioskopina.Controllers
{
    
    [ApiController]
    public class BioskopinaController : BaseCRUDController<
        Model.Bioskopina,
        BioskopinaSearchObject,
        BioskopinaInsertRequest,
        BioskopinaUpdateRequest>
    {
        protected IBioskopinaService _bService;
        private readonly BioskopinaContext _context;
        public BioskopinaController(IBioskopinaService service) : base(service)
        {
            _bService = service;
        }

        [HttpGet("GetMostPopularMovies")]
        public async Task<List<PopularBioskopinaData>> GetMostPopularBiskopina()
        {
            return await _bService.GetMostPopularMovie();
        }


      






    }
}
