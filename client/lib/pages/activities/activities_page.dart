import 'package:client/pages/activities/breathing_excersise_screen.dart';
import 'package:client/pages/activities/bubble_game.dart';
import 'package:flutter/material.dart';

class ActivitiesScreen extends StatelessWidget {
  const ActivitiesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Activities'),
        backgroundColor: Theme.of(context).colorScheme.surface,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.count(
          crossAxisCount: 2,
          childAspectRatio: 1.5,
          crossAxisSpacing: 16.0,
          mainAxisSpacing: 16.0,
          children: [
            _buildActivityButton(context, 'Breathing',() => _onBreathingSelected(context)),
            _buildActivityButton(context, 'Bubble Burst',() => _onBubbleBurstSelected(context)),
            _buildActivityButton(context, 'Soothing Music', _onSoothingMusicSelected),
            _buildActivityButton(context, 'Exercises', _onExercisesSelected),
          ],
        ),
      ),
    );
  }

  Widget _buildActivityButton(BuildContext context, String title, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.all(20.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
      ),
      child: Text(
        title,
        style: const TextStyle(fontSize: 18),
      ),
    );
  }

  void _onBreathingSelected(context) {
    // Navigate to Breathing activity
    print('Breathing activity selected');
    Navigator.push(context, MaterialPageRoute(builder: (context) => BreathingPage()));
  }

  void _onBubbleBurstSelected(context) {
    // Navigate to Bubble Burst activity
    print('Bubble Burst activity selected');
    Navigator.push(context, MaterialPageRoute(builder: (context) => BubbleGamePage()));
  }

  void _onSoothingMusicSelected() {
    // Navigate to Soothing Music activity
    print('Soothing Music activity selected');
  }

  void _onExercisesSelected() {
    // Navigate to Exercises activity
    print('Exercises activity selected');
  }
}
