using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Bioskopina.Model.Requests
{
    public class BioskopinaUpdateRequest
    {
        public string TitleEn { get; set; } = null!;

        public string TitleYugo { get; set; } = null!;

        public string Synopsis { get; set; } = null!;

        public string? ImageUrl { get; set; }
       

        public string? TrailerUrl { get; set; }
     

        public string? Director { get; set; }

        public int? YearRelease { get; set; }

        public int? Runtime { get; set; }

        public string? Cast { get; set; }
        public string? IMDbRatings { get; set; }
        public string? Awards { get; set; }

        public double? Score { get; set; }


    }
}
