using AutoMapper;
using Bioskopina.Model.Requests;
using Bioskopina.Model.SearchObjects;
using Bioskopina.Services.Database;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Bioskopina .Services
{
    public class QAService : BaseCRUDService<Model.QA, Database.QA, QASearchObject, QAInsertRequest, QAUpdateRequest>, IQAService
    {
        public QAService(BioskopinaContext context, IMapper mapper) : base(context, mapper)
        {
        }

        public override IQueryable<QA> AddFilter(IQueryable<QA> query, QASearchObject? search = null)
        {

            if (search?.UserId != null && (search?.AskedByOthers == false || search?.AskedByOthers == null))
            {
                query = query.Where(qa => qa.UserId == search.UserId);
            }

            if (!string.IsNullOrWhiteSpace(search?.FTS))
            {
                query = query.Where(qa => qa.Question.Contains(search.FTS) || qa.Answer.Contains(search.FTS));
            }

            if (search?.NewestFirst == true)
            {
                query = query.OrderByDescending(qa => qa.Id);
            }

            if (search?.UnansweredOnly == true)
            {
                query = query.Where(qa => string.IsNullOrWhiteSpace(qa.Answer));
            }

            if (search?.HiddenOnly == true)
            {
                query = query.Where(qa => qa.Displayed == false);
            }

            if (search?.DisplayedOnly == true)
            {
                query = query.Where(qa => qa.Displayed == true);
            }

            if (search?.UnansweredFirst == true)
            {
                query = query.OrderByDescending(qa => string.IsNullOrEmpty(qa.Answer)).ThenByDescending(y => y.Id);
            }

            if (search?.UserId != null && search?.AskedByOthers == true)
            {
                query = query.Where(qa => qa.UserId != search.UserId);
            }

            if (search?.AnsweredOnly == true)
            {
                query = query.Where(qa => qa.Answer != "");
            }

            return base.AddFilter(query, search);
        }

        public override IQueryable<QA> AddInclude(IQueryable<QA> query, QASearchObject? search = null)
        {

            if (search?.UserIncluded == true)
            {
                query = query.Include(x => x.User);
            }

            if (search?.CategoryIncluded == true)
            {
                query = query.Include(x => x.Category);
            }

            return base.AddInclude(query, search);
        }
    }
}
