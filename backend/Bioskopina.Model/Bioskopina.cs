using Bioskopina.Model;

namespace Bioskopina.Model
{
    public class Bioskopina
    {
        public int Id { get; set; }

        public string TitleEn { get; set; } = null!;

        public string TitleYugo { get; set; } = null!;

        public string Synopsis { get; set; } = null!;

        public string? TrailerUrl { get; set; }

        public string? ImageUrl { get; set; }

        public string Director { get; set; } = null!;

        public int YearRelease { get; set; }

        public TimeSpan Runtime { get; set; }  
        public string Cast { get; set; } = string.Empty;
        public string IMDbRatings { get; set; } = string.Empty;
        public string Awards { get; set; }
        public decimal Score { get; set; } = 0;


        public virtual ICollection<GenreBioskopina> GenreMovies { get; set; } = new List<GenreBioskopina>();

    }
}