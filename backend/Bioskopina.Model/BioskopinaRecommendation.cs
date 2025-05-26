using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Microsoft.ML.Data;

namespace Bioskopina.Model
{
    public class BioskopinaRecommendation
    {
        [KeyType(count: 27)]
        public uint MovieId { get; set; }

        [KeyType(count: 27)]
        public uint CoMovieId { get; set; }

        public float Label { get; set; }
    }
}
