# 🧭 Navigation Flow Guide

## Back Button Behavior

### 📱 **Main Screen (Bottom Navigation)**
```
Current Screen → Back Button Action
─────────────────────────────────────
Home (0)       → Show "Press back again to exit" snackbar
                 (Double tap within 2s to exit app)

Categories (1) → Navigate to Home (0)
Discover (2)   → Navigate to Home (0)
Favorites (3)  → Navigate to Home (0)
Settings (4)   → Navigate to Home (0)
```

### 🗂️ **Categories Screen States**
```
State                    → Back Button Action
──────────────────────────────────────────────
Search Active           → Clear search query
Category Selected       → Return to all categories
Main Categories View    → Navigate to Home (0)
```

### 🎯 **All Other Screens**
```
Screen          → Back Button Action
────────────────────────────────────
Discover        → Navigate to Home (0)
Favorites       → Navigate to Home (0)
Settings        → Navigate to Home (0)
```

---

## 🔄 Navigation Patterns

### **Pattern 1: Simple Back to Home**
Used in: Discover, Favorites, Settings
```dart
Future<bool> _onWillPop(AppProvider provider) async {
  provider.setCurrentIndex(0);
  return false;
}
```

### **Pattern 2: Smart State Management**
Used in: Categories
```dart
Future<bool> _onWillPop(AppProvider provider) async {
  // Clear search first
  if (provider.searchQuery.isNotEmpty) {
    provider.setSearchQuery('');
    return false;
  }
  
  // Clear category selection
  if (provider.selectedCategoryId != null) {
    provider.setSelectedCategory(null);
    return false;
  }
  
  // Go to home
  provider.setCurrentIndex(0);
  return false;
}
```

### **Pattern 3: Double-Tap Exit**
Used in: Main Screen (Home)
```dart
Future<bool> _onWillPop(BuildContext context, AppProvider provider) async {
  // If not on home, go to home
  if (provider.currentIndex != 0) {
    provider.setCurrentIndex(0);
    return false;
  }
  
  // If on home, check double tap
  final now = DateTime.now();
  if (_lastBackPress == null || 
      now.difference(_lastBackPress!) > Duration(seconds: 2)) {
    _lastBackPress = now;
    // Show snackbar
    return false;
  }
  return true; // Exit app
}
```

---

## 📊 Screen Hierarchy

```
App Launch
    │
    ├─→ Splash Screen (2 seconds)
    │       │
    │       ├─→ First Launch → Onboarding Screen
    │       │                      │
    │       │                      └─→ Main Screen
    │       │
    │       └─→ Returning User → Main Screen
    │
    └─→ Main Screen (Bottom Navigation)
            │
            ├─→ [0] Home Screen
            │       └─→ Back: Double-tap to exit
            │
            ├─→ [1] Categories Screen
            │       ├─→ All Categories View
            │       │   └─→ Back: Go to Home
            │       │
            │       ├─→ Category Selected View
            │       │   └─→ Back: Go to All Categories
            │       │
            │       └─→ Search Active View
            │           └─→ Back: Clear Search
            │
            ├─→ [2] Discover Screen
            │       └─→ Back: Go to Home
            │
            ├─→ [3] Favorites Screen
            │       └─→ Back: Go to Home
            │
            └─→ [4] Settings Screen
                    └─→ Back: Go to Home
```

---

## 🎯 User Journey Examples

### **Example 1: Browsing Categories**
```
1. User opens app → Home Screen
2. Taps Categories → Categories Screen (All Categories)
3. Taps "Money Making" → Categories Screen (Money Making prompts)
4. Presses Back → Categories Screen (All Categories)
5. Presses Back → Home Screen
6. Presses Back → "Press back again to exit" snackbar
7. Presses Back again → App exits
```

### **Example 2: Searching**
```
1. User on Categories Screen
2. Types in search bar → Search results shown
3. Presses Back → Search cleared, back to Categories
4. Presses Back → Home Screen
```

### **Example 3: Exploring App**
```
1. User on Home Screen
2. Taps Discover → Discover Screen
3. Presses Back → Home Screen
4. Taps Favorites → Favorites Screen
5. Presses Back → Home Screen
6. Taps Settings → Settings Screen
7. Presses Back → Home Screen
```

---

## 🛡️ Safety Features

### **No Accidental Exits**
- ✅ Back button never directly closes app (except from home with double-tap)
- ✅ Always returns to home screen first
- ✅ Clear visual feedback with snackbars

### **State Preservation**
- ✅ Search queries cleared before navigation
- ✅ Category selections cleared before navigation
- ✅ Proper state management throughout

### **User Feedback**
- ✅ Snackbar on home screen: "Press back again to exit"
- ✅ 2-second window for double-tap
- ✅ Visual confirmation of actions

---

## 🔧 Implementation Details

### **WillPopScope Widget**
All screens use `WillPopScope` to intercept back button:
```dart
WillPopScope(
  onWillPop: () => _onWillPop(provider),
  child: Scaffold(...),
)
```

### **Provider Integration**
Navigation uses `AppProvider` for state management:
```dart
provider.setCurrentIndex(0);        // Go to home
provider.setSearchQuery('');        // Clear search
provider.setSelectedCategory(null); // Clear category
```

### **Snackbar Feedback**
```dart
ScaffoldMessenger.of(context).showSnackBar(
  SnackBar(
    content: Row(
      children: [
        Icon(Icons.info_outline_rounded, color: Colors.white),
        SizedBox(width: 12),
        Text('Press back again to exit'),
      ],
    ),
    backgroundColor: AppConstants.textPrimary,
    behavior: SnackBarBehavior.floating,
    duration: Duration(seconds: 2),
  ),
);
```

---

## ✅ Testing Checklist

- [ ] Back from Categories → Goes to Home
- [ ] Back from Discover → Goes to Home
- [ ] Back from Favorites → Goes to Home
- [ ] Back from Settings → Goes to Home
- [ ] Back from Home → Shows exit snackbar
- [ ] Double back from Home → Exits app
- [ ] Back with search active → Clears search
- [ ] Back with category selected → Clears category
- [ ] All transitions are smooth
- [ ] No app crashes on back button

---

## 🎉 Benefits

1. **Intuitive Navigation**: Users always know where back button takes them
2. **No Accidental Exits**: Must be on home and double-tap to exit
3. **Clear State Management**: Search and filters cleared properly
4. **Consistent Behavior**: Same pattern across all screens
5. **Visual Feedback**: Users get confirmation of actions
6. **Professional UX**: Matches modern app standards

---

**Navigation is now smooth, intuitive, and user-friendly!** 🚀
