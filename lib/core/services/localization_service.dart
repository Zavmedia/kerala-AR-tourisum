import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalizationService extends ChangeNotifier {
  static final LocalizationService _instance = LocalizationService._internal();
  factory LocalizationService() => _instance;
  LocalizationService._internal();

  static const String _defaultLanguage = 'en';
  static const String _defaultCountry = 'IN';
  
  Locale _currentLocale = const Locale(_defaultLanguage, _defaultCountry);
  Map<String, Map<String, String>> _translations = {};
  bool _isInitialized = false;

  // Supported languages
  static const List<Locale> supportedLocales = [
    Locale('en', 'IN'), // English (India)
    Locale('ml', 'IN'), // Malayalam
    Locale('hi', 'IN'), // Hindi
    Locale('ta', 'IN'), // Tamil
  ];

  // Language names in their native script
  static const Map<String, String> languageNames = {
    'en': 'English',
    'ml': 'മലയാളം',
    'hi': 'हिन्दी',
    'ta': 'தமிழ்',
  };

  // Country names in their native script
  static const Map<String, String> countryNames = {
    'IN': 'India',
    'IN_ml': 'ഭാരതം',
    'IN_hi': 'भारत',
    'IN_ta': 'இந்தியா',
  };

  Locale get currentLocale => _currentLocale;
  bool get isInitialized => _isInitialized;

  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      await _loadTranslations();
      await _loadSavedLanguage();
      _isInitialized = true;
      notifyListeners();
    } catch (e) {
      print('Localization service initialization failed: $e');
      rethrow;
    }
  }

  Future<void> _loadTranslations() async {
    // Load English translations (base language)
    _translations['en'] = await _loadLanguageFile('en');
    
    // Load other languages
    for (final locale in supportedLocales) {
      if (locale.languageCode != 'en') {
        try {
          _translations[locale.languageCode] = await _loadLanguageFile(locale.languageCode);
        } catch (e) {
          print('Failed to load ${locale.languageCode} translations: $e');
          // Fallback to English
          _translations[locale.languageCode] = _translations['en']!;
        }
      }
    }
  }

  Future<Map<String, String>> _loadLanguageFile(String languageCode) async {
    // In a real app, this would load from JSON files or API
    // For now, we'll use hardcoded translations
    switch (languageCode) {
      case 'en':
        return _getEnglishTranslations();
      case 'ml':
        return _getMalayalamTranslations();
      case 'hi':
        return _getHindiTranslations();
      case 'ta':
        return _getTamilTranslations();
      default:
        return _getEnglishTranslations();
    }
  }

  Map<String, String> _getEnglishTranslations() {
    return {
      // Common
      'app_name': 'Zenscape AR Tourism',
      'welcome': 'Welcome',
      'login': 'Login',
      'signup': 'Sign Up',
      'logout': 'Logout',
      'search': 'Search',
      'cancel': 'Cancel',
      'save': 'Save',
      'delete': 'Delete',
      'edit': 'Edit',
      'close': 'Close',
      'next': 'Next',
      'previous': 'Previous',
      'done': 'Done',
      'loading': 'Loading...',
      'error': 'Error',
      'success': 'Success',
      
      // Navigation
      'home': 'Home',
      'explore': 'Explore',
      'memories': 'Memories',
      'plan_trip': 'Plan Trip',
      'profile': 'Profile',
      'settings': 'Settings',
      
      // Heritage Sites
      'heritage_sites': 'Heritage Sites',
      'featured_sites': 'Featured Sites',
      'nearby_sites': 'Nearby Sites',
      'trending_sites': 'Trending Sites',
      'saved_sites': 'Saved Sites',
      'visit_site': 'Visit Site',
      'site_details': 'Site Details',
      'historical_context': 'Historical Context',
      'cultural_significance': 'Cultural Significance',
      'architecture_style': 'Architecture Style',
      'best_time_to_visit': 'Best Time to Visit',
      'entrance_fee': 'Entrance Fee',
      'opening_hours': 'Opening Hours',
      
      // AR Experience
      'ar_experience': 'AR Experience',
      'point_camera': 'Point your camera',
      'scan_surroundings': 'Scan your surroundings',
      'place_model': 'Place 3D Model',
      'capture_photo': 'Capture Photo',
      'record_video': 'Record Video',
      'add_narration': 'Add Narration',
      'ar_settings': 'AR Settings',
      
      // Trip Planning
      'trip_planner': 'Trip Planner',
      'select_duration': 'Select Duration',
      'traveler_type': 'Traveler Type',
      'generate_itinerary': 'Generate Itinerary',
      'day_trip': 'Day Trip',
      'weekend_getaway': 'Weekend Getaway',
      'week_long': 'Week Long',
      'solo_traveler': 'Solo Traveler',
      'couple': 'Couple',
      'family': 'Family',
      'group': 'Group',
      
      // Memory Wall
      'memory_wall': 'Memory Wall',
      'add_memory': 'Add Memory',
      'my_memories': 'My Memories',
      'shared_memories': 'Shared Memories',
      'likes': 'Likes',
      'comments': 'Comments',
      'share': 'Share',
      
      // Authentication
      'email': 'Email',
      'password': 'Password',
      'confirm_password': 'Confirm Password',
      'forgot_password': 'Forgot Password?',
      'sign_in_with_google': 'Sign in with Google',
      'sign_in_with_otp': 'Sign in with OTP',
      'dont_have_account': "Don't have an account?",
      'already_have_account': 'Already have an account?',
      
      // Onboarding
      'welcome_to_zenscape': 'Welcome to Zenscape',
      'discover_heritage': 'Discover Heritage Sites',
      'ar_experience_desc': 'Experience history in Augmented Reality',
      'plan_perfect_trip': 'Plan the Perfect Trip',
      'share_memories': 'Share Your Memories',
      'get_started': 'Get Started',
      
      // Cultural Context
      'kerala_culture': 'Kerala Culture',
      'portuguese_heritage': 'Portuguese Heritage',
      'dutch_influence': 'Dutch Influence',
      'british_colonial': 'British Colonial',
      'traditional_architecture': 'Traditional Architecture',
      'spice_trade': 'Spice Trade History',
      'maritime_history': 'Maritime History',
    };
  }

  Map<String, String> _getMalayalamTranslations() {
    return {
      // Common
      'app_name': 'സെൻസ്കേപ്പ് എആർ ടൂറിസം',
      'welcome': 'സ്വാഗതം',
      'login': 'ലോഗിൻ',
      'signup': 'സൈൻ അപ്പ്',
      'logout': 'ലോഗൗട്ട്',
      'search': 'തിരയുക',
      'cancel': 'റദ്ദാക്കുക',
      'save': 'സൂക്ഷിക്കുക',
      'delete': 'ഇല്ലാതാക്കുക',
      'edit': 'എഡിറ്റ്',
      'close': 'അടയ്ക്കുക',
      'next': 'അടുത്തത്',
      'previous': 'മുമ്പത്തേത്',
      'done': 'പൂർത്തിയായി',
      'loading': 'ലോഡ് ചെയ്യുന്നു...',
      'error': 'പിശക്',
      'success': 'വിജയം',
      
      // Navigation
      'home': 'ഹോം',
      'explore': 'അന്വേഷിക്കുക',
      'memories': 'ഓർമ്മകൾ',
      'plan_trip': 'യാത്ര പ്ലാൻ ചെയ്യുക',
      'profile': 'പ്രൊഫൈൽ',
      'settings': 'ക്രമീകരണങ്ങൾ',
      
      // Heritage Sites
      'heritage_sites': 'പൈതൃക സ്ഥലങ്ങൾ',
      'featured_sites': 'വിശേഷ സ്ഥലങ്ങൾ',
      'nearby_sites': 'അടുത്ത സ്ഥലങ്ങൾ',
      'trending_sites': 'ട്രെൻഡിംഗ് സ്ഥലങ്ങൾ',
      'saved_sites': 'സൂക്ഷിച്ച സ്ഥലങ്ങൾ',
      'visit_site': 'സ്ഥലം സന്ദർശിക്കുക',
      'site_details': 'സ്ഥല വിവരങ്ങൾ',
      'historical_context': 'ചരിത്ര സന്ദർഭം',
      'cultural_significance': 'സാംസ്കാരിക പ്രാധാന്യം',
      'architecture_style': 'വാസ്തുവിദ്യാ ശൈലി',
      'best_time_to_visit': 'സന്ദർശിക്കാനുള്ള മികച്ച സമയം',
      'entrance_fee': 'പ്രവേശന ഫീസ്',
      'opening_hours': 'തുറക്കുന്ന സമയം',
      
      // AR Experience
      'ar_experience': 'എആർ അനുഭവം',
      'point_camera': 'കാമറ ലക്ഷ്യമിടുക',
      'scan_surroundings': 'ചുറ്റുപാടുകൾ സ്കാൻ ചെയ്യുക',
      'place_model': '3D മോഡൽ സ്ഥാപിക്കുക',
      'capture_photo': 'ഫോട്ടോ എടുക്കുക',
      'record_video': 'വീഡിയോ റെക്കോർഡ് ചെയ്യുക',
      'add_narration': 'വിവരണം ചേർക്കുക',
      'ar_settings': 'എആർ ക്രമീകരണങ്ങൾ',
      
      // Trip Planning
      'trip_planner': 'യാത്രാ ആസൂത്രണം',
      'select_duration': 'കാലയളവ് തിരഞ്ഞെടുക്കുക',
      'traveler_type': 'യാത്രക്കാരന്റെ തരം',
      'generate_itinerary': 'യാത്രാ പദ്ധതി ഉണ്ടാക്കുക',
      'day_trip': 'ഒരു ദിവസത്തെ യാത്ര',
      'weekend_getaway': 'വാരാന്ത്യ യാത്ര',
      'week_long': 'ഒരാഴ്ചത്തെ യാത്ര',
      'solo_traveler': 'ഒറ്റയ്ക്ക് യാത്ര',
      'couple': 'ജോഡി',
      'family': 'കുടുംബം',
      'group': 'ഗ്രൂപ്പ്',
      
      // Memory Wall
      'memory_wall': 'ഓർമ്മ മതിൽ',
      'add_memory': 'ഓർമ്മ ചേർക്കുക',
      'my_memories': 'എന്റെ ഓർമ്മകൾ',
      'shared_memories': 'പങ്കുവെച്ച ഓർമ്മകൾ',
      'likes': 'ഇഷ്ടങ്ങൾ',
      'comments': 'അഭിപ്രായങ്ങൾ',
      'share': 'പങ്കുവെയ്ക്കുക',
      
      // Authentication
      'email': 'ഇമെയിൽ',
      'password': 'പാസ്വേഡ്',
      'confirm_password': 'പാസ്വേഡ് സ്ഥിരീകരിക്കുക',
      'forgot_password': 'പാസ്വേഡ് മറന്നുപോയോ?',
      'sign_in_with_google': 'Google-ൽ സൈൻ ഇൻ ചെയ്യുക',
      'sign_in_with_otp': 'OTP-ൽ സൈൻ ഇൻ ചെയ്യുക',
      'dont_have_account': 'അക്കൗണ്ട് ഇല്ലേ?',
      'already_have_account': 'അക്കൗണ്ട് ഇതിനകം ഉണ്ടോ?',
      
      // Onboarding
      'welcome_to_zenscape': 'സെൻസ്കേപ്പിലേക്ക് സ്വാഗതം',
      'discover_heritage': 'പൈതൃക സ്ഥലങ്ങൾ കണ്ടെത്തുക',
      'ar_experience_desc': 'വർദ്ധിത യാഥാർത്ഥ്യത്തിൽ ചരിത്രം അനുഭവിക്കുക',
      'plan_perfect_trip': 'മികച്ച യാത്ര ആസൂത്രണം ചെയ്യുക',
      'share_memories': 'നിങ്ങളുടെ ഓർമ്മകൾ പങ്കുവെയ്ക്കുക',
      'get_started': 'ആരംഭിക്കുക',
      
      // Cultural Context
      'kerala_culture': 'കേരള സംസ്കാരം',
      'portuguese_heritage': 'പോർച്ചുഗീസ് പൈതൃകം',
      'dutch_influence': 'ഡച്ച് സ്വാധീനം',
      'british_colonial': 'ബ്രിട്ടീഷ് കോളനി',
      'traditional_architecture': 'പരമ്പരാഗത വാസ്തുവിദ്യ',
      'spice_trade': 'സുഗന്ധവ്യഞ്ജന വ്യാപാര ചരിത്രം',
      'maritime_history': 'കടൽ ചരിത്രം',
    };
  }

  Map<String, String> _getHindiTranslations() {
    return {
      // Common
      'app_name': 'ज़ेनस्केप एआर टूरिज्म',
      'welcome': 'स्वागत है',
      'login': 'लॉगिन',
      'signup': 'साइन अप',
      'logout': 'लॉगआउट',
      'search': 'खोजें',
      'cancel': 'रद्द करें',
      'save': 'सहेजें',
      'delete': 'हटाएं',
      'edit': 'संपादित करें',
      'close': 'बंद करें',
      'next': 'अगला',
      'previous': 'पिछला',
      'done': 'पूर्ण',
      'loading': 'लोड हो रहा है...',
      'error': 'त्रुटि',
      'success': 'सफलता',
      
      // Navigation
      'home': 'होम',
      'explore': 'खोजें',
      'memories': 'यादें',
      'plan_trip': 'यात्रा योजना',
      'profile': 'प्रोफ़ाइल',
      'settings': 'सेटिंग्स',
      
      // Heritage Sites
      'heritage_sites': 'विरासत स्थल',
      'featured_sites': 'विशेष स्थल',
      'nearby_sites': 'निकटवर्ती स्थल',
      'trending_sites': 'लोकप्रिय स्थल',
      'saved_sites': 'सहेजे गए स्थल',
      'visit_site': 'स्थल देखें',
      'site_details': 'स्थल विवरण',
      'historical_context': 'ऐतिहासिक संदर्भ',
      'cultural_significance': 'सांस्कृतिक महत्व',
      'architecture_style': 'वास्तुकला शैली',
      'best_time_to_visit': 'देखने का सर्वोत्तम समय',
      'entrance_fee': 'प्रवेश शुल्क',
      'opening_hours': 'खुलने का समय',
      
      // AR Experience
      'ar_experience': 'एआर अनुभव',
      'point_camera': 'कैमरा इंगित करें',
      'scan_surroundings': 'आसपास स्कैन करें',
      'place_model': '3D मॉडल रखें',
      'capture_photo': 'फोटो लें',
      'record_video': 'वीडियो रिकॉर्ड करें',
      'add_narration': 'वर्णन जोड़ें',
      'ar_settings': 'एआर सेटिंग्स',
      
      // Trip Planning
      'trip_planner': 'यात्रा योजनाकार',
      'select_duration': 'अवधि चुनें',
      'traveler_type': 'यात्री का प्रकार',
      'generate_itinerary': 'यात्रा कार्यक्रम बनाएं',
      'day_trip': 'दिन की यात्रा',
      'weekend_getaway': 'सप्ताहांत की यात्रा',
      'week_long': 'सप्ताह भर की यात्रा',
      'solo_traveler': 'एकल यात्री',
      'couple': 'जोड़ा',
      'family': 'परिवार',
      'group': 'समूह',
      
      // Memory Wall
      'memory_wall': 'स्मृति दीवार',
      'add_memory': 'स्मृति जोड़ें',
      'my_memories': 'मेरी यादें',
      'shared_memories': 'साझा की गई यादें',
      'likes': 'पसंद',
      'comments': 'टिप्पणियां',
      'share': 'साझा करें',
      
      // Authentication
      'email': 'ईमेल',
      'password': 'पासवर्ड',
      'confirm_password': 'पासवर्ड की पुष्टि करें',
      'forgot_password': 'पासवर्ड भूल गए?',
      'sign_in_with_google': 'Google से साइन इन करें',
      'sign_in_with_otp': 'OTP से साइन इन करें',
      'dont_have_account': 'खाता नहीं है?',
      'already_have_account': 'पहले से खाता है?',
      
      // Onboarding
      'welcome_to_zenscape': 'ज़ेनस्केप में आपका स्वागत है',
      'discover_heritage': 'विरासत स्थलों की खोज करें',
      'ar_experience_desc': 'वर्धित वास्तविकता में इतिहास का अनुभव करें',
      'plan_perfect_trip': 'सर्वोत्तम यात्रा की योजना बनाएं',
      'share_memories': 'अपनी यादें साझा करें',
      'get_started': 'शुरू करें',
      
      // Cultural Context
      'kerala_culture': 'केरल संस्कृति',
      'portuguese_heritage': 'पुर्तगाली विरासत',
      'dutch_influence': 'डच प्रभाव',
      'british_colonial': 'ब्रिटिश औपनिवेशिक',
      'traditional_architecture': 'पारंपरिक वास्तुकला',
      'spice_trade': 'मसाला व्यापार का इतिहास',
      'maritime_history': 'समुद्री इतिहास',
    };
  }

  Map<String, String> _getTamilTranslations() {
    return {
      // Common
      'app_name': 'ஜென்ஸ்கேப் ஏஆர் சுற்றுலா',
      'welcome': 'வரவேற்கிறோம்',
      'login': 'உள்நுழைவு',
      'signup': 'பதிவு செய்க',
      'logout': 'வெளியேறு',
      'search': 'தேடு',
      'cancel': 'ரத்து செய்',
      'save': 'சேமி',
      'delete': 'அழி',
      'edit': 'திருத்து',
      'close': 'மூடு',
      'next': 'அடுத்து',
      'previous': 'முந்தைய',
      'done': 'முடிந்தது',
      'loading': 'ஏற்றுகிறது...',
      'error': 'பிழை',
      'success': 'வெற்றி',
      
      // Navigation
      'home': 'முகப்பு',
      'explore': 'ஆராய்',
      'memories': 'நினைவுகள்',
      'plan_trip': 'பயணத் திட்டம்',
      'profile': 'சுயவிவரம்',
      'settings': 'அமைப்புகள்',
      
      // Heritage Sites
      'heritage_sites': 'பாரம்பரிய தளங்கள்',
      'featured_sites': 'சிறப்பு தளங்கள்',
      'nearby_sites': 'அருகிலுள்ள தளங்கள்',
      'trending_sites': 'பிரபலமான தளங்கள்',
      'saved_sites': 'சேமிக்கப்பட்ட தளங்கள்',
      'visit_site': 'தளத்தை பார்வையிடு',
      'site_details': 'தள விவரங்கள்',
      'historical_context': 'வரலாற்று சூழல்',
      'cultural_significance': 'கலாச்சார முக்கியத்துவம்',
      'architecture_style': 'கட்டிடக்கலை பாணி',
      'best_time_to_visit': 'பார்வையிட சிறந்த நேரம்',
      'entrance_fee': 'நுழைவு கட்டணம்',
      'opening_hours': 'திறக்கும் நேரம்',
      
      // AR Experience
      'ar_experience': 'ஏஆர் அனுபவம்',
      'point_camera': 'கேமராவை சுட்டு',
      'scan_surroundings': 'சுற்றுப்புறங்களை ஸ்கேன் செய்',
      'place_model': '3D மாடலை வைக்கவும்',
      'capture_photo': 'புகைப்படம் எடுக்கவும்',
      'record_video': 'வீடியோ பதிவு செய்யவும்',
      'add_narration': 'விளக்கத்தை சேர்க்கவும்',
      'ar_settings': 'ஏஆர் அமைப்புகள்',
      
      // Trip Planning
      'trip_planner': 'பயண திட்டமிடுநர்',
      'select_duration': 'கால அளவைத் தேர்ந்தெடுக்கவும்',
      'traveler_type': 'பயணி வகை',
      'generate_itinerary': 'பயண அட்டவணையை உருவாக்கவும்',
      'day_trip': 'ஒரு நாள் பயணம்',
      'weekend_getaway': 'வார இறுதி பயணம்',
      'week_long': 'ஒரு வார பயணம்',
      'solo_traveler': 'தனி பயணி',
      'couple': 'ஜோடி',
      'family': 'குடும்பம்',
      'group': 'குழு',
      
      // Memory Wall
      'memory_wall': 'நினைவு சுவர்',
      'add_memory': 'நினைவை சேர்க்கவும்',
      'my_memories': 'எனது நினைவுகள்',
      'shared_memories': 'பகிரப்பட்ட நினைவுகள்',
      'likes': 'விருப்பங்கள்',
      'comments': 'கருத்துகள்',
      'share': 'பகிர்',
      
      // Authentication
      'email': 'மின்னஞ்சல்',
      'password': 'கடவுச்சொல்',
      'confirm_password': 'கடவுச்சொலை உறுதிப்படுத்தவும்',
      'forgot_password': 'கடவுச்சொல் மறந்துவிட்டதா?',
      'sign_in_with_google': 'Google உடன் உள்நுழையவும்',
      'sign_in_with_otp': 'OTP உடன் உள்நுழையவும்',
      'dont_have_account': 'கணக்கு இல்லையா?',
      'already_have_account': 'ஏற்கனவே கணக்கு உள்ளதா?',
      
      // Onboarding
      'welcome_to_zenscape': 'ஜென்ஸ்கேப்பிற்கு வரவேற்கிறோம்',
      'discover_heritage': 'பாரம்பரிய தளங்களை கண்டறியவும்',
      'ar_experience_desc': 'விரிவாக்கப்பட்ட யதார்த்தத்தில் வரலாற்றை அனுபவிக்கவும்',
      'plan_perfect_trip': 'சிறந்த பயணத்தை திட்டமிடவும்',
      'share_memories': 'உங்கள் நினைவுகளை பகிர்ந்து கொள்ளவும்',
      'get_started': 'தொடங்கவும்',
      
      // Cultural Context
      'kerala_culture': 'கேரள கலாச்சாரம்',
      'portuguese_heritage': 'போர்ச்சுகீசிய பாரம்பரியம்',
      'dutch_influence': 'டச்சு செல்வாக்கு',
      'british_colonial': 'பிரிட்டிஷ் காலனி',
      'traditional_architecture': 'பாரம்பரிய கட்டிடக்கலை',
      'spice_trade': 'மசாலா வர்த்தக வரலாறு',
      'maritime_history': 'கடல் வரலாறு',
    };
  }

  Future<void> _loadSavedLanguage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedLanguage = prefs.getString('language_code');
      final savedCountry = prefs.getString('country_code');
      
      if (savedLanguage != null && savedCountry != null) {
        _currentLocale = Locale(savedLanguage, savedCountry);
      }
    } catch (e) {
      print('Failed to load saved language: $e');
    }
  }

  Future<void> changeLanguage(Locale locale) async {
    if (_currentLocale == locale) return;

    _currentLocale = locale;
    
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('language_code', locale.languageCode);
      await prefs.setString('country_code', locale.countryCode ?? 'IN');
    } catch (e) {
      print('Failed to save language preference: $e');
    }

    notifyListeners();
  }

  String translate(String key) {
    final languageCode = _currentLocale.languageCode;
    final translations = _translations[languageCode];
    
    if (translations != null && translations.containsKey(key)) {
      return translations[key]!;
    }
    
    // Fallback to English
    final englishTranslations = _translations['en'];
    if (englishTranslations != null && englishTranslations.containsKey(key)) {
      return englishTranslations[key]!;
    }
    
    // Return key if no translation found
    return key;
  }

  String translateWithContext(String key, Map<String, String> context) {
    String translation = translate(key);
    
    // Replace context variables in translation
    context.forEach((variable, value) {
      translation = translation.replaceAll('{$variable}', value);
    });
    
    return translation;
  }

  // Get cultural context for current locale
  Map<String, String> getCulturalContext() {
    final languageCode = _currentLocale.languageCode;
    
    switch (languageCode) {
      case 'ml':
        return {
          'greeting': 'നമസ്കാരം',
          'thank_you': 'നന്ദി',
          'goodbye': 'വിട',
          'welcome_message': 'കേരളത്തിലേക്ക് സ്വാഗതം',
        };
      case 'hi':
        return {
          'greeting': 'नमस्ते',
          'thank_you': 'धन्यवाद',
          'goodbye': 'अलविदा',
          'welcome_message': 'भारत में आपका स्वागत है',
        };
      case 'ta':
        return {
          'greeting': 'வணக்கம்',
          'thank_you': 'நன்றி',
          'goodbye': 'பிரியாவிடை',
          'welcome_message': 'இந்தியாவிற்கு வரவேற்கிறோம்',
        };
      default:
        return {
          'greeting': 'Hello',
          'thank_you': 'Thank you',
          'goodbye': 'Goodbye',
          'welcome_message': 'Welcome to India',
        };
    }
  }

  // Get date format for current locale
  String getDateFormat() {
    final languageCode = _currentLocale.languageCode;
    
    switch (languageCode) {
      case 'ml':
      case 'hi':
      case 'ta':
        return 'dd/MM/yyyy'; // Indian format
      default:
        return 'MM/dd/yyyy'; // US format
    }
  }

  // Get number format for current locale
  String getNumberFormat() {
    final languageCode = _currentLocale.languageCode;
    
    switch (languageCode) {
      case 'ml':
      case 'hi':
      case 'ta':
        return 'Indian'; // 1,00,000 format
      default:
        return 'International'; // 100,000 format
    }
  }
}
