import 'dart:ui' show Size;

import 'package:flutter/foundation.dart'
    show Diagnosticable, DiagnosticPropertiesBuilder, DiagnosticsProperty;
import 'package:flutter/widgets.dart' show Orientation;

import 'device_type.dart';
import 'responsive_breakpoints.dart';

class ResponsiveData with Diagnosticable {
  ResponsiveData({
    this.deviceType = const DeviceType.mobile(),
    this.screenSize = const Size(0, 0),
    this.breakpoints = const ResponsiveBreakpoints.defaults(),
  });

  /// The detected device type.
  final DeviceType deviceType;

  /// The current screen size.
  final Size screenSize;

  /// The breakpoints configuration used for detection.
  final ResponsiveBreakpoints breakpoints;

  Orientation get orientation {
    return screenSize.width > screenSize.height
        ? Orientation.landscape
        : Orientation.portrait;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ResponsiveData &&
        other.deviceType == deviceType &&
        other.screenSize == screenSize &&
        other.breakpoints == breakpoints;
  }

  @override
  int get hashCode => Object.hashAll([deviceType, screenSize, breakpoints]);

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    properties.add(DiagnosticsProperty<DeviceType>('deviceType', deviceType));
    properties.add(DiagnosticsProperty<Size>('screenSize', screenSize));
    properties.add(
      DiagnosticsProperty<ResponsiveBreakpoints>('breakpoints', breakpoints),
    );
    super.debugFillProperties(properties);
  }
}
