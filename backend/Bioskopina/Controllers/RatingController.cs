using Bioskopina.Model.Requests;
using Bioskopina.Model.SearchObjects;
using Bioskopina.Services;
using Microsoft.AspNetCore.Mvc;

namespace Bioskopina.Controllers
{
    [ApiController]
    public class RatingController : BaseCRUDController<Model.Rating, RatingSearchObject, RatingInsertRequest, RatingUpdateRequest>
    {
        public RatingController(IRatingService service) : base(service)
        {

        }
    }
}