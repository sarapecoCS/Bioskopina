using Bioskopina.Services.Database;
using Bioskopina.Services.Helpers;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Reflection.Emit;
using System.Text;
using System.Threading.Tasks;

namespace Bioskopina.Services.Database
{
    public partial class BioskopinaContext
    {
        private void SeedData(ModelBuilder modelBuilder)
        {
            SeedBioskopina(modelBuilder);
            SeedUserProfilePictures(modelBuilder);
            SeedUsers(modelBuilder);
            SeedQACategories(modelBuilder);
            SeedRoles(modelBuilder);
            SeedGenres(modelBuilder);
            SeedUserRoles(modelBuilder);
            SeedQA(modelBuilder);
            SeedLists(modelBuilder);
            SeedWatchlists(modelBuilder);
            SeedWatchlistMovies(modelBuilder);
            SeedGenreBioskopina(modelBuilder);
            SeedRatings(modelBuilder);
            SeedPreferredGenres(modelBuilder);
            SeedDonations(modelBuilder);
            SeedPosts(modelBuilder);
            SeedComments(modelBuilder);
            SeedUserPostActions(modelBuilder);
            SeedUserCommentActions(modelBuilder);
            SeedListBioskopina(modelBuilder);


        }
        private void SeedBioskopina(ModelBuilder modelBuilder)
        {
            modelBuilder.Entity<Bioskopina>().HasData(
                new Bioskopina()
                {
                    Id = 1,
                    TitleEn = "Three",
                    Synopsis = "Three stories are set at the beginning, middle and the end of WW2. In all three of them the hero of the movie must witness the death of people he likes.",
                    ImageUrl = "https://m.media-amazon.com/images/M/MV5BOTZiNGFmM2EtOGVhMS00YjEyLThjNzAtY2M1MGUzYTljY2JiXkEyXkFqcGc@._V1_FMjpg_UX1000_.jpg",
                    TrailerUrl = "https://www.youtube.com/watch?v=i4pAWKQvORM",
                    Runtime = 76,
                    Score = 9, 
                    Director = "Aleksandar Petrović",
                    YearRelease = 1965,
                },
                new Bioskopina()
                {
                    Id = 2,
                    TitleEn = "The Rats Woke up",
                    Synopsis = "A lonely man struggles to find the money for his ill sister's treatment while at the same time trying to escape his past and to make sense of the present.",
                    ImageUrl = "https://upload.wikimedia.org/wikipedia/ru/b/bd/Budjenje_pacova.jpg",
                    TrailerUrl = "https://www.youtube.com/watch?v=9RXs4tnExXM",
                    YearRelease = 1967,
                    Runtime = 79,
                    Score = 3, 
                    Director = "Živojin Pavlović",
                },
                new Bioskopina()
                {
                    Id = 3,
                    TitleEn = "Mysteries of the Organism",
                    Synopsis = "An homage to the work of psychologist Wilhelm Reich, matched with a story about a Yugoslavian girl's affair with a Russian skater. Sexual repression, social systems and the orgone theory are explored.",
                    ImageUrl = "https://upload.wikimedia.org/wikipedia/en/thumb/7/7a/Wr_mysteries_of_the_organism_dvd.jpg/220px-Wr_mysteries_of_the_organism_dvd.jpg",
                    TrailerUrl = "https://www.youtube.com/watch?v=-NORCsCIBak",
                    YearRelease = 1971,
                    Runtime = 85,
                    Score = 8, 
                    Director = "Dušan Makavejev",
                },
                new Bioskopina()
                {
                    Id = 4,
                    TitleEn = "It Rains in My Village",
                    Synopsis = "A bizarre and tragic love story involving swineherd, village fool, teacher and an agricultural pilot. The story unfolds in a remote village in the communist ruled Yugoslavia at the down of Soviet occupation of Czechoslovakia in 1968.",
                    ImageUrl = "https://upload.wikimedia.org/wikipedia/sh/thumb/8/84/Bice_skoro_propast_sveta.jpg/220px-Bice_skoro_propast_sveta.jpg",
                    TrailerUrl = "https://www.youtube.com/watch?v=pQ16Puo9A2Q",
                    YearRelease = 1968,
                    Runtime = 84,
                    Director = "Aleksandar Petrović",
                    Score = 1 ,
                },
                new Bioskopina()
                {
                    Id = 5,
                    TitleEn = "When I Am Dead and Gone",
                    Synopsis = "The story about Jimmy the Dingy, a young vagabond who works as a seasonal worker. Having been sacked from the job, his dreams are to become a singer. As most of the things in the Balkans happen, he is destined to failure.",
                    ImageUrl = "https://m.media-amazon.com/images/M/MV5BNzMxOTRhNmYtYmU1Yy00NzliLTg0ZGEtM2JhNTgzNjEzYTBhXkEyXkFqcGc@._V1_QL75_UY281_CR8,0,190,281_.jpg",
                    TrailerUrl = "https://www.youtube.com/watch?app=desktop&v=YiuMux8AR14&t=128s",
                    YearRelease = 1967,
                    Runtime = 79,
                    Score = 4, 
                    Director = "Živojin Pavlović",
                },
                new Bioskopina()
                {
                    Id = 6,
                    TitleEn = "Do Not Mention the Cause of Death",
                    Synopsis = "In an atmosphere of WWII, a village dyer wants to help his folks in their sorrow and distress by supplying them with the black paint, but there is not enough black paint for all of them, because death works faster than the dyer. His wife was raped, but the naive dyer believes in straight intentions of his godfather - black marketeer, and he gives away free canvas to the people. But in all their pain, people are unable to distinguish good intentions from the evil ones.",
                    ImageUrl = "https://m.media-amazon.com/images/M/MV5BZDk2OGY4MWUtODE2My00ZjJiLThiNjYtNjg0NGQzNDFkZDRiXkEyXkFqcGc@._V1_.jpg",
                    TrailerUrl = "https://www.youtube.com/watch?v=S5hR5h1q0gA",
                    YearRelease = 1968,
                    Runtime = 92,
                    Director = "Jovan Zivanovic",
                    Score = 0,
                },
                new Bioskopina()
                {
                    Id = 7,
                    TitleEn = "I Even Met Happy Gypsies",
                    Synopsis = "Tensions arise in a Gypsy community when a local feather seller falls in love with a much younger girl.",
                    ImageUrl = "https://m.media-amazon.com/images/M/MV5BZDUwNmJlNDQtYWRhOC00NzFhLTk3NWUtM2UyNzdmNzMzYmIwXkEyXkFqcGc@._V1_.jpg",
                    TrailerUrl = "https://www.youtube.com/watch?v=Op0wuHguS4c",
                    YearRelease = 1967,
                    Runtime = 94,
                    Score = 5, 
                    Director = "Aleksandar Petrovic",
                },
                new Bioskopina()
                {
                    Id = 8,
                    TitleEn = "Early Works",
                    Synopsis = "A group of young persons are going to make a revolution, but in real life everything is not the same as in smart books.",
                    ImageUrl = "https://www.cinemaclock.com/images/posters/1000x1500/52/rani-radovi-1969-orig-poster.jpg",
                    TrailerUrl = "https://www.youtube.com/watch?v=H6Djqv0fwn4",
                    YearRelease = 1969,
                    Runtime = 87,
                    Director = "Zelimir Zilnik",
                    Score = 6,
                },
                new Bioskopina()
                {
                    Id = 9,
                    TitleEn = "The Ambush",
                    Synopsis = "Idealistic young man supports the party and the new Yugoslavia's communist regime, but soon gets involved in various political and criminal machinations becoming more and more confused about what's right and what's wrong.",
                    ImageUrl = "https://m.media-amazon.com/images/M/MV5BNmE0OTE1NTgtODFhYy00ZTVhLWE0MDktMDRjNjllNzVmMTFhXkEyXkFqcGc@._V1_.jpg",
                    TrailerUrl = "https://www.youtube.com/watch?v=H6Djqv0fwn4",
                    YearRelease = 1969,
                    Runtime = 87,
                    Director = "Zelimir Zilnik",
                    Score = 10 ,
                }
            );
        }



        private void SeedUserProfilePictures(ModelBuilder modelBuilder)
        {
            modelBuilder.Entity<UserProfilePicture>().HasData(
                new UserProfilePicture()
                {
                    Id = 1,
                    ProfilePicture = ImageHelper.ConvertImageToByteArray("UserPicture/picture.png")


    
                }
                    


         );
        }




        private void SeedUsers(ModelBuilder modelBuilder)
        {
            string hash = "my/ELwTcrvtQ7tlVYibJNnISjtw=";
            string salt = "u9Rht8UH9bvKrDQnbeNh7A==";

            modelBuilder.Entity<User>().HasData(
                new User()
                {
                    Id = 1,
                    FirstName = "Sara",
                    LastName = "Peco",
                    PasswordHash = hash,
                    PasswordSalt = salt,
                    Email = "sara.peco@edu.fit.ba",
                    ProfilePictureId = 1,
                    DateJoined = new DateTime(2025, 3, 31),
                    Username = "administrator",
                },
                new User()
                {
                    Id = 2,
                    FirstName = "Korisnik",
                    LastName = "Korisnik",
                    PasswordHash = hash,
                    PasswordSalt = salt,
                    Email ="korisnik@edu.fit.ba",
                    ProfilePictureId = 1,
                    DateJoined = new DateTime(2025, 3, 31),
                    Username = "korisnik",
                },
                  new User()
                  {
                      Id = 3,
                      FirstName = "Aleksandar",
                      LastName = "Petrović",
                      PasswordHash = hash,
                      PasswordSalt = salt,
                      Email = "aleksandar.petrovic@edu.fit.ba",
                       ProfilePictureId = 1,
                      DateJoined = new DateTime(2025, 3, 31),
                      Username = "alexpetr",
                  },
                    new User()
                    {
                        Id = 4,
                        FirstName = "Spiridon",
                        LastName = "Kopici",
                        PasswordHash = hash,
                        PasswordSalt = salt,
                        Email = "spiridon@outlook.com",
                        ProfilePictureId = 4,
                        DateJoined = new DateTime(2025, 3, 31),
                        Username = "spiridon_music",
                    },
                      new User()
                      {
                          Id = 5,
                          FirstName = "Katarina",
                          LastName = "Petrović",
                          PasswordHash = hash,
                          PasswordSalt = salt,
                          Email = "katarina@edu.fit.ba",
                          ProfilePictureId = 1,
                          DateJoined = new DateTime(2025, 3, 31),
                          Username = "katarina_petrovic",
                      }

         );
        }

        private void SeedQACategories(ModelBuilder modelBuilder)
        {
            modelBuilder.Entity<QAcategory>().HasData(
                new QAcategory()
                {
                    Id = 1,
                    Name = "General"
                },
                new QAcategory()
                {
                    Id = 2,
                    Name = "App Support"
                },
                new QAcategory()
                {
                    Id = 3,
                    Name = "Feedback and Suggestions"
                },
                new QAcategory()
                {
                    Id = 4,
                    Name = "Feature Requests"
                }
         );
        }
       

        private void SeedRoles(ModelBuilder modelBuilder)
        {
            modelBuilder.Entity<Role>().HasData(
                new Role()
                {
                    Id = 1,
                    Name = "Administrator"
                },
                new Role()
                {
                    Id = 2,
                    Name = "User"
                }
            );
        }

        private void SeedGenres(ModelBuilder modelBuilder)
        {
            modelBuilder.Entity<Genre>().HasData(
                new Genre()
                {
                    Id = 1,
                    Name = "Drama"
                },
                new Genre()
                {
                    Id = 2,
                    Name = "War"
                },
                new Genre()
                {
                    Id = 3,
                    Name = "Political"
                },
                new Genre()
                {
                    Id = 4,
                    Name = "Artistic"
                }
            );
        }


        private void SeedGenreBioskopina(ModelBuilder modelBuilder)
        {
            modelBuilder.Entity<GenreBioskopina>().HasData(
                new GenreBioskopina()
                {
                    Id = 1,
                    GenreId = 1, // Drama
                    MovieId = 9, // "The Ambush"
                },
                new GenreBioskopina()
                {
                    Id = 2,
                    GenreId = 3, // Political
                    MovieId = 9, // "The Ambush"
                },
                new GenreBioskopina()
                {
                    Id = 3,
                    GenreId = 1, // Drama
                    MovieId = 8, // "Early Works"
                },
                new GenreBioskopina()
                {
                    Id = 4,
                    GenreId = 3, // Political
                    MovieId = 8, // "Early Works"
                },
                new GenreBioskopina()
                {
                    Id = 5,
                    GenreId = 4, // Art House
                    MovieId = 8, // "Early Works"
                },
                new GenreBioskopina()
                {
                    Id = 6,
                    GenreId = 1, // Drama
                    MovieId = 7, // "I Even Met Happy Gypsies"
                },
                new GenreBioskopina()
                {
                    Id = 7,
                    GenreId = 4, // Art House
                    MovieId = 7, // "I Even Met Happy Gypsies"
                },
                new GenreBioskopina()
                {
                    Id = 8,
                    GenreId = 1, // Drama
                    MovieId = 6, // "Do Not Mention the Cause of Death"
                },
                new GenreBioskopina()
                {
                    Id = 9,
                    GenreId = 2, // War
                    MovieId = 6, // "Do Not Mention the Cause of Death"
                },
                new GenreBioskopina()
                {
                    Id = 10,
                    GenreId = 1, // Drama
                    MovieId = 5, // "When I Am Dead and Gone"
                },
                new GenreBioskopina()
                {
                    Id = 11,
                    GenreId = 4, // Art House
                    MovieId = 5, // "When I Am Dead and Gone"
                },
                new GenreBioskopina()
                {
                    Id = 12,
                    GenreId = 1, // Drama
                    MovieId = 4, // "It Rains in My Village"
                },
                new GenreBioskopina()
                {
                    Id = 13,
                    GenreId = 2, // War
                    MovieId = 4, // "It Rains in My Village"
                },
                new GenreBioskopina()
                {
                    Id = 14,
                    GenreId = 1, // Drama
                    MovieId = 3, // "WR: Mysteries of the Organism"
                },
                new GenreBioskopina()
                {
                    Id = 15,
                    GenreId = 4, // Art House
                    MovieId = 3, // "WR: Mysteries of the Organism"
                },
                new GenreBioskopina()
                {
                    Id = 16,
                    GenreId = 3, // Political
                    MovieId = 3, // "WR: Mysteries of the Organism"
                },
                new GenreBioskopina()
                {
                    Id = 17,
                    GenreId = 1, // Drama
                    MovieId = 2, // "The Rats Woke up"
                },
                new GenreBioskopina()
                {
                    Id = 18,
                    GenreId = 3, // Political
                    MovieId = 2, // "The Rats Woke up"
                },
                new GenreBioskopina()
                {
                    Id = 19,
                    GenreId = 1, // Drama
                    MovieId = 1, // "Three"
                },
                new GenreBioskopina()
                {
                    Id = 20,
                    GenreId = 2, // War
                    MovieId = 1, // "Three"
                }
            );
        }

        private void SeedUserRoles(ModelBuilder modelBuilder)
        {
            modelBuilder.Entity<UserRole>().HasData(
                new UserRole()
                {
                    Id = 1,
                    UserId = 1,
                    RoleId = 1,
                    CanReview = true,
                    CanAskQuestions = true,
                    CanParticipateInClubs = true,
                },
                new UserRole()
                {
                    Id = 2,
                    UserId = 1,
                    RoleId = 2,
                    CanReview = true,
                    CanAskQuestions = true,
                    CanParticipateInClubs = true,
                },
                new UserRole()
                {
                    Id = 3,
                    UserId = 2,
                    RoleId = 2,
                    CanReview = true,
                    CanAskQuestions = true,
                    CanParticipateInClubs = true,
                },
                new UserRole()
                {
                    Id = 4,
                    UserId = 3,
                    RoleId = 2,
                    CanReview = true,
                    CanAskQuestions = true,
                    CanParticipateInClubs = true,
                },
                new UserRole()
                {
                    Id = 5,
                    UserId = 4,
                    RoleId = 2,
                    CanReview = true,
                    CanAskQuestions = true,
                    CanParticipateInClubs = true,
                },
                new UserRole()
                {
                    Id = 6,
                    UserId = 5,
                    RoleId = 2,
                    CanReview = true,
                    CanAskQuestions = true,
                    CanParticipateInClubs = true,
                }
         );
        }

        private void SeedQA(ModelBuilder modelBuilder)
        {
            modelBuilder.Entity<QA>().HasData(
                new QA()
                {
                    Id = 1,
                    UserId = 2,
                    CategoryId = 1,
                    Question = "I wish users could add movies",
                    Answer = "",
                    Displayed = true
                },
              
              
                new QA()
                {
                    Id = 2,
                    UserId = 3,
                    CategoryId = 4,
                    Question = "Can we get a forum feature in this app?",
                    Answer = "It's in progress, it will be available once it's tested and ready.",
                    Displayed = true
                }
              
         );
        }

        private void SeedWatchlists(ModelBuilder modelBuilder)
        {
            modelBuilder.Entity<Watchlist>().HasData(
                new Watchlist()
                {
                    Id = 1,
                    UserId = 1,
                    
                    DateAdded = new DateTime(2025, 7, 11)
                },
                new Watchlist()
                {
                    Id = 2,
                    UserId = 2,
                    DateAdded = new DateTime(2025, 7, 11)
                },
                new Watchlist()
                {
                    Id = 3,
                    UserId = 3,
                    DateAdded = new DateTime(2025, 7, 11)
                },
                new Watchlist()
                {
                    Id = 4,
                    UserId = 4,
                    DateAdded = new DateTime(2025, 7, 11)
                },
                 new Watchlist
                 {
                     Id = 5,
                     UserId = 5,
                     DateAdded = new DateTime(2025, 7, 11)
                 }
                
         );
        }

        private void SeedWatchlistMovies(ModelBuilder modelBuilder)
        {
            modelBuilder.Entity<BioskopinaWatchlist>().HasData(
                // User 1 watchlist with 3 movies
                new BioskopinaWatchlist { Id = 1, MovieId = 1, WatchlistId = 1 },
                new BioskopinaWatchlist { Id = 2, MovieId = 2, WatchlistId = 1},
                new BioskopinaWatchlist { Id = 3, MovieId = 3, WatchlistId = 1 },

                // User 2 watchlist with 3 movies
                new BioskopinaWatchlist { Id = 4, MovieId = 2, WatchlistId = 2 },
                new BioskopinaWatchlist { Id = 5, MovieId = 4, WatchlistId = 2 },
                new BioskopinaWatchlist { Id = 6, MovieId = 5, WatchlistId = 2 },

                // User 3 watchlist with 2 movies
                new BioskopinaWatchlist { Id = 7, MovieId = 1, WatchlistId = 3 },
                new BioskopinaWatchlist { Id = 8, MovieId = 6, WatchlistId = 3 },

                // User 4 watchlist with 4 movies
                new BioskopinaWatchlist { Id = 9, MovieId = 3, WatchlistId = 4 },
                new BioskopinaWatchlist { Id = 10, MovieId = 5, WatchlistId = 4 },
                new BioskopinaWatchlist { Id = 11, MovieId = 7, WatchlistId = 4 },
                new BioskopinaWatchlist { Id = 12, MovieId = 8, WatchlistId = 4 },

                // User 5 watchlist with completed movies (IDs 13-21)
                new BioskopinaWatchlist { Id = 13, MovieId = 1, WatchlistId = 5 },
                new BioskopinaWatchlist { Id = 14, MovieId = 2, WatchlistId = 5 },
                new BioskopinaWatchlist { Id = 15, MovieId = 3, WatchlistId = 5 },
                new BioskopinaWatchlist { Id = 16, MovieId = 4, WatchlistId = 5 },
                new BioskopinaWatchlist { Id = 17, MovieId = 5, WatchlistId = 5 },
                new BioskopinaWatchlist { Id = 18, MovieId = 6, WatchlistId = 5 },
                new BioskopinaWatchlist { Id = 19, MovieId = 7, WatchlistId = 5 },
                new BioskopinaWatchlist { Id = 20, MovieId = 8, WatchlistId = 5 },
                new BioskopinaWatchlist { Id = 21, MovieId = 9, WatchlistId = 5 }


                



            );
            
        }



        private void SeedLists(ModelBuilder modelBuilder)
        {
            modelBuilder.Entity<List>().HasData(
                new List()
                {
                    Id = 1,
                    UserId = 3,
                    Name = "Relax",
                    DateCreated = new DateTime(2025, 6, 1)
                },
                new List()
                {
                    Id = 2,
                    UserId = 3,
                    Name = "Historical",
                    DateCreated = new DateTime(2025, 6, 5)
                },
                new List()
                {
                    Id = 3,
                    UserId = 2,
                    Name = "Artistic Films",
                    DateCreated = new DateTime(2025, 6, 10)
                },
                new List()
                {
                    Id = 4,
                    UserId = 3,
                    Name = "Classic Collection",
                    DateCreated = new DateTime(2025, 6, 15)
                },
                new List()
                {
                    Id = 5,
                    UserId = 4,
                    Name = "Nihilistic Night",
                    DateCreated = new DateTime(2025, 6, 20)
                }
            );
        }

        private void SeedListBioskopina(ModelBuilder modelBuilder)
        {
            modelBuilder.Entity<BioskopinaList>().HasData(
                // List 1: Movies 1, 2, 3 (Action)
                new BioskopinaList { Id = 1, ListId = 1, MovieId = 1 },
                new BioskopinaList { Id = 2, ListId = 1, MovieId = 2 },
                new BioskopinaList { Id = 3, ListId = 1, MovieId = 3 },

                // List 2: Movies 4, 5, 6 (Sci-Fi)
                new BioskopinaList { Id = 4, ListId = 2, MovieId = 4 },
                new BioskopinaList { Id = 5, ListId = 2, MovieId = 5 },
                new BioskopinaList { Id = 6, ListId = 2, MovieId = 6 },

                // List 3: Movies 7, 8, 9 (Artistic)
                new BioskopinaList { Id = 7, ListId = 3, MovieId = 7 },
                new BioskopinaList { Id = 8, ListId = 3, MovieId = 8 },
                new BioskopinaList { Id = 9, ListId = 3, MovieId = 9 },

                // List 4: Movies 1, 3, 5, 7 (Classic)
                new BioskopinaList { Id = 10, ListId = 4, MovieId = 1 },
                new BioskopinaList { Id = 11, ListId = 4, MovieId = 3 },
                new BioskopinaList { Id = 12, ListId = 4, MovieId = 5 },
                new BioskopinaList { Id = 13, ListId = 4, MovieId = 7 },

                // List 5: Movies 2, 4, 6, 8 (Horror)
                new BioskopinaList { Id = 14, ListId = 5, MovieId = 2 },
                new BioskopinaList { Id = 15, ListId = 5, MovieId = 4 },
                new BioskopinaList { Id = 16, ListId = 5, MovieId = 6 },
                new BioskopinaList { Id = 17, ListId = 5, MovieId = 8 },

                // 🚀 Add extra overlaps (e.g., Movie 9 appears again in List 4)
                new BioskopinaList { Id = 18, ListId = 4, MovieId = 9 },
                new BioskopinaList { Id = 19, ListId = 2, MovieId = 9 }
            );
        }
        private void SeedRatings(ModelBuilder modelBuilder)
        {
            modelBuilder.Entity<Rating>().HasData(
                new Rating()
                {
                    Id = 1,
                    UserId = 2,
                    MovieId = 1,
                    RatingValue = 10,
                    ReviewText = "Love it so much!",
                    DateAdded = new DateTime(2025, 7, 21)
                },
                new Rating()
                {
                    Id = 2,
                    UserId = 2,
                    MovieId = 3,
                    RatingValue = 8,
                    ReviewText = "Interesting...",
                    DateAdded = new DateTime(2025, 7, 21)
                },
                new Rating()
                {
                    Id = 3,
                    UserId = 3,
                    MovieId = 1,
                    RatingValue = 8,
                    ReviewText = "Visually stunning and emotionally resonants truly immersive experience",
                    DateAdded = new DateTime(2025, 7, 21)
                },
                new Rating()
                {
                    Id = 4,
                    UserId = 2,
                    MovieId = 4,
                    RatingValue = 1,
                    ReviewText = "It is quite slow to be honest, not my cup of tea.",
                    DateAdded = new DateTime(2025, 7, 21)
                },
                   new Rating()
                   {
                       Id = 5,
                       UserId = 2,
                       MovieId = 2,
                       RatingValue = 1,
                       ReviewText = "It is quite slow to be honest, not my cup of tea.",
                       DateAdded = new DateTime(2025, 7, 21)
                   },
                        new Rating()
                        {
                            Id = 6,
                            UserId = 3,
                            MovieId = 2,
                            RatingValue = 10,
                            ReviewText = "I think it is just perfect. The way tragedy can have such a deep roots it just unforgetable.",
                            DateAdded = new DateTime(2025, 7, 21)
                        },
                             new Rating()
                             {
                                 Id = 7,
                                 UserId = 5,
                                 MovieId = 5,
                                 RatingValue = 4,
                                 ReviewText = "Jimmy is just briliant but it's slightly sad movie",
                                 DateAdded = new DateTime(2025, 7, 21)
                             },
                                new Rating()
                                {
                                    Id = 8,
                                    UserId = 5,
                                    MovieId = 6,
                                    RatingValue = 5,
                                    ReviewText = "WW2 theme is good.",
                                    DateAdded = new DateTime(2025, 7, 21)
                                }


         );
        }

        private void SeedPreferredGenres(ModelBuilder modelBuilder)
        {
            modelBuilder.Entity<PreferredGenre>().HasData(
                new PreferredGenre()
                {
                    Id = 1,
                    GenreId = 1,
                    UserId = 2
                },
                new PreferredGenre()
                {
                    Id = 2,
                    GenreId = 3,
                    UserId = 4
                },
                new PreferredGenre()
                {
                    Id = 3,
                    GenreId =4,
                    UserId = 2
                }
         );
        }

        private void SeedDonations(ModelBuilder modelBuilder)
        {
            modelBuilder.Entity<Donation>().HasData(
                new Donation()
                {
                    Id = 1,
                    UserId = 5,
                    Amount = 2,
                    DateDonated = new DateTime(2025, 9, 12),
                    TransactionId = "txn_3PijFYRsmg17Kngz1idOozHb"
                },
                new Donation()
                {
                    Id = 2,
                    UserId = 2,
                    Amount = 3,
                    DateDonated = new DateTime(2025, 8, 12),
                    TransactionId = "txn_3PijFYRsmg17Kngz1idOozHc"
                },
                new Donation()
                {
                    Id = 3,
                    UserId = 3,
                    Amount = 8,
                    DateDonated = new DateTime(2025, 8, 15),
                    TransactionId = "txn_3PijFYRsmg17Kngz1idOozHd"
                }
         );
        }


        private void SeedPosts(ModelBuilder modelBuilder)
        {
            modelBuilder.Entity<Post>().HasData(
                new Post()
                {
                    Id = 1,
                    UserId = 1, 
                    Content = "Ever seen a movie that challenges everything you thought you knew? Three is one of those films. What do you think about movies that make you think deeply, even if they're a bit hard to grasp at first?",
                    LikesCount = 5,
                    DislikesCount = 0,
                    DatePosted = new DateTime(2024, 7, 11),
                    VideoUrl = "https://www.youtube.com/watch?v=i4pAWKQvORM" 
                },
                new Post()
                {
                    Id = 2,
                    UserId = 2, 
                    Content = "A raw, unsettling journey. The Rats Woke Up dives deep into the complexities of human nature. Have you ever watched a movie that just leaves you thinking for days after? This is one of those.",
                    LikesCount = 0,
                    DislikesCount = 4,
                    DatePosted = new DateTime(2024, 7, 11),
                    VideoUrl = "https://www.youtube.com/watch?v=9RXs4tnExXM" // Video URL
                },
                new Post()
                {
                    Id = 3,
                    UserId = 2, 
                    Content = "This one’s a wild ride—part psychological, part political, and entirely bizarre. WR: Mysteries of the Organism is one for those who love films that are as confusing as they are compelling. Thoughts?",
                    LikesCount = 2,
                    DislikesCount = 0,
                    DatePosted = new DateTime(2024, 7, 11),
                    VideoUrl = "https://www.youtube.com/watch?v=-NORCsCIBak" // Video URL
                },
                new Post()
                {
                    Id = 4,
                    UserId = 4, 
                    Content = "Sometimes the most powerful stories are the simplest ones. It Rains in My Village captures life in its purest form. How do you feel about films that focus on the quiet moments?",
                    LikesCount = 4,
                    DislikesCount = 0,
                    DatePosted = new DateTime(2024, 7, 11),
                    VideoUrl = "https://www.youtube.com/watch?v=pQ16Puo9A2Q" // Video URL
                },
                new Post()
                {
                    Id = 5,
                    UserId = 1, 
                    Content = "A haunting meditation on life and death. When I Am Dead and Gone explores what happens when everything we know is gone. What’s your take on films that ask big questions about our existence?",
                    LikesCount = 0,
                    DislikesCount = 3,
                    DatePosted = new DateTime(2024, 7, 11),
                    VideoUrl = "https://www.youtube.com/watch?app=desktop&v=YiuMux8AR14&t=128s" // Video URL
                },
                new Post()
                {
                    Id = 6,
                    UserId = 1,
                    Content = "If you’re into thought-provoking cinema with a dark edge, Uzrok smrti ne pominjati might just be your thing. It’s an exploration of history and humanity’s darker sides. What do you think about movies that confront uncomfortable truths?",
                    LikesCount = 2,
                    DislikesCount = 0,
                    DatePosted = new DateTime(2024, 7, 11),
                    VideoUrl = "https://www.youtube.com/watch?v=S5hR5h1q0gA" // Video URL
                },
                new Post()
                {
                    Id = 7,
                    UserId = 4, 
                    Content = "A classic! I Even Met Happy Gypsies is a poignant look at the lives of those who live on the margins of society. Have you ever seen a film that makes you rethink your perspective on the world?",
                    LikesCount = 9,
                    DislikesCount = 0,
                    DatePosted = new DateTime(2024, 7, 11),
                    VideoUrl = "https://www.youtube.com/watch?v=Op0wuHguS4c" // Video URL
                },
                new Post()
                {
                    Id = 8,
                    UserId = 2, 
                    Content = "Early Works is one of those films that packs a punch with its rawness. It's a perfect example of how art can push boundaries. What’s the most daring film you’ve ever seen?",
                    LikesCount = 4,
                    DislikesCount = 1,
                    DatePosted = new DateTime(2024, 7, 11),
                    VideoUrl = "https://www.youtube.com/watch?v=H6Djqv0fwn4" // Video URL
                },
                new Post()
                {
                    Id = 9,
                    UserId = 1, 
                    Content = "A gripping story of survival and loyalty. The Ambush takes you on a journey you won’t forget. What do you think about war films that focus on the human cost over the action?",
                    LikesCount = 3,
                    DislikesCount = 2,
                    DatePosted = new DateTime(2024, 7, 11),
                    VideoUrl = "https://www.youtube.com/watch?v=H6Djqv0fwn4" // Video URL
                }
            );
        }

        private void SeedComments(ModelBuilder modelBuilder)
        {
            modelBuilder.Entity<Comment>().HasData(
                new Comment()
                {
                    Id = 1,
                    PostId = 1, // Post for "Three"
                    UserId = 4,
                    Content = "The complexity of 'Three' still holds up. It's incredible how it delves into personal identity, especially in today’s world of shifting political landscapes.",
                    LikesCount = 1,
                    DislikesCount = 0,
                    DateCommented = new DateTime(2025, 7, 11)
                },
                new Comment()
                {
                    Id = 2,
                    PostId = 2, // Post for "The Rats Woke Up"
                    UserId = 4,
                    Content = "Watching 'The Rats Woke Up' again, I can’t help but think how its themes of social unrest resonate even more today. It's still relevant, and that's what's so disturbing about it.",
                    LikesCount = 2,
                    DislikesCount = 0,
                    DateCommented = new DateTime(2025, 7, 11)
                },
                new Comment()
                {
                    Id = 3,
                    PostId = 3, // Post for "WR: Mysteries of the Organism"
                    UserId = 3,
                    Content = "'WR' was always a mind-bender, but after seeing it again, I’m amazed by its influence on modern experimental filmmakers. It’s still way ahead of its time.",
                    LikesCount = 2,
                    DislikesCount = 1,
                    DateCommented = new DateTime(2025, 7, 11)
                },
                new Comment()
                {
                    Id = 4,
                    PostId = 4, // Post for "It Rains in My Village"
                    UserId = 2,
                    Content = "'It Rains in My Village' hits differently now. The emotional depth, the commentary on human resilience... it feels even more poignant given today's world events.",
                    LikesCount = 3,
                    DislikesCount = 0,
                    DateCommented = new DateTime(2025, 7, 11)
                },
                new Comment()
                {
                    Id = 5,
                    PostId = 5, // Post for "When I Am Dead and Gone"
                    UserId = 1,
                    Content = "I keep thinking about how 'When I Am Dead and Gone' captures the human cost of conflict. It’s timeless, but its message is even more urgent now in 2025.",
                    LikesCount = 0,
                    DislikesCount = 0,
                    DateCommented = new DateTime(2025, 7, 11)
                },
                new Comment()
                {
                    Id = 6,
                    PostId = 6, // Post for "Uzrok smrti ne pominjati"
                    UserId = 2,
                    Content = "This film's reflection on trauma and survival is so crucial. It feels especially relevant in today’s world where conflict seems never-ending.",
                    LikesCount = 5,
                    DislikesCount = 0,
                    DateCommented = new DateTime(2025, 7, 11)
                }
            );
        }


        private void SeedUserPostActions(ModelBuilder modelBuilder)
        {
            modelBuilder.Entity<UserPostAction>().HasData(
                new UserPostAction()
                {
                    Id = 1,
                    UserId = 2,
                    PostId = 1,
                    Action = "like"
                },
                new UserPostAction()
                {
                    Id = 2,
                    UserId = 2,
                    PostId = 2,
                    Action = "dislike"
                },
                new UserPostAction()
                {
                    Id = 3,
                    UserId = 2,
                    PostId = 3,
                    Action = "like"
                }
         );
        }

        private void SeedUserCommentActions(ModelBuilder modelBuilder)
        {
            modelBuilder.Entity<UserCommentAction>().HasData(
                new UserCommentAction()
                {
                    Id = 1,
                    UserId = 2,

                    CommentId = 1,
                

                    Action = "like"
                },
                new UserCommentAction()
                {
                    Id = 2,
                    UserId = 1,
                    
                    CommentId = 2,
                  

                  
                    Action = "dislike"
                }

         );
        }

    }
}
