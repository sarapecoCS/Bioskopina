using AutoMapper;
using Bioskopina.Model.Requests;
using Bioskopina.Model.SearchObjects;
using Bioskopina.Services.Database;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Bioskopina.Services
{
    public class UserProfilePictureService : BaseCRUDService<Model.UserProfilePicture, Database.UserProfilePicture, UserProfilePictureSearchObject, UserProfilePictureInsertRequest, UserProfilePictureUpdateRequest>, IUserProfilePictureService
    {
        public UserProfilePictureService(BioskopinaContext context, IMapper mapper) : base(context, mapper)
        {
        }


    }
}
