import 'package:app_mntr_bt/views/config_btcontrollers.dart';
import 'package:app_mntr_bt/views/login.dart';
import 'package:app_mntr_bt/views/user_profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

import '../database/share_reference.dart';

class Home_Monitor extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Home_page(),
    );
  }
}

class Home_page extends StatefulWidget {
  final BluetoothDevice? device;

  const Home_page({this.device});

  State<Home_page> createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<Home_page> {
  BluetoothConnection? connection;
  double? heartRate;
  double? spo2;
  double? temperatura;

  bool isConnected = false;
  @override
  void initState() {
    super.initState();
    if (widget.device != null) {
      connectToBluetooth();
    }
  }

  // Conectar al dispositivo Bluetooth y escuchar datos
  void connectToBluetooth() async {
     BluetoothDevice? selectedDevice = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ConfigBluetooth(),
      ),
    );
    try {
      connection = await BluetoothConnection.toAddress(widget.device!.address);
      setState(() {
        isConnected = true;
      });

      connection!.input!.listen((data) {
        final receivedData = String.fromCharCodes(data).trim();
        final parsedData = receivedData.split(',');

        // Validar y asignar los valores recibidos
        if (parsedData.length == 3) {
          setState(() {
            heartRate = double.tryParse(parsedData[0]);
            spo2 = double.tryParse(parsedData[1]);
            temperatura = double.tryParse(parsedData[2]);
          });
        }
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Error al conectar"),
        backgroundColor: Colors.red,
      ));
      print('Error al conectar: $e');
      setState(() {
        isConnected = false;
      });
    }
  }

  @override
  void dispose() {
    connection?.dispose();
    super.dispose();
  }

  // Comprobación de rango normal o fuera de rango
  bool areVitalsNormal() {
    return heartRate != null && heartRate! >= 60 && heartRate! <= 100 &&
        spo2 != null && spo2! >= 95 && spo2! <= 100 &&
        temperatura != null && temperatura! >= 36.5 && temperatura! <= 37.5;
  }

  double getHeartRatePercent() => (heartRate ?? 0) / 150 * 100;
  double getSpo2Percent() => (spo2 ?? 0) / 100 * 100;
  double getTemperaturePercent() => ((temperatura ?? 0) - 30) / 10 * 100;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Aguirre Monitor"),
        actions: [
          IconButton(
            onPressed: () {
              logout(context);
            },
            icon: const Icon(
              Icons.logout,
            ),
          ),
          IconButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => ConfigBluetooth()));
            },
            icon: const Icon(
              Icons.settings_bluetooth,
            ),
          ),
          IconButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => UserProfileScreen()));
            },
            icon: const Icon(
              Icons.person_pin,
            ),
          )
        ],
        backgroundColor: Colors.redAccent,
      ),
      body: ListView(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          children: <Widget>[
            Container(
              padding: const EdgeInsets.all(15),
              child: ListView(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                children: <Widget>[
                  Container(
                    margin: const EdgeInsets.only(top: 30),
                    padding: const EdgeInsets.all(15),
                    child: const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "CONTROL DE SIGNOS VITALES",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontFamily: AutofillHints.language,
                            color: Colors.black38,
                            fontSize: 40,
                          ),
                        ),
                        SizedBox(height: 50),
                      ],
                    ),
                  )
                ],
              ),
            ),
            Container(
              child: isConnected &&
                      heartRate != null &&
                      spo2 != null &&
                      temperatura != null
                  ? Column(children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Padding(
                              padding: const EdgeInsets.all(5),
                              child: Column(children: <Widget>[
                                const Text("TEMPERATURA",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                                const SizedBox(
                                  height: 20,
                                ),
                                CircularPercentIndicator(
                                  radius: 50.0,
                                  lineWidth: 10.0,
                                  percent: getTemperaturePercent()
                                          .clamp(0.0, 100.0) /
                                      100,
                                  center: Text(
                                      "${temperatura!.toStringAsFixed(1)} °C"),
                                  progressColor: Colors.green,
                                )
                              ])),
                          Padding(
                              padding: const EdgeInsets.all(5),
                              child: Column(children: <Widget>[
                                const Text("PRESIÓN ARTERIAL",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                                const SizedBox(
                                  height: 20,
                                ),
                                CircularPercentIndicator(
                                  radius: 50.0,
                                  lineWidth: 10.0,
                                  percent:
                                      getHeartRatePercent().clamp(0.0, 100.0) /
                                          100,
                                  center: Text(
                                      "${heartRate!.toStringAsFixed(0)} bpm"),
                                  progressColor: Colors.red,
                                ),
                              ])),
                          Padding(
                              padding: const EdgeInsets.all(5),
                              child: Column(children: <Widget>[
                                const Text("RESPIRACION",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                                const SizedBox(
                                  height: 20,
                                ),
                                CircularPercentIndicator(
                                  radius: 50.0,
                                  lineWidth: 10.0,
                                  percent:
                                      getSpo2Percent().clamp(0.0, 100.0) / 100,
                                  center:
                                      Text("${spo2!.toStringAsFixed(0)}BPM"),
                                  progressColor: Color(0xFF2703F4),
                                ),
                              ]))
                        ],
                      ),
                      const SizedBox(height: 60),
                      Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              areVitalsNormal()
                                  ? "Signos Vitales en Rango Normal"
                                  : "Signos Vitales Fuera de Rango",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: areVitalsNormal()
                                    ? Colors.green
                                    : Colors.red,
                              ),
                            ),
                            SizedBox(width: 10),
                            Icon(
                              areVitalsNormal()
                                  ? Icons.check_circle
                                  : Icons.cancel,
                              color:
                                  areVitalsNormal() ? Colors.green : Colors.red,
                              size: 30,
                            ),
                          ])
                    ])
                  : Container(
                      padding: const EdgeInsets.all(30.0),
                      child: Column(
                        children: [
                          Text(
                            isConnected
                                ? "Conectado, esperando datos..."
                                : "No se ha conectado ningún dispositivo",
                            style: TextStyle(fontSize: 20, color: Colors.grey),
                          ),
                          SizedBox(height: 150),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.redAccent,
                                padding: EdgeInsets.symmetric(
                                    horizontal: 30, vertical: 20),
                                textStyle: TextStyle(
                                    fontSize: 30, fontWeight: FontWeight.bold)),
                            onPressed: connectToBluetooth,
                            child: const Wrap(
                              children: <Widget>[
                                Icon(
                                  Icons.bluetooth,
                                  color: Colors.white,
                                  size: 24.0,
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text("Conectar Bluetooth",
                                    style: TextStyle(fontSize: 20)),
                              ],
                            ),
                          ),
                        ],
                      )),
            )
          ]),
    );
  }
}

Future<void> logout(BuildContext context) async {
  const CircularProgressIndicator();
  await SessionManager.logout();
  // ignore: use_build_context_synchronously
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(
      builder: (context) => const Login(),
    ),
  );
}
