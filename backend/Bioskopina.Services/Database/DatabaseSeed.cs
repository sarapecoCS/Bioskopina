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
        }
        private void SeedBioskopina(ModelBuilder modelBuilder)
        {
            modelBuilder.Entity<Bioskopina>().HasData(
                new Bioskopina()
                {
                    Id = 1,
                    TitleEn = "Three",
                    TitleYugo = "Tri",
                    Synopsis = "Three stories are set at the beginning, middle and the end of WW2. In all three of them the hero of the movie must witness the death of people he likes.",
                    ImageUrl = "https://m.media-amazon.com/images/M/MV5BOTZiNGFmM2EtOGVhMS00YjEyLThjNzAtY2M1MGUzYTljY2JiXkEyXkFqcGc@._V1_FMjpg_UX1000_.jpg",
                    TrailerUrl = "https://www.youtube.com/watch?v=i4pAWKQvORM",
                    Runtime = 76,
                    Director = "Aleksandar Petrović",
                    YearRelease = 1965,
                    Awards = "Nominated for 1 Oscar - 2 wins & 2 nominations total",
                    IMDbRatings = "7.7/10"
                },
                new Bioskopina()
                {
                    Id = 2,
                    TitleEn = "The Rats Woke up",
                    TitleYugo = "Buđenje pacova",
                    Synopsis = "A lonely man struggles to find the money for his ill sister's treatment while at the same time trying to escape his past and to make sense of the present.",
                    ImageUrl = "https://upload.wikimedia.org/wikipedia/ru/b/bd/Budjenje_pacova.jpg",
                    TrailerUrl = "https://www.youtube.com/watch?v=9RXs4tnExXM",
                    YearRelease = 1967,
                    Runtime = 79,
                    Director = "Živojin Pavlović",
                    Awards = "4 wins & 1 nomination",
                    IMDbRatings = "7.6/10"
                },
                new Bioskopina()
                {
                    Id = 3,
                    TitleEn = "WR: Mysteries of the Organism",
                    TitleYugo = "W. R. – Misterije organizma",
                    Synopsis = "An homage to the work of psychologist Wilhelm Reich, matched with a story about a Yugoslavian girl's affair with a Russian skater. Sexual repression, social systems and the orgone theory are explored.",
                    ImageUrl = "https://upload.wikimedia.org/wikipedia/en/thumb/7/7a/Wr_mysteries_of_the_organism_dvd.jpg/220px-Wr_mysteries_of_the_organism_dvd.jpg",
                    TrailerUrl = "https://www.youtube.com/watch?v=-NORCsCIBak",
                    YearRelease = 1971,
                    Runtime = 85,
                    Director = "Dušan Makavejev",
                    Awards = "4 wins & 1 nomination total",
                    IMDbRatings = "6.7/10"
                },
                new Bioskopina()
                {
                    Id = 4,
                    TitleEn = "It Rains in My Village",
                    TitleYugo = "Biće skoro propast sveta",
                    Synopsis = "A bizarre and tragic love story involving swineherd, village fool, teacher and an agricultural pilot. The story unfolds in a remote village in the communist ruled Yugoslavia at the down of Soviet occupation of Czechoslovakia in 1968.",
                    ImageUrl = "https://upload.wikimedia.org/wikipedia/sh/thumb/8/84/Bice_skoro_propast_sveta.jpg/220px-Bice_skoro_propast_sveta.jpg",
                    TrailerUrl = "https://www.youtube.com/watch?v=pQ16Puo9A2Q",
                    YearRelease = 1968,
                    Runtime = 84,
                    Director = "Aleksandar Petrović",
                    Awards = "1 wins & 1 nomination total",
                    IMDbRatings = "7.2/10",
                    Score = 2
                },
                new Bioskopina()
                {
                    Id = 5,
                    TitleEn = "When I Am Dead and Gone",
                    TitleYugo = "Kad budem mrtav i beo",
                    Synopsis = "The story about Jimmy the Dingy, a young vagabond who works as a seasonal worker. Having been sacked from the job, his dreams are to become a singer. As most of the things in the Balkans happen, he is destined to failure.",
                    ImageUrl = "https://m.media-amazon.com/images/M/MV5BNzMxOTRhNmYtYmU1Yy00NzliLTg0ZGEtM2JhNTgzNjEzYTBhXkEyXkFqcGc@._V1_QL75_UY281_CR8,0,190,281_.jpg",
                    TrailerUrl = "https://www.youtube.com/watch?app=desktop&v=YiuMux8AR14&t=128s",
                    YearRelease = 1967,
                    Runtime = 79,
                    Director = "Živojin Pavlović",
                    Awards = "4 wins & 2 nomination total",
                    IMDbRatings = "7.9/10"
                },
                new Bioskopina()
                {
                    Id = 6,
                    TitleEn = "Do Not Mention the Cause of Death",
                    TitleYugo = "Uzrok smrti ne pominjati",
                    Synopsis = "In an atmosphere of WWII, a village dyer wants to help his folks in their sorrow and distress by supplying them with the black paint, but there is not enough black paint for all of them, because death works faster than the dyer. His wife was raped, but the naive dyer believes in straight intentions of his godfather - black marketeer, and he gives away free canvas to the people. But in all their pain, people are unable to distinguish good intentions from the evil ones.",
                    ImageUrl = "https://m.media-amazon.com/images/M/MV5BZDk2OGY4MWUtODE2My00ZjJiLThiNjYtNjg0NGQzNDFkZDRiXkEyXkFqcGc@._V1_.jpg",
                    TrailerUrl = "https://www.youtube.com/watch?v=S5hR5h1q0gA",
                    YearRelease = 1968,
                    Runtime = 92,
                    Director = "Jovan Zivanovic",
                    Awards = " 0 nomination total",
                    IMDbRatings = "7.0/10"
                },
                new Bioskopina()
                {
                    Id = 7,
                    TitleEn = "I Even Met Happy Gypsies",
                    TitleYugo = "Skupljaci perja",
                    Synopsis = "Tensions arise in a Gypsy community when a local feather seller falls in love with a much younger girl.",
                    ImageUrl = "https://m.media-amazon.com/images/M/MV5BZDUwNmJlNDQtYWRhOC00NzFhLTk3NWUtM2UyNzdmNzMzYmIwXkEyXkFqcGc@._V1_.jpg",
                    TrailerUrl = "https://www.youtube.com/watch?v=Op0wuHguS4c",
                    YearRelease = 1967,
                    Runtime = 94,
                    Director = "Aleksandar Petrovic",
                    Awards = "Nominated for 1 Oscar - 7 wins & 6 nominations total",
                    IMDbRatings = "7.6/10--"
                },
                new Bioskopina()
                {
                    Id = 8,
                    TitleEn = "Early Works",
                    TitleYugo = "Rani radovi",
                    Synopsis = "A group of young persons are going to make a revolution, but in real life everything is not the same as in smart books.",
                    ImageUrl = "https://www.cinemaclock.com/images/posters/1000x1500/52/rani-radovi-1969-orig-poster.jpg",
                    TrailerUrl = "https://www.youtube.com/watch?v=H6Djqv0fwn4",
                    YearRelease = 1969,
                    Runtime = 87,
                    Director = "Zelimir Zilnik",
                    Awards = "2 wins in total",
                    Score = 3,
                    IMDbRatings = "7.6/10"
                },
                new Bioskopina()
                {
                    Id = 9,
                    TitleEn = "The Ambush",
                    TitleYugo = "Zaseda",
                    Synopsis = "Idealistic young man supports the party and the new Yugoslavia's communist regime, but soon gets involved in various political and criminal machinations becoming more and more confused about what's right and what's wrong.",
                    ImageUrl = "https://m.media-amazon.com/images/M/MV5BNmE0OTE1NTgtODFhYy00ZTVhLWE0MDktMDRjNjllNzVmMTFhXkEyXkFqcGc@._V1_.jpg",
                    TrailerUrl = "https://www.youtube.com/watch?v=H6Djqv0fwn4",
                    YearRelease = 1969,
                    Runtime = 87,
                    Director = "Zelimir Zilnik",
                    Awards = "2 wins in total",
                    Score = 4,
                    IMDbRatings = "7.6/10"
                }
            );
        }


        private void SeedUserProfilePictures(ModelBuilder modelBuilder)
        {
            modelBuilder.Entity<UserProfilePicture>().HasData(
                new UserProfilePicture()
                {
                    Id = 1,
                    ProfilePicture = ImageHelper.ConvertImageToByteArray("UserPicture\\picture.png")


    
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
                    Username = "saraapeco",
                },
                new User()
                {
                    Id = 2,
                    FirstName = "Armina",
                    LastName = "Čosić",
                    PasswordHash = hash,
                    PasswordSalt = salt,
                    Email ="armina.cosic@edu.fit.ba",
                    ProfilePictureId = 1,
                    DateJoined = new DateTime(2025, 3, 31),
                    Username = "arminaacosic",
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
                        ProfilePictureId = 1,
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
            modelBuilder.Entity<GenreBiskopina>().HasData(
                new GenreBiskopina()
                {
                    Id = 1,
                    GenreId = 1, // Drama
                    MovieId = 9, // "The Ambush"
                },
                new GenreBiskopina()
                {
                    Id = 2,
                    GenreId = 3, // Political
                    MovieId = 9, // "The Ambush"
                },
                new GenreBiskopina()
                {
                    Id = 3,
                    GenreId = 1, // Drama
                    MovieId = 8, // "Early Works"
                },
                new GenreBiskopina()
                {
                    Id = 4,
                    GenreId = 3, // Political
                    MovieId = 8, // "Early Works"
                },
                new GenreBiskopina()
                {
                    Id = 5,
                    GenreId = 4, // Art House
                    MovieId = 8, // "Early Works"
                },
                new GenreBiskopina()
                {
                    Id = 6,
                    GenreId = 1, // Drama
                    MovieId = 7, // "I Even Met Happy Gypsies"
                },
                new GenreBiskopina()
                {
                    Id = 7,
                    GenreId = 4, // Art House
                    MovieId = 7, // "I Even Met Happy Gypsies"
                },
                new GenreBiskopina()
                {
                    Id = 8,
                    GenreId = 1, // Drama
                    MovieId = 6, // "Do Not Mention the Cause of Death"
                },
                new GenreBiskopina()
                {
                    Id = 9,
                    GenreId = 2, // War
                    MovieId = 6, // "Do Not Mention the Cause of Death"
                },
                new GenreBiskopina()
                {
                    Id = 10,
                    GenreId = 1, // Drama
                    MovieId = 5, // "When I Am Dead and Gone"
                },
                new GenreBiskopina()
                {
                    Id = 11,
                    GenreId = 4, // Art House
                    MovieId = 5, // "When I Am Dead and Gone"
                },
                new GenreBiskopina()
                {
                    Id = 12,
                    GenreId = 1, // Drama
                    MovieId = 4, // "It Rains in My Village"
                },
                new GenreBiskopina()
                {
                    Id = 13,
                    GenreId = 2, // War
                    MovieId = 4, // "It Rains in My Village"
                },
                new GenreBiskopina()
                {
                    Id = 14,
                    GenreId = 1, // Drama
                    MovieId = 3, // "WR: Mysteries of the Organism"
                },
                new GenreBiskopina()
                {
                    Id = 15,
                    GenreId = 4, // Art House
                    MovieId = 3, // "WR: Mysteries of the Organism"
                },
                new GenreBiskopina()
                {
                    Id = 16,
                    GenreId = 3, // Political
                    MovieId = 3, // "WR: Mysteries of the Organism"
                },
                new GenreBiskopina()
                {
                    Id = 17,
                    GenreId = 1, // Drama
                    MovieId = 2, // "The Rats Woke up"
                },
                new GenreBiskopina()
                {
                    Id = 18,
                    GenreId = 3, // Political
                    MovieId = 2, // "The Rats Woke up"
                },
                new GenreBiskopina()
                {
                    Id = 19,
                    GenreId = 1, // Drama
                    MovieId = 1, // "Three"
                },
                new GenreBiskopina()
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
                    UserId = 1,
                    CategoryId = 3,
                    Question = "I wish there were more subtitles",
                    Answer = "We’re planning to add support for more languages in the near future, so you can expect more subtitle options soon!",
                    Displayed = true
                },
                new QA()
                {
                    Id = 3,
                    UserId = 5,
                    CategoryId = 3,
                    Question = "Do not make design more modern please.",
                    Answer = "Do not worry! We will be keeping design.",
                    Displayed = true
                },
                new QA()
                {
                    Id = 4,
                    UserId = 3,
                    CategoryId = 4,
                    Question = "Can we get a forum feature in this app?",
                    Answer = "It's in progress, it will be available once it's tested and ready.",
                    Displayed = true
                },
                new QA()
                {
                    Id = 5,
                    UserId = 4,
                    CategoryId = 1,
                    Question = "How long did it take you to make this app?",
                    Answer = "At least 7 months.",
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
                }
         );
        }

        private void SeedWatchlistMovies(ModelBuilder modelBuilder)
        {
            modelBuilder.Entity<BioskopinaWatchlist>().HasData(
                // User 1
                new BioskopinaWatchlist()
                {
                    Id = 1,
                    MovieId = 1,
                    WatchlistId = 1,
                    WatchStatus = "Watching",
                    DateStarted = new DateTime(2025, 7, 11),
                    DateFinished = null
                },
                new BioskopinaWatchlist()
                {
                    Id = 2,
                    MovieId = 2,
                    WatchlistId = 3,
                    WatchStatus = "Completed",
                    DateStarted = new DateTime(2025, 3, 10),
                    DateFinished = new DateTime(2025, 4, 10)
                },

                // User 2
                new BioskopinaWatchlist()
                {
                    Id = 3,
                    MovieId = 3,
                    WatchlistId = 2,
                    WatchStatus = "On Hold",
                    DateStarted = new DateTime(2025, 7, 11),
                    DateFinished = null
                },
                new BioskopinaWatchlist()
                {
                    Id = 4,
                    MovieId = 4,
                    WatchlistId = 4,
                    WatchStatus = "Dropped",
                    
                    DateStarted = new DateTime(2025, 7, 11),
                    DateFinished = null
                }
         
            );
        }


        private void SeedLists(ModelBuilder modelBuilder)
        {
            modelBuilder.Entity<List>().HasData(
                new List()
                {
                    Id = 1,
                    UserId = 2,
                    Name = "Favorites",
                    DateCreated = new DateTime(2025, 7, 11)
                }
         );
        }

        private void SeedListBioskopina(ModelBuilder modelBuilder)
        {
            modelBuilder.Entity<BioskopinaList>().HasData(
                new BioskopinaList()
                {
                    Id = 1,
                    ListId = 1,
                    MovieId = 3,
                },
                new BioskopinaList()
                {
                    Id = 2,
                    ListId = 1,
                    MovieId = 2,
                },
                new BioskopinaList()
                {
                    Id = 3,
                    ListId = 1,
                    MovieId = 1,
                }
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
                    RatingValue = 9,
                    ReviewText = "Interesting...",
                    DateAdded = new DateTime(2025, 7, 21)
                },
                new Rating()
                {
                    Id = 3,
                    UserId = 2,
                    MovieId = 4,
                    RatingValue = 8,
                    ReviewText = "Visually stunning and emotionally resonants truly immersive experience",
                    DateAdded = new DateTime(2025, 7, 21)
                },
                new Rating()
                {
                    Id = 4,
                    UserId = 2,
                    MovieId = 2,
                    RatingValue = 1,
                    ReviewText = "It is quite slow to be honest, not my cup of tea.",
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
                    UserId = 2,
                    Amount = 20,
                    DateDonated = new DateTime(2025, 1, 11),
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
                    UserId = 2,
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
                    UserId = 1, // Admin UserId
                    Content = "Three",
                    LikesCount = 5,
                    DislikesCount = 0,
                    DatePosted = new DateTime(2024, 7, 11),
                   
                    VideoUrl = "https://www.youtube.com/watch?v=i4pAWKQvORM" // Example video URL
                },
                new Post()
                {
                    Id = 2,
                    UserId = 1, // Admin UserId
                    Content = "The Rats Woke Up",
                    LikesCount = 3,
                    DislikesCount = 1,
                    DatePosted = new DateTime(2024, 7, 11),
                    
                    VideoUrl = "https://www.youtube.com/watch?v=9RXs4tnExXM" // Video URL
                },
                new Post()
                {
                    Id = 3,
                    UserId = 1, // Admin UserId
                    Content = "WR: Mysteries of the Organism",
                    LikesCount = 7,
                    DislikesCount = 0,
                    DatePosted = new DateTime(2024, 7, 11),
                    
                    VideoUrl = "https://www.youtube.com/watch?v=-NORCsCIBak" // Video URL
                },
                new Post()
                {
                    Id = 4,
                    UserId = 1, // Admin UserId
                    Content = "It Rains in My Village",
                    LikesCount = 4,
                    DislikesCount = 0,
                    DatePosted = new DateTime(2024, 7, 11),
                 
                    VideoUrl = "https://www.youtube.com/watch?v=pQ16Puo9A2Q" // Video URL
                },
                new Post()
                {
                    Id = 5,
                    UserId = 1, // Admin UserId
                    Content = "When I Am Dead and Gone",
                    LikesCount = 8,
                    DislikesCount = 2,
                    DatePosted = new DateTime(2024, 7, 11),
                   
                    VideoUrl = "https://www.youtube.com/watch?app=desktop&v=YiuMux8AR14&t=128s" // Video URL
                },
                new Post()
                {
                    Id = 6,
                    UserId = 1, // Admin UserId
                    Content = "Uzrok smrti ne pominjati",
                    LikesCount = 2,
                    DislikesCount = 0,
                    DatePosted = new DateTime(2024, 7, 11),
                  
                    VideoUrl = "https://www.youtube.com/watch?v=S5hR5h1q0gA" // Video URL
                },
                new Post()
                {
                    Id = 7,
                    UserId = 1, // Admin UserId
                    Content = "I Even Met Happy Gypsies",
                    LikesCount = 9,
                    DislikesCount = 0,
                    DatePosted = new DateTime(2024, 7, 11),
                    
                    VideoUrl = "https://www.youtube.com/watch?v=Op0wuHguS4c" // Video URL
                },
                new Post()
                {
                    Id = 8,
                    UserId = 1, // Admin UserId
                    Content = "Early Works",
                    LikesCount = 4,
                    DislikesCount = 1,
                    DatePosted = new DateTime(2024, 7, 11),
                    
                    VideoUrl = "https://www.youtube.com/watch?v=H6Djqv0fwn4" // Video URL
                },
                new Post()
                {
                    Id = 9,
                    UserId = 1, // Admin UserId
                    Content = "The Ambush",
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
