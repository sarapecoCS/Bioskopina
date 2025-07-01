using AutoMapper;
using Bioskopina.Model;
using Bioskopina.Model.Requests;
using Bioskopina.Model.SearchObjects;
using Bioskopina.Services.Database;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Security.Cryptography;
using System.Text;
using System.Threading.Tasks;

namespace Bioskopina.Services
{
    public class UserService : BaseCRUDService<Model.User, Database.User, UserSearchObject, UserInsertRequest, UserUpdateRequest>, IUserService
    {
        protected BioskopinaContext _context;
        //protected IRabbitMQProducer _rabbitMQProducer;

        public UserService(BioskopinaContext context, IMapper mapper, IRabbitMQProducer rabbitMQProducer)
            : base(context, mapper)
        {
            _context = context;
            //_rabbitMQProducer = rabbitMQProducer;
        }

        public override async Task BeforeInsert(Database.User entity, UserInsertRequest insert)
        {
            if (insert.Password != insert.PasswordConfirmation)
                throw new Exception("Passwords do not match.");

            entity.PasswordSalt = GenerateSalt();
            entity.PasswordHash = GenerateHash(entity.PasswordSalt, insert.Password);

            if (entity.DateJoined == default)
                entity.DateJoined = DateTime.Now;
        }

        public override async Task AfterInsert(Database.User entity, UserInsertRequest insert)
        {
            if (!string.IsNullOrEmpty(insert.Email))
            {
                Model.Email email = new()
                {
                    Subject = "Welcoming email",
                    Content = "Welcome to Bioskopina! We're thrilled to have you join our community!",
                    Recipient = insert.Email,
                    Sender = "bioskopina0@gmail.com",
                };
                //_rabbitMQProducer.SendMessage(email);
            }
        }

        public override IQueryable<Database.User> AddInclude(IQueryable<Database.User> query, UserSearchObject? search = null)
        {
            if (search?.RolesIncluded == true)
            {
                query = query.Include(user => user.UserRoles)
                             .ThenInclude(userRole => userRole.Role);
            }

            if (search?.WatchlistsIncluded == true)
            {
                query = query.Include(watchlist => watchlist.Watchlists)
                            .ThenInclude(watchlists => watchlists.BioWatchlists);
            }

            if (search?.ProfilePictureIncluded == true)
            {
                query = query.Include(profilePicture => profilePicture.ProfilePicture);
            }

            return base.AddInclude(query, search);
        }

        public static string GenerateSalt()
        {
            using var provider = new RNGCryptoServiceProvider();
            var byteArray = new byte[16];
            provider.GetBytes(byteArray);
            return Convert.ToBase64String(byteArray);
        }

        public static string GenerateHash(string salt, string password)
        {
            byte[] src = Convert.FromBase64String(salt);
            byte[] bytes = Encoding.Unicode.GetBytes(password);
            byte[] dst = new byte[src.Length + bytes.Length];

            Buffer.BlockCopy(src, 0, dst, 0, src.Length);
            Buffer.BlockCopy(bytes, 0, dst, src.Length, bytes.Length);

            using HashAlgorithm algorithm = HashAlgorithm.Create("SHA1");
            byte[] inArray = algorithm.ComputeHash(dst);
            return Convert.ToBase64String(inArray);
        }

        public async Task<Model.User> Login(string username, string password)
        {
            var entity = await _context.Users.Include("UserRoles.Role")
                                             .FirstOrDefaultAsync(x => x.Username == username);

            if (entity == null)
                return null;

            var hash = GenerateHash(entity.PasswordSalt, password);

            if (hash != entity.PasswordHash)
                return null;

            return _mapper.Map<Model.User>(entity);
        }

        public override IQueryable<Database.User> AddFilter(IQueryable<Database.User> query, UserSearchObject? search = null)
        {
            if (!string.IsNullOrWhiteSpace(search?.Username))
                query = query.Where(x => x.Username == search.Username);

            if (!string.IsNullOrWhiteSpace(search?.Email))
                query = query.Where(x => x.Email == search.Email);

            if (!string.IsNullOrWhiteSpace(search?.FirstName))
                query = query.Where(x => x.FirstName.StartsWith(search.FirstName));

            if (!string.IsNullOrWhiteSpace(search?.LastName))
                query = query.Where(x => x.LastName.StartsWith(search.LastName));

            if (!string.IsNullOrWhiteSpace(search?.FTS))
            {
                query = query.Where(x => (x.FirstName + " " + x.LastName).Contains(search.FTS)
                                       || (x.LastName + " " + x.FirstName).Contains(search.FTS)
                                       || x.Username.Contains(search.FTS));
            }

            if (search?.Id != null)
                query = query.Where(x => x.Id == search.Id);

            return base.AddFilter(query, search);
        }

        public async Task<List<UserRegistrationData>> GetUserRegistrations(int days, bool groupByMonths = false)
        {
            DateTime startDate = DateTime.Today.AddDays(-days);
            DateTime endDate = DateTime.Today;

            var userRegistrations = await _context.Users
                .Where(user => user.DateJoined >= startDate)
                .ToListAsync();

            var registrationsByDate = new Dictionary<DateTime, int>();

            if (!groupByMonths)
            {
                for (DateTime date = startDate; date <= endDate; date = date.AddDays(1))
                {
                    int registrationsCount = userRegistrations
                        .Count(user => user.DateJoined.Date == date);
                    registrationsByDate[date] = registrationsCount;
                }
            }
            else
            {
                for (DateTime date = startDate; date <= endDate; date = date.AddMonths(1))
                {
                    int registrationsCount = userRegistrations
                        .Count(user => user.DateJoined.Month == date.Month
                                    && user.DateJoined.Year == date.Year);
                    registrationsByDate[date] = registrationsCount;
                }
            }

            var userRegistrationDataList = registrationsByDate
                .Select(pair => new UserRegistrationData
                {
                    DateJoined = pair.Key,
                    NumberOfUsers = pair.Value
                })
                .ToList();

            return userRegistrationDataList;
        }

        public async Task ChangePassword(ChangePasswordRequest request)
        {
            var user = await _context.Users.FindAsync(request.UserId);

            if (user == null)
                throw new Exception($"User with ID {request.UserId} not found.");

            var providedHash = GenerateHash(user.PasswordSalt, request.OldPassword);

            if (user.PasswordHash != providedHash)
                throw new Exception("Invalid password.");

            user.PasswordSalt = GenerateSalt();
            user.PasswordHash = GenerateHash(user.PasswordSalt, request.NewPassword);

            _context.Update(user);
            await _context.SaveChangesAsync();
        }

        public async Task DeleteUser(int userId)
        {
            var user = _context.Users
                .Include(u => u.Posts)
                    .ThenInclude(p => p.Comments)
                .FirstOrDefault(u => u.Id == userId);

            if (user != null)
            {
                _context.Comments.RemoveRange(user.Posts.SelectMany(p => p.Comments));
                _context.Posts.RemoveRange(user.Posts);
                _context.Users.Remove(user);

                try
                {
                    await _context.SaveChangesAsync();
                }
                catch (Exception ex)
                {
                    Console.WriteLine($"Error deleting user: {ex.Message}");
                    throw;
                }
            }
        }
    }
}
