using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Bioskopina.Model
{
    public class Watchlist
    {
        public int Id { get; set; }

        public int UserId { get; set; }

        public DateTime DateAdded { get; set; }

        public virtual ICollection<BWatchlist> MovieWatchlists { get; set; } = new List<BWatchlist>();

    }
}
