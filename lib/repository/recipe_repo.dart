import 'package:state_notifier/state_notifier.dart';

class StepsNotifier extends StateNotifier<List<String>> {
  StepsNotifier() : super([]);

  void addStep(String step) => state = [...state, step];

  void addSteps(List<String> steps) => state = [...steps];

  void deleteStep(String step) {
    state = [
      for (final loopStep in state)
        if (step != loopStep) loopStep,
    ];
  }

  void swapSteps(int oldIndex, int newIndex) {
    var newState = state;
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }
    final String step = newState.removeAt(oldIndex);
    newState.insert(newIndex, step);
    state = newState;
  }

  void replaceStep(String newStep, int stepIndex) {
    var newState = state;
    newState.replaceRange(stepIndex, stepIndex + 1, [newStep]);
    state = newState;
  }

  void resetSteps() => state = <String>[];
}

class IngredientsNotifier extends StateNotifier<List<String>> {
  IngredientsNotifier() : super([]);

  void addIngredient(String ing) => state = [...state, ing];

  void addIngredients(List<String> ingredients) => state = [...ingredients];

  void deleteIngredient(String ing) {
    state = [
      for (final loopIng in state)
        if (ing != loopIng) loopIng,
    ];
  }

  void replaceIngredient(String newIng, int ingIndex) {
    var newState = state;
    newState.replaceRange(ingIndex, ingIndex + 1, [newIng]);
    state = newState;
  }

  void resetIngredients() => state = <String>[];
}

class TagsNotifier extends StateNotifier<List<String>> {
  TagsNotifier() : super([]);

  void addTag(String tag) => state = [...state, tag];

  void addTags(List<String> tags) => state = [...tags];

  void deleteTag(String tag) {
    state = [
      for (final loopTag in state)
        if (tag != loopTag) loopTag,
    ];
  }

  void resetTags() => state = <String>[];
}

class RecipeNotifier extends StateNotifier<IntroStateModel> {
  RecipeNotifier(IntroStateModel state) : super(state);
  // RecipeNotifier() : super(RecipeStateModel());

  void updateCaloriesPerServing(int value) {
    final newState = state;
    newState.caloriesPerServing = value;
    state = newState;
  }

  void updateDuration(int value) {
    final newState = state;
    newState.duration = value;
    state = newState;
  }

  void updateServes(int value) {
    final newState = state;
    newState.serves = value;
    state = newState;
  }

  void updateDescription(String value) {
    final newState = state;
    newState.description = value;
    state = newState;
  }

  void updateName(String value) {
    final newState = state;
    newState.name = value;
    state = newState;
  }

  void resetIntro() {
    final newState = state;
    newState.caloriesPerServing = 0;
    newState.duration = 0;
    newState.serves = 0;
    newState.description = "";
    newState.name = "";
    state = newState;
  }

  void updateIntro(IntroStateModel value) {
    final newState = state;
    newState.name = value.name;
    newState.serves = value.serves;
    newState.duration = value.duration;
    newState.description = value.description;
    newState.caloriesPerServing = value.caloriesPerServing;
    state = newState;
  }
}

class IntroStateModel {
  int serves;
  String name;
  int duration;
  String description;
  int caloriesPerServing;

  IntroStateModel({
    this.serves,
    this.name,
    this.duration,
    this.description,
    this.caloriesPerServing,
  });
}
