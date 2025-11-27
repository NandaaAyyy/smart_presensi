import 'package:flutter/material.dart';
import '../services/auth_service.dart';
// import 'login_screen.dart'; // Import ini jika Anda ingin navigasi ke LoginScreen tertentu

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> with TickerProviderStateMixin {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _nimController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  
  bool _isStudent = true;
  bool _isLoading = false;
  
  // STATE BARU: Untuk toggle password visibility
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  final AuthService _authService = AuthService();
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  
  // Kunci form untuk validasi (Opsional: dapat ditambahkan untuk validasi field)
  // final _formKey = GlobalKey<FormState>(); 

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeIn,
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _nimController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    // 1. Validasi Password Match
    if (_passwordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Passwords do not match')),
      );
      return;
    }
    
    // 2. Validasi field wajib (Contoh dasar)
    if (_nameController.text.isEmpty || _passwordController.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Name and Password fields cannot be empty.')),
        );
        return;
    }
    
    // Validasi kondisional untuk email/nim
    if (_isStudent) {
        if (_emailController.text.isEmpty || _nimController.text.isEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Email and Student ID are required for students.')),
            );
            return;
        }
    } else {
         if (_emailController.text.isEmpty || _phoneController.text.isEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Email and Phone Number are required for teachers/admin.')),
            );
            return;
        }
    }

    setState(() => _isLoading = true);

    try {
      // 3. Panggil AuthService.register
      await _authService.register(
        name: _nameController.text,
        email: _emailController.text,
        password: _passwordController.text,
        role: _isStudent ? 'student' : 'teacher',
        // Mengirimkan data yang relevan saja. Non-relevan dikirim null.
        nim: _isStudent ? _nimController.text : null, 
        phone: !_isStudent ? _phoneController.text : null,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Registration successful! Please log in.')),
        );
        Navigator.pop(context); // Kembali ke halaman Login
        // Atau: Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LoginScreen()));
      }
    } catch (e) {
      // 4. Tangani Exception dari AuthService (misal: "Registration failed: Network error...")
      if (mounted) {
        // Membersihkan error message jika ada Exception:
        String errorMessage = e.toString().contains('Exception:') 
            ? e.toString().substring(e.toString().indexOf(':') + 1).trim()
            : 'An unknown error occurred.';
            
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Registration failed: $errorMessage')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF667EEA),
              Color(0xFF764BA2),
              Color(0xFFF093FB),
              Color(0xFFF5576C),
            ],
            stops: [0.1, 0.4, 0.7, 0.9],
          ),
        ),
        child: Stack(
          children: [
            // Animated background particles
            ...List.generate(20, (index) {
              return Positioned(
                left: (index * 37.0) % MediaQuery.of(context).size.width,
                top: (index * 41.0) % MediaQuery.of(context).size.height,
                child: AnimatedBuilder(
                  animation: _fadeAnimation,
                  builder: (context, child) {
                    return Opacity(
                      opacity: _fadeAnimation.value * 0.1,
                      child: Container(
                        width: 4 + (index % 3) * 2.0,
                        height: 4 + (index % 3) * 2.0,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.3),
                          shape: BoxShape.circle,
                        ),
                      ),
                    );
                  },
                ),
              );
            }),
            SafeArea(
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: SlideTransition(
                  position: _slideAnimation,
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 20),
                        // Back button
                        Align(
                          alignment: Alignment.topLeft,
                          child: IconButton(
                            onPressed: () => Navigator.pop(context),
                            icon: const Icon(
                              Icons.arrow_back,
                              color: Colors.white,
                              size: 28,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        // Logo/Brand
                        Container(
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.95),
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.white.withOpacity(0.3),
                                blurRadius: 30,
                                spreadRadius: 5,
                              ),
                              BoxShadow(
                                color: const Color(0xFF667EEA).withOpacity(0.3),
                                blurRadius: 20,
                                offset: const Offset(0, 10),
                              ),
                            ],
                          ),
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: const BoxDecoration(
                              gradient: LinearGradient(
                                colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.person_add,
                              size: 48,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(height: 32),
                        // Title
                        ShaderMask(
                          shaderCallback: (bounds) => const LinearGradient(
                            colors: [Colors.white, Colors.white70],
                          ).createShader(bounds),
                          child: const Text(
                            'Create Account',
                            style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              letterSpacing: 1.2,
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Text(
                            'Join Smart Presence',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        const SizedBox(height: 40),
                        // Role Selection - PERBAIKAN DI MULAI DARI SINI ⬇️
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.95),
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 15,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          // Gunakan Row dan Expanded untuk memastikan ToggleButtons pas di layar
                          child: Row(
                            children: [
                              Expanded(
                                child: ToggleButtons(
                                  isSelected: [_isStudent, !_isStudent],
                                  onPressed: (index) {
                                    setState(() {
                                      _isStudent = index == 0;
                                    });
                                  },
                                  borderRadius: BorderRadius.circular(12),
                                  selectedColor: Colors.white,
                                  fillColor: const Color(0xFF667EEA),
                                  color: const Color(0xFF667EEA),
                                  splashColor: Colors.transparent,
                                  highlightColor: Colors.transparent,
                                  // Hapus padding horizontal yang menyebabkan overflow
                                  children: [
                                    Container(
                                      // Padding Vertikal dipertahankan, Horizontal dikecilkan/dihapus
                                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center, // Pusatkan konten
                                        children: [
                                          Icon(
                                            Icons.school,
                                            color: _isStudent ? Colors.white : const Color(0xFF667EEA),
                                          ),
                                          const SizedBox(width: 8),
                                          Text(
                                            'Student',
                                            style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 16,
                                              color: _isStudent ? Colors.white : const Color(0xFF667EEA),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center, // Pusatkan konten
                                        children: [
                                          Icon(
                                            Icons.admin_panel_settings,
                                            color: !_isStudent ? Colors.white : const Color(0xFF667EEA),
                                          ),
                                          const SizedBox(width: 8),
                                          Text(
                                            'Teacher/Admin',
                                            style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 16,
                                              color: !_isStudent ? Colors.white : const Color(0xFF667EEA),
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
                        // Role Selection - PERBAIKAN SELESAI DI SINI ⬆️
                        const SizedBox(height: 32),
                        // Registration Form
                        Container(
                          padding: const EdgeInsets.all(28),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.95),
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 25,
                                offset: const Offset(0, 15),
                              ),
                            ],
                            border: Border.all(
                              color: Colors.white.withOpacity(0.2),
                              width: 1,
                            ),
                          ),
                          child: Column(
                            children: [
                              // Name field
                              _buildTextField(
                                controller: _nameController,
                                labelText: 'Full Name',
                                icon: Icons.person,
                              ),
                              const SizedBox(height: 20),
                              // NIM/Email/Phone field - DYNAMIC
                              AnimatedSwitcher(
                                duration: const Duration(milliseconds: 300),
                                transitionBuilder: (child, animation) {
                                  return SlideTransition(
                                    position: Tween<Offset>(
                                      begin: const Offset(0, 0.2),
                                      end: Offset.zero,
                                    ).animate(animation),
                                    child: FadeTransition(opacity: animation, child: child),
                                  );
                                },
                                child: Column(
                                  key: ValueKey(_isStudent), // Key untuk memaksa AnimatedSwitcher bekerja
                                  children: [
                                    // Field Email (Wajib untuk Keduanya, gunakan emailController)
                                    _buildTextField(
                                        controller: _emailController,
                                        labelText: 'Email Address',
                                        icon: Icons.email,
                                    ),
                                    const SizedBox(height: 20),
                                    if (_isStudent)
                                        // NIM field (Student)
                                        _buildTextField(
                                          controller: _nimController,
                                          labelText: 'Student ID (NIM)',
                                          icon: Icons.badge,
                                          keyboardType: TextInputType.number,
                                        )
                                    else
                                        // Phone field (Teacher/Admin)
                                        _buildTextField(
                                          controller: _phoneController,
                                          labelText: 'Phone Number',
                                          icon: Icons.phone,
                                          keyboardType: TextInputType.phone,
                                        ),
                                    
                                  ],
                                ),
                              ),
                              const SizedBox(height: 20),
                              // Password field
                              _buildPasswordField(
                                controller: _passwordController,
                                labelText: 'Password',
                                isVisible: _isPasswordVisible,
                                onToggle: () {
                                  setState(() {
                                    _isPasswordVisible = !_isPasswordVisible;
                                  });
                                },
                              ),
                              const SizedBox(height: 20),
                              // Confirm Password field
                              _buildPasswordField(
                                controller: _confirmPasswordController,
                                labelText: 'Confirm Password',
                                isVisible: _isConfirmPasswordVisible,
                                onToggle: () {
                                  setState(() {
                                    _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                                  });
                                },
                              ),
                              const SizedBox(height: 24),
                              // Register button
                              Container(
                                width: double.infinity,
                                height: 56,
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
                                    begin: Alignment.centerLeft,
                                    end: Alignment.centerRight,
                                  ),
                                  borderRadius: BorderRadius.circular(14),
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color(0xFF667EEA).withOpacity(0.3),
                                      blurRadius: 12,
                                      offset: const Offset(0, 6),
                                    ),
                                  ],
                                ),
                                child: ElevatedButton(
                                  onPressed: _isLoading ? null : _register,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.transparent,
                                    shadowColor: Colors.transparent,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(14),
                                    ),
                                  ),
                                  child: _isLoading
                                      ? const CircularProgressIndicator(color: Colors.white)
                                      : const Text(
                                          'Create Account',
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.white,
                                          ),
                                        ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),
                        // Back to login
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Already have an account?',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.8),
                                fontSize: 14,
                              ),
                            ),
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text(
                                'Sign In',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  // Helper Widget untuk TextField Biasa
  Widget _buildTextField({
    required TextEditingController controller,
    required String labelText,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextField(
      controller: controller,
      style: const TextStyle(fontSize: 16),
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: TextStyle(
          color: const Color(0xFF667EEA).withOpacity(0.7),
        ),
        prefixIcon: Container(
          padding: const EdgeInsets.all(12),
          child: Icon(
            icon,
            color: const Color(0xFF667EEA),
          ),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        filled: true,
        fillColor: Colors.grey[50],
        contentPadding: const EdgeInsets.symmetric(vertical: 16),
      ),
    );
  }
  
  // Helper Widget untuk Password Field (dengan toggle)
  Widget _buildPasswordField({
    required TextEditingController controller,
    required String labelText,
    required bool isVisible,
    required VoidCallback onToggle,
  }) {
    return TextField(
      controller: controller,
      obscureText: !isVisible,
      style: const TextStyle(fontSize: 16),
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: TextStyle(
          color: const Color(0xFF667EEA).withOpacity(0.7),
        ),
        prefixIcon: Container(
          padding: const EdgeInsets.all(12),
          child: const Icon(
            Icons.lock_outline,
            color: Color(0xFF667EEA),
          ),
        ),
        suffixIcon: IconButton(
          icon: Icon(
            isVisible ? Icons.visibility : Icons.visibility_off,
            color: const Color(0xFF667EEA),
          ),
          onPressed: onToggle,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        filled: true,
        fillColor: Colors.grey[50],
        contentPadding: const EdgeInsets.symmetric(vertical: 16),
      ),
    );
  }
}