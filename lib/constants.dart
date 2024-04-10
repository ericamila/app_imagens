import 'package:flutter/material.dart';

const imagemPadraoUrl = 'images/nophoto.png';
const space = Padding(padding: EdgeInsets.all(8));
const paddingPadraoFormulario = EdgeInsets.all(12.0);

const carregando = Center(
  child: Column(
    mainAxisAlignment: MainAxisAlignment.center,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      CircularProgressIndicator(),
      Text('Carregando'),
    ],
  ),
);

InputDecoration myDecoration(String texto, {Icon? icone}) {
  return InputDecoration(
      border: const OutlineInputBorder(),
      label: Text(texto),
      contentPadding: const EdgeInsets.all(15),
      floatingLabelBehavior: FloatingLabelBehavior.always,
      enabled: true,
      filled: true,
      fillColor: Colors.white70,
      prefixIcon: icone
  );
}

ClipRRect imageLeading(String? foto) {
  return ClipRRect(
    borderRadius: BorderRadius.circular(50.0),
    child: foto != null
        ? Image.network(
            height: 58,
            width: 58,
            foto!,
            fit: BoxFit.cover,
          )
        : Container(
            color: Colors.grey,
            child: Image.asset(imagemPadraoUrl),
          ),
  );
}
