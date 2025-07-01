using Bioskopina.Model;
using Bioskopina.Model.Requests;
using Bioskopina.Model.SearchObjects;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace Bioskopina.Services
{
    public interface IBioskopinaService
      : ICRUDService<Model.Bioskopina, BioskopinaSearchObject, BioskopinaInsertRequest, BioskopinaUpdateRequest>
    {
        Task<List<PopularBioskopinaData>> GetMostPopularMovie();
    }

}
