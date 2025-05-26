using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Bioskopina.Model.Requests
{
    public class ChangePasswordRequest
    {
        public int UserId { get; set; }
     
        public string OldPassword { get; set; } = null!;

        [Compare("PasswordConfirmation", ErrorMessage = "Passwords do not match")]
        public string NewPassword { get; set; } = null!;

        [Compare("NewPassword", ErrorMessage = "Passwords do not match")]
        public string PasswordConfirmation { get; set; } = null!;
    }
}
