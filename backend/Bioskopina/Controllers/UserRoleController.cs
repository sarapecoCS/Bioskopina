using Bioskopina.Model;
using Bioskopina.Model.Requests;
using Bioskopina.Model.SearchObjects;
using Bioskopina.Services;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace Bioskopina.Controllers
{
    [ApiController]
    public class UserRoleController : BaseCRUDController<Model.UserRole, UserRoleSearchObject, UserRoleInsertRequest, UserRoleUpdateRequest>
    {
        public UserRoleController(IUserRoleService service) : base(service)
        {

        }

        [AllowAnonymous]
        public override Task<UserRole> Insert([FromBody] UserRoleInsertRequest insert)
        {
            return base.Insert(insert);
        }
    }
}