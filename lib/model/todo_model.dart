class Todo {
  int? id;
  String? title;
  String? description;
  bool is_done;

  Todo({this.id, this.title, this.description, this.is_done = false});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'is_done': is_done ? 1 : 0,
    };
  }

  factory Todo.fromMap(Map<String, dynamic> map) {
    return Todo(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      is_done: map['is_done'] == 1,
    );
  }
  Todo copyWith({
    int? id,
    String? title,
    bool? is_done,
  }) {
    return Todo(
      id: id ?? this.id,
      title: title ?? this.title,
      is_done: is_done ?? this.is_done,
    );
  }
}
