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
    public class QAcategoryService : BaseCRUDService<Model.QAcategory, Database.QAcategory, QAcategorySearchObject, QAcategoryInsertRequest, QAcategoryUpdateRequest>, IQAcategoryService
    {
        public QAcategoryService(BioskopinaContext context, IMapper mapper) : base(context, mapper)
        {
        }

        public override IQueryable<QAcategory> AddFilter(IQueryable<QAcategory> query, QAcategorySearchObject? search = null)
        {
            if (!string.IsNullOrWhiteSpace(search?.Name))
            {
                query = query.Where(x => x.Name.StartsWith(search.Name));
            }

            return base.AddFilter(query, search);
        }
    }
}
