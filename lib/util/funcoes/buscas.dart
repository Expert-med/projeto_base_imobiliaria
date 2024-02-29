import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';

class Buscas {
  FirebaseFirestore db = FirebaseFirestore.instance;

  Future<List<Map<String, dynamic>>> buscarTodosImoveis() async {
    List<Map<String, dynamic>> filteredInstrumentais = [];

    QuerySnapshot snapshot = await db.collection("imoveis_final_teste").get();

    if (snapshot.docs.isNotEmpty) {
      filteredInstrumentais = snapshot.docs.map((doc) {
        Map<String, dynamic> instrumentalData =
            doc.data() as Map<String, dynamic>;
        return instrumentalData;
      }).toList();
    }

    return filteredInstrumentais;
  }

}
