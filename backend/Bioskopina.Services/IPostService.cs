using Bioskopina.Model.Requests;
using Bioskopina.Model.SearchObjects;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.CompilerServices;
using System.Text;
using System.Threading.Tasks;

namespace Bioskopina.Services
{
    public interface IPostService : ICRUDService<Model.Post, PostSearchObject, PostInsertRequest, PostUpdateRequest>
    {
       // Task DeleteAllCommentsByPostId(int postId);
    }
}
