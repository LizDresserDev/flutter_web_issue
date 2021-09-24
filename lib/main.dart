import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:uuid/uuid.dart';
import 'package:firebase_core/firebase_core.dart';

void main() {
  final String mainUuid = Uuid().v4().toString();
  print('mainUuid: $mainUuid');
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Web Issue Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Firebase Messaging Causes Duplicate Build'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _emailFocus = FocusNode();
  final _passwordFocus = FocusNode();
  final _loginButtonFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    _emailController.addListener(_onEmailChanged);
    _passwordController.addListener(_onPasswordChanged);
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocus.dispose();
    _passwordFocus.dispose();
    _loginButtonFocus.dispose();
    super.dispose();
  }

  static final RegExp _emailRegExp = RegExp(
    r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$',
  );

  static final RegExp _passwordRegExp = RegExp(
    r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,20}$',
  );
  bool _isValidEmail(String? email) {
    if (email == null) {
      return false;
    }
    setState(() {});
    return _emailRegExp.hasMatch(email);
  }

  bool _isValidPassword(String? password) {
    if (password == null) {
      return false;
    }
    setState(() {});
    return _passwordRegExp.hasMatch(password);
  }

  bool _isLoginButtonEnabled() {
    return _isValidEmail(_emailController.text) &&
        _isValidPassword(_passwordController.text);
  }

  bool _isChangePasswordEnabled() {
    return _isValidEmail(_emailController.text);
  }

  void _onEmailChanged() {
    print('On Email Change: ${_emailController.toString()}');
    if (_emailController.text.isNotEmpty &&
        (_emailController.text[_emailController.text.length - 1] == "\t" ||
            _emailController.text[_emailController.text.length - 1] == "\n")) {
      _emailController.text =
          _emailController.text.substring(0, _emailController.text.length - 1);
      FocusScope.of(context).requestFocus(_passwordFocus);
    }
  }

  void _onPasswordChanged() {
    print('On Password Change: ${_passwordController.toString()}');
    if (_passwordController.text.isNotEmpty &&
        (_passwordController.text[_passwordController.text.length - 1] ==
                "\t" ||
            _passwordController.text[_passwordController.text.length - 1] ==
                "\n")) {
      _passwordController.text = _passwordController.text
          .substring(0, _passwordController.text.length - 1);
      FocusScope.of(context).requestFocus(_loginButtonFocus);
    }
  }

  void _onFormSubmitted() {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Row(
            children: const [
              Padding(
                padding: EdgeInsets.only(right: 10),
                child: Icon(Icons.check, color: Colors.green),
              ),
              Expanded(
                  child: Text('Logging In!', style: TextStyle(fontSize: 10))),
            ],
          ),
        ),
      );
  }

  void _onInvalidFormSubmitted() {
    String disabledLoginText = 'Invalid Login: ';

    if (!_isValidEmail(_emailController.text) ||
        _emailController.text.trim().isEmpty) {
      disabledLoginText = disabledLoginText + 'Invalid Email. ';
    }

    if (!_isValidPassword(_passwordController.text) ||
        _passwordController.text.trim().isEmpty) {
      disabledLoginText = disabledLoginText + 'Invalid Password. ';
    }
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Padding(
                padding: EdgeInsets.only(right: 10),
                child: Icon(Icons.error, color: Colors.red),
              ),
              Expanded(
                  child: Text(disabledLoginText,
                      style: const TextStyle(fontSize: 10))),
            ],
          ),
        ),
      );
  }

  void _onRequestPasswordChange() {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Row(
            children: const [
              Padding(
                padding: EdgeInsets.only(right: 10),
                child: Icon(Icons.check, color: Colors.green),
              ),
              Expanded(
                  child: Text('Password change request sent',
                      style: TextStyle(fontSize: 10))),
            ],
          ),
        ),
      );
  }

  void _onInvalidRequestPasswordChange() {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Row(
            children: const [
              Padding(
                padding: EdgeInsets.only(right: 10),
                child: Icon(Icons.error, color: Colors.red),
              ),
              Expanded(
                  child: Text('Enter an email address to reset your password!',
                      style: TextStyle(fontSize: 10))),
            ],
          ),
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('Email Changed: ${_emailController.toString()}');
    debugPrint('Password Changed: ${_passwordController.toString()}');

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'REPRODUCTION STEPS:\n   1) Run: flutter build web\n   2) Run: flutter run --release -d chrome\n   3) Pick Chrome\n   4) Inspect the page and go to the console tab\n   5) ',
            ),
            SizedBox(
              width: 300,
              child: TextFormField(
                controller: _emailController,
                autofocus: true,
                focusNode: _emailFocus,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                autocorrect: false,
                validator: (value) {
                  print(_isValidEmail(value));
                },
              ),
            ),
            SizedBox(
              width: 300,
              child: TextFormField(
                controller: _passwordController,
                obscureText: true,
                focusNode: _passwordFocus,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                autocorrect: false,
                validator: (value) {
                  print(_isValidPassword(value));
                },
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                RawKeyboardListener(
                  focusNode: _loginButtonFocus,
                  onKey: (event) {
                    if (event.isKeyPressed(LogicalKeyboardKey.tab)) {
                      FocusScope.of(context).requestFocus(_emailFocus);
                    }
                    if (event.isKeyPressed(LogicalKeyboardKey.enter) &&
                        _isLoginButtonEnabled()) {
                      _onFormSubmitted();
                    } else {
                      _onInvalidFormSubmitted();
                    }
                  },
                  child: Container(
                    color: Colors.grey[400],
                    child: TextButton(
                        onPressed: _isLoginButtonEnabled()
                            ? _onFormSubmitted
                            : _onInvalidFormSubmitted,
                        child: Text("Login",
                            style: TextStyle(
                                color: _isLoginButtonEnabled()
                                    ? Colors.black
                                    : Colors.grey))),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                GestureDetector(
                  onTap: _isChangePasswordEnabled()
                      ? _onRequestPasswordChange
                      : _onInvalidRequestPasswordChange,
                  child: Container(
                    alignment: Alignment.centerRight,
                    height: 48,
                    child: Text(
                      'Forgot password?',
                      style: TextStyle(
                        color: _isChangePasswordEnabled()
                            ? Colors.black
                            : Colors.grey,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
