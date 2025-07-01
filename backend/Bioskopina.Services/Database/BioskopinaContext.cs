using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Migrations;
using System;
using System.Linq;
using System.Xml.Linq;

namespace Bioskopina.Services.Database
{
    public partial class BioskopinaContext : DbContext
    {
        public BioskopinaContext()
        {
        }

        public BioskopinaContext(DbContextOptions<BioskopinaContext> options)
            : base(options)
        {
        }

        public virtual DbSet<Bioskopina> Bioskopina { get; set; }
        public virtual DbSet<BioskopinaList> BioskopinaLists { get; set; }
        public virtual DbSet<Watchlist> Watchlists { get; set; }
        public virtual DbSet<BioskopinaWatchlist> BioskopinaWatchlists { get; set; }
        public virtual DbSet<Comment> Comments { get; set; }
        public virtual DbSet<Donation> Donations { get; set; }
        public virtual DbSet<Genre> Genres { get; set; }
        public virtual DbSet<GenreBioskopina> GenreBioskopina { get; set; }
        public virtual DbSet<List> Lists { get; set; }
        public virtual DbSet<Post> Posts { get; set; }
        public virtual DbSet<PreferredGenre> PreferredGenres { get; set; }
        public virtual DbSet<QA> QAs { get; set; }
        public virtual DbSet<QAcategory> QAcategories { get; set; }
        public virtual DbSet<Rating> Ratings { get; set; }
        public virtual DbSet<Recommender> Recommenders { get; set; }
        public virtual DbSet<Role> Roles { get; set; }
    
        public virtual DbSet<User> Users { get; set; }
        public virtual DbSet<UserCommentAction> UserCommentActions { get; set; }
        public virtual DbSet<UserPostAction> UserPostActions { get; set; }
    
        public virtual DbSet<UserRole> UserRoles { get; set; }
        public virtual DbSet<UserProfilePicture> UserProfilePictures { get; set; }

        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            SeedData(modelBuilder);
            foreach (var relationship in modelBuilder.Model.GetEntityTypes().SelectMany(e => e.GetForeignKeys()))
            {
                relationship.DeleteBehavior = DeleteBehavior.Restrict; 
            }

            base.OnModelCreating(modelBuilder);

            modelBuilder.Entity<Bioskopina>(entity =>
            {
                entity.ToTable("Bioskopina");


                entity.Property(e => e.Id).HasColumnName("ID");
                entity.Property(e => e.YearRelease).HasColumnType("int");

                entity.Property(e => e.ImageUrl).HasColumnName("ImageURL");
                entity.Property(e => e.Score).HasColumnType("decimal(4, 2)");

                entity.Property(e => e.TitleEn)
                    .HasMaxLength(200)
                    .HasColumnName("TitleEN");
            
                entity.Property(e => e.TrailerUrl).HasColumnName("TrailerURL");
               
                entity.Property(e => e.Runtime).HasColumnName("Runtime");
            });
            modelBuilder.Entity<Role>(entity =>
            {
                entity.ToTable("Role");

                entity.Property(e => e.Id).HasColumnName("ID");
                entity.Property(e => e.Name).HasMaxLength(50);
            });

            modelBuilder.Entity<User>(entity =>
            {
                entity.ToTable("User");

                entity.Property(e => e.Id).HasColumnName("ID");
                entity.Property(e => e.DateJoined).HasColumnType("datetime");
                entity.Property(e => e.Email).HasMaxLength(100);
                entity.Property(e => e.FirstName).HasMaxLength(50);
                entity.Property(e => e.LastName).HasMaxLength(50);
                entity.Property(e => e.PasswordHash).HasMaxLength(50);
                entity.Property(e => e.PasswordSalt).HasMaxLength(50);
                entity.Property(e => e.ProfilePictureId).HasColumnName("ProfilePictureID");

                entity.Property(e => e.Username)
                    .HasMaxLength(50)
                    .HasDefaultValueSql("('')")
                    .UseCollation("Latin1_General_CS_AS");

                entity.HasOne(d => d.ProfilePicture).WithMany(p => p.Users)
                    .HasForeignKey(d => d.ProfilePictureId)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("FK_User_UserProfilePicture");
            });

            modelBuilder.Entity<UserProfilePicture>(entity =>
            {
                entity.ToTable("UserProfilePicture");

                entity.Property(e => e.Id).HasColumnName("ID");
            });

            modelBuilder.Entity<UserRole>(entity =>
            {
                entity.ToTable("User_Role");

                entity.Property(e => e.Id).HasColumnName("ID");
                entity.Property(e => e.RoleId).HasColumnName("RoleID");
                entity.Property(e => e.UserId).HasColumnName("UserID");

                entity.HasOne(d => d.Role).WithMany(p => p.UserRoles)
                    .HasForeignKey(d => d.RoleId)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("FK_User_Role_Role");

                entity.HasOne(d => d.User).WithMany(p => p.UserRoles)
                    .HasForeignKey(d => d.UserId)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("FK_User_Role_User");
            });



       
            modelBuilder.Entity<Watchlist>(entity =>
            {
                entity.ToTable("Watchlist");

                entity.Property(e => e.Id).HasColumnName("ID");
                entity.Property(e => e.DateAdded).HasColumnType("datetime");
                entity.Property(e => e.UserId).HasColumnName("UserID");

                entity.HasOne(d => d.User).WithMany(p => p.Watchlists)
                    .HasForeignKey(d => d.UserId)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("FK_Watchlist_User");
            });


            modelBuilder.Entity<BioskopinaWatchlist>(entity =>
            {
                entity.ToTable("Bioskopina_Watchlist");

                entity.Property(e => e.Id).HasColumnName("ID");
                entity.Property(e => e.MovieId).HasColumnName("MovieID");
           
                entity.Property(e => e.WatchlistId).HasColumnName("WatchlistID");

                entity.HasOne(d => d.Movie)
                    .WithMany(p => p.BioskopinaWatchlists)
                    .HasForeignKey(d => d.MovieId)
                    .OnDelete(DeleteBehavior.Cascade)
                    .HasConstraintName("FK_Bioskopina_Watchlist_Bioskopina");

                entity.HasOne(d => d.Watchlist)
                    .WithMany(p => p.BioWatchlists)
                    .HasForeignKey(d => d.WatchlistId)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("FK_Bioskopina_Watchlist_Watchlist");

         
                entity.Navigation(e => e.Movie).AutoInclude();
            });


            modelBuilder.Entity<Comment>(entity =>
            {
                entity.ToTable("Comment");

                entity.Property(e => e.Id).HasColumnName("ID");
                entity.Property(e => e.DateCommented).HasColumnType("datetime");
                entity.Property(e => e.PostId).HasColumnName("PostID");
                entity.Property(e => e.UserId).HasColumnName("UserID");

                entity.HasOne(d => d.Post).WithMany(p => p.Comments)
                    .HasForeignKey(d => d.PostId)
                    .OnDelete(DeleteBehavior.Restrict)
                    .HasConstraintName("FK_Comment_Post");

                entity.HasOne(d => d.User).WithMany(p => p.Comments)
                    .HasForeignKey(d => d.UserId)
                    .OnDelete(DeleteBehavior.Restrict)
                    .HasConstraintName("FK_Comment_User");
            });

            modelBuilder.Entity<Donation>(entity =>
            {
                entity.ToTable("Donation");

                entity.Property(e => e.Id).HasColumnName("ID");
                entity.Property(e => e.Amount).HasColumnType("decimal(18, 2)");
                entity.Property(e => e.DateDonated).HasColumnType("datetime");
                entity.Property(e => e.TransactionId).HasColumnName("TransactionID");
                entity.Property(e => e.UserId).HasColumnName("UserID");

                entity.HasOne(d => d.User).WithMany(p => p.Donations)
                    .HasForeignKey(d => d.UserId)
                    .HasConstraintName("FK_Donation_User");
            });

            modelBuilder.Entity<Genre>(entity =>
            {
                entity.ToTable("Genre");

                entity.Property(e => e.Id).HasColumnName("ID");
                entity.Property(e => e.Name).HasMaxLength(50);
            });

            modelBuilder.Entity<GenreBioskopina>(entity =>
            {
                entity.ToTable("Genre_Movies");

                entity.Property(e => e.Id).HasColumnName("ID");
                entity.Property(e => e.MovieId).HasColumnName("MovieID");
                entity.Property(e => e.GenreId).HasColumnName("GenreID");

                entity.HasOne(d => d.Movies).WithMany(p => p.GenreMovies)
                    .HasForeignKey(d => d.MovieId)
                    .OnDelete(DeleteBehavior.Cascade)  
                    .HasConstraintName("FK_Genre_Bioskopina_Movies");

                entity.HasOne(d => d.Genre).WithMany(p => p.GenreMovies)
                    .HasForeignKey(d => d.GenreId)
                     .OnDelete(DeleteBehavior.Cascade)
                    .HasConstraintName("FK_Genre_Movie_Genre");
            });


            modelBuilder.Entity<List>(entity =>
            {
                entity.ToTable("List");

                entity.Property(e => e.Id).HasColumnName("ID");
                entity.Property(e => e.DateCreated).HasColumnType("datetime");
                entity.Property(e => e.Name).HasMaxLength(50);
                entity.Property(e => e.UserId).HasColumnName("UserID");

                entity.HasOne(d => d.User).WithMany(p => p.Lists)
                    .HasForeignKey(d => d.UserId)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("FK_List_User");
            });
            modelBuilder.Entity<BioskopinaList>(entity =>
            {
                entity.ToTable("BioskopinaList");

                entity.Property(e => e.Id).HasColumnName("ID");
                entity.Property(e => e.MovieId).HasColumnName("MovieID");
                entity.Property(e => e.ListId).HasColumnName("ListID");

                entity.HasOne(d => d.Movie).WithMany(p => p.BioskopinaLists)
                    .HasForeignKey(d => d.MovieId)
                     .OnDelete(DeleteBehavior.Cascade)
                    .HasConstraintName("FK_Bioskopina_List_Movie");

                entity.HasOne(d => d.List).WithMany(p => p.BioskopinaLists)
                    .HasForeignKey(d => d.ListId)
                    .OnDelete(DeleteBehavior.Cascade)
                    .HasConstraintName("FK_Bioskopina_List_List");
            });

            modelBuilder.Entity<Post>(entity =>
            {
                entity.ToTable("Post");


                entity.Property(e => e.Id).HasColumnName("ID");
                entity.Property(e => e.DatePosted).HasColumnType("datetime");
                entity.Property(e => e.UserId).HasColumnName("UserID");
                entity.Property(e => e.Content).HasColumnType("text");
                entity.Property(e => e.LikesCount).HasColumnType("int");
                entity.Property(e => e.DislikesCount).HasColumnType("int");
                entity.Property(e => e.VideoUrl).HasColumnType("varchar(255)");

                entity.HasOne(d => d.User)
                    .WithMany(p => p.Posts)
                    .HasForeignKey(d => d.UserId)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("FK_Post_User");
            });





            modelBuilder.Entity<PreferredGenre>(entity =>
            {
                entity.ToTable("PreferredGenre");

                entity.Property(e => e.Id).HasColumnName("ID");
                entity.Property(e => e.GenreId).HasColumnName("GenreID");
                entity.Property(e => e.UserId).HasColumnName("UserID");

                entity.HasOne(d => d.Genre).WithMany(p => p.PreferredGenres)
                    .HasForeignKey(d => d.GenreId)
                        .OnDelete(DeleteBehavior.Cascade)
                    .HasConstraintName("FK_PreferredGenre_Genre");
                    

                entity.HasOne(d => d.User).WithMany(p => p.PreferredGenres)
                    .HasForeignKey(d => d.UserId)
                    .HasConstraintName("FK_PreferredGenre_User");
            });

            modelBuilder.Entity<QAcategory>(entity =>
            {
                entity.ToTable("Q&ACategory");

                entity.Property(e => e.Id).HasColumnName("ID");
                entity.Property(e => e.Name).HasMaxLength(50);
            });
            modelBuilder.Entity<QA>(entity =>
            {
                entity.ToTable("Q&A");

                entity.Property(e => e.Id).HasColumnName("ID");
                entity.Property(e => e.CategoryId).HasColumnName("CategoryID");
                entity.Property(e => e.UserId).HasColumnName("UserID");

                entity.HasOne(d => d.Category)
                    .WithMany(p => p.QAs)
                    .HasForeignKey(d => d.CategoryId)
                    .OnDelete(DeleteBehavior.Cascade)  
                    .HasConstraintName("FK_Q&A_Q&ACategory");

                entity.HasOne(d => d.User)
                    .WithMany(p => p.QAs)
                    .HasForeignKey(d => d.UserId)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("FK_Q&A_User");
            });



            modelBuilder.Entity<Rating>(entity =>
            {
                entity.ToTable("Rating");

                entity.Property(e => e.Id).HasColumnName("ID");
                entity.Property(e => e.MovieId).HasColumnName("MovieID");
                entity.Property(e => e.DateAdded).HasColumnType("datetime");
                entity.Property(e => e.UserId).HasColumnName("UserID");

                entity.HasOne(d => d.Movie).WithMany(p => p.Ratings)
                    .HasForeignKey(d => d.MovieId)
                    .OnDelete(DeleteBehavior.Cascade) 
                    .HasConstraintName("FK_Rating_Bioskopina");

                entity.HasOne(d => d.User).WithMany(p => p.Ratings)
                    .HasForeignKey(d => d.UserId)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("FK_Rating_User");
            });


            modelBuilder.Entity<Recommender>(entity =>
            {
                entity.ToTable("Recommender");

                entity.Property(e => e.Id).HasColumnName("ID");
                entity.Property(e => e.MovieId).HasColumnName("MovieID");
                entity.Property(e => e.CoMovieId1).HasColumnName("CoMovieID1");
                entity.Property(e => e.CoMovieId2).HasColumnName("CoMovieID2");
                entity.Property(e => e.CoMovieId3).HasColumnName("CoMovieID3");

                entity.HasOne(d => d.Movie).WithMany(p => p.Recommenders)
                    .HasForeignKey(d => d.MovieId)
                    .OnDelete(DeleteBehavior.Cascade)
                    .HasConstraintName("FK_Recommender_Movies");
            });


            modelBuilder.Entity<UserCommentAction>(entity =>
            {
                entity.ToTable("UserCommentAction");

                entity.Property(e => e.Id).HasColumnName("ID");
                entity.Property(e => e.Action).HasMaxLength(10);
                entity.Property(e => e.CommentId).HasColumnName("CommentID");
                entity.Property(e => e.UserId).HasColumnName("UserID");

                entity.HasOne(d => d.Comment)
                    .WithMany(p => p.UserCommentActions)
                    .HasForeignKey(d => d.CommentId)
                    .OnDelete(DeleteBehavior.Cascade) 
                    .HasConstraintName("FK_UserCommentAction_Comment");

                entity.HasOne(d => d.User)
                    .WithMany(p => p.UserCommentActions)
                    .HasForeignKey(d => d.UserId)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("FK_UserCommentAction_User");
            });





            modelBuilder.Entity<UserPostAction>(entity =>
            {
                entity.ToTable("UserPostAction");

                entity.Property(e => e.Id).HasColumnName("ID");
                entity.Property(e => e.Action).HasMaxLength(10);
                entity.Property(e => e.PostId).HasColumnName("PostID");
                entity.Property(e => e.UserId).HasColumnName("UserID");

                entity.HasOne(d => d.Post)
                    .WithMany(p => p.UserPostActions)  
                    .HasForeignKey(d => d.PostId)
                    .OnDelete(DeleteBehavior.Cascade)
                    .HasConstraintName("FK_UserPostAction_Post");

                entity.HasOne(d => d.User)
                    .WithMany(p => p.UserPostActions)
                    .HasForeignKey(d => d.UserId)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("FK_UserPostAction_User");
            });




            OnModelCreatingPartial(modelBuilder);
        }

        partial void OnModelCreatingPartial(ModelBuilder modelBuilder);

    }
}
