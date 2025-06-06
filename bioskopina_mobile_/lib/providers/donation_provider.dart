import '../models/donation.dart';
import '../providers/base_provider.dart';

class DonationProvider extends BaseProvider<Donation> {
  DonationProvider() : super("Donation");

  @override
  Donation fromJson(data) {
    return Donation.fromJson(data);
  }
}
