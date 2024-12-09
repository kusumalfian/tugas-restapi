import 'package:vania/vania.dart';
import '../../models/productnote.dart';
import 'package:vania/src/exception/validation_exception.dart';

class ProductNoteController extends Controller {
  Future<Response> index() async {
    try {
      final productNotes = await ProductNote().query().get();
      return Response.json({'data': productNotes}, 200);
    } catch (e) {
      return Response.json({
        'message': 'Gagal mengambil data product notes',
        'error': e.toString()
      }, 500);
    }
  }

  Future<Response> create(Request request) async {
    try {
      request.validate({
        'note_id': 'required|string|max_length:5',
        'prod_id': 'required|string|max_length:10',
        'note_date': 'required|date',
        'note_text': 'required|string',
      });

      final noteData = request.input();
      await ProductNote().query().insert(noteData);

      return Response.json(
          {'message': 'Product note berhasil ditambahkan', 'data': noteData},
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
      final note =
          await ProductNote().query().where('note_id', '=', id).first();
      if (note == null) {
        return Response.json({'message': 'Product note tidak ditemukan'}, 404);
      }

      request.validate({
        'prod_id': 'string|max_length:10',
        'note_date': 'date',
        'note_text': 'string',
      });

      final updateData = request.input();
      await ProductNote().query().where('note_id', '=', id).update(updateData);

      return Response.json(
          {'message': 'Product note berhasil diperbarui', 'data': updateData},
          200);
    } catch (e) {
      return Response.json(
          {'message': 'Terjadi kesalahan', 'error': e.toString()}, 500);
    }
  }

  Future<Response> destroy(String id) async {
    try {
      final note =
          await ProductNote().query().where('note_id', '=', id).first();
      if (note == null) {
        return Response.json({'message': 'Product note tidak ditemukan'}, 404);
      }

      await ProductNote().query().where('note_id', '=', id).delete();
      return Response.json({'message': 'Product note berhasil dihapus'}, 200);
    } catch (e) {
      return Response.json(
          {'message': 'Terjadi kesalahan', 'error': e.toString()}, 500);
    }
  }
}
