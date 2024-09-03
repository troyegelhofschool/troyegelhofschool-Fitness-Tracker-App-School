import 'package:flutter_application_1/models/exercise.dart';
import 'package:flutter_application_1/models/workout.dart';

class WorkoutData {
  /*

  WORKOUT DATA STRUCTURE

  - This overall list contains the different workouts
  - Each workout has a name and a list of exercises

  */

  List<Workout> workoutList = [
    // default workout
    Workout(
      name: "Upper Body",
      excercises: [
        Exercise(
          name: "Bicep Curls",
          weight: "10",
          reps: "10",
          sets: "3",
        ),
      ],
    )
  ];

  // get the list of workouts
  List<Workout> getWorkoutList() {
    return workoutList;
  }

  // add a workout
  void addWorkout(String name) {
    // add a new workout with a blank list of exercises
    workoutList.add(Workout(name: name, excercises: []));
  }

  // add an exercise to a workout
  void AddExercise(String workoutName, String exerciseName, String weight,
      String reps, String sets) {
    // find the relevant workout
    Workout relevantWorkout =
        workoutList.firstWhere((workout) => workout.name == workoutName);

    relevantWorkout.excercises.add(
      Exercise(
        name: exerciseName,
        weight: weight,
        reps: reps,
        sets: sets,
      ),
    );
  }
  // check off exercise

  // get length of a given workout
}
