using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Bioskopina.Model
{
    public class BioskopinaList
    {
        public int Id { get; set; }

        public int ListId { get; set; }

        public int MovieId { get; set; }

        public virtual Bioskopina Movie { get; set; } = null!;

        public virtual List List { get; set; } = null!;
    }
}
