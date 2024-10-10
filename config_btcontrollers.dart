
import 'package:app_mntr_bt/views/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:permission_handler/permission_handler.dart';

class ConfigBluetooth extends StatefulWidget {
  @override
  BluetoothConfig createState() => BluetoothConfig();
}

class BluetoothConfig extends State<ConfigBluetooth> {
  List<BluetoothDiscoveryResult> devicesList = [];
  bool isScanning = false;

  @override
  void initState() {
    super.initState();
    requestPermissions();
  }

  // Solicita permisos necesarios
  Future<void> requestPermissions() async {
    var statusScan = await Permission.bluetoothScan.request();
    var statusConnect = await Permission.bluetoothConnect.request();

    if (statusScan.isGranted && statusConnect.isGranted) {
      startDiscovery();
    } else {
      // Manejo de permiso denegado
      print("Permisos de Bluetooth denegados");
    }
  }

  // Iniciar el escaneo de dispositivos Bluetooth
  void startDiscovery() {
    if (isScanning) return; 
    setState(() {
      isScanning = true;
      devicesList.clear(); 
    });

    FlutterBluetoothSerial.instance.startDiscovery().listen((result) {
      setState(() {
        final existingIndex = devicesList.indexWhere(
            (element) => element.device.address == result.device.address);
        if (existingIndex >= 0) {
          devicesList[existingIndex] = result;
        } else {
          devicesList.add(result);
        }
      });
    }).onDone(() {
      setState(() {
        isScanning = false;
      });
    });

    
  }
   Future<void> connectToDevice(BluetoothDevice device) async {
  
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Home_page(device: device),
      ),
    );
  }
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Seleccionar dispositivo"),
         backgroundColor: Colors.red,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: devicesList.length,
              itemBuilder: (context, index) {
                BluetoothDiscoveryResult result = devicesList[index];
                return Container(
                  padding: EdgeInsets.only(right: 30, left: 30),
                  child: ListTile(
                    title: Text(
                      result.device.name ?? "Dispositivo desconocido",
                      style: TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      result.device.address,
                      style: TextStyle(
                          fontSize: 20, fontWeight: FontWeight.normal),
                    ),
                    onTap: () {
                      Navigator.pop(context, result.device);
                    },
                    trailing: const Icon(Icons.arrow_forward_ios_outlined),
                  ),
                );
              },
            ),
          ),
          if (isScanning)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircularProgressIndicator(),
            ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
              textStyle:
                  TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            onPressed: startDiscovery,
            child: const Wrap(
              children: <Widget>[
                Icon(
                  Icons.search_sharp,
                  color: Colors.white,
                  size: 24.0,
                ),
                SizedBox(width: 10),
                Text("Buscar", style: TextStyle(fontSize: 20)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
