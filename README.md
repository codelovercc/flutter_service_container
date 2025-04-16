<!--
This README describes the package. If you publish this package to pub.dev,
this README's contents appear on the landing page for your package.

For information about how to write a good package README, see the guide for
[writing package pages](https://dart.dev/tools/pub/writing-package-pages).

For general information about developing packages, see the Dart guide for
[creating packages](https://dart.dev/guides/libraries/create-packages)
and the Flutter guide for
[developing packages and plugins](https://flutter.dev/to/develop-packages).
-->

# flutter_service_container

[![pub package](https://img.shields.io/pub/v/flutter_service_container?logo=dart&logoColor=00b9fc)](https://pub.dev/packages/flutter_service_container)
[![CI](https://img.shields.io/github/actions/workflow/status/codelovercc/flutter_service_container/flutter.yml?branch=main&logo=github-actions&logoColor=white)](https://github.com/codelovercc/flutter_service_container/actions)
[![Last Commits](https://img.shields.io/github/last-commit/codelovercc/flutter_service_container?logo=git&logoColor=white)](https://github.com/codelovercc/flutter_service_container/commits/main)
[![Pull Requests](https://img.shields.io/github/issues-pr/codelovercc/flutter_service_container?logo=github&logoColor=white)](https://github.com/codelovercc/flutter_service_container/pulls)
[![Code size](https://img.shields.io/github/languages/code-size/codelovercc/flutter_service_container?logo=github&logoColor=white)](https://github.com/codelovercc/flutter_service_container)
[![License](https://img.shields.io/github/license/codelovercc/flutter_service_container?logo=open-source-initiative&logoColor=green)](https://github.com/codelovercc/flutter_service_container/blob/main/LICENSE)

Useful widgets for [service_container](https://pub.dev/packages/service_container) package.

## Features

Widgets:

1. `ServicesRoot` provide a root service provider for its child.
2. `ServicesScope` provide a scope service provider for its child.
3. `Services` inherited widget shared service provider for its child.
4. `ServiceConsumer` consumes services.
5. `DeveloperLogPrinter` forwards logs to the dart:developer log() API.

Get `IServiceProvider` instance:

1. `Services.of(context)`  
   Get the `IServiceProvider` instance from the nearest `Services` inherited widget. Notes
   that `ServicesRoot` and `ServicesScope` will create `Services` inherited widget.
2. `ServiceConsumer(builder: (context, provider){})`  
   The `IServiceProvider` instance from the nearest `Services` inherited widget will pass into the
   `provider` parameter of the `builder`.
3. Routes
   If you want to get the `IServiceProvider` that created or provided by other route, use the
   `Services` inherited widget to wrap the widgets of the new route child widget.

## Getting started

Install

```shell
flutter pub add flutter_service_container
```

## Usage

Here's a short example. For a full example, check out [example](example).

```dart

ServiceDescriptor<Logger> exampleLogger = ServiceDescriptor.singleton((p) => Logger("Example"));

void main() {
  useDeveloperLogPrinter();

  /// Use ServicesRoot to provide a root service provider for the app.
  runApp(
    ServicesRoot(
      printDebugLogs: true,
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final logger = Services.of(context).getService(exampleLogger);
    logger.info("$MyApp is building");
    return MaterialApp(
      title: 'Flutter service Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: MyHomePage(title: "Flutter service example"),
    );
  }
}
```

## Logging

Use [logging](https://pub.dev/packages/logging) package to logging.  
`useDeveloperLogPrinter()` method will override the default log printer that defined
in [service_container](https://pub.dev/packages/service_container) package and
use `DeveloperLogPrinter`. `DeveloperLogPrinter` forwards logs to the dart:developer log() API.
