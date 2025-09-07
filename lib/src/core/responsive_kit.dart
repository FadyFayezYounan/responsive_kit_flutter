import 'package:flutter/widgets.dart';

import '../models/models.exports.dart';

class ResponsiveKit extends StatelessWidget {
  const ResponsiveKit({
    super.key,
    this.data = const ResponsiveBreakpoints(),
    required this.child,
  });

  /// The theme data to use for descendant widgets.
  final ResponsiveBreakpoints data;

  /// The widget below this widget in the tree.
  final Widget child;

  static ResponsiveData of(BuildContext context) {
    return maybeOf(context) ?? defaultsOf(context);
  }

  static ResponsiveData? maybeOf(BuildContext context) {
    final _InheritedResponsiveKit? inheritedTheme = context
        .dependOnInheritedWidgetOfExactType<_InheritedResponsiveKit>();
    if (inheritedTheme == null) {
      return null;
    }
    return ResponsiveDataDefaults.withBreakpoints(
      context,
      inheritedTheme.kit.data,
    );
  }

  static ResponsiveData defaultsOf(BuildContext context) {
    return ResponsiveDataDefaults(context);
  }

  static DeviceType deviceTypeOf(BuildContext context) {
    final data = of(context);
    return data.deviceType;
  }

  @override
  Widget build(BuildContext context) {
    return _InheritedResponsiveKit(kit: this, child: child);
  }
}

/// An inherited widget that defines the configuration for [ResponsiveKit] widgets.
final class _InheritedResponsiveKit extends InheritedTheme {
  /// Creates an [_InheritedResponsiveKit].
  ///
  /// The [kit] and [child] arguments must not be null.
  const _InheritedResponsiveKit({required this.kit, required super.child});

  /// The theme data provided by this inherited widget.
  final ResponsiveKit kit;

  @override
  bool updateShouldNotify(covariant _InheritedResponsiveKit oldWidget) =>
      kit.data != oldWidget.kit.data;

  @override
  Widget wrap(BuildContext context, Widget child) {
    return ResponsiveKit(data: kit.data, child: child);
  }
}
