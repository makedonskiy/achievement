import 'package:achievement/enums.dart';
import 'package:achievement/model/remind_model.dart';
import 'package:achievement/utils/formate_date.dart';
import 'package:flutter/material.dart';

class RemindDay extends StatefulWidget {
  final RemindModel remindModel;

  final Function(RemindDay) callbackRemove;

  final _RemindDayState _remindDayState = _RemindDayState();
  RemindDateTime get remindDateTime => _remindDayState.remindDateTime;

  RemindDay({Key? key, required this.remindModel, required this.callbackRemove})
      : super(key: key);

  @override
  _RemindDayState createState() {
    return _remindDayState;
  }

  void setRangeDateTime(DateTimeRange dateTimeRange) {
    _remindDayState.setRangeDateTime(dateTimeRange);
  }
}

class _RemindDayState extends State<RemindDay> {
  TypeRepition _typeRepition = TypeRepition.none;
  late DateTimeRange _dateTimeRange;
  late RemindDateTime remindDateTime;

  void setRangeDateTime(DateTimeRange dateTimeRange) {
    _dateTimeRange = dateTimeRange;
    remindDateTime =
        RemindDateTime.fromDateTime(dateTime: _dateTimeRange.start);
  }

  @override
  Widget build(BuildContext context) {
    remindDateTime = widget.remindDateTime;
    return GestureDetector(
      onLongPress: () {
        widget.callbackRemove.call(widget);
      },
      child: Container(
        child: Card(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              DropdownButton<TypeRepition>(
                value: _typeRepition,
                onChanged: (TypeRepition? value) {
                  setState(() {
                    _typeRepition = value ?? TypeRepition.none;
                    widget.remindModel.typeRepition = _typeRepition;
                  });
                },
                items: TypeRepition.values
                    .map<DropdownMenuItem<TypeRepition>>((value) {
                  return DropdownMenuItem<TypeRepition>(
                    value: value,
                    child: Text(
                      _getStringRepition(value),
                      style: TextStyle(
                          color: Colors.black87,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
                  );
                }).toList(),
              ),
              _getRemindView(_typeRepition)
            ],
          ),
        ),
      ),
    );
  }

  Widget _getRemindView(TypeRepition typeRepition) {
    switch (typeRepition) {
      case TypeRepition.day:
        return _getDayRepition();
      case TypeRepition.week:
        return _getWeekRepition();
      case TypeRepition.month:
        return _getMonthRepition();
      default:
        return _getNoneRepition();
    }
  }

  Widget _getNoneRepition() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TextButton(
          onPressed: () async {
            var newRemindDate = await showDatePicker(
                context: context,
                initialDate: remindDateTime.dateTime,
                firstDate: _dateTimeRange.start,
                lastDate: _dateTimeRange.end);

            if (newRemindDate != null) {
              setState(() {
                remindDateTime =
                    RemindDateTime.fromDateTime(dateTime: newRemindDate);
                widget.remindModel.remindDateTime = remindDateTime;
              });
            }
          },
          child: Text(
            FormateDate.yearNumMonthDay(remindDateTime.dateTime),
            style: TextStyle(
                color: Colors.black87,
                fontSize: 20,
                fontWeight: FontWeight.bold),
          ),
        ),
        TextButton(
          onPressed: () async {
            var newTimeOfDay = await showTimePicker(
                context: context,
                initialTime: TimeOfDay.fromDateTime(remindDateTime.dateTime));

            if (newTimeOfDay != null) {
              setState(() {
                remindDateTime.hour = newTimeOfDay.hour;
                remindDateTime.minute = newTimeOfDay.minute;
                widget.remindModel.remindDateTime = remindDateTime;
              });
            }
          },
          child: Text(
            FormateDate.hour24Minute(remindDateTime.dateTime),
            style: TextStyle(
                color: Colors.black87,
                fontSize: 20,
                fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }

  Widget _getDayRepition() {
    return Container();
  }

  Widget _getWeekRepition() {
    return Container();
  }

  Widget _getMonthRepition() {
    return Container();
  }

  String _getStringRepition(TypeRepition typeRepition) {
    switch (typeRepition) {
      case TypeRepition.day:
        return 'каждый день';
      case TypeRepition.week:
        return 'каждую неделю';
      case TypeRepition.month:
        return 'каждый месяц';
      default:
        return 'без повтора';
    }
  }
}
