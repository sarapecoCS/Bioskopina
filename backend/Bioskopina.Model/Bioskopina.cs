using Bioskopina.Model;

namespace Bioskopina.Model
{
    public class Bioskopina
    {
        public int Id { get; set; }

   
        public string? TitleEn { get; set; }
       
        public string? Synopsis { get; set; }

        public string? TrailerUrl { get; set; }
        public string? ImageUrl { get; set; }

        public string? Director { get; set; }

        public int? YearRelease { get; set; }

        public int? Runtime { get; set; }

      
        public double? Score { get; set; }

        public virtual ICollection<GenreBioskopina> GenreMovies { get; set; } = new List<GenreBioskopina>();
    }
}
