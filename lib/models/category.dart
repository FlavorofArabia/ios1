class Category {
  final String? id;
  final String? parentId;
  final String? name;
  final String? seoUrl;
  final String? image;
  final String? originalImage;
  final Map<String, dynamic>? filters;
  final int? productCount;

  Category({
    this.id,
    this.parentId,
    this.seoUrl,
    this.name,
    this.image,
    this.originalImage,
    this.filters,
    this.productCount,
  });

  factory Category.fromMap(Map<String, dynamic> map) {
    return Category(
      id: map['category_id'].toString(),
      parentId: map['parent_id'].toString(),
      name: map['name'] ?? '',
      seoUrl: map['seo_url'] ?? '',
      image: map['image'] ?? '',
      originalImage: map['original_image'] ?? '',
      filters: map['filters'] ?? {},
      productCount: map['product_count'] ?? 0,
    );
  }
}
