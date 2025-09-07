import 'dart:ui' show Size;

import 'responsive_breakpoints.dart';

/// A sealed class representing different device types based on screen dimensions
/// and characteristics. Provides type-safe device detection with pattern matching
/// capabilities for responsive UI design.
sealed class DeviceType {
  const DeviceType();

  // Factory constructors for each device type
  const factory DeviceType.mobile() = Mobile;
  const factory DeviceType.smallTablet() = SmallTablet;
  const factory DeviceType.mediumTablet() = MediumTablet;
  const factory DeviceType.largeTablet() = LargeTablet;
  const factory DeviceType.desktop() = Desktop;
  const factory DeviceType.watch() = Watch;

  /// Creates a [DeviceType] from screen size and breakpoint configuration
  factory DeviceType.fromSize({
    required Size size,
    required ResponsiveBreakpoints breakpoints,
  }) {
    final width = size.width;
    final height = size.height;

    // Check for watch first (smallest screens with specific constraints)
    if (_isWatch(width, height, breakpoints)) {
      return const DeviceType.watch();
    }

    // Check for mobile
    if (width <= breakpoints.mobileMaxWidth) {
      return const DeviceType.mobile();
    }

    // Check for small tablet
    if (width <= breakpoints.smallTabletMaxWidth) {
      return const DeviceType.smallTablet();
    }

    // Check for medium tablet
    if (width <= breakpoints.mediumTabletMaxWidth) {
      return const DeviceType.mediumTablet();
    }

    // Check for large tablet
    if (width <= breakpoints.largeTabletMaxWidth) {
      return const DeviceType.largeTablet();
    }

    // Default to desktop for larger screens
    return const DeviceType.desktop();
  }

  /// Determines if the given dimensions represent a watch device
  static bool _isWatch(
    double width,
    double height,
    ResponsiveBreakpoints breakpoints,
  ) {
    // Watch detection: small screen with roughly square aspect ratio
    if (width <= breakpoints.watchMaxWidth &&
        height <= breakpoints.watchMaxHeight) {
      final aspectRatio = width / height;
      // Consider it a watch if aspect ratio is between 0.7 and 1.4 (roughly square)
      return aspectRatio >= 0.7 && aspectRatio <= 1.4;
    }
    return false;
  }

  // Abstract getters for device type checking
  bool get isMobile;
  bool get isSmallTablet;
  bool get isMediumTablet;
  bool get isLargeTablet;
  bool get isDesktop;
  bool get isWatch;

  // Computed abstract getters for device categories
  bool get isTablet;
  bool get isTabletOrLarger;
  bool get isMobileOrTablet;
  bool get isHandheld;
  bool get isLargeScreen;
  bool get hasLimitedSpace;
  bool get supportsHover;
  bool get prefersTouchInput;

  /// Pattern matching methods
  T when<T>({
    required T Function() mobile,
    required T Function() smallTablet,
    required T Function() mediumTablet,
    required T Function() largeTablet,
    required T Function() desktop,
    required T Function() watch,
  });

  T maybeWhen<T>({
    T Function()? mobile,
    T Function()? smallTablet,
    T Function()? mediumTablet,
    T Function()? largeTablet,
    T Function()? desktop,
    T Function()? watch,
    required T Function() orElse,
  });

  T? whenOrNull<T>({
    T Function()? mobile,
    T Function()? smallTablet,
    T Function()? mediumTablet,
    T Function()? largeTablet,
    T Function()? desktop,
    T Function()? watch,
  });

  /// Simplified pattern matching that groups tablets together
  T whenSimple<T>({
    required T Function() mobile,
    required T Function() tablet,
    required T Function() desktop,
    required T Function() watch,
  }) {
    return when(
      mobile: mobile,
      smallTablet: tablet,
      mediumTablet: tablet,
      largeTablet: tablet,
      desktop: desktop,
      watch: watch,
    );
  }

  T maybeWhenSimple<T>({
    T Function()? mobile,
    T Function()? tablet,
    T Function()? desktop,
    T Function()? watch,
    required T Function() orElse,
  }) {
    return maybeWhen(
      mobile: mobile,
      smallTablet: tablet,
      mediumTablet: tablet,
      largeTablet: tablet,
      desktop: desktop,
      watch: watch,
      orElse: orElse,
    );
  }

  T? whenSimpleOrNull<T>({
    T Function()? mobile,
    T Function()? tablet,
    T Function()? desktop,
    T Function()? watch,
  }) {
    return whenOrNull(
      mobile: mobile,
      smallTablet: tablet,
      mediumTablet: tablet,
      largeTablet: tablet,
      desktop: desktop,
      watch: watch,
    );
  }

  /// Map methods with instance access
  T map<T>({
    required T Function(Mobile) mobile,
    required T Function(SmallTablet) smallTablet,
    required T Function(MediumTablet) mediumTablet,
    required T Function(LargeTablet) largeTablet,
    required T Function(Desktop) desktop,
    required T Function(Watch) watch,
  });

  T maybeMap<T>({
    T Function(Mobile)? mobile,
    T Function(SmallTablet)? smallTablet,
    T Function(MediumTablet)? mediumTablet,
    T Function(LargeTablet)? largeTablet,
    T Function(Desktop)? desktop,
    T Function(Watch)? watch,
    required T Function(DeviceType) orElse,
  });

  T? mapOrNull<T>({
    T Function(Mobile)? mobile,
    T Function(SmallTablet)? smallTablet,
    T Function(MediumTablet)? mediumTablet,
    T Function(LargeTablet)? largeTablet,
    T Function(Desktop)? desktop,
    T Function(Watch)? watch,
  });

  /// Simplified map methods that group tablets together
  T mapSimple<T>({
    required T Function(Mobile) mobile,
    required T Function(DeviceType) tablet,
    required T Function(Desktop) desktop,
    required T Function(Watch) watch,
  }) {
    return map(
      mobile: mobile,
      smallTablet: tablet,
      mediumTablet: tablet,
      largeTablet: tablet,
      desktop: desktop,
      watch: watch,
    );
  }

  T maybeMapSimple<T>({
    T Function(Mobile)? mobile,
    T Function(DeviceType)? tablet,
    T Function(Desktop)? desktop,
    T Function(Watch)? watch,
    required T Function(DeviceType) orElse,
  }) {
    return maybeMap(
      mobile: mobile,
      smallTablet: tablet,
      mediumTablet: tablet,
      largeTablet: tablet,
      desktop: desktop,
      watch: watch,
      orElse: orElse,
    );
  }

  T? mapSimpleOrNull<T>({
    T Function(Mobile)? mobile,
    T Function(DeviceType)? tablet,
    T Function(Desktop)? desktop,
    T Function(Watch)? watch,
  }) {
    return mapOrNull(
      mobile: mobile,
      smallTablet: tablet,
      mediumTablet: tablet,
      largeTablet: tablet,
      desktop: desktop,
      watch: watch,
    );
  }

  /// Additional utility methods

  /// Returns true if this device typically supports keyboard input
  bool get hasPhysicalKeyboard => isDesktop;

  /// Returns true if this device has precise pointer input (mouse)
  bool get hasPrecisePointer => isDesktop;

  @override
  String toString() => 'DeviceType()';

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is DeviceType && other.runtimeType == runtimeType);
  }

  @override
  int get hashCode => runtimeType.hashCode;
}

// Concrete implementations

final class Mobile extends DeviceType {
  const Mobile();

  @override
  bool get isMobile => true;
  @override
  bool get isSmallTablet => false;
  @override
  bool get isMediumTablet => false;
  @override
  bool get isLargeTablet => false;
  @override
  bool get isDesktop => false;
  @override
  bool get isWatch => false;

  @override
  bool get isTablet => false;
  @override
  bool get isTabletOrLarger => false;
  @override
  bool get isMobileOrTablet => true;
  @override
  bool get isHandheld => true;
  @override
  bool get isLargeScreen => false;
  @override
  bool get hasLimitedSpace => true;
  @override
  bool get supportsHover => false;
  @override
  bool get prefersTouchInput => true;

  @override
  T when<T>({
    required T Function() mobile,
    required T Function() smallTablet,
    required T Function() mediumTablet,
    required T Function() largeTablet,
    required T Function() desktop,
    required T Function() watch,
  }) => mobile();

  @override
  T maybeWhen<T>({
    T Function()? mobile,
    T Function()? smallTablet,
    T Function()? mediumTablet,
    T Function()? largeTablet,
    T Function()? desktop,
    T Function()? watch,
    required T Function() orElse,
  }) => mobile?.call() ?? orElse();

  @override
  T? whenOrNull<T>({
    T Function()? mobile,
    T Function()? smallTablet,
    T Function()? mediumTablet,
    T Function()? largeTablet,
    T Function()? desktop,
    T Function()? watch,
  }) => mobile?.call();

  @override
  T map<T>({
    required T Function(Mobile) mobile,
    required T Function(SmallTablet) smallTablet,
    required T Function(MediumTablet) mediumTablet,
    required T Function(LargeTablet) largeTablet,
    required T Function(Desktop) desktop,
    required T Function(Watch) watch,
  }) => mobile(this);

  @override
  T maybeMap<T>({
    T Function(Mobile)? mobile,
    T Function(SmallTablet)? smallTablet,
    T Function(MediumTablet)? mediumTablet,
    T Function(LargeTablet)? largeTablet,
    T Function(Desktop)? desktop,
    T Function(Watch)? watch,
    required T Function(DeviceType) orElse,
  }) => mobile?.call(this) ?? orElse(this);

  @override
  T? mapOrNull<T>({
    T Function(Mobile)? mobile,
    T Function(SmallTablet)? smallTablet,
    T Function(MediumTablet)? mediumTablet,
    T Function(LargeTablet)? largeTablet,
    T Function(Desktop)? desktop,
    T Function(Watch)? watch,
  }) => mobile?.call(this);
}

final class SmallTablet extends DeviceType {
  const SmallTablet();

  @override
  bool get isMobile => false;
  @override
  bool get isSmallTablet => true;
  @override
  bool get isMediumTablet => false;
  @override
  bool get isLargeTablet => false;
  @override
  bool get isDesktop => false;
  @override
  bool get isWatch => false;

  @override
  bool get isTablet => true;
  @override
  bool get isTabletOrLarger => true;
  @override
  bool get isMobileOrTablet => true;
  @override
  bool get isHandheld => false;
  @override
  bool get isLargeScreen => false;
  @override
  bool get hasLimitedSpace => true;
  @override
  bool get supportsHover => false;
  @override
  bool get prefersTouchInput => true;

  @override
  T when<T>({
    required T Function() mobile,
    required T Function() smallTablet,
    required T Function() mediumTablet,
    required T Function() largeTablet,
    required T Function() desktop,
    required T Function() watch,
  }) => smallTablet();

  @override
  T maybeWhen<T>({
    T Function()? mobile,
    T Function()? smallTablet,
    T Function()? mediumTablet,
    T Function()? largeTablet,
    T Function()? desktop,
    T Function()? watch,
    required T Function() orElse,
  }) => smallTablet?.call() ?? orElse();

  @override
  T? whenOrNull<T>({
    T Function()? mobile,
    T Function()? smallTablet,
    T Function()? mediumTablet,
    T Function()? largeTablet,
    T Function()? desktop,
    T Function()? watch,
  }) => smallTablet?.call();

  @override
  T map<T>({
    required T Function(Mobile) mobile,
    required T Function(SmallTablet) smallTablet,
    required T Function(MediumTablet) mediumTablet,
    required T Function(LargeTablet) largeTablet,
    required T Function(Desktop) desktop,
    required T Function(Watch) watch,
  }) => smallTablet(this);

  @override
  T maybeMap<T>({
    T Function(Mobile)? mobile,
    T Function(SmallTablet)? smallTablet,
    T Function(MediumTablet)? mediumTablet,
    T Function(LargeTablet)? largeTablet,
    T Function(Desktop)? desktop,
    T Function(Watch)? watch,
    required T Function(DeviceType) orElse,
  }) => smallTablet?.call(this) ?? orElse(this);

  @override
  T? mapOrNull<T>({
    T Function(Mobile)? mobile,
    T Function(SmallTablet)? smallTablet,
    T Function(MediumTablet)? mediumTablet,
    T Function(LargeTablet)? largeTablet,
    T Function(Desktop)? desktop,
    T Function(Watch)? watch,
  }) => smallTablet?.call(this);
}

final class MediumTablet extends DeviceType {
  const MediumTablet();

  @override
  bool get isMobile => false;
  @override
  bool get isSmallTablet => false;
  @override
  bool get isMediumTablet => true;
  @override
  bool get isLargeTablet => false;
  @override
  bool get isDesktop => false;
  @override
  bool get isWatch => false;

  @override
  bool get isTablet => true;
  @override
  bool get isTabletOrLarger => true;
  @override
  bool get isMobileOrTablet => true;
  @override
  bool get isHandheld => false;
  @override
  bool get isLargeScreen => false;
  @override
  bool get hasLimitedSpace => false;
  @override
  bool get supportsHover => false;
  @override
  bool get prefersTouchInput => true;

  @override
  T when<T>({
    required T Function() mobile,
    required T Function() smallTablet,
    required T Function() mediumTablet,
    required T Function() largeTablet,
    required T Function() desktop,
    required T Function() watch,
  }) => mediumTablet();

  @override
  T maybeWhen<T>({
    T Function()? mobile,
    T Function()? smallTablet,
    T Function()? mediumTablet,
    T Function()? largeTablet,
    T Function()? desktop,
    T Function()? watch,
    required T Function() orElse,
  }) => mediumTablet?.call() ?? orElse();

  @override
  T? whenOrNull<T>({
    T Function()? mobile,
    T Function()? smallTablet,
    T Function()? mediumTablet,
    T Function()? largeTablet,
    T Function()? desktop,
    T Function()? watch,
  }) => mediumTablet?.call();

  @override
  T map<T>({
    required T Function(Mobile) mobile,
    required T Function(SmallTablet) smallTablet,
    required T Function(MediumTablet) mediumTablet,
    required T Function(LargeTablet) largeTablet,
    required T Function(Desktop) desktop,
    required T Function(Watch) watch,
  }) => mediumTablet(this);

  @override
  T maybeMap<T>({
    T Function(Mobile)? mobile,
    T Function(SmallTablet)? smallTablet,
    T Function(MediumTablet)? mediumTablet,
    T Function(LargeTablet)? largeTablet,
    T Function(Desktop)? desktop,
    T Function(Watch)? watch,
    required T Function(DeviceType) orElse,
  }) => mediumTablet?.call(this) ?? orElse(this);

  @override
  T? mapOrNull<T>({
    T Function(Mobile)? mobile,
    T Function(SmallTablet)? smallTablet,
    T Function(MediumTablet)? mediumTablet,
    T Function(LargeTablet)? largeTablet,
    T Function(Desktop)? desktop,
    T Function(Watch)? watch,
  }) => mediumTablet?.call(this);
}

final class LargeTablet extends DeviceType {
  const LargeTablet();

  @override
  bool get isMobile => false;
  @override
  bool get isSmallTablet => false;
  @override
  bool get isMediumTablet => false;
  @override
  bool get isLargeTablet => true;
  @override
  bool get isDesktop => false;
  @override
  bool get isWatch => false;

  @override
  bool get isTablet => true;
  @override
  bool get isTabletOrLarger => true;
  @override
  bool get isMobileOrTablet => true;
  @override
  bool get isHandheld => false;
  @override
  bool get isLargeScreen => true;
  @override
  bool get hasLimitedSpace => false;
  @override
  bool get supportsHover => false;
  @override
  bool get prefersTouchInput => true;

  @override
  T when<T>({
    required T Function() mobile,
    required T Function() smallTablet,
    required T Function() mediumTablet,
    required T Function() largeTablet,
    required T Function() desktop,
    required T Function() watch,
  }) => largeTablet();

  @override
  T maybeWhen<T>({
    T Function()? mobile,
    T Function()? smallTablet,
    T Function()? mediumTablet,
    T Function()? largeTablet,
    T Function()? desktop,
    T Function()? watch,
    required T Function() orElse,
  }) => largeTablet?.call() ?? orElse();

  @override
  T? whenOrNull<T>({
    T Function()? mobile,
    T Function()? smallTablet,
    T Function()? mediumTablet,
    T Function()? largeTablet,
    T Function()? desktop,
    T Function()? watch,
  }) => largeTablet?.call();

  @override
  T map<T>({
    required T Function(Mobile) mobile,
    required T Function(SmallTablet) smallTablet,
    required T Function(MediumTablet) mediumTablet,
    required T Function(LargeTablet) largeTablet,
    required T Function(Desktop) desktop,
    required T Function(Watch) watch,
  }) => largeTablet(this);

  @override
  T maybeMap<T>({
    T Function(Mobile)? mobile,
    T Function(SmallTablet)? smallTablet,
    T Function(MediumTablet)? mediumTablet,
    T Function(LargeTablet)? largeTablet,
    T Function(Desktop)? desktop,
    T Function(Watch)? watch,
    required T Function(DeviceType) orElse,
  }) => largeTablet?.call(this) ?? orElse(this);

  @override
  T? mapOrNull<T>({
    T Function(Mobile)? mobile,
    T Function(SmallTablet)? smallTablet,
    T Function(MediumTablet)? mediumTablet,
    T Function(LargeTablet)? largeTablet,
    T Function(Desktop)? desktop,
    T Function(Watch)? watch,
  }) => largeTablet?.call(this);
}

final class Desktop extends DeviceType {
  const Desktop();

  @override
  bool get isMobile => false;
  @override
  bool get isSmallTablet => false;
  @override
  bool get isMediumTablet => false;
  @override
  bool get isLargeTablet => false;
  @override
  bool get isDesktop => true;
  @override
  bool get isWatch => false;

  @override
  bool get isTablet => false;
  @override
  bool get isTabletOrLarger => true;
  @override
  bool get isMobileOrTablet => false;
  @override
  bool get isHandheld => false;
  @override
  bool get isLargeScreen => true;
  @override
  bool get hasLimitedSpace => false;
  @override
  bool get supportsHover => true;
  @override
  bool get prefersTouchInput => false;

  @override
  T when<T>({
    required T Function() mobile,
    required T Function() smallTablet,
    required T Function() mediumTablet,
    required T Function() largeTablet,
    required T Function() desktop,
    required T Function() watch,
  }) => desktop();

  @override
  T maybeWhen<T>({
    T Function()? mobile,
    T Function()? smallTablet,
    T Function()? mediumTablet,
    T Function()? largeTablet,
    T Function()? desktop,
    T Function()? watch,
    required T Function() orElse,
  }) => desktop?.call() ?? orElse();

  @override
  T? whenOrNull<T>({
    T Function()? mobile,
    T Function()? smallTablet,
    T Function()? mediumTablet,
    T Function()? largeTablet,
    T Function()? desktop,
    T Function()? watch,
  }) => desktop?.call();

  @override
  T map<T>({
    required T Function(Mobile) mobile,
    required T Function(SmallTablet) smallTablet,
    required T Function(MediumTablet) mediumTablet,
    required T Function(LargeTablet) largeTablet,
    required T Function(Desktop) desktop,
    required T Function(Watch) watch,
  }) => desktop(this);

  @override
  T maybeMap<T>({
    T Function(Mobile)? mobile,
    T Function(SmallTablet)? smallTablet,
    T Function(MediumTablet)? mediumTablet,
    T Function(LargeTablet)? largeTablet,
    T Function(Desktop)? desktop,
    T Function(Watch)? watch,
    required T Function(DeviceType) orElse,
  }) => desktop?.call(this) ?? orElse(this);

  @override
  T? mapOrNull<T>({
    T Function(Mobile)? mobile,
    T Function(SmallTablet)? smallTablet,
    T Function(MediumTablet)? mediumTablet,
    T Function(LargeTablet)? largeTablet,
    T Function(Desktop)? desktop,
    T Function(Watch)? watch,
  }) => desktop?.call(this);
}

final class Watch extends DeviceType {
  const Watch();

  @override
  bool get isMobile => false;
  @override
  bool get isSmallTablet => false;
  @override
  bool get isMediumTablet => false;
  @override
  bool get isLargeTablet => false;
  @override
  bool get isDesktop => false;
  @override
  bool get isWatch => true;

  @override
  bool get isTablet => false;
  @override
  bool get isTabletOrLarger => false;
  @override
  bool get isMobileOrTablet => false;
  @override
  bool get isHandheld => true;
  @override
  bool get isLargeScreen => false;
  @override
  bool get hasLimitedSpace => true;
  @override
  bool get supportsHover => false;
  @override
  bool get prefersTouchInput => true;

  @override
  T when<T>({
    required T Function() mobile,
    required T Function() smallTablet,
    required T Function() mediumTablet,
    required T Function() largeTablet,
    required T Function() desktop,
    required T Function() watch,
  }) => watch();

  @override
  T maybeWhen<T>({
    T Function()? mobile,
    T Function()? smallTablet,
    T Function()? mediumTablet,
    T Function()? largeTablet,
    T Function()? desktop,
    T Function()? watch,
    required T Function() orElse,
  }) => watch?.call() ?? orElse();

  @override
  T? whenOrNull<T>({
    T Function()? mobile,
    T Function()? smallTablet,
    T Function()? mediumTablet,
    T Function()? largeTablet,
    T Function()? desktop,
    T Function()? watch,
  }) => watch?.call();

  @override
  T map<T>({
    required T Function(Mobile) mobile,
    required T Function(SmallTablet) smallTablet,
    required T Function(MediumTablet) mediumTablet,
    required T Function(LargeTablet) largeTablet,
    required T Function(Desktop) desktop,
    required T Function(Watch) watch,
  }) => watch(this);

  @override
  T maybeMap<T>({
    T Function(Mobile)? mobile,
    T Function(SmallTablet)? smallTablet,
    T Function(MediumTablet)? mediumTablet,
    T Function(LargeTablet)? largeTablet,
    T Function(Desktop)? desktop,
    T Function(Watch)? watch,
    required T Function(DeviceType) orElse,
  }) => watch?.call(this) ?? orElse(this);

  @override
  T? mapOrNull<T>({
    T Function(Mobile)? mobile,
    T Function(SmallTablet)? smallTablet,
    T Function(MediumTablet)? mediumTablet,
    T Function(LargeTablet)? largeTablet,
    T Function(Desktop)? desktop,
    T Function(Watch)? watch,
  }) => watch?.call(this);
}
