using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Bioskopina.Model.Requests
{
    public class UserInsertRequest
    {
        public string FirstName { get; set; } = null!;

        public string LastName { get; set; } = null!;

        public string Username { get; set; } = null!;
        [DefaultValue(1)]
        public int ProfilePictureId { get; set; }

        [Compare("PasswordConfirmation", ErrorMessage = "Passwords do not match")]
        public string Password { get; set; } = null!;
        [Compare("Password", ErrorMessage = "Passwords do not match")]
        public string PasswordConfirmation { get; set; } = null!;
        public string? Email { get; set; }
        public DateTime DateJoined { get; set; }
    }
}
