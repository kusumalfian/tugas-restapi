import 'package:vania/vania.dart';
import '../../models/customer.dart';
import 'package:vania/src/exception/validation_exception.dart';

class CustomerController extends Controller {
  Future<Response> index() async {
    try {
      final customers = await Customer().query().get();
      return Response.json({'data': customers}, 200);
    } catch (e) {
      return Response.json(
          {'message': 'Gagal mengambil data customer', 'error': e.toString()},
          500);
    }
  }

  Future<Response> create(Request request) async {
    try {
      request.validate({
        'cust_id': 'required|string|max_length:5',
        'cust_name': 'required|string|max_length:50',
        'cust_address': 'required|string|max_length:50',
        'cust_city': 'required|string|max_length:20',
        'cust_state': 'required|string|max_length:5',
        'cust_zip': 'required|string|max_length:7',
        'cust_country': 'required|string|max_length:25',
        'cust_telp': 'required|string|max_length:15',
      });

      final customerData = request.input();
      await Customer().query().insert(customerData);

      return Response.json(
          {'message': 'Customer berhasil ditambahkan', 'data': customerData},
          201);
    } catch (e) {
      if (e is ValidationException) {
        return Response.json({'errors': e.message}, 400);
      }
      return Response.json(
          {'message': 'Terjadi kesalahan', 'error': e.toString()}, 500);
    }
  }

  Future<Response> update(Request request, String id) async {
    try {
      final customer =
          await Customer().query().where('cust_id', '=', id).first();
      if (customer == null) {
        return Response.json({'message': 'Customer tidak ditemukan'}, 404);
      }

      request.validate({
        'cust_name': 'string|max_length:50',
        'cust_address': 'string|max_length:50',
        'cust_city': 'string|max_length:20',
        'cust_state': 'string|max_length:5',
        'cust_zip': 'string|max_length:7',
        'cust_country': 'string|max_length:25',
        'cust_telp': 'string|max_length:15',
      });

      final updateData = request.input();
      await Customer().query().where('cust_id', '=', id).update(updateData);

      return Response.json(
          {'message': 'Customer berhasil diperbarui', 'data': updateData}, 200);
    } catch (e) {
      return Response.json(
          {'message': 'Terjadi kesalahan', 'error': e.toString()}, 500);
    }
  }

  Future<Response> destroy(String id) async {
    try {
      final customer =
          await Customer().query().where('cust_id', '=', id).first();
      if (customer == null) {
        return Response.json({'message': 'Customer tidak ditemukan'}, 404);
      }

      await Customer().query().where('cust_id', '=', id).delete();
      return Response.json({'message': 'Customer berhasil dihapus'}, 200);
    } catch (e) {
      return Response.json(
          {'message': 'Terjadi kesalahan', 'error': e.toString()}, 500);
    }
  }
}
