/// Represents a service provider with a prefix and a name.
class ServiceProvider {
  final String prefix; // Prefix of the service provider.
  final String name; // Name of the service provider.

  /// Constructs a [ServiceProvider] with the given [prefix] and [name].
  ///
  /// Both [prefix] and [name] are required parameters.
  const ServiceProvider({
    required this.prefix,
    required this.name,
  });

  /// Override toString for better debugging.
  @override
  String toString() {
    return 'ServiceProvider(prefix: $prefix, name: $name)';
  }
}
