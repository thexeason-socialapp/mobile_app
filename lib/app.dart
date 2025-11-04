import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/app_colors.dart';

class ThexeasonApp extends StatefulWidget {
  const ThexeasonApp({super.key});

  @override
  State<ThexeasonApp> createState() => _ThexeasonAppState();
}

class _ThexeasonAppState extends State<ThexeasonApp> with WidgetsBindingObserver {
  // Theme mode state
  ThemeMode _themeMode = ThemeMode.system;
  
  @override
  void initState() {
    super.initState();
    // Add observer for app lifecycle
    WidgetsBinding.instance.addObserver(this);
    
    // TODO: Load saved theme preference from local storage
    _loadThemePreference();
  }
  
  @override
  void dispose() {
    // Remove observer
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }
  
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    
    // Handle app lifecycle changes
    switch (state) {
      case AppLifecycleState.resumed:
        // App came to foreground
        debugPrint('App resumed');
        // TODO: Sync pending data, refresh feed, etc.
        break;
      case AppLifecycleState.inactive:
        // App is inactive
        debugPrint('App inactive');
        break;
      case AppLifecycleState.paused:
        // App is in background
        debugPrint('App paused');
        // TODO: Save draft state, pause uploads, etc.
        break;
      case AppLifecycleState.detached:
        // App is detached
        debugPrint('App detached');
        break;
      case AppLifecycleState.hidden:
        // App is hidden
        debugPrint('App hidden');
        break;
    }
  }
  
  @override
  void didChangePlatformBrightness() {
    super.didChangePlatformBrightness();
    // Respond to system theme changes
    if (_themeMode == ThemeMode.system) {
      setState(() {});
    }
  }
  
  /// Load theme preference from local storage
  Future<void> _loadThemePreference() async {
    // TODO: Implement when we add SharedPreferences/Hive
    // final prefs = await SharedPreferences.getInstance();
    // final isDark = prefs.getBool('isDarkMode') ?? false;
    // setState(() {
    //   _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    // });
  }
  
  /// Toggle theme mode
  void _toggleTheme() {
    setState(() {
      _themeMode = _themeMode == ThemeMode.light 
          ? ThemeMode.dark 
          : ThemeMode.light;
    });
    
    // TODO: Save preference to local storage
    // final prefs = await SharedPreferences.getInstance();
    // await prefs.setBool('isDarkMode', _themeMode == ThemeMode.dark);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // ===== App Configuration =====
      title: 'Thexeason',
      debugShowCheckedModeBanner: false,
      
      // ===== Theme Configuration =====
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: _themeMode,
      
      // ===== Localization (Future Enhancement) =====
      // locale: const Locale('en', 'US'),
      // supportedLocales: const [
      //   Locale('en', 'US'),
      //   Locale('fr', 'FR'),
      // ],
      // localizationsDelegates: const [
      //   GlobalMaterialLocalizations.delegate,
      //   GlobalWidgetsLocalizations.delegate,
      //   GlobalCupertinoLocalizations.delegate,
      // ],
      
      // ===== Navigation Configuration =====
      // TODO: Replace with GoRouter when we implement navigation
      home: _buildHomePlaceholder(),
      
      // ===== Route Configuration (Temporary) =====
      routes: {
        '/splash': (context) => _buildSplashScreen(),
        '/home': (context) => _buildHomePlaceholder(),
        '/login': (context) => _buildLoginPlaceholder(),
      },
      initialRoute: '/splash',
      
      // ===== Error Handling =====
      builder: (context, child) {
        // Wrap app in error boundary
        ErrorWidget.builder = (FlutterErrorDetails details) {
          return _buildErrorWidget(details);
        };
        
        // Set text scale factor limits (accessibility)
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(
            textScaler: TextScaler.linear(
              MediaQuery.of(context).textScaleFactor.clamp(0.8, 1.3),
            ),
          ),
          child: child ?? const SizedBox.shrink(),
        );
      },
      
      // ===== Scroll Behavior =====
      scrollBehavior: const MaterialScrollBehavior().copyWith(
        physics: const BouncingScrollPhysics(),
        scrollbars: false,
      ),
    );
  }
  
  // ============================================
  // TEMPORARY PLACEHOLDER SCREENS
  // (Will be replaced with actual screens)
  // ============================================
  
  /// Splash Screen (Temporary)
  Widget _buildSplashScreen() {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // App Logo (Placeholder)
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: AppColors.secondary,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.flash_on_rounded,
                  size: 60,
                  color: AppColors.primary,
                ),
              ),
              
              const SizedBox(height: 24),
              
              // App Name
              const Text(
                'Thexeason',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w700,
                  color: AppColors.secondary,
                  letterSpacing: 1.2,
                ),
              ),
              
              const SizedBox(height: 8),
              
              // Tagline
              Text(
                'Connect. Share. Inspire.',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppColors.secondary.withOpacity(0.8),
                  letterSpacing: 0.5,
                ),
              ),
              
              const SizedBox(height: 48),
              
              // Loading Indicator
              const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.secondary),
                strokeWidth: 3,
              ),
              
              const SizedBox(height: 16),
              
              // Loading Text
              GestureDetector(
                onTap: () {
                  // For demo purposes, navigate to home after tap
                  Navigator.pushReplacementNamed(context, '/home');
                },
                child: Text(
                  'Loading...',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.secondary.withOpacity(0.7),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  /// Home Placeholder (Temporary)
  Widget _buildHomePlaceholder() {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Thexeason'),
        actions: [
          IconButton(
            icon: Icon(
              _themeMode == ThemeMode.light 
                  ? Icons.dark_mode_rounded 
                  : Icons.light_mode_rounded,
            ),
            onPressed: _toggleTheme,
            tooltip: 'Toggle Theme',
          ),
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {
              // TODO: Navigate to notifications
            },
            tooltip: 'Notifications',
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.construction_rounded,
              size: 80,
              color: AppColors.primary,
            ),
            const SizedBox(height: 24),
            const Text(
              'Home Screen',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Coming Soon',
              style: TextStyle(
                fontSize: 16,
                color: Theme.of(context).textTheme.bodySmall?.color,
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: _toggleTheme,
              icon: Icon(
                _themeMode == ThemeMode.light 
                    ? Icons.dark_mode_rounded 
                    : Icons.light_mode_rounded,
              ),
              label: Text(
                _themeMode == ThemeMode.light 
                    ? 'Switch to Dark Mode' 
                    : 'Switch to Light Mode',
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: Navigate to post composer
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Post composer coming soon!'),
              behavior: SnackBarBehavior.floating,
            ),
          );
        },
        tooltip: 'Create Post',
        child: const Icon(Icons.add_rounded),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: 0,
        onDestinationSelected: (index) {
          // TODO: Implement navigation
          debugPrint('Selected tab: $index');
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home_rounded),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.explore_outlined),
            selectedIcon: Icon(Icons.explore_rounded),
            label: 'Explore',
          ),
          NavigationDestination(
            icon: Icon(Icons.video_library_outlined),
            selectedIcon: Icon(Icons.video_library_rounded),
            label: 'Shorts',
          ),
          NavigationDestination(
            icon: Icon(Icons.chat_bubble_outline),
            selectedIcon: Icon(Icons.chat_bubble_rounded),
            label: 'Messages',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person_rounded),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
  
  /// Login Placeholder (Temporary)
  Widget _buildLoginPlaceholder() {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Logo
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(25),
                ),
                child: const Icon(
                  Icons.flash_on_rounded,
                  size: 50,
                  color: AppColors.secondary,
                ),
              ),
              
              const SizedBox(height: 32),
              
              // Title
              const Text(
                'Welcome to Thexeason',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                ),
              ),
              
              const SizedBox(height: 8),
              
              // Subtitle
              Text(
                'Connect with friends and the world around you',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.textSecondaryLight,
                ),
              ),
              
              const SizedBox(height: 48),
              
              // Email Field
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Email',
                  hintText: 'Enter your email',
                  prefixIcon: Icon(Icons.email_outlined),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              
              const SizedBox(height: 16),
              
              // Password Field
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Password',
                  hintText: 'Enter your password',
                  prefixIcon: Icon(Icons.lock_outline),
                  suffixIcon: Icon(Icons.visibility_outlined),
                ),
                obscureText: true,
              ),
              
              const SizedBox(height: 24),
              
              // Login Button
              ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacementNamed(context, '/home');
                },
                child: const Text('Sign In'),
              ),
              
              const SizedBox(height: 12),
              
              // Sign Up Button
              OutlinedButton(
                onPressed: () {
                  // TODO: Navigate to sign up
                },
                child: const Text('Create Account'),
              ),
              
              const SizedBox(height: 16),
              
              // Forgot Password
              TextButton(
                onPressed: () {
                  // TODO: Navigate to forgot password
                },
                child: const Text('Forgot Password?'),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  /// Error Widget (Production-Ready)
  Widget _buildErrorWidget(FlutterErrorDetails details) {
    return Scaffold(
      backgroundColor: AppColors.error,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.error_outline_rounded,
                size: 80,
                color: Colors.white,
              ),
              const SizedBox(height: 24),
              const Text(
                'Oops! Something went wrong',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                'We\'re working to fix the issue. Please try again.',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white.withOpacity(0.9),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: () {
                  // Restart app
                  SystemNavigator.pop();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: AppColors.error,
                ),
                child: const Text('Restart App'),
              ),
              const SizedBox(height: 48),
              // Error details (only in debug mode)
              if (details.exception.toString().isNotEmpty)
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.black26,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    details.exception.toString(),
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.white,
                      fontFamily: 'monospace',
                    ),
                    maxLines: 5,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}