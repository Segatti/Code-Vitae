sealed class IPageState {}

class StartState implements IPageState {}

class LoadingState implements IPageState {}

class ErrorState implements IPageState {
  final String message;

  ErrorState(this.message);
}

class SuccessState implements IPageState {}