class SubTasksModel {
  final String subtask;
  final bool done;

  SubTasksModel({required this.subtask, required this.done});

  Map<String, dynamic> toJson() {
    return {
      'subtask': subtask,
      'done': done,
    };
  }

  factory SubTasksModel.fromJson(Map<String, dynamic> json) {
    return SubTasksModel(
      subtask: json['subtask'],
      done: json['done'],
    );
  }
}
