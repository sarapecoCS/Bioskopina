using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Bioskopina.Model.SearchObjects
{
    public class BioskopinaSearchObject : BaseSearchObject
    {
        public int? Id { get; set; }

        public string? Title { get; set; }

        public string? FTS { get; set; } //FTS - Full Text Search

        public bool? GenresIncluded { get; set; }

        public bool? NewestFirst { get; set; }

        public bool? TopFirst { get; set; }

        public List<int>? Ids { get; set; }

        public List<int>? GenreIds { get; set; }

        public bool? GetEmptyList { get; set; }
    }
}
