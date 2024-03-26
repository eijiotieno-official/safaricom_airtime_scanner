import 'package:safaricom_airtime_scanner/data/database/service_providers_database.dart';
import 'package:ussd_advanced/ussd_advanced.dart';

import 'grant_permissions.dart';

Future<String?> sendUssd(String code) async {
  try {
    await grantPermissions();
    String refinedCode = "${ServiceProvidersDatabase.safaricom.prefix}$code#"
        .replaceAll(" ", "");
    return await UssdAdvanced.sendAdvancedUssd(code: refinedCode);
  } catch (e) {
    return null;
  }
}
