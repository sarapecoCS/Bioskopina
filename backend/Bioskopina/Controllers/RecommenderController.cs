using Bioskopina.Model;
using Bioskopina.Services;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;

namespace Bioskopina.Controllers
{
    public class RecommenderController
    {
        private readonly IRecommenderService _recommenderService;


        public RecommenderController(IRecommenderService service)
        {
            _recommenderService = service;
        }

        [Authorize]
        [HttpGet("Recommender/{movieId}")]
        public virtual async Task<Model.Recommender?> Get(int movieId, CancellationToken cancellationToken = default)
        {
            return await _recommenderService.GetById(movieId, cancellationToken);
        }

        [Authorize]
        [HttpPost("TrainModelAsync")]
        public virtual async Task<PagedResult<Model.Recommender>> TrainModel(CancellationToken cancellationToken = default)
        {
            return await _recommenderService.TrainMovieModelAsync(cancellationToken);
        }

        [Authorize]
        [HttpDelete("ClearRecommendations")]
        public virtual async Task ClearRecommendations(CancellationToken cancellationToken = default)
        {
            await _recommenderService.DeleteAllRecommendations();
        }

    }
}
