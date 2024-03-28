// Store instances of service providers

import 'package:safaricom_airtime_scanner/data/models/service_provider.dart';

class ServiceProvidersDatabase {
  // Static instance of Safaricom service provider
  static ServiceProvider safaricom = ServiceProvider(
    prefix: "*141*",
    name: "Safaricom",
  );
}
