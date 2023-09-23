import 'package:examen_dam_info_debarsywilliamchapelierbasile/styles/style.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import '../../class/TransactionNotification.dart';
import 'DonnerPage.dart';

class ScanPage extends StatefulWidget {
  final int clientID;
  final int expediteur_cardid;
  const ScanPage({super.key, required this.clientID, required this.expediteur_cardid});

  @override
  State<StatefulWidget> createState() => _ScanPageState();
}

class _ScanPageState extends State<ScanPage> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;
  bool _isScanning = true;
  bool _showInvalidFormatDialog = true;
  String _montant = "";
  String _destinataire = "";
  String _commu = "";

  @override
  void dispose() {
    controller?.stopCamera();
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scanner le QR Code'),
        backgroundColor: kBackgroundColorGreen,
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            flex: 5,
            child: QRView(
              key: qrKey,
              onQRViewCreated: _onQRViewCreated,
              overlay: QrScannerOverlayShape(
                borderColor: Theme.of(context).scaffoldBackgroundColor,
                borderRadius: 10,
                borderLength: 20,
                borderWidth: 10,
                cutOutSize: MediaQuery.of(context).size.width * 0.8,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      if (mounted && _isScanning) {

        String? data = scanData.code;

        if(_isValidFormat(data))
        {
          setState(() {
            _isScanning = false;
          });


          TransactionNotification tr = CreateTransaction();
          Navigator.push(context, MaterialPageRoute(
              builder: (contextBuild) => Donner(clientID : widget.clientID,transaction: tr)
          ));
        }
        else if(_showInvalidFormatDialog)
        {
          _showInvalidFormatDialog = false;
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Format invalide'),
                content: const Text('Le format du QR code scanné est invalide !'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      _showInvalidFormatDialog = true;
                    },
                    child: const Text('OK'),
                  ),
                ],
              );
            },
          );
        }
        //print(scanData.code);
      }
    });
  }

  bool _isValidFormat(String? data) {
    if(data == null) {
      return false;
    }
    List<String> parts = data.split(";");
    if(parts.length == 5 &&
       parts[0] == 'VW' &&
       parts[1].contains(RegExp(r'^[0-9]+(\,[0-9]+)?$')) &&
       parts[2].length == 9 &&
       parts[4] == 'SCAN'
      ) {
      setMontant(parts[1]);
      setDestinataireCardId(parts[2]);
      setCommunication(parts[3]);
      return true;
    }
    return false;
  }

  TransactionNotification CreateTransaction()
  {
    TransactionNotification transactionNotif = TransactionNotification(
      id: -1,
      expediteur_id: widget.clientID,
      expediteur_card_id: widget.expediteur_cardid,
      destinataire_card_id: int.parse(_destinataire),
      montant: _montant.toString().replaceAll(',', '.'),
      communication: _commu,
      date: DateTime.now(),
      qr_code: true,
      read: false,
    );
    return transactionNotif;
  }

  void setMontant(String Montant) {
    _montant = Montant;
  }

  void setDestinataireCardId(String destiCard) {
    _destinataire = destiCard;
  }

  void setCommunication(String communication) {
    _commu = communication;
  }
}