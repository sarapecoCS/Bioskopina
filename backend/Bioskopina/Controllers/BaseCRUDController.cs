using Bioskopina.Model;
using Bioskopina.Services;
using Microsoft.AspNetCore.Mvc;
using System.Threading.Tasks;

namespace Bioskopina.Controllers
{
    [Route("[controller]")]
    [ApiController]
    public class BaseCRUDController<T, TSearch, TInsert, TUpdate>
        : BaseController<T, TSearch, TInsert, TUpdate>
        where T : class
        where TSearch : class
    {
        protected readonly ICRUDService<T, TSearch, TInsert, TUpdate> _service;

        public BaseCRUDController(ICRUDService<T, TSearch, TInsert, TUpdate> service)
            : base(service)
        {
            _service = service;
        }

        [NonAction] // ✅ Prevent Swagger from mapping this as an API action
        public virtual async Task<T> Insert([FromBody] TInsert insert)
        {
            return await _service.Insert(insert);
        }

        [NonAction] // ✅ Prevent Swagger from mapping this as an API action
        public virtual async Task<T> Update(int id, [FromBody] TUpdate update)
        {
            return await _service.Update(id, update);
        }

        [NonAction] // ✅ Prevent Swagger from mapping this as an API action
        public virtual async Task<T> Delete(int id)
        {
            return await _service.Delete(id);
        }
    }
}
