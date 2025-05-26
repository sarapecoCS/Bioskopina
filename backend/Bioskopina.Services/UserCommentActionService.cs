using AutoMapper;
using Bioskopina.Model;
using Bioskopina.Model.Requests;
using Bioskopina.Model.SearchObjects;
using Bioskopina.Services.Database;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Bioskopina.Services
{
    public class UserCommentActionService : BaseCRUDService<Model.UserCommentAction, Database.UserCommentAction, UserCommentActionSearchObject, UserCommentActionInsertRequest, UserCommentActionUpdateRequest>, IUserCommentActionService
    {
        protected BioskopinaContext _context;
        protected IMapper _mapper;
        public UserCommentActionService(BioskopinaContext context, IMapper mapper) : base(context, mapper)
        {
            _context = context;
            _mapper = mapper;
        }

        public override IQueryable<Database.UserCommentAction> AddFilter(IQueryable<Database.UserCommentAction> query, UserCommentActionSearchObject? search = null)
        {
            if(search?.UserId != null)
            {
                query = query.Where(uca => uca.UserId == search.UserId);
            }

            return base.AddFilter(query, search);
        }

        public async Task<bool> CommentUserAction(int commentId, UserCommentActionInsertRequest userCommentAction, string username)
        {
            var user = await _context.Users.SingleOrDefaultAsync(u => u.Username == username);

            if (user == null)
            {
                return false;
            }

            var comment = await _context.Comments.Include(c => c.UserCommentActions).SingleOrDefaultAsync(c => c.Id == commentId);

            if (comment == null)
            {
                return false;
            }

            var existingAction = comment.UserCommentActions.SingleOrDefault(a => a.UserId == user.Id);
            if (existingAction != null)
            {
                _context.UserCommentActions.Remove(existingAction);
                if (existingAction.Action == "like")
                {
                    comment.LikesCount--;
                }
                else if (existingAction.Action == "dislike")
                {
                    comment.DislikesCount--;
                }
            }

            if (userCommentAction.Action == "like")
            {
                comment.LikesCount++;
            }
            else if (userCommentAction.Action == "dislike")
            {
                comment.DislikesCount++;
            }

            userCommentAction.UserId = user.Id;
            userCommentAction.CommentId = commentId;
            _context.UserCommentActions.Add(_mapper.Map<Database.UserCommentAction>(userCommentAction));
            await _context.SaveChangesAsync();

            return true;
        }

    }

}
