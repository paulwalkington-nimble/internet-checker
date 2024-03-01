import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internet_checker/connectivity_bloc.dart';
import 'package:internet_checker/connectivity_event.dart';
import 'package:internet_checker/connectivity_state.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => ConnectivityBloc(),
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

  var isInternetAvailable = true;

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
      isInternetAvailable = false;
    }

    if (state is ConnectivityAvaliable) {
      if (isInternetAvailable == false) {
        appBarColour = Colors.green;
        appBarTitle = "Connection Restored";
      } else {
        appBarColour = Colors.blue;
        appBarTitle = "Internet Checker";
      }
      isInternetAvailable = true;
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
              calculateAppBarColour(state);

              setState(() {
                _currentIndex = index;
              });
            },
            items: [
              const BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Page 1',
              ),
              const BottomNavigationBarItem(
                icon: Icon(Icons.search),
                label: 'Page 2',
              ),
              const BottomNavigationBarItem(
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
    return const Center(
      child: Text('Page 1'),
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
