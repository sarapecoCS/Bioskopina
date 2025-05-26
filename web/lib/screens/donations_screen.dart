import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import '../widgets/form_builder_dropdown.dart';
import 'package:provider/provider.dart';

import '../widgets/master_screen.dart';
import '../models/donation.dart';
import '../models/search_result.dart';
import '../providers/donation_provider.dart';
import '../utils/colors.dart';
import '../widgets/donation_cards.dart';

class DonationsScreen extends StatefulWidget {
  const DonationsScreen({super.key});

  @override
  State<DonationsScreen> createState() => _DonationsScreenState();
}

class _DonationsScreenState extends State<DonationsScreen> {
  late final DonationProvider _donationProvider;
  int page = 0;
  int pageSize = 30;
  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();

  Map<String, dynamic> _filter = {
    "NewestFirst": true,
    "UserIncluded": true,
  };

  @override
  void initState() {
    _donationProvider = context.read<DonationProvider>();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      showProfileIcon: false,
      showBackArrow: true,
      titleWidget: const Row(
        children: [
          Icon(Icons.credit_card_rounded, color: Palette.lightPurple),
          SizedBox(width: 5),
          Text("Donations"),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.only(top: 15),
        child: Column(
          children: [
            FormBuilder(
              key: _formKey,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  MyFormBuilderDropdown(
                    initialValue: "Latest first",
                    name: "sort",
                    borderRadius: 50,
                    width: 130,
                    icon: const Icon(Icons.filter_alt,
                        color: Palette.lightPurple),
                    dropdownColor: Palette.dropdownMenu,
                    onChanged: (val) {
                      if (val != null) {
                        if (val.contains("Latest")) {
                          setState(() {
                            _filter = {
                              "NewestFirst": true,
                              "UserIncluded": true,
                            };
                          });
                        } else if (val.contains("Largest")) {
                          setState(() {
                            _filter = {
                              "LargestFirst": true,
                              "UserIncluded": true,
                            };
                          });
                        } else if (val.contains("Smallest")) {
                          setState(() {
                            _filter = {
                              "SmallestFirst": true,
                              "UserIncluded": true,
                            };
                          });
                        } else if (val.contains("Oldest")) {
                          setState(() {
                            _filter = {
                              "OldestFirst": true,
                              "UserIncluded": true,
                            };
                          });
                        }
                      }
                    },
                    items: const [
                      DropdownMenuItem(
                          value: 'Latest first', child: Text('Latest first')),
                      DropdownMenuItem(
                          value: 'Oldest first', child: Text('Oldest first')),
                      DropdownMenuItem(
                          value: 'Largest first', child: Text('Largest first')),
                      DropdownMenuItem(
                          value: 'Smallest first',
                          child: Text('Smallest first')),
                    ],
                  )
                ],
              ),
            ),
            const SizedBox(height: 20),
            DonationCards(
              fetchDonations: fetchDonations,
              fetchPage: fetchPage,
              filter: _filter,
              page: page,
              pageSize: pageSize,
            ),
          ],
        ),
      ),
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
