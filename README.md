# web_issue_example

A buggy Flutter project that uses Firebase Messaging. The user can't enter text into a textfield becaues the autofocus is still on the original _emailController.

## Reproduction Steps

1. Run: `flutter build web`
2. Run: `flutter run --verbose --release -d chrome > verbose_web_issue_example_output.txt`
3. Inspect the page and go to the console tab
4. The app is built twice
5. Enter text into the email text field. While no text shows up, text is being added to the original _emailController.

### Expected Output
```
New service worker available.			(index):86 

MAIN projectUuid: 810c44a3-7e45-4274-a51c-93b0ef998ce3

BILD projectUuid: 810c44a3   _emailController #a7890 text: 

LSTN projectUuid: 810c44a3   _emailController #a7890 text: 

Installed new service worker.			(index):84 

MAIN projectUuid: 0825003f-675c-4394-a6b9-9117ca76f76d

BILD projectUuid: 0825003f   _emailController #e92ec text: 

LSTN projectUuid: 0825003f   _emailController #e92ec text: 

LSTN projectUuid: 810c44a3   _emailController #a7890 text: m

LSTN projectUuid: 810c44a3   _emailController #a7890 text: my

LSTN projectUuid: 810c44a3   _emailController #a7890 text: mye

LSTN projectUuid: 810c44a3   _emailController #a7890 text: myem

LSTN projectUuid: 810c44a3   _emailController #a7890 text: myema

LSTN projectUuid: 810c44a3   _emailController #a7890 text: myemai

LSTN projectUuid: 810c44a3   _emailController #a7890 text: myemail
```

Submitted issue here: https://github.com/flutter/flutter/issues/90647
