using Bioskopina.Model.Requests;
using Bioskopina.Model.SearchObjects;
using Microsoft.EntityFrameworkCore.Metadata;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Bioskopina.Services
{
    public interface ICommentService : ICRUDService<Model.Comment, CommentSearchObject, CommentInsertRequest, CommentUpdateRequest>
    {
        public Task<bool> DeleteAllCommentsByPostId(int postId);
    }
}
