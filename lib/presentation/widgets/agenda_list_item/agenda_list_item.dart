// // lib/widgets/agenda_list_item.dart

// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';

// enum AgendaStatus {
//   completed,
//   inProgress,
//   upcoming,
// }

// class AgendaListItem extends StatelessWidget {
//   final AgendaModel agenda;

//   const AgendaListItem({
//     Key? key,
//     required this.agenda,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//       elevation: 2,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(12),
//       ),
//       child: Padding(
//         padding: const EdgeInsets.all(16),
//         child: IntrinsicHeight(
//           child: Row(
//             crossAxisAlignment: CrossAxisAlignment.stretch,
//             children: [
//               // Left timeline section
//               _buildTimeline(),
//               const SizedBox(width: 16),
              
//               // Main content section
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     _buildHeader(),
//                     const SizedBox(height: 8),
//                     _buildDescription(),
//                     const SizedBox(height: 12),
//                     _buildTimeInfo(),
//                     const SizedBox(height: 12),
//                     _buildPresenters(),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildTimeline() {
//     return Column(
//       children: [
//         _TimelineDot(status: _getAgendaStatus()),
//         Expanded(
//           child: Container(
//             width: 2,
//             color: Colors.grey.withOpacity(0.3),
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildHeader() {
//     return Row(
//       children: [
//         Container(
//           padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//           decoration: BoxDecoration(
//             color: _getStatusColor().withOpacity(0.1),
//             borderRadius: BorderRadius.circular(4),
//           ),
//           child: Text(
//             _getStatusText(),
//             style: TextStyle(
//               color: _getStatusColor(),
//               fontSize: 12,
//               fontWeight: FontWeight.w500,
//             ),
//           ),
//         ),
//         const Spacer(),
//         Icon(
//           Icons.more_vert,
//           color: Colors.grey[600],
//           size: 20,
//         ),
//       ],
//     );
//   }

//   Widget _buildDescription() {
//     return Text(
//       agenda.description,
//       style: const TextStyle(
//         fontSize: 16,
//         fontWeight: FontWeight.w500,
//         color: Colors.black87,
//       ),
//       maxLines: 2,
//       overflow: TextOverflow.ellipsis,
//     );
//   }

//   Widget _buildTimeInfo() {
//     return Row(
//       children: [
//         Icon(Icons.access_time, size: 16, color: Colors.grey[600]),
//         const SizedBox(width: 4),
//         Text(
//           '${DateFormat('h:mm a').format(agenda.startTime)} - ${DateFormat('h:mm a').format(agenda.endTime)}',
//           style: TextStyle(
//             color: Colors.grey[600],
//             fontSize: 14,
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildPresenters() {
//     return Row(
//       children: [
//         Icon(Icons.people, size: 16, color: Colors.grey[600]),
//         const SizedBox(width: 8),
//         Expanded(
//           child: ProfileStack(
//             members: agenda.presenters.map((id) => 
//               MemberModel(
//                 id: id,
//                 name: "Member Name", // This should come from your data
//                 photoUrl: "https://via.placeholder.com/150", // This should be actual photo URL
//                 role: "Speaker"
//               )
//             ).toList(),
//             visibleCount: 3,
//           ),
//         ),
//       ],
//     );
//   }

//   AgendaStatus _getAgendaStatus() {
//     final now = DateTime.now();
//     if (agenda.endTime.isBefore(now)) {
//       return AgendaStatus.completed;
//     } else if (agenda.startTime.isBefore(now) && agenda.endTime.isAfter(now)) {
//       return AgendaStatus.inProgress;
//     }
//     return AgendaStatus.upcoming;
//   }

//   String _getStatusText() {
//     switch (_getAgendaStatus()) {
//       case AgendaStatus.completed:
//         return 'Completed';
//       case AgendaStatus.inProgress:
//         return 'In Progress';
//       case AgendaStatus.upcoming:
//         return 'Upcoming';
//     }
//   }

//   Color _getStatusColor() {
//     switch (_getAgendaStatus()) {
//       case AgendaStatus.completed:
//         return Colors.green;
//       case AgendaStatus.inProgress:
//         return Colors.blue;
//       case AgendaStatus.upcoming:
//         return Colors.grey;
//     }
//   }
// }

// // Timeline dot widget
// class _TimelineDot extends StatelessWidget {
//   final AgendaStatus status;

//   const _TimelineDot({
//     Key? key,
//     required this.status,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: 16,
//       height: 16,
//       decoration: BoxDecoration(
//         shape: BoxShape.circle,
//         color: _getBgColor(),
//         border: Border.all(
//           color: _getBorderColor(),
//           width: 2,
//         ),
//       ),
//     );
//   }

//   Color _getBgColor() {
//     switch (status) {
//       case AgendaStatus.completed:
//         return Colors.blue;
//       case AgendaStatus.inProgress:
//         return Colors.white;
//       case AgendaStatus.upcoming:
//         return Colors.white;
//     }
//   }

//   Color _getBorderColor() {
//     switch (status) {
//       case AgendaStatus.completed:
//         return Colors.blue;
//       case AgendaStatus.inProgress:
//         return Colors.blue;
//       case AgendaStatus.upcoming:
//         return Colors.grey;
//     }
//   }
// }