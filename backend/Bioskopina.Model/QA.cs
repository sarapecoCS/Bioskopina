using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Bioskopina.Model
{
    public class QA
    {
        public int Id { get; set; }

        public int UserId { get; set; }

        public int CategoryId { get; set; }

        public string Question { get; set; } = null!;

        public string Answer { get; set; } = null!;

        public bool Displayed { get; set; }

        public virtual QAcategory Category { get; set; } = null!;

        public virtual User User { get; set; } = null!;
    }
}
