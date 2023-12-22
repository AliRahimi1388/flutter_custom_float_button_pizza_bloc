import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bloc_pizza_app/bloc/pizza_bloc.dart';
import 'package:flutter_bloc_pizza_app/model/pizza_model.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => PizzaBloc()..add(LoadPizzaCounter()),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'The Bloc App',
        home: MyHomePage(title: 'Pizza Choice in Bloc app'),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this,
        duration: Duration(milliseconds: 350),
        reverseDuration: Duration(milliseconds: 275));

    _animation = CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOut,
        reverseCurve: Curves.easeIn);

    _controller.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  Alignment alignment1 = Alignment(0.0, 0.0);
  Alignment alignment2 = Alignment(0.0, 0.0);
  Alignment alignment3 = Alignment(0.0, 0.0);
  double size1 = 50;
  double size2 = 50;
  double size3 = 50;

  void _incrementCounter() {
    setState(() {
      context.read<PizzaBloc>().add(AddPizza(Pizza.pizzas[0]));
    });
  }

  void _incrementFirstTypePizzaCounter() {
    setState(() {
      context.read<PizzaBloc>().add(AddPizza(Pizza.pizzas[1]));
    });
  }

  void _removeFirstTypePizzaCounter() {
    setState(() {
      context.read<PizzaBloc>().add(RemovePizza(Pizza.pizzas[1]));
    });
  }

  bool toggle = true;

  void _decrementCounter() {
    setState(() {
      if (toggle) {
        toggle = !toggle;
        _controller.forward();
        Future.delayed(Duration(milliseconds: 10), () {
          alignment1 = Alignment(-0.8, -0.4);
          alignment2 = Alignment(0.0, -0.8);
          alignment3 = Alignment(0.8, -0.4);
        });
      } else {
        toggle = !toggle;
        Future.delayed(Duration(milliseconds: 10), () {
          alignment1 = Alignment(0.0, 0.0);
          alignment2 = Alignment(0.0, 0.0);
          alignment3 = Alignment(0.0, 0.0);
        });

        _controller.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange[800],
        title: Text(widget.title),
      ),
      body: Center(
        child: BlocBuilder<PizzaBloc, PizzaState>(
          builder: (context, state) {
            if (state is PizzaInitial) {
              return const CircularProgressIndicator(
                  color: Colors.yellowAccent);
            }
            if (state is PizzaLoaded) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '${state.pizzas.length}',
                    style: const TextStyle(
                        fontSize: 60, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 1.5,
                    width: MediaQuery.of(context).size.width,
                    child: Stack(
                      alignment: Alignment.center,
                      clipBehavior: Clip.none,
                      children: [
                        for (int index = 0;
                            index < state.pizzas.length;
                            index++)
                          Positioned(
                            left: Random().nextInt(250).toDouble(),
                            right: Random().nextInt(250).toDouble(),
                            child: SizedBox(
                              height: 150,
                              width: 150,
                              child: state.pizzas[index].image,
                            ),
                          )
                      ],
                    ),
                  )
                ],
              );
            } else {
              return Text('somthing wrong');
            }
          },
        ),
      ),
      floatingActionButton: Center(
        child: SizedBox(
          height: 250.0,
          width: 250.0,
          child: Stack(
            children: [
              AnimatedAlign(
                duration: toggle
                    ? Duration(milliseconds: 275)
                    : Duration(milliseconds: 875),
                alignment: alignment1,
                curve: toggle ? Curves.easeIn : Curves.elasticOut,
                child: AnimatedContainer(
                  duration: toggle
                      ? Duration(milliseconds: 275)
                      : Duration(milliseconds: 875),
                  curve: toggle ? Curves.easeIn : Curves.easeOut,
                  height: size1,
                  width: size1,
                  decoration: BoxDecoration(
                    color: Colors.black87,
                    borderRadius: BorderRadius.circular(40),
                  ),
                  child: IconButton(
                      icon: const Icon(Icons.local_pizza),
                      color: Colors.white,
                      splashColor: Colors.black54,
                      splashRadius: 31,
                      onPressed: _incrementCounter),
                ),
              ),
              AnimatedAlign(
                duration: toggle
                    ? Duration(milliseconds: 275)
                    : Duration(milliseconds: 875),
                alignment: alignment2,
                curve: toggle ? Curves.easeIn : Curves.elasticOut,
                child: AnimatedContainer(
                  duration: toggle
                      ? Duration(milliseconds: 275)
                      : Duration(milliseconds: 875),
                  curve: toggle ? Curves.easeIn : Curves.easeOut,
                  height: size2,
                  width: size2,
                  decoration: BoxDecoration(
                    color: Colors.black87,
                    borderRadius: BorderRadius.circular(40),
                  ),
                  child: IconButton(
                      icon: const Icon(Icons.cut),
                      color: Colors.white,
                      splashColor: Colors.black54,
                      splashRadius: 31,
                      onPressed: _removeFirstTypePizzaCounter),
                ),
              ),
              AnimatedAlign(
                duration: toggle
                    ? Duration(milliseconds: 275)
                    : Duration(milliseconds: 875),
                alignment: alignment3,
                curve: toggle ? Curves.easeIn : Curves.elasticOut,
                child: AnimatedContainer(
                  duration: toggle
                      ? Duration(milliseconds: 275)
                      : Duration(milliseconds: 875),
                  curve: toggle ? Curves.easeIn : Curves.easeOut,
                  height: size3,
                  width: size3,
                  decoration: BoxDecoration(
                    color: Colors.black87,
                    borderRadius: BorderRadius.circular(40),
                  ),
                  child: IconButton(
                      icon: const Icon(Icons.local_pizza_rounded),
                      color: Colors.white,
                      splashColor: Colors.black54,
                      splashRadius: 31,
                      onPressed: _incrementFirstTypePizzaCounter),
                ),
              ),

              Align(
                alignment: Alignment.center,
                child: Transform.rotate(
                  angle: _animation.value * pi * (3 / 4),
                  child: AnimatedContainer(
                    height: toggle ? 80 : 60,
                    width: toggle ? 80 : 60,
                    curve: Curves.easeOut,
                    decoration: BoxDecoration(
                        color:
                            toggle ? Colors.yellow[600] : Colors.green[600],
                        borderRadius: BorderRadius.circular(60.0)),
                    duration: Duration(milliseconds: 375),
                    child: Material(
                      color: Colors.transparent,
                      child: IconButton(
                        splashColor: Colors.black54,
                        splashRadius: 31,
                        onPressed: _decrementCounter,
                        icon: const Icon(Icons.add, size: 45.0),
                      ),
                    ),
                  ),
                ),
              ),
              // AnimatedContainer(
              //   height: MediaQuery.of(context).size.height / 6,
              //   width: MediaQuery.of(context).size.width / 6,
              //   duration: const Duration(microseconds: 300),
              //   child: FloatingActionButton(
              //     onPressed: _decrementCounter,
              //     backgroundColor: toggle ? Colors.orange : Colors.red,
              //     tooltip: 'open Menu',
              //     child: toggle
              //         ? const Icon(Icons.close)
              //         : const Icon(Icons.remove),
              //   ),
              // )
            ],
          ),
        ),
      ),
    );
  }
}
