using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Bioskopina.Model.SearchObjects
{
    public class DonationSearchObject : BaseSearchObject
    {
        public int? UserId { get; set; }

        public bool? NewestFirst { get; set; }

        public bool? LargestFirst { get; set; }

        public bool? SmallestFirst { get; set; }

        public bool? OldestFirst { get; set; }

        public bool? UserIncluded { get; set; }
    }
}
