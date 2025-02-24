import 'package:agenda_app/logic/agenda_bloc/agenda_event.dart';
import 'package:agenda_app/presentation/widgets/dynamic_time_indicator/dynamic_time_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:agenda_app/core/theme/theme.dart';
import 'package:agenda_app/data/models/agenda_model.dart';
import 'package:agenda_app/logic/agenda_bloc/agenda_bloc.dart';
import 'package:agenda_app/logic/agenda_bloc/agenda_state.dart';
import 'package:agenda_app/presentation/Screens/agenda/add_agenda_screen.dart';
import 'package:agenda_app/presentation/widgets/profile_stack/profile_stack.dart';

class AgendaScreen extends StatelessWidget {
  const AgendaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AgendaBloc, AgendaState>(
      builder: (context, state) {
        if (state is AgendaLoading) {
          return Center(
            child: CircularProgressIndicator(
              color: AppColors.primaryBlue,
            ),
          );
        }

        if (state is AgendaLoaded) {
          final now = DateTime.now();
          final activeAgendas = state.agenda.where((agenda) {
            final agendaEndDateTime = DateTime(
              agenda.date.year,
              agenda.date.month,
              agenda.date.day,
              agenda.endTime.hour,
              agenda.endTime.minute,
            );
            return agendaEndDateTime.isAfter(now);
          }).toList();
          final groupedAgendas = _groupAgendaByDate(activeAgendas);
          final dates = groupedAgendas.keys.toList()..sort();

          return DefaultTabController(
            length: dates.length,
            child: Scaffold(
              backgroundColor: AppColors.white,
              appBar: AppBar(
                title: Text(
                  'Agendas',
                  style: AppTextStyles.headingStyleW,
                ),
                backgroundColor: AppColors.primaryBlue,
                actions: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CircleAvatar(
                      backgroundColor: AppColors.accent,
                      child: IconButton(
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const AddAgendaScreen(),
                          ));
                        },
                        icon: const Icon(Icons.add),
                        color: AppColors.iconSecondary,
                      ),
                    ),
                  )
                ],
                bottom: TabBar(
                  tabs: dates.map((date) {
                    final dayNumber = dates.indexOf(date) + 1;
                    return Tab(
                      text: 'Day $dayNumber',
                    );
                  }).toList(),
                  labelColor: AppColors.white,
                  indicatorColor: AppColors.white,
                ),
              ),
              body: TabBarView(
                children: dates.map((date) {
                  final dayAgendas = groupedAgendas[date]!;
                  return _buildRefreshableAgendaList(context, dayAgendas);
                }).toList(),
              ),
            ),
          );
        }

        if (state is AgendaError) {
          return Center(
            child: Text(state.message),
          );
        }

        return const SizedBox();
      },
    );
  }

  Widget _buildRefreshableAgendaList(
      BuildContext context, List<AgendaModel> agendas) {
    return RefreshIndicator(
      color: AppColors.primaryBlue,
      onRefresh: () async {
        context.read<AgendaBloc>().add(LoadAgendas());

        await Future.delayed(const Duration(milliseconds: 800));
      },
      child:
          agendas.isEmpty ? _buildEmptyListView() : _buildAgendaList(agendas),
    );
  }

  Widget _buildEmptyListView() {
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      children: [
        SizedBox(
          height: 300,
          child: Center(
            child: Text(
              'No agendas for this day',
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 16,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAgendaList(List<AgendaModel> agendas) {
    agendas.sort((a, b) {
      int dateComparison = a.date.compareTo(b.date);
      if (dateComparison != 0) return dateComparison;
      return a.startTime.compareTo(b.startTime);
    });

    return ListView.builder(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.all(16),
      itemCount: agendas.length,
      itemBuilder: (context, index) {
        final agenda = agendas[index];
        final isLastItem = index == agendas.length - 1;
        return _buildAgendaCard(agenda, isLastItem);
      },
    );
  }

  Widget _buildAgendaCard(AgendaModel agenda, bool isLastItem) {
    final startTime = DateFormat('h:mm a').format(agenda.startTime);
    final endTime = DateFormat('h:mm a').format(agenda.endTime);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 16, right: 16),
          child: DynamicTimeIndicator(
              startTime: DateTime(
                agenda.date.year,
                agenda.date.month,
                agenda.date.day,
                agenda.startTime.hour,
                agenda.startTime.minute,
              ),
              endTime: DateTime(
                agenda.date.year,
                agenda.date.month,
                agenda.date.day,
                agenda.endTime.hour,
                agenda.endTime.minute,
              ),
              isLastItem: isLastItem),
        ),
        Expanded(
          child: Card(
            margin: const EdgeInsets.only(bottom: 16),
            color: AppColors.white,
            shadowColor: AppColors.grey,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '$startTime - $endTime',
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        DateFormat('MMM d').format(agenda.date),
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    agenda.title,
                    style: AppTextStyles.headerBoldB,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    agenda.description,
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 32,
                    child: ProfileStack(
                      selectedMembers: agenda.members,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Map<DateTime, List<AgendaModel>> _groupAgendaByDate(
      List<AgendaModel> agendas) {
    final Map<DateTime, List<AgendaModel>> grouped = {};

    for (var agenda in agendas) {
      final date = DateTime(
        agenda.date.year,
        agenda.date.month,
        agenda.date.day,
      );

      if (!grouped.containsKey(date)) {
        grouped[date] = [];
      }
      grouped[date]!.add(agenda);
    }

    return grouped;
  }
}
