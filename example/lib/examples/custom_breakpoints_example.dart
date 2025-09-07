import 'package:flutter/material.dart';
import 'package:responsive_kit_flutter/responsive_kit_flutter.dart';

class CustomBreakpointsExample extends StatefulWidget {
  const CustomBreakpointsExample({super.key});

  @override
  State<CustomBreakpointsExample> createState() =>
      _CustomBreakpointsExampleState();
}

class _CustomBreakpointsExampleState extends State<CustomBreakpointsExample> {
  ResponsiveBreakpoints _currentBreakpoints = const ResponsiveBreakpoints();

  // Custom breakpoint presets
  final Map<String, ResponsiveBreakpoints> _presets = {
    'Default': const ResponsiveBreakpoints(),
    'Compact': const ResponsiveBreakpoints(
      mobileMaxWidth: 480,
      smallTabletMaxWidth: 600,
      mediumTabletMaxWidth: 900,
      largeTabletMaxWidth: 1200,
    ),
    'Wide': const ResponsiveBreakpoints(
      mobileMaxWidth: 768,
      smallTabletMaxWidth: 1024,
      mediumTabletMaxWidth: 1440,
      largeTabletMaxWidth: 1920,
    ),
    'Ultra Wide': const ResponsiveBreakpoints(
      mobileMaxWidth: 1024,
      smallTabletMaxWidth: 1366,
      mediumTabletMaxWidth: 1920,
      largeTabletMaxWidth: 2560,
    ),
  };

  String _selectedPreset = 'Default';

  @override
  Widget build(BuildContext context) {
    return ResponsiveKit(
      data: _currentBreakpoints,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            const SizedBox(height: 24),
            _buildBreakpointControls(),
            const SizedBox(height: 24),
            _buildCurrentConfiguration(),
            const SizedBox(height: 24),
            _buildResponsiveDemo(),
            const SizedBox(height: 24),
            _buildBreakpointVisualization(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.tune,
                  color: Theme.of(context).primaryColor,
                  size: 28,
                ),
                const SizedBox(width: 12),
                Text(
                  'Custom Breakpoints',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              'This example demonstrates how to use custom breakpoints with ResponsiveKit. '
              'You can define your own breakpoints to match your design requirements.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.blue.withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    color: Colors.blue.shade700,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Try different presets or resize your window to see how breakpoints affect layout.',
                      style: TextStyle(
                        color: Colors.blue.shade700,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBreakpointControls() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Breakpoint Presets',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _presets.keys
                  .map(
                    (preset) => ChoiceChip(
                      label: Text(preset),
                      selected: _selectedPreset == preset,
                      onSelected: (selected) {
                        if (selected) {
                          setState(() {
                            _selectedPreset = preset;
                            _currentBreakpoints = _presets[preset]!;
                          });
                        }
                      },
                    ),
                  )
                  .toList(),
            ),
            const SizedBox(height: 20),
            _buildCustomBreakpointEditor(),
          ],
        ),
      ),
    );
  }

  Widget _buildCustomBreakpointEditor() {
    return ExpansionTile(
      title: const Text('Custom Breakpoint Editor'),
      subtitle: const Text('Fine-tune breakpoint values'),
      children: [
        const SizedBox(height: 16),
        _buildBreakpointSlider(
          'Mobile Max Width',
          _currentBreakpoints.mobileMaxWidth,
          200,
          1000,
          (value) {
            setState(() {
              _currentBreakpoints = ResponsiveBreakpoints(
                mobileMaxWidth: value,
                smallTabletMaxWidth: _currentBreakpoints.smallTabletMaxWidth,
                mediumTabletMaxWidth: _currentBreakpoints.mediumTabletMaxWidth,
                largeTabletMaxWidth: _currentBreakpoints.largeTabletMaxWidth,
                watchMaxWidth: _currentBreakpoints.watchMaxWidth,
                watchMaxHeight: _currentBreakpoints.watchMaxHeight,
              );
              _selectedPreset = 'Custom';
            });
          },
        ),
        _buildBreakpointSlider(
          'Small Tablet Max Width',
          _currentBreakpoints.smallTabletMaxWidth,
          400,
          1200,
          (value) {
            setState(() {
              _currentBreakpoints = ResponsiveBreakpoints(
                mobileMaxWidth: _currentBreakpoints.mobileMaxWidth,
                smallTabletMaxWidth: value,
                mediumTabletMaxWidth: _currentBreakpoints.mediumTabletMaxWidth,
                largeTabletMaxWidth: _currentBreakpoints.largeTabletMaxWidth,
                watchMaxWidth: _currentBreakpoints.watchMaxWidth,
                watchMaxHeight: _currentBreakpoints.watchMaxHeight,
              );
              _selectedPreset = 'Custom';
            });
          },
        ),
        _buildBreakpointSlider(
          'Medium Tablet Max Width',
          _currentBreakpoints.mediumTabletMaxWidth,
          600,
          1600,
          (value) {
            setState(() {
              _currentBreakpoints = ResponsiveBreakpoints(
                mobileMaxWidth: _currentBreakpoints.mobileMaxWidth,
                smallTabletMaxWidth: _currentBreakpoints.smallTabletMaxWidth,
                mediumTabletMaxWidth: value,
                largeTabletMaxWidth: _currentBreakpoints.largeTabletMaxWidth,
                watchMaxWidth: _currentBreakpoints.watchMaxWidth,
                watchMaxHeight: _currentBreakpoints.watchMaxHeight,
              );
              _selectedPreset = 'Custom';
            });
          },
        ),
        _buildBreakpointSlider(
          'Large Tablet Max Width',
          _currentBreakpoints.largeTabletMaxWidth,
          800,
          2000,
          (value) {
            setState(() {
              _currentBreakpoints = ResponsiveBreakpoints(
                mobileMaxWidth: _currentBreakpoints.mobileMaxWidth,
                smallTabletMaxWidth: _currentBreakpoints.smallTabletMaxWidth,
                mediumTabletMaxWidth: _currentBreakpoints.mediumTabletMaxWidth,
                largeTabletMaxWidth: value,
                watchMaxWidth: _currentBreakpoints.watchMaxWidth,
                watchMaxHeight: _currentBreakpoints.watchMaxHeight,
              );
              _selectedPreset = 'Custom';
            });
          },
        ),
      ],
    );
  }

  Widget _buildBreakpointSlider(
    String label,
    double value,
    double min,
    double max,
    ValueChanged<double> onChanged,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [Text(label), Text('${value.toInt()}px')],
          ),
          Slider(
            value: value,
            min: min,
            max: max,
            divisions: ((max - min) / 50).round(),
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }

  Widget _buildCurrentConfiguration() {
    final deviceType = ResponsiveKit.deviceTypeOf(context);
    final screenWidth = MediaQuery.of(context).size.width;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Current Configuration',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Current Screen Width:'),
                      Text(
                        '${screenWidth.toInt()}px',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Detected Device Type:'),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          deviceType.runtimeType.toString(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _buildBreakpointTable(),
          ],
        ),
      ),
    );
  }

  Widget _buildBreakpointTable() {
    final screenWidth = MediaQuery.of(context).size.width;

    final breakpointData = [
      (
        'Mobile',
        '0',
        '${_currentBreakpoints.mobileMaxWidth.toInt()}',
        screenWidth <= _currentBreakpoints.mobileMaxWidth,
      ),
      (
        'Small Tablet',
        '${(_currentBreakpoints.mobileMaxWidth + 1).toInt()}',
        '${_currentBreakpoints.smallTabletMaxWidth.toInt()}',
        screenWidth > _currentBreakpoints.mobileMaxWidth &&
            screenWidth <= _currentBreakpoints.smallTabletMaxWidth,
      ),
      (
        'Medium Tablet',
        '${(_currentBreakpoints.smallTabletMaxWidth + 1).toInt()}',
        '${_currentBreakpoints.mediumTabletMaxWidth.toInt()}',
        screenWidth > _currentBreakpoints.smallTabletMaxWidth &&
            screenWidth <= _currentBreakpoints.mediumTabletMaxWidth,
      ),
      (
        'Large Tablet',
        '${(_currentBreakpoints.mediumTabletMaxWidth + 1).toInt()}',
        '${_currentBreakpoints.largeTabletMaxWidth.toInt()}',
        screenWidth > _currentBreakpoints.mediumTabletMaxWidth &&
            screenWidth <= _currentBreakpoints.largeTabletMaxWidth,
      ),
      (
        'Desktop',
        '${(_currentBreakpoints.largeTabletMaxWidth + 1).toInt()}',
        '∞',
        screenWidth > _currentBreakpoints.largeTabletMaxWidth,
      ),
    ];

    return Table(
      border: TableBorder.all(color: Colors.grey.shade300),
      children: [
        TableRow(
          decoration: BoxDecoration(color: Colors.grey.shade100),
          children: [
            _buildTableCell('Device Type', isHeader: true),
            _buildTableCell('Min Width (px)', isHeader: true),
            _buildTableCell('Max Width (px)', isHeader: true),
            _buildTableCell('Active', isHeader: true),
          ],
        ),
        ...breakpointData.map(
          (data) => TableRow(
            decoration: BoxDecoration(
              color: data.$4
                  ? Theme.of(context).primaryColor.withOpacity(0.1)
                  : null,
            ),
            children: [
              _buildTableCell(data.$1),
              _buildTableCell(data.$2),
              _buildTableCell(data.$3),
              _buildTableCell(data.$4 ? '✓' : ''),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTableCell(String text, {bool isHeader = false}) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Text(
        text,
        style: TextStyle(
          fontWeight: isHeader ? FontWeight.bold : FontWeight.normal,
          fontSize: 14,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildResponsiveDemo() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Responsive Layout Demo',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            Text(
              'This layout adapts based on your custom breakpoints:',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            _buildAdaptiveLayout(),
          ],
        ),
      ),
    );
  }

  Widget _buildAdaptiveLayout() {
    return ResponsiveBuilder(
      mobile: (context) => _buildMobileLayout(),
      smallTablet: (context) => _buildSmallTabletLayout(),
      mediumTablet: (context) => _buildMediumTabletLayout(),
      largeTablet: (context) => _buildLargeTabletLayout(),
      desktop: (context) => _buildDesktopLayout(),
      watch: (context) => _buildWatchLayout(),
    );
  }

  Widget _buildMobileLayout() {
    return Container(
      height: 200,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.blue),
      ),
      child: Column(
        children: [
          Icon(Icons.smartphone, color: Colors.blue, size: 40),
          const SizedBox(height: 8),
          const Text(
            'Mobile Layout',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 8),
          const Text(
            'Single column, stacked elements',
            textAlign: TextAlign.center,
          ),
          const Spacer(),
          _buildDemoCards(1),
        ],
      ),
    );
  }

  Widget _buildSmallTabletLayout() {
    return Container(
      height: 200,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.green.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.green),
      ),
      child: Column(
        children: [
          Icon(Icons.tablet_android, color: Colors.green, size: 40),
          const SizedBox(height: 8),
          const Text(
            'Small Tablet Layout',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 8),
          const Text('Two columns side by side', textAlign: TextAlign.center),
          const Spacer(),
          _buildDemoCards(2),
        ],
      ),
    );
  }

  Widget _buildMediumTabletLayout() {
    return Container(
      height: 200,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.orange.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.orange),
      ),
      child: Column(
        children: [
          Icon(Icons.tablet, color: Colors.orange, size: 40),
          const SizedBox(height: 8),
          const Text(
            'Medium Tablet Layout',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 8),
          const Text(
            'Three columns with more content',
            textAlign: TextAlign.center,
          ),
          const Spacer(),
          _buildDemoCards(3),
        ],
      ),
    );
  }

  Widget _buildLargeTabletLayout() {
    return Container(
      height: 200,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.purple.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.purple),
      ),
      child: Column(
        children: [
          Icon(Icons.tablet_mac, color: Colors.purple, size: 40),
          const SizedBox(height: 8),
          const Text(
            'Large Tablet Layout',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 8),
          const Text(
            'Four columns, desktop-like experience',
            textAlign: TextAlign.center,
          ),
          const Spacer(),
          _buildDemoCards(4),
        ],
      ),
    );
  }

  Widget _buildDesktopLayout() {
    return Container(
      height: 200,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.indigo.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.indigo),
      ),
      child: Column(
        children: [
          Icon(Icons.computer, color: Colors.indigo, size: 40),
          const SizedBox(height: 8),
          const Text(
            'Desktop Layout',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 8),
          const Text(
            'Maximum columns, full desktop experience',
            textAlign: TextAlign.center,
          ),
          const Spacer(),
          _buildDemoCards(5),
        ],
      ),
    );
  }

  Widget _buildWatchLayout() {
    return Container(
      height: 200,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.red.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.red),
      ),
      child: Column(
        children: [
          Icon(Icons.watch, color: Colors.red, size: 40),
          const SizedBox(height: 8),
          const Text(
            'Watch Layout',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 8),
          const Text('Minimal, single column', textAlign: TextAlign.center),
          const Spacer(),
          _buildDemoCards(1),
        ],
      ),
    );
  }

  Widget _buildDemoCards(int count) {
    return Row(
      children: List.generate(
        count,
        (index) => Expanded(
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: count > 1 ? 2 : 0),
            height: 40,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Center(
              child: Text(
                '${index + 1}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBreakpointVisualization() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Breakpoint Visualization',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            Text(
              'Visual representation of your custom breakpoints:',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            _buildBreakpointBar(),
            const SizedBox(height: 16),
            _buildBreakpointLegend(),
          ],
        ),
      ),
    );
  }

  Widget _buildBreakpointBar() {
    final maxWidth =
        _currentBreakpoints.largeTabletMaxWidth +
        500; // Add some padding for desktop
    final screenWidth = MediaQuery.of(context).size.width;

    return Column(
      children: [
        Container(
          height: 40,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: Stack(
            children: [
              // Mobile section
              Positioned(
                left: 0,
                top: 0,
                bottom: 0,
                width:
                    (_currentBreakpoints.mobileMaxWidth / maxWidth) *
                    MediaQuery.of(context).size.width *
                    0.8,
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(8),
                      bottomLeft: Radius.circular(8),
                    ),
                  ),
                  child: const Center(
                    child: Text(
                      'Mobile',
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
                ),
              ),
              // Small Tablet section
              Positioned(
                left:
                    (_currentBreakpoints.mobileMaxWidth / maxWidth) *
                    MediaQuery.of(context).size.width *
                    0.8,
                top: 0,
                bottom: 0,
                width:
                    ((_currentBreakpoints.smallTabletMaxWidth -
                            _currentBreakpoints.mobileMaxWidth) /
                        maxWidth) *
                    MediaQuery.of(context).size.width *
                    0.8,
                child: Container(
                  color: Colors.green,
                  child: const Center(
                    child: Text(
                      'S.Tablet',
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
                ),
              ),
              // Medium Tablet section
              Positioned(
                left:
                    (_currentBreakpoints.smallTabletMaxWidth / maxWidth) *
                    MediaQuery.of(context).size.width *
                    0.8,
                top: 0,
                bottom: 0,
                width:
                    ((_currentBreakpoints.mediumTabletMaxWidth -
                            _currentBreakpoints.smallTabletMaxWidth) /
                        maxWidth) *
                    MediaQuery.of(context).size.width *
                    0.8,
                child: Container(
                  color: Colors.orange,
                  child: const Center(
                    child: Text(
                      'M.Tablet',
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
                ),
              ),
              // Large Tablet section
              Positioned(
                left:
                    (_currentBreakpoints.mediumTabletMaxWidth / maxWidth) *
                    MediaQuery.of(context).size.width *
                    0.8,
                top: 0,
                bottom: 0,
                width:
                    ((_currentBreakpoints.largeTabletMaxWidth -
                            _currentBreakpoints.mediumTabletMaxWidth) /
                        maxWidth) *
                    MediaQuery.of(context).size.width *
                    0.8,
                child: Container(
                  color: Colors.purple,
                  child: const Center(
                    child: Text(
                      'L.Tablet',
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
                ),
              ),
              // Desktop section
              Positioned(
                left:
                    (_currentBreakpoints.largeTabletMaxWidth / maxWidth) *
                    MediaQuery.of(context).size.width *
                    0.8,
                top: 0,
                bottom: 0,
                right: 0,
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.indigo,
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(8),
                      bottomRight: Radius.circular(8),
                    ),
                  ),
                  child: const Center(
                    child: Text(
                      'Desktop',
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
                ),
              ),
              // Current screen width indicator
              Positioned(
                left:
                    (screenWidth / maxWidth) *
                    MediaQuery.of(context).size.width *
                    0.8,
                top: -10,
                child: Container(
                  width: 2,
                  height: 60,
                  color: Colors.red,
                  child: const Center(
                    child: Icon(
                      Icons.keyboard_arrow_down,
                      color: Colors.red,
                      size: 20,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Current screen width: ${screenWidth.toInt()}px',
          style: const TextStyle(
            fontSize: 12,
            color: Colors.red,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildBreakpointLegend() {
    return Wrap(
      spacing: 16,
      runSpacing: 8,
      children: [
        _buildLegendItem(
          'Mobile',
          Colors.blue,
          '0 - ${_currentBreakpoints.mobileMaxWidth.toInt()}px',
        ),
        _buildLegendItem(
          'Small Tablet',
          Colors.green,
          '${(_currentBreakpoints.mobileMaxWidth + 1).toInt()} - ${_currentBreakpoints.smallTabletMaxWidth.toInt()}px',
        ),
        _buildLegendItem(
          'Medium Tablet',
          Colors.orange,
          '${(_currentBreakpoints.smallTabletMaxWidth + 1).toInt()} - ${_currentBreakpoints.mediumTabletMaxWidth.toInt()}px',
        ),
        _buildLegendItem(
          'Large Tablet',
          Colors.purple,
          '${(_currentBreakpoints.mediumTabletMaxWidth + 1).toInt()} - ${_currentBreakpoints.largeTabletMaxWidth.toInt()}px',
        ),
        _buildLegendItem(
          'Desktop',
          Colors.indigo,
          '${(_currentBreakpoints.largeTabletMaxWidth + 1).toInt()}px+',
        ),
      ],
    );
  }

  Widget _buildLegendItem(String label, Color color, String range) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
            ),
            Text(
              range,
              style: const TextStyle(fontSize: 10, color: Colors.grey),
            ),
          ],
        ),
      ],
    );
  }
}
