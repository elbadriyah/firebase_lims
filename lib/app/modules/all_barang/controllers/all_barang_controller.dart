import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_crud_firebase/app/routes/app_pages.dart';
import 'package:get/get.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class AllBarangController extends GetxController {
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  TextEditingController searchC = TextEditingController();

  void search() {}

  void downloaditems() async {
    final pdf = pw.Document();

    var getData = await firestore.collection("items").get();

    List items = [];

    for (var element in getData.docs) {
      items.add(element.data());
    }

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        build: (context) {
          List<pw.TableRow> allData = List.generate(
            items.length,
            (index) {
              var item = items[index];

              return pw.TableRow(
                children: [
                  // No
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(20),
                    child: pw.Text(
                      "${index + 1}",
                      textAlign: pw.TextAlign.center,
                      style: const pw.TextStyle(
                        fontSize: 10,
                      ),
                    ),
                  ),
                  // Kode Barang
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(20),
                    child: pw.Text(
                      item["nama_barang"],
                      textAlign: pw.TextAlign.center,
                      style: const pw.TextStyle(
                        fontSize: 10,
                      ),
                    ),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(20),
                    child: pw.Text(
                      item["spesifikasi"],
                      textAlign: pw.TextAlign.center,
                      style: const pw.TextStyle(
                        fontSize: 10,
                      ),
                    ),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(20),
                    child: pw.BarcodeWidget(
                      color: PdfColor.fromHex("#000000"),
                      barcode: pw.Barcode.qrCode(),
                      data: item["task_id"],
                      height: 50,
                      width: 50,
                    ),
                  ),
                ],
              );
            },
          );
          return [
            pw.Center(
              child: pw.Text(
                "DOWNLOAD DATA BARANG",
                textAlign: pw.TextAlign.center,
                style: const pw.TextStyle(
                  fontSize: 24,
                ),
              ),
            ),
            pw.SizedBox(height: 20),
            pw.Table(
              border: pw.TableBorder.all(
                color: PdfColor.fromHex("#000000"),
                width: 2,
              ),
              children: [
                pw.TableRow(
                  children: [
                    // No
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(20),
                      child: pw.Text(
                        "No",
                        textAlign: pw.TextAlign.center,
                        style: pw.TextStyle(
                          fontSize: 10,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                    ),
                    // Kode Barang
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(20),
                      child: pw.Text(
                        "Nama barang",
                        textAlign: pw.TextAlign.center,
                        style: pw.TextStyle(
                          fontSize: 10,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                    ),

                    // QR Code
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(20),
                      child: pw.Text(
                        "Spesifikasi",
                        textAlign: pw.TextAlign.center,
                        style: pw.TextStyle(
                          fontSize: 10,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                    ),

                    // QR Code
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(20),
                      child: pw.Text(
                        "QR Code",
                        textAlign: pw.TextAlign.center,
                        style: pw.TextStyle(
                          fontSize: 10,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                ...allData,
              ],
            ),
          ];
        },
      ),
    );

    // simpan
    Uint8List bytes = await pdf.save();

    // buat file kosong di direktori
    final dir = await getTemporaryDirectory();
    final file = File('${dir.path}/mydocument.pdf');
    await file.writeAsBytes(bytes);

    // open pdf
    await OpenFile.open(file.path);
  }

  Future<Map<String, dynamic>> getBarangById(String kodeBarang) async {
    try {
      var hasil = await firestore
          .collection("items")
          .where("task_id", isEqualTo: kodeBarang)
          .get();

      if (hasil.docs.isEmpty) {
        return {
          "error": true,
          "message": "Tidak ada Barang di database",
        };
      }

      Map<String, dynamic> data = hasil.docs.first.data();

      return {
        "error": false,
        "message": "Berhasil mendapatkan detail Barang dari kode ini.",
        "data": data,
      };
    } catch (e) {
      return {
        "error": true,
        "message": "Tidak dapat mendapatkan detail Barang dari kode ini.",
      };
    }
  }

  void scanQr() async {
    String barcode = await FlutterBarcodeScanner.scanBarcode(
      "#000000",
      "CANCEL",
      true,
      ScanMode.QR,
    );
    log(barcode);
    Map<String, dynamic> hasil = await getBarangById(barcode);
    if (hasil["error"] == false) {
      print(hasil);
      // var todoBarang = data[Index].data();
      Get.toNamed(
        Routes.DETAIL_BARANG,
        arguments: {
          "id": "${hasil["data"]["task_id"]}",
          "nama_barang": "${hasil["data"]["nama_barang"]}",
          "spesifikasi": "${hasil["data"]["spesifikasi"]}",
          "merk": "${hasil["data"]["merk"]}",
          "tahun_beli": "${hasil["data"]["tahun_beli"]}",
          "sumber_dana": "${hasil["data"]["sumber_dana"]}",
          "jumlah": "${hasil["data"]["jumlah"]}",
          "image": "${hasil["data"]["image"]}"
        },
      );
    } else {
      Get.snackbar(
        "Error",
        hasil["message"],
        duration: const Duration(seconds: 2),
      );
    }
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getAllResult() async {
    String uid = auth.currentUser!.uid;
    QuerySnapshot<Map<String, dynamic>> query = await firestore
        .collection("items")
        .orderBy(
          "created_at",
          descending: true,
        )
        .get();
    return query;
  }
}
