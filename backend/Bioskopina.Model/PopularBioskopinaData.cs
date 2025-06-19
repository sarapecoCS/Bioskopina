using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Bioskopina.Model
{
    public class PopularBioskopinaData
    {
        public string BioskopinaTitleEN { get; set; }
    

        public decimal Score { get; set; }
        public string imageUrl { get; set; }

        public string Director { get; set; }

        public List<string> Genres { get; set; } = new List<string>();
        public int NumberOfRatings { get; set; }

    }
}
