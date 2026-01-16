// This class represents any content item in our app
// It can be an emoticon, gif, or meme
class ContentItem {
  final String id;           // Unique identifier
  final String content;      // The actual content (emoji text, gif URL, or meme URL)
  final ContentType type;    // Whether it's emoticon, gif, or meme
  final List<String> tags;   // Keywords for searching (e.g., "happy", "sad", "cute")
  bool isFavorite;          // Can be toggled by user

  ContentItem({
    required this.id,
    required this.content,
    required this.type,
    this.tags = const [],
    this.isFavorite = false,
  });
}

// Enum to define the three types of content
enum ContentType {
  emoticon,
  gif,
  meme,
}
