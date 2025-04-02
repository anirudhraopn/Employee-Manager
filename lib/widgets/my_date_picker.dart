import 'dart:math';

import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:calendar_date_picker2/calendar_date_picker2.dart' as c;
import 'package:date_picker_plus/date_picker_plus.dart';
import 'package:employee_manager/constants/app_colors.dart';
import 'package:employee_manager/constants/app_constants.dart';
import 'package:employee_manager/screens/employee_details/employee_details_screen.dart';
import 'package:employee_manager/utils/app_date_utils.dart';
import 'package:employee_manager/utils/app_icons.dart';
import 'package:employee_manager/widgets/app_button.dart';
import 'package:employee_manager/widgets/save_cancel_row.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MyDatePicker extends StatefulWidget {
  const MyDatePicker({
    super.key,
    required this.initialDate,
    required this.firstDate,
    required this.lastDate,
    required this.quickButtonList,
  });

  final DateTime? initialDate;
  final DateTime firstDate, lastDate;
  final List<QuickButton> quickButtonList;

  @override
  State<MyDatePicker> createState() => _MyDatePickerState();
}

class _MyDatePickerState extends State<MyDatePicker> {
  late final ValueNotifier<DateTime?> currentDateNotifier;

  final ValueNotifier<int> selectedQuickButton = ValueNotifier(-1);

  @override
  void initState() {
    super.initState();
    currentDateNotifier = ValueNotifier(widget.initialDate);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Dialog(
      backgroundColor: Colors.white,
      insetPadding: EdgeInsets.symmetric(horizontal: min(20, size.width * 0.1)),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ValueListenableBuilder<DateTime?>(
          valueListenable: currentDateNotifier,
          builder: (context, currentDate, child) => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              GridView.count(
                crossAxisCount: 2,
                childAspectRatio: 4,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                shrinkWrap: true,
                children: List.generate(
                  widget.quickButtonList.length,
                  (index) {
                    final item = widget.quickButtonList[index];
                    return ValueListenableBuilder<int>(
                      valueListenable: selectedQuickButton,
                      builder: (context, value, child) => AppButton(
                        text: item.text,
                        isPrimary: index == value,
                        onTap: () {
                          item.onTap(currentDateNotifier);
                          selectedQuickButton.value = index;
                        },
                      ),
                    );
                  },
                ),
              ),
              calPic2(currentDate),
              Row(
                children: [
                  Expanded(
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        spacing: 8,
                        children: [
                          SvgPicture.asset(AppIcons.calendar),
                          Text(
                            currentDate == null
                                ? 'No date'
                                : AppDateUtils.formatDate(currentDate),
                            textAlign: TextAlign.left,
                          ),
                        ],
                      ),
                    ),
                  ),
                  SaveCancelRow(
                    onSave: () {
                      Navigator.pop(context, currentDate);
                    },
                    onCancel: () {
                      Navigator.pop(context);
                    },
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  CalendarDatePicker2 calPic2(DateTime? currentDate) {
    return CalendarDatePicker2(
      value: [
        currentDate,
      ],
      displayedMonthDate: DateTime.now(),
      onValueChanged: (value) {
        selectedQuickButton.value = -1;
        currentDateNotifier.value = value.first;
      },
      config: CalendarDatePicker2Config(
        calendarType: CalendarDatePicker2Type.single,
        calendarViewMode: CalendarDatePicker2Mode.day,
        weekdayLabelBuilder: ({isScrollViewTopHeader, required weekday}) {
          return Text(AppConstants.weekdays[weekday]);
        },
        selectedDayHighlightColor: AppColors.primaryColor,
        daySplashColor: Colors.transparent,
        customModePickerIcon: SizedBox(),
      ),
    );
  }

  void onDateChanged(DateTime value) {
    currentDateNotifier.value = value;
  }
}

class QuickButton {
  final String text;
  final ValueChanged<ValueNotifier<DateTime?>> onTap;

  QuickButton({
    required this.text,
    required this.onTap,
  });
}
