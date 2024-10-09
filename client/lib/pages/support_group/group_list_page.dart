import 'package:flutter/material.dart';

class SupportGroupScreen extends StatelessWidget {
  const SupportGroupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Support Groups'),
        backgroundColor: Theme.of(context).colorScheme.surface,
      ),
      body: _buildSupportGroupsList(),
    );
  }

  Widget _buildSupportGroupsList() {
    // Sample data for support groups
    final List<SupportGroup> supportGroups = [
      SupportGroup(
        name: 'Mental Wellness Support',
        description: 'A safe space for sharing experiences and coping strategies.',
        members: 25,
        imageUrl: 'https://via.placeholder.com/150',
      ),
      SupportGroup(
        name: 'Anxiety and Stress Relief',
        description: 'Join us for discussions and mindfulness practices.',
        members: 40,
        imageUrl: 'https://via.placeholder.com/150',
      ),
      SupportGroup(
        name: 'Depression Support Circle',
        description: 'Find understanding and encouragement from peers.',
        members: 30,
        imageUrl: 'https://via.placeholder.com/150',
      ),
      SupportGroup(
        name: 'Addiction Recovery Group',
        description: 'Support and resources for those on the path to recovery.',
        members: 15,
        imageUrl: 'https://via.placeholder.com/150',
      ),
      SupportGroup(
        name: 'Parenting Support Group',
        description: 'Share challenges and successes in parenting.',
        members: 20,
        imageUrl: 'https://via.placeholder.com/150',
      ),
    ];

    return ListView.builder(
      itemCount: supportGroups.length,
      itemBuilder: (context, index) {
        return _buildSupportGroupCard(supportGroups[index]);
      },
    );
  }

  Widget _buildSupportGroupCard(SupportGroup group) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(group.imageUrl),
              radius: 40,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    group.name,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(group.description),
                  const SizedBox(height: 4),
                  Text('Members: ${group.members}'),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: () {
                _joinSupportGroup(group);
              },
              child: const Text('Join'),
            ),
          ],
        ),
      ),
    );
  }

  void _joinSupportGroup(SupportGroup group) {
    // Logic to join the support group (e.g., navigate to group chat or details)
    print('Joining ${group.name}');
    // Here you can navigate to a detailed screen or open a chat interface
  }
}

class SupportGroup {
  final String name;
  final String description;
  final int members;
  final String imageUrl;

  SupportGroup({
    required this.name,
    required this.description,
    required this.members,
    required this.imageUrl,
  });
}
