using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Bioskopina.Model
{
    public class Donation
    {
        public int Id { get; set; }

        public int UserId { get; set; }

        public decimal Amount { get; set; }

        public DateTime DateDonated { get; set; }

        public string TransactionId { get; set; } = null!;

        public virtual User User { get; set; } = null!;
    }
}
