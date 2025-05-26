using System;
using System.Collections.Generic;

namespace Bioskopina.Services.Database;

public partial class UserPostAction
{
    public int Id { get; set; }

    public int UserId { get; set; }

    public int PostId { get; set; }

    public string Action { get; set; } = null!;

    public virtual Post Post { get; set; } = null!;

    public virtual User User { get; set; } = null!;
}
