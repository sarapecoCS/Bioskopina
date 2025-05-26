using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Bioskopina.Model.Requests
{
    public class QAUpdateRequest
    {
        public string Question { get; set; } = null!;

        public string Answer { get; set; } = null!;

        public bool Displayed { get; set; }
    }
}
