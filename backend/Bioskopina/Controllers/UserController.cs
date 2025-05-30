using Bioskopina.Model;
using Bioskopina.Model.Requests;
using Bioskopina.Model.SearchObjects;
using Bioskopina.Services;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using System.Threading.Tasks;

namespace Bioskopina.Controllers
{
    [ApiController]
    //[Route("api/[controller]")]
    public class UserController : BaseController<Model.User, UserSearchObject, UserInsertRequest, UserUpdateRequest>
    {
        private readonly IUserService _userService;

        public UserController(IUserService service) : base(service)
        {
            _userService = service;
        }
       

        [AllowAnonymous]
        public override async Task<Model.User> Insert([FromBody] UserInsertRequest insert)
        {
            return await base.Insert(insert);
        }

        [HttpPost("register")]
        [AllowAnonymous]
        public async Task<Model.User> Register([FromBody] UserInsertRequest insert)
        {
            return await _userService.Insert(insert);
        }

        [AllowAnonymous]
        public override async Task<PagedResult<Model.User>> Get([FromQuery] UserSearchObject? search = null)
        {
            return await base.Get(search);
        }

        [HttpGet("GetUserRegistrations/{days}")]
        public async Task<List<UserRegistrationData>> GetUserRegistrations(int days, bool groupByMonths = false)
        {
            return await _userService.GetUserRegistrations(days, groupByMonths);
        }

        [HttpPost("ChangePassword/{userId}")]
        public async Task<IActionResult> ChangePassword(int userId, [FromBody] ChangePasswordRequest request)
        {
            try
            {
                if (userId != request.UserId)
                {
                    return Forbid("You don't have permission to change another user's password.");
                }

                await _userService.ChangePassword(request);

                return Ok(new { Message = "Password changed successfully." });
            }
            catch (Exception ex)
            {
                return StatusCode(500, ex.Message);
            }
        }

        [HttpDelete("{userId}")]
        public async Task<IActionResult> DeleteUser(int userId)
        {
            try
            {
                await _userService.Delete(userId);
                return Ok(new { Message = "User and related data deleted successfully." });
            }
            catch (Exception ex)
            {
                return StatusCode(500, ex.Message);
            }
        }


    }
}
