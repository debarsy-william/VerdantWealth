import 'package:examen_dam_info_debarsywilliamchapelierbasile/pages/HomePage.dart';
import 'package:flutter/material.dart';
import '../../styles/style.dart';
import 'package:lottie/lottie.dart';

class SuccessPage extends StatefulWidget {
  final int clientID;
  const SuccessPage({super.key, required this.clientID});

  @override
  _SuccessPageState createState() => _SuccessPageState();
}

class _SuccessPageState extends State<SuccessPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
          backgroundColor: kBackgroundColorWhite,
          appBar: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: Colors.green[800],
            title: const Text('Transaction effectuée'),
          ),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Lottie.network(
                  'https://lottie.host/b01bcce2-32eb-4065-9091-e1f32de9f28e/EZtUN5jUiw.json', // Chemin vers votre animation Lottie JSON
                  width: 170,
                  height: 170,
                  fit: BoxFit.contain,
                ),
                const Padding(padding: EdgeInsets.all(20)),
                const Text(
                  'Transaction effectuée',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
                const Padding(padding: EdgeInsets.all(5)),
                const Text(
                  'Votre transaction a été traitée avec succès.',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          persistentFooterButtons: [
            Builder(
              builder: (BuildContext contextBuild) {
                return Container(
                  height: 50,
                  alignment: Alignment.center,
                  child: SizedBox(
                    width: 200,
                    height: 32,
                    child: ElevatedButton(
                      style: const ButtonStyle(
                        backgroundColor: MaterialStatePropertyAll(Colors.green),
                      ),
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(
                            builder: (context) => HomePage(clientID: widget.clientID)));
                      },
                      child: const Text(
                        "Fermer",
                        style: TextStyle(fontSize: 22),
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        )
    );
  }
}