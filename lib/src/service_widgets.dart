import 'package:flutter/widgets.dart';
import 'package:service_container/service_container.dart';

/// Share the [IServiceProvider] for child widgets.
class Services extends InheritedWidget {
  /// The [IServiceProvider], it can be a root [IServiceProvider] or a scoped [IServiceProvider].
  final IServiceProvider provider;

  /// Create [Services] inherited widget.
  const Services({
    super.key,
    required this.provider,
    required super.child,
  });

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) => false;

  /// Document on the [of] method.
  static IServiceProvider? maybeOf(BuildContext context) => context.getInheritedWidgetOfExactType<Services>()?.provider;

  /// Get the service provider in the parent widget tree that holds by the first [Services]
  static IServiceProvider of(BuildContext context) {
    final p = maybeOf(context);
    assert(p != null, "No $IServiceProvider found in context, please wrap the current widget with $Services widget.");
    return p!;
  }
}

/// Provide a root provider for the [child] widget.
class ServicesRoot extends StatefulWidget {
  /// The root [ServiceProvider], if `null` a [ServiceProvider] will be created.
  final ServiceProvider? _root;
  final bool? _printDebugLogs;

  /// Child widget
  final Widget child;

  /// Create a root provider for the [child] widget.
  /// The root provider is created by this widget, it will be disposed by this widget when this widget removed from widget tree.
  ///
  /// - [printDebugLogs] When `ture` print debug logs in debug-mode.
  /// if you only want to enable service container debug logging please call [ServiceContainerLogging.enableDebugLogging]
  /// before service container is created and set this argument to `false`.
  /// To prevent duplicate log outputs, see [ServiceContainerLogging]
  const ServicesRoot({
    Key? key,
    bool printDebugLogs = false,
    required Widget child,
  }) : this._(
          key: key,
          root: null,
          printDebugLogs: printDebugLogs,
          child: child,
        );

  /// From an exists root.
  ///
  /// - [root] The root provider, it will not be disposed by this widget.
  const ServicesRoot.from({
    Key? key,
    required ServiceProvider root,
    required Widget child,
  }) : this._(
          key: key,
          root: root,
          child: child,
        );

  const ServicesRoot._({
    super.key,
    required ServiceProvider? root,
    bool? printDebugLogs,
    required this.child,
  })  : _root = root,
        _printDebugLogs = printDebugLogs;

  @override
  State<ServicesRoot> createState() => _ServicesRootState();
}

class _ServicesRootState extends State<ServicesRoot> {
  late final ServiceProvider root;
  @override
  void initState() {
    root = widget._root ?? ServiceProvider(printDebugLogs: widget._printDebugLogs ?? false);
    super.initState();
  }

  @override
  void dispose() {
    if (widget._root == null) {
      // If the ServiceProvider created by this widget itself, we need to dispose it.
      root.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Services(provider: root, child: widget.child);
  }
}

/// Provide a scope for the [child] widget.
///
/// The [IServiceScope] created by this widget will dispose when this widget is disposed.
///
/// In the [child] widget, use [Services.of] to get the [IServiceProvider] for the corresponding scope.
class ServicesScope extends StatefulWidget {
  /// The factory to create a scope.
  final IServiceScopeFactory factory;

  /// Child widget
  final Widget child;

  /// Provide a scope for the [child] widgets.
  ///
  /// The [IServiceScope] created by this widget will dispose when this widget is disposed.
  const ServicesScope({super.key, required this.factory, required this.child});

  @override
  State<ServicesScope> createState() => _ServicesScopeState();
}

class _ServicesScopeState extends State<ServicesScope> {
  late final IServiceScope scope;

  @override
  void initState() {
    scope = widget.factory.createScope();
    super.initState();
  }

  @override
  void dispose() {
    scope.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Services(provider: scope.provider, child: widget.child);
}

/// A widget builder
///
/// - The first parameter is the [BuildContext]
/// - The second parameter is the [IServiceProvider] that holds by the first [ServiceInheritedWidget] in ancestor widget,
/// it may be the root [IServiceProvider] or not.
typedef ProviderWidgetBuilder = Widget Function(BuildContext context, IServiceProvider p);

/// A widget that consumes services
final class ServiceConsumer extends StatefulWidget {
  /// Child widget builder with [IServiceProvider]
  final ProviderWidgetBuilder builder;

  /// Create a service consumer widget
  ///
  /// - [key] The widget key.
  /// - [builder] The widget builder.
  const ServiceConsumer({super.key, required this.builder});

  @override
  State<ServiceConsumer> createState() => _ServiceConsumerState();
}

class _ServiceConsumerState extends State<ServiceConsumer> {
  late final IServiceProvider provider;

  @override
  void initState() {
    provider = Services.of(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) => widget.builder(context, provider);
}
