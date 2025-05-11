import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../bloc/auth/index.dart';
import '../bloc/theme/index.dart';
import '../models/product.dart';
import '../screens/profile_screen.dart';
import '../services/api_service.dart';
import '../theme/app_theme.dart';

class HomeScreenApi extends StatefulWidget {
  const HomeScreenApi({super.key});

  @override
  State<HomeScreenApi> createState() => _HomeScreenApiState();
}

class _HomeScreenApiState extends State<HomeScreenApi>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final PageController _pageController = PageController();

  // Product variables
  late Future<List<Product>> featuredProducts;
  late Future<List<Product>> popularProducts;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    // We still need the TabController for bottom navigation
    _tabController = TabController(length: 2, vsync: this);

    // Load API data
    _loadProducts();
  }

  void _loadProducts() {
    try {
      featuredProducts = ApiService.getProducts();
      popularProducts = ApiService.getProducts();
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      print('Kesalahan memuat produk: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _tabController.animateTo(index);
                  });
                },
                children: [_buildHomeTab(), _buildProfileTab()],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavigation(),
    );
  }

  Widget _buildHeader() {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors:
              isDarkMode
                  ? [AppTheme.darkCardColor, const Color(0xFF252525)]
                  : [
                    AppTheme.primaryColor.withOpacity(0.8),
                    AppTheme.primaryColor,
                  ],
        ),
        boxShadow:
            isDarkMode
                ? []
                : [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 1,
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              BlocBuilder<AuthBloc, AuthState>(
                builder: (context, state) {
                  return Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.person_outline,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Selamat Datang,',
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: Colors.white.withOpacity(0.8),
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '${state.username ?? 'Pengguna'}',
                            style: GoogleFonts.poppins(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ],
                  );
                },
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: IconButton(
                  icon: Icon(
                    isDarkMode ? Icons.light_mode : Icons.dark_mode,
                    color: Colors.white,
                    size: 24,
                  ),
                  onPressed: () {
                    // Toggle theme with animation
                    context.read<ThemeBloc>().add(const ThemeToggled());
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                const Icon(Icons.search, color: Colors.white, size: 24),
                const SizedBox(width: 12),
                Text(
                  'Cari produk',
                  style: GoogleFonts.poppins(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _buildHomeTab() {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Promotional carousel
          Container(
            height: 180,
            margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [AppTheme.primaryColor, AppTheme.accentColor],
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.primaryColor.withOpacity(0.3),
                  spreadRadius: 1,
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Positioned(
                  right: -20,
                  bottom: -15,
                  child: Icon(
                    Icons.shopping_bag,
                    size: 150,
                    color: Colors.white.withOpacity(0.1),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.3),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                'PENAWARAN SPESIAL',
                                style: GoogleFonts.poppins(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 1,
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              'Koleksi Ponsel 2025',
                              style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              'Dapatkan diskon hingga 30% untuk semua aksesori ponsel',
                              style: GoogleFonts.poppins(
                                color: Colors.white.withOpacity(0.8),
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: Text(
                                'Beli Sekarang',
                                style: GoogleFonts.poppins(
                                  color: AppTheme.primaryColor,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Featured items section
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Produk Unggulan',
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: isDarkMode ? Colors.white : Colors.black87,
                  ),
                ),
                Text(
                  'Lihat Semua',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppTheme.primaryColor,
                  ),
                ),
              ],
            ),
          ), // Featured items list
          Container(
            height: 210,
            margin: const EdgeInsets.only(bottom: 16),
            child:
                isLoading
                    ? _buildLoadingIndicator()
                    : FutureBuilder<List<Product>>(
                      future: featuredProducts,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return _buildLoadingIndicator();
                        } else if (snapshot.hasError) {
                          return _buildErrorWidget(snapshot.error.toString());
                        } else if (!snapshot.hasData ||
                            snapshot.data!.isEmpty) {
                          return _buildEmptyWidget(
                            'Tidak ada produk unggulan tersedia',
                          );
                        }
                        final products = snapshot.data!;

                        return ListView.builder(
                          physics: const BouncingScrollPhysics(),
                          padding: const EdgeInsets.only(left: 16, right: 16),
                          scrollDirection: Axis.horizontal,
                          itemCount:
                              products.length > 10 ? 10 : products.length,
                          itemBuilder: (context, index) {
                            final product = products[index];
                            return Container(
                              width: 180,
                              margin: const EdgeInsets.only(right: 16),
                              decoration: BoxDecoration(
                                color:
                                    isDarkMode
                                        ? const Color(0xFF303030)
                                        : Colors.white,
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.08),
                                    blurRadius: 10,
                                    spreadRadius: 1,
                                    offset: const Offset(0, 5),
                                  ),
                                ],
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Stack(
                                    children: [
                                      Container(
                                        height: 130,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              const BorderRadius.vertical(
                                                top: Radius.circular(16),
                                              ),
                                          image: DecorationImage(
                                            image: NetworkImage(
                                              product.primaryImage,
                                            ),
                                            fit: BoxFit.cover,
                                            onError:
                                                (_, __) => const AssetImage(
                                                  'assets/images/item1.png',
                                                ),
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        top: 8,
                                        right: 8,
                                        child: Container(
                                          padding: const EdgeInsets.all(6),
                                          decoration: const BoxDecoration(
                                            color: Colors.white,
                                            shape: BoxShape.circle,
                                          ),
                                          child: Icon(
                                            Icons.favorite_border,
                                            size: 18,
                                            color: AppTheme.primaryColor,
                                          ),
                                        ),
                                      ),
                                      if (index <
                                          3) // Show "New" badge for first 3 items
                                        Positioned(
                                          top: 8,
                                          left: 8,
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 8,
                                              vertical: 4,
                                            ),
                                            decoration: BoxDecoration(
                                              color: AppTheme.accentColor,
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                            child: Text(
                                              'BARU',
                                              style: GoogleFonts.poppins(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 10,
                                              ),
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                      12,
                                      6,
                                      12,
                                      6,
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          product.title,
                                          style: GoogleFonts.poppins(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 14,
                                            color:
                                                isDarkMode
                                                    ? Colors.white
                                                    : Colors.black87,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(height: 3),
                                        Text(
                                          product.description,
                                          style: GoogleFonts.poppins(
                                            color:
                                                isDarkMode
                                                    ? Colors.grey.shade300
                                                    : Colors.grey.shade600,
                                            fontSize: 12,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(height: 4),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(
                                              child: Text(
                                                'Rp${product.price * 15000}',
                                                style: GoogleFonts.poppins(
                                                  color: AppTheme.primaryColor,
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 16,
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                            Container(
                                              padding: const EdgeInsets.all(6),
                                              decoration: BoxDecoration(
                                                color: AppTheme.primaryColor,
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                              child: const Icon(
                                                Icons.visibility,
                                                color: Colors.white,
                                                size: 16,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      },
                    ),
          ),

          // Popular section
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Populer Saat Ini',
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: isDarkMode ? Colors.white : Colors.black87,
                  ),
                ),
                Text(
                  'Lihat Semua',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppTheme.primaryColor,
                  ),
                ),
              ],
            ),
          ),

          // Popular items with API data
          isLoading
              ? _buildLoadingIndicator()
              : FutureBuilder<List<Product>>(
                future: popularProducts,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return _buildLoadingIndicator();
                  } else if (snapshot.hasError) {
                    return _buildErrorWidget(snapshot.error.toString());
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return _buildEmptyWidget(
                      'Tidak ada produk populer tersedia',
                    );
                  }

                  final products = snapshot.data!;
                  // Limit to 5 products for display
                  final displayProducts =
                      products.length > 5 ? products.sublist(0, 5) : products;

                  return ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    shrinkWrap: true,
                    itemCount: displayProducts.length,
                    itemBuilder: (context, index) {
                      final product = displayProducts[index];
                      return Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        decoration: BoxDecoration(
                          color:
                              isDarkMode
                                  ? const Color(0xFF303030)
                                  : Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.06),
                              blurRadius: 8,
                              spreadRadius: 1,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 100,
                              height: 100,
                              decoration: BoxDecoration(
                                color: Colors.grey.shade200,
                                borderRadius: const BorderRadius.horizontal(
                                  left: Radius.circular(16),
                                ),
                                image: DecorationImage(
                                  image: NetworkImage(product.primaryImage),
                                  fit: BoxFit.cover,
                                  onError:
                                      (_, __) => const AssetImage(
                                        'assets/images/item1.png',
                                      ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(12),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            product.title,
                                            style: GoogleFonts.poppins(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 16,
                                              color:
                                                  isDarkMode
                                                      ? Colors.white
                                                      : Colors.black87,
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 8,
                                            vertical: 4,
                                          ),
                                          decoration: BoxDecoration(
                                            color: AppTheme.primaryColor
                                                .withOpacity(0.2),
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                          ),
                                          child: Row(
                                            children: [
                                              Icon(
                                                Icons.star,
                                                size: 14,
                                                color: AppTheme.primaryColor,
                                              ),
                                              const SizedBox(width: 2),
                                              Text(
                                                '${4.5 + (index * 0.1)}',
                                                style: GoogleFonts.poppins(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w500,
                                                  color: AppTheme.primaryColor,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      product.description,
                                      style: GoogleFonts.poppins(
                                        color:
                                            isDarkMode
                                                ? Colors.grey.shade300
                                                : Colors.grey.shade600,
                                        fontSize: 12,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 8),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Rp${product.price * 15000}',
                                          style: GoogleFonts.poppins(
                                            color: AppTheme.primaryColor,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 16,
                                          ),
                                        ),
                                        Container(
                                          padding: const EdgeInsets.all(6),
                                          decoration: BoxDecoration(
                                            color: AppTheme.primaryColor,
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                          ),
                                          child: const Icon(
                                            Icons.info_outline,
                                            color: Colors.white,
                                            size: 18,
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
                },
              ),

          // Bottom padding
          const SizedBox(height: 80),
        ],
      ),
    );
  }

  Widget _buildProfileTab() {
    return const ProfileScreen();
  }

  Widget _buildBottomNavigation() {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Container(
      height: 70,
      decoration: BoxDecoration(
        color: isDarkMode ? const Color(0xFF252525) : Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 0,
            blurRadius: 10,
            offset: const Offset(0, -1),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(0, Icons.home_rounded, 'Beranda'),
          _buildNavItem(1, Icons.person_rounded, 'Profil'),
        ],
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label) {
    final isSelected = index == _tabController.index;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return InkWell(
      onTap: () {
        setState(() {
          _tabController.animateTo(index);
          _pageController.animateToPage(
            index,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        });
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            padding: EdgeInsets.all(isSelected ? 12 : 8),
            decoration: BoxDecoration(
              color:
                  isSelected
                      ? AppTheme.primaryColor.withOpacity(
                        isDarkMode ? 0.2 : 0.1,
                      )
                      : Colors.transparent,
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color:
                  isSelected
                      ? AppTheme.primaryColor
                      : (isDarkMode
                          ? Colors.grey.shade400
                          : Colors.grey.shade600),
              size: 26,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: GoogleFonts.poppins(
              color:
                  isSelected
                      ? AppTheme.primaryColor
                      : (isDarkMode
                          ? Colors.grey.shade400
                          : Colors.grey.shade600),
              fontSize: 12,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  // Helper widgets for API integration
  Widget _buildLoadingIndicator() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: const Center(child: CircularProgressIndicator()),
    );
  }

  Widget _buildErrorWidget(String errorMessage) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, color: Colors.red, size: 60),
          const SizedBox(height: 16),
          Text(
            'Kesalahan memuat data',
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            errorMessage,
            style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _loadProducts();
              });
            },
            child: const Text('Coba Lagi'),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyWidget(String message) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.inbox, color: Colors.grey, size: 60),
          const SizedBox(height: 16),
          Text(
            message,
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
