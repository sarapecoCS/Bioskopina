using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Bioskopina.Model.Requests
{
    public class BioskopinaWatchlistUpdateRequest
    {
        public string WatchStatus { get; set; } = null!;

        public int Progress { get; set; }

        public DateTime? DateStarted { get; set; }

        public DateTime? DateFinished { get; set; }
    }
}
