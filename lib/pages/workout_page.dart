import 'package:flutter/material.dart';
import 'package:flutter_application_1/components/exercise_tile.dart';
import 'package:flutter_application_1/data/workout_data.dart';
import 'package:provider/provider.dart';

class WorkoutPage extends StatefulWidget {
  final String workoutName;
  const WorkoutPage({super.key, required this.workoutName});

  @override
  State<WorkoutPage> createState() => _WorkoutPageState();
}

class _WorkoutPageState extends State<WorkoutPage> {
  //checkbox was tapped
  void onCheckBoxChanged(String workoutName, String exerciseName) {
    Provider.of<WorkoutData>(context, listen: false)
        .checkOffExercise(workoutName, exerciseName);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<WorkoutData>(
      builder: (context, value, child) => Scaffold(
        appBar: AppBar(
          title: Text(widget.workoutName),
          backgroundColor: Colors.blue,
        ),
        body: ListView.builder(
          itemCount: value.numberOfExercisesInWorkout(widget.workoutName),
          itemBuilder: (context, index) => ExerciseTile(
            exerciseName: value
                .getRelevantWorkout(widget.workoutName)
                .excercises[index]
                .name,
            weight: value
                .getRelevantWorkout(widget.workoutName)
                .excercises[index]
                .weight,
            reps: value
                .getRelevantWorkout(widget.workoutName)
                .excercises[index]
                .reps,
            sets: value
                .getRelevantWorkout(widget.workoutName)
                .excercises[index]
                .sets,
            isCompleted: value
                .getRelevantWorkout(widget.workoutName)
                .excercises[index]
                .isCompleted,
            onCheckBoxChanged: (val) => onCheckBoxChanged(
              widget.workoutName,
              value
                  .getRelevantWorkout(widget.workoutName)
                  .excercises[index]
                  .name,
            ),
          ),
        ),
      ),
    );
  }
}
