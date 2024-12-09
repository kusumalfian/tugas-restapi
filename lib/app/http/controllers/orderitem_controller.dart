import 'package:vania/vania.dart';
import '../../models/orderitem.dart';
import 'package:vania/src/exception/validation_exception.dart';

class OrderItemController extends Controller {
  Future<Response> index() async {
    try {
      final orderItems = await OrderItem().query().get();
      return Response.json({'data': orderItems}, 200);
    } catch (e) {
      return Response.json({
        'message': 'Gagal mengambil data order items',
        'error': e.toString()
      }, 500);
    }
  }

  Future<Response> create(Request request) async {
    try {
      request.validate({
        'order_item': 'required|numeric',
        'order_num': 'required|numeric',
        'prod_id': 'required|string|max_length:10',
        'quantity': 'required|numeric',
        'size': 'numeric|max_length:5',
      });

      final orderItemData = request.input();
      await OrderItem().query().insert(orderItemData);

      return Response.json({
        'message': 'Order item berhasil ditambahkan',
        'data': orderItemData,
      }, 201);
    } catch (e) {
      if (e is ValidationException) {
        return Response.json({'errors': e.message}, 400);
      }
      return Response.json({
        'message': 'Terjadi kesalahan',
        'error': e.toString(),
      }, 500);
    }
  }

  Future<Response> update(Request request, int id) async {
    try {
      final orderItem =
          await OrderItem().query().where('order_item', '=', id).first();
      if (orderItem == null) {
        return Response.json({'message': 'Order item tidak ditemukan'}, 404);
      }

      request.validate({
        'order_num': 'numeric',
        'prod_id': 'string|max_length:10',
        'quantity': 'numeric',
        'size': 'numeric|max_length:5',
      });

      final updateData = request.input();
      await OrderItem().query().where('order_item', '=', id).update(updateData);

      return Response.json({
        'message': 'Order item berhasil diperbarui',
        'data': updateData,
      }, 200);
    } catch (e) {
      return Response.json({
        'message': 'Terjadi kesalahan',
        'error': e.toString(),
      }, 500);
    }
  }

  Future<Response> destroy(int id) async {
    try {
      final orderItem =
          await OrderItem().query().where('order_item', '=', id).first();
      if (orderItem == null) {
        return Response.json({'message': 'Order item tidak ditemukan'}, 404);
      }

      await OrderItem().query().where('order_item', '=', id).delete();
      return Response.json({'message': 'Order item berhasil dihapus'}, 200);
    } catch (e) {
      return Response.json({
        'message': 'Terjadi kesalahan',
        'error': e.toString(),
      }, 500);
    }
  }
}
