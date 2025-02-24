import 'package:agenda_app/data/models/agenda_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AgendaRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  //! Get Agenda From Firestore
  Future<List<AgendaModel>> getAgendas()async{
    final snapShot = await _firestore.collection('agendas').get();

    return snapShot.docs.map((doc)=> AgendaModel.fromFirestore(doc)).toList();
  }


  //! Add Agenda to Firestore

  Future addAgenda(AgendaModel agenda)async{
    await _firestore.collection('agendas').add(agenda.toMap());
  }
}