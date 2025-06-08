import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../constants/app_theme.dart';
import '../models/cryptocurrency.dart';

class DepositScreen extends StatefulWidget {
  final Cryptocurrency? selectedCrypto;

  const DepositScreen({Key? key, this.selectedCrypto}) : super(key: key);

  @override
  State<DepositScreen> createState() => _DepositScreenState();
}

class _DepositScreenState extends State<DepositScreen> {
  Cryptocurrency? _selectedCrypto;
  bool _showQRCode = true;
  final String _walletAddress = '0x7Fc66500c84A76Ad7e9c93437bFc5Ac33E2DDaE9';

  @override
  void initState() {
    super.initState();
    _selectedCrypto = widget.selectedCrypto ?? Cryptocurrency.mockData[0];
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
          'Deposit Crypto',
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
            _buildNetworkSelector(),
            const SizedBox(height: 32),
            _buildDepositMethods(),
            const SizedBox(height: 32),
            _showQRCode 
                ? _buildQRCodeSection() 
                : _buildAddressSection(),
            const SizedBox(height: 24),
            _buildDepositInfo(),
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
          'Select Coin',
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
                'Select Coin to Deposit',
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
                      crypto.symbol.toUpperCase(),
                      style: const TextStyle(color: AppTheme.textGrey),
                    ),
                    onTap: () {
                      setState(() {
                        _selectedCrypto = crypto;
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

  Widget _buildNetworkSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Network',
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
          child: Row(
            children: [
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Ethereum (ERC20)',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.textWhite,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Network Fee: 0.005 ETH',
                      style: TextStyle(
                        fontSize: 12,
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
      ],
    );
  }

  Widget _buildDepositMethods() {
    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () {
              setState(() {
                _showQRCode = true;
              });
            },
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: _showQRCode
                    ? AppTheme.primaryColor
                    : AppTheme.cardDarkBackground,
                borderRadius: const BorderRadius.horizontal(
                  left: Radius.circular(8),
                ),
              ),
              child: Center(
                child: Text(
                  'QR Code',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: _showQRCode ? Colors.white : AppTheme.textGrey,
                  ),
                ),
              ),
            ),
          ),
        ),
        Expanded(
          child: GestureDetector(
            onTap: () {
              setState(() {
                _showQRCode = false;
              });
            },
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: !_showQRCode
                    ? AppTheme.primaryColor
                    : AppTheme.cardDarkBackground,
                borderRadius: const BorderRadius.horizontal(
                  right: Radius.circular(8),
                ),
              ),
              child: Center(
                child: Text(
                  'Address',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: !_showQRCode ? Colors.white : AppTheme.textGrey,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildQRCodeSection() {
    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: AppTheme.cardDarkBackground,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: [
              Container(
                width: 200,
                height: 200,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  'QR CODE\nPLACEHOLDER',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Deposit ${_selectedCrypto!.symbol.toUpperCase()}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textWhite,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        _buildAddressDisplay(),
      ],
    );
  }

  Widget _buildAddressSection() {
    return _buildAddressDisplay();
  }

  Widget _buildAddressDisplay() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.cardDarkBackground,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Your Deposit Address',
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
              color: AppTheme.cardLightBackground,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    _walletAddress,
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppTheme.textLightGrey,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: _walletAddress));
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Address copied to clipboard'),
                        backgroundColor: AppTheme.primaryColor,
                      ),
                    );
                  },
                  icon: const Icon(
                    Icons.copy_rounded,
                    color: AppTheme.primaryColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDepositInfo() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.cardDarkBackground,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Important Information',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppTheme.textWhite,
            ),
          ),
          const SizedBox(height: 16),
          _buildInfoItem(
            '• Send only ${_selectedCrypto!.symbol.toUpperCase()} to this deposit address.',
          ),
          _buildInfoItem(
            '• Ensure the network is Ethereum (ERC20).',
          ),
          _buildInfoItem(
            '• Minimum deposit: 0.01 ${_selectedCrypto!.symbol.toUpperCase()}',
          ),
          _buildInfoItem(
            '• Deposits typically require 12 network confirmations.',
          ),
          _buildInfoItem(
            '• Deposits will be available in your account after 30 minutes to 1 hour.',
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 14,
          color: AppTheme.textLightGrey,
        ),
      ),
    );
  }
}
