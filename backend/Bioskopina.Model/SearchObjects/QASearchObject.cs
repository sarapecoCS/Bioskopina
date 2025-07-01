using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Bioskopina.Model.SearchObjects
{
    public class QASearchObject : BaseSearchObject
    {
        public int? UserId { get; set; }

        public string? FTS { get; set; }

        public bool? UserIncluded { get; set; }

        public bool? CategoryIncluded { get; set; }

        public bool? NewestFirst { get; set; }

        public bool? UnansweredOnly { get; set; }

        public bool? HiddenOnly { get; set; }

        public bool? DisplayedOnly { get; set; }

        public bool? UnansweredFirst { get; set; }

        public bool? AskedByOthers { get; set; }

        public bool? AnsweredOnly { get; set; }

    }
}
