using System;
using System.Collections.Generic;

namespace Bioskopina.Services.Database;

public partial class Genre
{
    public int Id { get; set; }

    public string Name { get; set; } = null!;

    public virtual ICollection<GenreBiskopina> GenreMovies { get; set; } = new List<GenreBiskopina>();

    public virtual ICollection<PreferredGenre> PreferredGenres { get; set; } = new List<PreferredGenre>();
}
