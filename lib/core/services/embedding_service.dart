import 'dart:convert';
import 'dart:math';

/// EmbeddingService v1.5 stub
/// - Provides deterministic lightweight embeddings without external APIs
/// - Can be swapped to real provider later (OpenAI/Vertex/etc.)
class EmbeddingService {
  static final EmbeddingService _instance = EmbeddingService._internal();
  factory EmbeddingService() => _instance;
  EmbeddingService._internal();

  bool _isInitialized = false;
  bool get isInitialized => _isInitialized;

  // Feature flag: enable vector scoring in advanced search
  bool enableVectorScoring = true;

  // Embedding size kept small for on-device speed
  static const int _dimension = 64;

  Future<void> initialize() async {
    if (_isInitialized) return;
    // No external setup required for the stub
    _isInitialized = true;
  }

  /// Deterministic "hashing" embedding of a text
  /// Not semantically rich but provides vector space for fusion prototype
  List<double> embedText(String text) {
    final bytes = utf8.encode(text.toLowerCase());
    final vector = List<double>.filled(_dimension, 0.0);
    for (int i = 0; i < bytes.length; i++) {
      final idx = (bytes[i] + i) % _dimension;
      vector[idx] += 1.0;
    }
    // L2 normalize
    final norm = sqrt(vector.fold<double>(0.0, (sum, v) => sum + v * v));
    if (norm > 0) {
      for (int i = 0; i < vector.length; i++) {
        vector[i] /= norm;
      }
    }
    return vector;
  }

  /// Cosine similarity between two vectors
  double cosineSimilarity(List<double> a, List<double> b) {
    final len = min(a.length, b.length);
    double dot = 0.0;
    double na = 0.0;
    double nb = 0.0;
    for (int i = 0; i < len; i++) {
      dot += a[i] * b[i];
      na += a[i] * a[i];
      nb += b[i] * b[i];
    }
    if (na == 0 || nb == 0) return 0.0;
    return dot / (sqrt(na) * sqrt(nb));
  }
}


