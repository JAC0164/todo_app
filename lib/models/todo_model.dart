class TodoCategory {
  String id = "";
  String name = "";
  int? icon;
  String? useId;
  String? color;
  String? createdAt;
  String? updatedAt;

  TodoCategory({
    required this.id,
    required this.name,
    this.icon = 0,
    this.useId = "",
    this.color = "",
    this.createdAt,
    this.updatedAt,
  });

  TodoCategory.fromJson(Map<String, dynamic> json, {String? id}) {
    this.id = id ?? json['id'] ?? '';
    name = json['name'] ?? 'Untitled';
    icon = json['icon'] ?? '';
    useId = json['userId'] ?? '';
    color = json['color'] ?? '';
    createdAt = json['createdAt'] ?? '';
    updatedAt = json['updatedAt'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['icon'] = icon;
    data['userId'] = useId;
    data['color'] = color;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    return data;
  }

  @override
  String toString() {
    return 'TodoCategory{id: $id, name: $name, icon: $icon, useId: $useId, color: $color}';
  }
}

class TodoModel {
  String id = "";
  String title = "";
  bool isDone = false;
  String? description;
  String? userId;
  TodoCategory? category;
  int? priority = 0;
  String? date;
  String? createdAt;
  String? updatedAt;

  TodoModel({
    required this.id,
    required this.title,
    this.description = "",
    this.userId = "",
    this.isDone = false,
    this.category,
    this.priority = 0,
    this.date = '',
    this.createdAt,
    this.updatedAt,
  });

  TodoModel.fromJson(Map<String, dynamic> json, {String? id}) {
    this.id = id ?? json["id"] ?? '';
    title = json['title'] ?? 'Untitled';
    description = json['description'];
    userId = json['userId'];
    isDone = json['isDone'] ?? false;
    category = json['category'] != null ? TodoCategory.fromJson(json['category']) : null;
    priority = json['priority'] ?? 0;
    date = json['date'] ?? '';
    createdAt = json['createdAt'] ?? '';
    updatedAt = json['updatedAt'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['description'] = description;
    data['userId'] = userId;
    data['isDone'] = isDone;
    data['category'] = category?.toJson();
    data['priority'] = priority;
    data['date'] = date;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    return data;
  }

  // copyWith method
  TodoModel copyWith({
    String? id,
    String? title,
    String? description,
    String? userId,
    bool? isDone,
    TodoCategory? category,
    int? priority,
    String? date,
    String? createdAt,
    String? updatedAt,
  }) {
    return TodoModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      userId: userId ?? this.userId,
      isDone: isDone ?? this.isDone,
      category: category ?? this.category,
      priority: priority ?? this.priority,
      date: date ?? this.date,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  String toString() {
    return 'TodoModel{id: $id, title: $title, description: $description, userId: $userId, isDone: $isDone, category: $category, priority: $priority, date: $date}';
  }
}
