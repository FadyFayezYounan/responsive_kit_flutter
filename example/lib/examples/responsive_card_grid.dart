import 'package:flutter/material.dart';
import 'package:responsive_kit_flutter/responsive_kit_flutter.dart';

class ResponsiveCardGrid extends StatelessWidget {
  const ResponsiveCardGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(context),
          const SizedBox(height: 16),
          Expanded(child: _buildResponsiveGrid(context)),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final deviceType = ResponsiveKit.deviceTypeOf(context);
    final crossAxisCount = _getCrossAxisCount(deviceType);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Responsive Grid Layout',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              'This grid adapts its column count based on the device type:',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'Current device: ${deviceType.runtimeType} → $crossAxisCount columns',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: Theme.of(context).primaryColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResponsiveGrid(BuildContext context) {
    final deviceType = ResponsiveKit.deviceTypeOf(context);
    final crossAxisCount = _getCrossAxisCount(deviceType);

    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: _getChildAspectRatio(deviceType),
      ),
      itemCount: 24, // Sample item count
      itemBuilder: (context, index) => _buildGridItem(context, index),
    );
  }

  int _getCrossAxisCount(DeviceType deviceType) {
    return deviceType.when(
      mobile: () => 1,
      smallTablet: () => 2,
      mediumTablet: () => 3,
      largeTablet: () => 4,
      desktop: () => 5,
      watch: () => 1,
    );
  }

  double _getChildAspectRatio(DeviceType deviceType) {
    return deviceType.when(
      mobile: () => 1.2, // Wider cards for mobile
      smallTablet: () => 1.0,
      mediumTablet: () => 0.9,
      largeTablet: () => 0.8,
      desktop: () => 0.7, // Taller cards for desktop
      watch: () => 1.5, // Very wide for watch
    );
  }

  Widget _buildGridItem(BuildContext context, int index) {
    final deviceType = ResponsiveKit.deviceTypeOf(context);
    final cardData = _getCardData(index);

    return Card(
      elevation: 3,
      child: InkWell(
        onTap: () => _showCardDetails(context, cardData),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildCardHeader(cardData, deviceType),
              const SizedBox(height: 12),
              Expanded(child: _buildCardContent(context, cardData, deviceType)),
              _buildCardFooter(cardData, deviceType),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCardHeader(CardData cardData, DeviceType deviceType) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: cardData.color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            cardData.icon,
            color: cardData.color,
            size: deviceType.when(
              mobile: () => 24.0,
              smallTablet: () => 22.0,
              mediumTablet: () => 20.0,
              largeTablet: () => 18.0,
              desktop: () => 16.0,
              watch: () => 20.0,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            cardData.title,
            style: TextStyle(
              fontSize: deviceType.when(
                mobile: () => 16.0,
                smallTablet: () => 15.0,
                mediumTablet: () => 14.0,
                largeTablet: () => 13.0,
                desktop: () => 12.0,
                watch: () => 14.0,
              ),
              fontWeight: FontWeight.bold,
            ),
            maxLines: deviceType.when(
              mobile: () => 2,
              smallTablet: () => 2,
              mediumTablet: () => 1,
              largeTablet: () => 1,
              desktop: () => 1,
              watch: () => 1,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildCardContent(
    BuildContext context,
    CardData cardData,
    DeviceType deviceType,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          cardData.description,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            fontSize: deviceType.when(
              mobile: () => 14.0,
              smallTablet: () => 13.0,
              mediumTablet: () => 12.0,
              largeTablet: () => 11.0,
              desktop: () => 10.0,
              watch: () => 12.0,
            ),
          ),
          maxLines: deviceType.when(
            mobile: () => 3,
            smallTablet: () => 2,
            mediumTablet: () => 2,
            largeTablet: () => 2,
            desktop: () => 3,
            watch: () => 2,
          ),
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 8),
        // Show additional content only on larger screens
        ResponsiveVisibility(
          showOnMobile: false,
          showOnWatch: false,
          builder: (context) => Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: cardData.color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              cardData.category,
              style: TextStyle(
                fontSize: 10,
                color: cardData.color,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCardFooter(CardData cardData, DeviceType deviceType) {
    return ResponsiveBuilder(
      mobile: (context) => _buildMobileFooter(cardData),
      smallTablet: (context) => _buildTabletFooter(cardData),
      mediumTablet: (context) => _buildTabletFooter(cardData),
      largeTablet: (context) => _buildDesktopFooter(cardData),
      desktop: (context) => _buildDesktopFooter(cardData),
      watch: (context) => _buildWatchFooter(cardData),
    );
  }

  Widget _buildMobileFooter(CardData cardData) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          cardData.value,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey.shade600),
      ],
    );
  }

  Widget _buildTabletFooter(CardData cardData) {
    return Row(
      children: [
        Text(
          cardData.value,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
        const Spacer(),
        Text(
          cardData.trend,
          style: TextStyle(
            fontSize: 12,
            color: cardData.trendPositive ? Colors.green : Colors.red,
          ),
        ),
      ],
    );
  }

  Widget _buildDesktopFooter(CardData cardData) {
    return Row(
      children: [
        Expanded(
          child: Text(
            cardData.value,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
          ),
        ),
        Icon(
          cardData.trendPositive ? Icons.trending_up : Icons.trending_down,
          size: 14,
          color: cardData.trendPositive ? Colors.green : Colors.red,
        ),
        const SizedBox(width: 4),
        Text(
          cardData.trend,
          style: TextStyle(
            fontSize: 10,
            color: cardData.trendPositive ? Colors.green : Colors.red,
          ),
        ),
      ],
    );
  }

  Widget _buildWatchFooter(CardData cardData) {
    return Center(
      child: Text(
        cardData.value,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
      ),
    );
  }

  CardData _getCardData(int index) {
    final sampleData = [
      CardData(
        title: 'Revenue',
        description: 'Total revenue for this month',
        value: '\$12,345',
        trend: '+12%',
        trendPositive: true,
        category: 'Finance',
        icon: Icons.attach_money,
        color: Colors.green,
      ),
      CardData(
        title: 'Users',
        description: 'Active users this week',
        value: '8,901',
        trend: '+5%',
        trendPositive: true,
        category: 'Analytics',
        icon: Icons.people,
        color: Colors.blue,
      ),
      CardData(
        title: 'Orders',
        description: 'New orders today',
        value: '234',
        trend: '-2%',
        trendPositive: false,
        category: 'Sales',
        icon: Icons.shopping_cart,
        color: Colors.orange,
      ),
      CardData(
        title: 'Performance',
        description: 'System performance score',
        value: '98.5%',
        trend: '+1%',
        trendPositive: true,
        category: 'System',
        icon: Icons.speed,
        color: Colors.purple,
      ),
      CardData(
        title: 'Storage',
        description: 'Available storage space',
        value: '2.3 TB',
        trend: '-5%',
        trendPositive: false,
        category: 'System',
        icon: Icons.storage,
        color: Colors.teal,
      ),
      CardData(
        title: 'Messages',
        description: 'Unread messages',
        value: '47',
        trend: '+8%',
        trendPositive: true,
        category: 'Communication',
        icon: Icons.message,
        color: Colors.indigo,
      ),
    ];

    return sampleData[index % sampleData.length];
  }

  void _showCardDetails(BuildContext context, CardData cardData) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(cardData.icon, color: cardData.color),
            const SizedBox(width: 8),
            Text(cardData.title),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(cardData.description),
            const SizedBox(height: 16),
            Text(
              'Value: ${cardData.value}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            Text('Trend: ${cardData.trend}'),
            Text('Category: ${cardData.category}'),
          ],
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

class CardData {
  final String title;
  final String description;
  final String value;
  final String trend;
  final bool trendPositive;
  final String category;
  final IconData icon;
  final Color color;

  CardData({
    required this.title,
    required this.description,
    required this.value,
    required this.trend,
    required this.trendPositive,
    required this.category,
    required this.icon,
    required this.color,
  });
}
