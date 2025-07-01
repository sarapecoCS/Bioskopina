using System;
using System.Collections.Generic;

namespace Bioskopina.Services.Database;

public partial class BioskopinaWatchlist
{
    public int Id { get; set; }

    public int MovieId { get; set; }

    public int WatchlistId { get; set; }



    public virtual Bioskopina Movie { get; set; } = null!;

    public virtual Watchlist Watchlist { get; set; } = null!;
}
