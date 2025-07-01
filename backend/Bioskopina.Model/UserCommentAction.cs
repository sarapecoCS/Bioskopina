using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Bioskopina.Model
{
    public class UserCommentAction
    {
        public int Id { get; set; }

        public int? UserId { get; set; }

        public int? CommentId { get; set; }
    
        public virtual Comment Comment { get; set; }
        public virtual User User { get; set; }
        public string Action { get; set; } = null!;
    }
}
