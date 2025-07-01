using Bioskopina.Model;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Stripe;

namespace Bioskopina.Controllers
{
   
    [ApiController]
    public class PaymentIntentController : ControllerBase
    {
        [HttpPost("[controller]/CreatePaymentIntent")]
        public async Task<ActionResult<PaymentIntentResponse>> CreatePaymentIntent([FromBody] PaymentIntentRequest request)
        {
            var service = new PaymentIntentService();

            var options = new PaymentIntentCreateOptions
            {
                Amount = request.Amount,
                Currency = "BAM",
            };

            var paymentIntent = await service.CreateAsync(options);

            return new PaymentIntentResponse()
            {
                Id = paymentIntent.Id,
                ClientSecret = paymentIntent.ClientSecret
            };
        }
    }
}
