import '../models/service_provider.dart';

class ServiceProvidersDatabase {
  static ServiceProvider safaricom = ServiceProvider(
    prefix: "*141*", // Prefix for Safaricom
    name: "Safaricom",
  );
}
