import 'package:flutter/material.dart';
import 'package:responsive_kit_flutter/responsive_kit_flutter.dart';

class DeviceSpecificFeatures extends StatefulWidget {
  const DeviceSpecificFeatures({super.key});

  @override
  State<DeviceSpecificFeatures> createState() => _DeviceSpecificFeaturesState();
}

class _DeviceSpecificFeaturesState extends State<DeviceSpecificFeatures> {
  bool _isDarkMode = false;
  double _textScale = 1.0;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(context),
          const SizedBox(height: 24),
          _buildDeviceSpecificFeatures(context),
          const SizedBox(height: 24),
          _buildResponsiveVisibilityDemo(),
          const SizedBox(height: 24),
          _buildInputMethodsDemo(),
          const SizedBox(height: 24),
          _buildLayoutAdaptations(),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final deviceType = ResponsiveKit.deviceTypeOf(context);
    final breakpoints = const ResponsiveBreakpoints();
    final size = MediaQuery.of(context).size;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Device-Specific Features',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontSize: deviceType.when(
                  mobile: () => 24.0,
                  smallTablet: () => 26.0,
                  mediumTablet: () => 28.0,
                  largeTablet: () => 30.0,
                  desktop: () => 32.0,
                  watch: () => 18.0,
                ),
              ),
            ),
            const SizedBox(height: 16),
            _buildDeviceInfo(deviceType, size, breakpoints),
          ],
        ),
      ),
    );
  }

  Widget _buildDeviceInfo(
    DeviceType deviceType,
    Size size,
    ResponsiveBreakpoints breakpoints,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                _getDeviceIcon(deviceType),
                color: Theme.of(context).primaryColor,
                size: 24,
              ),
              const SizedBox(width: 8),
              Text(
                'Current Device: ${deviceType.runtimeType}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildInfoRow(
            'Screen Size',
            '${size.width.toInt()} × ${size.height.toInt()}',
          ),
          _buildInfoRow(
            'Aspect Ratio',
            '${(size.width / size.height).toStringAsFixed(2)}:1',
          ),
          _buildInfoRow('Mobile Breakpoint', '${breakpoints.mobileMaxWidth}px'),
          _buildInfoRow(
            'Small Tablet Breakpoint',
            '${breakpoints.smallTabletMaxWidth}px',
          ),
          _buildInfoRow(
            'Medium Tablet Breakpoint',
            '${breakpoints.mediumTabletMaxWidth}px',
          ),
          _buildInfoRow(
            'Large Tablet Breakpoint',
            '${breakpoints.largeTabletMaxWidth}px',
          ),
          _buildInfoRow(
            'Desktop Breakpoint',
            '${breakpoints.largeTabletMaxWidth + 1}px+',
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          SizedBox(
            width: 140,
            child: Text(
              label,
              style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
            ),
          ),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
          ),
        ],
      ),
    );
  }

  IconData _getDeviceIcon(DeviceType deviceType) {
    return deviceType.when(
      mobile: () => Icons.smartphone,
      smallTablet: () => Icons.tablet_android,
      mediumTablet: () => Icons.tablet,
      largeTablet: () => Icons.tablet_mac,
      desktop: () => Icons.computer,
      watch: () => Icons.watch,
    );
  }

  Widget _buildDeviceSpecificFeatures(BuildContext context) {
    return ResponsiveBuilder(
      mobile: (context) => _buildMobileFeatures(),
      smallTablet: (context) => _buildSmallTabletFeatures(),
      mediumTablet: (context) => _buildTabletFeatures(),
      largeTablet: (context) => _buildLargeTabletFeatures(),
      desktop: (context) => _buildDesktopFeatures(),
      watch: (context) => _buildWatchFeatures(),
    );
  }

  Widget _buildMobileFeatures() {
    return Column(
      children: [
        _buildFeatureCard('Mobile-Optimized Features', [
          FeatureItem(
            'Pull-to-refresh',
            Icons.refresh,
            'Gesture-based refresh',
          ),
          FeatureItem(
            'Bottom sheets',
            Icons.vertical_align_bottom,
            'Easy thumb access',
          ),
          FeatureItem(
            'FAB placement',
            Icons.add_circle,
            'Optimized for one-hand use',
          ),
          FeatureItem(
            'Swipe gestures',
            Icons.swipe,
            'Touch-friendly interactions',
          ),
        ], Colors.blue),
        const SizedBox(height: 16),
        _buildMobileSpecificDemo(),
      ],
    );
  }

  Widget _buildSmallTabletFeatures() {
    return Column(
      children: [
        _buildFeatureCard('Small Tablet Features', [
          FeatureItem('Split view', Icons.view_column, 'Dual-pane layouts'),
          FeatureItem(
            'Adaptive navigation',
            Icons.navigation,
            'Bottom nav + tabs',
          ),
          FeatureItem(
            'Touch optimization',
            Icons.touch_app,
            'Finger-friendly targets',
          ),
          FeatureItem(
            'Portrait focus',
            Icons.stay_current_portrait,
            'Optimized for portrait',
          ),
        ], Colors.green),
        const SizedBox(height: 16),
        _buildTabletDemo(),
      ],
    );
  }

  Widget _buildTabletFeatures() {
    return Row(
      children: [
        Expanded(
          child: _buildFeatureCard('Medium Tablet Features', [
            FeatureItem(
              'Master-detail',
              Icons.view_sidebar,
              'Side-by-side layouts',
            ),
            FeatureItem('Multi-column', Icons.view_week, 'Grid-based content'),
            FeatureItem(
              'Contextual menus',
              Icons.more_horiz,
              'Right-click support',
            ),
            FeatureItem(
              'Drag & drop',
              Icons.drag_indicator,
              'Touch interactions',
            ),
          ], Colors.orange),
        ),
        const SizedBox(width: 16),
        Expanded(child: _buildTabletDemo()),
      ],
    );
  }

  Widget _buildLargeTabletFeatures() {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: _buildFeatureCard('Large Tablet Features', [
            FeatureItem(
              'Desktop-like UI',
              Icons.desktop_windows,
              'Full-featured interface',
            ),
            FeatureItem('Multi-window', Icons.dashboard, 'Complex layouts'),
            FeatureItem(
              'Keyboard shortcuts',
              Icons.keyboard,
              'Productivity features',
            ),
            FeatureItem(
              'Precision input',
              Icons.mouse,
              'Mouse/trackpad support',
            ),
          ], Colors.purple),
        ),
        const SizedBox(width: 16),
        Expanded(child: _buildDesktopDemo()),
      ],
    );
  }

  Widget _buildDesktopFeatures() {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: _buildFeatureCard('Desktop Features', [
            FeatureItem(
              'Window management',
              Icons.crop_din,
              'Resizable panels',
            ),
            FeatureItem('Menu bars', Icons.menu, 'Traditional menus'),
            FeatureItem(
              'Keyboard navigation',
              Icons.keyboard_arrow_right,
              'Full keyboard support',
            ),
            FeatureItem('Context menus', Icons.menu_open, 'Right-click menus'),
            FeatureItem('Tooltips', Icons.help_outline, 'Hover information'),
            FeatureItem(
              'Dense layouts',
              Icons.view_compact,
              'Information density',
            ),
          ], Colors.indigo),
        ),
        const SizedBox(width: 16),
        Expanded(child: _buildDesktopDemo()),
      ],
    );
  }

  Widget _buildWatchFeatures() {
    return _buildFeatureCard('Watch Features', [
      FeatureItem('Glanceable info', Icons.visibility, 'Quick information'),
      FeatureItem(
        'Large targets',
        Icons.radio_button_checked,
        'Easy touch targets',
      ),
      FeatureItem('Minimal text', Icons.text_fields, 'Essential content only'),
      FeatureItem(
        'Crown navigation',
        Icons.rotate_right,
        'Scroll alternatives',
      ),
    ], Colors.red);
  }

  Widget _buildFeatureCard(
    String title,
    List<FeatureItem> features,
    Color color,
  ) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(Icons.featured_play_list, color: color),
                ),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...features.map(
              (feature) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  children: [
                    Icon(feature.icon, size: 20, color: color),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            feature.title,
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                          Text(
                            feature.description,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMobileSpecificDemo() {
    return Card(
      child: Column(
        children: [
          ListTile(
            leading: const Icon(Icons.smartphone),
            title: const Text('Mobile Interactions'),
            subtitle: const Text('Swipe, tap, and gesture controls'),
          ),
          Container(
            height: 100,
            margin: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Center(
              child: Text(
                'Pull down to refresh\nSwipe left/right to navigate',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabletDemo() {
    return Card(
      child: Column(
        children: [
          ListTile(
            leading: const Icon(Icons.tablet),
            title: const Text('Tablet Layout'),
            subtitle: const Text('Split-view interface'),
          ),
          Container(
            height: 120,
            margin: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Center(
                      child: Text('Master', style: TextStyle(fontSize: 14)),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.orange.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Center(
                      child: Text('Detail', style: TextStyle(fontSize: 14)),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDesktopDemo() {
    return Card(
      child: Column(
        children: [
          ListTile(
            leading: const Icon(Icons.computer),
            title: const Text('Desktop Layout'),
            subtitle: const Text('Multi-panel interface'),
          ),
          Container(
            height: 150,
            margin: const EdgeInsets.all(16),
            child: Column(
              children: [
                Container(
                  height: 30,
                  decoration: BoxDecoration(
                    color: Colors.indigo.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Center(
                    child: Text('Menu Bar', style: TextStyle(fontSize: 12)),
                  ),
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: Row(
                    children: [
                      Container(
                        width: 60,
                        decoration: BoxDecoration(
                          color: Colors.purple.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Center(
                          child: Text(
                            'Sidebar',
                            style: TextStyle(fontSize: 10),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.blue.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Center(
                            child: Text(
                              'Content',
                              style: TextStyle(fontSize: 12),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResponsiveVisibilityDemo() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Responsive Visibility',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            Text(
              'Different elements are shown/hidden based on device type:',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                ResponsiveVisibility(
                  showOnMobile: true,
                  showOnSmallTablet: false,
                  showOnMediumTablet: false,
                  showOnLargeTablet: false,
                  showOnDesktop: false,
                  showOnWatch: true,
                  builder: (context) => Chip(
                    label: const Text('Mobile & Watch Only'),
                    backgroundColor: Colors.blue.withOpacity(0.1),
                  ),
                ),
                ResponsiveVisibility(
                  showOnMobile: false,
                  showOnSmallTablet: true,
                  showOnMediumTablet: true,
                  showOnLargeTablet: true,
                  showOnDesktop: false,
                  showOnWatch: false,
                  builder: (context) => Chip(
                    label: const Text('Tablet Only'),
                    backgroundColor: Colors.green.withOpacity(0.1),
                  ),
                ),
                ResponsiveVisibility(
                  showOnMobile: false,
                  showOnSmallTablet: false,
                  showOnMediumTablet: false,
                  showOnLargeTablet: false,
                  showOnDesktop: true,
                  showOnWatch: false,
                  builder: (context) => Chip(
                    label: const Text('Desktop Only'),
                    backgroundColor: Colors.purple.withOpacity(0.1),
                  ),
                ),
                ResponsiveVisibility(
                  showOnMobile: false,
                  showOnSmallTablet: true,
                  showOnMediumTablet: true,
                  showOnLargeTablet: true,
                  showOnDesktop: true,
                  showOnWatch: false,
                  builder: (context) => Chip(
                    label: const Text('Tablet & Desktop'),
                    backgroundColor: Colors.orange.withOpacity(0.1),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputMethodsDemo() {
    final deviceType = ResponsiveKit.deviceTypeOf(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Input Methods',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            Text(
              'Input methods adapt to the current device:',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            _buildInputMethodItem(
              deviceType,
              'Text Input',
              deviceType.when(
                mobile: () => 'On-screen keyboard',
                smallTablet: () => 'Virtual keyboard',
                mediumTablet: () => 'Virtual/physical keyboard',
                largeTablet: () => 'Physical keyboard preferred',
                desktop: () => 'Physical keyboard',
                watch: () => 'Voice/scribble input',
              ),
              Icons.keyboard,
            ),
            _buildInputMethodItem(
              deviceType,
              'Navigation',
              deviceType.when(
                mobile: () => 'Touch gestures',
                smallTablet: () => 'Touch + stylus',
                mediumTablet: () => 'Touch + mouse/trackpad',
                largeTablet: () => 'Mouse/trackpad preferred',
                desktop: () => 'Mouse + keyboard',
                watch: () => 'Crown + touch',
              ),
              Icons.navigation,
            ),
            _buildInputMethodItem(
              deviceType,
              'Selection',
              deviceType.when(
                mobile: () => 'Long press + drag',
                smallTablet: () => 'Tap selection',
                mediumTablet: () => 'Click + drag',
                largeTablet: () => 'Precise selection',
                desktop: () => 'Click + keyboard shortcuts',
                watch: () => 'Force touch',
              ),
              Icons.select_all,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputMethodItem(
    DeviceType deviceType,
    String method,
    String description,
    IconData icon,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: Theme.of(context).primaryColor, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  method,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                Text(
                  description,
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLayoutAdaptations() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Layout Adaptations',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            Text(
              'Settings and preferences that adapt to device capabilities:',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            SwitchListTile(
              title: const Text('Dark Mode'),
              subtitle: const Text('Adapts to system preferences'),
              value: _isDarkMode,
              onChanged: (value) => setState(() => _isDarkMode = value),
            ),
            const Divider(),
            ListTile(
              title: const Text('Text Scale'),
              subtitle: Slider(
                value: _textScale,
                min: 0.8,
                max: 1.5,
                divisions: 7,
                label: '${(_textScale * 100).round()}%',
                onChanged: (value) => setState(() => _textScale = value),
              ),
            ),
            const Divider(),
            ResponsiveBuilder(
              mobile: (context) => ListTile(
                title: const Text('Mobile Optimizations'),
                subtitle: const Text(
                  'Touch targets enlarged, simplified navigation',
                ),
                leading: Icon(
                  Icons.smartphone,
                  color: Theme.of(context).primaryColor,
                ),
              ),
              smallTablet: (context) => ListTile(
                title: const Text('Small Tablet Optimizations'),
                subtitle: const Text('Split layouts, adaptive navigation'),
                leading: Icon(
                  Icons.tablet_android,
                  color: Theme.of(context).primaryColor,
                ),
              ),
              mediumTablet: (context) => ListTile(
                title: const Text('Medium Tablet Optimizations'),
                subtitle: const Text('Multi-column layouts, contextual menus'),
                leading: Icon(
                  Icons.tablet,
                  color: Theme.of(context).primaryColor,
                ),
              ),
              largeTablet: (context) => ListTile(
                title: const Text('Large Tablet Optimizations'),
                subtitle: const Text('Desktop-like interface, precision input'),
                leading: Icon(
                  Icons.tablet_mac,
                  color: Theme.of(context).primaryColor,
                ),
              ),
              desktop: (context) => ListTile(
                title: const Text('Desktop Optimizations'),
                subtitle: const Text(
                  'Dense layouts, keyboard shortcuts, hover states',
                ),
                leading: Icon(
                  Icons.computer,
                  color: Theme.of(context).primaryColor,
                ),
              ),
              watch: (context) => ListTile(
                title: const Text('Watch Optimizations'),
                subtitle: const Text('Minimal interface, large touch targets'),
                leading: Icon(
                  Icons.watch,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FeatureItem {
  final String title;
  final IconData icon;
  final String description;

  FeatureItem(this.title, this.icon, this.description);
}
