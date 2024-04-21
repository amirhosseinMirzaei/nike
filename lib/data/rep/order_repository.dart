import 'package:nike/data/common/http_client.dart';
import 'package:nike/data/order.dart';
import 'package:nike/data/source/order_data_source.dart';

final orderRepository =
    OrderRepository(dataSource: OrderRemoteDataSource(httpclient: httpClient));

abstract class IOrderRepository extends IOrderDataSource {}

class OrderRepository implements IOrderRepository {
  final IOrderDataSource dataSource;

  OrderRepository({required this.dataSource});
  @override
  Future<CreateOrderResult> create(CreateOrderParams params) =>
      dataSource.create(params);
}
