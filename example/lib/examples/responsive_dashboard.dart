import 'package:flutter/material.dart';
import 'package:responsive_kit_flutter/responsive_kit_flutter.dart';

class ResponsiveDashboard extends StatefulWidget {
  const ResponsiveDashboard({super.key});

  @override
  State<ResponsiveDashboard> createState() => _ResponsiveDashboardState();
}

class _ResponsiveDashboardState extends State<ResponsiveDashboard> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      mobile: (context) => _buildMobileDashboard(),
      smallTablet: (context) => _buildTabletDashboard(),
      mediumTablet: (context) => _buildTabletDashboard(),
      largeTablet: (context) => _buildDesktopDashboard(),
      desktop: (context) => _buildDesktopDashboard(),
      watch: (context) => _buildWatchDashboard(),
    );
  }

  Widget _buildMobileDashboard() {
    return Column(
      children: [
        _buildStatsCards(1),
        const SizedBox(height: 16),
        Expanded(child: _buildChartSection()),
      ],
    );
  }

  Widget _buildTabletDashboard() {
    return Column(
      children: [
        _buildStatsCards(2),
        const SizedBox(height: 16),
        Expanded(
          child: Row(
            children: [
              Expanded(flex: 2, child: _buildChartSection()),
              const SizedBox(width: 16),
              Expanded(child: _buildActivityFeed()),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDesktopDashboard() {
    return Column(
      children: [
        _buildStatsCards(4),
        const SizedBox(height: 16),
        Expanded(
          child: Row(
            children: [
              Expanded(
                flex: 3,
                child: Column(
                  children: [
                    Expanded(flex: 2, child: _buildChartSection()),
                    const SizedBox(height: 16),
                    Expanded(child: _buildQuickActions()),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  children: [
                    Expanded(child: _buildActivityFeed()),
                    const SizedBox(height: 16),
                    Expanded(child: _buildNotifications()),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildWatchDashboard() {
    return Column(
      children: [
        _buildStatsCards(1),
        const SizedBox(height: 8),
        Expanded(child: _buildSimpleMetrics()),
      ],
    );
  }

  Widget _buildStatsCards(int columns) {
    final stats = [
      DashboardStat(
        title: 'Total Sales',
        value: '\$45,231',
        change: '+12%',
        positive: true,
        icon: Icons.trending_up,
        color: Colors.green,
      ),
      DashboardStat(
        title: 'New Orders',
        value: '1,234',
        change: '+8%',
        positive: true,
        icon: Icons.shopping_cart,
        color: Colors.blue,
      ),
      DashboardStat(
        title: 'Active Users',
        value: '12,345',
        change: '-2%',
        positive: false,
        icon: Icons.people,
        color: Colors.orange,
      ),
      DashboardStat(
        title: 'Conversion',
        value: '3.2%',
        change: '+0.5%',
        positive: true,
        icon: Icons.percent,
        color: Colors.purple,
      ),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final deviceType = ResponsiveKit.deviceTypeOf(context);
        final itemWidth =
            (constraints.maxWidth - (16 * (columns - 1))) / columns;

        return Wrap(
          spacing: 16,
          runSpacing: 16,
          children: stats
              .take(columns == 1 ? 2 : stats.length)
              .map(
                (stat) => SizedBox(
                  width: columns == 1 ? constraints.maxWidth : itemWidth,
                  child: _buildStatCard(stat, deviceType),
                ),
              )
              .toList(),
        );
      },
    );
  }

  Widget _buildStatCard(DashboardStat stat, DeviceType deviceType) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: EdgeInsets.all(
          deviceType.when(
            mobile: () => 16.0,
            smallTablet: () => 14.0,
            mediumTablet: () => 12.0,
            largeTablet: () => 10.0,
            desktop: () => 12.0,
            watch: () => 8.0,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: stat.color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    stat.icon,
                    color: stat.color,
                    size: deviceType.when(
                      mobile: () => 24.0,
                      smallTablet: () => 20.0,
                      mediumTablet: () => 18.0,
                      largeTablet: () => 16.0,
                      desktop: () => 20.0,
                      watch: () => 16.0,
                    ),
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: stat.positive
                        ? Colors.green.withOpacity(0.1)
                        : Colors.red.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    stat.change,
                    style: TextStyle(
                      color: stat.positive ? Colors.green : Colors.red,
                      fontWeight: FontWeight.w600,
                      fontSize: deviceType.when(
                        mobile: () => 12.0,
                        smallTablet: () => 11.0,
                        mediumTablet: () => 10.0,
                        largeTablet: () => 9.0,
                        desktop: () => 10.0,
                        watch: () => 8.0,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: deviceType.when(
                mobile: () => 12.0,
                smallTablet: () => 10.0,
                mediumTablet: () => 8.0,
                largeTablet: () => 6.0,
                desktop: () => 8.0,
                watch: () => 4.0,
              ),
            ),
            Text(
              stat.title,
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: deviceType.when(
                  mobile: () => 14.0,
                  smallTablet: () => 13.0,
                  mediumTablet: () => 12.0,
                  largeTablet: () => 11.0,
                  desktop: () => 12.0,
                  watch: () => 10.0,
                ),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              stat.value,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: deviceType.when(
                  mobile: () => 24.0,
                  smallTablet: () => 20.0,
                  mediumTablet: () => 18.0,
                  largeTablet: () => 16.0,
                  desktop: () => 20.0,
                  watch: () => 14.0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChartSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Sales Overview',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                ResponsiveVisibility(
                  showOnMobile: false,
                  showOnWatch: false,
                  builder: (context) => DropdownButton<String>(
                    value: 'Last 7 days',
                    items: ['Last 7 days', 'Last 30 days', 'Last 3 months']
                        .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                        .toList(),
                    onChanged: (value) {},
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(child: _buildMockChart()),
          ],
        ),
      ),
    );
  }

  Widget _buildMockChart() {
    final deviceType = ResponsiveKit.deviceTypeOf(context);
    final barCount = deviceType.when(
      mobile: () => 7,
      smallTablet: () => 12,
      mediumTablet: () => 15,
      largeTablet: () => 20,
      desktop: () => 30,
      watch: () => 5,
    );

    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: List.generate(barCount, (index) {
        final height = 20 + (index * 3) % 80;
        return Expanded(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 1),
            height: height.toDouble(),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor.withOpacity(0.7),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(2),
                topRight: Radius.circular(2),
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildActivityFeed() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Recent Activity',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.separated(
                itemCount: 5,
                separatorBuilder: (context, index) => const Divider(),
                itemBuilder: (context, index) => _buildActivityItem(index),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActivityItem(int index) {
    final activities = [
      'New order #1234 received',
      'User John Doe registered',
      'Payment of \$299 processed',
      'Product review submitted',
      'Inventory updated',
    ];

    final icons = [
      Icons.shopping_bag,
      Icons.person_add,
      Icons.payment,
      Icons.star,
      Icons.inventory,
    ];

    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
        child: Icon(
          icons[index],
          color: Theme.of(context).primaryColor,
          size: 20,
        ),
      ),
      title: Text(activities[index], style: const TextStyle(fontSize: 14)),
      subtitle: Text(
        '${index + 1} hour${index == 0 ? '' : 's'} ago',
        style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
      ),
    );
  }

  Widget _buildQuickActions() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Quick Actions',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            Expanded(
              child: GridView.count(
                crossAxisCount: 4,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
                children: [
                  _buildActionButton('Add Product', Icons.add_box, Colors.blue),
                  _buildActionButton(
                    'View Orders',
                    Icons.list_alt,
                    Colors.green,
                  ),
                  _buildActionButton(
                    'Analytics',
                    Icons.analytics,
                    Colors.purple,
                  ),
                  _buildActionButton('Settings', Icons.settings, Colors.orange),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(String label, IconData icon, Color color) {
    return InkWell(
      onTap: () {},
      borderRadius: BorderRadius.circular(8),
      child: Container(
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                color: color,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotifications() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Notifications',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    '3',
                    style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView(
                children: [
                  _buildNotificationItem(
                    'Low inventory alert',
                    'Product XYZ has only 5 items left',
                    Icons.warning,
                    Colors.orange,
                  ),
                  _buildNotificationItem(
                    'New message',
                    'Customer support ticket #456',
                    Icons.message,
                    Colors.blue,
                  ),
                  _buildNotificationItem(
                    'System update',
                    'Scheduled maintenance at 2 AM',
                    Icons.system_update,
                    Colors.green,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationItem(
    String title,
    String message,
    IconData icon,
    Color color,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.05),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  message,
                  style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSimpleMetrics() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Text(
              'Today\'s Stats',
              style: Theme.of(context).textTheme.titleSmall,
            ),
            const SizedBox(height: 12),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildSimpleMetric(
                    'Sales',
                    '\$1,234',
                    Icons.attach_money,
                    Colors.green,
                  ),
                  _buildSimpleMetric(
                    'Orders',
                    '45',
                    Icons.shopping_cart,
                    Colors.blue,
                  ),
                  _buildSimpleMetric(
                    'Users',
                    '89',
                    Icons.people,
                    Colors.purple,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSimpleMetric(
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Row(
      children: [
        Icon(icon, color: color, size: 16),
        const SizedBox(width: 8),
        Text(label, style: const TextStyle(fontSize: 12)),
        const Spacer(),
        Text(
          value,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
        ),
      ],
    );
  }
}

class DashboardStat {
  final String title;
  final String value;
  final String change;
  final bool positive;
  final IconData icon;
  final Color color;

  DashboardStat({
    required this.title,
    required this.value,
    required this.change,
    required this.positive,
    required this.icon,
    required this.color,
  });
}
