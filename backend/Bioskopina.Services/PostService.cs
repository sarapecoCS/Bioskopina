using AutoMapper;
using Bioskopina.Model;
using Bioskopina.Model.Requests;
using Bioskopina.Model.SearchObjects;
using Bioskopina.Services.Database;
using Microsoft.EntityFrameworkCore;
using System;
using System.Linq;
using System.Threading.Tasks;

namespace Bioskopina.Services
{
    public class PostService : BaseCRUDService<Model.Post, Database.Post, PostSearchObject, PostInsertRequest, PostUpdateRequest>, IPostService
    {
        protected ICommentService _commentService;

        // Constructor with dependency injection for context, mapper, and comment service
        public PostService(BioskopinaContext context, IMapper mapper, ICommentService commentService) : base(context, mapper)
        {
            _commentService = commentService;
        }

        // Method to include related comments in search queries
        public override IQueryable<Database.Post> AddInclude(IQueryable<Database.Post> query, PostSearchObject? search = null)
        {
            if (search?.CommentsIncluded == true)
            {
                query = query.Include(post => post.Comments);
            }

            return base.AddInclude(query, search);
        }

        // Method to add filters for querying posts based on search parameters
        public override IQueryable<Database.Post> AddFilter(IQueryable<Database.Post> query, PostSearchObject? search = null)
        {
            if (search?.UserId != null)
            {
                query = query.Where(x => x.UserId == search.UserId);
            }

            if (search?.NewestFirst == true)
            {
                query = query.OrderByDescending(x => x.DatePosted);
            }

            if (search?.Id != null)
            {
                query = query.Where(x => x.Id == search.Id);
            }

            return base.AddFilter(query, search);
        }

        public override async Task BeforeDelete(Database.Post entity)
        {
            var commentsToDelete = _context.Comments.Where(c => c.PostId == entity.Id);
            _context.Comments.RemoveRange(commentsToDelete); // Remove all comments for the post
            await _context.SaveChangesAsync(); // Save changes to ensure comments are deleted first

            // Now delete the post
            await base.BeforeDelete(entity);
        }

    }
}
