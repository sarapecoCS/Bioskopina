using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Bioskopina.Model.Requests
{
    public class BioskopinaWatchlistInsertRequest
    {
        public int MovieId { get; set; }

        public int WatchlistId { get; set; }

        public string WatchStatus { get; set; } = null!;

        public int Progress { get; set; }

        public DateTime? DateStarted { get; set; }

        public DateTime? DateFinished { get; set; }
    }
}
