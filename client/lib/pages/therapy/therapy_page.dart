import 'package:flutter/material.dart';

class MentalHealthSpecialistsScreen extends StatelessWidget {
  const MentalHealthSpecialistsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Connect with Specialists'),
        backgroundColor: Theme.of(context).colorScheme.surface,
      ),
      body: _buildSpecialistsList(),
    );
  }

  Widget _buildSpecialistsList() {
    // Sample data for specialists
    final List<MentalHealthSpecialist> specialists = [
      MentalHealthSpecialist(
        name: 'Dr. Alice Johnson',
        specialty: 'Psychologist',
        experience: '10 years',
        profileImage: 'https://via.placeholder.com/150',
      ),
      MentalHealthSpecialist(
        name: 'Dr. Bob Smith',
        specialty: 'Psychiatrist',
        experience: '8 years',
        profileImage: 'https://via.placeholder.com/150',
      ),
      MentalHealthSpecialist(
        name: 'Dr. Charlie Brown',
        specialty: 'Therapist',
        experience: '5 years',
        profileImage: 'https://via.placeholder.com/150',
      ),
      MentalHealthSpecialist(
        name: 'Dr. David Williams',
        specialty: 'Counselor',
        experience: '12 years',
        profileImage: 'https://via.placeholder.com/150',
      ),
      MentalHealthSpecialist(
        name: 'Dr. Emily Davis',
        specialty: 'Clinical Psychologist',
        experience: '7 years',
        profileImage: 'https://via.placeholder.com/150',
      ),
      MentalHealthSpecialist(
        name: 'Dr. Fiona Garcia',
        specialty: 'Marriage and Family Therapist',
        experience: '6 years',
        profileImage: 'https://via.placeholder.com/150',
      ),
      MentalHealthSpecialist(
        name: 'Dr. George Martinez',
        specialty: 'Addiction Specialist',
        experience: '15 years',
        profileImage: 'https://via.placeholder.com/150',
      ),
      MentalHealthSpecialist(
        name: 'Dr. Hannah Lopez',
        specialty: 'Pediatric Psychologist',
        experience: '9 years',
        profileImage: 'https://via.placeholder.com/150',
      ),
      MentalHealthSpecialist(
        name: 'Dr. Ian White',
        specialty: 'Neuropsychologist',
        experience: '11 years',
        profileImage: 'https://via.placeholder.com/150',
      ),
      MentalHealthSpecialist(
        name: 'Dr. Jessica Lee',
        specialty: 'Clinical Social Worker',
        experience: '4 years',
        profileImage: 'https://via.placeholder.com/150',
      ),
    ];

    return ListView.builder(
      itemCount: specialists.length,
      itemBuilder: (context, index) {
        return _buildSpecialistCard(specialists[index]);
      },
    );
  }

  Widget _buildSpecialistCard(MentalHealthSpecialist specialist) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(specialist.profileImage),
              radius: 40,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    specialist.name,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(specialist.specialty),
                  const SizedBox(height: 4),
                  Text('Experience: ${specialist.experience}'),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: () {
                _connectWithSpecialist(specialist);
              },
              child: const Text('Connect'),
            ),
          ],
        ),
      ),
    );
  }

  void _connectWithSpecialist(MentalHealthSpecialist specialist) {
    // Logic to connect with the specialist (e.g., navigate to chat, booking, etc.)
    print('Connecting with ${specialist.name}');
    // You can navigate to another screen or open a chat interface here
  }
}

class MentalHealthSpecialist {
  final String name;
  final String specialty;
  final String experience;
  final String profileImage;

  MentalHealthSpecialist({
    required this.name,
    required this.specialty,
    required this.experience,
    required this.profileImage,
  });
}