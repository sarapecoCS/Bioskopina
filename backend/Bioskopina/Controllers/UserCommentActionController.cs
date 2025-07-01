using Bioskopina.Model;
using Bioskopina.Model.Requests;
using Bioskopina.Model.SearchObjects;
using Bioskopina.Services;
using Microsoft.AspNetCore.Mvc;

namespace Bioskopina.Controllers
{
    [ApiController]
    public class UserCommentActionController : BaseCRUDController<Model.UserCommentAction, UserCommentActionSearchObject, UserCommentActionInsertRequest, UserCommentActionUpdateRequest>
    {
        protected IUserCommentActionService _userCommentActionService;
        public UserCommentActionController(IUserCommentActionService service) : base(service)
        {
            _userCommentActionService = service;
        }

        [HttpPost("action/{commentId}")]
        public async Task<bool> CommentUserAction(int commentId, [FromBody] UserCommentActionInsertRequest userCommentAction)
        {
            var username = User.Identity!.Name;

           return await _userCommentActionService.CommentUserAction(commentId, userCommentAction, username!);
        }
    }
}