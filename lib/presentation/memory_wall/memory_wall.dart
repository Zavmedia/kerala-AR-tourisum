import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/custom_bottom_bar.dart';
import './widgets/memory_context_menu_widget.dart';
import './widgets/memory_grid_widget.dart';
import './widgets/memory_search_widget.dart';
import './widgets/memory_stats_widget.dart';

class MemoryWall extends StatefulWidget {
  const MemoryWall({super.key});

  @override
  State<MemoryWall> createState() => _MemoryWallState();
}

class _MemoryWallState extends State<MemoryWall> with TickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  final ImagePicker _imagePicker = ImagePicker();

  List<CameraDescription> _cameras = [];
  CameraController? _cameraController;
  bool _isCameraInitialized = false;
  bool _isLoading = false;
  bool _isRefreshing = false;

  String _searchQuery = '';
  String _selectedFilter = 'all';
  Map<String, dynamic>? _selectedMemory;
  bool _showContextMenu = false;

  late AnimationController _fabAnimationController;
  late Animation<double> _fabScaleAnimation;

  // Mock data for memories
  List<Map<String, dynamic>> _allMemories = [
    {
      "id": 1,
      "type": "photo",
      "imageUrl":
          "https://images.pexels.com/photos/2166711/pexels-photo-2166711.jpeg?auto=compress&cs=tinysrgb&w=800",
      "location": "Mattancherry Palace, Kochi",
      "date": "2 days ago",
      "likes": 24,
      "comments": 8,
      "width": 400,
      "height": 600,
      "culturalTheme": "heritage",
    },
    {
      "id": 2,
      "type": "video",
      "thumbnail":
          "https://images.pexels.com/photos/3408744/pexels-photo-3408744.jpeg?auto=compress&cs=tinysrgb&w=800",
      "imageUrl":
          "https://images.pexels.com/photos/3408744/pexels-photo-3408744.jpeg?auto=compress&cs=tinysrgb&w=800",
      "location": "Backwaters, Alleppey",
      "date": "5 days ago",
      "likes": 42,
      "comments": 15,
      "width": 600,
      "height": 400,
      "culturalTheme": "nature",
    },
    {
      "id": 3,
      "type": "ar",
      "imageUrl":
          "https://images.pexels.com/photos/1007426/pexels-photo-1007426.jpeg?auto=compress&cs=tinysrgb&w=800",
      "location": "Padmanabhaswamy Temple, Thiruvananthapuram",
      "date": "1 week ago",
      "likes": 67,
      "comments": 23,
      "width": 500,
      "height": 700,
      "culturalTheme": "temple",
    },
    {
      "id": 4,
      "type": "note",
      "content":
          "The intricate wood carvings at Mattancherry Palace tell stories of Kerala's rich maritime history. Each panel depicts scenes of trade, cultural exchange, and royal ceremonies that shaped this coastal region.",
      "location": "Mattancherry Palace, Kochi",
      "date": "1 week ago",
      "likes": 18,
      "comments": 5,
      "width": 300,
      "height": 400,
      "culturalTheme": "heritage",
    },
    {
      "id": 5,
      "type": "photo",
      "imageUrl":
          "https://images.pexels.com/photos/3889855/pexels-photo-3889855.jpeg?auto=compress&cs=tinysrgb&w=800",
      "location": "Munnar Tea Gardens",
      "date": "2 weeks ago",
      "likes": 89,
      "comments": 31,
      "width": 600,
      "height": 450,
      "culturalTheme": "nature",
    },
    {
      "id": 6,
      "type": "video",
      "thumbnail":
          "https://images.pexels.com/photos/1007426/pexels-photo-1007426.jpeg?auto=compress&cs=tinysrgb&w=800",
      "imageUrl":
          "https://images.pexels.com/photos/1007426/pexels-photo-1007426.jpeg?auto=compress&cs=tinysrgb&w=800",
      "location": "Kathakali Performance, Fort Kochi",
      "date": "2 weeks ago",
      "likes": 156,
      "comments": 47,
      "width": 400,
      "height": 600,
      "culturalTheme": "performance",
    },
    {
      "id": 7,
      "type": "ar",
      "imageUrl":
          "https://images.pixabay.com/photo/2019/11/07/20/24/kerala-4609866_1280.jpg",
      "location": "Chinese Fishing Nets, Fort Kochi",
      "date": "3 weeks ago",
      "likes": 73,
      "comments": 19,
      "width": 500,
      "height": 400,
      "culturalTheme": "heritage",
    },
    {
      "id": 8,
      "type": "photo",
      "imageUrl":
          "https://images.unsplash.com/photo-1602216056096-3b40cc0c9944?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80",
      "location": "Spice Markets, Thekkady",
      "date": "3 weeks ago",
      "likes": 45,
      "comments": 12,
      "width": 400,
      "height": 500,
      "culturalTheme": "market",
    },
  ];

  List<Map<String, dynamic>> _filteredMemories = [];

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _initializeCamera();
    _filteredMemories = List.from(_allMemories);
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _cameraController?.dispose();
    _fabAnimationController.dispose();
    super.dispose();
  }

  void _initializeAnimations() {
    _fabAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _fabScaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.1,
    ).animate(CurvedAnimation(
      parent: _fabAnimationController,
      curve: Curves.elasticOut,
    ));
  }

  Future<void> _initializeCamera() async {
    try {
      if (!kIsWeb) {
        final hasPermission = await _requestCameraPermission();
        if (!hasPermission) return;
      }

      _cameras = await availableCameras();
      if (_cameras.isNotEmpty) {
        final camera = kIsWeb
            ? _cameras.firstWhere(
                (c) => c.lensDirection == CameraLensDirection.front,
                orElse: () => _cameras.first,
              )
            : _cameras.firstWhere(
                (c) => c.lensDirection == CameraLensDirection.back,
                orElse: () => _cameras.first,
              );

        _cameraController = CameraController(
          camera,
          kIsWeb ? ResolutionPreset.medium : ResolutionPreset.high,
        );

        await _cameraController!.initialize();
        await _applySettings();

        if (mounted) {
          setState(() {
            _isCameraInitialized = true;
          });
        }
      }
    } catch (e) {
      debugPrint('Camera initialization error: \$e');
    }
  }

  Future<bool> _requestCameraPermission() async {
    if (kIsWeb) return true;
    final status = await Permission.camera.request();
    return status.isGranted;
  }

  Future<void> _applySettings() async {
    if (_cameraController == null) return;

    try {
      await _cameraController!.setFocusMode(FocusMode.auto);
      if (!kIsWeb) {
        try {
          await _cameraController!.setFlashMode(FlashMode.auto);
        } catch (e) {
          debugPrint('Flash mode not supported: \$e');
        }
      }
    } catch (e) {
      debugPrint('Camera settings error: \$e');
    }
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      _loadMoreMemories();
    }
  }

  Future<void> _loadMoreMemories() async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
    });

    await Future.delayed(const Duration(seconds: 1));

    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _refreshMemories() async {
    if (_isRefreshing) return;

    setState(() {
      _isRefreshing = true;
    });

    await Future.delayed(const Duration(seconds: 1));

    if (mounted) {
      setState(() {
        _isRefreshing = false;
      });
      _applyFilters();
    }
  }

  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query;
    });
    _applyFilters();
  }

  void _onFilterChanged(String filter) {
    setState(() {
      _selectedFilter = filter;
    });
    _applyFilters();
  }

  void _applyFilters() {
    List<Map<String, dynamic>> filtered = List.from(_allMemories);

    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((memory) {
        final location = (memory['location'] as String? ?? '').toLowerCase();
        final theme = (memory['culturalTheme'] as String? ?? '').toLowerCase();
        final content = (memory['content'] as String? ?? '').toLowerCase();
        final query = _searchQuery.toLowerCase();

        return location.contains(query) ||
            theme.contains(query) ||
            content.contains(query);
      }).toList();
    }

    if (_selectedFilter != 'all') {
      String filterType = _selectedFilter;
      if (filterType == 'photos') filterType = 'photo';
      if (filterType == 'videos') filterType = 'video';
      if (filterType == 'notes') filterType = 'note';

      filtered = filtered.where((memory) {
        return (memory['type'] as String) == filterType;
      }).toList();
    }

    setState(() {
      _filteredMemories = filtered;
    });
  }

  void _onMemoryTap(Map<String, dynamic> memory) {
    _showMemoryDetail(memory);
  }

  void _onMemoryLongPress(Map<String, dynamic> memory) {
    setState(() {
      _selectedMemory = memory;
      _showContextMenu = true;
    });
  }

  void _showMemoryDetail(Map<String, dynamic> memory) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildMemoryDetailSheet(memory),
    );
  }

  Widget _buildMemoryDetailSheet(Map<String, dynamic> memory) {
    return DraggableScrollableSheet(
      initialChildSize: 0.9,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: AppTheme.lightTheme.colorScheme.surface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              Container(
                width: 10.w,
                height: 0.5.h,
                margin: EdgeInsets.symmetric(vertical: 2.h),
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.outline
                      .withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  controller: scrollController,
                  padding: EdgeInsets.all(4.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (memory['type'] != 'note')
                        ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: CustomImageWidget(
                            imageUrl: memory['imageUrl'] as String? ??
                                memory['thumbnail'] as String? ??
                                '',
                            width: double.infinity,
                            height: 50.h,
                            fit: BoxFit.cover,
                          ),
                        ),
                      SizedBox(height: 3.h),
                      Row(
                        children: [
                          CustomIconWidget(
                            iconName: 'location_on',
                            color: AppTheme.lightTheme.colorScheme.primary,
                            size: 5.w,
                          ),
                          SizedBox(width: 2.w),
                          Expanded(
                            child: Text(
                              memory['location'] as String? ??
                                  'Unknown Location',
                              style: AppTheme.lightTheme.textTheme.titleLarge,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        memory['date'] as String? ?? '',
                        style:
                            AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                          color: AppTheme.lightTheme.colorScheme.onSurface
                              .withValues(alpha: 0.7),
                        ),
                      ),
                      if (memory['content'] != null) ...[
                        SizedBox(height: 3.h),
                        Text(
                          memory['content'] as String,
                          style: AppTheme.lightTheme.textTheme.bodyLarge,
                        ),
                      ],
                      SizedBox(height: 3.h),
                      Row(
                        children: [
                          _buildEngagementButton('favorite',
                              memory['likes'] as int? ?? 0, Colors.red),
                          SizedBox(width: 4.w),
                          _buildEngagementButton(
                              'comment',
                              memory['comments'] as int? ?? 0,
                              AppTheme.lightTheme.colorScheme.primary),
                          const Spacer(),
                          IconButton(
                            onPressed: () => _shareMemory(memory),
                            icon: CustomIconWidget(
                              iconName: 'share',
                              color: AppTheme.lightTheme.colorScheme.onSurface
                                  .withValues(alpha: 0.7),
                              size: 6.w,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildEngagementButton(String iconName, int count, Color color) {
    return Row(
      children: [
        CustomIconWidget(
          iconName: iconName,
          color: color,
          size: 5.w,
        ),
        SizedBox(width: 1.w),
        Text(
          count.toString(),
          style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
            color: AppTheme.lightTheme.colorScheme.onSurface
                .withValues(alpha: 0.7),
          ),
        ),
      ],
    );
  }

  Future<void> _captureMemory() async {
    _fabAnimationController.forward().then((_) {
      _fabAnimationController.reverse();
    });

    if (!_isCameraInitialized) {
      await _initializeCamera();
    }

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => _buildCaptureSheet(),
    );
  }

  Widget _buildCaptureSheet() {
    return Container(
      height: 40.h,
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          Container(
            width: 10.w,
            height: 0.5.h,
            margin: EdgeInsets.symmetric(vertical: 2.h),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.outline
                  .withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(4.w),
            child: Text(
              'Capture Memory',
              style: AppTheme.lightTheme.textTheme.titleLarge,
            ),
          ),
          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              padding: EdgeInsets.all(4.w),
              crossAxisSpacing: 4.w,
              mainAxisSpacing: 4.w,
              children: [
                _buildCaptureOption(
                  'AR Camera',
                  'view_in_ar',
                  AppTheme.lightTheme.colorScheme.primary,
                  () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, '/ar-camera-experience');
                  },
                ),
                _buildCaptureOption(
                  'Take Photo',
                  'camera_alt',
                  AppTheme.lightTheme.colorScheme.secondary,
                  () => _takePhoto(),
                ),
                _buildCaptureOption(
                  'Gallery',
                  'photo_library',
                  AppTheme.lightTheme.colorScheme.tertiary,
                  () => _pickFromGallery(),
                ),
                _buildCaptureOption(
                  'Add Note',
                  'note_add',
                  AppTheme.goldLight,
                  () => _addNote(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCaptureOption(
      String title, String iconName, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: color.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomIconWidget(
              iconName: iconName,
              color: color,
              size: 8.w,
            ),
            SizedBox(height: 2.h),
            Text(
              title,
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: color,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _takePhoto() async {
    Navigator.pop(context);

    if (_cameraController != null && _cameraController!.value.isInitialized) {
      try {
        final XFile photo = await _cameraController!.takePicture();
        _showSuccessMessage('Photo captured successfully!');
      } catch (e) {
        _showErrorMessage('Failed to capture photo');
      }
    } else {
      _showErrorMessage('Camera not available');
    }
  }

  Future<void> _pickFromGallery() async {
    Navigator.pop(context);

    try {
      final XFile? image =
          await _imagePicker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        _showSuccessMessage('Image selected from gallery!');
      }
    } catch (e) {
      _showErrorMessage('Failed to pick image from gallery');
    }
  }

  void _addNote() {
    Navigator.pop(context);
    _showSuccessMessage('Note feature coming soon!');
  }

  void _editMemory() {
    _showSuccessMessage('Edit feature coming soon!');
  }

  void _shareMemory(Map<String, dynamic> memory) {
    _showSuccessMessage('Memory shared successfully!');
  }

  void _addToStory() {
    _showSuccessMessage('Added to story successfully!');
  }

  void _deleteMemory() {
    if (_selectedMemory != null) {
      setState(() {
        _allMemories
            .removeWhere((memory) => memory['id'] == _selectedMemory!['id']);
        _applyFilters();
      });
      _showSuccessMessage('Memory deleted successfully!');
    }
  }

  void _showSuccessMessage(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: AppTheme.lightTheme.colorScheme.primary,
      textColor: AppTheme.lightTheme.colorScheme.onPrimary,
    );
  }

  void _showErrorMessage(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: AppTheme.lightTheme.colorScheme.error,
      textColor: AppTheme.lightTheme.colorScheme.onError,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: const CustomAppBar(
        title: 'Memory Wall',
        variant: CustomAppBarVariant.standard,
      ),
      body: Stack(
        children: [
          Column(
            children: [
              MemoryStatsWidget(
                sitesVisited: 12,
                photosCaptured: 89,
                arExperiences: 15,
                socialShares: 34,
              ),
              MemorySearchWidget(
                onSearchChanged: _onSearchChanged,
                onFilterChanged: _onFilterChanged,
                onClearSearch: () {
                  setState(() {
                    _searchQuery = '';
                  });
                  _applyFilters();
                },
              ),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: _refreshMemories,
                  color: AppTheme.lightTheme.colorScheme.primary,
                  child: MemoryGridWidget(
                    memories: _filteredMemories,
                    onMemoryTap: _onMemoryTap,
                    onMemoryLongPress: _onMemoryLongPress,
                    scrollController: _scrollController,
                  ),
                ),
              ),
            ],
          ),
          if (_showContextMenu && _selectedMemory != null)
            MemoryContextMenuWidget(
              memory: _selectedMemory!,
              onEdit: _editMemory,
              onShare: () => _shareMemory(_selectedMemory!),
              onAddToStory: _addToStory,
              onDelete: _deleteMemory,
              onClose: () {
                setState(() {
                  _showContextMenu = false;
                  _selectedMemory = null;
                });
              },
            ),
        ],
      ),
      floatingActionButton: AnimatedBuilder(
        animation: _fabScaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _fabScaleAnimation.value,
            child: FloatingActionButton(
              onPressed: _captureMemory,
              backgroundColor: AppTheme.lightTheme.colorScheme.tertiary,
              foregroundColor: AppTheme.lightTheme.colorScheme.onTertiary,
              child: CustomIconWidget(
                iconName: 'camera_alt',
                color: AppTheme.lightTheme.colorScheme.onTertiary,
                size: 6.w,
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: const CustomBottomBar(
        currentIndex: 3,
        variant: CustomBottomBarVariant.standard,
      ),
    );
  }
}
