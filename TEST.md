All flows for CLI test

- export DART_ENV=development

Flow 1 : Help
dart pub run bin/dartpm.dart help [command]
dart pub run bin/dartpm.dart [command] -h
dart pub run bin/dartpm.dart [command] --help

dart pub run bin/dartpm.dart
dart pub run bin/dartpm.dart -h
dart pub run bin/dartpm.dart login -h
dart pub run bin/dartpm.dart logout -h
dart pub run bin/dartpm.dart doctor -h
dart pub run bin/dartpm.dart publish -h
dart pub run bin/dartpm.dart add -h

Flow 2: Login 
- dart pub run bin/dartpm.dart login 
This will open the browser and login and give access


Flow 3: Login with description
- dart pub run bin/dartpm.dart login --desc testdescart

Flow 4: Login with cli token
- dart pub run bin/dartpm.dart login --token <cli-token>

If user is already logged in then this will create new session but old session is not removed. 

Flow 5: Logout
If logged in 
- dart pub run bin/dartpm.dart logout   

If logged out
- dart pub run bin/dartpm.dart logout
throw error

Flow 6: Doctor
dart pub run bin/dartpm.dart doctor 