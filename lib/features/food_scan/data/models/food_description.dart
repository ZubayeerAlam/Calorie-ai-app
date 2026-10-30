/// What the user typed about a meal on the "Add manually" screen.
/// Only [text] is required; the rest are optional details that help the AI.
class FoodDescription {
  const FoodDescription({
    required this.text,
    this.portion = '',
    this.cookingMethod = '',
    this.brand = '',
    this.ingredients = '',
  });

  /// e.g. "2 scrambled eggs, 1 slice toast with butter, black coffee".
  final String text;
  final String portion;
  final String cookingMethod;
  final String brand;
  final String ingredients;

  /// The optional details that were filled in, as (label, value) pairs.
  List<(String, String)> get details => [
    if (portion.trim().isNotEmpty) ('Portion', portion.trim()),
    if (cookingMethod.trim().isNotEmpty) ('Cooking', cookingMethod.trim()),
    if (brand.trim().isNotEmpty) ('Brand', brand.trim()),
    if (ingredients.trim().isNotEmpty) ('Ingredients', ingredients.trim()),
  ];

  /// Sent to the AI (empty details left out).
  Map<String, dynamic> toJson() => {
    'text': text.trim(),
    for (final (label, value) in details) label.toLowerCase(): value,
  };
}
