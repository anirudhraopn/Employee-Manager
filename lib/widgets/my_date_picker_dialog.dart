import 'dart:math';

import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:employee_manager/constants/app_colors.dart';
import 'package:employee_manager/constants/app_constants.dart';
import 'package:employee_manager/utils/app_date_utils.dart';
import 'package:employee_manager/utils/app_icons.dart';
import 'package:employee_manager/widgets/app_button.dart';
import 'package:employee_manager/widgets/save_cancel_row.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

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

  late final PageController controller;

  late final ValueNotifier<DateTime> currentPageNotifier;

  @override
  void initState() {
    super.initState();
    final months =
        (widget.lastDate.difference(widget.firstDate).inDays) * 12 ~/ 365;
    final currentDifference = (widget.lastDate
            .difference(widget.initialDate ?? DateTime.now())
            .inDays) *
        12 /
        365;
    final initialPage = months.round() - currentDifference.round();
    controller = PageController(initialPage: initialPage);
    currentDateNotifier = ValueNotifier(widget.initialDate);
    currentPageNotifier = ValueNotifier(widget.initialDate ?? DateTime.now());
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Dialog(
      backgroundColor: Colors.white,
      insetPadding: EdgeInsets.symmetric(horizontal: min(20, size.width * 0.1)),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: SizedBox(
        width: size.width < 400 ? null : 400,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
          child: ValueListenableBuilder<DateTime?>(
            valueListenable: currentDateNotifier,
            builder: (context, currentDate, child) => SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  GridView.extent(
                    physics: const NeverScrollableScrollPhysics(),
                    maxCrossAxisExtent: 400 / 2,
                    childAspectRatio: min(4, size.width * 0.1),
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    shrinkWrap: true,
                    children: List.generate(
                      widget.quickButtonList.length,
                      (index) {
                        final item = widget.quickButtonList[index];
                        return SizedBox(
                          height: max(50, 0),
                          child: ValueListenableBuilder<int>(
                            valueListenable: selectedQuickButton,
                            builder: (context, value, child) => AppButton(
                              text: item.text,
                              isPrimary: index == value,
                              onTap: () {
                                item.onTap(currentDateNotifier);
                                selectedQuickButton.value = index;
                                if (currentDateNotifier.value != null) {
                                  currentPageNotifier.value =
                                      currentDateNotifier.value!;
                                }
                              },
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  ValueListenableBuilder<DateTime>(
                    valueListenable: currentPageNotifier,
                    builder: (context, currentPage, child) {
                      bool disablePrevious =
                          currentPage.month == widget.firstDate.month &&
                              currentPage.year == widget.firstDate.year;
                      bool disableNext =
                          currentPage.month == widget.lastDate.month &&
                              currentPage.year == widget.lastDate.year;
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          spacing: 16,
                          children: [
                            const Spacer(),
                            GestureDetector(
                                onTap: disablePrevious ? null : previousPage,
                                child: const Icon(Icons.arrow_left)),
                            Expanded(
                              flex: 5,
                              child: Text(
                                DateFormat('MMMM yyyy').format(currentPage),
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                    fontWeight: FontWeight.w500, fontSize: 16),
                              ),
                            ),
                            IconButton(
                              onPressed: disableNext ? null : nextPage,
                              icon: const Icon(Icons.arrow_right),
                            ),
                            const Spacer(),
                          ],
                        ),
                      );
                    },
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  SizedBox(
                    height: 250,
                    child: myDatePicker(),
                  ),
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
                        onSave: () => Navigator.pop(context, currentDate),
                        onCancel: () => Navigator.pop(context),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void nextPage() async {
    if (!mounted) return;
    await controller.nextPage(duration: Durations.medium1, curve: Curves.ease);
  }

  void previousPage() async {
    if (!mounted) return;
    await controller.previousPage(
        duration: Durations.medium1, curve: Curves.ease);
  }

  CalendarDatePicker2 myDatePicker() {
    return CalendarDatePicker2(
      value: [
        currentDateNotifier.value,
      ],
      onDisplayedMonthChanged: (value) {
        currentPageNotifier.value = value;
      },
      displayedMonthDate: currentPageNotifier.value,
      onValueChanged: (value) {
        selectedQuickButton.value = -1;
        currentDateNotifier.value = value.first;
        // currentPageNotifier.value = value.first;
      },
      config: CalendarDatePicker2Config(
        calendarType: CalendarDatePicker2Type.single,
        calendarViewMode: CalendarDatePicker2Mode.day,
        weekdayLabelBuilder: ({isScrollViewTopHeader, required weekday}) {
          return Text(AppConstants.weekdays[weekday]);
        },
        selectedDayHighlightColor: AppColors.primaryColor,
        daySplashColor: Colors.transparent,
        customModePickerIcon: const SizedBox(),
        dayViewController: controller,
        dayModeScrollDirection: Axis.horizontal,
        hideScrollViewTopHeader: true,
        hideScrollViewMonthWeekHeader: true,
        animateToDisplayedMonthDate: false,
        centerAlignModePicker: true,
        disableMonthPicker: true,
        controlsHeight: 0,
        hideLastMonthIcon: true,
        hideNextMonthIcon: true,
        firstDate: widget.firstDate,
        lastDate: widget.lastDate,
      ),
    );
  }

  @override
  void dispose() {
    currentDateNotifier.dispose();
    currentPageNotifier.dispose();
    selectedQuickButton.dispose();
    super.dispose();
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
