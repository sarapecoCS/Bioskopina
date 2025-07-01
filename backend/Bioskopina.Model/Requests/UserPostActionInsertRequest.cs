using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Bioskopina.Model.Requests
{
    public class UserPostActionInsertRequest
    {
        public int UserId { get; set; }

        public int PostId { get; set; }

        public string Action { get; set; } = null!;
    }
}
