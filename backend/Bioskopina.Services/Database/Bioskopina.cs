using System;
using System.Collections.Generic;

namespace Bioskopina.Services.Database;

public partial class Bioskopina
{
    public int Id { get; set; }

    public string TitleEn { get; set; } = null!;

    public string TitleYugo { get; set; } = null!;

    public string Synopsis { get; set; } = null!;

    public string? TrailerUrl { get; set; }

    public string? ImageUrl { get; set; }

    public string Director { get; set; } = null!;

    public int YearRelease { get; set; }

    public int Runtime { get; set; }  
    public string Cast { get; set; } = string.Empty;   
    public string IMDbRatings { get; set; } = string.Empty;
    public string Awards { get; set; }


    public virtual ICollection<BioskopinaList> BioskopinaLists { get; set; } = new List<BioskopinaList>();

    public virtual ICollection<BioskopinaWatchlist> BioskopinaWatchlists { get; set; } = new List<BioskopinaWatchlist>();

    public virtual ICollection<GenreBiskopina> GenreMovies{ get; set; } = new List<GenreBiskopina>();

    public virtual ICollection<Rating> Ratings { get; set; } = new List<Rating>();

    public virtual ICollection<Recommender> Recommenders { get; set; } = new List<Recommender>();
    public double Score { get; set; }
}
