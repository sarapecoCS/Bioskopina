using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Bioskopina.Model
{
    public class UserRole
    {
        public int Id { get; set; }

        public int UserId { get; set; }

        public int RoleId { get; set; }

        public bool CanReview { get; set; }

        public bool CanAskQuestions { get; set; }

        public bool? CanParticipateInClubs { get; set; }

        public virtual Role Role { get; set; } = null!;

    }
}
