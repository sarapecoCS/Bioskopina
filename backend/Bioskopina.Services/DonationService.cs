using AutoMapper;
using Bioskopina.Model.Requests;
using Bioskopina.Model.SearchObjects;
using Bioskopina.Services.Database;
using Microsoft.EntityFrameworkCore;
using Stripe;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Bioskopina.Services
{
    public class DonationService : BaseCRUDService<Model.Donation, Database.Donation, DonationSearchObject, DonationInsertRequest, DonationUpdateRequest>, IDonationService
    {
        public DonationService(BioskopinaContext context, IMapper mapper) : base(context, mapper)
        {
        }

        public async override Task<Model.Donation> Insert(DonationInsertRequest insert)
        {
            string? transactionId = null;

            decimal amount = 0;

            var charges = await GetChargesByIntent(insert.PaymentIntentId);

            foreach (var charge in charges.Data)
            {
                if (charge.Captured)
                {
                    transactionId = charge.BalanceTransactionId;
                    amount = charge.AmountCaptured / 100m;
                    break;
                }
            }

            if (transactionId == null)
            {
                throw new Exception("Transaction ID is null");
            }

            var set = _context.Set<Donation>();
            Donation entity = _mapper.Map<Donation>(insert);
            entity.TransactionId = transactionId;
            set.Add(entity);

            await _context.SaveChangesAsync();

            return _mapper.Map<Model.Donation>(entity);
        }

        private async Task<StripeList<Charge>> GetChargesByIntent(string paymentIntentId)
        {
            var service = new ChargeService();
            var options = new ChargeListOptions()
            {
                PaymentIntent = paymentIntentId,
            };
            var list = await service.ListAsync(options);
            return list;
        }

        public override IQueryable<Donation> AddFilter(IQueryable<Donation> query, DonationSearchObject? search = null)
        {
            if(search?.UserId != null)
            {
                query = query.Where(donation => donation.UserId == search.UserId);
            }

            if (search?.NewestFirst == true)
            {
                query = query.OrderByDescending(donation => donation.DateDonated);
            }

            if (search?.LargestFirst == true)
            {
                query = query.OrderByDescending(donation => donation.Amount);
            }

            if (search?.SmallestFirst == true)
            {
                query = query.OrderBy(donation => donation.Amount);
            }

            if (search?.OldestFirst == true)
            {
                query = query.OrderBy(donation => donation.DateDonated);
            }

            return base.AddFilter(query, search);
        }

        public override IQueryable<Donation> AddInclude(IQueryable<Donation> query, DonationSearchObject? search = null)
        {
            if(search?.UserIncluded == true)
            {
                query = query.Include(d => d.User).ThenInclude(u => u.ProfilePicture);
            }
            
            return base.AddInclude(query, search);
        }
    }
}
