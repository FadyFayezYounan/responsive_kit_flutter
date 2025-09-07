import 'package:flutter/material.dart';
import 'package:responsive_kit_flutter/responsive_kit_flutter.dart';

class NavigationExample extends StatefulWidget {
  const NavigationExample({super.key});

  @override
  State<NavigationExample> createState() => _NavigationExampleState();
}

class _NavigationExampleState extends State<NavigationExample> {
  int _selectedIndex = 0;
  final PageController _pageController = PageController();

  final List<NavigationItem> _navigationItems = [
    NavigationItem(
      title: 'Dashboard',
      icon: Icons.dashboard,
      content: 'Dashboard content with analytics and overview information.',
    ),
    NavigationItem(
      title: 'Projects',
      icon: Icons.folder,
      content: 'Project management and file organization tools.',
    ),
    NavigationItem(
      title: 'Messages',
      icon: Icons.message,
      content: 'Communication center with chat and notifications.',
    ),
    NavigationItem(
      title: 'Calendar',
      icon: Icons.calendar_today,
      content: 'Schedule management and event planning.',
    ),
    NavigationItem(
      title: 'Analytics',
      icon: Icons.analytics,
      content: 'Data visualization and reporting dashboard.',
    ),
    NavigationItem(
      title: 'Settings',
      icon: Icons.settings,
      content: 'Application preferences and configuration options.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      mobile: (context) => _buildMobileNavigation(),
      smallTablet: (context) => _buildTabletNavigation(),
      mediumTablet: (context) => _buildTabletNavigation(),
      largeTablet: (context) => _buildDesktopNavigation(),
      desktop: (context) => _buildDesktopNavigation(),
      watch: (context) => _buildWatchNavigation(),
    );
  }

  Widget _buildMobileNavigation() {
    return Scaffold(
      appBar: AppBar(
        title: Text(_navigationItems[_selectedIndex].title),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () => _showSearchDialog(context),
          ),
          PopupMenuButton<int>(
            onSelected: (index) => _navigateToPage(index),
            itemBuilder: (context) => _navigationItems
                .asMap()
                .entries
                .map(
                  (entry) => PopupMenuItem<int>(
                    value: entry.key,
                    child: ListTile(
                      leading: Icon(entry.value.icon),
                      title: Text(entry.value.title),
                    ),
                  ),
                )
                .toList(),
          ),
        ],
      ),
      body: PageView.builder(
        controller: _pageController,
        onPageChanged: (index) => setState(() => _selectedIndex = index),
        itemCount: _navigationItems.length,
        itemBuilder: (context, index) => _buildContent(_navigationItems[index]),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: _navigateToPage,
        items: _navigationItems
            .map(
              (item) => BottomNavigationBarItem(
                icon: Icon(item.icon),
                label: item.title,
              ),
            )
            .toList(),
      ),
    );
  }

  Widget _buildTabletNavigation() {
    return Row(
      children: [
        SizedBox(
          width: 280,
          child: NavigationRail(
            extended: true,
            selectedIndex: _selectedIndex,
            onDestinationSelected: _navigateToPage,
            destinations: _navigationItems
                .map(
                  (item) => NavigationRailDestination(
                    icon: Icon(item.icon),
                    label: Text(item.title),
                  ),
                )
                .toList(),
          ),
        ),
        const VerticalDivider(thickness: 1, width: 1),
        Expanded(
          child: Column(
            children: [
              _buildTabletHeader(),
              Expanded(child: _buildContent(_navigationItems[_selectedIndex])),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDesktopNavigation() {
    return Row(
      children: [
        SizedBox(
          width: 250,
          child: Material(
            elevation: 2,
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      const Icon(Icons.widgets, size: 32),
                      const SizedBox(width: 12),
                      Text(
                        'ResponsiveKit',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ],
                  ),
                ),
                const Divider(height: 1),
                Expanded(
                  child: ListView.builder(
                    itemCount: _navigationItems.length,
                    itemBuilder: (context, index) {
                      final item = _navigationItems[index];
                      return ListTile(
                        selected: _selectedIndex == index,
                        leading: Icon(item.icon),
                        title: Text(item.title),
                        onTap: () => _navigateToPage(index),
                        hoverColor: Theme.of(context).hoverColor,
                      );
                    },
                  ),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.account_circle),
                  title: const Text('Profile'),
                  onTap: () => _showProfileDialog(context),
                ),
              ],
            ),
          ),
        ),
        Expanded(
          child: Column(
            children: [
              _buildDesktopHeader(),
              Expanded(child: _buildContent(_navigationItems[_selectedIndex])),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildWatchNavigation() {
    return Scaffold(
      body: PageView.builder(
        controller: _pageController,
        onPageChanged: (index) => setState(() => _selectedIndex = index),
        itemCount: _navigationItems.length,
        itemBuilder: (context, index) {
          final item = _navigationItems[index];
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(item.icon, size: 48),
                const SizedBox(height: 8),
                Text(
                  item.title,
                  style: Theme.of(context).textTheme.titleMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Text(
                  'Swipe for more',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildTabletHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        border: Border(
          bottom: BorderSide(color: Theme.of(context).dividerColor),
        ),
      ),
      child: Row(
        children: [
          Text(
            _navigationItems[_selectedIndex].title,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const Spacer(),
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () => _showSearchDialog(context),
          ),
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () => _showOptionsDialog(context),
          ),
        ],
      ),
    );
  }

  Widget _buildDesktopHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        border: Border(
          bottom: BorderSide(color: Theme.of(context).dividerColor),
        ),
      ),
      child: Row(
        children: [
          Text(
            _navigationItems[_selectedIndex].title,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const Spacer(),
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () => _showSearchDialog(context),
            tooltip: 'Search',
          ),
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () => _showNotificationsDialog(context),
            tooltip: 'Notifications',
          ),
          IconButton(
            icon: const Icon(Icons.help_outline),
            onPressed: () => _showHelpDialog(context),
            tooltip: 'Help',
          ),
          const SizedBox(width: 8),
          CircleAvatar(
            radius: 16,
            child: Text('U', style: Theme.of(context).textTheme.bodyMedium),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(NavigationItem item) {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(item.icon, size: 32, color: Theme.of(context).primaryColor),
              const SizedBox(width: 16),
              Text(
                item.title,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            ],
          ),
          const SizedBox(height: 24),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Content Area',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(item.content),
                  const SizedBox(height: 16),
                  _buildAdaptiveButtonBar(),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          _buildDeviceSpecificFeatures(),
        ],
      ),
    );
  }

  Widget _buildAdaptiveButtonBar() {
    final deviceType = ResponsiveKit.deviceTypeOf(context);

    return ResponsiveBuilder(
      mobile: (context) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ElevatedButton(onPressed: () {}, child: const Text('Primary Action')),
          const SizedBox(height: 8),
          OutlinedButton(
            onPressed: () {},
            child: const Text('Secondary Action'),
          ),
        ],
      ),
      tablet: (context) => Row(
        children: [
          ElevatedButton(onPressed: () {}, child: const Text('Primary Action')),
          const SizedBox(width: 8),
          OutlinedButton(
            onPressed: () {},
            child: const Text('Secondary Action'),
          ),
          const Spacer(),
          TextButton(onPressed: () {}, child: const Text('More Options')),
        ],
      ),
      desktop: (context) => Row(
        children: [
          ElevatedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.save),
            label: const Text('Primary Action'),
          ),
          const SizedBox(width: 8),
          OutlinedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.edit),
            label: const Text('Secondary Action'),
          ),
          const SizedBox(width: 8),
          TextButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.more_horiz),
            label: const Text('More Options'),
          ),
          const Spacer(),
          if (deviceType.supportsHover)
            Tooltip(
              message: 'Desktop-specific feature',
              child: IconButton(
                onPressed: () {},
                icon: const Icon(Icons.help_outline),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildDeviceSpecificFeatures() {
    return ResponsiveVisibility(
      showOnMobile: false,
      builder: (context) => Card(
        color: Theme.of(context).colorScheme.surfaceVariant,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Device-Specific Features',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              const Text(
                'This content is only visible on tablets and larger screens.',
              ),
              const SizedBox(height: 12),
              ResponsiveVisibility.desktop(
                builder: (context) => const Text(
                  '🖥️ Desktop: Hover effects, keyboard shortcuts, and advanced features available.',
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _navigateToPage(int index) {
    setState(() => _selectedIndex = index);
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _showSearchDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Search'),
        content: const TextField(
          decoration: InputDecoration(
            hintText: 'Enter search terms...',
            prefixIcon: Icon(Icons.search),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Search'),
          ),
        ],
      ),
    );
  }

  void _showOptionsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Options'),
        content: const Text(
          'Additional options and settings would be shown here.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showNotificationsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Notifications'),
        content: const Text(
          'Recent notifications and updates would be displayed here.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showHelpDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Help'),
        content: const Text(
          'Help documentation and support resources would be available here.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showProfileDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Profile'),
        content: const Text(
          'User profile settings and information would be shown here.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}

class NavigationItem {
  final String title;
  final IconData icon;
  final String content;

  NavigationItem({
    required this.title,
    required this.icon,
    required this.content,
  });
}
