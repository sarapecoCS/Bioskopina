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

namespace Bioskopina.Services
{
    public class RatingService : BaseCRUDService<Model.Rating, Database.Rating, RatingSearchObject, RatingInsertRequest, RatingUpdateRequest>, IRatingService
    {
        protected BioskopinaContext _context;
        public RatingService(BioskopinaContext context, IMapper mapper) : base(context, mapper)
        {
            _context = context;
        }

        public override Task AfterInsert(Database.Rating entity, RatingInsertRequest insert)
        {
            UpdateMovieScore(entity.MovieId);
            return base.AfterInsert(entity, insert);
        }

        public override Task AfterUpdate(Database.Rating entity, RatingUpdateRequest update)
        {
            UpdateMovieScore(entity.MovieId);
            return base.AfterUpdate(entity, update);
        }

        public override Task AfterDelete(Database.Rating entity)
        {
            UpdateMovieScore(entity.MovieId);
            return base.AfterDelete(entity);
        }



        public void UpdateMovieScore(int movieId)
        {
            var movie = _context.Bioskopina.Where(m => m.Id == movieId).FirstOrDefault();

            if (movie != null)
            {
                var averageScore = CalculateMovieScore(movie.Id);

               
                movie.Score = (double)averageScore;

                _context.SaveChanges();
            }
        }


        public decimal CalculateMovieScore(int movieId)
        {
            var ratings = _context.Ratings.Where(r => r.MovieId == movieId).ToList();

            if (ratings.Any())
            {
                
                double average = ratings.Average(r => Convert.ToDouble(r.RatingValue ?? 0)); 

               
                return (decimal)average; 
            }

            return 0.0m; 
        }





        public override IQueryable<Rating> AddFilter(IQueryable<Rating> query, RatingSearchObject? search = null)
        {
            if (search?.Rating != null)
            {
                query = query.Where(x => x.RatingValue == search.Rating);
            }
              
            if (!string.IsNullOrWhiteSpace(search?.FTS))
            {
                query = query.Where(x => x.ReviewText.Contains(search.FTS));
            }

            if (search?.UserId != null)
            {
                query = query.Where(x => x.UserId == search.UserId);
            }

            if (search?.MovieId != null)
            {
                query = query.Where(x => x.MovieId == search.MovieId);
            }

            if (search?.NewestFirst == true)
            {
                query = query.OrderByDescending(x => x.DateAdded);
            }

            if (search?.TakeItems != null)
            {
                query = query.Take((int)search.TakeItems);
            }

            return base.AddFilter(query, search);
        }
    }
}
