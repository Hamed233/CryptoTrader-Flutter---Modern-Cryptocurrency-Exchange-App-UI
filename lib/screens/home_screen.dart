import 'package:flutter/material.dart';
import '../constants/app_theme.dart';
import '../models/cryptocurrency.dart';
import '../widgets/crypto_list_item.dart';
import 'deposit_screen.dart';
import 'withdraw_screen.dart';
import 'buy_screen.dart';
import 'swap_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.darkBackground,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(context),
              _buildBalanceCard(),
              _buildActionButtons(context),
              _buildFeaturedSection(),
              _buildMarketTrends(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Welcome Back',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 4),
              Text(
                'Crypto Trader',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            ],
          ),
          Row(
            children: [
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.notifications_outlined),
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.settings_outlined),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBalanceCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF2151F5), Color(0xFF4D78FF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
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
                ),
              ),
              Row(
                children: [
                  Icon(
                    Icons.visibility_outlined,
                    color: Colors.white70,
                    size: 16,
                  ),
                  SizedBox(width: 4),
                  Text(
                    'Hide',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            '\$24,518.32',
            style: TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.arrow_upward,
                  color: Colors.white,
                  size: 12,
                ),
                SizedBox(width: 2),
                Text(
                  '3.21% today',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildActionButton(Icons.arrow_downward_rounded, 'Deposit', () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const DepositScreen(),
              ),
            );
          }),
          _buildActionButton(Icons.arrow_upward_rounded, 'Withdraw', () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const WithdrawScreen(),
              ),
            );
          }),
          _buildActionButton(Icons.swap_horiz_rounded, 'Swap', () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const SwapScreen(),
              ),
            );
          }),
          _buildActionButton(Icons.payment_rounded, 'Buy', () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const BuyScreen(),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildActionButton(IconData icon, String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: const BoxDecoration(
              color: AppTheme.cardDarkBackground,
              shape: BoxShape.circle,
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
      ),
    );
  }

  Widget _buildFeaturedSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Featured Assets',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textWhite,
                ),
              ),
              TextButton(
                onPressed: () {},
                child: const Text(
                  'View All',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.primaryColor,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 130,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            itemCount: Cryptocurrency.mockData.length,
            itemBuilder: (context, index) {
              final crypto = Cryptocurrency.mockData[index];
              return _buildFeaturedCard(crypto);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildFeaturedCard(Cryptocurrency crypto) {
    return Container(
      width: 160,
      margin: const EdgeInsets.symmetric(horizontal: 4),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.cardDarkBackground,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppTheme.cardLightBackground,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  crypto.symbol.substring(0, 1),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textWhite,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: crypto.isPriceUp
                      ? AppTheme.priceUp.withOpacity(0.2)
                      : AppTheme.priceDown.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  crypto.formattedPriceChange,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: crypto.isPriceUp ? AppTheme.priceUp : AppTheme.priceDown,
                  ),
                ),
              ),
            ],
          ),
          const Spacer(),
          Text(
            crypto.name,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              color: AppTheme.textWhite,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Text(
            crypto.formattedPrice,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppTheme.textWhite,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMarketTrends() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Market Trends',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textWhite,
                ),
              ),
              TextButton(
                onPressed: () {},
                child: const Text(
                  'View All',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.primaryColor,
                  ),
                ),
              ),
            ],
          ),
        ),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: Cryptocurrency.mockData.length,
          separatorBuilder: (context, index) => const SizedBox(height: 8),
          itemBuilder: (context, index) {
            final crypto = Cryptocurrency.mockData[index];
            return CryptoListItem(
              crypto: crypto,
              onTap: () {},
            );
          },
        ),
        const SizedBox(height: 16),
        _buildNewsSection(),
        const SizedBox(height: 16),
      ],
    );
  }
  
  Widget _buildNewsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Crypto News',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textWhite,
                ),
              ),
              TextButton(
                onPressed: () {},
                child: const Text(
                  'More',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.primaryColor,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 180,
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            scrollDirection: Axis.horizontal,
            children: [
              _buildNewsCard(
                'Bitcoin Surges Past 60,000 as Institutional Adoption Grows',
                'assets/images/news1.jpg',
                '2h ago',
              ),
              _buildNewsCard(
                'New Regulations for Crypto Exchanges Coming Next Month',
                'assets/images/news2.jpg',
                '5h ago',
              ),
              _buildNewsCard(
                'Ethereum 2.0 Upgrade: What You Need to Know',
                'assets/images/news3.jpg',
                '1d ago',
              ),
            ],
          ),
        ),
      ],
    );
  }
  
  Widget _buildNewsCard(String title, String imagePath, String timeAgo) {
    return Container(
      width: 260,
      margin: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        color: AppTheme.cardDarkBackground,
        borderRadius: BorderRadius.circular(12),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 3,
            child: Container(
              color: AppTheme.cardLightBackground,
              width: double.infinity,
              child: const Center(
                child: Icon(
                  Icons.currency_bitcoin,
                  size: 40,
                  color: AppTheme.primaryColor,
                ),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.textWhite,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const Spacer(),
                  Text(
                    timeAgo,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppTheme.textGrey,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
