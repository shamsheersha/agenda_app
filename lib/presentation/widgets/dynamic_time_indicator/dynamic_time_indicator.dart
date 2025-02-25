import 'dart:async';
import 'package:flutter/material.dart';
import 'package:agenda_app/core/theme/theme.dart';
import 'package:agenda_app/data/enum/agenda_status.dart';

class DynamicTimeIndicator extends StatefulWidget {
  final DateTime startTime;
  final DateTime endTime;
  final bool isLastItem;

  const DynamicTimeIndicator({
    super.key,
    required this.startTime,
    required this.endTime,
    required this.isLastItem,
  });

  @override
  State<DynamicTimeIndicator> createState() => _DynamicTimeIndicatorState();
}

class _DynamicTimeIndicatorState extends State<DynamicTimeIndicator> {
  late Timer _timer;
  late AgendaStatus _currentStatus;

  @override
  void initState() {
    super.initState();
    _currentStatus = _calculateStatus();
    // Update status every minute
    _timer = Timer.periodic(const Duration(minutes: 1), (_) {
      final newStatus = _calculateStatus();
      if (newStatus != _currentStatus) {
        setState(() {
          _currentStatus = newStatus;
        });
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  AgendaStatus _calculateStatus() {
    final now = DateTime.now();
    
    if (now.isBefore(widget.startTime)) {
      return AgendaStatus.upcoming;
    } else if (now.isAfter(widget.startTime) && now.isBefore(widget.endTime)) {
      return AgendaStatus.inProgress;
    } else {
      return AgendaStatus.completed;
    }
  }

  Color _getBorderColor() {
    switch (_currentStatus) {
      case AgendaStatus.upcoming:
        return AppColors.textSecondary; // Grey for upcoming
      case AgendaStatus.inProgress:
      case AgendaStatus.completed:
        return AppColors.primaryBlue; // Blue for in progress and completed
    }
  }

  Color _getCircleFillColor() {
    switch (_currentStatus) {
      case AgendaStatus.upcoming:
      case AgendaStatus.inProgress:
        return AppColors.white; // White/empty for upcoming and in progress
      case AgendaStatus.completed:
        return AppColors.primaryBlue; // Filled blue for completed
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: _getBorderColor(),
              width: 2,
            ),
            color: _getCircleFillColor(),
          ),
        ),
        if (!widget.isLastItem)
          Container(
            width: 2,
            height: 40,
            color: AppColors.textSecondary,
          ),
      ],
    );
  }
}