import 'package:flutter/material.dart';
import '../constants/app_theme.dart';
import '../models/cryptocurrency.dart';

class BuyScreen extends StatefulWidget {
  final Cryptocurrency? selectedCrypto;

  const BuyScreen({Key? key, this.selectedCrypto}) : super(key: key);

  @override
  State<BuyScreen> createState() => _BuyScreenState();
}

class _BuyScreenState extends State<BuyScreen> {
  Cryptocurrency? _selectedCrypto;
  String _selectedPaymentMethod = 'Credit Card';
  final TextEditingController _cryptoAmountController = TextEditingController();
  final TextEditingController _fiatAmountController = TextEditingController();
  
  final List<String> _paymentMethods = [
    'Credit Card',
    'Debit Card',
    'Bank Transfer',
    'Apple Pay'
  ];

  @override
  void initState() {
    super.initState();
    _selectedCrypto = widget.selectedCrypto ?? Cryptocurrency.mockData[0];
    _cryptoAmountController.text = '1';
    _updateFiatAmount('1');
  }

  @override
  void dispose() {
    _cryptoAmountController.dispose();
    _fiatAmountController.dispose();
    super.dispose();
  }

  void _updateFiatAmount(String cryptoAmount) {
    if (cryptoAmount.isEmpty) {
      _fiatAmountController.text = '';
      return;
    }
    try {
      final double amount = double.parse(cryptoAmount);
      final double fiatAmount = amount * _selectedCrypto!.currentPrice;
      _fiatAmountController.text = fiatAmount.toStringAsFixed(2);
    } catch (e) {
      _fiatAmountController.text = '';
    }
  }

  void _updateCryptoAmount(String fiatAmount) {
    if (fiatAmount.isEmpty) {
      _cryptoAmountController.text = '';
      return;
    }
    try {
      final double amount = double.parse(fiatAmount);
      final double cryptoAmount = amount / _selectedCrypto!.currentPrice;
      _cryptoAmountController.text = cryptoAmount.toStringAsFixed(8);
    } catch (e) {
      _cryptoAmountController.text = '';
    }
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
          'Buy Crypto',
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
            _buildCryptoSelector(),
            const SizedBox(height: 24),
            _buildAmountInput(),
            const SizedBox(height: 24),
            _buildPaymentMethodSelector(),
            const SizedBox(height: 24),
            _buildOrderSummary(),
            const SizedBox(height: 24),
            _buildBuyButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildCryptoSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Select Crypto',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppTheme.textWhite,
          ),
        ),
        const SizedBox(height: 12),
        InkWell(
          onTap: () {
            _showCryptoSelectionBottomSheet();
          },
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.cardDarkBackground,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: AppTheme.cardLightBackground,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Center(
                    child: Text(
                      _selectedCrypto!.symbol.substring(0, 1).toUpperCase(),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppTheme.textWhite,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _selectedCrypto!.name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.textWhite,
                        ),
                      ),
                      Text(
                        _selectedCrypto!.symbol.toUpperCase(),
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppTheme.textGrey,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.keyboard_arrow_down,
                  color: AppTheme.textGrey,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _showCryptoSelectionBottomSheet() {
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
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Select Coin to Buy',
                style: TextStyle(
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
                      '${crypto.symbol.toUpperCase()} • ${crypto.formattedPrice}',
                      style: const TextStyle(color: AppTheme.textGrey),
                    ),
                    onTap: () {
                      setState(() {
                        _selectedCrypto = crypto;
                        _updateFiatAmount(_cryptoAmountController.text);
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

  Widget _buildAmountInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Amount',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppTheme.textWhite,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppTheme.cardDarkBackground,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              _buildCryptoAmountField(),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: Row(
                  children: [
                    Expanded(
                      child: Divider(color: AppTheme.cardLightBackground),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Icon(
                        Icons.swap_vert,
                        color: AppTheme.primaryColor,
                      ),
                    ),
                    Expanded(
                      child: Divider(color: AppTheme.cardLightBackground),
                    ),
                  ],
                ),
              ),
              _buildFiatAmountField(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCryptoAmountField() {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _cryptoAmountController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            style: const TextStyle(
              fontSize: 18,
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
            onChanged: _updateFiatAmount,
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: AppTheme.cardLightBackground,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            _selectedCrypto!.symbol.toUpperCase(),
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              color: AppTheme.textWhite,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFiatAmountField() {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _fiatAmountController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            style: const TextStyle(
              fontSize: 18,
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
            onChanged: _updateCryptoAmount,
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: AppTheme.cardLightBackground,
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Text(
            'USD',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: AppTheme.textWhite,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentMethodSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Payment Method',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppTheme.textWhite,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: AppTheme.cardDarkBackground,
            borderRadius: BorderRadius.circular(12),
          ),
          child: ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _paymentMethods.length,
            separatorBuilder: (context, index) => const Divider(
              height: 1,
              color: AppTheme.cardLightBackground,
            ),
            itemBuilder: (context, index) {
              final method = _paymentMethods[index];
              return RadioListTile<String>(
                title: Text(
                  method,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: AppTheme.textWhite,
                  ),
                ),
                value: method,
                groupValue: _selectedPaymentMethod,
                activeColor: AppTheme.primaryColor,
                onChanged: (value) {
                  setState(() {
                    _selectedPaymentMethod = value!;
                  });
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildOrderSummary() {
    // Calculate order details
    double cryptoAmount = 0;
    double fiatAmount = 0;
    
    try {
      cryptoAmount = double.parse(_cryptoAmountController.text);
      fiatAmount = double.parse(_fiatAmountController.text);
    } catch (e) {
      // Handle parsing errors
    }
    
    const double fee = 2.99;
    final double totalAmount = fiatAmount + fee;
    
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
            'Order Summary',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppTheme.textWhite,
            ),
          ),
          const SizedBox(height: 16),
          _buildSummaryRow('You Buy', '$cryptoAmount ${_selectedCrypto!.symbol.toUpperCase()}'),
          const SizedBox(height: 8),
          _buildSummaryRow('Price', '\$${_selectedCrypto!.currentPrice}'),
          const SizedBox(height: 8),
          _buildSummaryRow('Subtotal', '\$${fiatAmount.toStringAsFixed(2)}'),
          const SizedBox(height: 8),
          _buildSummaryRow('Fee', '\$${fee.toStringAsFixed(2)}'),
          const Divider(
            height: 24,
            color: AppTheme.cardLightBackground,
          ),
          _buildSummaryRow(
            'Total',
            '\$${totalAmount.toStringAsFixed(2)}',
            isBold: true,
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value, {bool isBold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: isBold ? 16 : 14,
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            color: isBold ? AppTheme.textWhite : AppTheme.textGrey,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: isBold ? 16 : 14,
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            color: AppTheme.textWhite,
          ),
        ),
      ],
    );
  }

  Widget _buildBuyButton() {
    return ElevatedButton(
      onPressed: () {
        // Handle buy action
        _showBuySuccessDialog();
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: AppTheme.priceUp,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: const Text(
        'Buy Now',
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }

  void _showBuySuccessDialog() {
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
                  color: AppTheme.priceUp,
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
                'Purchase Successful!',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textWhite,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'You have successfully purchased ${_cryptoAmountController.text} ${_selectedCrypto!.symbol.toUpperCase()}',
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
