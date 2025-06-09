using System;
using System.Collections.Generic;

namespace Bioskopina.Services.Database;

public partial class Genre
{
    public int Id { get; set; }

    public string Name { get; set; } = null!;

    public virtual ICollection<GenreBioskopina> GenreMovies { get; set; } = new List<GenreBioskopina>();

    public virtual ICollection<PreferredGenre> PreferredGenres { get; set; } = new List<PreferredGenre>();
}
