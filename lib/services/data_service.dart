import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/category.dart';
import '../models/prompt.dart';
import 'database_service.dart';
import 'sqlite_service.dart';

class DataService {
  static final DataService _instance = DataService._internal();
  factory DataService() => _instance;
  DataService._internal();

  List<Category> _categories = [];
  List<Prompt> _prompts = [];
  Map<String, dynamic> _pricing = {};
  Map<String, dynamic> _appConfig = {};
  bool _hasLifetimeAccess = false;
  bool _hasActiveSubscription = false;

  List<Category> get categories => _categories;
  List<Prompt> get prompts => _prompts;
  Map<String, dynamic> get pricing => _pricing;
  Map<String, dynamic> get appConfig => _appConfig;

  Future<void> loadData() async {
    try {
      print('Loading data from SQLite database...');
      
      // Pro version: Always have access
      _hasLifetimeAccess = true;
      _hasActiveSubscription = true;

      _categories = await SQLiteService.getCategories();
      print('Categories loaded: ${_categories.length}');

      _prompts = await SQLiteService.getPrompts();
      print('Prompts loaded: ${_prompts.length}');

      _pricing = {};
      _appConfig = {'version': '1.3.0'};
      print('Data loaded from SQLite');

      await _loadUserData();
      print('User data loaded successfully');
    } catch (e) {
      print('Error loading data: $e');
      _categories = [];
      _prompts = [];
      _pricing = {};
      _appConfig = {};
      throw Exception('Failed to load data: $e');
    }
  }

  Future<void> _loadUserData() async {
    // Load favorites from database service
    final favorites = await DatabaseService.getFavoritePrompts();
    for (var prompt in _prompts) {
      prompt.isFavorite = favorites.contains(prompt.id);
    }

    // Pro version: All prompts are unlocked by default
    for (var prompt in _prompts) {
      prompt.isUnlocked = true;
    }
    
    // Set lifetime access to true for Pro version
    _hasLifetimeAccess = true;
    _hasActiveSubscription = true;

    // Increment session count
    await DatabaseService.incrementSessionCount();
  }

  List<Prompt> getPromptsByCategory(String categoryId) {
    return _prompts.where((prompt) => prompt.categoryId == categoryId).toList();
  }
  
  List<Category> getCategoriesSortedByPromptCount() {
    final categories = _categories.toList();
    categories.sort((a, b) => b.promptCount.compareTo(a.promptCount));
    return categories;
  }

  List<Prompt> getFavoritePrompts() {
    return _prompts.where((prompt) => prompt.isFavorite).toList();
  }

  List<String> getFavoritePromptIds() {
    return _prompts.where((prompt) => prompt.isFavorite).map((prompt) => prompt.id).toList();
  }

  List<Prompt> getUnlockedPrompts() {
    return _prompts.where((prompt) => prompt.isUnlocked).toList();
  }

  List<Prompt> searchPrompts(String query) {
    final lowercaseQuery = query.toLowerCase();
    return _prompts.where((prompt) {
      return prompt.title.toLowerCase().contains(lowercaseQuery) ||
             prompt.description.toLowerCase().contains(lowercaseQuery) ||
             prompt.tags.any((tag) => tag.toLowerCase().contains(lowercaseQuery));
    }).toList();
  }

  Future<void> toggleFavorite(String promptId) async {
    await DatabaseService.toggleFavorite(promptId);
    
    final prompt = _prompts.firstWhere((p) => p.id == promptId);
    prompt.isFavorite = await DatabaseService.isPromptFavorite(promptId);
  }

  Future<void> unlockPrompt(String promptId) async {
    await DatabaseService.unlockPrompt(promptId);
    
    final prompt = _prompts.firstWhere((p) => p.id == promptId);
    prompt.isUnlocked = true;
    
    // Refresh subscription status
    _hasLifetimeAccess = await DatabaseService.hasLifetimeAccess();
    _hasActiveSubscription = await DatabaseService.hasActiveSubscription();
  }

  Future<void> unlockAllPrompts() async {
    await DatabaseService.unlockAllPromptsLifetime();
    
    for (var prompt in _prompts) {
      prompt.isUnlocked = true;
    }
    
    // Refresh subscription status
    _hasLifetimeAccess = await DatabaseService.hasLifetimeAccess();
    _hasActiveSubscription = await DatabaseService.hasActiveSubscription();
  }

  int getFreePromptsCount() {
    return _prompts.where((prompt) => !prompt.isPremium).length;
  }

  int getPremiumPromptsCount() {
    return _prompts.where((prompt) => prompt.isPremium).length;
  }

  int getUnlockedPromptsCount() {
    return _prompts.where((prompt) => prompt.isUnlocked).length;
  }

  Future<bool> hasLifetimeAccess() async {
    return await DatabaseService.hasLifetimeAccess();
  }

  bool isPromptUnlocked(String promptId) {
    // Pro version: All prompts are always unlocked
    return true;
  }
}