import '../models/service_provider.dart';

/// Class to store instances of service providers.
class ServiceProvidersDatabase {
  /// Static instance of Safaricom service provider.
  static const ServiceProvider safaricom = ServiceProvider(
    prefix: "*141*", // Prefix for Safaricom
    name: "Safaricom",
  );
}
