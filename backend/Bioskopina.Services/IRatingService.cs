using Bioskopina.Model.Requests;
using Bioskopina.Model.SearchObjects;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Bioskopina.Services
{
    public interface IRatingService : ICRUDService<Model.Rating, RatingSearchObject, RatingInsertRequest, RatingUpdateRequest>
    {
        void UpdateMovieScore(int movieId);
        decimal CalculateMovieScore(int movieId);
    }
}
