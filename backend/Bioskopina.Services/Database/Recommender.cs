using System;
using System.Collections.Generic;

namespace Bioskopina.Services.Database;

public partial class Recommender
{
    public int Id { get; set; }

    public int MovieId { get; set; }

    public int CoMovieId1 { get; set; }

    public int CoMovieId2 { get; set; }

    public int CoMovieId3 { get; set; }

    public virtual Bioskopina Movie { get; set; } = null!;
}
