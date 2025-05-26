using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Bioskopina.Model
{
    public class List
    {
        public int Id { get; set; }

        public int UserId { get; set; }

        public string Name { get; set; } = null!;

        public DateTime DateCreated { get; set; }

        //public virtual ICollection<AnimeList> AnimeLists { get; set; } = new List<AnimeList>();

    }
}
