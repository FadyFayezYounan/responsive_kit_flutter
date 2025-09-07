# ResponsiveKit Flutter 📱💻

A powerful and type-safe Flutter package for building responsive UIs that adapt seamlessly across different device types and screen sizes.

[![pub package](https://img.shields.io/pub/v/responsive_kit_flutter.svg)](https://pub.dev/packages/responsive_kit_flutter)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

## Overview

ResponsiveKit Flutter provides a comprehensive solution for creating responsive applications with:

- **Type-safe device detection** using sealed classes and pattern matching
- **Customizable breakpoints** for different device categories
- **Declarative widgets** for responsive layouts and visibility
- **Inherited widget architecture** for efficient context propagation
- **Zero dependencies** beyond Flutter SDK

## Features

✨ **Device Type Detection**

- Mobile, Small/Medium/Large Tablet, Desktop, and Watch support
- Smart device categorization based on screen dimensions and aspect ratios
- Type-safe pattern matching with sealed classes

🎯 **Responsive Widgets**

- `ResponsiveBuilder` - Build different layouts for different devices
- `ResponsiveVisibility` - Show/hide widgets based on device type
- `ResponsiveKit` - Inherited widget for configuration and data access

🔧 **Customizable Breakpoints**

- Default Material Design inspired breakpoints
- Easy customization for your specific needs
- Watch device detection with aspect ratio analysis

📦 **Developer Experience**

- Comprehensive type safety with sealed classes
- Pattern matching for clean, readable code
- Rich debugging information with diagnostics

## Installation

Add this to your `pubspec.yaml`:

```yaml
dependencies:
  responsive_kit_flutter: ^0.0.1
```

Then run:

```bash
flutter pub get
```

## Quick Start

### 1. Wrap your Widget with ResponsiveKit

> [NOTE]
> You can still call `ResponsiveKit.of(context)` even if you don't wrap your widget tree with `ResponsiveKit`. When no ancestor `ResponsiveKit` is present, the API will provide sensible default breakpoints and device-type values. Wrap with `ResponsiveKit` only when you need custom breakpoints or configuration.

```dart
class MyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ResponsiveKit(
      data: ResponsiveBreakpoints(
        mobileMaxWidth: 600,        // Default: 600
        smallTabletMaxWidth: 768,   // Default: 768
        mediumTabletMaxWidth: 1024, // Default: 1024
        largeTabletMaxWidth: 1366,  // Default: 1366
        watchMaxWidth: 300,         // Default: 300
        watchMaxHeight: 300,        // Default: 300
      ), 
      child: Widget(),               
    );
  }
}
```

### 2. Build responsive layouts

```dart
class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ResponsiveBuilder(
        mobile: (context) => _buildMobileLayout(),
        tablet: (context) => _buildTabletLayout(),
        desktop: (context) => _buildDesktopLayout(),
        fallback: (context) => _buildMobileLayout(), // Default fallback
      ),
    );
  }

  Widget _buildMobileLayout() {
    return Column(
      children: [
        _buildHeader(),
        Expanded(child: _buildContent()),
      ],
    );
  }

  Widget _buildTabletLayout() {
    return Row(
      children: [
        SizedBox(width: 300, child: _buildSidebar()),
        Expanded(child: _buildContent()),
      ],
    );
  }

  Widget _buildDesktopLayout() {
    return Row(
      children: [
        SizedBox(width: 250, child: _buildSidebar()),
        Expanded(child: _buildContent()),
        SizedBox(width: 300, child: _buildRightPanel()),
      ],
    );
  }
}
```

### 3. Control widget visibility

```dart
class AdaptiveNavigation extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Show hamburger menu only on mobile
        ResponsiveVisibility.mobile(
          builder: (context) => IconButton(
            icon: Icon(Icons.menu),
            onPressed: () => _openDrawer(),
          ),
        ),
        
        // Show navigation tabs on tablets and larger
        ResponsiveVisibility(
          showOnMobile: false,
          builder: (context) => _buildNavigationTabs(),
        ),
        
        // Show breadcrumbs only on desktop
        ResponsiveVisibility.desktop(
          builder: (context) => _buildBreadcrumbs(),
        ),
      ],
    );
  }
}
```

## Advanced Usage

### Pattern Matching with Device Types

```dart
class AdaptiveContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final deviceType = ResponsiveKit.deviceTypeOf(context);
    
    return deviceType.when(
      mobile: () => _buildSingleColumn(),
      smallTablet: () => _buildTwoColumns(),
      mediumTablet: () => _buildTwoColumns(),
      largeTablet: () => _buildThreeColumns(),
      desktop: () => _buildFourColumns(),
      watch: () => _buildMinimal(),
    );
  }
}
```

### Accessing Responsive Data

```dart
class ResponsiveText extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final responsive = ResponsiveKit.of(context);
    
    return Text(
      'Hello World',
      style: TextStyle(
        fontSize: responsive.deviceType.isMobile ? 16 : 20,
        fontWeight: responsive.deviceType.isDesktop 
            ? FontWeight.bold 
            : FontWeight.normal,
      ),
    );
  }
}
```

### Custom Breakpoints

```dart
class CustomResponsiveApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ResponsiveKit(
      data: const ResponsiveBreakpoints(
        mobileMaxWidth: 480,        // Smaller mobile breakpoint
        smallTabletMaxWidth: 600,   // Custom small tablet range
        mediumTabletMaxWidth: 900,  // Custom medium tablet range
        largeTabletMaxWidth: 1200,  // Custom large tablet range
        watchMaxWidth: 250,         // Smaller watch screens
        watchMaxHeight: 300,
      ),
      child: MaterialApp(/* ... */),
    );
  }
}
```

### Device Categories and Properties

```dart
class AdaptiveFeatures extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final deviceType = ResponsiveKit.deviceTypeOf(context);
    
    return Column(
      children: [
        if (deviceType.isTablet) 
          _buildTabletSpecificFeature(),
          
        if (deviceType.isTabletOrLarger)
          _buildLargeScreenFeature(),
          
        if (deviceType.isHandheld)
          _buildTouchOptimizedControls(),
          
        if (deviceType.supportsHover)
          _buildHoverEffects(),
          
        if (deviceType.hasLimitedSpace)
          _buildCompactLayout(),
      ],
    );
  }
}
```

## Device Type Categories

| Device Type | Screen Width Range | Characteristics |
|-------------|-------------------|-----------------|
| **Watch** | ≤ 300px (square aspect ratio) | Minimal UI, essential info only |
| **Mobile** | ≤ 600px | Single column, touch-first |
| **Small Tablet** | 601px - 768px | Two columns possible |
| **Medium Tablet** | 769px - 1024px | Multi-column layouts |
| **Large Tablet** | 1025px - 1366px | Desktop-like features |
| **Desktop** | > 1366px | Full feature set, hover support |

## Device Properties

Each device type provides boolean properties for easy categorization:

```dart
final deviceType = ResponsiveKit.deviceTypeOf(context);

// Direct type checks
deviceType.isMobile        // true for Mobile devices
deviceType.isSmallTablet   // true for SmallTablet devices
deviceType.isDesktop       // true for Desktop devices

// Category checks
deviceType.isTablet        // true for any tablet size
deviceType.isTabletOrLarger // true for tablets and desktop
deviceType.isMobileOrTablet // true for mobile and tablets
deviceType.isHandheld      // true for mobile, tablets, and watch
deviceType.isLargeScreen   // true for large tablets and desktop

// Capability checks
deviceType.hasLimitedSpace    // true for mobile and watch
deviceType.supportsHover      // true for desktop
deviceType.prefersTouchInput  // true for mobile, tablets, and watch
```

## Best Practices

### 1. **Design Mobile-First**

Start with mobile layouts and progressively enhance for larger screens.

```dart
ResponsiveBuilder(
  mobile: (context) => _mobileLayout(),
  tablet: (context) => _enhancedTabletLayout(),
  desktop: (context) => _fullFeaturedDesktopLayout(),
)
```

### 2. **Use Semantic Breakpoints**

Choose breakpoints based on your content, not specific devices.

### 3. **Optimize Performance**

ResponsiveKit uses InheritedWidget for efficient rebuilds.

### 4. **Test Across Devices**

Use Flutter's device preview or responsive design mode to test your layouts.

### 5. **Consider Accessibility**

Ensure touch targets are appropriately sized for different devices.

## API Reference

### ResponsiveKit

The main inherited widget that provides responsive data to descendants.

```dart
ResponsiveKit(
  data: ResponsiveBreakpoints(), // Optional custom breakpoints
  child: Widget,                 // Your app widget tree
)
```

### ResponsiveBuilder

Builds different widgets based on device type.

```dart
ResponsiveBuilder(
  mobile: (context) => Widget,        // Mobile-specific widget
  smallTablet: (context) => Widget,   // Small tablet widget
  mediumTablet: (context) => Widget,  // Medium tablet widget
  largeTablet: (context) => Widget,   // Large tablet widget
  tablet: (context) => Widget,        // Fallback for all tablets
  desktop: (context) => Widget,       // Desktop widget
  watch: (context) => Widget,         // Watch widget
  fallback: (context) => Widget,      // Default fallback
)
```

### ResponsiveVisibility

Controls widget visibility based on device type.

```dart
ResponsiveVisibility(
  showOnMobile: bool,       // Show on mobile (default: true)
  showOnSmallTablet: bool,  // Show on small tablet (default: true)
  showOnMediumTablet: bool, // Show on medium tablet (default: true)
  showOnLargeTablet: bool,  // Show on large tablet (default: true)
  showOnDesktop: bool,      // Show on desktop (default: true)
  showOnWatch: bool,        // Show on watch (default: true)
  builder: (context) => Widget,           // Widget to show
  replacementBuilder: (context) => Widget, // Widget when hidden
)
```

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Changelog

See [CHANGELOG.md](CHANGELOG.md) for a detailed list of changes and version history.

---

Made with ❤️ for the Flutter community
