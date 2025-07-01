using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Bioskopina.Model.Requests
{
    public class PreferredGenreInsertRequest
    {
        public int GenreId { get; set; }

        public int UserId { get; set; }
    }
}
