# Build Debug Report
Date: Tue Aug 25 08:00:53 UTC 2026

## Analyze
```
Analyzing quran-circles-app...                                  

  error • The name 'SettingsScreen' isn't a class. Try correcting the name to match an existing class • lib/core/router/app_router.dart:37:69 • creation_with_non_type
  error • The method 'read' isn't defined for the type 'Function'. Try correcting the name to the name of an existing method, or defining a method named 'read' • lib/core/router/app_router.dart:83:25 • undefined_method
  error • The method 'read' isn't defined for the type 'Function'. Try correcting the name to the name of an existing method, or defining a method named 'read' • lib/core/router/app_router.dart:87:12 • undefined_method
  error • The method 'read' isn't defined for the type 'Function'. Try correcting the name to the name of an existing method, or defining a method named 'read' • lib/core/router/app_router.dart:89:17 • undefined_method
  error • The method 'watch' isn't defined for the type 'Function'. Try correcting the name to the name of an existing method, or defining a method named 'watch' • lib/core/router/app_router.dart:100:26 • undefined_method
  error • The method 'read' isn't defined for the type 'Function'. Try correcting the name to the name of an existing method, or defining a method named 'read' • lib/core/router/app_router.dart:131:41 • undefined_method
  error • The method 'read' isn't defined for the type 'Function'. Try correcting the name to the name of an existing method, or defining a method named 'read' • lib/core/router/app_router.dart:135:26 • undefined_method
  error • The method 'read' isn't defined for the type 'Function'. Try correcting the name to the name of an existing method, or defining a method named 'read' • lib/core/router/app_router.dart:137:31 • undefined_method
   info • Use 'const' with the constructor to improve performance. Try adding the 'const' keyword to the constructor invocation • lib/core/services/backup_service.dart:153:12 • prefer_const_constructors
   info • Use 'const' with the constructor to improve performance. Try adding the 'const' keyword to the constructor invocation • lib/core/services/backup_service.dart:186:13 • prefer_const_constructors
  error • Undefined name 'await' in function body not marked with 'async'. Try correcting the name to one that is defined, defining the name, or adding 'async' to the enclosing function body • lib/features/settings/settings_screen.dart:1:7 • undefined_identifier_await
  error • Functions must have an explicit list of parameters. Try adding a parameter list • lib/features/settings/settings_screen.dart:1:13 • missing_function_parameters
  error • A function body must be provided. Try adding a function body • lib/features/settings/settings_screen.dart:1:16 • missing_function_body
  error • Expected a method, getter, setter or operator declaration. This appears to be incomplete code. Try removing it or completing it • lib/features/settings/settings_screen.dart:1:16 • expected_executable
  error • A function body must be provided. Try adding a function body • lib/features/settings/settings_screen.dart:1:42 • missing_function_body
  error • Expected a method, getter, setter or operator declaration. This appears to be incomplete code. Try removing it or completing it • lib/features/settings/settings_screen.dart:1:42 • expected_executable
  error • A function body must be provided. Try adding a function body • lib/features/settings/settings_screen.dart:1:49 • missing_function_body
  error • Undefined name 'await' in function body not marked with 'async'. Try correcting the name to one that is defined, defining the name, or adding 'async' to the enclosing function body • lib/features/settings/settings_screen.dart:2:7 • undefined_identifier_await
  error • Functions must have an explicit list of parameters. Try adding a parameter list • lib/features/settings/settings_screen.dart:2:13 • missing_function_parameters
  error • The name 'ref' is already defined. Try renaming one of the declarations • lib/features/settings/settings_screen.dart:2:13 • duplicate_definition
  error • A function body must be provided. Try adding a function body • lib/features/settings/settings_screen.dart:2:16 • missing_function_body
  error • Expected a method, getter, setter or operator declaration. This appears to be incomplete code. Try removing it or completing it • lib/features/settings/settings_screen.dart:2:16 • expected_executable
  error • The name 'read' is already defined. Try renaming one of the declarations • lib/features/settings/settings_screen.dart:2:17 • duplicate_definition
  error • A function body must be provided. Try adding a function body • lib/features/settings/settings_screen.dart:2:42 • missing_function_body
  error • Expected a method, getter, setter or operator declaration. This appears to be incomplete code. Try removing it or completing it • lib/features/settings/settings_screen.dart:2:42 • expected_executable
  error • A function body must be provided. Try adding a function body • lib/features/settings/settings_screen.dart:2:49 • missing_function_body
  error • A function body must be provided. Try adding a function body • lib/features/settings/settings_screen.dart:3:27 • missing_function_body
   info • Use 'const' with the constructor to improve performance. Try adding the 'const' keyword to the constructor invocation • test/backup_pdf_test.dart:30:36 • prefer_const_constructors
   info • Use 'const' with the constructor to improve performance. Try adding the 'const' keyword to the constructor invocation • test/backup_pdf_test.dart:112:40 • prefer_const_constructors
   info • Use 'const' with the constructor to improve performance. Try adding the 'const' keyword to the constructor invocation • test/pdf_visual_test.dart:45:38 • prefer_const_constructors

30 issues found. (ran in 16.7s)
```

## Build
```
Compiling lib/main.dart for the Web...                          
Wasm dry run failed:
Found incompatibilities with WebAssembly.

package:universal_html/src/_sdk/html.dart 32:1 - dart:html unsupported (0)
package:universal_html/src/_sdk_html_additions.dart 16:1 - dart:html unsupported (0)

'record-use' is now enabled by default; this flag is no longer required.
'record-use' is now enabled by default; this flag is no longer required.

Use --no-wasm-dry-run to disable these warnings.
Target dart2js failed: ProcessException: Process exited abnormally with exit code 1:
lib/features/settings/settings_screen.dart:1:13:
Error: A function declaration needs an explicit list of parameters.
      await ref.read(seedServiceProvider).wipe();
            ^^^
lib/features/settings/settings_screen.dart:1:16:
Error: Expected '{' before this.
      await ref.read(seedServiceProvider).wipe();
               ^
lib/features/settings/settings_screen.dart:1:16:
Error: Expected a declaration, but got '.'.
      await ref.read(seedServiceProvider).wipe();
               ^
lib/features/settings/settings_screen.dart:1:42:
Error: Expected '{' before this.
      await ref.read(seedServiceProvider).wipe();
                                         ^
lib/features/settings/settings_screen.dart:1:42:
Error: Expected a declaration, but got '.'.
      await ref.read(seedServiceProvider).wipe();
                                         ^
lib/features/settings/settings_screen.dart:1:49:
Error: Expected a function body or '=>'.
      await ref.read(seedServiceProvider).wipe();
                                                ^
lib/features/settings/settings_screen.dart:2:13:
Error: A function declaration needs an explicit list of parameters.
      await ref.read(seedServiceProvider).seed();
            ^^^
lib/features/settings/settings_screen.dart:2:16:
Error: Expected '{' before this.
      await ref.read(seedServiceProvider).seed();
               ^
lib/features/settings/settings_screen.dart:2:16:
Error: Expected a declaration, but got '.'.
      await ref.read(seedServiceProvider).seed();
               ^
lib/features/settings/settings_screen.dart:2:42:
Error: Expected '{' before this.
      await ref.read(seedServiceProvider).seed();
                                         ^
lib/features/settings/settings_screen.dart:2:42:
Error: Expected a declaration, but got '.'.
      await ref.read(seedServiceProvider).seed();
                                         ^
lib/features/settings/settings_screen.dart:2:49:
Error: Expected a function body or '=>'.
      await ref.read(seedServiceProvider).seed();
                                                ^
lib/features/settings/settings_screen.dart:3:27:
Error: Expected a function body or '=>'.
      bumpDataVersion(ref);
                          ^
lib/features/settings/settings_screen.dart:2:13:
Error: 'ref' is already declared in this scope.
      await ref.read(seedServiceProvider).seed();
            ^^^
lib/features/settings/settings_screen.dart:1:13:
Info: Previous declaration of 'ref'.
      await ref.read(seedServiceProvider).wipe();
            ^^^
lib/features/settings/settings_screen.dart:2:17:
Error: 'read' is already declared in this scope.
      await ref.read(seedServiceProvider).seed();
                ^^^^
lib/features/settings/settings_screen.dart:1:17:
Info: Previous declaration of 'read'.
      await ref.read(seedServiceProvider).wipe();
                ^^^^
lib/features/settings/settings_screen.dart:1:7:
Error: Type 'await' not found.
      await ref.read(seedServiceProvider).wipe();
      ^^^^^
lib/features/settings/settings_screen.dart:2:7:
Error: Type 'await' not found.
      await ref.read(seedServiceProvider).seed();
      ^^^^^
lib/core/router/app_router.dart:37:69:
Error: Couldn't find constructor 'SettingsScreen'.
          GoRoute(path: '/home/settings', builder: (_, __) => const SettingsScreen()),
                                                                    ^^^^^^^^^^^^^^
lib/core/router/app_router.dart:83:25:
Error: The method 'read' isn't defined for the type 'invalid-type Function()'.
    final session = ref.read(sessionProvider);
                        ^^^^
lib/core/router/app_router.dart:87:12:
Error: The method 'read' isn't defined for the type 'invalid-type Function()'.
          .read(backupUiServiceProvider)
           ^^^^
lib/core/router/app_router.dart:89:17:
Error: The method 'read' isn't defined for the type 'invalid-type Function()'.
      await ref.read(backupSettingsProvider.notifier).reload();
                ^^^^
lib/core/router/app_router.dart:100:26:
Error: The method 'watch' isn't defined for the type 'invalid-type Function()'.
    final settings = ref.watch(backupSettingsProvider);
                         ^^^^^
lib/core/router/app_router.dart:131:41:
Error: The method 'read' isn't defined for the type 'invalid-type Function()'.
                    final session = ref.read(sessionProvider);
                                        ^^^^
lib/core/router/app_router.dart:135:26:
Error: The method 'read' isn't defined for the type 'invalid-type Function()'.
                        .read(backupUiServiceProvider)
                         ^^^^
lib/core/router/app_router.dart:137:31:
Error: The method 'read' isn't defined for the type 'invalid-type Function()'.
                    await ref.read(backupSettingsProvider.notifier).reload();
                              ^^^^
Error: Compilation failed.
  Command: /opt/hostedtoolcache/flutter/stable-3.47.1-x64/flutter/bin/cache/dart-sdk/bin/dart compile js --platform-binaries=/opt/hostedtoolcache/flutter/stable-3.47.1-x64/flutter/bin/cache/flutter_web_sdk/kernel --invoker=flutter_tool -Ddart.vm.product=true -DFLUTTER_BUILD_NAME=1.0.0 -DFLUTTER_BUILD_NUMBER=1 -DFLUTTER_VERSION=3.47.1 -DFLUTTER_CHANNEL=stable -DFLUTTER_GIT_URL=https://github.com/flutter/flutter.git -DFLUTTER_FRAMEWORK_REVISION=6655482ec0 -DFLUTTER_ENGINE_REVISION=5d53178869 -DFLUTTER_DART_VERSION=3.13.1 -DFLUTTER_WEB_USE_SKIA=true -DFLUTTER_WEB_USE_SKWASM=false -DFLUTTER_WEB_CANVASKIT_URL=https://www.gstatic.com/flutter-canvaskit/5d531788691ec3404cac0cee66ead4007b177363/ --write-resources --enable-experiment=record-use --native-null-assertions --no-source-maps -O4 --minify -o /home/runner/work/quran-circles-app/quran-circles-app/.dart_tool/flutter_build/78ba38472f7aaf7865c44448a45bb4c1/app.dill --packages=/home/runner/work/quran-circles-app/quran-circles-app/.dart_tool/package_config.json --cfe-only /home/runner/work/quran-circles-app/quran-circles-app/.dart_tool/flutter_build/78ba38472f7aaf7865c44448a45bb4c1/main.dart
#0      RunResult.throwException (package:flutter_tools/src/base/process.dart:153:5)
#1      _DefaultProcessUtils.run (package:flutter_tools/src/base/process.dart:379:19)
<asynchronous suspension>
#2      Dart2JSTarget.build (package:flutter_tools/src/build_system/targets/web.dart:225:5)
<asynchronous suspension>
#3      _BuildInstance._invokeInternal (package:flutter_tools/src/build_system/build_system.dart:937:9)
<asynchronous suspension>
#4      Future.wait.<anonymous closure> (dart:async/future.dart:567:21)
<asynchronous suspension>
#5      _BuildInstance.invokeTarget (package:flutter_tools/src/build_system/build_system.dart:875:32)
<asynchronous suspension>
#6      Future.wait.<anonymous closure> (dart:async/future.dart:567:21)
<asynchronous suspension>
#7      _BuildInstance.invokeTarget (package:flutter_tools/src/build_system/build_system.dart:875:32)
<asynchronous suspension>
#8      Future.wait.<anonymous closure> (dart:async/future.dart:567:21)
<asynchronous suspension>
#9      _BuildInstance.invokeTarget (package:flutter_tools/src/build_system/build_system.dart:875:32)
<asynchronous suspension>
#10     FlutterBuildSystem.build (package:flutter_tools/src/build_system/build_system.dart:684:16)
<asynchronous suspension>
#11     WebBuilder.buildWeb (package:flutter_tools/src/web/compile.dart:107:34)
<asynchronous suspension>
#12     BuildWebCommand.runCommand (package:flutter_tools/src/commands/build_web.dart:293:5)
<asynchronous suspension>
#13     FlutterCommand.run.<anonymous closure> (package:flutter_tools/src/runner/flutter_command.dart:1663:27)
<asynchronous suspension>
#14     AppContext.run.<anonymous closure> (package:flutter_tools/src/base/context.dart:154:19)
<asynchronous suspension>
#15     CommandRunner.runCommand (package:args/command_runner.dart:212:13)
<asynchronous suspension>
#16     FlutterCommandRunner.runCommand.<anonymous closure> (package:flutter_tools/src/runner/flutter_command_runner.dart:496:9)
<asynchronous suspension>
#17     AppContext.run.<anonymous closure> (package:flutter_tools/src/base/context.dart:154:19)
<asynchronous suspension>
#18     FlutterCommandRunner.runCommand (package:flutter_tools/src/runner/flutter_command_runner.dart:431:5)
<asynchronous suspension>
#19     FlutterCommandRunner.run.<anonymous closure> (package:flutter_tools/src/runner/flutter_command_runner.dart:307:33)
<asynchronous suspension>
#20     run.<anonymous closure>.<anonymous closure> (package:flutter_tools/runner.dart:104:11)
<asynchronous suspension>
#21     AppContext.run.<anonymous closure> (package:flutter_tools/src/base/context.dart:154:19)
<asynchronous suspension>
#22     main (package:flutter_tools/executable.dart:103:3)
<asynchronous suspension>

Compiling lib/main.dart for the Web...                             54.4s
Error: Failed to compile application for the Web.
```
