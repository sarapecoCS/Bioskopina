using System;
using System.Collections.Generic;

namespace Bioskopina.Services.Database;

public partial class BioskopinaList
{
    public int Id { get; set; }

    public int ListId { get; set; }

    public int MovieId { get; set; }

    public virtual Bioskopina Movie { get; set; } = null!;

    public virtual List List { get; set; } = null!;
}
