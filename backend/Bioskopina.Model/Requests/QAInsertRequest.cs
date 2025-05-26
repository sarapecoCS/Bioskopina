using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Bioskopina.Model.Requests
{
    public class QAInsertRequest
    {
        public int UserId { get; set; }

        public int CategoryId { get; set; }

        public string Question { get; set; } = null!;

        public string Answer { get; set; } = null!;

        public bool Displayed { get; set; }
    }
}
