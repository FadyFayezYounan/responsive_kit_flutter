import 'package:flutter/material.dart';
import 'package:responsive_kit_flutter/responsive_kit_flutter.dart';

void main() {
  runApp(const ResponsiveKitExampleApp());
}

class ResponsiveKitExampleApp extends StatelessWidget {
  const ResponsiveKitExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveKit(
      child: MaterialApp(
        title: 'ResponsiveKit Examples',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const MainScreen(),
      ),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  final List<ExampleTab> _examples = [
    ExampleTab(title: 'Device Info', icon: Icons.info),
    ExampleTab(title: 'Layout', icon: Icons.dashboard),
    ExampleTab(title: 'Visibility', icon: Icons.visibility),
    ExampleTab(title: 'Grid', icon: Icons.grid_view),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ResponsiveKit Examples'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: ResponsiveBuilder(
        mobile: (context) => _buildMobileLayout(),
        smallTablet: (context) => _buildTabletLayout(),
        mediumTablet: (context) => _buildTabletLayout(),
        largeTablet: (context) => _buildDesktopLayout(),
        desktop: (context) => _buildDesktopLayout(),
        watch: (context) => _buildWatchLayout(),
      ),
      bottomNavigationBar: ResponsiveVisibility(
        showOnMobile: true,
        showOnSmallTablet: false,
        showOnMediumTablet: false,
        showOnLargeTablet: false,
        showOnDesktop: false,
        showOnWatch: true,
        builder: (context) => BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: _selectedIndex,
          onTap: (index) => setState(() => _selectedIndex = index),
          items: _examples
              .map(
                (e) =>
                    BottomNavigationBarItem(icon: Icon(e.icon), label: e.title),
              )
              .toList(),
        ),
      ),
    );
  }

  Widget _buildMobileLayout() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: _getSelectedExample(),
    );
  }

  Widget _buildTabletLayout() {
    return Row(
      children: [
        NavigationRail(
          selectedIndex: _selectedIndex,
          onDestinationSelected: (index) =>
              setState(() => _selectedIndex = index),
          destinations: _examples
              .map(
                (e) => NavigationRailDestination(
                  icon: Icon(e.icon),
                  label: Text(e.title),
                ),
              )
              .toList(),
        ),
        const VerticalDivider(thickness: 1, width: 1),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: _getSelectedExample(),
          ),
        ),
      ],
    );
  }

  Widget _buildDesktopLayout() {
    return Row(
      children: [
        SizedBox(
          width: 250,
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                child: const Text(
                  'Examples',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: _examples.length,
                  itemBuilder: (context, index) => ListTile(
                    leading: Icon(_examples[index].icon),
                    title: Text(_examples[index].title),
                    selected: _selectedIndex == index,
                    onTap: () => setState(() => _selectedIndex = index),
                  ),
                ),
              ),
            ],
          ),
        ),
        const VerticalDivider(thickness: 1, width: 1),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: _getSelectedExample(),
          ),
        ),
      ],
    );
  }

  Widget _buildWatchLayout() {
    return PageView(
      children: [
        for (int i = 0; i < _examples.length; i++)
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(_examples[i].icon, size: 16),
                    const SizedBox(width: 4),
                    Text(
                      _examples[i].title,
                      style: const TextStyle(fontSize: 12),
                    ),
                  ],
                ),
              ),
              Expanded(child: _getExampleByIndex(i)),
            ],
          ),
      ],
    );
  }

  Widget _getSelectedExample() {
    return _getExampleByIndex(_selectedIndex);
  }

  Widget _getExampleByIndex(int index) {
    switch (index) {
      case 0:
        return const DeviceInfoExample();
      case 1:
        return const ResponsiveLayoutExample();
      case 2:
        return const VisibilityExample();
      case 3:
        return const GridExample();
      default:
        return const DeviceInfoExample();
    }
  }
}

// Simple inline examples
class DeviceInfoExample extends StatelessWidget {
  const DeviceInfoExample({super.key});

  @override
  Widget build(BuildContext context) {
    final deviceType = ResponsiveKit.deviceTypeOf(context);
    final size = MediaQuery.of(context).size;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Device Information',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),
            _buildInfoRow('Device Type', deviceType.runtimeType.toString()),
            _buildInfoRow(
              'Screen Size',
              '${size.width.toInt()} × ${size.height.toInt()}',
            ),
            _buildInfoRow(
              'Aspect Ratio',
              '${(size.width / size.height).toStringAsFixed(2)}:1',
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(
                    _getDeviceIcon(deviceType),
                    color: Theme.of(context).primaryColor,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'This is detected as: ${deviceType.runtimeType}',
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.bold,
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

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          Text(value),
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
}

class ResponsiveLayoutExample extends StatelessWidget {
  const ResponsiveLayoutExample({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      mobile: (context) => _buildMobileLayout(),
      smallTablet: (context) => _buildTabletLayout(),
      mediumTablet: (context) => _buildTabletLayout(),
      largeTablet: (context) => _buildDesktopLayout(),
      desktop: (context) => _buildDesktopLayout(),
      watch: (context) => _buildWatchLayout(),
    );
  }

  Widget _buildMobileLayout() {
    return const Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(Icons.smartphone, size: 48, color: Colors.blue),
            SizedBox(height: 8),
            Text(
              'Mobile Layout',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text('Single column, stacked elements for easy thumb navigation'),
            SizedBox(height: 16),
            _DemoCard(color: Colors.blue, text: 'Main Content'),
            SizedBox(height: 8),
            _DemoCard(color: Colors.green, text: 'Secondary'),
          ],
        ),
      ),
    );
  }

  Widget _buildTabletLayout() {
    return const Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Icon(Icons.tablet, size: 48, color: Colors.green),
                SizedBox(width: 8),
                Text(
                  'Tablet Layout',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(height: 16),
            Text('Two column layout with side-by-side content'),
            SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _DemoCard(color: Colors.blue, text: 'Main'),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: _DemoCard(color: Colors.green, text: 'Side'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDesktopLayout() {
    return const Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Icon(Icons.computer, size: 48, color: Colors.purple),
                SizedBox(width: 8),
                Text(
                  'Desktop Layout',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(height: 16),
            Text('Three column layout for maximum screen utilization'),
            SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _DemoCard(color: Colors.blue, text: 'Sidebar'),
                ),
                SizedBox(width: 8),
                Expanded(
                  flex: 2,
                  child: _DemoCard(color: Colors.green, text: 'Main Content'),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: _DemoCard(color: Colors.orange, text: 'Panel'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWatchLayout() {
    return const Card(
      child: Padding(
        padding: EdgeInsets.all(8),
        child: Column(
          children: [
            Icon(Icons.watch, size: 32, color: Colors.red),
            SizedBox(height: 4),
            Text(
              'Watch',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            _DemoCard(color: Colors.red, text: 'Minimal UI'),
          ],
        ),
      ),
    );
  }
}

class VisibilityExample extends StatelessWidget {
  const VisibilityExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Responsive Visibility',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),
            const Text(
              'Different elements are shown/hidden based on device type:',
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
                  builder: (context) => const Chip(
                    label: Text('Mobile & Watch Only'),
                    backgroundColor: Colors.blue,
                  ),
                ),
                ResponsiveVisibility(
                  showOnMobile: false,
                  showOnSmallTablet: true,
                  showOnMediumTablet: true,
                  showOnLargeTablet: true,
                  showOnDesktop: false,
                  showOnWatch: false,
                  builder: (context) => const Chip(
                    label: Text('Tablet Only'),
                    backgroundColor: Colors.green,
                  ),
                ),
                ResponsiveVisibility(
                  showOnMobile: false,
                  showOnSmallTablet: false,
                  showOnMediumTablet: false,
                  showOnLargeTablet: false,
                  showOnDesktop: true,
                  showOnWatch: false,
                  builder: (context) => const Chip(
                    label: Text('Desktop Only'),
                    backgroundColor: Colors.purple,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class GridExample extends StatelessWidget {
  const GridExample({super.key});

  @override
  Widget build(BuildContext context) {
    final deviceType = ResponsiveKit.deviceTypeOf(context);
    final columns = deviceType.when(
      mobile: () => 1,
      smallTablet: () => 2,
      mediumTablet: () => 3,
      largeTablet: () => 4,
      desktop: () => 5,
      watch: () => 1,
    );

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Responsive Grid ($columns columns)',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),
            Expanded(
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: columns,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                  childAspectRatio: 1.2,
                ),
                itemCount: 12,
                itemBuilder: (context, index) => Container(
                  decoration: BoxDecoration(
                    color: Colors.primaries[index % Colors.primaries.length]
                        .withOpacity(0.3),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Text(
                      '${index + 1}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DemoCard extends StatelessWidget {
  final Color color;
  final String text;

  const _DemoCard({required this.color, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color),
      ),
      child: Center(
        child: Text(
          text,
          style: TextStyle(color: color, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}

class ExampleTab {
  final String title;
  final IconData icon;

  ExampleTab({required this.title, required this.icon});
}
