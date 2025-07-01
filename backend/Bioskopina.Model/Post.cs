using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Xml.Linq;

namespace Bioskopina.Model
{
    public class Post
    {
        public int Id { get; set; }

      

        public int UserId { get; set; }

        public string Content { get; set; } = null!;

        public int LikesCount { get; set; }

        public int DislikesCount { get; set; }

        public DateTime DatePosted { get; set; }

     
        
        public virtual ICollection<Comment> Comments { get; set; } = new List<Comment>();

        public virtual User User { get; set; } = null!;
    }
}
