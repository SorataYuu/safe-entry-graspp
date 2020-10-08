class Room {
  int id;
  String name;
  int capacity;
  String imageUrl;

  Room (this.id, this.name, this.capacity, this.imageUrl);
}

final List<Room> roomList = [
  Room(0, "Student Lounge", 40, null),
  Room(1, "Discussion Room 1", 2, null),
  Room(1, "Discussion Room 2", 2, null),
  Room(1, "Discussion Room 3", 2, null),
  Room(1, "Discussion Room 4", 2, null),
  Room(1, "Discussion Room 5", 2, null),
];