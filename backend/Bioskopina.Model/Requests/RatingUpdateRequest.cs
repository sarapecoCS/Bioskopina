using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Bioskopina.Model.Requests
{
    public class RatingUpdateRequest
    {
        public int? RatingValue { get; set; }

        public string ReviewText { get; set; } = null!;
    }
}
