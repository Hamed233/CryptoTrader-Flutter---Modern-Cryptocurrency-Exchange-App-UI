import 'package:flutter/material.dart';
import '../constants/app_theme.dart';
import '../models/cryptocurrency.dart';
import 'crypto_price_chart.dart';

class CryptoListItem extends StatelessWidget {
  final Cryptocurrency crypto;
  final VoidCallback onTap;

  const CryptoListItem({
    Key? key,
    required this.crypto,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: AppTheme.cardDarkBackground,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Colors.transparent,
          ),
        ),
        child: Row(
          children: [
            _buildCryptoIcon(),
            const SizedBox(width: 12),
            _buildCryptoInfo(),
            const SizedBox(width: 12),
            _buildPriceChart(),
            const SizedBox(width: 12),
            _buildPriceInfo(),
          ],
        ),
      ),
    );
  }

  Widget _buildCryptoIcon() {
    return Container(
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
            fontSize: 18,
          ),
        ),
      ),
    );
  }

  Widget _buildCryptoInfo() {
    return Expanded(
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
          const SizedBox(height: 4),
          Text(
            crypto.symbol.toUpperCase(),
            style: const TextStyle(
              fontSize: 12,
              color: AppTheme.textGrey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPriceChart() {
    return Expanded(
      flex: 3,
      child: SizedBox(
        height: 40,
        child: CryptoPriceChart(
          crypto: crypto,
          height: 40,
        ),
      ),
    );
  }

  Widget _buildPriceInfo() {
    return Expanded(
      flex: 3,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            crypto.formattedPrice,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppTheme.textWhite,
            ),
          ),
          const SizedBox(height: 4),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: crypto.isPriceUp
                  ? AppTheme.priceUp.withOpacity(0.1)
                  : AppTheme.priceDown.withOpacity(0.1),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              crypto.formattedPriceChange,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: crypto.isPriceUp ? AppTheme.priceUp : AppTheme.priceDown,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
