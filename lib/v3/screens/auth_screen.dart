import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';
import '../theme/irma_theme.dart';
import '../services/irma_supabase_service.dart';
import '../widgets/irma_text_field.dart';
import '../widgets/irma_buttons.dart';
import 'auth_selection_screen.dart';
import 'identity_screen.dart';

enum AuthMode { login, signUp }

class IrmaAuthScreen extends ConsumerStatefulWidget {
  final AuthMode initialMode;
  const IrmaAuthScreen({super.key, this.initialMode = AuthMode.login});

  @override
  ConsumerState<IrmaAuthScreen> createState() => _IrmaAuthScreenState();
}

class _IrmaAuthScreenState extends ConsumerState<IrmaAuthScreen> {
  late AuthMode _mode;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _mode = widget.initialMode;
  }

  Future<void> _handleAuth() async {
    setState(() => _isLoading = true);
    final supabase = ref.read(supabaseServiceProvider);
    
    try {
      if (_mode == AuthMode.signUp) {
        await supabase.signUp(
          email: _emailController.text,
          password: _passwordController.text,
        );
        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const IrmaIdentityScreen()),
          );
        }
      } else {
        await supabase.signIn(
          email: _emailController.text,
          password: _passwordController.text,
        );
        // If login successful, for now just go to identity or shell
        // Usually identity is for new users, so login goes to shell
        if (mounted) {
          Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Auth Error: ${e.toString()}")),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: IrmaTheme.pureWhite,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back_ios_new, size: 20),
              ),
              const SizedBox(height: 40),
              Text(
                _mode == AuthMode.login ? "Welcome Back" : "Create Account",
                style: IrmaTheme.outfit.copyWith(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                _mode == AuthMode.login 
                  ? "Log in to access your cycle history." 
                  : "Join Irma for a healthier journey.",
                style: IrmaTheme.inter.copyWith(color: IrmaTheme.textSub),
              ),
              const SizedBox(height: 48),
              
              IrmaTextField(
                label: "Email Address",
                hint: "example@email.com",
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 24),
              IrmaTextField(
                label: "Password",
                hint: "••••••••",
                isPassword: true,
                controller: _passwordController,
              ),
              
              if (_mode == AuthMode.login)
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {},
                    child: Text("Forgot Password?", style: IrmaTheme.inter.copyWith(color: IrmaTheme.menstrual)),
                  ),
                ),
                
              const SizedBox(height: 48),
              
              IrmaPrimaryButton(
                label: _mode == AuthMode.login ? "Log In" : "Sign Up",
                onTap: _handleAuth,
                isLoading: _isLoading,
              ),
              
              const SizedBox(height: 32),
              
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _mode == AuthMode.login ? "Don't have an account?" : "Already have an account?",
                    style: IrmaTheme.inter.copyWith(color: IrmaTheme.textSub),
                  ),
                  TextButton(
                    onPressed: () => setState(() => _mode = _mode == AuthMode.login ? AuthMode.signUp : AuthMode.login),
                    child: Text(
                      _mode == AuthMode.login ? "Sign Up" : "Log In",
                      style: IrmaTheme.inter.copyWith(color: IrmaTheme.menstrual, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
