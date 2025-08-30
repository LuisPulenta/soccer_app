import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';

import '../components/loader_component.dart';
import '../helpers/api_helper.dart';
import '../models/models.dart';

class InvitarScreen extends StatefulWidget {
  final GroupBet group;
  final User user;
  final int tournamentId;
  final Token token;

  const InvitarScreen({
    super.key,
    required this.group,
    required this.user,
    required this.tournamentId,
    required this.token,
  });

  @override
  State<InvitarScreen> createState() => _InvitarScreenState();
}

class _InvitarScreenState extends State<InvitarScreen> {
  //***********************************************************************
  //******************** Declaración de Variables *************************
  //***********************************************************************

  bool _showLoader = false;

  String _email = '';
  String _emailError = '';
  bool _emailShowError = false;
  final TextEditingController _emailController = TextEditingController();

  //***********************************************************************
  //******************** Init State ***************************************
  //***********************************************************************
  @override
  void initState() {
    super.initState();
  }

  //***********************************************************************
  //******************** Pantalla *****************************************
  //***********************************************************************
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Invitar al Grupo ${widget.group.name}'),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 8, 69, 48),
      ),
      body: Container(
        color: const Color(0xFF00D99D),
        child: Stack(
          children: [
            Column(
              children: [
                const SizedBox(height: 20),
                ClipRRect(
                  borderRadius: BorderRadius.circular(200),
                  child: CachedNetworkImage(
                    imageUrl: widget.group.logoFullPath,
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                    fit: BoxFit.cover,
                    height: 180,
                    width: 180,
                    placeholder: (context, url) => const Image(
                      image: AssetImage('assets/loading.gif'),
                      fit: BoxFit.cover,
                      height: 180,
                      width: 180,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                _showEmail(),
                const SizedBox(height: 20),
                _showButton(),
              ],
            ),
            _showLoader
                ? const LoaderComponent(text: 'Por favor espere...')
                : Container(),
          ],
        ),
      ),
    );
  }

  //-----------------------------------------------------------------------
  //-------------------------- showEMail ----------------------------------
  //-----------------------------------------------------------------------
  Widget _showEmail() {
    return Container(
      padding: const EdgeInsets.all(10),
      child: TextField(
        controller: _emailController,
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
          hintText: 'Ingresa Email...',
          labelText: 'Email',
          errorText: _emailShowError ? _emailError : null,
          suffixIcon: const Icon(Icons.email),
          fillColor: Colors.white,
          filled: true,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
        onChanged: (value) {
          _email = value;
        },
      ),
    );
  }

  //-----------------------------------------------------------------------
  //-------------------------- showButton ---------------------------------
  //-----------------------------------------------------------------------
  Widget _showButton() {
    return Container(
      margin: const EdgeInsets.only(left: 10, right: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Expanded(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color.fromARGB(255, 8, 69, 48),
                minimumSize: const Size(100, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              onPressed: () => _invitar(),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.mail),
                  SizedBox(width: 15),
                  Text('Invitar'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  //***********************************************************************
  //******************** Método _invitar **********************************
  //***********************************************************************
  void _invitar() async {
    if (!validateFields()) {
      return;
    }
    _sendEmail();
  }

  //***********************************************************************
  //******************** Método validateFields ****************************
  //***********************************************************************
  bool validateFields() {
    bool isValid = true;

    if (_email.isEmpty) {
      isValid = false;
      _emailShowError = true;
      _emailError = 'Debes ingresar un Email válido';
    } else if (!EmailValidator.validate(_email)) {
      isValid = false;
      _emailShowError = true;
      _emailError = 'Debes ingresar un Email válido';
    } else {
      _emailShowError = false;
    }
    setState(() {});
    return isValid;
  }

  //***********************************************************************
  //******************** Método _sendEmail ********************************
  //***********************************************************************
  void _sendEmail() async {
    setState(() {
      _showLoader = true;
    });

    var connectivityResult = await Connectivity().checkConnectivity();

    if (connectivityResult == ConnectivityResult.none) {
      setState(() {
        _showLoader = false;
      });
      await showAlertDialog(
        context: context,
        title: 'Error',
        message: 'Verifica que estés conectado a Internet',
        actions: <AlertDialogAction>[
          const AlertDialogAction(key: null, label: 'Aceptar'),
        ],
      );
      return;
    }

    Map<String, dynamic> request = {
      'playerId': widget.user.id,
      'groupBetId': widget.group.id,
      'email': _email,
    };

    Response response = await ApiHelper.post(
      '/api/GroupBets/Invitar',
      request,
      widget.token,
    );

    setState(() {
      _showLoader = false;
    });

    if (!response.isSuccess) {
      await showAlertDialog(
        context: context,
        title: 'Error',
        message: response.message,
        actions: <AlertDialogAction>[
          const AlertDialogAction(key: null, label: 'Aceptar'),
        ],
      );
      return;
    }

    await showAlertDialog(
      context: context,
      title: 'Confirmación',
      message:
          'Se ha enviado un correo electrónico al usuario con su solicitud, esperamos a que responda pronto!',
      actions: <AlertDialogAction>[
        const AlertDialogAction(key: null, label: 'Aceptar'),
      ],
    );

    Navigator.pop(context, 'yes');
  }
}
