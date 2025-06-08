import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../constants/app_theme.dart';
import '../models/cryptocurrency.dart';

class WithdrawScreen extends StatefulWidget {
  final Cryptocurrency? selectedCrypto;

  const WithdrawScreen({Key? key, this.selectedCrypto}) : super(key: key);

  @override
  State<WithdrawScreen> createState() => _WithdrawScreenState();
}

class _WithdrawScreenState extends State<WithdrawScreen> {
  Cryptocurrency? _selectedCrypto;
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _memoController = TextEditingController();
  final String _network = 'Ethereum (ERC20)';
  final double _fee = 0.005;
  final double _availableBalance = 2.5;

  @override
  void initState() {
    super.initState();
    _selectedCrypto = widget.selectedCrypto ?? Cryptocurrency.mockData[0];
  }

  @override
  void dispose() {
    _amountController.dispose();
    _addressController.dispose();
    _memoController.dispose();
    super.dispose();
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
          'Withdraw Crypto',
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
            const SizedBox(height: 24),
            _buildAmountField(),
            const SizedBox(height: 24),
            _buildAddressField(),
            const SizedBox(height: 24),
            _buildMemoField(),
            const SizedBox(height: 24),
            _buildWithdrawSummary(),
            const SizedBox(height: 24),
            _buildWithdrawButton(),
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
                'Select Coin to Withdraw',
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
                      '${crypto.symbol.toUpperCase()} • Available: 2.5',
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
  
  Widget _buildAmountField() {
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _amountController,
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
                    ),
                  ),
                  Text(
                    _selectedCrypto!.symbol.toUpperCase(),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.textWhite,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Available: $_availableBalance ${_selectedCrypto!.symbol.toUpperCase()}',
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppTheme.textGrey,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _amountController.text = _availableBalance.toString();
                      });
                    },
                    child: const Text(
                      'MAX',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.primaryColor,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
  
  Widget _buildAddressField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Withdrawal Address',
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
              Expanded(
                child: TextField(
                  controller: _addressController,
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppTheme.textWhite,
                  ),
                  decoration: const InputDecoration(
                    hintText: 'Enter or paste address',
                    hintStyle: TextStyle(color: AppTheme.textGrey),
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
              ),
              IconButton(
                onPressed: () async {
                  final data = await Clipboard.getData('text/plain');
                  if (data?.text != null) {
                    setState(() {
                      _addressController.text = data!.text!;
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Address pasted from clipboard'),
                        backgroundColor: AppTheme.primaryColor,
                      ),
                    );
                  }
                },
                icon: const Icon(
                  Icons.paste_rounded,
                  color: AppTheme.primaryColor,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
  
  Widget _buildMemoField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text(
              'Memo (Optional)',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppTheme.textWhite,
              ),
            ),
            const SizedBox(width: 8),
            Tooltip(
              message: 'Some exchanges require a memo/tag for deposits',
              child: const Icon(
                Icons.info_outline,
                color: AppTheme.textGrey,
                size: 16,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppTheme.cardDarkBackground,
            borderRadius: BorderRadius.circular(12),
          ),
          child: TextField(
            controller: _memoController,
            style: const TextStyle(
              fontSize: 14,
              color: AppTheme.textWhite,
            ),
            decoration: const InputDecoration(
              hintText: 'Enter memo if required',
              hintStyle: TextStyle(color: AppTheme.textGrey),
              border: InputBorder.none,
              isDense: true,
              contentPadding: EdgeInsets.zero,
            ),
          ),
        ),
      ],
    );
  }
  
  Widget _buildWithdrawSummary() {
    double amount = double.tryParse(_amountController.text) ?? 0;
    double totalAmount = amount - _fee;
    if (totalAmount < 0) totalAmount = 0;
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.cardDarkBackground,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Network Fee',
                style: TextStyle(
                  fontSize: 14,
                  color: AppTheme.textLightGrey,
                ),
              ),
              Text(
                '$_fee ${_selectedCrypto!.symbol.toUpperCase()}',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textWhite,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(color: AppTheme.cardLightBackground),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'You will receive',
                style: TextStyle(
                  fontSize: 14,
                  color: AppTheme.textLightGrey,
                ),
              ),
              Text(
                '$totalAmount ${_selectedCrypto!.symbol.toUpperCase()}',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textWhite,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
  
  Widget _buildWithdrawButton() {
    return ElevatedButton(
      onPressed: () {
        if (_addressController.text.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Please enter a withdrawal address'),
              backgroundColor: Colors.red,
            ),
          );
          return;
        }
        
        if (_amountController.text.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Please enter an amount'),
              backgroundColor: Colors.red,
            ),
          );
          return;
        }
        
        _showWithdrawConfirmationDialog();
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: AppTheme.primaryColor,
        minimumSize: const Size(double.infinity, 56),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: const Text(
        'Withdraw',
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }
  
  void _showWithdrawConfirmationDialog() {
    double amount = double.tryParse(_amountController.text) ?? 0;
    double totalAmount = amount - _fee;
    if (totalAmount < 0) totalAmount = 0;
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.cardDarkBackground,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: const Text(
          'Confirm Withdrawal',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppTheme.textWhite,
          ),
          textAlign: TextAlign.center,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Please confirm your withdrawal details',
              style: TextStyle(
                fontSize: 14,
                color: AppTheme.textLightGrey,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            _buildConfirmationRow('Coin', '${_selectedCrypto!.name} (${_selectedCrypto!.symbol.toUpperCase()})'),
            const SizedBox(height: 12),
            _buildConfirmationRow('Network', _network),
            const SizedBox(height: 12),
            _buildConfirmationRow('Amount', '$amount ${_selectedCrypto!.symbol.toUpperCase()}'),
            const SizedBox(height: 12),
            _buildConfirmationRow('Fee', '$_fee ${_selectedCrypto!.symbol.toUpperCase()}'),
            const SizedBox(height: 12),
            _buildConfirmationRow('You will receive', '$totalAmount ${_selectedCrypto!.symbol.toUpperCase()}'),
            const SizedBox(height: 12),
            _buildConfirmationRow('Address', _addressController.text),
            if (_memoController.text.isNotEmpty) ...[  
              const SizedBox(height: 12),
              _buildConfirmationRow('Memo', _memoController.text),
            ],
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: AppTheme.textGrey),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Text(
                      'Cancel',
                      style: TextStyle(color: AppTheme.textGrey),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      _showWithdrawSuccessDialog();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Text('Confirm'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildConfirmationRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            color: AppTheme.textLightGrey,
          ),
        ),
        Flexible(
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppTheme.textWhite,
            ),
            textAlign: TextAlign.end,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
  
  void _showWithdrawSuccessDialog() {
    double amount = double.tryParse(_amountController.text) ?? 0;
    double totalAmount = amount - _fee;
    if (totalAmount < 0) totalAmount = 0;
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.cardDarkBackground,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.check_circle_outline,
              color: Colors.green,
              size: 64,
            ),
            const SizedBox(height: 16),
            const Text(
              'Withdrawal Successful',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppTheme.textWhite,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '$totalAmount ${_selectedCrypto!.symbol.toUpperCase()} has been sent to your wallet',
              style: const TextStyle(
                fontSize: 14,
                color: AppTheme.textLightGrey,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryColor,
                minimumSize: const Size(double.infinity, 56),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('Done'),
            ),
          ],
        ),
      ),
    );
  }
  }
