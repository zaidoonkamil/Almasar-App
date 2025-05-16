abstract class AuthStates {}

class AuthInitialState extends AuthStates {}

class ValidationState extends AuthStates {}

class LoginLoadingState extends AuthStates {}
class LoginSuccessState extends AuthStates {}
class LoginErrorState extends AuthStates {}

class SignUpLoadingState extends AuthStates {}
class SignUpSuccessState extends AuthStates {}
class SignUpErrorState extends AuthStates {}


