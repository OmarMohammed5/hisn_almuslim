class RepositoryException implements Exception {
  final String message;
  final StackTrace? stackTrace;

  const RepositoryException(this.message, [this.stackTrace]);

  @override
  String toString() => 'RepositoryException: $message';
}

class NoRecitersFoundException extends RepositoryException {
  const NoRecitersFoundException([String? message])
    : super(message ?? 'No reciters found in the repository');
}

class RepositoryInitializationException extends RepositoryException {
  const RepositoryInitializationException([String? message])
    : super(message ?? 'Failed to initialize repository');
}
