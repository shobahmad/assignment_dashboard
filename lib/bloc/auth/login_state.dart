class LoginStream {
    LoginState state;
    String message = '';

    LoginStream(this.state, this.message);
}

enum LoginState {
    loading,
    success,
    logout,
    failed
}