import 'package:flutter/material.dart';
import '../constants/app_theme.dart';
import '../models/cryptocurrency.dart';
import '../widgets/crypto_list_item.dart';

class MarketScreen extends StatefulWidget {
  const MarketScreen({Key? key}) : super(key: key);

  @override
  State<MarketScreen> createState() => _MarketScreenState();
}

class _MarketScreenState extends State<MarketScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.darkBackground,
      appBar: AppBar(
        backgroundColor: AppTheme.darkBackground,
        elevation: 0,
        title: const Text(
          'Markets',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppTheme.textWhite,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48),
          child: TabBar(
            controller: _tabController,
            isScrollable: true,
            labelColor: AppTheme.textWhite,
            unselectedLabelColor: AppTheme.textGrey,
            indicatorColor: AppTheme.primaryColor,
            tabs: const [
              Tab(text: 'All'),
              Tab(text: 'Spot'),
              Tab(text: 'Futures'),
              Tab(text: 'New'),
            ],
          ),
        ),
      ),
      body: Column(
        children: [
          _buildSearchBar(),
          _buildCategoryFilters(),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildCryptoList(),
                _buildCryptoList(), // Placeholder for Spot tab
                _buildCryptoList(), // Placeholder for Futures tab
                _buildCryptoList(), // Placeholder for New tab
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: TextField(
        controller: _searchController,
        style: const TextStyle(color: AppTheme.textWhite),
        decoration: InputDecoration(
          hintText: 'Search tokens',
          hintStyle: const TextStyle(color: AppTheme.textGrey),
          prefixIcon: const Icon(Icons.search, color: AppTheme.textGrey),
          filled: true,
          fillColor: AppTheme.cardLightBackground,
          contentPadding: const EdgeInsets.symmetric(vertical: 0),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryFilters() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        children: [
          _buildFilterChip('All', true),
          _buildFilterChip('Gainers', false),
          _buildFilterChip('Losers', false),
          _buildFilterChip('Volume', false),
          _buildFilterChip('Market Cap', false),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, bool isSelected) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      child: FilterChip(
        selected: isSelected,
        showCheckmark: false,
        selectedColor: AppTheme.primaryColor.withOpacity(0.2),
        backgroundColor: AppTheme.cardDarkBackground,
        label: Text(label),
        labelStyle: TextStyle(
          color: isSelected ? AppTheme.primaryColor : AppTheme.textGrey,
          fontSize: 14,
        ),
        onSelected: (value) {
          // Implement filter selection
        },
      ),
    );
  }

  Widget _buildCryptoList() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildTableHeader(),
        const SizedBox(height: 8),
        ...Cryptocurrency.mockData.map((crypto) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: CryptoListItem(
              crypto: crypto,
              onTap: () {
                // Navigate to detail page
              },
            ),
          );
        }).toList(),
      ],
    );
  }

  Widget _buildTableHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          const SizedBox(width: 40), // Space for icon
          const SizedBox(width: 12),
          const Expanded(
            flex: 3,
            child: Text(
              'Name',
              style: TextStyle(
                color: AppTheme.textGrey,
                fontSize: 12,
              ),
            ),
          ),
          const SizedBox(width: 12),
          const Expanded(
            flex: 3,
            child: Text(
              '24h',
              style: TextStyle(
                color: AppTheme.textGrey,
                fontSize: 12,
              ),
            ),
          ),
          const SizedBox(width: 12),
          const Expanded(
            flex: 3,
            child: Align(
              alignment: Alignment.centerRight,
              child: Text(
                'Price',
                style: TextStyle(
                  color: AppTheme.textGrey,
                  fontSize: 12,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
