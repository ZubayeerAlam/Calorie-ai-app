/// True for connection problems reported by the AI's HTTP layer (its
/// `ClientException`, or a failed host lookup).
bool isGeminiNetworkError(Object e) =>
    e.runtimeType.toString() == 'ClientException' ||
    '$e'.contains('Failed host lookup');
