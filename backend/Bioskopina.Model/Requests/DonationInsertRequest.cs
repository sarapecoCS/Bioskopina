using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Bioskopina.Model.Requests
{
    public class DonationInsertRequest
    {
        public int UserId { get; set; }

        public decimal Amount { get; set; }

        public DateTime DateDonated { get; set; }

        public string PaymentIntentId { get; set; } = null!;
    }
}
