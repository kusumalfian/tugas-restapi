import 'package:vania/vania.dart';

class CreateVendorTable extends Migration {
  @override
  Future<void> up() async {
    super.up();
    await createTableNotExists('vendors', () {
      string('vend_id', length: 5);
      primary('vend_id');
      string('vend_name', length: 50);
      text('vend_address');
      string('vend_kota', length: 20);
      string('vend_state', length: 5);
      string('vend_zip', length: 7);
      string('vend_country', length: 25);
    });
  }

  @override
  Future<void> down() async {
    super.down();
    await dropIfExists('vendors');
  }
}
