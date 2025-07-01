using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Bioskopina.Model.SearchObjects
{
    public class ListSearchObject : BaseSearchObject
    {
        public int? UserId { get; set; }

        public string? Name { get; set; }

        public bool? NewestFirst { get; set; }
    }
}
