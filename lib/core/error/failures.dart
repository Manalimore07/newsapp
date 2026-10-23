import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message;
  const Failure(this.message);

  @override
  List<Object?> get props => [message];
}

class ServerFailure extends Failure {
  const ServerFailure([super.message = 'Unable to fetch data from server.']);
}

class CacheFailure extends Failure {
  const CacheFailure([super.message = 'No cached news found on device.']);
}

class NetworkFailure extends Failure {
  const NetworkFailure([super.message = 'No active internet connection.']);
}
