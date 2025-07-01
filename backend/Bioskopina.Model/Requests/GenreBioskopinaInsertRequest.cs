using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Bioskopina.Model.Requests
{
    public class GenreBioskopinaInsertRequest
    {
        public int GenreId { get; set; }

        public int MovieId { get; set; }
    }
}
