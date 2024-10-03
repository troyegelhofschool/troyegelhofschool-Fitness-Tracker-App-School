import 'package:flutter_application_1/datetime/date_time.dart';
import 'package:flutter_application_1/models/exercise.dart';
import 'package:flutter_application_1/models/workout.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HiveDatabase {
  // reference our hive box
  final _myBox = Hive.box("workout_database");

  // check if there is already data stored, if not, record the start date
  bool previousDataExists() {
    if (_myBox.isEmpty) {
      print("previous data does NOT exist");
      _myBox.put("START_DATE", todaysDateYYYYMMDD());
      return false;
    } else {
      print("previous data does exist");
      return true;
    }
  }

  // return start date as yyyymmdd
  String getStartDate() {
    return _myBox.get("START_DATE");
  }

  // write data
  void saveToDatabase(List<Workout> workouts) {
    // convert workout objects into list of strings so that we can save in hive
    final workoutList = convertObjectToWorkoutList(workouts);
    final exerciseList = convertObjectToExerciseList(workouts);

    /*

    check if any exercises have been done
    we will a 0 or 1 for each yyyymmdd date

    */

    if (exerciseCompleted(workouts)) {
      _myBox.put("COMPLETION_STATUS_${todaysDateYYYYMMDD()}", 1);
    } else {
      _myBox.put("COMPLETION_STATUS_${todaysDateYYYYMMDD()}", 0);
    }

    // save into hive
    _myBox.put("WORKOUTS", workoutList);
    _myBox.put("EXERCISE", exerciseList);
  }

  // read data, and return a list of workouts
  List<Workout> readFromDatabase() {
    List<Workout> mySavedWorkouts = [];

    List<String> workoutNames = _myBox.get("WORKOUTS");
    final exerciseDetails = _myBox.get("EXERCISES");

    //create workout objects
    for (int i = 0; i < workoutNames.length; i++) {
      // each workout can have multiple exercises
      List<Exercise> exercisesInEachWorkout = [];

      for (int j = 0; j < exerciseDetails[i].length; j++) {
        // so add each exercise into a list
        exercisesInEachWorkout.add(
          Exercise(
            name: exerciseDetails[i][j][0],
            weight: exerciseDetails[i][j][1],
            reps: exerciseDetails[i][j][2],
            sets: exerciseDetails[i][j][3],
            isCompleted: exerciseDetails[i][j][4] == true ? true : false,
          ),
        );
      }

      // create individual workout
      Workout workout =
          Workout(name: workoutNames[i], excercises: exercisesInEachWorkout);

      // add individual workout to overall list
      mySavedWorkouts.add(workout);
    }

    return mySavedWorkouts;
  }

  // check if any exercises has already been done
  bool exerciseCompleted(List<Workout> workouts) {
    // go though each workout
    for (var workout in workouts) {
      //go through each exercise in workout
      for (var exercise in workout.excercises) {
        if (exercise.isCompleted) {
          return true;
        }
      }
    }
    return false;
  }

  // return completion status of a give date yyyymmdd
  int getCompletionStatus(String yyyymmdd) {
    // returns 0 or 1, if null then return 0
    int completionStatus = _myBox.get("COMPLETION_STATUS_$yyyymmdd") ?? 0;
    return completionStatus;
  }
}

// converts workout objects into a list eg (upperbody, lowerbody)
List<String> convertObjectToWorkoutList(List<Workout> workouts) {
  List<String> workoutList = [
    // eg. [upperbody, lowerbody]
  ];

  for (int i = 0; i < workouts.length; i++) {
    // in each workout, add the name, followed by lists of exercises
    workoutList.add(
      workouts[i].name,
    );
  }

  return workoutList;
}

// converts the exercises in a workout object into a list of strings
List<List<List<String>>> convertObjectToExerciseList(List<Workout> workouts) {
  List<List<List<String>>> exerciseList = [
    /*
      [
        Upper Body
        [ [biceps, 10kg, 10reps, 3sets], [truceos, 20kg, 10reps, 3sets ],

        Lower Body
        [ [squats, 25kg, 10reps, 3sets], [legraise, 30kg, 10reps, 3sets], [calf, 10kg, 10reps, 3sets]
        
      ]
    */
  ];

  // go through each workout
  for (int i = 0; i < workouts.length; i++) {
    // get exercises from each workout
    List<Exercise> exercisesInWorkout = workouts[i].excercises;

    List<List<String>> individualWorkout = [
      // Upper Body
      // [ [biceps, 10kg, 10reps, 3sets], [triceps, 20kg, 10reps, 3sets] ],
    ];

    // go through each exercise in exerciseList
    for (int j = 0; j < exercisesInWorkout.length; j++) {
      List<String> individualExercise = [
        // [biceps, 10kg, 10reps, 3sets]
      ];
      individualExercise.addAll(
        [
          exercisesInWorkout[j].name,
          exercisesInWorkout[j].weight,
          exercisesInWorkout[j].reps,
          exercisesInWorkout[j].sets,
          exercisesInWorkout[j].isCompleted.toString(),
        ],
      );
      individualWorkout.add(individualExercise);
    }

    exerciseList.add(individualWorkout);
  }

  return exerciseList;
}
