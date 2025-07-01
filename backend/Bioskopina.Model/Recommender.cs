using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Bioskopina.Model
{
    public class Recommender
    {
        public int Id { get; set; }

        public int MovieId { get; set; }

        public int CoMovieId1 { get; set; }

        public int CoMovieId2 { get; set; }

        public int CoMovieId3 { get; set; }

    }
}
