import 'package:agenda_app/core/theme/theme.dart';
import 'package:agenda_app/presentation/widgets/profile_stack/profile_stack.dart';
import 'package:flutter/material.dart';

class AddMembersScreen extends StatefulWidget {
  final List<String> selectedMembers;

  const AddMembersScreen({super.key, required this.selectedMembers});

  @override
  AddMembersScreenState createState() => AddMembersScreenState();
}

class AddMembersScreenState extends State<AddMembersScreen> {
  final List<Map<String, String>> members = [
    {'id': 'A', 'name': 'Adhil'},
    {'id': 'D', 'name': 'Dennis'},
    {'id': 'L', 'name': 'Labeeb'},
    {'id': 'R', 'name': 'Rinshal'},
    {'id': 'M', 'name': 'Mufassil'},
  ];

  late List<String> selectedMembers;

  @override
  void initState() {
    super.initState();
    selectedMembers = widget.selectedMembers;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Members',style: AppTextStyles.headingStyleW,),
        backgroundColor: AppColors.primaryBlue,
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context, selectedMembers);
            },
            child: Text(
              'Done',
              style: AppTextStyles.headerBoldW,
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ProfileStack(selectedMembers: selectedMembers),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: members.length,
              itemBuilder: (context, index) {
                final member = members[index];
                final isSelected = selectedMembers.contains(member['id']);
                return ListTile(
                  leading: CircleAvatar(
                    child: Text(member['id']!),
                  ),
                  title: Text(member['name']!),
                  trailing: isSelected
                      ? Icon(Icons.check_circle, color: Colors.blue)
                      : Icon(Icons.circle_outlined, color: Colors.grey),
                  onTap: () {
                    setState(() {
                      if (isSelected) {
                        selectedMembers.remove(member['id']);
                      } else {
                        selectedMembers.add(member['id']!);
                      }
                    });
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

