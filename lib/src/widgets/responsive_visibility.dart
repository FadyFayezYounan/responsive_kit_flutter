import 'package:flutter/widgets.dart';

import '../core/responsive_kit.dart';

/// A widget that conditionally shows its child based on device type.
class ResponsiveVisibility extends StatelessWidget {
  /// Creates a responsive visibility widget.
  ///
  /// The [builder] will only be visible on all device types by default.
  const ResponsiveVisibility({
    super.key,
    required this.builder,
    this.replacementBuilder,
    this.showOnMobile = true,
    this.showOnSmallTablet = true,
    this.showOnMediumTablet = true,
    this.showOnLargeTablet = true,
    this.showOnDesktop = true,
    this.showOnWatch = true,
  });

  /// Creates a responsive visibility widget that shows the child only on mobile devices.
  const ResponsiveVisibility.mobile({
    super.key,
    required this.builder,
    this.replacementBuilder,
  }) : showOnMobile = true,
       showOnSmallTablet = false,
       showOnMediumTablet = false,
       showOnLargeTablet = false,
       showOnDesktop = false,
       showOnWatch = false;

  /// Creates a responsive visibility widget that shows the child only on small tablet devices.
  const ResponsiveVisibility.smallTablet({
    super.key,
    required this.builder,
    this.replacementBuilder,
  }) : showOnMobile = false,
       showOnSmallTablet = true,
       showOnMediumTablet = false,
       showOnLargeTablet = false,
       showOnDesktop = false,
       showOnWatch = false;

  /// Creates a responsive visibility widget that shows the child only on medium tablet devices.
  const ResponsiveVisibility.mediumTablet({
    super.key,
    required this.builder,
    this.replacementBuilder,
  }) : showOnMobile = false,
       showOnSmallTablet = false,
       showOnMediumTablet = true,
       showOnLargeTablet = false,
       showOnDesktop = false,
       showOnWatch = false;

  /// Creates a responsive visibility widget that shows the child only on large tablet devices.
  const ResponsiveVisibility.largeTablet({
    super.key,
    required this.builder,
    this.replacementBuilder,
  }) : showOnMobile = false,
       showOnSmallTablet = false,
       showOnMediumTablet = false,
       showOnLargeTablet = true,
       showOnDesktop = false,
       showOnWatch = false;

  /// Creates a responsive visibility widget that shows the child only on all tablet devices.
  const ResponsiveVisibility.tablet({
    super.key,
    required this.builder,
    this.replacementBuilder,
  }) : showOnMobile = false,
       showOnSmallTablet = true,
       showOnMediumTablet = true,
       showOnLargeTablet = true,
       showOnDesktop = false,
       showOnWatch = false;

  /// Creates a responsive visibility widget that shows the child only on desktop devices.
  const ResponsiveVisibility.desktop({
    super.key,
    required this.builder,
    this.replacementBuilder,
  }) : showOnMobile = false,
       showOnSmallTablet = false,
       showOnMediumTablet = false,
       showOnLargeTablet = false,
       showOnDesktop = true,
       showOnWatch = false;

  /// Creates a responsive visibility widget that shows the child only on watch devices.
  const ResponsiveVisibility.watch({
    super.key,
    required this.builder,
    this.replacementBuilder,
  }) : showOnMobile = false,
       showOnSmallTablet = false,
       showOnMediumTablet = false,
       showOnLargeTablet = false,
       showOnDesktop = false,
       showOnWatch = true;

  /// The child widget to show when visible.
  final WidgetBuilder builder;

  /// Whether to show on mobile devices.
  final bool showOnMobile;

  /// Whether to show on small tablet devices.
  final bool showOnSmallTablet;

  /// Whether to show on medium tablet devices.
  final bool showOnMediumTablet;

  /// Whether to show on large tablet devices.
  final bool showOnLargeTablet;

  /// Whether to show on desktop devices.
  final bool showOnDesktop;

  /// Whether to show on watch devices.
  final bool showOnWatch;

  /// The widget to show when the child is not visible.
  /// If null, an empty [SizedBox] will be shown.
  final WidgetBuilder? replacementBuilder;

  @override
  Widget build(BuildContext context) {
    final responsive = ResponsiveKit.of(context);

    // Use pattern matching with the sealed class
    final isVisible = responsive.deviceType.when(
      mobile: () => showOnMobile,
      smallTablet: () => showOnSmallTablet,
      mediumTablet: () => showOnMediumTablet,
      largeTablet: () => showOnLargeTablet,
      desktop: () => showOnDesktop,
      watch: () => showOnWatch,
    );

    if (isVisible) {
      return builder(context);
    }

    return replacementBuilder?.call(context) ?? const SizedBox.shrink();
  }
}
