using Bioskopina.Model;
using Bioskopina.Model.Requests;
using Bioskopina.Model.SearchObjects;
using Bioskopina.Services;
using Microsoft.AspNetCore.Mvc;

namespace Bioskopina.Controllers
{
    [ApiController]
    public class UserPostActionController : BaseCRUDController<Model.UserPostAction, UserPostActionSearchObject, UserPostActionInsertRequest, UserPostActionUpdateRequest>
    {
        protected IUserPostActionService _userPostActionService;
        public UserPostActionController(IUserPostActionService service) : base(service)
        {
            _userPostActionService = service;
        }

        [HttpPost("action/{postId}")]
        public async Task<bool> PostUserAction(int postId, [FromBody] UserPostActionInsertRequest userPostAction)
        {
            var username = User.Identity!.Name;

           return await _userPostActionService.PostUserAction(postId, userPostAction, username!);
        }
    }
}