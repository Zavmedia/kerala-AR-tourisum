import 'dart:async';
import 'dart:math';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:record/record.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/ar_model_info_popup.dart';
import './widgets/ar_overlay_controls.dart';
import './widgets/ar_side_panel.dart';
import './widgets/ar_subtitle_overlay.dart';
import './widgets/heritage_site_badge.dart';

class ArCameraExperience extends StatefulWidget {
  const ArCameraExperience({super.key});

  @override
  State<ArCameraExperience> createState() => _ArCameraExperienceState();
}

class _ArCameraExperienceState extends State<ArCameraExperience>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  // Camera and AR related variables
  CameraController? _cameraController;
  List<CameraDescription> _cameras = [];
  bool _isCameraInitialized = false;
  bool _isRecording = false;
  bool _isFlashOn = false;

  // AR and Location variables
  Position? _currentPosition;
  bool _isLocationEnabled = false;
  String _currentSiteName = '';
  double _siteDistance = 0.0;
  bool _isSiteDetected = false;
  bool _isARInitialized = false;
  bool _isARSessionActive = false;
  String? _currentModelId;

  // Audio and Narration variables
  final AudioRecorder _audioRecorder = AudioRecorder();
  bool _isNarrationPlaying = false;
  bool _showSubtitles = false;
  String _currentSubtitle = '';
  Timer? _subtitleTimer;

  // UI State variables
  bool _showSidePanel = false;
  bool _showModelPopup = false;
  Offset _popupPosition = Offset.zero;
  Map<String, dynamic>? _selectedModelData;
  Map<String, dynamic>? _currentSiteData;

  // Animation controllers
  late AnimationController _arAnimationController;
  late AnimationController _uiAnimationController;

  // Mock heritage sites data
  final List<Map<String, dynamic>> _heritageSites = [
    {
      'id': 1,
      'name': 'Mattancherry Palace',
      'latitude': 9.9591,
      'longitude': 76.2570,
      'period': '16th Century CE',
      'description':
          'Also known as the Dutch Palace, this magnificent structure showcases traditional Kerala architecture with Portuguese and Dutch influences.',
      'models': [
        {
          'id': 'model_1',
          'title': 'Original Palace Structure',
          'category': 'Architecture',
          'description':
              'The original 16th-century palace structure before colonial modifications.',
          'image':
              'https://images.unsplash.com/photo-1578662996442-48f60103fc96?w=800&q=80',
          'historicalContext':
              'Built by the Portuguese and later renovated by the Dutch, this palace served as the residence of the Cochin royal family.',
          'significance':
              'Represents the unique blend of European and traditional Kerala architectural styles.',
        },
        {
          'id': 'model_2',
          'title': 'Royal Coronation Hall',
          'category': 'Interior',
          'description':
              'The grand hall where Cochin rulers were crowned for centuries.',
          'image':
              'https://images.unsplash.com/photo-1571847140471-1d7766e825ea?w=800&q=80',
          'historicalContext':
              'This hall witnessed the coronation of 14 Cochin rulers from 1663 to 1949.',
          'significance':
              'Sacred space that symbolizes the continuity of Kerala royal traditions.',
        },
      ],
    },
    {
      'id': 2,
      'name': 'Chinese Fishing Nets',
      'latitude': 9.9654,
      'longitude': 76.2424,
      'period': '14th Century CE',
      'description':
          'Iconic cantilever fishing nets introduced by Chinese traders, now a symbol of Kochi.',
      'models': [
        {
          'id': 'model_3',
          'title': 'Traditional Fishing Net',
          'category': 'Maritime Heritage',
          'description':
              'Ancient Chinese cantilever fishing technique still in use today.',
          'image':
              'https://images.unsplash.com/photo-1544735716-392fe2489ffa?w=800&q=80',
          'historicalContext':
              'Brought to Kerala by Chinese explorer Zheng He during his maritime expeditions.',
          'significance':
              'Represents the historical maritime trade connections between Kerala and China.',
        },
      ],
    },
    {
      'id': 3,
      'name': 'St. Francis Church',
      'latitude': 9.9648,
      'longitude': 76.2423,
      'period': '1503 CE',
      'description':
          'The oldest European church in India, where Vasco da Gama was originally buried.',
      'models': [
        {
          'id': 'model_4',
          'title': 'Original Church Structure',
          'category': 'Religious Architecture',
          'description':
              'The first European church built in India by Portuguese explorers.',
          'image':
              'https://images.unsplash.com/photo-1520637836862-4d197d17c90a?w=800&q=80',
          'historicalContext':
              'Built in 1503 by Portuguese Franciscan friars, marking the beginning of European religious architecture in India.',
          'significance':
              'Symbolizes the arrival of European Christianity and colonial influence in Kerala.',
        },
      ],
    },
  ];

  // AR models with local assets
  final List<Map<String, String>> _localArModels = const [
    {
      'id': 'fort_kochi',
      'title': 'Fort Kochi',
      'assetPath': 'assets/models/fort_kochi.glb',
    },
    {
      'id': 'mattancherry_palace',
      'title': 'Mattancherry Palace',
      'assetPath': 'assets/models/mattancherry_palace.glb',
    },
    {
      'id': 'jewish_synagogue',
      'title': 'Paradesi Synagogue',
      'assetPath': 'assets/models/jewish_synagogue.glb',
    },
  ];

  // Mock subtitles data
  final List<String> _narrationSubtitles = [
    'Welcome to the historic Mattancherry Palace, a testament to Kerala\'s rich cultural heritage.',
    'Built in the 16th century, this palace showcases the unique blend of Portuguese, Dutch, and traditional Kerala architecture.',
    'The intricate murals you see here depict scenes from the great Indian epics - Ramayana and Mahabharata.',
    'Each room tells a story of the royal families who once called this magnificent structure home.',
    'Notice the traditional Kerala architectural elements seamlessly integrated with European influences.',
  ];

  int _currentSubtitleIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initializeAnimationControllers();
    _initializeCamera();
    _requestPermissions();
    _getCurrentLocation();
    _initializeAR();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _cameraController?.dispose();
    _audioRecorder.dispose();
    _arAnimationController.dispose();
    _uiAnimationController.dispose();
    _subtitleTimer?.cancel();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final CameraController? cameraController = _cameraController;
    if (cameraController == null || !cameraController.value.isInitialized) {
      return;
    }

    if (state == AppLifecycleState.inactive) {
      cameraController.dispose();
    } else if (state == AppLifecycleState.resumed) {
      _initializeCamera();
    }
  }

  Future<void> _initializeAR() async {
    try {
      final ok = await ARService.instance.initialize();
      if (mounted) {
        setState(() {
          _isARInitialized = ok;
        });
      }
      if (ok) {
        await ARService.instance.startARSession();
        if (mounted) {
          setState(() => _isARSessionActive = true);
        }
      }
    } catch (e) {
      debugPrint('AR init/session failed: $e');
    }
  }

  void _initializeAnimationControllers() {
    _arAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _uiAnimationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _arAnimationController.forward();
    _uiAnimationController.forward();
  }

  Future<void> _requestPermissions() async {
    final permissions = [
      Permission.camera,
      Permission.microphone,
      Permission.location,
      Permission.storage,
    ];

    await permissions.request();
  }

  Future<void> _initializeCamera() async {
    try {
      _cameras = await availableCameras();
      if (_cameras.isEmpty) return;

      final camera = _cameras.firstWhere(
        (camera) => camera.lensDirection == CameraLensDirection.back,
        orElse: () => _cameras.first,
      );

      _cameraController = CameraController(
        camera,
        ResolutionPreset.high,
        enableAudio: true,
      );

      await _cameraController!.initialize();
      await _cameraController!.setFocusMode(FocusMode.auto);
      await _cameraController!.setFlashMode(FlashMode.auto);

      if (mounted) {
        setState(() {
          _isCameraInitialized = true;
        });
      }
    } catch (e) {
      debugPrint('Error initializing camera: $e');
    }
  }

  Future<void> _getCurrentLocation() async {
    try {
      final permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        await Geolocator.requestPermission();
      }

      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      setState(() {
        _currentPosition = position;
        _isLocationEnabled = true;
      });

      _detectNearbyHeritageSites();
    } catch (e) {
      debugPrint('Error getting location: $e');
    }
  }

  void _detectNearbyHeritageSites() {
    if (_currentPosition == null) return;

    for (final site in _heritageSites) {
      final distance = Geolocator.distanceBetween(
        _currentPosition!.latitude,
        _currentPosition!.longitude,
        site['latitude'] as double,
        site['longitude'] as double,
      );

      if (distance <= 500) {
        // Within 500 meters
        setState(() {
          _isSiteDetected = true;
          _currentSiteName = site['name'] as String;
          _siteDistance = distance;
          _currentSiteData = site;
        });
        break;
      }
    }
  }

  Future<void> _capturePhoto() async {
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      return;
    }

    try {
      HapticFeedback.lightImpact();
      final XFile photo = await _cameraController!.takePicture();

      // Show success feedback
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Photo captured successfully!'),
          backgroundColor: AppTheme.lightTheme.colorScheme.primary,
          duration: const Duration(seconds: 2),
        ),
      );
    } catch (e) {
      debugPrint('Error capturing photo: $e');
    }
  }

  Future<void> _toggleVideoRecording() async {
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      return;
    }

    try {
      if (_isRecording) {
        await _cameraController!.stopVideoRecording();
        setState(() {
          _isRecording = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Video recording stopped'),
            backgroundColor: AppTheme.lightTheme.colorScheme.primary,
          ),
        );
      } else {
        await _cameraController!.startVideoRecording();
        setState(() {
          _isRecording = true;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Video recording started'),
            backgroundColor: AppTheme.lightTheme.colorScheme.error,
          ),
        );
      }

      HapticFeedback.mediumImpact();
    } catch (e) {
      debugPrint('Error toggling video recording: $e');
    }
  }

  void _openGallery() {
    Navigator.pushNamed(context, '/memory-wall');
  }

  void _openSettings() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildSettingsBottomSheet(),
    );
  }

  Future<void> _onSelectModel(Map<String, String> model) async {
    if (!_isARInitialized) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('AR not initialized'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    try {
      // Load model once
      await ARService.instance.loadLocalModel(
        modelId: model['id']!,
        assetPath: model['assetPath']!,
        scale: 0.5,
        position: const [0, 0, -1.5],
        rotation: const [0, 0, 0],
      );
      setState(() => _currentModelId = model['id']);

      // Place in front of the camera
      await ARService.instance.placeModelAt(
        modelId: model['id']!,
        position: const [0, 0, -1.5],
        rotation: const [0, 0, 0],
        scale: 0.5,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Placed ${model['title']}'),
            backgroundColor: AppTheme.lightTheme.colorScheme.tertiary,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to place model: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _showModelPicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          padding: EdgeInsets.all(6.w),
          decoration: BoxDecoration(
            color: AppTheme.lightTheme.colorScheme.surface,
            borderRadius: BorderRadius.vertical(top: Radius.circular(6.w)),
          ),
          child: SafeArea(
            top: false,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Place 3D Model',
                      style: AppTheme.lightTheme.textTheme.titleLarge,
                    ),
                    if (_isARSessionActive)
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 0.8.h),
                        decoration: BoxDecoration(
                          color: AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(3.w),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.vrpano, size: 16, color: AppTheme.lightTheme.colorScheme.primary),
                            SizedBox(width: 2.w),
                            Text('AR Ready', style: AppTheme.lightTheme.textTheme.bodySmall),
                          ],
                        ),
                      ),
                  ],
                ),
                SizedBox(height: 2.h),
                ..._localArModels.map((m) => ListTile(
                      leading: Icon(Icons.threed_rotation, color: AppTheme.lightTheme.colorScheme.primary),
                      title: Text(m['title']!),
                      subtitle: Text(m['assetPath']!),
                      onTap: () {
                        Navigator.pop(context);
                        _onSelectModel(m);
                      },
                      trailing: _currentModelId == m['id']
                          ? Icon(Icons.check_circle, color: AppTheme.lightTheme.colorScheme.tertiary)
                          : null,
                    )),
                SizedBox(height: 1.h),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSettingsBottomSheet() {
    return Container(
      padding: EdgeInsets.all(6.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(6.w)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 12.w,
            height: 1.h,
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.outline,
              borderRadius: BorderRadius.circular(0.5.h),
            ),
          ),
          SizedBox(height: 3.h),
          Text(
            'AR Camera Settings',
            style: AppTheme.lightTheme.textTheme.titleLarge,
          ),
          SizedBox(height: 3.h),
          _buildSettingsTile(
            'Flash',
            _isFlashOn ? 'On' : 'Off',
            Icons.flash_on,
            () => _toggleFlash(),
          ),
          _buildSettingsTile(
            'Subtitles',
            _showSubtitles ? 'Enabled' : 'Disabled',
            Icons.closed_caption,
            () => _toggleSubtitles(),
          ),
          _buildSettingsTile(
            'Language',
            'Malayalam',
            Icons.language,
            () => _showLanguageOptions(),
          ),
          SizedBox(height: 4.h),
        ],
      ),
    );
  }

  Widget _buildSettingsTile(
      String title, String value, IconData icon, VoidCallback onTap) {
    return ListTile(
      leading: CustomIconWidget(
        iconName: icon.toString().split('.').last,
        color: AppTheme.lightTheme.colorScheme.primary,
        size: 6.w,
      ),
      title: Text(
        title,
        style: AppTheme.lightTheme.textTheme.bodyLarge,
      ),
      trailing: Text(
        value,
        style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
          color: AppTheme.lightTheme.colorScheme.primary,
        ),
      ),
      onTap: onTap,
    );
  }

  void _toggleFlash() async {
    if (_cameraController == null) return;

    try {
      final newFlashMode = _isFlashOn ? FlashMode.off : FlashMode.torch;
      await _cameraController!.setFlashMode(newFlashMode);
      setState(() {
        _isFlashOn = !_isFlashOn;
      });
      Navigator.pop(context);
    } catch (e) {
      debugPrint('Error toggling flash: $e');
    }
  }

  void _toggleSubtitles() {
    setState(() {
      _showSubtitles = !_showSubtitles;
    });
    Navigator.pop(context);
  }

  void _showLanguageOptions() {
    Navigator.pop(context);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Select Language'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            'Malayalam',
            'English',
            'Hindi',
            'Tamil',
          ]
              .map((language) => ListTile(
                    title: Text(language),
                    onTap: () => Navigator.pop(context),
                  ))
              .toList(),
        ),
      ),
    );
  }

  void _toggleSidePanel() {
    setState(() {
      _showSidePanel = !_showSidePanel;
    });
  }

  void _startNarration() {
    setState(() {
      _isNarrationPlaying = true;
      _showSubtitles = true;
      _currentSubtitleIndex = 0;
    });

    _playSubtitles();
  }

  void _pauseNarration() {
    setState(() {
      _isNarrationPlaying = false;
    });

    _subtitleTimer?.cancel();
  }

  void _playSubtitles() {
    _subtitleTimer = Timer.periodic(const Duration(seconds: 4), (timer) {
      if (_currentSubtitleIndex < _narrationSubtitles.length) {
        setState(() {
          _currentSubtitle = _narrationSubtitles[_currentSubtitleIndex];
          _currentSubtitleIndex++;
        });
      } else {
        timer.cancel();
        setState(() {
          _isNarrationPlaying = false;
          _currentSubtitle = '';
          _currentSubtitleIndex = 0;
        });
      }
    });

    // Start with first subtitle
    if (_narrationSubtitles.isNotEmpty) {
      setState(() {
        _currentSubtitle = _narrationSubtitles[0];
        _currentSubtitleIndex = 1;
      });
    }
  }

  void _handleModelTap(Offset position) {
    final random = Random();
    final modelIndex = random.nextInt(_arModels.length);

    setState(() {
      _selectedModelData = _arModels[modelIndex];
      _popupPosition = position;
      _showModelPopup = true;
    });
  }

  void _closeModelPopup() {
    setState(() {
      _showModelPopup = false;
      _selectedModelData = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Camera Preview
          _buildCameraPreview(),

          // AR Overlays
          if (_isSiteDetected)
            HeritageSiteBadge(
              siteName: _currentSiteName,
              distance: _siteDistance,
              isVisible: _isSiteDetected,
            ),

          // Camera Controls
          ArOverlayControls(
            onCapturePhoto: _capturePhoto,
            onCaptureVideo: _toggleVideoRecording,
            onGalleryAccess: _openGallery,
            onSettingsMenu: _openSettings,
            isRecording: _isRecording,
          ),

          // Place Model FAB
          Positioned(
            bottom: 6.h,
            left: 0,
            right: 0,
            child: Center(
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.lightTheme.colorScheme.primary,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 1.8.h),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(3.w)),
                ),
                onPressed: _isARInitialized ? _showModelPicker : null,
                icon: const Icon(Icons.view_in_ar),
                label: Text(_isARInitialized ? 'Place 3D Model' : 'Initializing AR...'),
              ),
            ),
          ),

          // Side Panel
          ArSidePanel(
            isVisible: _showSidePanel,
            siteData: _currentSiteData,
            onClose: _toggleSidePanel,
            onPlayNarration: _startNarration,
            onPauseNarration: _pauseNarration,
            isNarrationPlaying: _isNarrationPlaying,
          ),

          // Model Info Popup
          if (_showModelPopup && _selectedModelData != null)
            ArModelInfoPopup(
              modelData: _selectedModelData!,
              position: _popupPosition,
              isVisible: _showModelPopup,
              onClose: _closeModelPopup,
            ),

          // Subtitle Overlay
          if (_showSubtitles && _currentSubtitle.isNotEmpty)
            ArSubtitleOverlay(
              subtitle: _currentSubtitle,
              isVisible: _showSubtitles && _currentSubtitle.isNotEmpty,
              onToggleSubtitles: _toggleSubtitles,
            ),

          // Top Navigation
          _buildTopNavigation(),

          // Side Panel Toggle
          if (_isSiteDetected) _buildSidePanelToggle(),
        ],
      ),
    );
  }

  Widget _buildCameraPreview() {
    if (!_isCameraInitialized || _cameraController == null) {
      return Container(
        color: Colors.black,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(
                color: AppTheme.lightTheme.colorScheme.primary,
              ),
              SizedBox(height: 2.h),
              Text(
                'Initializing AR Camera...',
                style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return GestureDetector(
      onTapDown: (details) {
        _handleModelTap(details.globalPosition);
      },
      child: SizedBox.expand(
        child: CameraPreview(_cameraController!),
      ),
    );
  }

  Widget _buildTopNavigation() {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  padding: EdgeInsets.all(2.w),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.6),
                    borderRadius: BorderRadius.circular(2.w),
                  ),
                  child: CustomIconWidget(
                    iconName: 'arrow_back',
                    color: Colors.white,
                    size: 6.w,
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.5.h),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.6),
                  borderRadius: BorderRadius.circular(3.w),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 2.w,
                      height: 2.w,
                      decoration: BoxDecoration(
                        color: _isLocationEnabled
                            ? AppTheme.lightTheme.colorScheme.tertiary
                            : Colors.red,
                        shape: BoxShape.circle,
                      ),
                    ),
                    SizedBox(width: 2.w),
                    Text(
                      'AR Mode',
                      style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () =>
                    Navigator.pushNamed(context, '/heritage-dashboard'),
                child: Container(
                  padding: EdgeInsets.all(2.w),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.6),
                    borderRadius: BorderRadius.circular(2.w),
                  ),
                  child: CustomIconWidget(
                    iconName: 'home',
                    color: Colors.white,
                    size: 6.w,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSidePanelToggle() {
    return Positioned(
      right: 4.w,
      top: 50.h,
      child: GestureDetector(
        onTap: _toggleSidePanel,
        child: Container(
          padding: EdgeInsets.all(3.w),
          decoration: BoxDecoration(
            color: AppTheme.lightTheme.colorScheme.primary,
            borderRadius: BorderRadius.circular(3.w),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.3),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: CustomIconWidget(
            iconName: 'info',
            color: Colors.white,
            size: 6.w,
          ),
        ),
      ),
    );
  }
}
