import 'package:daily_planner/core/constant/app_enum.dart';
import 'package:daily_planner/core/constant/app_theme.dart';
import 'package:daily_planner/core/constant/daily_palnner_style.dart';
import 'package:firebase_auth/firebase_auth.dart' show FirebaseAuth;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CommonUtils {
  static snackBar(BuildContext context, {String msg = "Error"}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsetsGeometry.all(8.0),
        content: Text("$msg"),
      ),
    );
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
    ).then((val) {
      if (val != null && val) {
        FirebaseAuth.instance.signOut();
      }
    });
  }
}

class CommonAppbar extends StatelessWidget {
  final String title;
  final bool isLogOut;
  final bool showThemeIcon;

  const CommonAppbar({
    super.key,
    required this.title,
    this.isLogOut = false,
    this.showThemeIcon = false,
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
      actions: [
        if (isLogOut)
          IconButton(
            iconSize: 40,
            onPressed: () => CommonUtils.logOut(context),
            icon: Icon(Icons.person),

            tooltip: "log out",
          ),
        if(showThemeIcon)
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

  CommonTextField({
    super.key,
    this.onChanged,
    this.icon,
    this.hintText,
    this.enable = true,
    this.onTap,
    this.type,
  });

  final _textFieldController = TextEditingController();
  final List<int> _time = [for (int i = 1; i <= 24; i++) i];

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
          decoration: InputDecoration(
            prefixIcon: icon,
            labelText: hintText,
            labelStyle: DailyPlannerStyle.hintText(color: Colors.red.shade800),
            border: OutlineInputBorder(
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
      firstDate: DateTime(DateTime.now().year - 50, 1, 1),
      lastDate: DateTime(DateTime.now().year + 50, 12, 31),
    ).then((val) {
      if (val != null && onTap != null) {
        _textFieldController.text = val.toString();
        onTap!(_textFieldController.text);
      }
    });
  }

  // choose the time for particular action
  _timeChooseSheet(BuildContext context) async {
    await showModalBottomSheet(
      backgroundColor: Colors.white,
      context: context,
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(50.0),
              child: SizedBox(
                height: 140,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Column(
                        children: List.generate(
                          _time.length,
                          (index) => Text(
                            "${_time[index]}",
                            style: DailyPlannerStyle.normalText(
                              fontWeight: FontWeight.bold,
                              fontSize: 70,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 32.0),
                    // SingleChildScrollView(
                    //   scrollDirection: Axis.vertical,
                    //   child: Column(
                    //     children: List.generate(
                    //       _time.length,
                    //           (index) => Text("${_time[index]}"),
                    //     ),
                    //   ),
                    // ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 50),
          ],
        );
      },
    );
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
