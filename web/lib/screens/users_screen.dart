import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../providers/user_profile_picture_provider.dart';
import '../providers/user_provider.dart';
import '../providers/user_role_provider.dart';
import '../screens/user_detail_screen.dart';
import '../widgets/form_builder_switch.dart';
import '../widgets/gradient_button.dart';
import '../widgets/master_screen.dart';
import '../widgets/pagination_buttons.dart';
import '../widgets/separator.dart';
import '../widgets/circular_progress_indicator.dart';
import '../models/search_result.dart';
import '../models/user.dart';
import '../models/user_role.dart';
import '../utils/colors.dart';
import '../utils/util.dart';
import 'dart:convert';
import 'dart:typed_data';

Uint8List imageFromBase64String(String base64String) {
  return base64Decode(base64String);
}

class UsersScreen extends StatefulWidget {
  const UsersScreen({super.key});

  @override
  State<UsersScreen> createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> {
  late UserProvider _userProvider;
  late Future<SearchResult<User>> _userFuture;
  final TextEditingController _userController = TextEditingController();
  final _userRoleFormKey = GlobalKey<FormBuilderState>();
  late UserRoleProvider _userRoleProvider;
  late UserProfilePictureProvider _userProfilePictureProvider;
  bool? adminRoleSelected;
  bool? userRoleSelected;

  int page = 0;
  int pageSize = 18;
  int totalItems = 0;
  bool isSearching = false;

  @override
  void initState() {
    _userProvider = context.read<UserProvider>();
    _userFuture = _userProvider.get(filter: {
      "ProfilePictureIncluded": "true",
      "Page": "$page",
      "PageSize": "$pageSize"
    });
    setTotalItems();

    _userRoleProvider = context.read<UserRoleProvider>();

    _userProfilePictureProvider = context.read<UserProfilePictureProvider>();
    _userProfilePictureProvider.addListener(() {
      _reloadUsers();
      setTotalItems();
    });

    _userProvider.addListener(() {
      _reloadUsers();
      setTotalItems();
    });

    super.initState();
  }

  void _reloadUsers() {
    if (mounted) {
      setState(() {
        _userFuture = _userProvider.get(filter: {
          "ProfilePictureIncluded": "true",
          "Page": "$page",
          "PageSize": "$pageSize"
        });
      });
    }
  }

  void setTotalItems() async {
    var userResult = await _userFuture;

    if (mounted) {
      setState(() {
        totalItems = userResult.count;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      titleWidget: Row(
        children: [
          Icon(Icons.people, size: 24),
          const SizedBox(width: 5),
          const Text("Users"),
        ],
      ),
      showSearch: true,
      onSubmitted: _search,
      controller: _userController,
      child: FutureBuilder<SearchResult<User>>(
        future: _userFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const MyProgressIndicator(); // Loading state
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}'); // Error state
          } else {
            // Data loaded successfully
            var userList = snapshot.data!.result;
            return SingleChildScrollView(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Wrap(
                      children: _buildUserCards(userList),
                    ),
                    MyPaginationButtons(
                        page: page,
                        pageSize: pageSize,
                        totalItems: totalItems,
                        fetchPage: fetchPage),
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }

  Future<void> fetchPage(int requestedPage) async {
    try {
      var result = await _userProvider.get(
        filter: {
          "FTS": isSearching ? _userController.text : null,
          "ProfilePictureIncluded": "true",
          "Page": "$requestedPage",
          "PageSize": "$pageSize",
        },
      );

      if (mounted) {
        setState(() {
          _userFuture = Future.value(result);
          page = requestedPage;
        });
      }
    } on Exception catch (e) {
      if (mounted) {
        showErrorDialog(context, e);
      }
    }
  }

  void _search(String searchText) async {
    try {
      var result = await _userProvider.get(filter: {
        "FTS": searchText,
        "ProfilePictureIncluded": "true",
        "Page": "0",
        "PageSize": "$pageSize",
      });

      if (mounted) {
        setState(() {
          _userFuture = Future.value(result);
          isSearching = true;
          totalItems = result.count;
          page = 0;
        });
      }
    } on Exception catch (e) {
      if (mounted) {
        showErrorDialog(context, e);
      }
    }
  }

  List<Widget> _buildUserCards(List<User> userList) {
    return List.generate(
      userList.length,
      (index) => _buildUserCard(userList[index]),
    );
  }

  Widget _buildUserCard(User user) {
    return Container(
      width: 230,
      height: 300,
      margin: const EdgeInsets.only(top: 20, left: 20, right: 0, bottom: 0),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15), color: Palette.darkPurple),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(15), topRight: Radius.circular(15)),
            child: (user.profilePicture != null)
                ? Image.memory(
                    imageFromBase64String(user.profilePicture!.profilePicture!),
                    width: 230,
                    height: 190,
                    fit: BoxFit.cover,
                    alignment: Alignment.center,
                  )
                : const SizedBox(
                    width: 230,
                    height: 190,
                  ),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Container(
                  alignment: Alignment.center,
                  child: Padding(
                    padding: const EdgeInsets.only(
                        bottom: 10, left: 35, right: 0, top: 5),
                    child: Text(
                      user.username!,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      textAlign: TextAlign.left,
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.only(top: 0, left: 0, right: 0, bottom: 0),
                child: _buildPopupMenu(user),
              ),
            ],
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
              child: SingleChildScrollView(
                controller: ScrollController(),
                child: Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(
                          top: 8, left: 0, right: 0, bottom: 0),
                      child: Row(
                        children: [
                          const Icon(Icons.person,
                              size: 20, color: Palette.lightPurple),
                          const SizedBox(width: 3),
                          Expanded(
                            child: Text("${user.firstName} ${user.lastName}",
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                    color: Palette.lightPurple, fontSize: 16)),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(
                          top: 5, left: 0, right: 0, bottom: 0),
                      child: Row(
                        children: [
                          Icon(Icons.calendar_today, size: 20),
                          const SizedBox(width: 3),
                          Tooltip(
                            message: "Date joined",
                            verticalOffset: 15,
                            child: Text(
                                DateFormat('MMM d, y').format(user.dateJoined!),
                                style: const TextStyle(
                                    color: Palette.lightPurple, fontSize: 16)),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  void _showOverlayForm(BuildContext context, User user) {
    showCupertinoModalPopup(
      context: context,
      barrierColor: Palette.black.withOpacity(0.5),
      builder: (BuildContext context) {
        return SizedBox(
          height: MediaQuery.of(context).size.height * 1,
          child: Stack(
            children: [
              _buildOverlayForm(context, user),
            ],
          ),
        );
      },
    );
  }

  Widget _buildOverlayForm(BuildContext context, User user) {
    return Positioned.fill(
      child: Material(
        color: Colors.transparent,
        child: Center(
          child: SingleChildScrollView(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: Palette.lightPurple.withOpacity(0.2)),
                color: Palette.darkPurple,
              ),
              padding: const EdgeInsets.only(
                  top: 5, bottom: 16, left: 16, right: 16),
              width: 500.0,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      IconButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          icon: const Icon(Icons.close_rounded))
                    ],
                  ),
                  Column(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: Image.memory(
                          imageFromBase64String(
                              user.profilePicture!.profilePicture!),
                          width: 300,
                          height: 200,
                          fit: BoxFit.cover,
                          alignment: Alignment.center,
                        ),
                      ),
                      Container(
                        constraints: const BoxConstraints(maxWidth: 300),
                        child: Text("${user.username}",
                            style: const TextStyle(fontSize: 20)),
                      ),
                    ],
                  ),
                  FormBuilder(
                    key: _userRoleFormKey,
                    child: Column(
                      children: [
                        StatefulBuilder(
                          builder: ((context, setState) {
                            return _buildSwitches(user);
                          }),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  GradientButton(
                    width: 100,
                    height: 30,
                    borderRadius: 50,
                    gradient: Palette.buttonGradient,
                    onPressed: () async {
                      _userRoleFormKey.currentState?.saveAndValidate();

                      if (_userRoleFormKey.currentState?.saveAndValidate() ==
                          true) {
                        try {
                          var userRoles = await _userRoleProvider
                              .get(filter: {"UserId": "${user.id}"});

// if userRole list has userRole with RoleId = 1 (Admin) and admin isn't selected -> delete userRole.id -> TESTED, WORKS
                          if (userRoles.result
                                  .any((userRole) => userRole.roleId == 1) &&
                              _userRoleFormKey.currentState
                                      ?.fields["administrator"]?.value ==
                                  false) {
                            await _userRoleProvider.delete(userRoles.result
                                .where((element) => element.roleId == 1)
                                .first
                                .id!);
                          }
// if userRole list doesn't have userRole with RoleId = 1 (Admin) and admin is selected -> add userRole with roleId 1 -> TESTED, WORKS
                          if (userRoles.result
                                  .every((userRole) => userRole.roleId != 1) &&
                              _userRoleFormKey.currentState
                                      ?.fields["administrator"]?.value ==
                                  true) {
                            Map<dynamic, dynamic> userRole = {
                              "userId": "${user.id}",
                              "roleId": 1,
                              "canReview": false,
                              "canAskQuestions": false,
                              "canParticipateInClubs": false
                            };
                            await _userRoleProvider.insert(userRole);
                          }

// if userRole list has userRole with RoleId = 1 (Admin) and admin is selected -> do nothing

// if userRole list doesn't have userRole with RoleId = 1 (Admin) and admin isn't selected -> do nothing

// if userRole list has userRole with RoleId = 2 (User) and User isn't selected -> delete userRole.id
                          if (userRoles.result
                                  .any((userRole) => userRole.roleId == 2) &&
                              _userRoleFormKey
                                      .currentState?.fields["user"]?.value ==
                                  false) {
                            await _userRoleProvider.delete(userRoles.result
                                .where((element) => element.roleId == 2)
                                .first
                                .id!);
                          }

// if userRole list has userRole with RoleId = 2 (User) and User is selected -> update userRole.id with appropriate permissions -> TESTED, WORKS
                          if (userRoles.result
                                  .any((userRole) => userRole.roleId == 2) &&
                              _userRoleFormKey
                                      .currentState?.fields["user"]?.value ==
                                  true) {
                            Map<dynamic, dynamic> userRole = {
                              "userId": "${user.id}",
                              "roleId": 2,
                              "canReview": _userRoleFormKey
                                  .currentState?.fields["canReview"]?.value,
                              "canAskQuestions": _userRoleFormKey.currentState
                                  ?.fields["canAskQuestions"]?.value,
                              "canParticipateInClubs": _userRoleFormKey
                                  .currentState
                                  ?.fields["canParticipateInClubs"]
                                  ?.value
                            };
                            await _userRoleProvider.update(
                                userRoles.result
                                    .where((element) => element.roleId == 2)
                                    .first
                                    .id!,
                                request: userRole);
                          }


                          if (userRoles.result
                                  .every((userRole) => userRole.roleId != 2) &&
                              _userRoleFormKey
                                      .currentState?.fields["user"]?.value ==
                                  true) {
                            Map<dynamic, dynamic> userRole = {
                              "userId": "${user.id}",
                              "roleId": 2,
                              "canReview": _userRoleFormKey
                                  .currentState?.fields["canReview"]?.value,
                              "canAskQuestions": _userRoleFormKey.currentState
                                  ?.fields["canAskQuestions"]?.value,
                              "canParticipateInClubs": _userRoleFormKey
                                  .currentState
                                  ?.fields["canParticipateInClubs"]
                                  ?.value
                            };
                            await _userRoleProvider.insert(userRole);
                          }

                          if (context.mounted) {
                            showInfoDialog(
                                context,
                                const Icon(Icons.task_alt,
                                    color: Palette.lightPurple, size: 50),
                                const Text(
                                  "Updated successfully!",
                                  textAlign: TextAlign.center,
                                ));
                          }
                        } on Exception catch (e) {
                          if (context.mounted) {
                            showErrorDialog(context, e);
                          }
                        }
                      } else {
                        showInfoDialog(
                            context,
                            const Icon(Icons.warning_rounded,
                                color: Palette.lightRed, size: 55),
                            const Text(
                              "There are validation errors.",
                              textAlign: TextAlign.center,
                            ));
                      }
                    },
                    child: const Text(
                      'Save',
                      style: TextStyle(
                          fontWeight: FontWeight.w500, color: Palette.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  FutureBuilder<SearchResult<UserRole>> _buildSwitches(User user) {
    return FutureBuilder<SearchResult<UserRole>>(
        future: _userRoleProvider.get(filter: {"userId": "${user.id}"}),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const MyProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else if (!snapshot.hasData || snapshot.data == null) {
            return const Text('No roles available');
          } else {
            // Data loaded successfully
            var userRoles = snapshot.data!.result;
            bool adminRoleValue = false;
            bool userRoleValue = false;

            if (userRoles.any((userRole) => userRole.roleId == 1)) {
              adminRoleValue = true;
            }
            if (userRoles.any((userRole) => userRole.roleId == 2)) {
              userRoleValue = true;
            }

            adminRoleSelected = adminRoleValue;
            userRoleSelected = userRoleValue;

            return Column(
              children: [
                MyFormBuilderSwitch(
                  initialValue: adminRoleValue,
                  name: "administrator",
                  title: const Text(
                    "Administrator role",
                    style: TextStyle(fontSize: 15, color: Palette.lightPurple),
                  ),
                  subtitle: Text(
                    "Gives user administrator privileges.",
                    style:
                        TextStyle(color: Palette.lightPurple.withOpacity(0.5)),
                  ),
                  onChanged: (val) {
                    _userRoleFormKey.currentState?.saveAndValidate();
                  },
                  validator: (val) {
                    if (val == null) {
                      return "This field cannot be empty.";
                    } else if (val == false &&
                        _userRoleFormKey.currentState?.fields['user']?.value ==
                            false) {
                      return "Must have either Administrator or User role turned on.";
                    }
                    return null;
                  },
                ),
                MySeparator(
                  width: 420,
                  opacity: 0.3,
                ),
                MyFormBuilderSwitch(
                  initialValue: userRoleValue,
                  name: "user",
                  title: const Text(
                    "User role",
                    style: TextStyle(fontSize: 15, color: Palette.lightPurple),
                  ),
                  subtitle: Text(
                    "Gives user basic privileges.",
                    style:
                        TextStyle(color: Palette.lightPurple.withOpacity(0.5)),
                  ),
                  onChanged: (value) {
                    //setState(() {
                    _userRoleFormKey.currentState?.saveAndValidate();
                    if (value != null) {
                      if (!value) {
                        _userRoleFormKey.currentState?.fields
                            .forEach((key, field) {
                          if (key != 'user' && key != 'administrator') {
                            field.didChange(false);
                          }
                        });
                      }
                    }
                    // });
                  },
                  validator: (val) {
                    if (val == null) {
                      return "This field cannot be empty.";
                    } else if (val == false &&
                        _userRoleFormKey
                                .currentState?.fields['administrator']?.value ==
                            false) {
                      return "Must have either Administrator or User role turned on.";
                    }
                    return null;
                  },
                ),
                MyFormBuilderSwitch(
                  initialValue: userRoles
                      .where((userRole) => userRole.roleId == 2)
                      .any((element) => element.canParticipateInClubs == true),
                  name: "canParticipateInClubs",
                  title: const Text(
                    "Club participation",
                    style: TextStyle(fontSize: 15, color: Palette.lightPurple),
                  ),
                  subtitle: Text(
                    "Allows the user to create clubs, make posts and comments.",
                    style:
                        TextStyle(color: Palette.lightPurple.withOpacity(0.5)),
                  ),
                  onChanged: (val) {
                    _userRoleFormKey.currentState?.saveAndValidate();
                  },
                  validator: (val) {
                    if (val == null) {
                      return "This field cannot be empty.";
                    } else if (val == true &&
                        _userRoleFormKey.currentState?.fields['user']?.value ==
                            false) {
                      return "Must have User role turned on.";
                    }
                    return null;
                  },
                ),
                MyFormBuilderSwitch(
                  initialValue: userRoles
                      .where((userRole) => userRole.roleId == 2)
                      .any((element) => element.canReview == true),
                  enabled: _userRoleFormKey.currentState?.fields["user"]?.value,
                  name: "canReview",
                  title: const Text(
                    "Reviewing",
                    style: TextStyle(fontSize: 15, color: Palette.lightPurple),
                  ),
                  subtitle: Text(
                    "Allows the user to leave reviews.",
                    style:
                        TextStyle(color: Palette.lightPurple.withOpacity(0.5)),
                  ),
                  onChanged: (val) {
                    _userRoleFormKey.currentState?.saveAndValidate();
                  },
                  validator: (val) {
                    if (val == null) {
                      return "This field cannot be empty.";
                    } else if (val == true &&
                        _userRoleFormKey.currentState?.fields['user']?.value ==
                            false) {
                      return "Must have User role turned on.";
                    }
                    return null;
                  },
                ),
                MyFormBuilderSwitch(
                  initialValue: userRoles
                      .where((userRole) => userRole.roleId == 2)
                      .any((element) => element.canAskQuestions == true),
                  //enabled: _userRoleFormKey.currentState?.fields["user"]?.value,
                  name: "canAskQuestions",
                  title: const Text(
                    "Help section participation",
                    style: TextStyle(fontSize: 15, color: Palette.lightPurple),
                  ),
                  subtitle: Text(
                    "Allows the user to ask administrator(s) questions.",
                    style:
                        TextStyle(color: Palette.lightPurple.withOpacity(0.5)),
                  ),
                  onChanged: (val) {
                    _userRoleFormKey.currentState?.saveAndValidate();
                  },
                  validator: (val) {
                    if (val == null) {
                      return "This field cannot be empty.";
                    } else if (val == true &&
                        _userRoleFormKey.currentState?.fields['user']?.value ==
                            false) {
                      return "Must have User role turned on.";
                    }
                    return null;
                  },
                ),
              ],
            );
          }
        });
  }

  Widget _buildPopupMenu(User user) {
    return PopupMenuButton<String>(
      tooltip: "Actions",
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
        side: BorderSide(color: Palette.lightPurple.withOpacity(0.3)),
      ),
      icon: const Icon(Icons.more_vert_rounded),
      splashRadius: 1,
      constraints: const BoxConstraints(minWidth: 10),
      padding: EdgeInsets.zero,
      color: const Color.fromRGBO(50, 48, 90, 1),
      itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
        PopupMenuItem<String>(
          child: ListTile(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
            hoverColor: Palette.lightPurple.withOpacity(0.1),
            leading: const Icon(Icons.text_snippet_rounded,
                color: Palette.lightPurple),
            title: const Text("See details",
                style: TextStyle(color: Palette.lightPurple)),
            subtitle: Text("See more information about this user",
                style: TextStyle(color: Palette.lightPurple.withOpacity(0.5))),
            onTap: () {
              Navigator.pop(context);
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => UserDetailScreen(user: user)));
            },
          ),
        ),
        PopupMenuItem<String>(
          child: ListTile(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
            hoverColor: Palette.lightPurple.withOpacity(0.1),
            leading: const Icon(
              Icons.settings_suggest_rounded,
              color: Palette.lightPurple,
              size: 24,
            ),
            title: const Text("User permissions",
                style: TextStyle(color: Palette.lightPurple)),
            subtitle: Text("Manage user's role and permissions",
                style: TextStyle(color: Palette.lightPurple.withOpacity(0.5))),
            onTap: () async {
              Navigator.pop(context);
              try {
                // Show loading indicator while fetching data
                showDialog(
                  context: context,
                  builder: (context) => const Center(
                    child: MyProgressIndicator(),
                  ),
                );

                SearchResult<UserRole> result = await _userRoleProvider.get(
                  filter: {"UserId": "${user.id}", "RoleIncluded": "true"},
                );

                if (context.mounted) {
                  Navigator.pop(context); //Closes loading indicator dialog
                }

                if (result.result.isEmpty) {
                } else {
                  if (context.mounted) {
                    _showOverlayForm(context, user);
                  }
                }
              } on Exception catch (e) {
                if (context.mounted) {
                  showErrorDialog(context, e);
                }
              }
            },
          ),
        ),
      ],
    );
  }
}
