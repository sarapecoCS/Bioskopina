using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Bioskopina.Model.SearchObjects
{
    public class BioskopinaListSearchObject : BaseSearchObject
    {
        public int? Id { get; set; }

        public int? MovieId { get; set; }

        public int? ListId { get; set; }

        public bool? IncludeMovie { get; set; }

        public bool? GetRandom { get; set; }
    }
}
