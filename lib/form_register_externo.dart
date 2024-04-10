import 'package:flutter/material.dart';
import '../foto.dart';
import '../externo.dart';
import 'constants.dart';
import 'package:uuid/uuid.dart';

class FormCadastro extends StatefulWidget {
  final BuildContext externoContext;
  final Externo? externoEdit;
  final String tipoCadastro;

  const FormCadastro(
      {super.key,
      required this.externoContext,
      this.externoEdit,
      required this.tipoCadastro});

  @override
  State<FormCadastro> createState() => _FormCadastroState();
}

class _FormCadastroState extends State<FormCadastro> {
  final _formKey = GlobalKey<FormState>();
  final nomeController = TextEditingController();
  String? _imageUrl;
  bool isEditar = false;
  var uuid = const Uuid();


  @override
  void initState() {
    super.initState();
    _seEditar();
  }

  @override
  void dispose() {
    nomeController.dispose();
    _imageUrl = '';
    super.dispose();
  }

  void _seEditar() {
    if (widget.externoEdit != null) {
      setState(() {
        nomeController.text = widget.externoEdit!.nome;
        _imageUrl = widget.externoEdit!.foto;
        isEditar = true;
      });
    }
  }


  bool valueValidator(String? value) {
    if (value != null && value.isEmpty) {
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Cadastro de ${widget.tipoCadastro}'),
        ),
        body: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [

                Padding(
                  padding: paddingPadraoFormulario,
                  child: TextFormField(
                    validator: (String? value) {
                      if (valueValidator(value)) {
                        return 'Preencha o campo';
                      }
                      return null;
                    },
                    controller: nomeController,
                    textAlign: TextAlign.center,
                    decoration: myDecoration('Nome Completo'),
                  ),
                ),
                //N O V O
                Foto(
                        uUID: (isEditar)? widget.externoEdit?.id : uuid.v1(),
                        imageUrl: _imageUrl,
                        onUpload: (imageUrl) async {
                          if (!mounted) return;
                          setState(() {
                            _imageUrl = imageUrl;
                          });
                        }),
                space,
                FilledButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                     // print('${nomeController.text}\n$_imageUrl');
                      ExternoDao().save(Externo(
                        nome: nomeController.text,
                        foto: (_imageUrl != '') ? _imageUrl : '',
                      ));
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Salvando registro!'),
                          duration: Duration(seconds: 3),
                        ),
                      );
                      setState(() {});
                      Navigator.pop(context);
                    }
                  },
                  child: const Text('Salvar'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
