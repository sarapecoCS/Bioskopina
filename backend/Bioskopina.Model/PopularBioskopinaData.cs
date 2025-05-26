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

        public string BioskopinaTitleYugo { get; set; }

        public decimal Score { get; set; }
        public string imageUrl { get; set; }

        public string Director { get; set; }


        public int NumberOfRatings { get; set; }

    }
}
