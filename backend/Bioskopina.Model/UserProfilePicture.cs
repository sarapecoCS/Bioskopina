using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Bioskopina.Model
{
    public class UserProfilePicture
    {
        public int Id { get; set; }

        public byte[] ProfilePicture { get; set; } = null!;

    }
}
