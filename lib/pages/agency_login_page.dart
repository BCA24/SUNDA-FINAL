import 'package:flutter/material.dart';
import 'package:houzi_package/files/app_preferences/app_preferences.dart';
import 'package:houzi_package/files/generic_methods/general_notifier.dart';
import 'package:houzi_package/files/generic_methods/utility_methods.dart';
import 'package:houzi_package/files/hive_storage_files/hive_storage_manager.dart';
import 'package:houzi_package/widgets/app_bar_widget.dart';
import 'package:houzi_package/widgets/button_widget.dart';
import 'package:houzi_package/widgets/generic_text_field_widgets/text_field_widget.dart';
import 'package:houzi_package/widgets/toast_widget.dart';
import 'package:houzi_package/pages/home_page_screens/parent_home_related/parent_home.dart';
import 'package:houzi_package/pages/main_screen_pages/my_home_page.dart';
import 'package:houzi_package/common/constants.dart';
import 'package:houzi_package/providers/state_providers/user_log_provider.dart';
import '../services/agency_auth_service.dart';

class AgencyLoginPage extends StatefulWidget {
  @override
  _AgencyLoginPageState createState() => _AgencyLoginPageState();
}

class _AgencyLoginPageState extends State<AgencyLoginPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  
  bool _isLoading = false;
  bool _isRegisterMode = false;
  
  // Additional fields for registration
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
        appBarTitle: _isRegisterMode ? "Agency Registration" : "Login to SuriStay",
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Caribbean-themed header
              Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF006633), Color(0xFF2EC4B6)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    Text(
                      'SuriStay Caribbean',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      _isRegisterMode 
                        ? 'Register your agency to add properties'
                        : 'Choose your access level',
                      style: TextStyle(
                        fontSize: 16,
                        color: Color(0xFFFFCC00),
                      ),
                    ),
                  ],
                ),
              ),
              
              SizedBox(height: 30),
              
              if (!_isRegisterMode) ...[
                // Guest Login Button
                _buildGuestLoginButton(),
                
                SizedBox(height: 20),
                
                // Divider
                Row(
                  children: [
                    Expanded(child: Divider()),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Text('OR', style: TextStyle(color: Colors.grey)),
                    ),
                    Expanded(child: Divider()),
                  ],
                ),
                
                SizedBox(height: 20),
                
                Text(
                  'Agency Login',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF006633),
                  ),
                ),
                
                SizedBox(height: 16),
              ],
              
              // Registration fields
              if (_isRegisterMode) ...[
                TextFormFieldWidget(
                  controller: _nameController,
                  labelText: "Agency Name",
                  hintText: "Enter your agency name",
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter agency name';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
              ],
              
              // Email field
              TextFormFieldWidget(
                controller: _emailController,
                labelText: "Email",
                hintText: _isRegisterMode ? "Enter agency email" : "Enter your email",
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter email';
                  }
                  if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                    return 'Please enter a valid email';
                  }
                  return null;
                },
              ),
              
              SizedBox(height: 16),
              
              // Password field
              TextFormFieldWidget(
                controller: _passwordController,
                labelText: "Password",
                hintText: _isRegisterMode ? "Create password" : "Enter your password",
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter password';
                  }
                  if (_isRegisterMode && value.length < 6) {
                    return 'Password must be at least 6 characters';
                  }
                  return null;
                },
              ),
              
              if (_isRegisterMode) ...[
                SizedBox(height: 16),
                
                TextFormFieldWidget(
                  controller: _phoneController,
                  labelText: "Phone Number",
                  hintText: "Enter agency phone number",
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter phone number';
                    }
                    return null;
                  },
                ),
                
                SizedBox(height: 16),
                
                TextFormFieldWidget(
                  controller: _addressController,
                  labelText: "Address",
                  hintText: "Enter agency address",
                  maxLines: 3,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter address';
                    }
                    return null;
                  },
                ),
              ],
              
              SizedBox(height: 30),
              
              // Submit button
              ButtonWidget(
                text: _isLoading 
                  ? "Processing..." 
                  : (_isRegisterMode ? "Register Agency" : "Login"),
                color: Color(0xFF006633),
                onPressed: _isLoading ? () {} : () => _handleSubmit(),
              ),
              
              SizedBox(height: 16),
              
              // Switch between login and register
              TextButton(
                onPressed: () {
                  setState(() {
                    _isRegisterMode = !_isRegisterMode;
                    _clearForm();
                  });
                },
                child: Text(
                  _isRegisterMode 
                    ? "Already have an account? Login here"
                    : "Don't have an agency account? Register here",
                  style: TextStyle(color: Color(0xFF2EC4B6)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildGuestLoginButton() {
    return Container(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _isLoading ? null : () => _handleGuestLogin(),
        style: ElevatedButton.styleFrom(
          backgroundColor: Color(0xFF2EC4B6),
          padding: EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.person, color: Colors.white),
            SizedBox(width: 8),
            Text(
              'Continue as Guest',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  void _clearForm() {
    _emailController.clear();
    _passwordController.clear();
    _nameController.clear();
    _phoneController.clear();
    _addressController.clear();
  }
  
  Future<void> _handleGuestLogin() async {
    setState(() {
      _isLoading = true;
    });
    
    try {
      final result = await AgencyAuthService.guestLogin();
      
      if (result['success']) {
        _showToast('Welcome! You\'re browsing as a guest.');
        
        // For guests, set logged in status so drawer filtering works properly
        HiveStorageManager.saveData(key: USER_LOGGED_IN, data: true); // Guests ARE logged in but with limited role
        
        // Store guest info using Houzi's method with correct role
        Map<String, dynamic> guestLoginInfo = {
          'user_id': 'guest_user',
          'user_email': 'guest@guest.com',
          'user_display_name': 'Guest User',
          'user_role': ['houzez_buyer'],  // Must be array and use correct Houzi constant!
          'user_login': 'guest_user',
        };
        HiveStorageManager.storeUserLoginInfoData(guestLoginInfo);
        
        // Guests should be marked as logged OUT for Provider to deny Add Property access
        UserLoggedProvider().loggedOut();
        
        print('🔥 Set Guest info - role: houzez_buyer, USER_LOGGED_IN: true, Provider: loggedOut');
        
        // Navigate directly for guests without calling _navigateToHome
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => MyHomePage()),
          (route) => false,
        );
      } else {
        _showToast('Failed to login as guest: ${result['error']}');
      }
    } catch (e) {
      _showToast('An error occurred: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
  
  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    
    setState(() {
      _isLoading = true;
    });
    
    try {
      Map<String, dynamic> result;
      
      if (_isRegisterMode) {
        // Agency Registration
        final agencyData = {
          'name': _nameController.text.trim(),
          'email': _emailController.text.trim(),
          'password': _passwordController.text,
          'phone': _phoneController.text.trim(),
          'address': _addressController.text.trim(),
          'role': 'agency',
        };
        
        result = await AgencyAuthService.agencyRegister(agencyData);
      } else {
        // Agency Login
        result = await AgencyAuthService.agencyLogin(
          _emailController.text.trim(),
          _passwordController.text,
        );
      }
      
      if (result['success']) {
        _showToast(_isRegisterMode 
          ? 'Agency registered successfully!' 
          : 'Welcome back!');
        _navigateToHome();
      } else {
        _showToast(result['error'] ?? 'An error occurred');
      }
    } catch (e) {
      _showToast('An error occurred: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
  
  void _showToast(String message) {
    ShowToastWidget(
      buildContext: context,
      text: message,
    );
  }
  
  void _navigateToHome() {
    HiveStorageManager.saveData(key: USER_LOGGED_IN, data: true);
    UserLoggedProvider().loggedIn();
    GeneralNotifier().publishChange(GeneralNotifier.USER_LOGGED_IN);

    print('🔥 Set Agency login status - USER_LOGGED_IN: true, Provider updated');

    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => MyHomePage()),
      (route) => false,
    );
  }
}