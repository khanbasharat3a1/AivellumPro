import 'package:flutter/material.dart';
import '../models/category.dart';
import '../models/prompt.dart';
import '../services/data_service.dart';
import '../utils/performance_monitor.dart';

class AppProvider with ChangeNotifier {
  final DataService _dataService = DataService();
  
  bool _isLoading = true;
  String _error = '';
  int _currentIndex = 0;
  String _searchQuery = '';
  String? _selectedCategoryId;
  bool _hasLifetimeAccess = true; // Always true in Pro version
  bool _hasActiveSubscription = true; // Always true in Pro version

  // Getters
  bool get isLoading => _isLoading;
  String get error => _error;
  int get currentIndex => _currentIndex;
  String get searchQuery => _searchQuery;
  String? get selectedCategoryId => _selectedCategoryId;
  bool get hasLifetimeAccess => _hasLifetimeAccess;
  bool get hasActiveSubscription => _hasActiveSubscription;
  bool get isUserSubscribed => _hasLifetimeAccess || _hasActiveSubscription;
  
  List<Category> get categories => _dataService.categories;
  List<Prompt> get prompts => _dataService.prompts;
  Map<String, dynamic> get pricing => {}; // No pricing in Pro version
  Map<String, dynamic> get appConfig => _dataService.appConfig;

  // Initialize app data
  Future<void> initialize() async {
    PerformanceMonitor.startTimer('app_initialization');
    try {
      print('Initializing app...');
      _isLoading = true;
      _error = '';
      notifyListeners();

      PerformanceMonitor.startTimer('data_loading');
      await _dataService.loadData();
      PerformanceMonitor.stopTimer('data_loading', description: 'Loading prompts and categories');
      print('Data service loaded successfully');
      
      // Pro version: Unlock all prompts by default
      PerformanceMonitor.startTimer('unlock_prompts');
      await _dataService.unlockAllPrompts();
      PerformanceMonitor.stopTimer('unlock_prompts', description: 'Unlocking all prompts');
      print('All prompts unlocked in Pro version');
      
      _isLoading = false;
      notifyListeners();
      print('App initialization completed');
      PerformanceMonitor.stopTimer('app_initialization', description: 'Complete app initialization');
    } catch (e) {
      print('App initialization error: $e');
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      PerformanceMonitor.stopTimer('app_initialization', description: 'Failed app initialization');
    }
  }

  // Navigation
  void setCurrentIndex(int index) {
    _currentIndex = index;
    notifyListeners();
  }

  // Search
  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  List<Prompt> getSearchResults() {
    if (_searchQuery.isEmpty) return [];
    return _dataService.searchPrompts(_searchQuery);
  }

  // Category filtering
  void setSelectedCategory(String? categoryId) {
    _selectedCategoryId = categoryId;
    notifyListeners();
  }

  List<Prompt> getPromptsByCategory(String categoryId) {
    return _dataService.getPromptsByCategory(categoryId);
  }

  List<Prompt> getFeaturedPrompts() {
    if (prompts.isEmpty) return [];
    
    final List<Prompt> featured = [];
    
    // First, add some premium prompts from money_making (most popular category)
    final moneyMakingPrompts = prompts.where((p) => p.categoryId == 'money_making').toList();
    if (moneyMakingPrompts.isNotEmpty) {
      featured.addAll(moneyMakingPrompts.take(2));
    }
    
    // Add some content creation prompts
    final contentPrompts = prompts.where((p) => p.categoryId == 'content_creation').toList();
    if (contentPrompts.isNotEmpty) {
      featured.addAll(contentPrompts.take(1));
    }
    
    // Add business strategy prompts
    final businessPrompts = prompts.where((p) => p.categoryId == 'business_strategy').toList();
    if (businessPrompts.isNotEmpty) {
      featured.addAll(businessPrompts.take(1));
    }
    
    // Add freelancing prompts
    final freelancingPrompts = prompts.where((p) => p.categoryId == 'freelancing').toList();
    if (freelancingPrompts.isNotEmpty) {
      featured.addAll(freelancingPrompts.take(1));
    }
    
    // Add writing prompts
    final writingPrompts = prompts.where((p) => p.categoryId == 'writing').toList();
    if (writingPrompts.isNotEmpty) {
      featured.addAll(writingPrompts.take(1));
    }
    
    // Add marketing prompts
    final marketingPrompts = prompts.where((p) => p.categoryId == 'marketing_sales').toList();
    if (marketingPrompts.isNotEmpty) {
      featured.addAll(marketingPrompts.take(1));
    }
    
    // If we still don't have enough, add more from any category
    if (featured.length < 8) {
      final remaining = prompts.where((p) => !featured.contains(p)).take(8 - featured.length);
      featured.addAll(remaining);
    }
    
    // Shuffle for variety and return up to 8 prompts
    featured.shuffle();
    return featured.take(8).toList();
  }

  // Favorites
  List<Prompt> get favoritePrompts => _dataService.getFavoritePrompts();

  Future<void> toggleFavorite(String promptId) async {
    await _dataService.toggleFavorite(promptId);
    notifyListeners();
  }

  // Premium features
  List<Prompt> get unlockedPrompts => _dataService.getUnlockedPrompts();
  
  bool isPromptUnlocked(String promptId) {
    // All prompts are unlocked in Pro version
    return true;
  }
  

  // Pro version: No payment methods needed
  Future<bool> unlockPromptWithPayment(String promptId) async {
    // All prompts are already unlocked in Pro version
    return true;
  }

  Future<bool> unlockAllPromptsWithPayment() async {
    // All prompts are already unlocked in Pro version
    return true;
  }

  Future<bool> purchaseMonthlySubscription() async {
    // No subscription needed in Pro version
    return true;
  }

  // Statistics
  int get totalPrompts => prompts.length;
  int get freePromptsCount => _dataService.getFreePromptsCount();
  int get premiumPromptsCount => _dataService.getPremiumPromptsCount();
  int get unlockedPromptsCount => _dataService.getUnlockedPromptsCount();
  int get favoritePromptsCount => favoritePrompts.length;

  // Get prompts by difficulty
  List<Prompt> getPromptsByDifficulty(String difficulty) {
    return prompts.where((p) => p.difficulty == difficulty).toList();
  }

  // Get category by ID
  Category? getCategoryById(String categoryId) {
    try {
      return categories.firstWhere((c) => c.id == categoryId);
    } catch (e) {
      return null;
    }
  }

  // Get prompt by ID
  Prompt? getPromptById(String promptId) {
    try {
      return prompts.firstWhere((p) => p.id == promptId);
    } catch (e) {
      return null;
    }
  }

  // Pro version: No pricing methods needed
  String getIndividualPromptPrice() {
    return 'FREE'; // All prompts are free in Pro version
  }

  String getLifetimeAccessPrice() {
    return 'INCLUDED'; // Already included in Pro version
  }

  String getFormattedPrice() {
    return 'INCLUDED';
  }

  String getMonthlySubscriptionPrice() {
    return 'INCLUDED';
  }

  // No restore needed in Pro version
  Future<void> restorePurchases() async {
    // Nothing to restore in Pro version
    print('No purchases to restore in Pro version');
  }
}