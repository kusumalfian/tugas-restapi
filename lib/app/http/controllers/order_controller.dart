import 'package:vania/vania.dart';
import '../../models/order.dart';
import 'package:vania/src/exception/validation_exception.dart';

class OrderController extends Controller {
  Future<Response> index() async {
    try {
      final orders = await Order().query().get();
      return Response.json({'data': orders}, 200);
    } catch (e) {
      return Response.json(
          {'message': 'Gagal mengambil data orders', 'error': e.toString()},
          500);
    }
  }

  Future<Response> create(Request request) async {
    try {
      request.validate({
        'order_num': 'required|numeric',
        'order_date': 'required|date',
        'cust_id': 'required|string|max_length:5',
      });

      final orderData = request.input();
      await Order().query().insert(orderData);

      return Response.json(
          {'message': 'Order berhasil ditambahkan', 'data': orderData}, 201);
    } catch (e) {
      if (e is ValidationException) {
        return Response.json({'errors': e.message}, 400);
      }
      return Response.json(
          {'message': 'Terjadi kesalahan', 'error': e.toString()}, 500);
    }
  }

  Future<Response> update(Request request, int id) async {
    try {
      final order = await Order().query().where('order_num', '=', id).first();
      if (order == null) {
        return Response.json({'message': 'Order tidak ditemukan'}, 404);
      }

      request.validate({
        'order_date': 'date',
        'cust_id': 'string|max_length:5',
      });

      final updateData = request.input();
      await Order().query().where('order_num', '=', id).update(updateData);

      return Response.json(
          {'message': 'Order berhasil diperbarui', 'data': updateData}, 200);
    } catch (e) {
      return Response.json(
          {'message': 'Terjadi kesalahan', 'error': e.toString()}, 500);
    }
  }

  Future<Response> destroy(int id) async {
    try {
      final order = await Order().query().where('order_num', '=', id).first();
      if (order == null) {
        return Response.json({'message': 'Order tidak ditemukan'}, 404);
      }

      await Order().query().where('order_num', '=', id).delete();
      return Response.json({'message': 'Order berhasil dihapus'}, 200);
    } catch (e) {
      return Response.json(
          {'message': 'Terjadi kesalahan', 'error': e.toString()}, 500);
    }
  }
}
