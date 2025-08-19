# BIOSKOPINA - Black wave 
Bioskopina is a movie app dedicated to showcasing films from the ex-Yugoslavian region, especially those connected to the influential   Black Wave cinema movement. The app allows users to discover movie trailers, share posts with links to where certain movies can be found, and engage with a community passionate about this unique film heritage.
This platform brings together movie lovers to explore, discuss, and celebrate the rich legacy of ex-Yugoslavian cinema in a modern, interactive way.


Setup Instructions
## Backend
Open a terminal inside the backend or project root folder.

Set your Stripe secret key:


set STRIPE_SECRET_KEY=YourSecretKey
Run Docker Compose to build and start backend services:


docker-compose up -d --build

## Payment Integration Notes

The backend correctly sends integer values for payment amounts. ✅  

When testing with **Stripe in test mode**, some small amounts may fail due to Stripe's internal restrictions:

- **Minimum charge enforcement:** Stripe enforces a minimum charge amount in EUR.
- **Currency conversion effect:** Small BAM amounts (e.g., 20 BAM) may convert to less than Stripe’s minimum in EUR, causing the payment to fail.
- **Larger amounts work:** Payments of 200 BAM or more reliably pass, because they exceed Stripe’s minimum charge after conversion.

In **production mode**, Stripe accepts any reasonable BAM amount ≥1, so this limitation only affects test mode.

**Key takeaway:**  
The backend works correctly. Any failures for small amounts during testing are due to Stripe’s test-mode rules, not my code.

## Flutter Desktop Application
Credentials:
Username: administrator ( in the document made by professor it was told if we have many users that we should name username admin for web and korisnik for mobile as far as I can recall)
Password: test


## Flutter Mobile Application
Credentials:
Username: korisnik
Password: test


To use your Stripe publishable key, run:


flutter run --dart-define=STRIPE_PUBLISHABLE_KEY=YourPublishableKey
### Stripe Testing
Use Stripe’s test card number for payment testing:
4242 4242 4242 4242
Use any valid future expiration date, CVC, and ZIP code.

Additional Notes
Email notifications may sometimes be routed to Gmail’s spam folder—please check there if you don’t see them in your inbox.

BIOSKOPINA builds on the passion for app development I cultivated in my previous project,https://github.com/sarapecoCS/yugofilm

Some UI principles and features are inspired by that project, while BIOSKOPINA represents an enhanced and more refined application based on lessons learned.
