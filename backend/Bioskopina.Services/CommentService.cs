using AutoMapper;
using Bioskopina.Model.Requests;
using Bioskopina.Model.SearchObjects;
using Bioskopina.Services.Database;
using Microsoft.EntityFrameworkCore;
using System;
using System.Linq;
using System.Threading.Tasks;

namespace Bioskopina.Services
{
    public class CommentService : BaseCRUDService<Model.Comment, Database.Comment, CommentSearchObject, CommentInsertRequest, CommentUpdateRequest>, ICommentService
    {
        // Constructor with dependency injection for context and mapper
        public CommentService(BioskopinaContext context, IMapper mapper) : base(context, mapper)
        {
        }

        // Method to delete all comments by post ID
        public async Task<bool> DeleteAllCommentsByPostId(int postId)
        {
            var comments = await _context.Comments
                .Where(c => c.PostId == postId)
                .ToListAsync();

            if (comments.Any())
            {
                _context.Comments.RemoveRange(comments);
                await _context.SaveChangesAsync();
                return true;
            }

            return false;
        }

    }
}
