using System;
using System.Collections.Generic;

namespace Bioskopina.Services.Database;

public partial class Watchlist
{
    public int Id { get; set; }

    public int UserId { get; set; }

    public DateTime DateAdded { get; set; }

    public virtual ICollection<BioskopinaWatchlist> BioWatchlists { get; set; } = new List<BioskopinaWatchlist>();

    public virtual User User { get; set; } = null!;
}
