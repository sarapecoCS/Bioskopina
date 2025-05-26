using Bioskopina.Model.Requests;
using Bioskopina.Model.SearchObjects;
using Bioskopina.Services;
using Microsoft.AspNetCore.Mvc;

namespace Bioskopina.Controllers
{
    [ApiController]
    public class QAcategoryController : BaseCRUDController<Model.QAcategory, QAcategorySearchObject, QAcategoryInsertRequest, QAcategoryUpdateRequest>
    {
        public QAcategoryController(IQAcategoryService service) : base(service)
        {

        }
    }
}