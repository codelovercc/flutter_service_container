import 'package:flutter/material.dart';
import 'package:flutter_service_container/flutter_service_container.dart';
import 'package:service_container/service_container.dart';

import 'src/services/services.dart';

void main() {
  containerConfigure.useDeveloperLogPrinter();
  runApp(
    ServicesRoot(
      printDebugLogs: true,
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'Flutter service Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: MyHomePage(title: "Flutter service example"),
      );
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late final String greetingMsg;
  late final String greetingMsg2;

  @override
  void initState() {
    final provider = Services.of(context);
    final helloService = provider.getService($singletonHelloService);
    final transientHelloService = provider.getService($transientHelloService);
    greetingMsg = helloService.greeting("Singleton");
    greetingMsg2 = transientHelloService.greeting("Transient");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(greetingMsg),
            Text(greetingMsg2),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => ServicesScope(
                      factory: Services.of(context),
                      child: const ScopeFeatureWidget(),
                    ),
                  ),
                );
              },
              child: Text("Scoped Feature"),
            ),
          ],
        ),
      ),
    );
  }
}

class ScopeFeatureWidget extends StatelessWidget {
  const ScopeFeatureWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final serviceProvider = Services.of(context);
    final service1 = serviceProvider.getService($scopeHelloService);
    final transientHelloService = serviceProvider.getService($transientHelloService);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text("$ScopeFeatureWidget"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(service1.greeting("Scope")),
            Text(transientHelloService.greeting("Transient")),
            ServiceConsumer(
              builder: (context, p) {
                final service2 = p.getService($scopeHelloService);
                assert(identical(service1, service2),
                    "ServiceConsumer in ScopedServices widget should use the same IServiceProvider as ScopedServices");
                return Text(service2.greeting("Consumer"));
              },
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return Services(
                        provider: serviceProvider,
                        child: RouteAndScopedServicesWidget(),
                      );
                    },
                  ),
                );
              },
              child: Text("Same scope in new route"),
            ),
          ],
        ),
      ),
    );
  }
}

class RouteAndScopedServicesWidget extends StatelessWidget {
  const RouteAndScopedServicesWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final p = Services.of(context);
    final service = p.getService($scopeHelloService);
    return Scaffold(
      appBar: AppBar(
        title: Text("Scoped services in new route"),
      ),
      body: Center(
        child: Text(service.greeting("New Route")),
      ),
    );
  }
}
