import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../core/app_export.dart';
import '../widgets/custom_error_widget.dart';
import '../core/services/service_manager.dart';
import 'dart:async';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize services with guarded zone for global error capture
  await runZonedGuarded(() async {
    try {
      await ServiceManager.instance.initialize();
      // Start periodic memory monitoring
      ServiceManager.instance.loggingService.startMemoryMonitoring(
        interval: const Duration(minutes: 1),
      );
    } catch (e, st) {
      ServiceManager.instance.loggingService.logError(e, st, context: 'Service init');
    }

  bool _hasShownError = false;

  // 🚨 CRITICAL: Custom error handling - DO NOT REMOVE
  ErrorWidget.builder = (FlutterErrorDetails details) {
    if (!_hasShownError) {
      _hasShownError = true;

      // Reset flag after 3 seconds to allow error widget on new screens
      Future.delayed(Duration(seconds: 5), () {
        _hasShownError = false;
      });

      return CustomErrorWidget(
        errorDetails: details,
      );
    }
    return SizedBox.shrink();
  };

    // 🚨 CRITICAL: Device orientation lock - DO NOT REMOVE
    Future.wait([
      SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
    ]).then((value) {
      runApp(MyApp());
    });
  }, (error, stack) {
    // Global error handler
    try {
      ServiceManager.instance.loggingService.logError(error, stack);
    } catch (_) {
      // Fallback console if logging service not ready
      // ignore: avoid_print
      print('Uncaught: $error');
      // ignore: avoid_print
      print(stack);
    }
  });
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Sizer(builder: (context, orientation, screenType) {
      return MaterialApp(
        title: 'zenscape_ar_tourism',
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.light,
        // 🚨 CRITICAL: NEVER REMOVE OR MODIFY
        builder: (context, child) {
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(
              textScaler: TextScaler.linear(1.0),
            ),
            child: child!,
          );
        },
        // 🚨 END CRITICAL SECTION
        debugShowCheckedModeBanner: false,
        routes: AppRoutes.routes,
        initialRoute: AppRoutes.initial,
      );
    });
  }
}
