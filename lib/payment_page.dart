import 'package:flutter/material.dart';

class PaymentPage extends StatefulWidget {
  final double amount;

  PaymentPage({required this.amount});

  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  String selectedPaymentMethod = "Credit Card";

  void processPayment() {
    // Placeholder for actual payment gateway integration
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Payment of ₹${widget.amount.toStringAsFixed(2)} is being processed..."),
        duration: Duration(seconds: 2),
      ),
    );

    Future.delayed(Duration(seconds: 3), () {
      Navigator.pop(context); // Go back to previous screen
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Payment Successful! 🎉"),
          duration: Duration(seconds: 3),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Payment"),
        backgroundColor: Colors.orange,
      ),
      backgroundColor: Colors.orange[50],
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Select Payment Method", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),

            // Payment Method Options
            ListTile(
              leading: Icon(Icons.credit_card, color: Colors.blue),
              title: Text("Credit Card / Debit Card"),
              trailing: Radio(
                value: "Credit Card",
                groupValue: selectedPaymentMethod,
                onChanged: (value) {
                  setState(() {
                    selectedPaymentMethod = value.toString();
                  });
                },
              ),
            ),
            ListTile(
              leading: Icon(Icons.account_balance_wallet, color: Colors.green),
              title: Text("UPI (Google Pay, PhonePe, Paytm)"),
              trailing: Radio(
                value: "UPI",
                groupValue: selectedPaymentMethod,
                onChanged: (value) {
                  setState(() {
                    selectedPaymentMethod = value.toString();
                  });
                },
              ),
            ),
            ListTile(
              leading: Icon(Icons.money, color: Colors.brown),
              title: Text("Cash on Delivery"),
              trailing: Radio(
                value: "Cash on Delivery",
                groupValue: selectedPaymentMethod,
                onChanged: (value) {
                  setState(() {
                    selectedPaymentMethod = value.toString();
                  });
                },
              ),
            ),

            SizedBox(height: 20),
            Divider(thickness: 2),

            // Amount to Pay
            Text("Total Amount: ₹${widget.amount.toStringAsFixed(2)}",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.green)),

            SizedBox(height: 20),

            // Proceed to Payment Button
            Center(
              child: ElevatedButton(
                onPressed: processPayment,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                ),
                child: Text("Pay Now", style: TextStyle(fontSize: 18)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
