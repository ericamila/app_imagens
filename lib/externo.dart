import '../banco.dart';

class ExternoDao {
  static const String _tablename = 'teste';
  static const String _nome = 'nome';
  static const String _foto = 'foto';
  static const String _id = 'id';

  save(Externo model) async {
    var itemExists = await find(model.nome);
    Map<String, dynamic> modelMap = toMap(model);
    if (itemExists.isEmpty) {
      await supabase.from(_tablename).insert({
        'nome': model.nome,
        'foto': model.foto
      });
    } else {
      model.id = itemExists.last.id;
      await supabase
          .from(_tablename)
          .update(modelMap)
          .eq('id', model.id.toString());
    }
  }

  Map<String, dynamic> toMap(Externo model) {
    final Map<String, dynamic> mapa = {};
    mapa[_nome] = model.nome;
    mapa[_foto] = model.foto;
    return mapa;
  }

  Future<List<Externo>> findAll() async {
    final List<Map<String, dynamic>> result =
        await supabase.from(_tablename).select().order(_nome, ascending: true);
    return toList(result);
  }

  List<Externo> toList(List<Map<String, dynamic>> mapa) {
    final List<Externo> models = [];
    for (Map<String, dynamic> linha in mapa) {
      final Externo model = Externo(
        nome: linha[_nome],
        foto: linha[_foto],
        id: linha[_id],
      );
      models.add(model);
    }
    return models;
  }

  Future<List<Externo>> find(String nome) async {
    final List<Map<String, dynamic>> result =
        await supabase.from(_tablename).select().eq('nome', nome);
    return toList(result);
  }

  Future<Externo> findID(String id) async {
    final Map<String, dynamic> result =
        await supabase.from(_tablename).select().eq('id', id).single();
    final Externo model = Externo(
      nome: result[_nome],
      foto: result[_foto],
      id: result[_id],
    );
    return model;
  }

  delete(String id) async {
    return await supabase.from(_tablename).delete().eq('id', id);
  }
}

class Externo{
  String? id;
  String nome;
  String? foto;
  
  Externo({required this.nome, this.foto, this.id});

  @override
  String toString() {
    return '$nome $foto $id';
  }
}
