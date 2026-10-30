import 'food_description.dart';

/// What to analyse: a photo, or a typed description.
sealed class AnalysisRequest {
  const AnalysisRequest();
}

class PhotoAnalysisRequest extends AnalysisRequest {
  const PhotoAnalysisRequest(this.imagePath);

  final String imagePath;
}

class TextAnalysisRequest extends AnalysisRequest {
  const TextAnalysisRequest(this.description);

  final FoodDescription description;
}
