using System;
using System.Collections.Generic;

namespace Bioskopina.Services.Database;

public partial class List
{
    public int Id { get; set; }

    public int UserId { get; set; }

    public string Name { get; set; } = null!;

    public DateTime DateCreated { get; set; }

    public virtual ICollection<BioskopinaList> BioskopinaLists { get; set; } = new List<BioskopinaList>();

    public virtual User User { get; set; } = null!;
}
