using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Bioskopina.Model.SearchObjects
{
    public class PostSearchObject : BaseSearchObject
    {
        public int? Id { get; set; }

        public string? FTS { get; set; }

     

        public int? UserId { get; set; }

        public bool? NewestFirst { get; set; }

        public bool? CommentsIncluded { get; set; }
    }
}
