class Attendance {
  String uuid;
  String title;
  String description;
  String createdAt;
  String filepath;
  String type;

  Attendance({
    required this.uuid,
    required this.title,
    required this.description,
    required this.createdAt,
    required this.filepath,
    required this.type,
  });

  factory Attendance.fromMap(Map<String, dynamic> map) {
    return Attendance(
      uuid: map['uuid'] ?? '',
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      createdAt: map['createdAt'] ?? '',
      filepath: map['filepath'] ?? '',
      type: map['type'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uuid': uuid,
      'title': title,
      'description': description,
      'createdAt': createdAt,
      'filepath': filepath,
      'type': type,
    };
  }
}
