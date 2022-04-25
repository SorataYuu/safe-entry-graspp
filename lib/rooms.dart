class Room {
  int id;
  String name;
  int capacity;
  String imageUrl;

  Room (this.id, this.name, this.capacity, this.imageUrl);
}

final List<Room> roomList = [
  Room(0, "Student Lounge", 20, 'assets/student_lounge.jpeg'),
  Room(1, "Discussion Room 1", 2, 'assets/discussion_room_1.jpeg'),
  Room(2, "Discussion Room 2", 4, 'assets/discussion_room_2.jpeg'),
  Room(3, "Discussion Room 3", 4, 'assets/discussion_room_3.jpeg'),
  Room(4, "Discussion Room 4", 2, 'assets/discussion_room_4.jpeg'),
  Room(5, "Study Room W", 30, 'assets/study_room_w.jpeg'),
  Room(6, "Study Room N", 60, 'assets/study_room_n.jpeg')
];