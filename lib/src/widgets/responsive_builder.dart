import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../core/responsive_kit.dart';
import '../models/models.exports.dart';

class ResponsiveBuilder extends StatelessWidget {
  const ResponsiveBuilder({
    super.key,
    this.mobile,
    this.smallTablet,
    this.mediumTablet,
    this.largeTablet,
    this.tablet,
    this.desktop,
    this.watch,
    this.fallback,
  });

  final WidgetBuilder? mobile;
  final WidgetBuilder? smallTablet;
  final WidgetBuilder? mediumTablet;
  final WidgetBuilder? largeTablet;

  /// Fallback builder for all tablet types if specific tablet builders are not provided
  final WidgetBuilder? tablet;
  final WidgetBuilder? desktop;
  final WidgetBuilder? watch;
  final WidgetBuilder? fallback;

  @override
  Widget build(BuildContext context) {
    final responsive = ResponsiveKit.of(context);
    return switch (responsive.deviceType) {
          Mobile() => mobile?.call(context),
          SmallTablet() => smallTablet?.call(context) ?? tablet?.call(context),
          MediumTablet() =>
            mediumTablet?.call(context) ?? tablet?.call(context),
          LargeTablet() => largeTablet?.call(context) ?? tablet?.call(context),
          Desktop() => desktop?.call(context),
          Watch() => watch?.call(context),
        } ??
        fallback?.call(context) ??
        const SizedBox.shrink();
  }
}
