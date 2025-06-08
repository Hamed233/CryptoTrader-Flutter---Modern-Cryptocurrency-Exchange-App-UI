import 'package:flutter/material.dart';
import '../constants/app_theme.dart';
import '../models/cryptocurrency.dart';
import '../widgets/crypto_list_item.dart';

class WalletScreen extends StatelessWidget {
  const WalletScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.darkBackground,
      appBar: AppBar(
        backgroundColor: AppTheme.darkBackground,
        elevation: 0,
        title: const Text(
          'Wallet',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppTheme.textWhite,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.history, color: AppTheme.textWhite),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.qr_code_scanner, color: AppTheme.textWhite),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildWalletBalanceCard(),
            _buildQuickActions(),
            _buildAssetCategoryTabs(),
            _buildAssetsList(),
          ],
        ),
      ),
    );
  }

  Widget _buildWalletBalanceCard() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: const LinearGradient(
          colors: [Color(0xFF2151F5), Color(0xFF4D78FF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total Balance',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Icon(
                Icons.visibility,
                color: Colors.white,
                size: 16,
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '\$24,518.32',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(width: 8),
              Text(
                'USD',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _buildBalanceMetric('+\$1,824.32', '24h Change'),
              const SizedBox(width: 24),
              _buildBalanceMetric('+7.25%', '24h %'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBalanceMetric(String value, String label) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildQuickActions() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildActionButton(Icons.arrow_downward_rounded, 'Deposit'),
          _buildActionButton(Icons.arrow_upward_rounded, 'Withdraw'),
          _buildActionButton(Icons.swap_horiz_rounded, 'Swap'),
          _buildActionButton(Icons.history, 'History'),
        ],
      ),
    );
  }

  Widget _buildActionButton(IconData icon, String label) {
    return Column(
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: AppTheme.cardDarkBackground,
            borderRadius: BorderRadius.circular(25),
          ),
          child: Icon(
            icon,
            color: AppTheme.primaryColor,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(
            color: AppTheme.textLightGrey,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildAssetCategoryTabs() {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: AppTheme.cardLightBackground,
            width: 1,
          ),
        ),
      ),
      child: DefaultTabController(
        length: 3,
        child: TabBar(
          labelColor: AppTheme.primaryColor,
          unselectedLabelColor: AppTheme.textGrey,
          indicatorColor: AppTheme.primaryColor,
          indicatorSize: TabBarIndicatorSize.tab,
          tabs: const [
            Tab(text: 'Coins'),
            Tab(text: 'NFTs'),
            Tab(text: 'Earn'),
          ],
        ),
      ),
    );
  }

  Widget _buildAssetsList() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Your Assets',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textWhite,
                ),
              ),
              Row(
                children: [
                  Icon(
                    Icons.search,
                    color: AppTheme.textGrey,
                    size: 20,
                  ),
                  SizedBox(width: 16),
                  Icon(
                    Icons.sort,
                    color: AppTheme.textGrey,
                    size: 20,
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            separatorBuilder: (context, index) => const Divider(
              color: AppTheme.cardLightBackground,
              height: 1,
            ),
            itemCount: 3, // Show only a subset of assets
            itemBuilder: (context, index) {
              final crypto = Cryptocurrency.mockData[index];
              return _buildAssetItem(crypto);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildAssetItem(Cryptocurrency crypto) {
    // Calculate a random amount of this asset owned for demo purposes
    double ownedAmount = crypto.currentPrice > 1000 
        ? 0.01 * (crypto.currentPrice / 1000) 
        : 1.5 * (1000 / crypto.currentPrice);
    double valueUsd = ownedAmount * crypto.currentPrice;
        
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppTheme.cardLightBackground,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Center(
              child: Text(
                crypto.symbol.substring(0, 1),
                style: const TextStyle(
                  color: AppTheme.textWhite,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  crypto.name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textWhite,
                  ),
                ),
                Text(
                  crypto.symbol.toUpperCase(),
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppTheme.textGrey,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '\$${valueUsd.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textWhite,
                  ),
                ),
                Text(
                  '${ownedAmount.toStringAsFixed(ownedAmount < 1 ? 4 : 2)} ${crypto.symbol.toUpperCase()}',
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppTheme.textGrey,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppTheme.primaryColor,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text(
              'Trade',
              style: TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
