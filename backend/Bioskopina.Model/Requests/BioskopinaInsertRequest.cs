using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Bioskopina.Model.Requests
{
    public class BioskopinaInsertRequest
    {
        public string TitleEn { get; set; } = null!;

        public string TitleJp { get; set; } = null!;

        public string Synopsis { get; set; } = null!;

        public string? ImageUrl { get; set; }

        public string? TrailerUrl { get; set; }

       
    }
}
