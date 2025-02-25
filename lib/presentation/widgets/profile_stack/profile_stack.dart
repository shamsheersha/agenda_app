import 'package:agenda_app/core/theme/theme.dart';
import 'package:flutter/material.dart';

class ProfileStack extends StatelessWidget {
  final List<String> selectedMembers;
  final double avatarSize;
  final double overlap;
  final double gap;

  const ProfileStack({
    super.key,
    required this.selectedMembers,
    this.avatarSize = 32,
    this.overlap = 20,
    this.gap = 4,
  });

  @override
  Widget build(BuildContext context) {
    // Define a list of colors for the avatars
    final List<Color> avatarColors = [
      AppColors.primaryBlue,
      Color(0xFF4CAF50),  // Green
      Color(0xFFF44336),  // Red
      Color(0xFFFF9800),  // Orange
      Color(0xFF9C27B0),  // Purple
      Color(0xFF009688),  // Teal
      Color(0xFF795548),  // Brown
      Color(0xFF607D8B),  // Blue Grey
    ];

    return Row(
      children: [
        for (int i = 0; i < (selectedMembers.length > 3 ? 3 : selectedMembers.length); i++)
          Padding(
            padding: EdgeInsets.only(right: gap),
            child: Transform.translate(
              offset: Offset(i * -(overlap - gap), 0),
              child: CircleAvatar(
                radius: avatarSize / 2,
                // Use different colors for each avatar by getting a color from the array
                // Use modulo to cycle through colors if there are more members than colors
                backgroundColor: avatarColors[i % avatarColors.length],
                child: Text(
                  getInitials(selectedMembers[i]),
                  style: const TextStyle(
                    color: AppColors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ),
        
        if (selectedMembers.length > 3)
          Transform.translate(
            offset: Offset(-(overlap - gap) * 3, 0),
            child: CircleAvatar(
              radius: avatarSize / 2,
              backgroundColor: AppColors.grey,
              child: Text(
                '+${selectedMembers.length - 3}',
                style: const TextStyle(
                  color: AppColors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
      ],
    );
  }

  String getInitials(String name) {
    List<String> nameParts = name.split(' ');
    String initials = '';
    for (var part in nameParts) {
      if (part.isNotEmpty) {
        initials += part[0].toUpperCase();
      }
    }
    return initials;
  }
}