using Bioskopina.Model;
using Bioskopina.Model.Requests;
using Bioskopina.Model.SearchObjects;
using Bioskopina.Services;
using Bioskopina.Services.Database;
using Microsoft.AspNetCore.Mvc;

namespace Bioskopina.Controllers
{
    [ApiController]
    public class GenreBioskopinaController : BaseCRUDController<Model.GenreBioskopina, GenreBioskopinaSearchObject, GenreBioskopinaInsertRequest, GenreBioskopinaUpdateRequest>
    {
        protected readonly IGenreBioskopinaService _service;
        private readonly BioskopinaContext _context;

        public GenreBioskopinaController(IGenreBioskopinaService service) : base(service)
        {
            _service = service;
        }

        [ApiExplorerSettings(IgnoreApi = true)]
        public override Task<Model.GenreBioskopina> Update(int id, [FromBody] GenreBioskopinaUpdateRequest update)
        {
            return base.Update(id, update);
        }

        [HttpPut("UpdateGenres/{movieId}")]
        public async Task<bool> UpdateGenresForMovie(int movieId, [FromBody] List<GenreBioskopinaInsertRequest> newGenres)
        {
            return await _service.UpdateGenresForMovie(movieId, newGenres);
        }

       






    }
}
