import 'package:agenda_app/core/theme/theme.dart';
import 'package:agenda_app/data/models/agenda_model.dart';
import 'package:agenda_app/logic/agenda_bloc/agenda_bloc.dart';
import 'package:agenda_app/logic/agenda_bloc/agenda_event.dart';
import 'package:agenda_app/logic/agenda_bloc/agenda_state.dart';
import 'package:agenda_app/presentation/Screens/member/add_member_screen.dart';
import 'package:agenda_app/presentation/widgets/custom_textfield/custom_textfield.dart';
import 'package:agenda_app/presentation/widgets/profile_stack/profile_stack.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

class AddAgendaScreen extends StatefulWidget {
  const AddAgendaScreen({super.key});

  @override
  AddAgendaScreenState createState() => AddAgendaScreenState();
}

class AddAgendaScreenState extends State<AddAgendaScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  late DateTime selectedDate;
  late DateTime startTime;
  late DateTime endTime;
  List<String> selectedMembers = [];

  late DateTime currentWeeksStart;
  int weekOffset = 0;

  @override
  void initState() {
    super.initState();
    selectedDate = DateTime.now();
    startTime = DateTime.now();
    endTime = DateTime.now().add(const Duration(hours: 1));
    currentWeeksStart = getWeekStart(DateTime.now());
  }

  @override
  Widget build(BuildContext context) {
    DateTime currentWeek =
        currentWeeksStart.add(Duration(days: weekOffset * 7));
    List<DateTime> weekDays = getWeekDays(currentWeek);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Add Agenda',
          style: AppTextStyles.headingStyleW,
        ),
        backgroundColor: AppColors.primaryBlue,
        actions: [
          TextButton(
              onPressed: _saveAgenda,
              child: Text(
                'Save',
                style: AppTextStyles.headerBoldW,
              ))
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(DateFormat('dd MMM').format(selectedDate),
                    style: AppTextStyles.headingStyleB),
                const SizedBox(
                  height: 16,
                ),
                SizedBox(
                  height: 70,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        onPressed: weekOffset > 0
                            ? () {
                                setState(() {
                                  weekOffset--;
                                });
                              }
                            : null,
                        icon: Icon(Icons.arrow_back_ios),
                        color:
                            weekOffset == 0 ? AppColors.grey : AppColors.black,
                      ),
                      Flexible(
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: 7,
                          itemBuilder: (context, index) {
                            final date = weekDays[index];
                            final isSelected = date.day == selectedDate.day &&
                                date.month == selectedDate.month &&
                                date.year == selectedDate.year;
                            final isPast = date.year < DateTime.now().year ||
                                (date.year == DateTime.now().year &&
                                    date.month < DateTime.now().month) ||
                                (date.year == DateTime.now().year &&
                                    date.month == DateTime.now().month &&
                                    date.day < DateTime.now().day);

                            return GestureDetector(
                              onTap: isPast
                                  ? null
                                  : () {
                                      setState(() {
                                        selectedDate = date;
                                      });
                                    },
                              child: Container(
                                width: 45,
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 4),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? AppColors.primaryBlue
                                      : AppColors.transparent,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      DateFormat('E').format(date)[0],
                                      style: TextStyle(
                                        color: isSelected
                                            ? AppColors.textTertiary
                                            : (isPast
                                                ? AppColors.textSecondary
                                                : AppColors.selectedColor),
                                      ),
                                    ),
                                    Text(
                                      date.day.toString(),
                                      style: TextStyle(
                                        color: isSelected
                                            ? AppColors.textTertiary
                                            : (isPast
                                                ? AppColors.textSecondary
                                                : AppColors.selectedColor),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          setState(() {
                            weekOffset++;
                          });
                        },
                        icon: Icon(Icons.arrow_forward_ios),
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                Text('Title', style: AppTextStyles.headerBoldB),
                SizedBox(
                  height: 5,
                ),
                CustomTextfield(
                  controller: _titleController,
                  hintText: 'Title',
                  textCapitalization: TextCapitalization.sentences,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a title';
                    }
                    return null;
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () async {
                          final TimeOfDay? time = await showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.fromDateTime(startTime),
                            builder: (BuildContext context, Widget? child) {
                              return Theme(
                                data: Theme.of(context).copyWith(
                                  timePickerTheme: TimePickerThemeData(
                                    backgroundColor: Colors.white,
                                    hourMinuteColor:
                                        WidgetStateColor.resolveWith(
                                            (states) => Colors.blue.shade100),
                                    hourMinuteTextColor:
                                        WidgetStateColor.resolveWith(
                                            (states) => AppColors.primaryBlue),
                                    dialHandColor: AppColors.primaryBlue,
                                    dialBackgroundColor: Colors.white,
                                    entryModeIconColor: AppColors.primaryBlue,
                                    cancelButtonStyle: ButtonStyle(
                                      foregroundColor: WidgetStateProperty.all(
                                          AppColors.primaryBlue),
                                    ),
                                    confirmButtonStyle: ButtonStyle(
                                      foregroundColor: WidgetStateProperty.all(
                                          AppColors.primaryBlue),
                                    ),
                                  ),
                                ),
                                child: child!,
                              );
                            },
                          );

                          if (time != null) {
                            setState(() {
                              startTime = DateTime(
                                selectedDate.year,
                                selectedDate.month,
                                selectedDate.day,
                                time.hour,
                                time.minute,
                              );
                            });
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 12, horizontal: 16),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: AppColors.grey),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Start Time',
                                    style: AppTextStyles.headerBoldB,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    DateFormat('hh:mm a').format(startTime),
                                    style: AppTextStyles.body,
                                  ),
                                ],
                              ),
                              Icon(Icons.access_time,
                                  color: AppColors.primaryBlue),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: GestureDetector(
                        onTap: () async {
                          final TimeOfDay? time = await showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.fromDateTime(endTime),
                            builder: (BuildContext context, Widget? child) {
                              return Theme(
                                data: Theme.of(context).copyWith(
                                  timePickerTheme: TimePickerThemeData(
                                    backgroundColor: Colors.white,
                                    hourMinuteColor:
                                        WidgetStateColor.resolveWith(
                                            (states) => Colors.blue.shade100),
                                    hourMinuteTextColor:
                                        WidgetStateColor.resolveWith(
                                            (states) => AppColors.primaryBlue),
                                    dialHandColor: AppColors.primaryBlue,
                                    dialBackgroundColor: Colors.white,
                                    entryModeIconColor: AppColors.primaryBlue,
                                    cancelButtonStyle: ButtonStyle(
                                      foregroundColor: WidgetStateProperty.all(
                                          AppColors.primaryBlue),
                                    ),
                                    confirmButtonStyle: ButtonStyle(
                                      foregroundColor: WidgetStateProperty.all(
                                          AppColors.primaryBlue),
                                    ),
                                  ),
                                ),
                                child: child!,
                              );
                            },
                          );

                          if (time != null) {
                            setState(() {
                              endTime = DateTime(
                                selectedDate.year,
                                selectedDate.month,
                                selectedDate.day,
                                time.hour,
                                time.minute,
                              );
                            });
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 12, horizontal: 16),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: AppColors.grey),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'End Time',
                                    style: AppTextStyles.headerBoldB,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    DateFormat('hh:mm a').format(endTime),
                                    style: AppTextStyles.body,
                                  ),
                                ],
                              ),
                              Icon(Icons.access_time,
                                  color: AppColors.primaryBlue),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 15,
                ),
                Text('Description', style: AppTextStyles.headerBoldB),
                const SizedBox(
                  height: 5,
                ),
                CustomTextfield(
                  controller: _descriptionController,
                  textCapitalization: TextCapitalization.sentences,
                  hintText: 'Description',
                  maxLines: 5,
                  onChanged: (_) {
                    _formKey.currentState?.validate();
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a description';
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 15,
                ),
                buildMembersSection()
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<DateTime> getWeekDays(DateTime start) {
    return List.generate(7, (index) => start.add(Duration(days: index)));
  }

  DateTime getWeekStart(DateTime date) {
    return date.subtract(Duration(days: date.weekday % 7));
  }

  Widget buildMembersSection() {
    if (selectedMembers.isEmpty) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Presenters/Speakers', style: AppTextStyles.headerBoldB),
          const SizedBox(height: 12),
          InkWell(
            onTap: () => _navigateToAddMembers(),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.grey.withOpacity(0.3)),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: AppColors.primaryBlue.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.person_add_outlined,
                      color: AppColors.primaryBlue,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Add Presenters',
                          style: AppTextStyles.headerBoldB,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Select presenters for this agenda',
                          style: TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.chevron_right,
                    color: AppColors.grey,
                  ),
                ],
              ),
            ),
          ),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Presenters/Speakers', style: AppTextStyles.headerBoldB),
        const SizedBox(height: 12),
        InkWell(
          onTap: () => _navigateToAddMembers(),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.grey.withOpacity(0.3)),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                SizedBox(
                  height: 40,
                  child: ProfileStack(
                    selectedMembers: selectedMembers,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    '${selectedMembers.length} ${selectedMembers.length == 1 ? 'Presenter' : 'Presenters'} selected',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 14,
                    ),
                  ),
                ),
                Icon(
                  Icons.edit,
                  color: AppColors.primaryBlue,
                  size: 20,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _navigateToAddMembers() async {
    final result = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) =>
            AddMembersScreen(selectedMembers: selectedMembers),
      ),
    );

    if (result != null && result is List<String>) {
      setState(() {
        selectedMembers = result;
      });
    }
  }

  _saveAgenda() {
    if (_formKey.currentState?.validate() ?? false) {
      final title = _titleController.text;
      final description = _descriptionController.text;

      if (selectedMembers.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Please select at least one presenter')),
        );
        return;
      }

      // Create full DateTime objects for comparison
      final newStartDateTime = DateTime(
        selectedDate.year,
        selectedDate.month,
        selectedDate.day,
        startTime.hour,
        startTime.minute,
      );

      final newEndDateTime = DateTime(
        selectedDate.year,
        selectedDate.month,
        selectedDate.day,
        endTime.hour,
        endTime.minute,
      );

      if (newStartDateTime.isAfter(newEndDateTime)) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('End time must be after start time')),
        );
        return;
      }

      // Get current state to access existing agendas
      final state = context.read<AgendaBloc>().state;
      if (state is AgendaLoaded) {
        if (_hasTimeOverlap(state.agenda)) {
          _showOverlapErrorDialog();
          return;
        }

        final agenda = AgendaModel(
          id: const Uuid().v4(),
          title: title,
          date: selectedDate,
          description: description,
          startTime: startTime,
          endTime: endTime,
          members: selectedMembers,
        );

        context.read<AgendaBloc>().add(AddAgenda(agenda));
        Navigator.of(context).pop();
      }
    }
  }

  void _showOverlapErrorDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Time Slot Conflict', style: AppTextStyles.headerBoldB),
          content: Text(
            'There is already an agenda scheduled during this time period. Please select a different time slot.',
            style: TextStyle(color: AppColors.textSecondary),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('OK', style: TextStyle(color: AppColors.primaryBlue)),
            ),
          ],
        );
      },
    );
  }

  bool _hasTimeOverlap(List<AgendaModel> existingAgendas) {
    // Create complete DateTime objects for new agenda
    final newStart = DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
      startTime.hour,
      startTime.minute,
    );

    final newEnd = DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
      endTime.hour,
      endTime.minute,
    );

    // Check overlap with all existing agendas
    for (var agenda in existingAgendas) {
      final existingStart = DateTime(
        agenda.date.year,
        agenda.date.month,
        agenda.date.day,
        agenda.startTime.hour,
        agenda.startTime.minute,
      );

      final existingEnd = DateTime(
        agenda.date.year,
        agenda.date.month,
        agenda.date.day,
        agenda.endTime.hour,
        agenda.endTime.minute,
      );

      // Check if there's any overlap in the time ranges
      if (newStart.isBefore(existingEnd) && newEnd.isAfter(existingStart)) {
        return true;
      }
    }
    return false;
  }
}
