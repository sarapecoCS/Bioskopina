using Bioskopina.Model;
using Bioskopina.Services;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using System.Threading.Tasks;

namespace Bioskopina.Controllers
{
    [Route("[controller]")]
    [Authorize]
    public class BaseController<T, TSearch, TInsert, TUpdate> : ControllerBase
        where T : class
        where TSearch : class
    {
        private readonly ICRUDService<T, TSearch, TInsert, TUpdate> _service;

        // Use strongly typed service instead of dynamic
        public BaseController(ICRUDService<T, TSearch, TInsert, TUpdate> service)
        {
            _service = service;
        }

        [HttpGet]
        public virtual async Task<PagedResult<T>> Get([FromQuery] TSearch? search = null)
        {
            // Ensure the service returns the correct type
            return await _service.Get(search);
        }

        [HttpGet("{id}")]
        public virtual async Task<T> GetById(int id)
        {
            // Ensure the service returns the correct type
            return await _service.GetById(id);
        }

        [HttpPost]
        [AllowAnonymous]
        public virtual async Task<T> Insert([FromBody] TInsert insert)
        {
            return await _service.Insert(insert);
        }

        [HttpPut("{id}")]
        public virtual async Task<T> Update(int id, [FromBody] TUpdate update)
        {
            return await _service.Update(id, update);
        }

        [HttpDelete("{id}")]
        public virtual async Task<T> Delete(int id)
        {
            return await _service.Delete(id);
        }
    }
}
