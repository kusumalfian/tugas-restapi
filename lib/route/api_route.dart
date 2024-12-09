import 'package:vania/vania.dart';
import 'package:tugas_rest_api/app/http/controllers/customer_controller.dart';
import 'package:tugas_rest_api/app/http/controllers/productnote_controller.dart';
import 'package:tugas_rest_api/app/http/controllers/product_controller.dart';
import 'package:tugas_rest_api/app/http/controllers/vendor_controller.dart';
import 'package:tugas_rest_api/app/http/controllers/orderitem_controller.dart';
import 'package:tugas_rest_api/app/http/controllers/order_controller.dart';

class ApiRoute implements Route {
  @override
  void register() {
    /// Base RoutePrefix
    Router.basePrefix('api');

    final customerController = CustomerController();
    final productNoteController = ProductNoteController();
    final productController = ProductController();
    final orderController = OrderController();
    final vendorController = VendorController();
    final orderItemController = OrderItemController();

    Router.post('/create-customer', customerController.create);
    Router.get('/customers', customerController.index);
    Router.put('/customer/{cust_id}', customerController.update);
    Router.delete('/customer/{id}', customerController.destroy);

    Router.post('/create-productnote', productNoteController.create);
    Router.get('/productnotes', productNoteController.index);
    Router.put('/productnote/{note_id}', productNoteController.update);
    Router.delete('/productnote/{id}', productNoteController.destroy);

    Router.post('/create-order', orderController.create);
    Router.get('/orders', orderController.index);
    Router.put('/order/{order_num}', orderController.update);
    Router.delete('/order/{id}', orderController.destroy);

    Router.post('/create-product', productController.create);
    Router.get('/products', productController.index);
    Router.put('/product/{prod_id}', productController.update);
    Router.delete('/product/{id}', productController.destroy);

    Router.post('/create-vendor', vendorController.create);
    Router.get('/vendors', vendorController.index);
    Router.put('/vendor/{vend_id}', vendorController.update);
    Router.delete('/vendor/{id}', vendorController.destroy);

    Router.post('/create-orderitem', orderItemController.create);
    Router.get('/orderitems', orderItemController.index);
    Router.put('/orderitem/{order_item}', orderItemController.update);
    Router.delete('/orderitem/{id}', orderItemController.destroy);
  }
}
