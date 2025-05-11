import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../bloc/auth/index.dart';
import '../theme/app_theme.dart';
import '../utils/snackbar_utils.dart';
import 'auth/login_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _addressController;

  // Animation controller for subtle animations
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: "John Doe");
    _emailController = TextEditingController(text: "john.doe@example.com");
    _phoneController = TextEditingController(text: "+1 234 567 890");
    _addressController = TextEditingController(
      text: "123 Main Street, New York, NY 10001",
    );

    // Initialize animation controller
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeIn,
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _toggleEditMode() {
    setState(() {
      _isEditing = !_isEditing;
    });

    if (_isEditing) {
      _animationController.reset();
      _animationController.forward();
    }
  }

  void _saveProfile() {
    if (_formKey.currentState!.validate()) {
      // Here you would save the profile data to a database or shared preferences
      setState(() {
        _isEditing = false;
      });
      SnackBarUtils.showSuccessSnackBar(context, 'Profil berhasil diperbarui!');
    }
  }

  void _logout() {
    // Show confirmation dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Keluar'),
          content: const Text('Apakah Anda yakin ingin keluar?'),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () {
                // Close the dialog
                Navigator.of(context).pop();

                // Dispatch logout event
                context.read<AuthBloc>().add(const LogOut());

                // Show success message
                SnackBarUtils.showInfoSnackBar(
                  context,
                  'You have been logged out.',
                );

                // Navigate to login screen
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                );
              },
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('Keluar'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            // _buildAppBar(isDarkMode),
            SliverToBoxAdapter(child: _buildProfileHeader()),
            SliverList(
              delegate: SliverChildListDelegate([
                _buildProfileForm(theme),
                _buildBottomButtons(),
              ]),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar(bool isDarkMode) {
    return SliverAppBar(
      expandedHeight: 100.0,
      floating: false,
      pinned: true,
      elevation: 0,
      backgroundColor:
          isDarkMode ? AppTheme.darkCardColor : AppTheme.primaryColor,
      flexibleSpace: FlexibleSpaceBar(centerTitle: true),
    );
  }

  Widget _buildProfileHeader() {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 30, 20, 20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors:
              isDarkMode
                  ? [AppTheme.darkCardColor, Color(0xFF252525)]
                  : [AppTheme.primaryColor, Color(0xFF8A84FF)],
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(40),
          bottomRight: Radius.circular(40),
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
          Stack(
            alignment: Alignment.bottomRight,
            children: [
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 20,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Hero(
                  tag: 'profile-avatar',
                  child: Material(
                    elevation: 0,
                    shape: CircleBorder(
                      side: BorderSide(color: Colors.white, width: 4),
                    ),
                    child: CircleAvatar(
                      radius: 55,
                      backgroundColor:
                          isDarkMode ? Color(0xFF303030) : Colors.white,
                      child: Icon(
                        Icons.person,
                        size: 70,
                        color:
                            isDarkMode ? Colors.white70 : AppTheme.primaryColor,
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                right: 0,
                bottom: 5,
                child: Container(
                  padding: EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: isDarkMode ? AppTheme.accentColor : Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 6,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.camera_alt,
                    size: 20,
                    color: isDarkMode ? Colors.white : AppTheme.primaryColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          BlocBuilder<AuthBloc, AuthState>(
            builder: (context, state) {
              return Column(
                children: [
                  Text(
                    state.status == AuthStatus.authenticated
                        ? (state.username ?? 'Guest')
                        : 'John Doe',
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.calendar_today,
                          size: 14,
                          color: Colors.white,
                        ),
                        const SizedBox(width: 6),
                        const Text(
                          'Member since May 2025',
                          style: TextStyle(color: Colors.white, fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildProfileForm(ThemeData theme) {
    return AnimatedPadding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
      duration: const Duration(milliseconds: 300),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              elevation: 4,
              margin: const EdgeInsets.only(bottom: 20),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.person_outline,
                              color: theme.colorScheme.primary,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Personal Information',
                              style: theme.textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        IconButton(
                          icon: Icon(
                            _isEditing ? Icons.close : Icons.edit,
                            color: theme.colorScheme.primary,
                          ),
                          onPressed: _toggleEditMode,
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    _buildAnimatedTextField(
                      label: 'Full Name',
                      controller: _nameController,
                      icon: Icons.person,
                      isEnabled: _isEditing,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your name';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    _buildAnimatedTextField(
                      label: 'Email',
                      controller: _emailController,
                      icon: Icons.email,
                      isEnabled: _isEditing,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        }
                        if (!value.contains('@')) {
                          return 'Please enter a valid email';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    _buildAnimatedTextField(
                      label: 'Phone Number',
                      controller: _phoneController,
                      icon: Icons.phone,
                      isEnabled: _isEditing,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your phone number';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    _buildAnimatedTextField(
                      label: 'Address',
                      controller: _addressController,
                      icon: Icons.home,
                      isEnabled: _isEditing,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your address';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomButtons() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Save button (only visible when editing)
          if (_isEditing)
            Container(
              width: double.infinity,
              margin: const EdgeInsets.only(bottom: 20),
              child: ElevatedButton(
                onPressed: _saveProfile,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 4,
                ),
                child: const Text(
                  'Save Changes',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ), // Logout button (only visible when not editing)
          if (!_isEditing)
            Container(
              width: double.infinity,
              margin: const EdgeInsets.only(bottom: 20, left: 16, right: 16),
              child: ElevatedButton.icon(
                onPressed: _logout,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor:
                      Theme.of(context).brightness == Brightness.dark
                          ? Color(0xFF424242)
                          : Colors.white,
                  foregroundColor:
                      Theme.of(context).brightness == Brightness.dark
                          ? Colors.white
                          : AppTheme.primaryColor,
                  elevation: 2,
                  shadowColor: Colors.black26,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                icon: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color:
                        Theme.of(context).brightness == Brightness.dark
                            ? Colors.white.withOpacity(0.1)
                            : AppTheme.primaryColor.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.logout_rounded,
                    color:
                        Theme.of(context).brightness == Brightness.dark
                            ? AppTheme.accentColor
                            : AppTheme.primaryColor,
                    size: 20,
                  ),
                ),
                label: Text(
                  'Logout',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildAnimatedTextField({
    required String label,
    required TextEditingController controller,
    required IconData icon,
    required bool isEnabled,
    String? Function(String?)? validator,
  }) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color:
            isEnabled
                ? Theme.of(context).brightness == Brightness.dark
                    ? Colors.grey.shade800
                    : Colors.grey.shade100
                : Colors.transparent,
      ),
      child: TextFormField(
        controller: controller,
        validator: validator,
        enabled: isEnabled,
        style: TextStyle(color: Theme.of(context).textTheme.bodyLarge?.color),
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: Theme.of(context).colorScheme.primary,
              width: 2,
            ),
          ),
          filled: true,
          fillColor:
              Theme.of(context).brightness == Brightness.dark
                  ? Colors.grey.shade800.withOpacity(isEnabled ? 1.0 : 0.5)
                  : Colors.white.withOpacity(isEnabled ? 1.0 : 0.7),
        ),
      ),
    );
  }
}
