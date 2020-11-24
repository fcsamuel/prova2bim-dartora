import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:prova_dartora/telas/aba-conversas.dart';
import 'package:prova_dartora/telas/aba-registros.dart';
import 'package:prova_dartora/telas/aba-sintomas.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
/*
  Completer<GoogleMapController> _controller = Completer();
  CameraPosition _position = CameraPosition(target: LatLng(-24.720739, -53.713464), zoom: 10);
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};*/

  TabController _tabController;
  String _emailUsuarioLogado = "";
  List<String> itensMenu = ["Configurações", "Deslogar"];

  _escolhaMenu(String itemEscolhido){
    switch (itemEscolhido){
      case "Configurações":
        Navigator.pushReplacementNamed(context, "/configuracoes");
        break;
      case "Deslogar":
        _deslogarUsuario();
        break;
    }
    print("Item escolhido foi o : " + itemEscolhido);
  }

  _deslogarUsuario() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    await auth.signOut();
    Navigator.pushReplacementNamed(context, "/login");

  }
/*
  _onMapCreate(GoogleMapController googleMapController) {
    _controller.complete(googleMapController);
  }

  _recuperarLocalizacao() async {
    Position position = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    final Marker marker = Marker(
      markerId: MarkerId("marker"),
      position: LatLng(position.latitude, position.longitude),
      infoWindow: InfoWindow(title: 'Posicao: '+position.latitude.toString() +' - '+ position.longitude.toString()),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
    );
    setState(() {
      _position = CameraPosition(target: LatLng(position.latitude, position.longitude), zoom: 10);
      markers[MarkerId("marker")] = marker;
    });
  }*/

  @override
  void initState() {
    _tabController = TabController(length: 3, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Contato Médico"),
        bottom: TabBar(
          indicatorWeight: 4,
          labelStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          controller: _tabController,
          indicatorColor: Colors.white,
          tabs: <Widget>[
            Tab(
              text: "Sintomas",
            ),
            Tab(
              text: "Registros",
            ),
            Tab(
              text: "Conversas"
            )
          ],
        ),

        //botões de ação definidos na lista de itens
        actions: <Widget>[
          PopupMenuButton(
              //onSelected: _escolhaMenu, //método para tratar uma das opções escolhidas
              itemBuilder: (context){ //criou as opções de menu
                return itensMenu.map((String item){ //percorre cada item como forma de objeto
                  return PopupMenuItem<String>(
                    value: item,
                    child: Text(item),
                  );
                }).toList();
              })
        ],

      ),
      body: TabBarView(
          controller: _tabController,
          children: <Widget>[AbaSintomas(), AbaRegistros(), AbaConversas()]),
    );
  }
}
