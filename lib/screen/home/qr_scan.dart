import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

import '../../generated/l10n.dart' as lang;
import '../../model/models.dart';
import '../../model/repository.dart';
import '../../theme/theme_constants.dart';
import '../category/productdetail.dart';
import '../widgets/partial.dart';
import 'home.dart';

class QRScan extends StatefulWidget {
  const QRScan({super.key});

  @override
  State<StatefulWidget> createState() => _QRScan();
}

class _QRScan extends State<QRScan> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  late String _lastResult = "";
  late bool _isLoading = false;
  late bool _isCorrect = true;
  late Product _product;

  QRViewController? controller;

  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.
  @override
  /*void reassemble() {
    super.reassemble();

    if (Platform.isAndroid) {
      controller!.pauseCamera();
    }
    controller!.resumeCamera();
  }*/

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  Future<void> getproduct(String sku) async {
    if (!_isLoading) {
      setState(() {
        _isLoading = true;
      });
    }

    HttpService httpService = HttpService();

    Response response = await httpService.getproductbysku(sku, null);
    var data = json.decode(response.toString());
    if (data["statusCode"] == 200) {
      setState(() {
        _product = Product.fromMap(data["data"]);
        _isLoading = false;
        _isCorrect = true;
      });
    } else {
      setState(() {
        _isLoading = false;
        _isCorrect = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 44,
        elevation: 0.0,
        backgroundColor: whiteColor,
        surfaceTintColor: whiteColor,
        automaticallyImplyLeading: false,
        title: Text(
          lang.S.of(context).qrscanTitle,
          style: textTheme.titleLarge?.copyWith(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.close_outlined,
          ),
        ),
      ),
      body: _isLoading
          ? const Center(
              child: LoadingCircle(),
            )
          : Column(
              children: [
                Expanded(
                  flex: 4,
                  child: QRView(
                    key: qrKey,
                    onQRViewCreated: (ctr) {
                      ctr.scannedDataStream.listen((scanData) async {
                        if (scanData.code != null &&
                            _lastResult != scanData.code) {
                          _lastResult = scanData.code!;
                          await getproduct(scanData.code!).then((value) {
                            if (!_isLoading && _isCorrect) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ProductDetail(
                                    product: _product,
                                  ),
                                ),
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    lang.S
                                        .of(context)
                                        .qrscanNoProduct(scanData.code!),
                                  ),
                                ),
                              );

                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const Home(),
                                ),
                              );
                              /*if (Platform.isAndroid) {
                                controller!.pauseCamera();
                              }
                              controller!.resumeCamera();*/
                            }
                          });
                        }
                      });
                    },
                    overlay: QrScannerOverlayShape(
                        borderColor: Colors.red,
                        borderRadius: 10,
                        borderLength: 30,
                        borderWidth: 10,
                        cutOutSize: (MediaQuery.of(context).size.width < 400 ||
                                MediaQuery.of(context).size.height < 400)
                            ? 250.0
                            : 350.0),
                    onPermissionSet: (ctrl, p) =>
                        _onPermissionSet(context, ctrl, p),
                  ),
                ),
              ],
            ),
    );
  }

  //DADA-202401-0015-SHIRT-S!QAZxsw2#EDC

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    log('${DateTime.now().toIso8601String()}_onPermissionSet $p');

    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('no Permission')),
      );
    }
  }
}
