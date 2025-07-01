using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Bioskopina.Model
{
    public class GenreBioskopina
    {
        public int Id { get; set; }

        public int GenreId { get; set; }

        public int MovieId { get; set; }

       // public virtual Bioskopina Bioskopina { get; set; } = null!;

        public virtual Genre Genre { get; set; } = null!;
    }
}
