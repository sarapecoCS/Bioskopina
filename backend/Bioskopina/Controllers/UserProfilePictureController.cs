using Bioskopina.Model.Requests;
using Bioskopina.Model.SearchObjects;
using Bioskopina.Services;
using Microsoft.AspNetCore.Mvc;

namespace Bioskopina.Controllers
{
    [ApiController]
    public class UserProfilePictureController : BaseCRUDController<Model.UserProfilePicture, UserProfilePictureSearchObject, UserProfilePictureInsertRequest, UserProfilePictureUpdateRequest>
    {
        public UserProfilePictureController(IUserProfilePictureService service) : base(service)
        {

        }
    }
}