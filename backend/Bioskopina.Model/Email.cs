using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Bioskopina.Model
{
    public class Email
    {
       
            public string Subject { get; set; } = string.Empty;
            public string Content { get; set; } = string.Empty;
            public string Sender { get; set; } = string.Empty;
            public string Recipient { get; set; } = string.Empty;
      
    }
}
