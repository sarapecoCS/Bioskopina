using Bioskopina.Model.Requests;
using Bioskopina.Model.SearchObjects;
using Bioskopina.Services;
using Microsoft.AspNetCore.Mvc;

namespace Bioskopina.Controllers
{
    [ApiController]
    public class PostController : BaseCRUDController<Model.Post, PostSearchObject, PostInsertRequest, PostUpdateRequest>
    {
        public PostController(IPostService service) : base(service)
        {

        }
    }
}