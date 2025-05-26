using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Bioskopina.Model.Requests
{
    public class UserRoleUpdateRequest
    {
        public int RoleId { get; set; }

        public bool CanReview { get; set; }

        public bool CanAskQuestions { get; set; }

        public bool CanParticipateInClubs { get; set; }
    }
}
