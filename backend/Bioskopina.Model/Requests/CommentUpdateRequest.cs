using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Bioskopina.Model.Requests
{
    public class CommentUpdateRequest
    {
        public string Content { get; set; } = null!;

        public int LikesCount { get; set; }

        public int DislikesCount { get; set; }
    }
}
