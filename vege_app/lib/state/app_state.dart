import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/vegetable_model.dart';
import '../models/category_model.dart';
import '../models/cart_item_model.dart';
import '../services/auth_service.dart';
import '../services/vegetable_api_service.dart';

class AppState extends ChangeNotifier {
  // Singleton pattern for easy global access
  static final AppState _instance = AppState._internal();
  factory AppState() => _instance;

  AppState._internal() {
    // Initial sample items in cart for better demo experience
    if (sampleVegetables.length >= 4) {
      _cart.add(CartItemModel(vegetable: sampleVegetables[0], quantity: 2));
      _cart.add(CartItemModel(vegetable: sampleVegetables[1], quantity: 1));
      _favorites.add(sampleVegetables[0].id);
      _favorites.add(sampleVegetables[3].id);
    }

    // Initial auth listener
    _initAuthListener();

    // Fetch live API data
    fetchVegetables();
    fetchCategories();
  }

  // API Service & Vegetable State
  final VegetableApiService _apiService = VegetableApiService();
  List<VegetableModel> _vegetables = [];
  List<VegetableCategory> _categories = [];
  bool _isLoadingVegetables = false;
  String? _vegetablesError;

  List<VegetableModel> get vegetables =>
      _vegetables.isNotEmpty ? _vegetables : sampleVegetables;
  List<VegetableCategory> get categories => _categories;
  bool get isLoadingVegetables => _isLoadingVegetables;
  String? get vegetablesError => _vegetablesError;

  Future<void> fetchVegetables({bool refresh = false}) async {
    if (_isLoadingVegetables) return;
    _isLoadingVegetables = true;
    _vegetablesError = null;
    notifyListeners();

    try {
      final result = await _apiService.fetchVegetables();
      if (result.isNotEmpty) {
        _vegetables = result;
      }
      _vegetablesError = null;
    } catch (e) {
      _vegetablesError = e.toString();
      debugPrint('[AppState] Error fetching vegetables: $e');
    } finally {
      _isLoadingVegetables = false;
      notifyListeners();
    }
  }

  Future<void> fetchCategories() async {
    try {
      final result = await _apiService.fetchCategories();
      if (result.isNotEmpty) {
        _categories = result;
        notifyListeners();
      }
    } catch (e) {
      debugPrint('[AppState] Error fetching categories: $e');
    }
  }

  Future<VegetableModel?> fetchVegetableDetail(String id) async {
    try {
      final detail = await _apiService.fetchVegetableDetail(id);
      final index = _vegetables.indexWhere((v) => v.id == id);
      if (index != -1) {
        _vegetables[index] = detail;
        notifyListeners();
      }
      return detail;
    } catch (e) {
      debugPrint('[AppState] Error fetching vegetable detail $id: $e');
      return null;
    }
  }

  // Firebase Auth State
  final AuthService _authService = AuthService();
  User? _firebaseUser;
  bool _isLoggedIn = false;
  bool _isGuest = false;
  String _userName = 'Pengguna VegBox';
  String _userEmail = 'user@vegbox.id';
  String _userPhone = '+62 812 3456 7890';
  String _userAddress = 'Jl. Surya Kencana No. 45, Kebayoran Baru, Jakarta Selatan';
  String? _userPhotoUrl;

  bool get isLoggedIn => _isLoggedIn;
  bool get isGuest => _isGuest;
  User? get firebaseUser => _firebaseUser;
  String get userName => _userName;
  String get userEmail => _userEmail;
  String get userPhone => _userPhone;
  String get userAddress => _userAddress;
  String? get userPhotoUrl => _userPhotoUrl;

  void _initAuthListener() {
    try {
      final initialUser = _authService.currentUser;
      if (initialUser != null) {
        _syncUser(initialUser);
      }

      _authService.authStateChanges.listen((User? user) {
        if (user != null) {
          _isGuest = false;
          _syncUser(user);
        } else if (!_isGuest) {
          _isLoggedIn = false;
          _firebaseUser = null;
        }
        notifyListeners();
      });
    } catch (e) {
      debugPrint('Auth listener init error: $e');
    }
  }

  void _syncUser(User user) {
    _firebaseUser = user;
    _isLoggedIn = true;
    if (user.displayName != null && user.displayName!.trim().isNotEmpty) {
      _userName = user.displayName!;
    } else if (user.email != null && user.email!.isNotEmpty) {
      _userName = user.email!.split('@').first;
    }
    if (user.email != null && user.email!.isNotEmpty) {
      _userEmail = user.email!;
    }
    if (user.phoneNumber != null && user.phoneNumber!.isNotEmpty) {
      _userPhone = user.phoneNumber!;
    }
    _userPhotoUrl = user.photoURL;
  }

  void login({String? name, String? email, String? phone}) {
    if (name != null && name.trim().isNotEmpty) _userName = name;
    if (email != null && email.trim().isNotEmpty) _userEmail = email;
    if (phone != null && phone.trim().isNotEmpty) _userPhone = phone;
    _isGuest = false;
    _isLoggedIn = true;
    notifyListeners();
  }

  void loginAsGuest() {
    _isGuest = true;
    _isLoggedIn = true;
    _userName = 'Tamu Sehat';
    _userEmail = 'guest@vegbox.id';
    _userPhone = '+62 800 0000 0000';
    notifyListeners();
  }

  Future<void> logout() async {
    _isGuest = false;
    _isLoggedIn = false;
    _firebaseUser = null;
    try {
      await AuthService().signOut();
    } catch (e) {
      debugPrint('Error signing out: $e');
    }
    notifyListeners();
  }

  Future<void> updateProfile({
    required String name,
    required String phone,
    required String address,
  }) async {
    _userName = name;
    _userPhone = phone;
    _userAddress = address;

    if (_firebaseUser != null && name.trim().isNotEmpty) {
      try {
        await _firebaseUser!.updateDisplayName(name.trim());
        await _firebaseUser!.reload();
        _firebaseUser = _authService.currentUser;
      } catch (e) {
        debugPrint('Error updating Firebase display name: $e');
      }
    }
    notifyListeners();
  }

  // Theme State
  ThemeMode _themeMode = ThemeMode.light;
  ThemeMode get themeMode => _themeMode;
  bool get isDarkMode => _themeMode == ThemeMode.dark;

  void toggleTheme() {
    _themeMode = _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }

  // Navigation State
  int _currentNavIndex = 0;
  int get currentNavIndex => _currentNavIndex;

  void setNavIndex(int index) {
    _currentNavIndex = index;
    notifyListeners();
  }

  // Category and Search Filtering
  String _selectedCategory = 'Semua';
  String _searchQuery = '';

  String get selectedCategory => _selectedCategory;
  String get searchQuery => _searchQuery;

  void setCategory(String category) {
    _selectedCategory = category;
    notifyListeners();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  // Favorites
  final Set<String> _favorites = {};
  Set<String> get favorites => _favorites;

  bool isFavorite(String vegetableId) => _favorites.contains(vegetableId);

  void toggleFavorite(String vegetableId) {
    if (_favorites.contains(vegetableId)) {
      _favorites.remove(vegetableId);
    } else {
      _favorites.add(vegetableId);
    }
    notifyListeners();
  }

  // Shopping Cart
  final List<CartItemModel> _cart = [];
  List<CartItemModel> get cart => List.unmodifiable(_cart);

  int get cartCount => _cart.fold(0, (sum, item) => sum + item.quantity);

  double get subtotal => _cart.fold(0.0, (sum, item) => sum + item.totalPrice);

  double get deliveryFee => (subtotal > 50000 || subtotal == 0) ? 0.0 : 10000.0;

  double _promoDiscount = 0.0;
  String _appliedPromoCode = '';
  String get appliedPromoCode => _appliedPromoCode;
  double get promoDiscount => _promoDiscount;

  bool applyPromoCode(String code) {
    final cleanCode = code.trim().toUpperCase();
    if (cleanCode == 'VEG75' || cleanCode == 'PANENBERKAH') {
      _promoDiscount = subtotal * 0.20; // 20% discount up to max
      _appliedPromoCode = cleanCode;
      notifyListeners();
      return true;
    }
    return false;
  }

  void removePromoCode() {
    _promoDiscount = 0.0;
    _appliedPromoCode = '';
    notifyListeners();
  }

  double get grandTotal {
    final total = subtotal + deliveryFee - _promoDiscount;
    return total < 0 ? 0 : total;
  }

  void addToCart(VegetableModel vegetable, {int quantity = 1}) {
    final index = _cart.indexWhere((item) => item.vegetable.id == vegetable.id);
    if (index >= 0) {
      _cart[index].quantity += quantity;
    } else {
      _cart.add(CartItemModel(vegetable: vegetable, quantity: quantity));
    }
    notifyListeners();
  }

  void decreaseQuantity(String vegetableId) {
    final index = _cart.indexWhere((item) => item.vegetable.id == vegetableId);
    if (index >= 0) {
      if (_cart[index].quantity > 1) {
        _cart[index].quantity -= 1;
      } else {
        _cart.removeAt(index);
      }
      notifyListeners();
    }
  }

  void removeFromCart(String vegetableId) {
    _cart.removeWhere((item) => item.vegetable.id == vegetableId);
    notifyListeners();
  }

  void clearCart() {
    _cart.clear();
    _promoDiscount = 0.0;
    _appliedPromoCode = '';
    notifyListeners();
  }
}
