import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nike/ui/cart/price_info.dart';
import 'package:nike/ui/receipt/payment_receipt.dart';

class ShippingScreen extends StatelessWidget {
  final int payablePrice;
  final int shippingCost;
  final int totalPrice;

  const ShippingScreen(
      {super.key,
      required this.payablePrice,
      required this.shippingCost,
      required this.totalPrice});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text('تحویل گیرنده'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(
                  label: Text(
                'نام و نام خانوادگی',
                style:
                    Theme.of(context).textTheme.caption!.copyWith(fontSize: 16),
              )),
            ),
            const SizedBox(
              height: 12,
            ),
            TextField(
              decoration: InputDecoration(
                  label: Text(
                'شماره تماس',
                style:
                    Theme.of(context).textTheme.caption!.copyWith(fontSize: 16),
              )),
            ),
            const SizedBox(
              height: 12,
            ),
            TextField(
              decoration: InputDecoration(
                  label: Text(
                ' کد پستی',
                style:
                    Theme.of(context).textTheme.caption!.copyWith(fontSize: 16),
              )),
            ),
            const SizedBox(
              height: 12,
            ),
            PriceInfo(
                payablePrice: payablePrice,
                shippingCost: shippingCost,
                totalPrice: totalPrice),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                OutlinedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const PaymentReceiptScreen(),
                      ),
                    );
                  },
                  child: const Text('پرداخت در محل'),
                ),
                const SizedBox(
                  width: 16,
                ),
                ElevatedButton(
                  onPressed: () {},
                  child: const Text('پرداخت اینترنتی'),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
