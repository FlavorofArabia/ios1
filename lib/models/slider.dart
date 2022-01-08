class Slider {
  final String? id;
  final String? image;
  final String? title;
  final String? link;

  Slider({
    this.id,
    this.image,
    this.title,
    this.link,
  });

  factory Slider.fromMap(Map<String, dynamic> map) {
    return Slider(
      id: map['_id'],
      image: map['image'],
      title: map['title'],
      link: map['link'],
    );
  }
}
