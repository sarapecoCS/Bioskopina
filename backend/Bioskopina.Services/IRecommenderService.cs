using Bioskopina.Model;
using Bioskopina.Model.Requests;
using Bioskopina.Model.SearchObjects;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Bioskopina.Services
{
    public interface IRecommenderService : ICRUDService<Model.Recommender, RecommenderSearchObject, RecommenderInsertRequest, RecommenderUpdateRequest>
    {
        Task<Model.Recommender?> GetById(int movieid, CancellationToken cancellationToken = default);
        Task<PagedResult<Model.Recommender>> TrainMovieModelAsync(CancellationToken cancellationToken = default);
        Task DeleteAllRecommendations(CancellationToken cancellationToken = default);
        List<Model.Bioskopina> Recommend(int movieId);
    }
}
