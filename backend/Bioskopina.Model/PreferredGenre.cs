using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Bioskopina.Model
{
    public class PreferredGenre
    {
        public int Id { get; set; }

        public int GenreId { get; set; }

        public int UserId { get; set; }

        public virtual Genre Genre { get; set; } = null!;

        public virtual User User { get; set; } = null!;
    }
}
