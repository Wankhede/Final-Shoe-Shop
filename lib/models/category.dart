class Category {
  final String id;
  final String name;
  final String description;
  final String image;
  final int count;

  Category({
    required this.id,
    required this.name,
    required this.description,
    required this.image,
    required this.count,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      image: json['image'],
      count: json['count'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'image': image,
      'count': count,
    };
  }
}