import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:prova_dartora/home.dart';
import 'package:prova_dartora/input-customize.dart';
import 'package:prova_dartora/model/usuario.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> with SingleTickerProviderStateMixin {

  TextEditingController _controllerEmail = TextEditingController();
  TextEditingController _controllerSenha = TextEditingController();
  String _result = "";

  AnimationController _controllerAnimacao;
  Animation<double> _animacaoBlur;
  Animation<double> _animacaoFade;
  Animation<double> _animacaoSize;

  _validarCampos() {
    String email = _controllerEmail.text.toString();
    String senha = _controllerSenha.text.toString();

    if (email.isNotEmpty && email.contains("@")) {
      if (senha.isNotEmpty) {
        setState(() {
          _result = "Login sucesso!";
          print(_result);
        });

        Usuario usuario = Usuario();
        usuario.email = email;
        usuario.senha = senha;

        _autenticandoUsuario(usuario);
      } else {
        setState(() {
          _result = "Favor preencher a senha!";
          print(_result);
        });
      }
    } else {
      setState(() {
        _result = "Favor preencher o e-mail utilizando um @!";
        print(_result);
      });
    }
  }
  
  _autenticandoUsuario(Usuario usuario) {
    FirebaseAuth auth = FirebaseAuth.instance;

    auth
        .signInWithEmailAndPassword(
        email: usuario.email, password: usuario.senha)
        .then((firebaserUser) {
      Navigator.pushReplacementNamed(context, "/home");
    }).catchError((error) {
      setState(() {
        _result = "Erro au autenticar o usuário!" + error.toString();
        print(_result);
      });
    });
  }

  Future _verificarUsuarioLogado() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    FirebaseUser usuarioLogado = await auth.currentUser();

    auth.signOut(); //verificou que o usuário está logado, faça o logoff

    if (usuarioLogado != null) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => Home()));
    }
  }

  @override
  void initState() {
    super.initState();

    _controllerAnimacao =
        AnimationController(duration: Duration(milliseconds: 4000), vsync: this);

    _animacaoBlur = Tween<double>(begin: 5, end: 0)
        .animate(CurvedAnimation(parent: _controllerAnimacao, curve: Curves.ease));

    _animacaoFade = Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(parent: _controllerAnimacao, curve: Curves.easeInOutQuint));

    _animacaoSize = Tween<double>(begin: 0, end: 500).animate(
        CurvedAnimation(parent: _controllerAnimacao, curve: Curves.decelerate));

    _controllerAnimacao.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("images/background.png"),
            fit: BoxFit.cover
          )
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              AnimatedBuilder(
                animation: _animacaoBlur,
                builder: (context, widget) {
                  return Container(
                    height: 400,
                    /*decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage("images/fundo.jpeg"),
                            fit: BoxFit.fill)),*/
                    child: BackdropFilter(
                      filter: ImageFilter.blur(
                          sigmaX: _animacaoBlur.value,
                          sigmaY: _animacaoBlur.value),
                      child: Stack(
                        children: <Widget>[
                          Positioned(
                            left: 10,
                            child: FadeTransition(
                              opacity: _animacaoFade,
                              child: Image.asset("images/detalhe1.png"),
                            ),
                          ),
                          Positioned(
                            left: 50,
                            child: FadeTransition(
                              opacity: _animacaoFade,
                              child: Image.asset("images/detalhe2.png"),
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                },
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 32),
              ),
              Padding(
                padding: EdgeInsets.only(left: 30, right: 30),
                child: Column(
                  children: <Widget>[
                    AnimatedBuilder(
                      animation: _animacaoSize,
                      builder: (context, widget) {
                        return Container(
                          width: _animacaoSize.value,
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.grey[200],
                                    blurRadius: 15,
                                    spreadRadius: 4
                                )
                              ]),
                          child: Column(
                            children: <Widget>[
                              InputCustomize(
                                hint: "Email",
                                obscure: false,
                                icon: Icon(Icons.person),
                                controller: _controllerEmail,
                              ),
                              InputCustomize(
                                hint: "Senha",
                                obscure: false,
                                icon: Icon(Icons.lock),
                                controller: _controllerSenha,
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    AnimatedBuilder(
                        animation: _animacaoSize,
                        builder: (context, widget) {
                          return InkWell(
                            onTap: () {
                              _validarCampos();
                            },
                            child: Container(
                              width: _animacaoSize.value,
                              height: 50,
                              child: Center(
                                child: Text(
                                  "Entrar",
                                  style: TextStyle(
                                      fontSize: 20,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold
                                  ),
                                ),
                              ),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  gradient: LinearGradient(colors: [
                                    Color.fromRGBO(255, 100, 127, 1),
                                    Color.fromRGBO(255, 123, 145, 1),
                                  ])
                              ),
                            ),
                          );
                        }
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    FadeTransition(
                      opacity: _animacaoFade,
                      child: GestureDetector(
                        child: Text(
                          "Esqueci minha senha!",
                          style: TextStyle(
                              color: Colors.pink, fontWeight: FontWeight.bold),
                        ),
                        onTap: () {
                          Navigator.pushReplacementNamed(context, "/recuperarsenha");
                        },
                      ),
                    )
                  ],
                ),
              ),
              Center(
                child: GestureDetector(
                  child: Text(
                    "Não possui conta? Cadastre-se!",
                    style: TextStyle(color: Colors.black),
                  ),
                  onTap: () {
                    Navigator.pushReplacementNamed(context, "/cadastro");
                  },
                ),
              )
            ],
          ),
        ),

        //padding: EdgeInsets.all(18),

      ),
    );
  }
}

/*
Padding(
  padding: EdgeInsets.only(bottom: 8),
  child: TextField(
    controller: _controllerEmail,
    autofocus: true,
    keyboardType: TextInputType.emailAddress,
    style: TextStyle(fontSize: 20),
    decoration: InputDecoration(
        contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
        hintText: "E-mail",
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(32))),
  ),
),*/

/*child: TextField(
                    obscureText: true,
                    controller: _controllerSenha,
                    autofocus: true,
                    keyboardType: TextInputType.text,
                    style: TextStyle(fontSize: 20),
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                        hintText: "Senha",
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(32))),
                  ),*/
/*
Padding(
  padding: EdgeInsets.only(bottom: 10, top: 16),
  child: RaisedButton(
    child: Text(
      "Entrar",
      style: TextStyle(color: Colors.white, fontSize: 20),
    ),
    color: Colors.lightBlueAccent,
    padding: EdgeInsets.fromLTRB(32, 16, 32, 16),
    shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(32)),
    onPressed: () {
      _validarCampos();
    }
  ),
),*/
