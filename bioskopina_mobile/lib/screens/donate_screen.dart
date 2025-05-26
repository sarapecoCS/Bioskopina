import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:provider/provider.dart';

import '../models/payment_intent.dart' as payment_intent;
import '../providers/donation_provider.dart';
import '../providers/payment_intent_provider.dart';
import '../utils/util.dart';
import '../widgets/gradient_button.dart';
import '../widgets/separator.dart';
import '../models/donation.dart';
import '../models/search_result.dart';
import '../utils/colors.dart';
import '../widgets/donation_cards.dart';
import '../widgets/form_builder_text_field.dart';

class DonateScreen extends StatefulWidget {
  const DonateScreen({super.key});

  @override
  State<DonateScreen> createState() => _DonateScreenState();
}

class _DonateScreenState extends State<DonateScreen> {
  final GlobalKey<FormBuilderState> _donationFormKey =
      GlobalKey<FormBuilderState>();
  late final PaymentIntentProvider _paymentIntentProvider;
  late final DonationProvider _donationProvider;
  final FocusNode _focusNode1 = FocusNode();

  int page = 0;
  int pageSize = 10;

  final Map<String, dynamic> _filter = {
    "UserId": "${LoggedUser.user!.id}",
    "NewestFirst": true,
  };

  @override
  void dispose() {
    _focusNode1.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _paymentIntentProvider = context.read<PaymentIntentProvider>();
    _donationProvider = context.read<DonationProvider>();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double width = size.width;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildTop(),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              MySeparator(
                width: width * 0.8,
                borderRadius: 50,
                opacity: 0.7,
                paddingBottom: 10,
                paddingTop: 10,
              ),
            ],
          ),
          _buildBottom(),
        ],
      ),
    );
  }

  String _calculateAmount(double amount) {
    final calculatedAmount = amount.toInt() * 100;
    return calculatedAmount.toString();
  }

  Widget _buildTop() {
    Size size = MediaQuery.of(context).size;
    double screenWidth = size.width;

    return Column(
      children: [
        const SizedBox(height: 10),
        const Text("Support the developers!", style: TextStyle(fontSize: 20)),
        const SizedBox(height: 20),
        FormBuilder(
          key: _donationFormKey,
          child: MyFormBuilderTextField(
            focusNode: _focusNode1,
            width: screenWidth * 0.8,
            labelText: "Amount",
            name: "amount",
            fillColor: Palette.textFieldPurple.withOpacity(0.5),
            height: 43,
            borderRadius: 50,
            keyboardType: TextInputType.number,
            validator: (val) {
              if (val == null || val.isEmpty) {
                return "This field cannot be empty.";
              } else if (val != "" && !digitsOnly(val)) {
                return "Enter digits only.";
              }
              return null;
            },
          ),
        ),
        const SizedBox(height: 10),
        GradientButton(
            onPressed: () async {
              try {
                if (_donationFormKey.currentState?.saveAndValidate() == true) {
                  // Making payment intent
                  final amount = double.parse(
                      _donationFormKey.currentState?.fields["amount"]?.value);

                  var request = {"amount": _calculateAmount(amount)};

                  payment_intent.PaymentIntent paymentIntent =
                      await _paymentIntentProvider.createPaymentIntent(request);

                  await Stripe.instance.initPaymentSheet(
                      paymentSheetParameters: SetupPaymentSheetParameters(
                    paymentIntentClientSecret: paymentIntent.clientSecret,
                    style: ThemeMode.dark,
                    merchantDisplayName: 'My Anime Galaxy',
                    billingDetails: const BillingDetails(
                      address: Address(
                        country: 'BA',
                        city: '',
                        line1: '',
                        line2: '',
                        state: '',
                        postalCode: '',
                      ),
                    ),
                  ));

                  if (mounted) {
                    _displayPaymentSheet(context, paymentIntent);
                  }
                }
              } on Exception catch (e) {
                if (mounted) {
                  showErrorDialog(context, e);
                }

                print(e);
              }
            },
            width: 80,
            height: 25,
            gradient: Palette.buttonGradient,
            borderRadius: 50,
            child: const Text("Donate",
                style: TextStyle(
                    fontWeight: FontWeight.w500, color: Palette.white))),
      ],
    );
  }

  void _displayPaymentSheet(
      BuildContext context, payment_intent.PaymentIntent paymentIntent) async {
    try {
      await Stripe.instance.presentPaymentSheet().then((value) async {
        if (context.mounted) {
          showInfoDialog(
              context,
              const Icon(Icons.task_alt, color: Palette.lightPurple, size: 50),
              const SizedBox(
                width: 300,
                child: Text(
                  "Payment successful!",
                  textAlign: TextAlign.center,
                ),
              ));
        }

        double amount = double.parse(
            _donationFormKey.currentState?.fields["amount"]?.value);

        var donationInsert = {
          "userId": LoggedUser.user!.id,
          "amount": amount,
          "dateDonated": DateTime.now().toIso8601String(),
          "paymentIntentId": paymentIntent.id
        };

        await _donationProvider.insert(donationInsert);
      }).onError((error, stackTrace) {
        throw Exception(error);
      });
    } on StripeException catch (e) {
      if (e.toString().contains("cancel")) {
        if (context.mounted) {
          showInfoDialog(
              context,
              const Icon(Icons.warning_rounded,
                  color: Palette.lightRed, size: 55),
              const SizedBox(
                width: 300,
                child: Text(
                  "Payment canceled!",
                  textAlign: TextAlign.center,
                ),
              ));
        }
      } else {
        if (context.mounted) {
          showErrorDialog(context, e);
        }
      }
    } on Exception catch (e) {
      if (e.toString().contains("cancel")) {
        if (context.mounted) {
          showInfoDialog(
              context,
              const Icon(Icons.warning_rounded,
                  color: Palette.lightRed, size: 55),
              const SizedBox(
                width: 300,
                child: Text(
                  "Payment canceled!",
                  textAlign: TextAlign.center,
                ),
              ));
        }
      } else {
        if (context.mounted) {
          showErrorDialog(context, e);
        }
      }
    }
  }

  Widget _buildBottom() {
    return Column(
      children: [
        const Text(
          "Your donations",
          style: TextStyle(fontSize: 17),
        ),
        const SizedBox(height: 10),
        DonationCards(
          fetchDonations: fetchDonations,
          fetchPage: fetchPage,
          filter: _filter,
          page: page,
          pageSize: pageSize,
        ),
      ],
    );
  }

  Future<SearchResult<Donation>> fetchDonations() {
    return _donationProvider.get(filter: {
      ..._filter,
      "Page": "$page",
      "PageSize": "$pageSize",
    });
  }

  Future<SearchResult<Donation>> fetchPage(Map<String, dynamic> filter) {
    return _donationProvider.get(filter: filter);
  }
}
