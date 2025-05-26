using System;
using System.Collections.Generic;

namespace Bioskopina.Services.Database;

public partial class UserProfilePicture
{
    public int Id { get; set; }

    public byte[] ProfilePicture { get; set; } = null!;

    public virtual ICollection<User> Users { get; set; } = new List<User>();
}
