class MenuItemReview {
  int? id; // Review ID
  int? itemId; // ID of the menu item being reviewed
  int? customerId; // ID of the customer who left the review
  int? rating; // Star rating (e.g., 1 to 5 stars)
  String? reviewText; // Review text (optional)
  DateTime? reviewDate; // Date when the review was submitted

  MenuItemReview({
    this.id,
    this.itemId,
    this.customerId,
    this.rating,
    this.reviewText,
    this.reviewDate,
  });

  // Create a MenuItemReview instance from a map (e.g., from a database query result)
  factory MenuItemReview.fromJson(Map<String, dynamic> json) {
    return MenuItemReview(
      id: json['id'] ?? null,
      itemId: json['itemId'] ?? "",
      customerId: json['customerId'] ?? null,
      rating: json['rating'] ?? 0,
      reviewText: json['reviewText'] ?? "",
      reviewDate: json['reviewDate'] == null
          ? null
          : DateTime.parse(json['reviewDate']),
    );
  }

  // Convert a MenuItemReview instance to a map (e.g., for JSON serialization)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'itemId': itemId,
      'customerId': customerId,
      'rating': rating,
      'reviewText': reviewText,
      'reviewDate': reviewDate == null ? null : reviewDate!.toIso8601String(),
    }..removeWhere((key, value) => value == null);
  }
}
