import 'package:flutter/material.dart';

class PaymentPage extends StatefulWidget {
  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  final _formKey = GlobalKey<FormState>();
  String _paymentMethod = 'Card';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Payment"),
        backgroundColor: Colors.orange,
        centerTitle: true,
      ),
      backgroundColor: Colors.orange[50],
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Select Payment Method:",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Row(
              children: [
                Radio(
                  value: 'Card',
                  groupValue: _paymentMethod,
                  onChanged: (value) {
                    setState(() {
                      _paymentMethod = value as String;
                    });
                  },
                ),
                Text("Credit/Debit Card"),
                Radio(
                  value: 'UPI',
                  groupValue: _paymentMethod,
                  onChanged: (value) {
                    setState(() {
                      _paymentMethod = value as String;
                    });
                  },
                ),
                Text("UPI Payment"),
              ],
            ),
            SizedBox(height: 10),
            if (_paymentMethod == 'Card') _buildCardPaymentForm(),
            if (_paymentMethod == 'UPI') _buildUPIPaymentForm(),
            SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: _processPayment,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 50),
                ),
                child: Text("Pay Now", style: TextStyle(fontSize: 18)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCardPaymentForm() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            decoration: InputDecoration(labelText: "Card Number"),
            keyboardType: TextInputType.number,
            validator: (value) => value!.isEmpty ? "Enter card number" : null,
          ),
          TextFormField(
            decoration: InputDecoration(labelText: "Expiry Date (MM/YY)"),
            keyboardType: TextInputType.datetime,
            validator: (value) => value!.isEmpty ? "Enter expiry date" : null,
          ),
          TextFormField(
            decoration: InputDecoration(labelText: "CVV"),
            keyboardType: TextInputType.number,
            validator: (value) => value!.isEmpty ? "Enter CVV" : null,
          ),
        ],
      ),
    );
  }

  Widget _buildUPIPaymentForm() {
    return TextField(
      decoration: InputDecoration(labelText: "Enter UPI ID"),
      keyboardType: TextInputType.emailAddress,
    );
  }

  void _processPayment() {
    if (_paymentMethod == 'Card' && !_formKey.currentState!.validate()) {
      return;
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Payment Successful"),
        content: Text("Thank you for your order!"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("OK"),
          ),
        ],
      ),
    );
  }
}
