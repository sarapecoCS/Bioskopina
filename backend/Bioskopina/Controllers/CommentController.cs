using Bioskopina.Model.Requests;
using Bioskopina.Model.SearchObjects;
using Bioskopina.Services;
using Microsoft.AspNetCore.Mvc;

namespace Bioskopina.Controllers
{
    [ApiController]
    public class CommentController : BaseCRUDController<Model.Comment, CommentSearchObject, CommentInsertRequest, CommentUpdateRequest>
    {
        public CommentController(ICommentService service) : base(service)
        {

        }
    }
}