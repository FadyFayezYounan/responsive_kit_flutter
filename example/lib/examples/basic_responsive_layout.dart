import 'package:flutter/material.dart';
import 'package:responsive_kit_flutter/responsive_kit_flutter.dart';

class BasicResponsiveLayout extends StatelessWidget {
  const BasicResponsiveLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInfoCard(context),
          const SizedBox(height: 20),
          _buildPatternMatchingExample(context),
          const SizedBox(height: 20),
          Expanded(child: _buildResponsiveContent(context)),
        ],
      ),
    );
  }

  Widget _buildInfoCard(BuildContext context) {
    final responsive = ResponsiveKit.of(context);
    final deviceType = responsive.deviceType;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Device Information',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 12),
            _buildInfoRow('Device Type', deviceType.runtimeType.toString()),
            _buildInfoRow(
              'Screen Size',
              '${responsive.screenSize.width.toInt()} × ${responsive.screenSize.height.toInt()}',
            ),
            _buildInfoRow('Orientation', responsive.orientation.name),
            _buildInfoRow('Is Mobile', deviceType.isMobile.toString()),
            _buildInfoRow('Is Tablet', deviceType.isTablet.toString()),
            _buildInfoRow('Is Desktop', deviceType.isDesktop.toString()),
            _buildInfoRow('Is Handheld', deviceType.isHandheld.toString()),
            _buildInfoRow(
              'Supports Hover',
              deviceType.supportsHover.toString(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Row(
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          Text(value),
        ],
      ),
    );
  }

  Widget _buildPatternMatchingExample(BuildContext context) {
    final deviceType = ResponsiveKit.deviceTypeOf(context);

    final backgroundColor = deviceType.when(
      mobile: () => Colors.blue.shade100,
      smallTablet: () => Colors.green.shade100,
      mediumTablet: () => Colors.orange.shade100,
      largeTablet: () => Colors.purple.shade100,
      desktop: () => Colors.red.shade100,
      watch: () => Colors.grey.shade100,
    );

    final deviceMessage = deviceType.when(
      mobile: () => '📱 Mobile Layout - Single column, touch-first design',
      smallTablet: () => '📲 Small Tablet - Compact two-column layout',
      mediumTablet: () => '💻 Medium Tablet - Balanced layout with sidebars',
      largeTablet: () => '🖥️ Large Tablet - Desktop-like experience',
      desktop: () => '🖥️ Desktop - Full-featured layout with hover effects',
      watch: () => '⌚ Watch - Minimal, essential information only',
    );

    return Card(
      color: backgroundColor,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Pattern Matching Example',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(deviceMessage),
          ],
        ),
      ),
    );
  }

  Widget _buildResponsiveContent(BuildContext context) {
    return ResponsiveBuilder(
      mobile: (context) => _buildMobileContent(),
      smallTablet: (context) => _buildSmallTabletContent(),
      mediumTablet: (context) => _buildMediumTabletContent(),
      largeTablet: (context) => _buildLargeTabletContent(),
      desktop: (context) => _buildDesktopContent(),
      watch: (context) => _buildWatchContent(),
      fallback: (context) => _buildFallbackContent(),
    );
  }

  Widget _buildMobileContent() {
    return Column(
      children: [
        _buildContentCard(
          'Mobile Layout',
          'Single column layout optimized for touch interaction. Content stacks vertically for easy scrolling.',
          Icons.phone_android,
          Colors.blue,
        ),
        const SizedBox(height: 16),
        _buildContentCard(
          'Touch Optimized',
          'Larger touch targets and gesture-friendly interactions.',
          Icons.touch_app,
          Colors.blue.shade300,
        ),
      ],
    );
  }

  Widget _buildSmallTabletContent() {
    return Row(
      children: [
        Expanded(
          child: _buildContentCard(
            'Small Tablet',
            'Compact two-column layout that makes better use of available screen space.',
            Icons.tablet_android,
            Colors.green,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildContentCard(
            'Adaptive',
            'Content adapts to show more information while remaining touch-friendly.',
            Icons.settings_input_composite,
            Colors.green.shade300,
          ),
        ),
      ],
    );
  }

  Widget _buildMediumTabletContent() {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: _buildContentCard(
            'Medium Tablet',
            'Three-column layout with primary content and supporting sidebars.',
            Icons.tablet,
            Colors.orange,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            children: [
              Expanded(
                child: _buildContentCard(
                  'Sidebar',
                  'Secondary content and navigation.',
                  Icons.menu,
                  Colors.orange.shade300,
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: _buildContentCard(
                  'Tools',
                  'Additional tools and options.',
                  Icons.build,
                  Colors.orange.shade200,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLargeTabletContent() {
    return Row(
      children: [
        SizedBox(
          width: 200,
          child: _buildContentCard(
            'Navigation',
            'Persistent navigation sidebar for easy access.',
            Icons.navigation,
            Colors.purple.shade300,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          flex: 3,
          child: _buildContentCard(
            'Large Tablet',
            'Desktop-like layout with multiple content areas and rich interactions.',
            Icons.laptop_chromebook,
            Colors.purple,
          ),
        ),
        const SizedBox(width: 16),
        SizedBox(
          width: 200,
          child: _buildContentCard(
            'Details',
            'Detailed information panel with additional context.',
            Icons.info,
            Colors.purple.shade200,
          ),
        ),
      ],
    );
  }

  Widget _buildDesktopContent() {
    return Row(
      children: [
        SizedBox(
          width: 250,
          child: Column(
            children: [
              Expanded(
                child: _buildContentCard(
                  'Navigation',
                  'Full navigation with expandable sections.',
                  Icons.menu_open,
                  Colors.red.shade300,
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: _buildContentCard(
                  'Quick Actions',
                  'Frequently used tools and shortcuts.',
                  Icons.flash_on,
                  Colors.red.shade200,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          flex: 3,
          child: _buildContentCard(
            'Desktop Layout',
            'Full-featured desktop experience with hover effects, keyboard shortcuts, and multiple content panes.',
            Icons.desktop_windows,
            Colors.red,
          ),
        ),
        const SizedBox(width: 16),
        SizedBox(
          width: 300,
          child: Column(
            children: [
              Expanded(
                child: _buildContentCard(
                  'Properties',
                  'Detailed properties and settings panel.',
                  Icons.settings,
                  Colors.red.shade300,
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: _buildContentCard(
                  'Preview',
                  'Live preview and additional context.',
                  Icons.preview,
                  Colors.red.shade200,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildWatchContent() {
    return Center(
      child: _buildContentCard(
        'Watch Layout',
        'Minimal design showing only essential information. Optimized for small screens.',
        Icons.watch,
        Colors.grey,
      ),
    );
  }

  Widget _buildFallbackContent() {
    return Center(
      child: _buildContentCard(
        'Fallback Layout',
        'Default layout when no specific device type matches.',
        Icons.help_outline,
        Colors.grey,
      ),
    );
  }

  Widget _buildContentCard(
    String title,
    String description,
    IconData icon,
    Color color,
  ) {
    return Card(
      elevation: 2,
      child: Container(
        width: double.infinity,
        height: double.infinity,
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: color, size: 24),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Expanded(
              child: Text(
                description,
                style: TextStyle(fontSize: 14, color: Colors.grey.shade700),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
