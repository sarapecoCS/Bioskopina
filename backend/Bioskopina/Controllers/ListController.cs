using Bioskopina.Model.Requests;
using Bioskopina.Model.SearchObjects;
using Bioskopina.Services;
using Microsoft.AspNetCore.Mvc;

namespace Bioskopina.Controllers
{
    [ApiController]
    public class ListController : BaseCRUDController<Model.List, ListSearchObject, ListInsertRequest, ListUpdateRequest>
    {
        public ListController(IListService service) : base(service)
        {

        }
    }
}