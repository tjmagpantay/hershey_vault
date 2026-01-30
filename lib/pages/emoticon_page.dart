import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';
import '../models/content_item.dart';
import '../services/favorites_manager.dart';
import '../data/content_data.dart';

class EmoticonPage extends StatefulWidget {
  const EmoticonPage({super.key});

  @override
  State<EmoticonPage> createState() => _EmoticonPageState();
}

class _EmoticonPageState extends State<EmoticonPage> {
  String _searchQuery = '';
  String? _selectedTag;
  bool _showTagFilters = false;
  final FavoritesManager _favoritesManager = FavoritesManager();
  String? _animatingHeartId;
  
  // Use shared data
  List<ContentItem> get defaultEmoticons => ContentData.emoticons;

  @override
  void initState() {
    super.initState();
    _favoritesManager.addListener(_onFavoritesChanged);
  }

  @override
  void dispose() {
    _favoritesManager.removeListener(_onFavoritesChanged);
    super.dispose();
  }

  void _onFavoritesChanged() {
    if (mounted) setState(() {});
  }

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
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Copied to clipboard!'),
        duration: Duration(milliseconds: 800),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Color(0xFF496853),
      ),
    );
  }

  void _handleDoubleTap(ContentItem item) async {
    await _favoritesManager.toggleFavorite(item);
    
    setState(() {
      _animatingHeartId = item.id;
    });
    
    Future.delayed(const Duration(milliseconds: 1000), () {
      if (mounted) {
        setState(() {
          _animatingHeartId = null;
        });
      }
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _favoritesManager.isFavorite(item.id) 
              ? 'Added to favorites <3' 
              : 'Removed from favorites'
        ),
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
                      final isFavorite = _favoritesManager.isFavorite(item.id);
                      final isAnimating = _animatingHeartId == item.id;
                      
                      return GestureDetector(
                        onTap: () => _copyToClipboard(item.content),
                        onDoubleTap: () => _handleDoubleTap(item),
                        child: Stack(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: const Color(0xFF262932),
                                borderRadius: BorderRadius.circular(12),
                                border: isFavorite ? Border.all(
                                  color: const Color(0xFF496853),
                                  width: 2,
                                ) : null,
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
                            if (isFavorite)
                              Positioned(
                                top: 4,
                                right: 4,
                                child: Container(
                                  padding: const EdgeInsets.all(2),
                                  decoration: BoxDecoration(
                                    color: Colors.black54,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: const Icon(
                                    Icons.favorite,
                                    color: Color(0xFF496853),
                                    size: 10,
                                  ),
                                ),
                              ),
                            if (isAnimating)
                              Center(
                                child: TweenAnimationBuilder<double>(
                                  tween: Tween(begin: 0.0, end: 1.0),
                                  duration: const Duration(milliseconds: 600),
                                  curve: Curves.elasticOut,
                                  builder: (context, value, child) {
                                    return Transform.scale(
                                      scale: value,
                                      child: Opacity(
                                        opacity: 1.0 - (value * 0.5),
                                        child: const Icon(
                                          Icons.favorite,
                                          color: Color(0xFF496853),
                                          size: 40,
                                          shadows: [
                                            Shadow(
                                              blurRadius: 10,
                                              color: Colors.black54,
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                          ],
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
