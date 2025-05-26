using Bioskopina.Model.Requests;
using Bioskopina.Model.SearchObjects;
using Bioskopina.Services;
using Microsoft.AspNetCore.Mvc;

namespace Bioskopina.Controllers
{
    [ApiController]
    public class QAController : BaseCRUDController<Model.QA, QASearchObject, QAInsertRequest, QAUpdateRequest>
    {
        public QAController(IQAService service) : base(service)
        {

        }
    }
}