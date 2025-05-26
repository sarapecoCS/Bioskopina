using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Bioskopina.Model.Requests
{
    public class UserCommentActionInsertRequest
    {
        public int UserId { get; set; }

        public int CommentId { get; set; }

        public string Action { get; set; } = null!;
    }
}
