using AutoMapper;
using Bioskopina.Model;
using Bioskopina.Model.Requests;
using Bioskopina.Model.SearchObjects;
using Bioskopina.Services.Database;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Bioskopina.Services
{
    public class GenreService : BaseCRUDService<Model.Genre, Database.Genre, GenreSearchObject, GenreInsertRequest, GenreUpdateRequest>, IGenreService
    {

        public GenreService(BioskopinaContext context, IMapper mapper) : base(context, mapper)
        {
        }

        public override IQueryable<Database.Genre> AddFilter(IQueryable<Database.Genre> query, GenreSearchObject? search = null)
        {
            if(search?.SortAlphabetically == true)
            {
                query = query.OrderBy(x => x.Name);
            }
            
            return base.AddFilter(query, search);
        }

        public async Task<List<Model.PopularGenresData>> GetMostPopularGenres()
        {
             var preferredGenres = await _context.Genres.OrderByDescending(genre => genre.PreferredGenres.Count()).Take(5).ToListAsync();

             List<PopularGenresData> popularGenres = new List<PopularGenresData>();

             foreach(var genre in preferredGenres)
             {
                 popularGenres.Add(new PopularGenresData
                 {
                     GenreName = genre.Name,
                     UsersWhoLikeIt = _context.PreferredGenres.Where(x => x.GenreId == genre.Id).Count(),
                 });
             }

             return popularGenres;
        }
   


    }
}
