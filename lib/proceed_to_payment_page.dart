import 'package:flutter/material.dart';
import 'payment_page.dart';

class ProceedToPaymentPage extends StatelessWidget {
  final double totalPrice;

  ProceedToPaymentPage({required this.totalPrice});

  @override
  Widget build(BuildContext context) {
    double gst = totalPrice * 0.18; // 18% GST
    double finalAmount = totalPrice + gst;

    return Scaffold(
      appBar: AppBar(
        title: Text("Payment Summary", style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.orange,
        centerTitle: true,
      ),
      backgroundColor: Colors.orange[50],
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Order Details", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),

            // Order Summary Box
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 4)],
              ),
              child: Column(
                children: [
                  orderDetailRow("Total Price", "₹${totalPrice.toStringAsFixed(2)}"),
                  orderDetailRow("GST (18%)", "₹${gst.toStringAsFixed(2)}"),
                  Divider(thickness: 1, color: Colors.grey),
                  orderDetailRow("Final Amount", "₹${finalAmount.toStringAsFixed(2)}", isBold: true),
                ],
              ),
            ),

            Spacer(),

            // Proceed to Payment Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PaymentPage(amount: finalAmount),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: EdgeInsets.symmetric(vertical: 15),
                ),
                child: Text("Proceed to Payment", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper Widget for Order Details
  Widget orderDetailRow(String label, String value, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontSize: 18, fontWeight: isBold ? FontWeight.bold : FontWeight.normal)),
          Text(value, style: TextStyle(fontSize: 18, fontWeight: isBold ? FontWeight.bold : FontWeight.normal, color: isBold ? Colors.green : Colors.black)),
        ],
      ),
    );
  }
}
