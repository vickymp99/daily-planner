import 'package:daily_planner/core/constant/app_enum.dart';
import 'package:daily_planner/core/constant/daily_palnner_style.dart';
import 'package:daily_planner/core/utils/common_widgets.dart';
import 'package:flutter/material.dart';

class NewDayPlannerWidget extends StatelessWidget {
  NewDayPlannerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16.0, 12.0, 16.0, 0.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            _NewDayTextField(
              hintText: "Title",
              fn: (value) {
                print(value);
              },
            ),
            _NewDayTextField(
              hintText: "Description",
              fn: (value) {
                print(value);
              },
            ),
            _NewDayTextField(
              hintText: "Date",
              type: NewDayAddType.date,
              fn: (value) {
                print(value);
              },
              enable: false,
              onTap: (value) {
                print(value);
              },
            ),
            _NewDayTextField(
              hintText: "time",
              enable: false,
              type: NewDayAddType.time,
              fn: (value) {},
            ),
          ],
        ),
      ),
    );
  }
}

class _NewDayTextField extends StatelessWidget {
  final Icon? icon;
  final String? hintText;
  ValueChanged<String> fn;
  final bool enable;
  final NewDayAddType? type;
  final Function(String)? onTap;

  _NewDayTextField({
    required this.fn,
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
            ? () => openDateTime(context, type!)
            : null,
        child: TextField(
          controller: _textFieldController,
          onChanged: fn,
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

  openDateTime(BuildContext context, NewDayAddType type) {
    switch (type) {
      case NewDayAddType.time:
        timeChooseSheet(context);
        break;
      case NewDayAddType.date:
        pickDate(context);
        break;
    }
  }

  // pick a date to plan
  pickDate(BuildContext context) async {
    await showDatePicker(
      context: context,
      firstDate: DateTime(2020, 1, 1),
      lastDate: DateTime(2030, 1, 1),
    ).then((val) {
      if (val != null && onTap != null) {
        _textFieldController.text = val.toString();
        onTap!(_textFieldController.text);
      }
    });
  }

  // choose the time for particular action
  timeChooseSheet(BuildContext context) async {
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
                              (index) => Text("${_time[index]}",
                                style: DailyPlannerStyle.normalText(fontWeight: FontWeight.bold,fontSize: 70),),
                        ),
                      ),
                    ),
                    SizedBox(width: 32.0,),
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
            SizedBox(height: 50,)
          ],
        );

      },
    );
  }
}
