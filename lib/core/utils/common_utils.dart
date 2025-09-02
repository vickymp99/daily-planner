import 'package:daily_planner/core/constant/app_enum.dart';
import 'package:daily_planner/core/constant/app_theme.dart';
import 'package:daily_planner/core/constant/daily_planner_style.dart';
import 'package:daily_planner/core/utils/hive_service.dart';
import 'package:firebase_auth/firebase_auth.dart' show FirebaseAuth;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:intl/intl.dart';

void appDebugPrint(Object? object) {
  if (kDebugMode) {
    print(object);
  }
}

class CommonUtils {
  static snackBar(BuildContext context, {String? msg}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsetsGeometry.all(8.0),
        content: Text(msg ?? ""),
      ),
    );
  }

  static String formatDate(String formatString, String date) {
    DateTime localDate = DateTime.parse(date);
    return DateFormat(formatString).format(localDate);
  }

  static logOut(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            "Are you sure to logout?",
            style: DailyPlannerStyle.fieldLabelText(),
          ),
          actionsAlignment: MainAxisAlignment.spaceAround,
          actions: [
            ElevatedButton(
              onPressed: () => Navigator.pop(context, false),
              style: ElevatedButton.styleFrom(
                // backgroundColor: Colors.redAccent,
              ),
              child: Text(
                "Cancel",
                style: DailyPlannerStyle.normalText(color: Colors.white),
              ),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              style: ElevatedButton.styleFrom(
                // backgroundColor: Colors.redAccent,
              ),
              child: Text(
                "Log out",
                style: DailyPlannerStyle.normalText(color: Colors.white),
              ),
            ),
          ],
        );
      },
    ).then((val) async {
      if (val != null && val) {
        await HiveService.userPlan.clear();
        _signOutApp();
      }
    });
  }

  // user signout
  static _signOutApp() async {
    final user = FirebaseAuth.instance;
    String? otherSignOut;
    for (final providerProfile in user.currentUser!.providerData) {
      otherSignOut = providerProfile.providerId;
    }
    await user.signOut();
    if (otherSignOut == "google.com") {
      await GoogleSignIn().signOut();
    }
  }
}

class CommonAppbar extends StatelessWidget {
  final String title;
  final bool isLogOut;
  final bool showThemeIcon;
  final bool leadingIcon;

  const CommonAppbar({
    super.key,
    required this.title,
    this.isLogOut = false,
    this.showThemeIcon = false,
    this.leadingIcon = false,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0.0,
      actionsPadding: EdgeInsetsGeometry.fromLTRB(0.0, 8.0, 16.0, 8.0),
      scrolledUnderElevation: 0,
      // shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(
      //     bottomLeft: Radius.circular(16.0),bottomRight: Radius.circular(16.0))),
      // backgroundColor: Colors.yellow,
      backgroundColor: Colors.transparent,
      leading: leadingIcon
          ? Padding(
              padding: const EdgeInsets.only(left: 12.0),
              child: Icon(Icons.arrow_back_ios, size: 30),
            )
          : null,
      actions: [
        if (isLogOut)
          IconButton(
            iconSize: 40,
            onPressed: () => CommonUtils.logOut(context),
            icon: Icon(Icons.person),
            tooltip: "log out",
          ),
        if (showThemeIcon)
          IconButton(
            iconSize: 40,
            onPressed: () => BlocProvider.of<ThemeCubit>(context).toggleTheme(),
            icon: Icon(Icons.dark_mode),

            tooltip: "switch theme",
          ),
      ],

      title: Text(title, style: DailyPlannerStyle.appbarTitle()),
    );
  }
}

class CommonTextField extends StatelessWidget {
  final Icon? icon;
  final String? hintText;
  ValueChanged<String>? onChanged;
  final bool enable;
  final TextFieldActionType? type;
  final Function(String)? onTap;
  final bool showFromTodayDate;

  CommonTextField({
    super.key,
    this.onChanged,
    this.icon,
    this.hintText,
    this.enable = true,
    this.onTap,
    this.type,
    this.showFromTodayDate = false,
  });

  final _textFieldController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: InkWell(
        onTap: !enable && type != null
            ? () => _openDateTime(context, type!)
            : null,
        child: TextField(
          controller: _textFieldController,
          onChanged: onChanged,
          enabled: enable,
          maxLength: 50,
          decoration: InputDecoration(
            counterText: !enable ? "" : null,
            prefixIcon: icon,
            labelText: hintText,
            labelStyle: DailyPlannerStyle.hintText(color: Colors.red.shade800),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
        ),
      ),
    );
  }

  _openDateTime(BuildContext context, TextFieldActionType type) {
    switch (type) {
      case TextFieldActionType.time:
        _timeChooseSheet(context);
        break;
      case TextFieldActionType.date:
        _pickDate(context);
        break;
    }
  }

  // pick a date to plan
  _pickDate(BuildContext context) async {
    await showDatePicker(
      context: context,
      firstDate: showFromTodayDate
          ? DateTime.now()
          : DateTime(DateTime.now().year - 50, 1, 1),
      lastDate: DateTime(DateTime.now().year + 50, 12, 31),
    ).then((val) {
      if (val != null && onTap != null) {
        _textFieldController.text = CommonUtils.formatDate(
          "d MMM yyyy",
          val.toString(),
        );
        onTap!(_textFieldController.text);
      }
    });
  }

  _timeChooseSheet(BuildContext context) async {
    final TextEditingController controller = TextEditingController();
    String timeString = "AM";
    await showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (innerContext, innerState) {
            return AlertDialog(
              title: Text("Choose time"),
              content: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 100,
                    height: 50,
                    child: TextField(
                      controller: controller,
                      showCursor: false,
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.number,
                      style: DailyPlannerStyle.normalText(fontSize: 20),
                    ),
                  ),
                  SizedBox(width: 16),
                  InkWell(
                    onTap: () {
                      innerState(() {
                        timeString == "AM"
                            ? timeString = "PM"
                            : timeString = "AM";
                      });
                    },
                    child: Container(
                      width: 100,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: Colors.grey, // Color of the border
                          width: 2.0, // Thickness of the border
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              timeString,
                              style: DailyPlannerStyle.normalText(fontSize: 20),
                            ),

                            // Icon(Icons.keyboard_arrow_up),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              actions: [
                ElevatedButton(
                  onPressed: () {
                    try {
                      // condition for check text value must there and it is integer
                      if (controller.text.isNotEmpty &&
                          int.parse(controller.text.trim()).runtimeType ==
                              int) {
                        // condition for check value must be 1 above and should be less than 12
                        if (int.parse(controller.text) >= 1 &&
                            (int.parse(controller.text) <= 12)) {
                          Navigator.pop(context, {
                            "time": controller.text.trim(),
                            "denote": timeString,
                          });
                        }
                        // tell user to give value between 1 and 12
                        else {
                          CommonUtils.snackBar(
                            context,
                            msg: "Enter correct value between 1 and 12",
                          );
                        }
                      }
                    } catch (e) {
                      appDebugPrint(e);
                      CommonUtils.snackBar(context, msg: "Enter correct value");
                    }
                  },
                  child: Text("Ok"),
                ),
              ],
              icon: Align(
                alignment: Alignment.topRight,
                child: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(Icons.cancel, size: 35),
                ),
              ),
            );
          },
        );
      },
    ).then((val) {
      if (val != null && onTap != null) {
        appDebugPrint("$val");
        _textFieldController.text = "${val["time"]} ${val["denote"]}";
        onTap!(_textFieldController.text);
      }
    });
  }
}

class CommonElevatedButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  const CommonElevatedButton({
    super.key,
    required this.onPressed,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          // backgroundColor: Colors.redAccent.shade200,
        ),
        child: Text(text, style: DailyPlannerStyle.buttonText()),
      ),
    );
  }
}
