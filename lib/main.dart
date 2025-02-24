import 'package:agenda_app/core/theme/theme.dart';
import 'package:agenda_app/data/repositories/agenda_repository.dart';
import 'package:agenda_app/logic/agenda_bloc/agenda_bloc.dart';
import 'package:agenda_app/logic/agenda_bloc/agenda_event.dart';
import 'package:agenda_app/presentation/Screens/agenda/agenda_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AgendaBloc(AgendaRepository())..add(LoadAgendas()),
        ),
      ],
      child: MaterialApp(
        title: 'Agenda App',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          scaffoldBackgroundColor: AppColors.white,
          useMaterial3: true,
        ),
        debugShowCheckedModeBanner: false,
        home: const AgendaScreen(),
      ),
    );
  }
}
