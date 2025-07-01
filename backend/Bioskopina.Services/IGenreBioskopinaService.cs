using Bioskopina.Model.Requests;
using Bioskopina.Model.SearchObjects;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace Bioskopina.Services
{
    public interface IGenreBioskopinaService : ICRUDService<Model.GenreBioskopina, GenreBioskopinaSearchObject, GenreBioskopinaInsertRequest, GenreBioskopinaUpdateRequest>
    {
        Task<bool> DeleteByMovieId(int movieId);
        Task<bool> UpdateGenresForMovie(int movieId, List<GenreBioskopinaInsertRequest> newGenres);
        Task<List<Model.GenreBioskopina>> GetGenresByMovie(int movieId);


    }
}
