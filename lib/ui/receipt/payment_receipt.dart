import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nike/common/utils.dart';
import 'package:nike/data/rep/order_repository.dart';
import 'package:nike/theme.dart';
import 'package:nike/ui/receipt/bloc/payment_receipt_bloc.dart';

class PaymentReceiptScreen extends StatelessWidget {
  final int orderId;
  const PaymentReceiptScreen({super.key, required this.orderId});

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('رسید پرداخت'),
      ),
      body: BlocProvider<PaymentReceiptBloc>(
        create: (context) => PaymentReceiptBloc(orderRepository)
          ..add(PaymentReceiptStarted(orderId: orderId)),
        child: BlocBuilder<PaymentReceiptBloc, PaymentReceiptState>(
          builder: (context, state) {
            if (state is PaymentReceiptSuccess) {
              return Column(
                children: [
                  Container(
                    padding: EdgeInsets.all(16),
                    margin: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      border:
                          Border.all(color: themeData.dividerColor, width: 1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      children: [
                        Text(
                          state.paymentReceiptData.purchaseSuccess
                              ? 'پرداخت با موفقیت انجام شد'
                              : 'پرداخت ناموفق',
                          style: themeData.textTheme.headline6!
                              .apply(color: themeData.colorScheme.primary),
                        ),
                        const SizedBox(
                          height: 32,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Text(
                              'وضعیت سفارش',
                              style: TextStyle(
                                  color: LightThemeColor.secondaryTextColor),
                            ),
                            Text(
                              state.paymentReceiptData.paymentStatus,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16),
                            )
                          ],
                        ),
                        const Divider(
                          height: 32,
                          thickness: 1,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Text(
                              'مبلغ',
                              style: TextStyle(
                                  color: LightThemeColor.secondaryTextColor),
                            ),
                            Text(
                              state.paymentReceiptData.payablePrice
                                  .withPriceLabel,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                  ElevatedButton(
                      onPressed: () {
                        Navigator.of(context)
                            .popUntil((route) => route.isFirst);
                      },
                      child: Text('بازگشت به صفحه اصلی'))
                ],
              );
            } else if (state is PaymentReceiptError) {
              return Center(
                child: Text(state.exception.message),
              );
            } else if (state is PaymentReceiptLoading) {
              return Center(
                child: CupertinoActivityIndicator(),
              );
            } else {
              throw Exception('state is not supported');
            }
          },
        ),
      ),
    );
  }
}
