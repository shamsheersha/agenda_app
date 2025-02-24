

import 'package:agenda_app/data/repositories/agenda_repository.dart';
import 'package:agenda_app/logic/agenda_bloc/agenda_event.dart';
import 'package:agenda_app/logic/agenda_bloc/agenda_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AgendaBloc extends Bloc<AgendaEvent, AgendaState> {
  final AgendaRepository agendaRepository;
  AgendaBloc(this.agendaRepository) : super(AgendaInitial()) {
    on<LoadAgendas>(onLoadAgendas);
    on<AddAgenda>(onAddAgenda);
  }



  Future onLoadAgendas(LoadAgendas event,Emitter<AgendaState> emit)async{
    emit(AgendaLoading());

    try{
      final agendas = await agendaRepository.getAgendas();
      emit(AgendaLoaded(agendas));
    }catch(e){
      emit(AgendaError(e.toString()));
    }
  }

  Future onAddAgenda(AddAgenda event, Emitter<AgendaState> emit)async{
    try{
      await agendaRepository.addAgenda(event.agenda);
      add(LoadAgendas());
    }catch(e){
      emit(AgendaError(e.toString()));
    }
  }
}
