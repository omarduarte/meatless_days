abstract class UseCase<Entity, Params> {
  Future<Entity> call(Params params);
}

abstract class NoArgUseCase<Entity> {
  Future<Entity> call();
}

abstract class Params {}
