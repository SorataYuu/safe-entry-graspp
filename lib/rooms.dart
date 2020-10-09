class Room {
  int id;
  String name;
  int capacity;
  String imageUrl;

  Room (this.id, this.name, this.capacity, this.imageUrl);
}

final List<Room> roomList = [
  Room(0, "Student Lounge", 40, 'student_lounge.jpeg'),
  Room(1, "Discussion Room 1", 2, 'discussion_room_1.jpeg'),
  Room(2, "Discussion Room 2", 2, 'discussion_room_2.jpeg'),
  Room(3, "Discussion Room 3", 2, 'discussion_room_3.jpeg'),
  Room(4, "Discussion Room 4", 2, 'discussion_room_4.jpeg'),
  Room(5, "Discussion Room 5", 2, 'discussion_room_5.jpeg'),
];