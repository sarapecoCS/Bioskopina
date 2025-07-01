using Bioskopina.Model;
using Bioskopina.Model.Requests;
using Bioskopina.Model.SearchObjects;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Bioskopina.Services
{
    public interface IUserService : ICRUDService<User, UserSearchObject, UserInsertRequest, UserUpdateRequest>
    {
        public Task<Model.User> Login(string username, string password);
        public Task<List<UserRegistrationData>> GetUserRegistrations(int days, bool groupByMonths = false);
        Task ChangePassword(ChangePasswordRequest request);
    }
}
