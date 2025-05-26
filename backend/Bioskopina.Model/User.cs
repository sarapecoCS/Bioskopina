using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Bioskopina.Model
{
    public class User
    {
        public int Id { get; set; }

        public string FirstName { get; set; } = null!;

        public string LastName { get; set; } = null!;

        public string Username { get; set; } = null!;

        public string PasswordHash { get; set; } = null!;

        public string PasswordSalt { get; set; } = null!;

        public string? Email { get; set; }

        public int ProfilePictureId { get; set; }

        public virtual UserProfilePicture ProfilePicture { get; set; } = null!;

        public DateTime DateJoined { get; set; }

        public virtual ICollection<UserRole> UserRoles { get; set; } = new List<UserRole>();

        public virtual ICollection<Watchlist> Watchlists { get; set; } = new List<Watchlist>();
        public virtual ICollection<UserCommentAction> UserCommentActions { get; set; } = new List<UserCommentAction>();


    }
}
