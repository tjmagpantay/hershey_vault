import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/content_item.dart';

class EmoticonPage extends StatefulWidget {
  const EmoticonPage({super.key});

  @override
  State<EmoticonPage> createState() => _EmoticonPageState();
}

class _EmoticonPageState extends State<EmoticonPage> {
  String _searchQuery = '';
  String? _selectedTag; // Currently selected filter tag
  bool _showTagFilters = false; // Whether to show the tag filter section
  
  // Default text-based emoticons (kaomoji) with searchable tags
  final List<ContentItem> defaultEmoticons = [
    ContentItem(id: '1', content: '(˶ᵔ ᵕ ᵔ˶)', type: ContentType.emoticon, tags: ['happy', 'smile', 'cute', 'joy']),
    ContentItem(id: '2', content: '(っ＾▿＾)💨', type: ContentType.emoticon, tags: ['excited', 'happy', 'running']),
    ContentItem(id: '3', content: '(╥﹏╥)', type: ContentType.emoticon, tags: ['sad', 'cry', 'tears', 'upset']),
    ContentItem(id: '4', content: '(づ ◕‿◕ )づ', type: ContentType.emoticon, tags: ['hug', 'love', 'cute', 'happy']),
    ContentItem(id: '5', content: '(｡•́︿•̀｡)', type: ContentType.emoticon, tags: ['sad', 'disappointed', 'upset']),
    ContentItem(id: '6', content: '(ﾉ◕ヮ◕)ﾉ*:･ﾟ✧', type: ContentType.emoticon, tags: ['magic', 'sparkle', 'excited', 'happy']),
    ContentItem(id: '7', content: '(¬‿¬)', type: ContentType.emoticon, tags: ['smirk', 'mischief', 'sly']),
    ContentItem(id: '8', content: '(⊙_⊙)', type: ContentType.emoticon, tags: ['shocked', 'surprise', 'confused']),
    ContentItem(id: '9', content: '(◕‿◕✿)', type: ContentType.emoticon, tags: ['happy', 'cute', 'flower', 'smile']),
    ContentItem(id: '10', content: '(ง •̀_•́)ง', type: ContentType.emoticon, tags: ['fight', 'determined', 'strong']),
    ContentItem(id: '11', content: '(´｡• ᵕ •｡`)', type: ContentType.emoticon, tags: ['shy', 'cute', 'blush', 'happy']),
    ContentItem(id: '12', content: '(╯°□°）╯︵ ┻━┻', type: ContentType.emoticon, tags: ['angry', 'rage', 'flip', 'table']),
    ContentItem(id: '13', content: '┬─┬ノ( º _ ºノ)', type: ContentType.emoticon, tags: ['calm', 'fix', 'table', 'sorry']),
    ContentItem(id: '14', content: '(｡♥‿♥｡)', type: ContentType.emoticon, tags: ['love', 'heart', 'happy', 'cute']),
    ContentItem(id: '15', content: '(¬_¬")', type: ContentType.emoticon, tags: ['annoyed', 'skeptical', 'doubt']),
    ContentItem(id: '16', content: '(◠‿◠✿)', type: ContentType.emoticon, tags: ['sweet', 'happy', 'cute', 'smile']),
    ContentItem(id: '17', content: '(｡•́︿•̀｡)', type: ContentType.emoticon, tags: ['sad', 'pout', 'upset']),
    ContentItem(id: '18', content: '(づ｡◕‿‿◕｡)づ', type: ContentType.emoticon, tags: ['hug', 'love', 'cuddle', 'cute']),
    ContentItem(id: '19', content: '(⌐■_■)', type: ContentType.emoticon, tags: ['cool', 'sunglasses', 'swag']),
    ContentItem(id: '20', content: '(｡･ω･｡)', type: ContentType.emoticon, tags: ['cute', 'cat', 'happy']),
    ContentItem(id: '21', content: '(☞ﾟヮﾟ)☞', type: ContentType.emoticon, tags: ['pointing', 'cool', 'hey']),
    ContentItem(id: '22', content: '☜(ﾟヮﾟ☜)', type: ContentType.emoticon, tags: ['pointing', 'cool', 'hey']),
    ContentItem(id: '23', content: '(っ˘ڡ˘ς)', type: ContentType.emoticon, tags: ['yummy', 'food', 'delicious', 'hungry']),
    ContentItem(id: '24', content: '(｡◕‿◕｡)', type: ContentType.emoticon, tags: ['happy', 'cute', 'smile', 'joy']),
    ContentItem(id: '25', content: '(ᵔᴥᵔ)', type: ContentType.emoticon, tags: ['bear', 'cute', 'happy', 'animal']),
    ContentItem(id: '26', content: '(￣︶￣)', type: ContentType.emoticon, tags: ['content', 'satisfied', 'happy']),
    ContentItem(id: '27', content: '(˘▾˘~)', type: ContentType.emoticon, tags: ['sleepy', 'tired', 'relaxed']),
    ContentItem(id: '28', content: '(╬ಠ益ಠ)', type: ContentType.emoticon, tags: ['angry', 'mad', 'rage', 'furious']),
    ContentItem(id: '29', content: '(ノಠ益ಠ)ノ彡┻━┻', type: ContentType.emoticon, tags: ['angry', 'flip', 'table', 'rage']),
    ContentItem(id: '30', content: '(◕ᴗ◕✿)', type: ContentType.emoticon, tags: ['happy', 'cute', 'flower', 'sweet']),
    ContentItem(id: '31', content: '(´• ω •`)', type: ContentType.emoticon, tags: ['cute', 'happy', 'soft', 'gentle']),
    ContentItem(id: '32', content: '(o˘◡˘o)', type: ContentType.emoticon, tags: ['happy', 'content', 'smile']),
    ContentItem(id: '33', content: '(｡･∀･)ﾉﾞ', type: ContentType.emoticon, tags: ['wave', 'hi', 'hello', 'greeting']),
    ContentItem(id: '34', content: '(づ￣ ³￣)づ', type: ContentType.emoticon, tags: ['kiss', 'love', 'hug', 'affection']),
    ContentItem(id: '35', content: '(｡･ω･｡)ﾉ♡', type: ContentType.emoticon, tags: ['love', 'wave', 'heart', 'cute']),
    ContentItem(id: '36', content: '(͡° ͜ʖ ͡°)', type: ContentType.emoticon, tags: ['lenny', 'meme', 'smirk', 'suspicious']),
    ContentItem(id: '37', content: 'ಠ_ಠ', type: ContentType.emoticon, tags: ['disapprove', 'judgement', 'look']),
    ContentItem(id: '38', content: '¯\\_(ツ)_/¯', type: ContentType.emoticon, tags: ['shrug', 'idk', 'whatever', 'dunno']),
    ContentItem(id: '39', content: '(ಥ﹏ಥ)', type: ContentType.emoticon, tags: ['cry', 'sad', 'tears', 'upset']),
    ContentItem(id: '40', content: '(´• ω •`)ﾉ', type: ContentType.emoticon, tags: ['wave', 'bye', 'hello', 'cute']),
  ];

  // Get all unique tags from emoticons
  List<String> get allTags {
    final tagSet = <String>{};
    for (var item in defaultEmoticons) {
      tagSet.addAll(item.tags);
    }
    return tagSet.toList()..sort();
  }

  // Filter emoticons based on search query and selected tag
  List<ContentItem> get filteredEmoticons {
    var results = defaultEmoticons;
    
    // Filter by selected tag first
    if (_selectedTag != null) {
      results = results.where((item) => item.tags.contains(_selectedTag)).toList();
    }
    
    // Then filter by search query
    if (_searchQuery.isNotEmpty) {
      final query = _searchQuery.toLowerCase();
      results = results.where((item) {
        return item.tags.any((tag) => tag.contains(query)) ||
               item.content.contains(query);
      }).toList();
    }
    
    return results;
  }

  // Copy emoticon to clipboard when tapped
  void _copyToClipboard(String emoticon) {
    Clipboard.setData(ClipboardData(text: emoticon));
    
    // Show a quick message that it was copied
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Copied $emoticon'),
        duration: const Duration(milliseconds: 800),
        behavior: SnackBarBehavior.floating,
        backgroundColor: const Color(0xFF496853),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Search Bar with Filter Button
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              // Search Field
              Expanded(
                child: TextField(
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value;
                    });
                  },
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'Find it!...',
                    hintStyle: const TextStyle(color: Color(0xFF777A8D), fontSize: 14),
                    prefixIcon: const Icon(Icons.search, color: Color(0xFF777A8D)),
                    filled: true,
                    fillColor: const Color(0xFF262932),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
              
              const SizedBox(width: 8),
              
              // Filter Button
              InkWell(
                onTap: () {
                  setState(() {
                    _showTagFilters = !_showTagFilters;
                  });
                },
                child: Container(
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                    color: _selectedTag != null 
                        ? const Color(0xFF496853) 
                        : const Color(0xFF262932),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Icon(
                        Icons.filter_list,
                        color: _selectedTag != null ? Colors.white : const Color(0xFF777A8D),
                      ),
                      if (_selectedTag != null)
                        Positioned(
                          top: 8,
                          right: 8,
                          child: Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        
        // Tag Filter Section - Expandable (Below search bar)
        if (_showTagFilters)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              children: [
                // Selected tag display with clear button
                if (_selectedTag != null)
                  Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                    decoration: BoxDecoration(
                      color: const Color(0xFF496853),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Tag: $_selectedTag',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedTag = null;
                            });
                          },
                          child: const Icon(
                            Icons.close,
                            color: Colors.white,
                            size: 18,
                          ),
                        ),
                      ],
                    ),
                  ),
                
                // Tag Chips
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1A1B21),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: allTags.map((tag) {
                      final isSelected = _selectedTag == tag;
                      return InkWell(
                        onTap: () {
                          setState(() {
                            _selectedTag = isSelected ? null : tag;
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: isSelected 
                                ? const Color(0xFF496853) 
                                : const Color(0xFF262932),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: isSelected 
                                  ? const Color(0xFF496853) 
                                  : const Color(0xFF3A3B44),
                            ),
                          ),
                          child: Text(
                            tag,
                            style: TextStyle(
                              color: isSelected ? Colors.white : const Color(0xFF777A8D),
                              fontSize: 12,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
        
        const SizedBox(height: 12),
        
        // Grid of Emoticons
        Expanded(
          child: filteredEmoticons.isEmpty
              ? const Center(
                  child: Text(
                    'No emoticons found',
                    style: TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3, // 4 columns for text-based emoticons
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 2.5, // Wider boxes for text
                    ),
                    itemCount: filteredEmoticons.length,
                    itemBuilder: (context, index) {
                      final item = filteredEmoticons[index];
                      
                      return InkWell(
                        onTap: () => _copyToClipboard(item.content),
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          decoration: BoxDecoration(
                            color: const Color(0xFF262932),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Center(
                            child: Text(
                              item.content,
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
        )
      ],
    );
  }
}
