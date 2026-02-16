import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

import '../../../core/services/app_services.dart';
import '../../../core/services/notifications/reminder_destination_localizations.dart';
import '../../../core/services/notifications/reminder_destinations.dart';
import '../../../core/widgets/app_sheet.dart';
import '../../../data/models/reminder_item.dart';
import '../../../l10n/app_localizations.dart';

class ReminderFormSheet extends StatefulWidget {
  const ReminderFormSheet({super.key, this.existing});

  final ReminderItem? existing;

  @override
  State<ReminderFormSheet> createState() => _ReminderFormSheetState();
}

class _ReminderFormSheetState extends State<ReminderFormSheet> {
  static const _titleField = 'title';
  static const _descriptionField = 'description';
  static const _labelField = 'label';
  static const _enabledField = 'enabled';
  static const _timeField = 'time';
  static const _weekdaysField = 'weekdays';
  static const _openDestinationField = 'openDestination';
  static const _destinationField = 'destination';

  final _formKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isEdit = widget.existing != null;
    final initial = _initialValues();

    return AppSheetLayout(
      title: isEdit
          ? l10n.settingsRemindersEditTitle
          : l10n.settingsRemindersCreateTitle,
      titleStyle: Theme.of(context).textTheme.titleLarge,
      mainAxisSize: MainAxisSize.max,
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      children: [
        Expanded(
          child: FormBuilder(
            key: _formKey,
            initialValue: initial,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FormBuilderTextField(
                    name: _titleField,
                    decoration: InputDecoration(
                      labelText: l10n.settingsRemindersFieldTitle,
                      border: const OutlineInputBorder(),
                      isDense: true,
                    ),
                    validator: (valueCandidate) {
                      if ((valueCandidate ?? '').trim().isEmpty) {
                        return l10n.settingsRemindersRequired;
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),
                  FormBuilderTextField(
                    name: _descriptionField,
                    decoration: InputDecoration(
                      labelText: l10n.settingsRemindersFieldDescription,
                      border: const OutlineInputBorder(),
                      isDense: true,
                    ),
                    maxLines: 2,
                  ),
                  const SizedBox(height: 12),
                  FormBuilderTextField(
                    name: _labelField,
                    decoration: InputDecoration(
                      labelText: l10n.settingsRemindersFieldLabel,
                      border: const OutlineInputBorder(),
                      isDense: true,
                    ),
                    validator: (valueCandidate) {
                      if ((valueCandidate ?? '').trim().isEmpty) {
                        return l10n.settingsRemindersRequired;
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),
                  FormBuilderSwitch(
                    name: _enabledField,
                    title: Text(l10n.settingsRemindersEnabled),
                    initialValue: initial[_enabledField] as bool,
                  ),
                  const SizedBox(height: 8),
                  FormBuilderField<TimeOfDay>(
                    name: _timeField,
                    initialValue: initial[_timeField] as TimeOfDay,
                    validator: (valueCandidate) {
                      if (valueCandidate == null) {
                        return l10n.settingsRemindersRequired;
                      }
                      return null;
                    },
                    builder: (field) {
                      final selected =
                          field.value ?? const TimeOfDay(hour: 9, minute: 0);
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ListTile(
                            contentPadding: EdgeInsets.zero,
                            title: Text(l10n.settingsRemindersFieldTime),
                            subtitle: Text(
                              '${selected.hour.toString().padLeft(2, '0')}:${selected.minute.toString().padLeft(2, '0')}',
                            ),
                            trailing: const Icon(Icons.schedule_outlined),
                            onTap: () async {
                              final picked = await showTimePicker(
                                context: context,
                                initialTime: selected,
                              );
                              if (picked != null) {
                                field.didChange(picked);
                              }
                            },
                          ),
                          if (field.hasError)
                            Padding(
                              padding: const EdgeInsets.only(top: 4),
                              child: Text(
                                field.errorText ?? '',
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.error,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 8),
                  FormBuilderFilterChips<int>(
                    name: _weekdaysField,
                    spacing: 8,
                    runSpacing: 8,
                    showCheckmark: false,
                    initialValue: List<int>.from(
                      initial[_weekdaysField] as List<int>,
                    ),
                    decoration: InputDecoration(
                      labelText: l10n.settingsRemindersFieldRepeat,
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.all(8.0),
                    ),
                    validator: (valueCandidate) {
                      if ((valueCandidate ?? <int>[]).isEmpty) {
                        return l10n.settingsRemindersRequired;
                      }
                      return null;
                    },
                    options: [
                      FormBuilderChipOption(
                        value: DateTime.sunday,
                        child: Text(l10n.settingsWeekdaySunShort),
                      ),
                      FormBuilderChipOption(
                        value: DateTime.monday,
                        child: Text(l10n.settingsWeekdayMonShort),
                      ),
                      FormBuilderChipOption(
                        value: DateTime.tuesday,
                        child: Text(l10n.settingsWeekdayTueShort),
                      ),
                      FormBuilderChipOption(
                        value: DateTime.wednesday,
                        child: Text(l10n.settingsWeekdayWedShort),
                      ),
                      FormBuilderChipOption(
                        value: DateTime.thursday,
                        child: Text(l10n.settingsWeekdayThuShort),
                      ),
                      FormBuilderChipOption(
                        value: DateTime.friday,
                        child: Text(l10n.settingsWeekdayFriShort),
                      ),
                      FormBuilderChipOption(
                        value: DateTime.saturday,
                        child: Text(l10n.settingsWeekdaySatShort),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  FormBuilderSwitch(
                    name: _openDestinationField,
                    title: Text(l10n.settingsRemindersFieldOpenDestination),
                    initialValue: initial[_openDestinationField] as bool,
                    onChanged: (valueCandidate) {
                      if (valueCandidate == true) {
                        _formKey.currentState?.fields[_destinationField]
                            ?.didChange(
                              _formKey
                                      .currentState
                                      ?.fields[_destinationField]
                                      ?.value ??
                                  ReminderDestinations.newSale,
                            );
                      } else {
                        _formKey.currentState?.fields[_destinationField]
                            ?.didChange(null);
                      }
                      setState(() {});
                    },
                  ),
                  const SizedBox(height: 8),
                  FormBuilderDropdown<String>(
                    name: _destinationField,
                    initialValue: initial[_destinationField] as String?,
                    enabled:
                        _formKey
                                .currentState
                                ?.fields[_openDestinationField]
                                ?.value
                            as bool? ??
                        (initial[_openDestinationField] as bool),
                    decoration: InputDecoration(
                      labelText: l10n.settingsRemindersFieldDestination,
                      border: const OutlineInputBorder(),
                      isDense: true,
                    ),
                    items: reminderDestinationItems(
                      l10n,
                      ReminderDestinations.selectableIds,
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: FilledButton(
            onPressed: _save,
            child: Text(l10n.settingsRemindersSaveAction),
          ),
        ),
      ],
    );
  }

  Map<String, dynamic> _initialValues() {
    final existing = widget.existing;
    final destination = existing?.destinationId;
    return {
      _titleField: existing?.title ?? '',
      _descriptionField: existing?.description ?? '',
      _labelField: existing?.label ?? '',
      _enabledField: existing?.enabled ?? true,
      _timeField: TimeOfDay(
        hour: existing?.hour ?? 9,
        minute: existing?.minute ?? 0,
      ),
      _weekdaysField: List<int>.from(
        existing?.weekdays ?? <int>[DateTime.monday],
      ),
      _openDestinationField: destination != null,
      _destinationField: destination,
    };
  }

  Future<void> _save() async {
    final form = _formKey.currentState;
    if (form == null) return;

    final valid = form.saveAndValidate();
    if (!valid) return;

    final values = form.value;
    final title = (values[_titleField] as String? ?? '').trim();
    final description = (values[_descriptionField] as String? ?? '').trim();
    final label = (values[_labelField] as String? ?? '').trim();
    final enabled = values[_enabledField] as bool? ?? true;
    final time = values[_timeField] as TimeOfDay?;
    final weekdays = List<int>.from(values[_weekdaysField] as List? ?? <int>[])
      ..sort();
    final openDestination = values[_openDestinationField] as bool? ?? false;
    final destinationId = openDestination
        ? values[_destinationField] as String?
        : null;

    if (time == null || weekdays.isEmpty) return;

    if (widget.existing == null) {
      await AppServices.userReminders.create(
        title: title,
        description: description,
        label: label,
        enabled: enabled,
        hour: time.hour,
        minute: time.minute,
        weekdays: weekdays,
        destinationId: destinationId,
      );
    } else {
      final existing = widget.existing!;
      await AppServices.userReminders.update(
        existing.copyWith(
          title: title,
          description: description,
          label: label,
          enabled: enabled,
          hour: time.hour,
          minute: time.minute,
          weekdays: weekdays,
          destinationId: destinationId,
          clearDestinationId: destinationId == null,
        ),
      );
    }

    if (!mounted) return;
    Navigator.of(context).pop();
  }
}
