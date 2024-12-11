// Função que retorna uma string de erro com base no código de erro fornecido
String getErrorString(String code) {
  switch (code) {
    case 'ERROR_WEAK_PASSWORD': // Caso a senha seja fraca
      return 'Sua senha é muito fraca.';
    case 'ERROR_INVALID_EMAIL': // Caso o e-mail seja inválido
      return 'Seu e-mail é inválido.';
    case 'ERROR_EMAIL_ALREADY_IN_USE': // Caso o e-mail já esteja em uso
      return 'E-mail já está sendo utilizado em outra conta.';
    case 'ERROR_INVALID_CREDENTIAL': // Caso a credencial seja inválida
      return 'Seu e-mail é inválido.';
    case 'ERROR_WRONG_PASSWORD': // Caso a senha esteja incorreta
      return 'Sua senha está incorreta.';
    case 'ERROR_USER_NOT_FOUND': // Caso o usuário não seja encontrado
      return 'Não há usuário com este e-mail.';
    case 'ERROR_USER_DISABLED': // Caso o usuário tenha sido desabilitado
      return 'Este usuário foi desabilitado.';
    case 'ERROR_TOO_MANY_REQUESTS': // Caso haja muitas solicitações em um curto período
      return 'Muitas solicitações. Tente novamente mais tarde.';
    case 'ERROR_OPERATION_NOT_ALLOWED': // Caso a operação não seja permitida
      return 'Operação não permitida.';
    default: // Caso o código de erro não corresponda a nenhum dos casos acima
      return 'Um erro indefinido ocorreu.';
  }
}
