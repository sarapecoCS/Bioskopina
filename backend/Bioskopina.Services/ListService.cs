using AutoMapper;
using Bioskopina.Model.Requests;
using Bioskopina.Model.SearchObjects;
using Bioskopina.Services.Database;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Bioskopina.Services
{
    public class ListService : BaseCRUDService<Model.List, Database.List, ListSearchObject, ListInsertRequest, ListUpdateRequest>, IListService
    {
        public ListService(BioskopinaContext context, IMapper mapper) : base(context, mapper)
        {
        }

        public override IQueryable<List> AddFilter(IQueryable<List> query, ListSearchObject? search = null)
        {
            if(search?.Name != null)
            {
                query = query.Where(list => list.Name.Contains(search.Name));
            }
            if (search?.NewestFirst != null)
            {
                query = query.OrderByDescending(list => list.Id);
            }
            if (search?.UserId != null)
            {
                query = query.Where(list => list.UserId == search.UserId);
            }

            return base.AddFilter(query, search);
        }
    }
}
