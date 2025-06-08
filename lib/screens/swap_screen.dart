import 'package:flutter/material.dart';
import '../constants/app_theme.dart';
import '../models/cryptocurrency.dart';

class SwapScreen extends StatefulWidget {
  const SwapScreen({Key? key}) : super(key: key);

  @override
  State<SwapScreen> createState() => _SwapScreenState();
}

class _SwapScreenState extends State<SwapScreen> {
  Cryptocurrency _fromCrypto = Cryptocurrency.mockData[0]; 
  Cryptocurrency _toCrypto = Cryptocurrency.mockData[1];
  final TextEditingController _fromAmountController = TextEditingController();
  final TextEditingController _toAmountController = TextEditingController();
  
  @override
  void initState() {
    super.initState();
    _fromAmountController.text = '1';
    _calculateToAmount();
  }

  @override
  void dispose() {
    _fromAmountController.dispose();
    _toAmountController.dispose();
    super.dispose();
  }

  void _calculateToAmount() {
    if (_fromAmountController.text.isEmpty) {
      _toAmountController.text = '';
      return;
    }
    
    try {
      final double fromAmount = double.parse(_fromAmountController.text);
      final double fromValueInUsd = fromAmount * _fromCrypto.currentPrice;
      final double toAmount = fromValueInUsd / _toCrypto.currentPrice;
      _toAmountController.text = toAmount.toStringAsFixed(8);
    } catch (e) {
      _toAmountController.text = '';
    }
  }

  void _swapCurrencies() {
    setState(() {
      final temp = _fromCrypto;
      _fromCrypto = _toCrypto;
      _toCrypto = temp;
      
      final tempAmount = _fromAmountController.text;
      _fromAmountController.text = _toAmountController.text;
      _toAmountController.text = tempAmount;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.darkBackground,
      appBar: AppBar(
        backgroundColor: AppTheme.darkBackground,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Swap Crypto',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppTheme.textWhite,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppTheme.textWhite),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildFromCryptoField(),
            const SizedBox(height: 16),
            _buildSwapButton(),
            const SizedBox(height: 16),
            _buildToCryptoField(),
            const SizedBox(height: 24),
            _buildExchangeRate(),
            const SizedBox(height: 24),
            _buildSwapNowButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildFromCryptoField() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.cardDarkBackground,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'From',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: AppTheme.textGrey,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _fromAmountController,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textWhite,
                  ),
                  decoration: const InputDecoration(
                    hintText: '0',
                    hintStyle: TextStyle(color: AppTheme.textGrey),
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                  ),
                  onChanged: (value) {
                    _calculateToAmount();
                  },
                ),
              ),
              InkWell(
                onTap: () {
                  _showCryptoSelectionBottomSheet(true);
                },
                child: Row(
                  children: [
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: AppTheme.cardLightBackground,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Center(
                        child: Text(
                          _fromCrypto.symbol.substring(0, 1).toUpperCase(),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: AppTheme.textWhite,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      _fromCrypto.symbol.toUpperCase(),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.textWhite,
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Icon(
                      Icons.keyboard_arrow_down,
                      color: AppTheme.textGrey,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Available: 2.5 ${_fromCrypto.symbol.toUpperCase()}',
            style: const TextStyle(
              fontSize: 12,
              color: AppTheme.textGrey,
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildSwapButton() {
    return Center(
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: AppTheme.primaryColor,
          borderRadius: BorderRadius.circular(20),
        ),
        child: IconButton(
          icon: const Icon(
            Icons.swap_vert,
            color: Colors.white,
          ),
          onPressed: _swapCurrencies,
        ),
      ),
    );
  }
  
  Widget _buildToCryptoField() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.cardDarkBackground,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'To',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: AppTheme.textGrey,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _toAmountController,
                  readOnly: true,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textWhite,
                  ),
                  decoration: const InputDecoration(
                    hintText: '0',
                    hintStyle: TextStyle(color: AppTheme.textGrey),
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  _showCryptoSelectionBottomSheet(false);
                },
                child: Row(
                  children: [
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: AppTheme.cardLightBackground,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Center(
                        child: Text(
                          _toCrypto.symbol.substring(0, 1).toUpperCase(),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: AppTheme.textWhite,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      _toCrypto.symbol.toUpperCase(),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.textWhite,
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Icon(
                      Icons.keyboard_arrow_down,
                      color: AppTheme.textGrey,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'You will receive: ${_toAmountController.text} ${_toCrypto.symbol.toUpperCase()}',
            style: const TextStyle(
              fontSize: 12,
              color: AppTheme.textGrey,
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildExchangeRate() {
    double rate = _fromCrypto.currentPrice / _toCrypto.currentPrice;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.cardDarkBackground,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Exchange Rate',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: AppTheme.textGrey,
            ),
          ),
          Text(
            '1 ${_fromCrypto.symbol.toUpperCase()} = ${rate.toStringAsFixed(6)} ${_toCrypto.symbol.toUpperCase()}',
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppTheme.textWhite,
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildSwapNowButton() {
    return ElevatedButton(
      onPressed: () {
        _showSwapConfirmationDialog();
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: AppTheme.primaryColor,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: const Center(
        child: Text(
          'Swap Now',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  void _showCryptoSelectionBottomSheet(bool isFromCrypto) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.cardDarkBackground,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              margin: const EdgeInsets.only(top: 8),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppTheme.textGrey,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                isFromCrypto ? 'Select Source Coin' : 'Select Destination Coin',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textWhite,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search coins',
                  hintStyle: const TextStyle(color: AppTheme.textGrey),
                  prefixIcon: const Icon(Icons.search, color: AppTheme.textGrey),
                  filled: true,
                  fillColor: AppTheme.cardLightBackground,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
                style: const TextStyle(color: AppTheme.textWhite),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: Cryptocurrency.mockData.length,
                itemBuilder: (context, index) {
                  final crypto = Cryptocurrency.mockData[index];
                  
                  // Skip the already selected coin in the other field
                  if ((isFromCrypto && crypto.symbol == _toCrypto.symbol) ||
                      (!isFromCrypto && crypto.symbol == _fromCrypto.symbol)) {
                    return const SizedBox.shrink();
                  }
                  
                  return ListTile(
                    leading: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: AppTheme.cardLightBackground,
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: Center(
                        child: Text(
                          crypto.symbol.substring(0, 1).toUpperCase(),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: AppTheme.textWhite,
                          ),
                        ),
                      ),
                    ),
                    title: Text(
                      crypto.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        color: AppTheme.textWhite,
                      ),
                    ),
                    subtitle: Text(
                      crypto.symbol.toUpperCase(),
                      style: const TextStyle(color: AppTheme.textGrey),
                    ),
                    trailing: Text(
                      '\$${crypto.currentPrice.toStringAsFixed(2)}',
                      style: const TextStyle(color: AppTheme.textWhite),
                    ),
                    onTap: () {
                      setState(() {
                        if (isFromCrypto) {
                          _fromCrypto = crypto;
                        } else {
                          _toCrypto = crypto;
                        }
                        _calculateToAmount();
                      });
                      Navigator.pop(context);
                    },
                  );
                },
              ),
            ),
          ],
        );
      },
      isScrollControlled: true,
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.7,
      ),
    );
  }

  void _showSwapConfirmationDialog() {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: AppTheme.cardDarkBackground,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Confirm Swap',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textWhite,
                ),
              ),
              const SizedBox(height: 24),
              _buildSwapDetailsRow('You Pay', _fromAmountController.text, _fromCrypto.symbol.toUpperCase()),
              const SizedBox(height: 16),
              _buildSwapDetailsRow('You Receive', _toAmountController.text, _toCrypto.symbol.toUpperCase()),
              const SizedBox(height: 16),
              _buildSwapDetailsRow(
                'Exchange Rate', 
                '1 ${_fromCrypto.symbol.toUpperCase()}', 
                '${(_fromCrypto.currentPrice / _toCrypto.currentPrice).toStringAsFixed(6)} ${_toCrypto.symbol.toUpperCase()}'
              ),
              const SizedBox(height: 16),
              _buildSwapDetailsRow('Network Fee', '0.0001', 'BTC'),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: AppTheme.textGrey),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text(
                        'Cancel',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.textWhite,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        _showSwapSuccessDialog();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text(
                        'Confirm',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSwapDetailsRow(String label, String amount, String symbol) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            color: AppTheme.textGrey,
          ),
        ),
        Row(
          children: [
            Text(
              amount,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppTheme.textWhite,
              ),
            ),
            const SizedBox(width: 4),
            Text(
              symbol,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppTheme.textWhite,
              ),
            ),
          ],
        ),
      ],
    );
  }

  void _showSwapSuccessDialog() {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: AppTheme.cardDarkBackground,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: const BoxDecoration(
                  color: AppTheme.primaryColor,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check,
                  color: Colors.white,
                  size: 40,
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Swap Successful!',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textWhite,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'You have successfully swapped ${_fromAmountController.text} ${_fromCrypto.symbol.toUpperCase()} to ${_toAmountController.text} ${_toCrypto.symbol.toUpperCase()}',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16,
                  color: AppTheme.textLightGrey,
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryColor,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Done',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  }
