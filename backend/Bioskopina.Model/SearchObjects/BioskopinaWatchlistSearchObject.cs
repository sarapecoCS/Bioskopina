using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Bioskopina.Model.SearchObjects
{
    public class BioskopinaWatchlistSearchObject : BaseSearchObject
    {
        public string? WatchStatus { get; set; }

        public int? MovieId { get; set; }

        public int? WatchlistId { get; set; }

        public bool? MovieIncluded { get; set; }

        public bool? GenresIncluded { get; set; }

        public bool? NewestFirst { get; set; }
    }
}
