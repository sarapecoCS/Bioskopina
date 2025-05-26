using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Bioskopina.Model
{
    public class Email
    {
        public string Subject { get; set; }

        public string Content { get; set; }

        public string Sender { get; set; }

        public string Recipient { get; set; }       
    }
}
