using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Bioskopina.Model.Requests
{
    public class ListInsertRequest
    {
        public int UserId { get; set; }

        public string Name { get; set; } = null!;

        public DateTime DateCreated { get; set; }
    }
}
