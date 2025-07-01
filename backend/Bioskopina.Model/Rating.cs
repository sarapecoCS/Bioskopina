using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Bioskopina.Model
{
    public class Rating
    {
        public int Id { get; set; }

        public int UserId { get; set; }

        public int MovieId { get; set; }

        public double? RatingValue { get; set; }  


        public string? ReviewText { get; set; } = null!;

        public DateTime DateAdded { get; set; }
       

        public virtual Bioskopina Bioskopina { get; set; } = null!;

        public virtual User User { get; set; } = null!;
    }
}
