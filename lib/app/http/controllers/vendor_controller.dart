import 'package:vania/vania.dart';
import '../../models/vendor.dart';
import 'package:vania/src/exception/validation_exception.dart';

class VendorController extends Controller {
  Future<Response> index() async {
    try {
      final vendors = await Vendor().query().get();
      return Response.json({'data': vendors}, 200);
    } catch (e) {
      return Response.json(
          {'message': 'Gagal mengambil data vendors', 'error': e.toString()},
          500);
    }
  }

  Future<Response> create(Request request) async {
    try {
      request.validate({
        'vend_id': 'required|string|max_length:5',
        'vend_name': 'required|string|max_length:50',
        'vend_address': 'string',
        'vend_kota': 'string',
        'vend_state': 'string|max_length:5',
        'vend_zip': 'string|max_length:7',
        'vend_country': 'string|max_length:25',
      });

      final vendorData = request.input();
      await Vendor().query().insert(vendorData);

      return Response.json(
          {'message': 'Vendor berhasil ditambahkan', 'data': vendorData}, 201);
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
      final vendor = await Vendor().query().where('vend_id', '=', id).first();
      if (vendor == null) {
        return Response.json({'message': 'Vendor tidak ditemukan'}, 404);
      }

      request.validate({
        'vend_name': 'string|max_length:50',
        'vend_address': 'string',
        'vend_kota': 'string',
        'vend_state': 'string|max_length:5',
        'vend_zip': 'string|max_length:7',
        'vend_country': 'string|max_length:25',
      });

      final updateData = request.input();
      await Vendor().query().where('vend_id', '=', id).update(updateData);

      return Response.json(
          {'message': 'Vendor berhasil diperbarui', 'data': updateData}, 200);
    } catch (e) {
      return Response.json(
          {'message': 'Terjadi kesalahan', 'error': e.toString()}, 500);
    }
  }

  Future<Response> destroy(String id) async {
    try {
      final vendor = await Vendor().query().where('vend_id', '=', id).first();
      if (vendor == null) {
        return Response.json({'message': 'Vendor tidak ditemukan'}, 404);
      }

      await Vendor().query().where('vend_id', '=', id).delete();
      return Response.json({'message': 'Vendor berhasil dihapus'}, 200);
    } catch (e) {
      return Response.json(
          {'message': 'Terjadi kesalahan', 'error': e.toString()}, 500);
    }
  }
}
