import 'package:client/utils/theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_animate/flutter_animate.dart';

class HomeContent extends StatefulWidget {
  final int numberOfChallenges;

  const HomeContent({super.key, this.numberOfChallenges = 10});

  @override
  _HomeContentState createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  final ScrollController _scrollController = ScrollController();
  bool _isScrollingDown = true;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref();
  Map<int, bool> _completedChallenges = {};
  int _dailyStreak = 0;
  DateTime? _lastChallengeCompletionTime;
  bool _isLocked = false;
  int _lockDurationInHours = 24;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
    _loadUserData(); // Load user's challenges and streak from Firebase
  }

  // Load user data including challenges and daily streak
  void _loadUserData() async {
    final user = _auth.currentUser;
    if (user == null) return;

    final userRef = _dbRef.child('users').child(user.uid);

    // Load completed challenges
    DataSnapshot completedSnapshot = await userRef.child('completedChallenges').get();
    if (completedSnapshot.exists) {
      Map<dynamic, dynamic> completedData = completedSnapshot.value as Map;
      setState(() {
        _completedChallenges = completedData.map((key, value) => MapEntry(int.parse(key), value as bool));
      });
    }

    // Load daily streak
    DataSnapshot streakSnapshot = await userRef.child('dailyStreak').get();
    if (streakSnapshot.exists) {
      setState(() {
        _dailyStreak = streakSnapshot.value as int;
      });
    }

    // Load last challenge completion time
    DataSnapshot lastTimeSnapshot = await userRef.child('lastChallengeCompletionTime').get();
    if (lastTimeSnapshot.exists) {
      _lastChallengeCompletionTime = DateTime.fromMillisecondsSinceEpoch(lastTimeSnapshot.value as int);
      _checkIfChallengesShouldLock();
    }
  }

  // Check if challenges should lock after 24 hours
  void _checkIfChallengesShouldLock() {
    if (_lastChallengeCompletionTime == null) return;

    final currentTime = DateTime.now();
    final timeDifference = currentTime.difference(_lastChallengeCompletionTime!);

    setState(() {
      _isLocked = timeDifference.inHours >= _lockDurationInHours;
    });
  }

  // Update the task completion, streak, and last completion time in Firebase
  void _updateTaskCompletion(int index) async {
    if (_isLocked || (_completedChallenges[index] ?? false)) {
      // If challenges are locked or already completed, don't allow completion
      return;
    }

    final user = _auth.currentUser;
    if (user == null) return;

    setState(() {
      _completedChallenges[index] = true; // Mark the task as completed
    });

    final userRef = _dbRef.child('users').child(user.uid);
    await userRef.child('completedChallenges').update({index.toString(): true});

    // Update last challenge completion time
    final currentTime = DateTime.now();
    await userRef.child('lastChallengeCompletionTime').set(currentTime.millisecondsSinceEpoch);

    // Update the daily streak
    _updateDailyStreak(currentTime);
  }

  // Update the daily streak based on challenge completion
  void _updateDailyStreak(DateTime currentTime) async {
    final user = _auth.currentUser;
    if (user == null) return;

    if (_lastChallengeCompletionTime != null) {
      final timeDifference = currentTime.difference(_lastChallengeCompletionTime!);
      if (timeDifference.inHours < _lockDurationInHours) {
        setState(() {
          _dailyStreak += 1; // Increment streak if within 24 hours
        });
      } else {
        setState(() {
          _dailyStreak = 1; // Reset streak if more than 24 hours passed
        });
      }
    } else {
      setState(() {
        _dailyStreak = 1; // Start streak on first completion
      });
    }

    final userRef = _dbRef.child('users').child(user.uid);
    await userRef.child('dailyStreak').set(_dailyStreak);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.position.userScrollDirection == ScrollDirection.reverse) {
      if (!_isScrollingDown) {
        setState(() {
          _isScrollingDown = true;
        });
      }
    } else if (_scrollController.position.userScrollDirection == ScrollDirection.forward) {
      if (_isScrollingDown) {
        setState(() {
          _isScrollingDown = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      controller: _scrollController,
      slivers: [
        SliverPadding(
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                if (index == 0) return _buildHeader(context);
                if (index == 1) return const SizedBox(height: 24);
                if (index == 2) return _buildDailyStreak(context);
                if (index == 3) return const SizedBox(height: 24);
                if (index == 4) return _buildChallengesHeader(context);
                if (index == 5) return const SizedBox(height: 24);

                // Challenges start from index 6
                int challengeIndex = index - 6;
                return _buildChallengeItem(context, challengeIndex);
              },
              childCount: widget.numberOfChallenges + 6,
            ),
          ),
          padding: EdgeInsets.fromLTRB(16, 16, 16, 10),
        ),
      ],
    );
  }

  Widget _buildHeader(BuildContext context) {
    final user = _auth.currentUser;
    if (user == null) {
      return Text(
        'Welcome back!',
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Theme.of(context).colorScheme.primary,
        ),
      ).animate().fadeIn(duration: 500.ms);
    }

    final DatabaseReference userRef = _dbRef.child('users').child(user.uid);

    return FutureBuilder(
      future: userRef.child('name').get(),
      builder: (BuildContext context, AsyncSnapshot<DataSnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text(
            'Error loading name',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.primary,
            ),
          ).animate().fadeIn(duration: 500.ms);
        } else if (snapshot.hasData && snapshot.data!.value != null) {
          final String name = snapshot.data!.value.toString();
          return Text(
            'Welcome back $name!',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.primary,
            ),
          ).animate().fadeIn(duration: 500.ms);
        } else {
          return Text(
            'Welcome back!',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.primary,
            ),
          ).animate().fadeIn(duration: 500.ms);
        }
      },
    );
  }

  Widget _buildDailyStreak(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: colorScheme.secondary,
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Daily Streak',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: colorScheme.primary,
              ),
            ),
            Row(
              children: [
                Icon(Icons.local_fire_department, color: Colors.orange),
                const SizedBox(width: 8),
                Text(
                  '$_dailyStreak days',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: colorScheme.primary,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 500.ms).slideY(begin: 0.2, end: 0, duration: 500.ms);
  }

  Widget _buildChallengesHeader(BuildContext context) {
    return Text(
      'Daily Challenges',
      style: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Theme.of(context).colorScheme.primary,
      ),
    ).animate().fadeIn(duration: 500.ms);
  }

  final List<String> challengeDescriptions = [
    'Spend 5 minutes practicing mindful breathing.',
    'Write down three things you are grateful for today.',
    'Spend one hour away from your phone and digital devices.',
    'Write down three positive things about yourself.',
    'Engage in light physical activity for at least 15 minutes.',
    'Eat one meal slowly and mindfully.',
    'Reach out to a friend or loved one today.',
    'Spend 10 minutes meditating.',
    'Say three positive affirmations out loud.',
    'Spend 10-15 minutes outside enjoying nature.'
  ];

  Widget _buildChallengeItem(BuildContext context, int index) {
    final colorScheme = Theme.of(context).colorScheme;
    bool isCompleted = _completedChallenges[index] ?? false;
    bool isLocked = index > 0 && !(_completedChallenges[index - 1] ?? false); // Unlock only if the previous one is completed
    bool isLeft = index.isEven;

    Color cardColor = isCompleted
        ? colorScheme.accent1
        : isLocked
            ? colorScheme.secondary.withOpacity(0.2)
            : colorScheme.secondary;

    String challengeDescription = challengeDescriptions[index];

    Widget challengeCard = Padding(
      padding: EdgeInsets.only(
          left: isLeft ? 0 : 40, right: isLeft ? 40 : 0, bottom: 16),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        color: cardColor,
        child: InkWell(
          onTap: isLocked || isCompleted
              ? null
              : () {
                  if (!isCompleted) {
                    _updateTaskCompletion(index);
                  }
                },
          child: Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: colorScheme.surface,
                  ),
                  child: Icon(
                    isCompleted
                        ? Icons.check
                        : isLocked
                            ? Icons.lock
                            : Icons.play_arrow,
                    color: colorScheme.onPrimary,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Challenge ${index + 1}',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: colorScheme.onPrimary,
                        ),
                      ),
                      Text(
                        isLocked ? 'Locked' : challengeDescription,
                        style: TextStyle(
                          color: colorScheme.primary.withOpacity(0.8),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    return challengeCard.animate().fadeIn(duration: 500.ms).slideY(
          begin: _isScrollingDown ? 0.7 : -0.7,
          end: 0,
          duration: 500.ms,
          curve: Curves.easeInOut,
        );
  }
}
