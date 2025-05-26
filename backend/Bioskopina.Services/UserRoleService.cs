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
    public class UserRoleService : BaseCRUDService<Model.UserRole, Database.UserRole, UserRoleSearchObject, UserRoleInsertRequest, UserRoleUpdateRequest>, IUserRoleService
    {
        protected BioskopinaContext _context;
        public UserRoleService(BioskopinaContext context, IMapper mapper) : base(context, mapper)
        {
            _context = context;
        }

        public override IQueryable<Database.UserRole> AddFilter(IQueryable<Database.UserRole> query, UserRoleSearchObject? search = null)
        {
            if(search?.UserId != null)
            {
                query = query.Where(x => x.UserId == search.UserId);
            }
            
            return base.AddFilter(query, search);
        }

        public override IQueryable<Database.UserRole> AddInclude(IQueryable<Database.UserRole> query, UserRoleSearchObject? search = null)
        {
            if(search.RoleIncluded == true)
            {
                query = query.Include(role => role.Role);
            }

            return base.AddInclude(query, search);
        }
    }
}
