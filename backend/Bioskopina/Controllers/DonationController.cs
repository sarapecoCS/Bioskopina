using Bioskopina.Model.Requests;
using Bioskopina.Model.SearchObjects;
using Bioskopina.Services;
using Microsoft.AspNetCore.Mvc;

namespace Bioskopina.Controllers
{
    [ApiController]
    public class DonationController : BaseCRUDController<Model.Donation, DonationSearchObject, DonationInsertRequest, DonationUpdateRequest>
    {
        public DonationController(IDonationService service) : base(service)
        {

        }
    }
}