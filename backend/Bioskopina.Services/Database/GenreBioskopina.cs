using System;
using System.Collections.Generic;

namespace Bioskopina.Services.Database;

public partial class GenreBioskopina
{
    public int Id { get; set; }

    public int GenreId { get; set; }

    public int MovieId { get; set; }

    public virtual Bioskopina Movies { get; set; } = null!;

    public virtual Genre Genre { get; set; } = null!;
}
