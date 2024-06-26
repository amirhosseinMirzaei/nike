import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:nike/common/utils.dart';
import 'package:nike/data/product.dart';
import 'package:nike/data/rep/cart_repository.dart';
import 'package:nike/theme.dart';
import 'package:nike/ui/product/bloc/product_bloc.dart';
import 'package:nike/ui/product/comment/comment_list.dart';
import 'package:nike/ui/widgets/image.dart';


class ProductDetailsScreen extends StatefulWidget {
  final ProductEntity product;

  const ProductDetailsScreen({super.key, required this.product});

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  StreamSubscription<ProductState>? stateSubscription=null;
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey=GlobalKey();
  @override
  Widget build(BuildContext context) {
    @override
   void dispose(){
    stateSubscription?.cancel();
    _scaffoldKey.currentState?.dispose();
      super.dispose();
   }

    return Directionality(
      textDirection: TextDirection.rtl,
      child: BlocProvider<ProductBloc>(
  create: (context) {
    final bloc= ProductBloc(cartRepository);
    stateSubscription= bloc.stream.listen((state) {
      if(state is ProductAddToCartSuccess){
        _scaffoldKey.currentState?.showSnackBar(SnackBar(content:Text('با موفقیت ثبت شد') ,));
      } else if(state is ProductAddToCartError){
        _scaffoldKey.currentState?.showSnackBar(SnackBar(content: Text(state.exception.message)));
      }
    });
    return bloc;
  },
  child: ScaffoldMessenger(
    key: _scaffoldKey,
    child: Scaffold(
          floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
          floatingActionButton: SizedBox(
            width: MediaQuery.of(context).size.width - 48,
            child: BlocBuilder<ProductBloc, ProductState>(
    builder: (context, state) {
      return FloatingActionButton.extended(
                onPressed: () {
                  BlocProvider.of<ProductBloc>(context).add(CartAddButtonIsClicked(widget.product.id));

                }, label: state is ProductAddToCartButtonLoading ?CupertinoActivityIndicator(color: Colors.white,) : Text('افزودن به سبد خرید'));
    },
    ),
          ),
          body: CustomScrollView(
            physics: defaultScrollPhysics,
            slivers: [
              SliverAppBar(
                expandedHeight: MediaQuery.of(context).size.width * 0.8,
                flexibleSpace: ImageLoadingService(imageUrl: widget.product.imageUrl),
                foregroundColor: LightThemeColor.primaryTextColor,
                actions: [
                  IconButton(
                      onPressed: () {}, icon: const Icon(CupertinoIcons.heart))
                ],
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                              child: Text(
                            widget.product.title,
                            style: Theme.of(context).textTheme.headline6,
                          )),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                widget.product.previousPrice.withPriceLabel,
                                style: Theme.of(context).textTheme.caption!.apply(
                                    decoration: TextDecoration.lineThrough),
                              ),
                              Text(widget.product.price.withPriceLabel)
                            ],
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      const Text(
                          'این کتانی برای پیاده روی و دویدن مناسب است و هیچ فشار مخربی بر روی پا ندارد.',style: TextStyle(height: 1.4),),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'نظرات کاربران',
                            style: Theme.of(context).textTheme.subtitle1,
                          ),
                          TextButton(onPressed: () {}, child: Text('ثبت نظر'))
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              CommentList(
                productId: widget.product.id,
              )
            ],
          ),
        ),
  ),
),
    );
  }
}
