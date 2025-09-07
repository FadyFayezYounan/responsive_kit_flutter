// Tests for ResponsiveKit Flutter Package
//
// This test suite covers:
// - ResponsiveBreakpoints: Default and custom breakpoint configurations
// - DeviceType: Device detection logic and pattern matching
// - ResponsiveKit: Inherited widget functionality and data propagation
// - ResponsiveBuilder: Responsive layout building with different device types
// - ResponsiveVisibility: Conditional widget visibility based on device types
// - Integration: Complex layouts and real-world usage scenarios

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:responsive_kit_flutter/responsive_kit_flutter.dart';

Widget buildResponsiveTestApp({
  required Widget child,
  Size? screenSize,
  ResponsiveBreakpoints? breakpoints,
}) {
  Widget app = ResponsiveKit(
    data: breakpoints ?? const ResponsiveBreakpoints(),
    child: MaterialApp(home: Scaffold(body: child)),
  );

  if (screenSize != null) {
    app = MediaQuery(
      data: MediaQueryData(size: screenSize),
      child: app,
    );
  }

  return app;
}

void main() {
  group('ResponsiveBreakpoints', () {
    test('should create default breakpoints', () {
      const breakpoints = ResponsiveBreakpoints();

      expect(breakpoints.mobileMaxWidth, 600);
      expect(breakpoints.smallTabletMaxWidth, 768);
      expect(breakpoints.mediumTabletMaxWidth, 1024);
      expect(breakpoints.largeTabletMaxWidth, 1366);
      expect(breakpoints.watchMaxWidth, 300);
      expect(breakpoints.watchMaxHeight, 400);
    });

    test('should create custom breakpoints', () {
      const breakpoints = ResponsiveBreakpoints(
        mobileMaxWidth: 480,
        smallTabletMaxWidth: 600,
        mediumTabletMaxWidth: 900,
        largeTabletMaxWidth: 1200,
        watchMaxWidth: 250,
        watchMaxHeight: 350,
      );

      expect(breakpoints.mobileMaxWidth, 480);
      expect(breakpoints.smallTabletMaxWidth, 600);
      expect(breakpoints.mediumTabletMaxWidth, 900);
      expect(breakpoints.largeTabletMaxWidth, 1200);
      expect(breakpoints.watchMaxWidth, 250);
      expect(breakpoints.watchMaxHeight, 350);
    });

    test('should create copy with overrides', () {
      const original = ResponsiveBreakpoints();
      final copy = original.copyWith(mobileMaxWidth: 500, watchMaxWidth: 280);

      expect(copy.mobileMaxWidth, 500);
      expect(copy.watchMaxWidth, 280);
      // Other values should remain the same
      expect(copy.smallTabletMaxWidth, 768);
      expect(copy.mediumTabletMaxWidth, 1024);
      expect(copy.largeTabletMaxWidth, 1366);
      expect(copy.watchMaxHeight, 400);
    });
  });

  group('DeviceType', () {
    const breakpoints = ResponsiveBreakpoints();

    test('should detect mobile device', () {
      final deviceType = DeviceType.fromSize(
        size: const Size(400, 800),
        breakpoints: breakpoints,
      );

      expect(deviceType, isA<Mobile>());
      expect(deviceType.isMobile, true);
      expect(deviceType.isTablet, false);
      expect(deviceType.isDesktop, false);
      expect(deviceType.isWatch, false);
      expect(deviceType.isHandheld, true);
      expect(deviceType.prefersTouchInput, true);
      expect(deviceType.supportsHover, false);
    });

    test('should detect small tablet device', () {
      final deviceType = DeviceType.fromSize(
        size: const Size(700, 1000),
        breakpoints: breakpoints,
      );

      expect(deviceType, isA<SmallTablet>());
      expect(deviceType.isMobile, false);
      expect(deviceType.isSmallTablet, true);
      expect(deviceType.isTablet, true);
      expect(deviceType.isTabletOrLarger, true);
      expect(deviceType.isMobileOrTablet, true);
      expect(
        deviceType.isHandheld,
        false,
      ); // Tablets are not considered handheld
    });

    test('should detect medium tablet device', () {
      final deviceType = DeviceType.fromSize(
        size: const Size(900, 1200),
        breakpoints: breakpoints,
      );

      expect(deviceType, isA<MediumTablet>());
      expect(deviceType.isMediumTablet, true);
      expect(deviceType.isTablet, true);
      expect(deviceType.isLargeScreen, false);
    });

    test('should detect large tablet device', () {
      final deviceType = DeviceType.fromSize(
        size: const Size(1300, 1600),
        breakpoints: breakpoints,
      );

      expect(deviceType, isA<LargeTablet>());
      expect(deviceType.isLargeTablet, true);
      expect(deviceType.isTablet, true);
      expect(deviceType.isLargeScreen, true);
    });

    test('should detect desktop device', () {
      final deviceType = DeviceType.fromSize(
        size: const Size(1920, 1080),
        breakpoints: breakpoints,
      );

      expect(deviceType, isA<Desktop>());
      expect(deviceType.isDesktop, true);
      expect(deviceType.isTablet, false);
      expect(deviceType.isLargeScreen, true);
      expect(deviceType.isHandheld, false);
      expect(deviceType.supportsHover, true);
      expect(deviceType.prefersTouchInput, false);
    });

    test('should detect watch device', () {
      final deviceType = DeviceType.fromSize(
        size: const Size(200, 240),
        breakpoints: breakpoints,
      );

      expect(deviceType, isA<Watch>());
      expect(deviceType.isWatch, true);
      expect(deviceType.isMobile, false);
      expect(deviceType.hasLimitedSpace, true);
      expect(deviceType.isHandheld, true);
    });

    test('should not detect watch with wrong aspect ratio', () {
      final deviceType = DeviceType.fromSize(
        size: const Size(250, 800), // Too tall for watch
        breakpoints: breakpoints,
      );

      expect(deviceType, isA<Mobile>());
      expect(deviceType.isWatch, false);
    });

    test('should use pattern matching with when', () {
      final mobile = DeviceType.fromSize(
        size: const Size(400, 800),
        breakpoints: breakpoints,
      );

      final result = mobile.when(
        mobile: () => 'mobile',
        smallTablet: () => 'small-tablet',
        mediumTablet: () => 'medium-tablet',
        largeTablet: () => 'large-tablet',
        desktop: () => 'desktop',
        watch: () => 'watch',
      );

      expect(result, 'mobile');
    });

    test('should use pattern matching with maybeWhen', () {
      final tablet = DeviceType.fromSize(
        size: const Size(700, 1000),
        breakpoints: breakpoints,
      );

      final result = tablet.maybeWhen(
        smallTablet: () => 'tablet-detected',
        orElse: () => 'other',
      );

      expect(result, 'tablet-detected');
    });
  });

  group('ResponsiveKit Widget Tests', () {
    testWidgets('should provide responsive data to descendants', (
      tester,
    ) async {
      const breakpoints = ResponsiveBreakpoints(mobileMaxWidth: 500);
      late ResponsiveData capturedData;

      await tester.pumpWidget(
        buildResponsiveTestApp(
          breakpoints: breakpoints,
          child: Builder(
            builder: (context) {
              capturedData = ResponsiveKit.of(context);
              return const Text('Test');
            },
          ),
        ),
      );

      expect(capturedData, isNotNull);
      expect(capturedData.breakpoints, breakpoints);
    });

    testWidgets('should provide default data when no ResponsiveKit ancestor', (
      tester,
    ) async {
      late ResponsiveData capturedData;

      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              capturedData = ResponsiveKit.of(context);
              return const Scaffold(body: Text('Test'));
            },
          ),
        ),
      );

      expect(capturedData, isNotNull);
      expect(capturedData.breakpoints, isA<ResponsiveBreakpoints>());
    });

    testWidgets(
      'should return null with maybeOf when no ResponsiveKit ancestor',
      (tester) async {
        ResponsiveData? capturedData;

        await tester.pumpWidget(
          MaterialApp(
            home: Builder(
              builder: (context) {
                capturedData = ResponsiveKit.maybeOf(context);
                return const Scaffold(body: Text('Test'));
              },
            ),
          ),
        );

        expect(capturedData, isNull);
      },
    );

    testWidgets('should detect device type correctly', (tester) async {
      late DeviceType capturedDeviceType;

      await tester.pumpWidget(
        buildResponsiveTestApp(
          screenSize: const Size(400, 800), // Mobile size
          child: Builder(
            builder: (context) {
              capturedDeviceType = ResponsiveKit.deviceTypeOf(context);
              return const Text('Test');
            },
          ),
        ),
      );

      expect(capturedDeviceType, isA<Mobile>());
    });
  });

  group('ResponsiveBuilder Widget Tests', () {
    testWidgets('should build mobile widget on mobile device', (tester) async {
      await tester.pumpWidget(
        buildResponsiveTestApp(
          screenSize: const Size(400, 800),
          child: ResponsiveBuilder(
            mobile: (context) => const Text('Mobile'),
            tablet: (context) => const Text('Tablet'),
            desktop: (context) => const Text('Desktop'),
          ),
        ),
      );

      expect(find.text('Mobile'), findsOneWidget);
      expect(find.text('Tablet'), findsNothing);
      expect(find.text('Desktop'), findsNothing);
    });

    testWidgets('should build tablet widget on small tablet device', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildResponsiveTestApp(
          screenSize: const Size(700, 1000),
          child: ResponsiveBuilder(
            mobile: (context) => const Text('Mobile'),
            tablet: (context) => const Text('Tablet'),
            desktop: (context) => const Text('Desktop'),
          ),
        ),
      );

      expect(find.text('Mobile'), findsNothing);
      expect(find.text('Tablet'), findsOneWidget);
      expect(find.text('Desktop'), findsNothing);
    });

    testWidgets('should build specific tablet widget over generic tablet', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildResponsiveTestApp(
          screenSize: const Size(700, 1000),
          child: ResponsiveBuilder(
            smallTablet: (context) => const Text('Small Tablet'),
            tablet: (context) => const Text('Generic Tablet'),
            desktop: (context) => const Text('Desktop'),
          ),
        ),
      );

      expect(find.text('Small Tablet'), findsOneWidget);
      expect(find.text('Generic Tablet'), findsNothing);
    });

    testWidgets('should build desktop widget on desktop device', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildResponsiveTestApp(
          screenSize: const Size(1920, 1080),
          child: ResponsiveBuilder(
            mobile: (context) => const Text('Mobile'),
            tablet: (context) => const Text('Tablet'),
            desktop: (context) => const Text('Desktop'),
          ),
        ),
      );

      expect(find.text('Mobile'), findsNothing);
      expect(find.text('Tablet'), findsNothing);
      expect(find.text('Desktop'), findsOneWidget);
    });

    testWidgets(
      'should build fallback widget when no specific builder provided',
      (tester) async {
        await tester.pumpWidget(
          buildResponsiveTestApp(
            screenSize: const Size(400, 800),
            child: ResponsiveBuilder(
              desktop: (context) => const Text('Desktop'),
              fallback: (context) => const Text('Fallback'),
            ),
          ),
        );

        expect(find.text('Desktop'), findsNothing);
        expect(find.text('Fallback'), findsOneWidget);
      },
    );

    testWidgets(
      'should build empty widget when no builder matches and no fallback',
      (tester) async {
        await tester.pumpWidget(
          buildResponsiveTestApp(
            screenSize: const Size(400, 800),
            child: ResponsiveBuilder(
              desktop: (context) => const Text('Desktop'),
            ),
          ),
        );

        expect(find.text('Desktop'), findsNothing);
        expect(find.byType(SizedBox), findsOneWidget);
      },
    );

    testWidgets('should build watch widget on watch device', (tester) async {
      await tester.pumpWidget(
        buildResponsiveTestApp(
          screenSize: const Size(200, 240),
          child: ResponsiveBuilder(
            mobile: (context) => const Text('Mobile'),
            watch: (context) => const Text('Watch'),
          ),
        ),
      );

      expect(find.text('Mobile'), findsNothing);
      expect(find.text('Watch'), findsOneWidget);
    });
  });

  group('ResponsiveVisibility Widget Tests', () {
    testWidgets('should show widget on mobile when showOnMobile is true', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildResponsiveTestApp(
          screenSize: const Size(400, 800),
          child: ResponsiveVisibility(
            showOnMobile: true,
            showOnDesktop: false,
            builder: (context) => const Text('Visible'),
          ),
        ),
      );

      expect(find.text('Visible'), findsOneWidget);
    });

    testWidgets('should hide widget on mobile when showOnMobile is false', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildResponsiveTestApp(
          screenSize: const Size(400, 800),
          child: ResponsiveVisibility(
            showOnMobile: false,
            builder: (context) => const Text('Hidden'),
          ),
        ),
      );

      expect(find.text('Hidden'), findsNothing);
      expect(find.byType(SizedBox), findsOneWidget);
    });

    testWidgets('should show replacement widget when hidden', (tester) async {
      await tester.pumpWidget(
        buildResponsiveTestApp(
          screenSize: const Size(400, 800),
          child: ResponsiveVisibility(
            showOnMobile: false,
            builder: (context) => const Text('Hidden'),
            replacementBuilder: (context) => const Text('Replacement'),
          ),
        ),
      );

      expect(find.text('Hidden'), findsNothing);
      expect(find.text('Replacement'), findsOneWidget);
    });

    testWidgets('should use mobile-only constructor correctly', (tester) async {
      await tester.pumpWidget(
        buildResponsiveTestApp(
          screenSize: const Size(400, 800),
          child: ResponsiveVisibility.mobile(
            builder: (context) => const Text('Mobile Only'),
          ),
        ),
      );

      expect(find.text('Mobile Only'), findsOneWidget);
    });

    testWidgets('should hide with mobile-only constructor on tablet', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildResponsiveTestApp(
          screenSize: const Size(700, 1000),
          child: ResponsiveVisibility.mobile(
            builder: (context) => const Text('Mobile Only'),
          ),
        ),
      );

      expect(find.text('Mobile Only'), findsNothing);
    });

    testWidgets('should use desktop-only constructor correctly', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildResponsiveTestApp(
          screenSize: const Size(1920, 1080),
          child: ResponsiveVisibility.desktop(
            builder: (context) => const Text('Desktop Only'),
          ),
        ),
      );

      expect(find.text('Desktop Only'), findsOneWidget);
    });

    testWidgets('should hide with desktop-only constructor on mobile', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildResponsiveTestApp(
          screenSize: const Size(400, 800),
          child: ResponsiveVisibility.desktop(
            builder: (context) => const Text('Desktop Only'),
          ),
        ),
      );

      expect(find.text('Desktop Only'), findsNothing);
    });

    testWidgets('should show widget on watch device', (tester) async {
      await tester.pumpWidget(
        buildResponsiveTestApp(
          screenSize: const Size(200, 240),
          child: ResponsiveVisibility.watch(
            builder: (context) => const Text('Watch Only'),
          ),
        ),
      );

      expect(find.text('Watch Only'), findsOneWidget);
    });

    testWidgets('should use tablet constructor correctly', (tester) async {
      await tester.pumpWidget(
        buildResponsiveTestApp(
          screenSize: const Size(700, 1000),
          child: ResponsiveVisibility.tablet(
            builder: (context) => const Text('Tablet Only'),
          ),
        ),
      );

      expect(find.text('Tablet Only'), findsOneWidget);
    });

    testWidgets('should hide tablet widget on mobile', (tester) async {
      await tester.pumpWidget(
        buildResponsiveTestApp(
          screenSize: const Size(400, 800),
          child: ResponsiveVisibility.tablet(
            builder: (context) => const Text('Tablet Only'),
          ),
        ),
      );

      expect(find.text('Tablet Only'), findsNothing);
    });
  });

  group('Integration Tests', () {
    testWidgets('should work together in complex layout', (tester) async {
      await tester.pumpWidget(
        buildResponsiveTestApp(
          screenSize: const Size(700, 1000), // Small tablet
          breakpoints: const ResponsiveBreakpoints(
            mobileMaxWidth: 600,
            smallTabletMaxWidth: 768,
          ),
          child: Column(
            children: [
              ResponsiveBuilder(
                mobile: (context) => const Text('Mobile App'),
                tablet: (context) => const Text('Tablet App'),
                desktop: (context) => const Text('Desktop App'),
              ),
              ResponsiveVisibility(
                showOnMobile: false,
                builder: (context) => const Text('Tablet Feature'),
              ),
              Expanded(
                child: ResponsiveBuilder(
                  mobile: (context) =>
                      const Center(child: Text('Mobile Layout')),
                  tablet: (context) => Row(
                    children: [
                      Container(
                        width: 200,
                        color: Colors.grey[300],
                        child: const Center(child: Text('Sidebar')),
                      ),
                      const Expanded(
                        child: Center(child: Text('Tablet Content')),
                      ),
                    ],
                  ),
                ),
              ),
              ResponsiveVisibility.desktop(
                builder: (context) => const Text('Desktop Feature'),
              ),
            ],
          ),
        ),
      );

      expect(find.text('Tablet App'), findsOneWidget);
      expect(find.text('Tablet Feature'), findsOneWidget);
      expect(find.text('Sidebar'), findsOneWidget);
      expect(find.text('Tablet Content'), findsOneWidget);
      expect(find.text('Mobile Layout'), findsNothing);
      expect(find.text('Desktop Feature'), findsNothing); // Desktop only
    });

    testWidgets('should handle different screen sizes', (tester) async {
      // Test mobile
      await tester.pumpWidget(
        buildResponsiveTestApp(
          screenSize: const Size(400, 800),
          child: ResponsiveBuilder(
            mobile: (context) => const Text('Mobile'),
            tablet: (context) => const Text('Tablet'),
            desktop: (context) => const Text('Desktop'),
          ),
        ),
      );

      expect(find.text('Mobile'), findsOneWidget);

      // Test tablet by recreating widget
      await tester.pumpWidget(
        buildResponsiveTestApp(
          screenSize: const Size(800, 1000),
          child: ResponsiveBuilder(
            mobile: (context) => const Text('Mobile'),
            tablet: (context) => const Text('Tablet'),
            desktop: (context) => const Text('Desktop'),
          ),
        ),
      );

      expect(find.text('Tablet'), findsOneWidget);
      expect(find.text('Mobile'), findsNothing);

      // Test desktop
      await tester.pumpWidget(
        buildResponsiveTestApp(
          screenSize: const Size(1920, 1080),
          child: ResponsiveBuilder(
            mobile: (context) => const Text('Mobile'),
            tablet: (context) => const Text('Tablet'),
            desktop: (context) => const Text('Desktop'),
          ),
        ),
      );

      expect(find.text('Desktop'), findsOneWidget);
      expect(find.text('Tablet'), findsNothing);
      expect(find.text('Mobile'), findsNothing);
    });

    testWidgets('should work with custom breakpoints', (tester) async {
      const customBreakpoints = ResponsiveBreakpoints(
        mobileMaxWidth: 480,
        smallTabletMaxWidth: 600,
        mediumTabletMaxWidth: 900,
      );

      // 500px width should be small tablet with custom breakpoints
      await tester.pumpWidget(
        buildResponsiveTestApp(
          screenSize: const Size(500, 800),
          breakpoints: customBreakpoints,
          child: ResponsiveBuilder(
            mobile: (context) => const Text('Mobile'),
            smallTablet: (context) => const Text('Small Tablet'),
            mediumTablet: (context) => const Text('Medium Tablet'),
          ),
        ),
      );

      expect(find.text('Small Tablet'), findsOneWidget);
      expect(find.text('Mobile'), findsNothing);
    });

    testWidgets('should handle orientation changes', (tester) async {
      // Portrait mobile
      await tester.pumpWidget(
        buildResponsiveTestApp(
          screenSize: const Size(400, 800),
          child: Builder(
            builder: (context) {
              final responsive = ResponsiveKit.of(context);
              return Text('Orientation: ${responsive.orientation.name}');
            },
          ),
        ),
      );

      expect(find.text('Orientation: portrait'), findsOneWidget);

      // Landscape mobile (wide but still mobile width)
      await tester.pumpWidget(
        buildResponsiveTestApp(
          screenSize: const Size(800, 400),
          child: Builder(
            builder: (context) {
              final responsive = ResponsiveKit.of(context);
              return Text('Orientation: ${responsive.orientation.name}');
            },
          ),
        ),
      );

      expect(find.text('Orientation: landscape'), findsOneWidget);
    });
  });
}
