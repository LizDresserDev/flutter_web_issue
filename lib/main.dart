import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:uuid/uuid.dart';
import 'package:firebase_core/firebase_core.dart';

void main() {
  final String projectUuid = Uuid().v4().toString();
  print('MAIN projectUuid: $projectUuid');
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp();
  runApp(MyApp(projectUuid: projectUuid));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key, required this.projectUuid}) : super(key: key);
  final String projectUuid;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Web Issue Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(
          title: 'Firebase Messaging Causes Duplicate Build',
          projectUuid: projectUuid),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title, required this.projectUuid})
      : super(key: key);
  final String title;
  final String projectUuid;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _emailController = TextEditingController();
  final _emailFocus = FocusNode();
  final _passwordFocus = FocusNode();
  final _loginButtonFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    _emailController.addListener(_onEmailChanged);
  }

  @override
  void dispose() {
    _emailController.dispose();
    _emailFocus.dispose();
    _passwordFocus.dispose();
    _loginButtonFocus.dispose();
    super.dispose();
  }

  void _onEmailChanged() {
    print(
        "LSTN projectUuid: ${widget.projectUuid.substring(0, 8)}   _emailController ${_emailController.toString().substring(15, 21)} text: ${_emailController.text}");
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

  @override
  Widget build(BuildContext context) {
    print(
        "BILD projectUuid: ${widget.projectUuid.substring(0, 8)}   _emailController ${_emailController.toString().substring(15, 21)} text: ${_emailController.text}");

    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.title}: ${widget.projectUuid}'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'REPRODUCTION STEPS:\n   1) Run: flutter build web\n   2) Run: flutter run --verbose --release -d chrome > verbose_web_issue_example_output.txt\n   3) Inspect the page and go to the console tab\n   4) The app is built twice \n   5) Enter text into the email text field. While no text shows up, text is being added to the original _emailController.',
            ),
            SizedBox(
              width: 300,
              child: TextFormField(
                controller: _emailController,
                autofocus: true,
                focusNode: _emailFocus,
              ),
            ),
            const SizedBox(height: 20),
            RawKeyboardListener(
              focusNode: _loginButtonFocus,
              onKey: (event) {
                if (event.isKeyPressed(LogicalKeyboardKey.tab)) {
                  FocusScope.of(context).requestFocus(_emailFocus);
                }
                _onFormSubmitted();
              },
              child: Container(
                color: Colors.grey[400],
                width: 200,
                child: TextButton(
                  onPressed: _onFormSubmitted,
                  child: const Text(
                    "Login",
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
