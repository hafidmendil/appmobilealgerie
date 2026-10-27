abstract class Failure {
  final String message;
  const Failure(this.message);
}

class ServerFailure extends Failure {
  const ServerFailure(super.message);
}

class NetworkFailure extends Failure {
  const NetworkFailure()
    : super("Connexion internet perdue. Veuillez vérifier votre réseau.");
}

class OfflineModeFailure extends Failure {
  const OfflineModeFailure()
    : super(
        "Cette version fonctionne hors ligne et ne transmet aucune donnée.",
      );
}

class AuthFailure extends Failure {
  const AuthFailure(super.message);
}

class DatabaseFailure extends Failure {
  const DatabaseFailure(super.message);
}
