import 'package:achievement/core/changed_date_time_range.dart';
import 'package:achievement/core/extensions.dart';
import 'package:achievement/ui/edit_achievement_page/edit_remind_card/form_edit_remind_card.dart';
import 'package:date_time_progress/date_time_progress.dart';
import 'package:flutter/material.dart';

class EditDateTimeProgress extends StatefulWidget {
  final List<FormEditRemindCard> remindCards;
  final ChangedDateTimeRange dateRangeAchievement;

  EditDateTimeProgress({
    required this.remindCards,
    required this.dateRangeAchievement,
  });

  @override
  _EditDateTimeProgressState createState() => _EditDateTimeProgressState();
}

class _EditDateTimeProgressState extends State<EditDateTimeProgress> {
  bool get _hasRemind => widget.remindCards.isNotEmpty;

  @override
  Widget build(BuildContext context) {
    return DateTimeProgress(
      start: widget.dateRangeAchievement.start,
      finish: widget.dateRangeAchievement.end,
      current: DateTime.now().getDate(),
      onChangeStart: (dateTime) async {
        FocusScope.of(context).unfocus();
        var selectDate = await showDatePicker(
            context: context,
            initialDate: dateTime,
            firstDate: DateTime(0),
            lastDate: widget.dateRangeAchievement.end);
        setState(() {
          if (selectDate != null) {
            widget.dateRangeAchievement.start = selectDate;
            if (_hasRemind) {
              widget.remindCards.removeWhere((remind) {
                var start = remind.remindModel.remindDateTime.dateTime
                    .compareTo(widget.dateRangeAchievement.start);
                var end = remind.remindModel.remindDateTime.dateTime
                    .compareTo(widget.dateRangeAchievement.end);
                return start < 0 || end > 0;
              });
            }
          }
        });
      },
      onChangeFinish: (dateTime) async {
        FocusScope.of(context).unfocus();
        var selectDate = await showDatePicker(
            context: context,
            initialDate: dateTime,
            firstDate: widget.dateRangeAchievement.start,
            lastDate: DateTime(9999));
        setState(() {
          if (selectDate != null) {
            widget.dateRangeAchievement.end = selectDate;
            if (_hasRemind) {
              widget.remindCards.removeWhere((remind) {
                var start = remind.remindModel.remindDateTime.dateTime
                    .compareTo(widget.dateRangeAchievement.start);
                var end = remind.remindModel.remindDateTime.dateTime
                    .compareTo(widget.dateRangeAchievement.end);
                return start < 0 || end > 0;
              });
            }
          }
        });
      },
    );
  }
}
