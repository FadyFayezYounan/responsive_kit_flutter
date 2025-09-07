import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:responsive_kit_flutter/responsive_kit_flutter.dart';

void main() {
  testWidgets('Debug screen size and device detection', (tester) async {
    // Check default test screen size
    print('Default test screen size: ${tester.binding.window.physicalSize}');

    await tester.pumpWidget(
      ResponsiveKit(
        child: MaterialApp(
          home: Builder(
            builder: (context) {
              final responsive = ResponsiveKit.of(context);
              final screenSize = MediaQuery.sizeOf(context);
              print('MediaQuery screen size: $screenSize');
              print('Device type: ${responsive.deviceType}');
              print(
                'Device type runtime type: ${responsive.deviceType.runtimeType}',
              );
              print('Is mobile: ${responsive.deviceType.isMobile}');
              return Scaffold(body: Text('Debug'));
            },
          ),
        ),
      ),
    );
  });

  testWidgets('Test different screen sizes', (tester) async {
    // Test 400x800 (mobile)
    await tester.binding.setSurfaceSize(const Size(400, 800));
    await tester.pumpWidget(
      ResponsiveKit(
        child: MaterialApp(
          home: Builder(
            builder: (context) {
              final responsive = ResponsiveKit.of(context);
              final screenSize = MediaQuery.sizeOf(context);
              print(
                'Screen size 400x800: $screenSize, Device: ${responsive.deviceType.runtimeType}',
              );
              return Scaffold(body: Text('Test'));
            },
          ),
        ),
      ),
    );

    // Test 700x1000 (small tablet)
    await tester.binding.setSurfaceSize(const Size(700, 1000));
    await tester.pumpWidget(
      ResponsiveKit(
        child: MaterialApp(
          home: Builder(
            builder: (context) {
              final responsive = ResponsiveKit.of(context);
              final screenSize = MediaQuery.sizeOf(context);
              print(
                'Screen size 700x1000: $screenSize, Device: ${responsive.deviceType.runtimeType}',
              );
              return Scaffold(body: Text('Test'));
            },
          ),
        ),
      ),
    );
  });
}
