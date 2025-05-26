using Bioskopina.Model;
using Bioskopina.Model.Requests;
using Bioskopina.Model.SearchObjects;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace Bioskopina.Services
{
    public interface IBioskopinaListService
        : ICRUDService<BioskopinaList, BioskopinaListSearchObject, BioskopinaListInsertRequest, BioskopinaListUpdateRequest>
    {
        Task<bool> DeleteByMovieId(int movieId);
        Task<bool> UpdateListsForMovies(int movieId, List<BioskopinaListInsertRequest> newLists);
    }
}
