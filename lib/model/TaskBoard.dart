class TaskBoard {
  int? id;
  late String name;
  int? color;

  TaskBoard(this.name, {color = 0});

  TaskBoard.fromMap(Map map) {
    this.id = map["id"];
    this.name = map["name"];
    this.color = map["color"];
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      "name": this.name,
      "color": this.color
    };

    if (this.id != null) {
      map["id"] = this.id;
    }
    return map;
  }
}