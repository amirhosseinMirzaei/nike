import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nike/data/order.dart';
import 'package:nike/data/rep/order_repository.dart';
import 'package:nike/ui/cart/price_info.dart';
import 'package:nike/ui/receipt/payment_receipt.dart';
import 'package:nike/ui/shipping/bloc/shipping_bloc.dart';

class ShippingScreen extends StatefulWidget {
  final int payablePrice;
  final int shippingCost;
  final int totalPrice;

  ShippingScreen(
      {super.key,
      required this.payablePrice,
      required this.shippingCost,
      required this.totalPrice});

  @override
  State<ShippingScreen> createState() => _ShippingScreenState();
}

class _ShippingScreenState extends State<ShippingScreen> {
  final TextEditingController firstNameController =
      TextEditingController(text: 'امیرحسین');

  final TextEditingController lastNameController =
      TextEditingController(text: 'میرزایی');

  final TextEditingController phoneNumberController =
      TextEditingController(text: '09184127163');

  final TextEditingController postalCodeController =
      TextEditingController(text: '3456279329');

  final TextEditingController addressController =
      TextEditingController(text: ' خیابان سعیدیه جنوبی ساختمان الف پلاک ۲۲');

  StreamSubscription? subscription;
  @override
  void dispose() {
    subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text('تحویل گیرنده'),
      ),
      body: BlocProvider<ShippingBloc>(
        create: (context) {
          final bloc = ShippingBloc(orderRepository);
          subscription = bloc.stream.listen((state) {
            if (state is ShippingError) {
              ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.exception.message)));
            } else if (state is ShippingSuccess) {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) =>
                      PaymentReceiptScreen(orderId: state.result.orderId)));
            }
          });
          return bloc;
        },
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              TextField(
                controller: firstNameController,
                decoration: InputDecoration(
                    label: Text(
                  'نام',
                  style: Theme.of(context)
                      .textTheme
                      .caption!
                      .copyWith(fontSize: 16),
                )),
              ),
              const SizedBox(
                height: 12,
              ),
              TextField(
                controller: lastNameController,
                decoration: InputDecoration(
                    label: Text(
                  ' نام خانوادگی',
                  style: Theme.of(context)
                      .textTheme
                      .caption!
                      .copyWith(fontSize: 16),
                )),
              ),
              const SizedBox(
                height: 12,
              ),
              TextField(
                controller: phoneNumberController,
                decoration: InputDecoration(
                    label: Text(
                  'شماره تماس',
                  style: Theme.of(context)
                      .textTheme
                      .caption!
                      .copyWith(fontSize: 16),
                )),
              ),
              const SizedBox(
                height: 12,
              ),
              TextField(
                controller: postalCodeController,
                decoration: InputDecoration(
                    label: Text(
                  ' کد پستی',
                  style: Theme.of(context)
                      .textTheme
                      .caption!
                      .copyWith(fontSize: 16),
                )),
              ),
              const SizedBox(
                height: 12,
              ),
              TextField(
                controller: addressController,
                decoration: InputDecoration(
                    label: Text(
                  ' آدرس',
                  style: Theme.of(context)
                      .textTheme
                      .caption!
                      .copyWith(fontSize: 16),
                )),
              ),
              const SizedBox(
                height: 12,
              ),
              PriceInfo(
                  payablePrice: widget.payablePrice,
                  shippingCost: widget.shippingCost,
                  totalPrice: widget.totalPrice),
              BlocBuilder<ShippingBloc, ShippingState>(
                builder: (context, state) {
                  return state is ShippingLoading
                      ? const Center(
                          child: CupertinoActivityIndicator(),
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            OutlinedButton(
                              onPressed: () {
                                BlocProvider.of<ShippingBloc>(context).add(
                                  ShippingCreateOrder(
                                    params: CreateOrderParams(
                                        firstName: firstNameController.text,
                                        lastName: lastNameController.text,
                                        phoneNumber: phoneNumberController.text,
                                        postalCode: postalCodeController.text,
                                        address: addressController.text,
                                        paymentMethod:
                                            PaymentMethod.cashOnDelivery),
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
                        );
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
