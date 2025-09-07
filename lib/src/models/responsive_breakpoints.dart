import 'package:flutter/foundation.dart'
    show Diagnosticable, DiagnosticPropertiesBuilder, DoubleProperty;

/// Configuration class that defines breakpoints for different device types.
class ResponsiveBreakpoints with Diagnosticable {
  /// Default constructor with predefined breakpoints.
  const ResponsiveBreakpoints({
    this.mobileMaxWidth = 600,
    this.smallTabletMaxWidth = 768,
    this.mediumTabletMaxWidth = 1024,
    this.largeTabletMaxWidth = 1366,
    this.watchMaxWidth = 300,
    this.watchMaxHeight = 400,
  });

  const ResponsiveBreakpoints.defaults()
    : mobileMaxWidth = 600,
      smallTabletMaxWidth = 768,
      mediumTabletMaxWidth = 1024,
      largeTabletMaxWidth = 1366,
      watchMaxWidth = 300,
      watchMaxHeight = 400;

  /// Maximum width for mobile devices (inclusive).
  final double mobileMaxWidth;

  /// Maximum width for small tablet devices (inclusive).
  final double smallTabletMaxWidth;

  /// Maximum width for medium tablet devices (inclusive).
  final double mediumTabletMaxWidth;

  /// Maximum width for large tablet devices (inclusive).
  final double largeTabletMaxWidth;

  /// Maximum width for watch devices (inclusive).
  final double watchMaxWidth;

  /// Maximum height for watch devices (inclusive).
  final double watchMaxHeight;

  /// Creates a copy of this breakpoints configuration with optional overrides.
  ResponsiveBreakpoints copyWith({
    double? mobileMaxWidth,
    double? smallTabletMaxWidth,
    double? mediumTabletMaxWidth,
    double? largeTabletMaxWidth,
    double? watchMaxWidth,
    double? watchMaxHeight,
  }) {
    return ResponsiveBreakpoints(
      mobileMaxWidth: mobileMaxWidth ?? this.mobileMaxWidth,
      smallTabletMaxWidth: smallTabletMaxWidth ?? this.smallTabletMaxWidth,
      mediumTabletMaxWidth: mediumTabletMaxWidth ?? this.mediumTabletMaxWidth,
      largeTabletMaxWidth: largeTabletMaxWidth ?? this.largeTabletMaxWidth,
      watchMaxWidth: watchMaxWidth ?? this.watchMaxWidth,
      watchMaxHeight: watchMaxHeight ?? this.watchMaxHeight,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ResponsiveBreakpoints &&
          runtimeType == other.runtimeType &&
          mobileMaxWidth == other.mobileMaxWidth &&
          smallTabletMaxWidth == other.smallTabletMaxWidth &&
          mediumTabletMaxWidth == other.mediumTabletMaxWidth &&
          largeTabletMaxWidth == other.largeTabletMaxWidth &&
          watchMaxWidth == other.watchMaxWidth &&
          watchMaxHeight == other.watchMaxHeight;

  @override
  int get hashCode => Object.hashAll([
    mobileMaxWidth,
    smallTabletMaxWidth,
    mediumTabletMaxWidth,
    largeTabletMaxWidth,
    watchMaxWidth,
    watchMaxHeight,
  ]);

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    properties.add(DoubleProperty('mobileMaxWidth', mobileMaxWidth));
    properties.add(DoubleProperty('smallTabletMaxWidth', smallTabletMaxWidth));
    properties.add(
      DoubleProperty('mediumTabletMaxWidth', mediumTabletMaxWidth),
    );
    properties.add(DoubleProperty('largeTabletMaxWidth', largeTabletMaxWidth));
    properties.add(DoubleProperty('watchMaxWidth', watchMaxWidth));
    properties.add(DoubleProperty('watchMaxHeight', watchMaxHeight));
    super.debugFillProperties(properties);
  }
}
