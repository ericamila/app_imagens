import 'package:flutter/material.dart';
import '../externo.dart';
import 'constants.dart';
import 'form_register_externo.dart';

class ListaCadastro extends StatefulWidget {
  const ListaCadastro({super.key});

  @override
  State<ListaCadastro> createState() => _ListaCadastroState();
}

class _ListaCadastroState extends State<ListaCadastro> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cadastros'),
        actions: [
          IconButton(
            onPressed: () {
              setState(() {});
            },
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 8, bottom: 70),
        child: FutureBuilder<List<Externo>>(
            future: ExternoDao().findAll(),
            builder: (context, snapshot) {
              List<Externo>? items = snapshot.data;
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                case ConnectionState.waiting:
                case ConnectionState.active:
                  return carregando;
                case ConnectionState.done:
                  if (snapshot.hasData && items != null) {
                    if (items.isNotEmpty) {
                      return ListView.separated(
                        itemCount: items.length,
                        itemBuilder: (BuildContext context, int index) {
                          final Externo externo = items[index];
                          return ListTile(
                              title: Text(externo.nome),
                              leading: ClipRRect(
                                borderRadius: BorderRadius.circular(50.0),
                                child: externo.foto != null
                                    ? Image.network(
                                        height: 58,
                                        width: 58,
                                        externo.foto!,
                                        fit: BoxFit.cover,
                                      )
                                    : Container(
                                        color: Colors.grey,
                                        child: Image.asset(imagemPadraoUrl),
                                      ),
                              ),
                              onTap: () {},
                              trailing: PopupMenuButton<bool>(
                                onSelected: (value) async {
                                  if (value) {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (contextNew) => FormCadastro(
                                          externoContext: context,
                                          externoEdit: externo,
                                          tipoCadastro: 'Cadastro',
                                        ),
                                      ),
                                    ).then((value) => setState(() {}));
                                  } else {
                                    bool deletedConfirmed = await showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          title: const Text('Deletar'),
                                          content: Text(
                                              'Tem certeza que deseja deletar ${externo.nome}?'),
                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                Navigator.pop(context, false);
                                              },
                                              child: const Text('Cancelar'),
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                Navigator.pop(context, true);
                                              },
                                              child: const Text('Deletar'),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                    if (deletedConfirmed) {
                                      await ExternoDao().delete(externo.id!);
                                      setState(() {});
                                    }
                                  }
                                },
                                itemBuilder: (BuildContext context) =>
                                    <PopupMenuEntry<bool>>[
                                  const PopupMenuItem<bool>(
                                      value: true,
                                      child: ListTile(
                                        leading: Icon(Icons.edit),
                                        title: Text('Editar'),
                                      )),
                                  const PopupMenuItem<bool>(
                                      value: false,
                                      child: ListTile(
                                        leading: Icon(Icons.delete_forever),
                                        title: Text('Excluir'),
                                      )),
                                ],
                              ));
                        },
                        separatorBuilder: (BuildContext context, int index) {
                          return const Divider();
                        },
                      );
                    }
                    return const Center(
                        child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.error_outline,
                          size: 96,
                        ),
                        Text(
                          'Não há nenhum dado.',
                          style: TextStyle(fontSize: 32),
                        ),
                      ],
                    ));
                  }
                  return const Text('Erro ao carregar dados');
              }
            }),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (contextNew) => FormCadastro(
                  externoContext: context, tipoCadastro: 'Cadastro'),
            ),
          ).then((value) => setState(() {}));
        },
        label: const Text(
          'ADICIONAR',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        icon: const Icon(Icons.person_add),
      ),
    );
  }
}
