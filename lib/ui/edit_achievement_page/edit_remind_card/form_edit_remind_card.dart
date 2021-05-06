import 'package:achievement/core/changed_date_time_range.dart';
import 'package:achievement/model/remind_model.dart';
import 'package:achievement/ui/edit_achievement_page/edit_remind_card/edit_remind_card.dart';
import 'package:flutter/material.dart';

class FormEditRemindCard extends FormField<DateTime> {
  final RemindModel remindModel;
  final ChangedDateTimeRange dateTimeRange;

  FormEditRemindCard({
    Key? key,
    required this.remindModel,
    required this.dateTimeRange,
    ValueChanged<DateTime>? onChanged,
    FormFieldValidator<DateTime>? validator,
  }) : super(
          key: key,
          validator: validator,
          initialValue: remindModel.remindDateTime.dateTime,
          builder: (FormFieldState<DateTime> field) {
            /*final _FormRemindCardState state = field as _FormRemindCardState;
            final InputDecoration effectiveDecoration = (decoration ??
                    const InputDecoration())
                .applyDefaults(Theme.of(field.context).inputDecorationTheme);*/
            void onChangedHandler(DateTime value) {
              field.didChange(value);
              if (onChanged != null) {
                onChanged(value);
              }
            }

            return EditRemindCard(
              remindModel: remindModel,
              dateTimeRange: dateTimeRange,
              onChanged: onChangedHandler,
              textError: field.errorText,
            );
          },
        );

  @override
  _FormRemindCardState createState() => _FormRemindCardState();
}

class _FormRemindCardState extends FormFieldState<DateTime> {
  @override
  FormEditRemindCard get widget => super.widget as FormEditRemindCard;
}
