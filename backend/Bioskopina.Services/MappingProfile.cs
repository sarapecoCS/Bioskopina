using AutoMapper;
using Bioskopina.Model.Requests;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Bioskopina.Services
{
    public class MappingProfile : Profile
    {
        public MappingProfile()
        {
            CreateMap<Database.Bioskopina, Model.Bioskopina>();
            CreateMap<BioskopinaInsertRequest, Database.Bioskopina>();
            CreateMap<BioskopinaUpdateRequest, Database.Bioskopina>();

            CreateMap<Database.User, Model.User>();
            CreateMap<UserInsertRequest, Database.User>();
            CreateMap<UserUpdateRequest, Database.User>();

            CreateMap<Database.Role, Model.Role>();
            CreateMap<RoleInsertRequest, Database.Role>();
            CreateMap<RoleUpdateRequest, Database.Role>();

            CreateMap<Database.UserRole, Model.UserRole>();
            CreateMap<UserRoleInsertRequest, Database.UserRole>();
            CreateMap<UserRoleUpdateRequest, Database.UserRole>();

            CreateMap<Database.List, Model.List>();
            CreateMap<ListInsertRequest, Database.List>();
            CreateMap<ListUpdateRequest, Database.List>();

            CreateMap<Database.Genre, Model.Genre>();
            CreateMap<GenreInsertRequest, Database.Genre>();
            CreateMap<GenreUpdateRequest, Database.Genre>();

            CreateMap<Database.Watchlist, Model.Watchlist>();
            CreateMap<WatchlistInsertRequest, Database.Watchlist>();
            CreateMap<WatchlistUpdateRequest, Database.Watchlist>();

            CreateMap<Database.BioskopinaList, Model.BioskopinaList>();
            CreateMap<BioskopinaListInsertRequest, Database.BioskopinaList>();
            // CreateMap<BioskopinaListUpdateRequest, Database.BioskopinaList>();

            CreateMap<Database.Post, Model.Post>();
            CreateMap<PostInsertRequest, Database.Post>();
            CreateMap<PostUpdateRequest, Database.Post>();

            CreateMap<Database.Comment, Model.Comment>();
            CreateMap<CommentInsertRequest, Database.Comment>();
            CreateMap<CommentUpdateRequest, Database.Comment>();

            CreateMap<Database.GenreBioskopina, Model.GenreBioskopina>();
            CreateMap<GenreBioskopinaInsertRequest, Database.GenreBioskopina>();
            CreateMap<GenreBioskopinaUpdateRequest, Database.GenreBioskopina>();

            CreateMap<Database.PreferredGenre, Model.PreferredGenre>();
            CreateMap<PreferredGenreInsertRequest, Database.PreferredGenre>();
            // CreateMap<PreferredGenreUpdateRequest, Database.PreferredGenre>();

            CreateMap<Database.QAcategory, Model.QAcategory>();
            CreateMap<QAcategoryInsertRequest, Database.QAcategory>();
            CreateMap<QAcategoryUpdateRequest, Database.QAcategory>();

            CreateMap<Database.QA, Model.QA>();
            CreateMap<QAInsertRequest, Database.QA>();
            CreateMap<QAUpdateRequest, Database.QA>();

            CreateMap<Database.Rating, Model.Rating>();
            CreateMap<RatingInsertRequest, Database.Rating>();
            CreateMap<RatingUpdateRequest, Database.Rating>();

            CreateMap<Database.Donation, Model.Donation>();
            CreateMap<DonationInsertRequest, Database.Donation>();
            CreateMap<DonationUpdateRequest, Database.Donation>();

            CreateMap<Database.UserProfilePicture, Model.UserProfilePicture>();
            CreateMap<UserProfilePictureInsertRequest, Database.UserProfilePicture>();
            CreateMap<UserProfilePictureUpdateRequest, Database.UserProfilePicture>();

            // Updated BioskopinaWatchlist mapping with navigation property resolution
            CreateMap<Database.BioskopinaWatchlist, Model.BWatchlist>()
                .ForMember(dest => dest.Bioskopina, opt => opt.MapFrom(src => src.Movie))
                .ForMember(dest => dest.Watchlist, opt => opt.MapFrom(src => src.Watchlist))
                .ReverseMap()
                .ForMember(dest => dest.Movie, opt => opt.MapFrom(src => src.Bioskopina))
                .ForMember(dest => dest.Watchlist, opt => opt.MapFrom(src => src.Watchlist));

            CreateMap<BioskopinaWatchlistInsertRequest, Database.BioskopinaWatchlist>();
            CreateMap<BioskopinaWatchlistUpdateRequest, Database.BioskopinaWatchlist>();

            CreateMap<Database.UserPostAction, Model.UserPostAction>();
            CreateMap<UserPostActionInsertRequest, Database.UserPostAction>();
            CreateMap<UserPostActionUpdateRequest, Database.UserPostAction>();

            CreateMap<Database.UserCommentAction, Model.UserCommentAction>();
            CreateMap<UserCommentActionInsertRequest, Database.UserCommentAction>();
            CreateMap<UserCommentActionUpdateRequest, Database.UserCommentAction>();

            CreateMap<Database.Recommender, Model.Recommender>();
            CreateMap<RecommenderInsertRequest, Database.Recommender>();
            CreateMap<RecommenderUpdateRequest, Database.Recommender>();
        }
    }
}