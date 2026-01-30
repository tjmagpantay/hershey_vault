import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:io';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';
import '../models/content_item.dart';
import '../services/favorites_manager.dart';
import '../data/content_data.dart';

class MemePage extends StatefulWidget {
  const MemePage({super.key});

  @override
  State<MemePage> createState() => _MemePageState();
}

class _MemePageState extends State<MemePage> {
  String _searchQuery = '';
  String? _selectedTag;
  bool _showTagFilters = false;
  final FavoritesManager _favoritesManager = FavoritesManager();
  String? _animatingHeartId;
  
  // Use shared data
  List<ContentItem> get defaultMemes => ContentData.memes;

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

  List<String> get allTags {
    final tagSet = <String>{};
    for (var item in defaultMemes) {
      tagSet.addAll(item.tags);
    }
    return tagSet.toList()..sort();
  }

  List<ContentItem> get filteredMemes {
    var results = defaultMemes;
    
    if (_selectedTag != null) {
      results = results.where((item) => item.tags.contains(_selectedTag)).toList();
    }
    
    if (_searchQuery.isNotEmpty) {
      final query = _searchQuery.toLowerCase();
      results = results.where((item) {
        return item.tags.any((tag) => tag.contains(query));
      }).toList();
    }
    
    return results;
  }

  void _copyToClipboard(String content) {
    // Directly share the image when tapped
    _shareImage(content);
  }

  void _shareImage(String content) async {
    try {
      print('Attempting to share: $content');
      
      String filePath;
      
      // Check if it's an asset or a file path
      if (content.startsWith('assets/')) {
        // It's an asset - copy to temp directory first
        final ByteData data = await rootBundle.load(content);
        final List<int> bytes = data.buffer.asUint8List();
        
        // Get temporary directory
        final tempDir = await getTemporaryDirectory();
        final fileName = content.split('/').last;
        final tempFile = File('${tempDir.path}/$fileName');
        
        // Write asset to temp file
        await tempFile.writeAsBytes(bytes);
        filePath = tempFile.path;
        
        print('Asset copied to: $filePath');
      } else {
        // It's already a file path
        filePath = content;
      }
      
      // Share the file
      await Share.shareXFiles(
        [XFile(filePath)],
        text: 'Check out this meme!',
      );
      
      print('Share completed');
    } catch (e) {
      print('Share error: $e');
      
      // Silently handle cancellation
      final errorMsg = e.toString().toLowerCase();
      if (errorMsg.contains('cancelled') || 
          errorMsg.contains('did not call back') ||
          errorMsg.contains('user cancelled')) {
        return;
      }
      
      // Only show error for actual failures
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Unable to share: ${e.toString()}'),
            duration: const Duration(milliseconds: 2500),
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.orange,
          ),
        );
      }
    }
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
              Expanded(
                child: TextField(
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value;
                    });
                  },
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'Search memes...',
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
        
        // Tag Filter Section
        if (_showTagFilters)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              children: [
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
        
        // Grid of Memes - 2 columns
        Expanded(
          child: filteredMemes.isEmpty
              ? const Center(
                  child: Text(
                    'No memes found',
                    style: TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, // 2 columns for memes
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 1, // Square boxes
                    ),
                    itemCount: filteredMemes.length,
                    itemBuilder: (context, index) {
                      final item = filteredMemes[index];
                      final isFavorite = _favoritesManager.isFavorite(item.id);
                      final isAnimating = _animatingHeartId == item.id;
                      
                      return GestureDetector(
                        onTap: () => _copyToClipboard(item.content),
                        onDoubleTap: () => _handleDoubleTap(item),
                        onLongPress: () => _shareImage(item.content),
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
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: _buildImageWidget(item.content),
                              ),
                            ),
                            if (isFavorite)
                              Positioned(
                                top: 8,
                                right: 8,
                                child: Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    color: Colors.black54,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: const Icon(
                                    Icons.favorite,
                                    color: Color(0xFF496853),
                                    size: 16,
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
                                          size: 80,
                                          shadows: [
                                            Shadow(
                                              blurRadius: 20,
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

  Widget _buildImageWidget(String path) {
    // Check if it's a file path (user added) or asset path (default)
    if (path.startsWith('/') || path.contains(':\\')) {
      // It's a file path
      return Image.file(
        File(path),
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
        errorBuilder: (context, error, stackTrace) {
          return const Center(
            child: Icon(Icons.image, color: Colors.white54),
          );
        },
      );
    } else {
      // It's an asset path
      return Image.asset(
        path,
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
        errorBuilder: (context, error, stackTrace) {
          return const Center(
            child: Icon(Icons.image, color: Colors.white54),
          );
        },
      );
    }
  }
}
