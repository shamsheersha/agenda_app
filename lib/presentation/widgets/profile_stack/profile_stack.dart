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
    return Row(
      children: [
        for (int i = 0; i < (selectedMembers.length > 3 ? 3 : selectedMembers.length); i++)
          Padding(
            padding: EdgeInsets.only(right: gap), 
            child: Transform.translate(
              offset: Offset(i * -(overlap - gap), 0), 
              child: CircleAvatar(
                radius: avatarSize / 2,
                backgroundColor: AppColors.primaryBlue,
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