import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nike/common/utils.dart';
import 'package:nike/data/cart_item.dart';
import 'package:nike/theme.dart';
import 'package:nike/ui/widgets/image.dart';

class CartItem extends StatelessWidget {
  final CartItemEntity data;
  final GestureTapCallback onDeleteButtonClick;
  final GestureTapCallback onIncreaseButtonClick;
  final GestureTapCallback onDecreaseButtonClick;
  const CartItem(
      {super.key,
      required this.data,
      required this.onDeleteButtonClick,
      required this.onIncreaseButtonClick,
      required this.onDecreaseButtonClick});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(4),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Theme.of(context).colorScheme.surface,
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 10)
          ]),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                SizedBox(
                  height: 100,
                  width: 100,
                  child: ImageLoadingService(
                    imageUrl: data.product.imageUrl,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      data.product.title,
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8, right: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('تعداد'),
                    Row(
                      children: [
                        IconButton(
                          onPressed: onIncreaseButtonClick,
                          icon: const Icon(CupertinoIcons.plus_rectangle),
                        ),
                        data.changeCountLoading
                            ? CupertinoActivityIndicator(
                                color:
                                    Theme.of(context).colorScheme.onBackground,
                              )
                            : Text(
                                data.count.toString(),
                                style: Theme.of(context).textTheme.headline6,
                              ),
                        IconButton(
                          onPressed: onDecreaseButtonClick,
                          icon: const Icon(CupertinoIcons.minus_rectangle),
                        ),
                      ],
                    )
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      data.product.previousPrice.withPriceLabel.toString(),
                      style: TextStyle(
                          color: LightThemeColor.secondaryTextColor,
                          fontSize: 12,
                          decoration: TextDecoration.lineThrough),
                    ),
                    Text(data.product.price.withPriceLabel.toString()),
                  ],
                )
              ],
            ),
          ),
          const Divider(
            height: 1,
          ),
          data.deleteButtonLoading
              ? const SizedBox(
                  height: 48,
                  child: Center(
                    child: CupertinoActivityIndicator(),
                  ))
              : TextButton(
                  onPressed: onDeleteButtonClick,
                  child: const Text('حذف از سبد خرید'),
                ),
        ],
      ),
    );
  }
}
