using Bioskopina.Model;

namespace Bioskopina.Model
{
    public class Bioskopina
    {
        public int Id { get; set; }

   
        public string? TitleEn { get; set; }
        public string? TitleYugo { get; set; }
        public string? Synopsis { get; set; }

        public string? TrailerUrl { get; set; }
        public string? ImageUrl { get; set; }

        public string? Director { get; set; }

        public int? YearRelease { get; set; }

        public TimeSpan? Runtime { get; set; }

        public string? Cast { get; set; }
        public string? IMDbRatings { get; set; }
        public string? Awards { get; set; }

        public decimal? Score { get; set; }

        public virtual ICollection<GenreBioskopina> GenreMovies { get; set; } = new List<GenreBioskopina>();
    }
}
