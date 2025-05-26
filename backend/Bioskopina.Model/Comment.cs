using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Bioskopina.Model
{
    public class Comment
    {
  

        public int Id { get; set; }

        public int PostId { get; set; }

        public int UserId { get; set; }

        public string Content { get; set; } = null!;

        public int LikesCount { get; set; }

        public int DislikesCount { get; set; }

        public DateTime DateCommented { get; set; }

     //   public virtual Post Post { get; set; } = null!;

        public virtual User User { get; set; } = null!;

    }
}
