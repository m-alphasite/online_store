import 'package:flutter/material.dart'; // Importa o Flutter para construir a interface do usuário

getAuthenticationInputDecoration(String label, {Icon? icon}) {
  // Função para criar um InputDecoration personalizado
  return InputDecoration(
    // Cria um InputDecoration
    icon: icon, // Adiciona um icone ao InputDecoration
    hintText: label, // Define o texto de dica para o InputDecoration
    border: const OutlineInputBorder(), // Define a borda do InputDecoration
    filled: true, // Define que o InputDecoration deve ser preenchido
    contentPadding: const EdgeInsets.symmetric(
        horizontal: 12, vertical: 12), // Define o padding do InputDecoration
    enabledBorder: OutlineInputBorder(
      // Define a borda do InputDecoration quando o campo está desabilitado
      borderRadius: BorderRadius.circular(12), // Define a forma da borda
      borderSide: const BorderSide(
          color: Color(0xfffc90048),
          width: 2.0), // Define a cor e largura da borda
    ),
    focusedBorder: OutlineInputBorder(
      // Define a borda do InputDecoration quando o campo está habilitado
      borderRadius: BorderRadius.circular(12),
      borderSide:
          const BorderSide(color: Color.fromARGB(255, 248, 1, 215), width: 4.0),
    ),
    errorBorder: OutlineInputBorder(
      // Define a borda do InputDecoration quando houver um erro
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: Colors.red, width: 2.0),
    ),
    focusedErrorBorder: OutlineInputBorder(
      // Define a borda do InputDecoration quando houver um erro
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: Colors.red, width: 4.0),
    ),
  );
}
