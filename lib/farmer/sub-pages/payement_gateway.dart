import 'package:amplify_core/amplify_core.dart';
import 'package:flutter/material.dart';
import 'package:razorpay_web/razorpay_web.dart';

class PaymentGateway extends StatefulWidget {
  const PaymentGateway({Key? key}) : super(key: key);

  @override
  State<PaymentGateway> createState() => _PaymentGatewayState();
}

class _PaymentGatewayState extends State<PaymentGateway> {
  late final Razorpay _razorpay;
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _errorHandler);
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _successHandler);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _externalWalletHandler);
  }

  @override
  void dispose() {
    _razorpay.clear();
    super.dispose();
  }

  void _errorHandler(PaymentFailureResponse response) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(response.message!),
      backgroundColor: Colors.red,
    ));
    setState(() {
      _isLoading = false;
    });
  }

  void _successHandler(PaymentSuccessResponse response) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('Payment Successful. ID: ${response.paymentId}'),
      backgroundColor: Colors.green,
    ));
    setState(() {
      _isLoading = false;
    });
  }

  void _externalWalletHandler(ExternalWalletResponse response) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('External Wallet: ${response.walletName}'),
      backgroundColor: Colors.green,
    ));
  }

  Future<void> _openCheckout() async {
    if (_amountController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Please enter amount'),
        backgroundColor: Colors.red,
      ));
      return;
    }

    final amount = double.tryParse(_amountController.text);
    if (amount == null || amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Invalid amount'),
        backgroundColor: Colors.red,
      ));
      return;
    }

    if (_phoneController.text.isEmpty) {
      // Added phone number validation
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Please enter phone number'),
        backgroundColor: Colors.red,
      ));
      return;
    }

    String userId = '';
    try {
      final result = await Amplify.Auth.fetchUserAttributes();
      for (final element in result) {
        userId = element.value;
      }
    } on AuthException catch (e) {
      userId = '';
      safePrint('Error fetching user attributes: ${e.message}');
    }

    setState(() {
      _isLoading = true;
    });

    final options = {
      "key": "rzp_test_kQGpRIOSV90vFT",
      "amount": amount * 100, // Amount in Rupees
      "name": "Test Store",
      "description": "Test Payment from flutter app",
      "timeout": "180",
      "currency": "INR",
      "prefill": {
        "contact": _phoneController.text,
        "email": userId,
      }
    };

    _razorpay.open(options);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Payments',
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.redAccent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/3d-hand-making-cashless-payment-from-smartphone.jpg', // Your payment gateway logo
              width: 400,
              height: 400,
            ),
            const SizedBox(height: 5),
            Container(
              alignment: Alignment.centerLeft, // Align the text to the left
              margin: const EdgeInsets.only(
                  bottom: 5.0,
                  left: 5.0), // Add margin to separate it from the amount field
              child: const Text(
                'Amount in rupees',
                style: TextStyle(
                  fontSize: 18.0,
                  color: Colors.black87,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            // const SizedBox(height: 20),
            TextField(
              controller: _amountController,
              keyboardType: const TextInputType.numberWithOptions(
                  decimal: true), // Allow decimal input
              style: const TextStyle(
                fontSize: 18.0,
                color: Colors.black87,
                fontWeight: FontWeight.bold,
              ),
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons
                    .currency_rupee_outlined), // Rupee symbol as prefix icon
                hintText: "Enter amount (e.g., 100.00)",
                labelText: "Enter amount",
                labelStyle: const TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.redAccent,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: const BorderSide(color: Colors.redAccent),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: const BorderSide(color: Colors.redAccent),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide:
                      const BorderSide(color: Colors.redAccent, width: 2.0),
                ),
              ),
            ),

            const SizedBox(height: 25), // Add some space between the fields

            Container(
              alignment: Alignment.centerLeft,
              margin: const EdgeInsets.only(bottom: 5.0, left: 5.0),
              child: const Text(
                'Phone Number',
                style: TextStyle(
                  fontSize: 18.0,
                  color: Colors.black87,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            TextField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              style: const TextStyle(
                fontSize: 18.0,
                color: Colors.black87,
                fontWeight: FontWeight.bold,
              ),
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.phone),
                hintText: "Enter phone number",
                labelText: "Phone number",
                labelStyle: const TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.redAccent,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: const BorderSide(color: Colors.redAccent),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: const BorderSide(color: Colors.redAccent),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide:
                      const BorderSide(color: Colors.redAccent, width: 2.0),
                ),
              ),
            ),

            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isLoading ? null : _openCheckout,
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    Colors.redAccent, // Set button background color
                padding: const EdgeInsets.symmetric(
                    vertical: 10.0, horizontal: 35.0), // Set padding
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(18.0), // Set button border radius
                ),
                elevation: 3.0, // Set elevation
              ),
              child: _isLoading
                  ? const SizedBox(
                      width: 24.0,
                      height: 24.0,
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : const Text(
                      "Pay Now",
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
