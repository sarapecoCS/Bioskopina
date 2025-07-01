using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Bioskopina.Model.SearchObjects
{
    public class UserRoleSearchObject : BaseSearchObject
    {
        public int? UserId { get; set; }

        public bool? RoleIncluded { get; set; }
    }
}
