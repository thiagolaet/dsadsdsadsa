class Task {
  int? id;
  late int userId;
  late int boardId;
  late String title;
  String? note;
  String? date;
  String? startTime;
  String? endTime;
  int? isCompleted;

  Task(
    this.userId,
    this.boardId,
    this.title, {
    this.note,
    this.date,
    this.startTime,
    this.endTime,
    this.isCompleted = 0,
  });

  Task.fromMap(Map map) {
    this.id = map["id"];
    this.userId = map["user_id"];
    this.boardId = map["board_id"];
    this.title = map["title"];
    this.note = map["note"];
    this.date = map["date"];
    this.startTime = map["start_time"];
    this.endTime = map["end_time"];
    this.isCompleted = map["is_completed"];
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      "user_id": this.userId,
      "board_id": this.boardId,
      "title": this.title,
      "is_completed": this.isCompleted,
      "note": this.note,
      "date": this.date,
      "start_time": this.startTime,
      "end_time": this.endTime,
    };

    if (this.id != null) {
      map["id"] = this.id;
    }

    return map;
  }
}
