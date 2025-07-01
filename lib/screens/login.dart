import 'package:flutter/material.dart';
import 'package:web_view/screens/tnc.dart';

class LoginPage extends StatefulWidget {
  final Function(
    String
  ) onSubmit;
  final bool loader;

  const LoginPage({super.key, required this.onSubmit, required this.loader});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool isChecked = false;
  // final TextEditingController _correlationIdController =
  //     TextEditingController();
  // final TextEditingController _referenceIdController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  // final TextEditingController _usernameController = TextEditingController();
  // final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              Center(
                child: Image.asset('assets/images/logo.png'),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    const Text(
                      'Welcome',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Log in to continue accessing your account.',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 5),
                    // _buildInputLabel('Your Correlation id'),
                    // _buildTextField(_correlationIdController, 'Enter correlation id'),
                    // const SizedBox(height: 20),
                    // _buildInputLabel('Refference Id'),
                    // _buildTextField(
                    //   _referenceIdController,
                    //   'Enter Refference Id',
                    // ),
                    const SizedBox(height: 20),
                    _buildInputLabel('Mobile Number'),
                    _buildTextField(_mobileController, 'Enter mobile number'),
                    // const SizedBox(height: 20),
                    // _buildInputLabel('Username'),
                    // _buildTextField(_usernameController, 'Enter username'),
                    // const SizedBox(height: 20),
                    // _buildInputLabel('Password'),
                    // _buildTextField(_passwordController, 'Enter password'),
                    const SizedBox(height: 20),
                    // Row(
                    //   children: [
                    //     Checkbox(
                    //       value: isChecked,
                    //       onChanged: (value) {
                    //         setState(() {
                    //           isChecked = value!;
                    //         });
                    //       },
                    //       shape: RoundedRectangleBorder(
                    //         borderRadius: BorderRadius.circular(4),
                    //       ),
                    //     ),
                    //     const Text(
                    //       'Keep me logged in.',
                    //       style: TextStyle(fontSize: 16, color: Colors.black87),
                    //     ),
                    //   ],
                    // ),
                    // const SizedBox(height: 32),
                    _buildLoginButton(),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("For Privacy Policy ",
                      style: TextStyle(color: Colors.grey[600])),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                const TermsAndConditionsPage()), // Navigate to TncScreen
                      );
                    },
                    child: const Text(
                      'Click Here',
                      style: TextStyle(
                        color: Colors.amber,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              Center(
                child: Image.asset('assets/images/privacy.png'),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: Colors.black87,
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String hint,
      {bool isPassword = false}) {
    return TextField(
      controller: controller,
      obscureText: isPassword,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: Colors.grey[400]),
        filled: true,
        fillColor: Colors.white,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Colors.amber),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
    );
  }

  Widget _buildLoginButton() {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: () {
          widget.onSubmit(_mobileController.text);
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.amber,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
        child: widget.loader
            ? const CircularProgressIndicator(
                color: Colors.white,
              )
            : const Text(
                'Log in',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
      ),
    );
  }
}
