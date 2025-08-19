using Bioskopina.Model;
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
            try
            {
                // Minimum 1 BAM
                if (request.Amount < 1)
                {
                    return BadRequest(new
                    {
                        errors = new { ERROR = new[] { "Amount must be at least 1 BAM" } }
                    });
                }

                long amountInFeninga = (long)Math.Round((double)request.Amount * 100);



                Console.WriteLine($"[DEBUG] Amount sent to Stripe (feninga): {amountInFeninga}");

                var options = new PaymentIntentCreateOptions
                {
                    Amount = amountInFeninga,
                    Currency = "bam" 
                };

                var service = new PaymentIntentService();
                var paymentIntent = await service.CreateAsync(options);

                return Ok(new PaymentIntentResponse
                {
                    Id = paymentIntent.Id,
                    ClientSecret = paymentIntent.ClientSecret
                });
            }
            catch (StripeException ex)
            {
                Console.WriteLine($"Stripe error: {ex.StripeError.Message}");
                return StatusCode(500, new
                {
                    errors = new { ERROR = new[] { ex.StripeError.Message } }
                });
            }
            catch (Exception ex)
            {
                Console.WriteLine($"Unexpected error: {ex}");
                return StatusCode(500, new
                {
                    errors = new { ERROR = new[] { "Server side error", ex.Message } }
                });
            }
        }
    }
}
