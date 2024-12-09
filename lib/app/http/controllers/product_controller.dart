import 'package:vania/vania.dart';
import '../../models/product.dart';
import 'package:vania/src/exception/validation_exception.dart';

class ProductController extends Controller {
  Future<Response> index() async {
    try {
      final products = await Product().query().get();
      return Response.json({'data': products}, 200);
    } catch (e) {
      return Response.json(
          {'message': 'Gagal mengambil data products', 'error': e.toString()},
          500);
    }
  }

  Future<Response> create(Request request) async {
    try {
      request.validate({
        'prod_id': 'required|string|max_length:10',
        'vend_id': 'required|string|max_length:5',
        'prod_name': 'required|string|max_length:25',
        'prod_price': 'required|numeric',
        'prod_desc': 'string',
      });

      final productData = request.input();
      await Product().query().insert(productData);

      return Response.json(
          {'message': 'Product berhasil ditambahkan', 'data': productData},
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
      final product = await Product().query().where('prod_id', '=', id).first();
      if (product == null) {
        return Response.json({'message': 'Product tidak ditemukan'}, 404);
      }

      request.validate({
        'vend_id': 'string|max_length:5',
        'prod_name': 'string|max_length:25',
        'prod_price': 'numeric',
        'prod_desc': 'string',
      });

      final updateData = request.input();
      await Product().query().where('prod_id', '=', id).update(updateData);

      return Response.json(
          {'message': 'Product berhasil diperbarui', 'data': updateData}, 200);
    } catch (e) {
      return Response.json(
          {'message': 'Terjadi kesalahan', 'error': e.toString()}, 500);
    }
  }

  Future<Response> destroy(String id) async {
    try {
      final product = await Product().query().where('prod_id', '=', id).first();
      if (product == null) {
        return Response.json({'message': 'Product tidak ditemukan'}, 404);
      }

      await Product().query().where('prod_id', '=', id).delete();
      return Response.json({'message': 'Product berhasil dihapus'}, 200);
    } catch (e) {
      return Response.json(
          {'message': 'Terjadi kesalahan', 'error': e.toString()}, 500);
    }
  }
}
