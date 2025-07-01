using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Bioskopina.Model.SearchObjects
{
    public class UserSearchObject : BaseSearchObject
    {
        public int? Id { get; set; }

        public string? FirstName { get; set; }

        public string? LastName { get; set; }

        public string? Username { get; set; }

        public string? FTS { get; set; } //FTS - Full Text Search

        public bool? RolesIncluded { get; set; }

        public bool? WatchlistsIncluded { get; set; }

        public bool? ProfilePictureIncluded { get; set; }

        public string? Email { get; set; }
    }
}
