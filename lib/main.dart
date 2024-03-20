import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internet_checker/src/domain/api_timer.dart';
import 'package:internet_checker/src/presentation/bloc/connectivity_bloc.dart';
import 'package:internet_checker/src/presentation/bloc/connectivity_event.dart';
import 'package:internet_checker/src/presentation/bloc/connectivity_state.dart';
import 'package:internet_checker/core/injection_container.dart';

// ConnectivityBloc connectivityBloc = ConnectivityBloc();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await init();
  runApp(MyApp());

  ApiTimer(sl<ConnectivityBloc>()).start();
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<ConnectivityBloc>(),
      child: MaterialApp(
        title: 'Bottom Navigation Bar',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _currentIndex = 0;
  var appBarColour = Colors.blue;
  var appBarTitle = 'Internet Checker';

  final List<Widget> _pages = [
    PageOne(),
    PageTwo(),
    PageThree(),
  ];

  @override
  void initState() {
    super.initState();
    context.read<ConnectivityBloc>().add(ForceConnectivityCheckEvent());
  }

  void calculateAppBarColour(state) {
    if (state is ConnectivityNone) {
      appBarColour = Colors.red;
      appBarTitle = "Connection Lost";
    }

    if (state is ConnectivityAvaliable) {
      appBarColour = Colors.blue;
      appBarTitle = "Internet Checker";
    }

    if (state is ConnectivityRestored) {
      appBarColour = Colors.green;
      appBarTitle = "Connection Restored";
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ConnectivityBloc, ConnectivityState>(
      builder: (context, state) {
        calculateAppBarColour(state);

        return Scaffold(
          appBar: AppBar(
            backgroundColor: appBarColour,
            foregroundColor: Colors.white,
            title: Text(appBarTitle),
          ),
          body: _pages[_currentIndex],
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: _currentIndex,
            onTap: (index) {
              context
                  .read<ConnectivityBloc>()
                  .add(ForceConnectivityCheckEvent());

              setState(() {
                _currentIndex = index;
              });
            },
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Page 1',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.search),
                label: 'Page 2',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: 'Page 3',
              ),
            ],
          ),
        );
      },
    );
  }
}

class PageOne extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Center(
          child: Text('Page 1'),
        ),
        ElevatedButton(
          onPressed: () {
            sl<ConnectivityBloc>()
                .add(const ApiConnectivityChangedEvent(false));
          },
          child: const Text('turn of api'),
        ),
        ElevatedButton(
          onPressed: () {
            sl<ConnectivityBloc>().add(const ApiConnectivityChangedEvent(true));
          },
          child: const Text('turn on api'),
        )
      ],
    );
  }
}

class PageTwo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Page 2'),
    );
  }
}

class PageThree extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Page 3'),
    );
  }
}
