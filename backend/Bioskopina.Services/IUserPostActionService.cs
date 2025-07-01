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
    public interface IUserPostActionService : ICRUDService<Model.UserPostAction, UserPostActionSearchObject, UserPostActionInsertRequest, UserPostActionUpdateRequest>
    {
        Task<bool> PostUserAction(int postId, UserPostActionInsertRequest userPostAction, string username);
    }
}
