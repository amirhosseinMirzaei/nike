import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

import 'package:nike/common/exceptions.dart';
import 'package:nike/data/auth_info.dart';
import 'package:nike/data/cart_response.dart';
import 'package:nike/data/rep/cart_repository.dart';

part 'cart_event.dart';
part 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  final ICartRepository cartRepository;
  CartBloc(this.cartRepository) : super(CartLoading()) {
    on<CartEvent>((event, emit) async {
      if (event is CartStarted) {
        final authInfo = event.authInfo;
        if (authInfo == null || authInfo.accessToken.isEmpty) {
          emit(CartAuthRequired());
        } else {
          await loadCartItems(emit, event.isRefreshing);
        }
      } else if (event is CartDeleteButtonClicked) {
        try {
          if (state is CartSuccess) {
            final successState = (state as CartSuccess);
            final index = successState.cartResponse.cartItems
                .indexWhere((element) => element.id == event.cartItemId);
            successState.cartResponse.cartItems[index].deleteButtonLoading =
                true;
            emit(CartSuccess(successState.cartResponse));
          }

          await cartRepository.delete(event.cartItemId);
          await cartRepository.count();

          if (state is CartSuccess) {
            final successState = (state as CartSuccess);
            successState.cartResponse.cartItems
                .removeWhere((element) => element.id == event.cartItemId);
            if (successState.cartResponse.cartItems.isEmpty) {
              emit(CartEmpty());
            } else {
              emit(calculatePriceInfo(successState.cartResponse));
            }
          }
        } catch (e) {
          debugPrint(e.toString());
        }
      } else if (event is CartAuthInfoChanged) {
        if (event.authInfo == null || event.authInfo!.accessToken.isEmpty) {
          emit(CartAuthRequired());
        } else {
          if (state is CartAuthRequired) {
            await loadCartItems(emit, false);
          }
        }
      } else if (event is IncreaseCountButtonIsClicked ||
          event is DecreaseCartButtonIsClicked) {
        int cartItemId = 0;
        if (event is IncreaseCountButtonIsClicked) {
          cartItemId = event.cartItemId;
        } else if (event is DecreaseCartButtonIsClicked) {
          cartItemId = event.cartItemId;
        }
        try {
          if (state is CartSuccess) {
            final successState = (state as CartSuccess);
            final index = successState.cartResponse.cartItems
                .indexWhere((element) => element.id == cartItemId);
            successState.cartResponse.cartItems[index].changeCountLoading =
                true;
            emit(CartSuccess(successState.cartResponse));

            await Future.delayed(Duration(milliseconds: 2000));
            final newCount = event is IncreaseCountButtonIsClicked
                ? ++successState.cartResponse.cartItems[index].count
                : --successState.cartResponse.cartItems[index].count;
            await cartRepository.changeCount(cartItemId, newCount);
            await cartRepository.count();

            successState.cartResponse.cartItems
                .firstWhere((element) => element.id == cartItemId)
              ..count = newCount
              ..changeCountLoading = false;

            emit(calculatePriceInfo(successState.cartResponse));
          }
        } catch (e) {
          debugPrint(e.toString());
        }
      }
    });
  }

  Future<void> loadCartItems(Emitter<CartState> emit, bool isRefreshing) async {
    try {
      if (!isRefreshing) {
        emit(CartLoading());
      }

      final result = await cartRepository.getAll();
      if (result.cartItems.isEmpty) {
        emit(CartEmpty());
      } else {
        emit(CartSuccess(result));
      }
    } catch (e) {
      emit(CartError(AppException()));
    }
  }

  CartSuccess calculatePriceInfo(
    CartResponse cartResponse,
  ) {
    int totalPrice = 0;
    int payablePrice = 0;
    int shippingCost = 0;
    cartResponse.cartItems.forEach((cartItem) {
      totalPrice += cartItem.product.previousPrice * cartItem.count;
      payablePrice += cartItem.product.price * cartItem.count;
    });
    shippingCost = payablePrice >= 250000 ? 0 : 30000;
    cartResponse.totalPrice = totalPrice;
    cartResponse.payablePrice = payablePrice;
    cartResponse.shippingCost = shippingCost;

    return CartSuccess(cartResponse);
  }
}
