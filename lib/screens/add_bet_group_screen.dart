import 'dart:convert';
import 'dart:io';
import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:camera/camera.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:soccer_app/components/loader_component.dart';
import 'package:soccer_app/helpers/api_helper.dart';
import 'package:soccer_app/models/models.dart';
import 'package:soccer_app/screens/take_picture_screen.dart';

class AddBetGroupScreen extends StatefulWidget {
  final Token token;
  final User user;

  AddBetGroupScreen({required this.token, required this.user});

  @override
  State<AddBetGroupScreen> createState() => _AddBetGroupScreenState();
}

class _AddBetGroupScreenState extends State<AddBetGroupScreen> {
//***********************************************************************
//******************** Declaración de Variables *************************
//***********************************************************************
  bool _showLoader = false;
  bool _photoChanged = false;
  late XFile _image;

  String _name = '';
  String _nameError = '';
  bool _nameShowError = false;
  TextEditingController _nameController = TextEditingController();

  int _tournamentSelected = 0;
  String _tournamentSelectedError = '';
  bool _tournamentSelectedShowError = false;
  List<Tournament> _tournaments = [];

  String errorPhoto = '';

//***********************************************************************
//******************** Init State ***************************************
//***********************************************************************
  @override
  void initState() {
    super.initState();
    _getTournaments();
  }

//***********************************************************************
//******************** Pantalla *****************************************
//***********************************************************************
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF00D99D),
      appBar: AppBar(
        title: Text('Nuevo Grupo de Apuestas'),
        centerTitle: true,
        backgroundColor: Color.fromARGB(255, 8, 69, 48),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: <Widget>[
                _showPhoto(),
                Text(errorPhoto,
                    style: TextStyle(color: Colors.red, fontSize: 18)),
                _showName(),
                _showTournaments(),
                SizedBox(
                  height: 20,
                ),
                _showButtons(),
                SizedBox(
                  height: 10,
                ),
              ],
            ),
          ),
          _showLoader
              ? LoaderComponent(
                  text: 'Por favor espere...',
                )
              : Container(),
        ],
      ),
    );
  }

//-----------------------------------------------------------------------
//-------------------------- showPhoto ----------------------------------
//-----------------------------------------------------------------------
  Widget _showPhoto() {
    return InkWell(
      child: Stack(children: <Widget>[
        Container(
          margin: EdgeInsets.only(top: 10),
          child: widget.user.userId.isEmpty && !_photoChanged
              ? Image(
                  image: AssetImage('assets/noimage.png'),
                  width: 160,
                  height: 160,
                  fit: BoxFit.cover)
              : ClipRRect(
                  borderRadius: BorderRadius.circular(80),
                  child: _photoChanged
                      ? Image.file(
                          File(_image.path),
                          width: 160,
                          height: 160,
                          fit: BoxFit.cover,
                        )
                      : Image(
                          image: AssetImage('assets/noimage.png'),
                          fit: BoxFit.cover,
                          height: 160,
                          width: 160,
                        ),
                ),
        ),
        Positioned(
            bottom: 0,
            left: 100,
            child: InkWell(
              onTap: () => _takePicture(),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: Container(
                  color: Colors.green[50],
                  height: 60,
                  width: 60,
                  child: Icon(
                    Icons.photo_camera,
                    size: 40,
                    color: Color.fromARGB(255, 8, 69, 48),
                  ),
                ),
              ),
            )),
        Positioned(
            bottom: 0,
            left: 0,
            child: InkWell(
              onTap: () => _selectPicture(),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: Container(
                  color: Colors.green[50],
                  height: 60,
                  width: 60,
                  child: Icon(
                    Icons.image,
                    size: 40,
                    color: Color.fromARGB(255, 8, 69, 48),
                  ),
                ),
              ),
            )),
      ]),
    );
  }

//-----------------------------------------------------------------------
//-------------------------- showName ----------------------------------
//-----------------------------------------------------------------------
  Widget _showName() {
    return Container(
      padding: EdgeInsets.all(10),
      child: TextField(
        controller: _nameController,
        decoration: InputDecoration(
            hintText: 'Ingresa nombre...',
            labelText: 'Nombre',
            errorText: _nameShowError ? _nameError : null,
            suffixIcon: Icon(Icons.closed_caption),
            fillColor: Colors.white,
            filled: true,
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
        onChanged: (value) {
          _name = value;
        },
      ),
    );
  }

//-----------------------------------------------------------------------
//-------------------------- showTournaments --------------------------------
//-----------------------------------------------------------------------
  Widget _showTournaments() {
    return Container(
      padding: EdgeInsets.all(10),
      child: _tournaments.length == 0
          ? Text('')
          : DropdownButtonFormField(
              items: _getComboTournaments(),
              value: _tournamentSelected,
              onChanged: (option) {
                _tournamentSelected = option as int;
                setState(() {});
              },
              decoration: InputDecoration(
                hintText: 'Seleccione un Torneo...',
                labelText: 'Torneo',
                fillColor: Colors.white,
                filled: true,
                errorText: _tournamentSelectedShowError
                    ? _tournamentSelectedError
                    : null,
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              )),
    );
  }

//***********************************************************************
//******************** Método getComboTournaments ***************************
//***********************************************************************
  List<DropdownMenuItem<int>> _getComboTournaments() {
    List<DropdownMenuItem<int>> list = [];
    list.add(DropdownMenuItem(
      child: Text('Seleccione un Torneo...'),
      value: 0,
    ));

    _tournaments.forEach((tournament) {
      list.add(DropdownMenuItem(
        child: Text(tournament.name),
        value: tournament.id,
      ));
    });

    return list;
  }

//***********************************************************************
//******************** Método TakePicture *******************************
//***********************************************************************
  void _takePicture() async {
    WidgetsFlutterBinding.ensureInitialized();
    final cameras = await availableCameras();
    var firstCamera = cameras.first;
    var response1 = await showAlertDialog(
        context: context,
        title: 'Seleccionar cámara',
        message: '¿Qué cámara desea utilizar?',
        actions: <AlertDialogAction>[
          AlertDialogAction(key: 'no', label: 'Trasera'),
          AlertDialogAction(key: 'yes', label: 'Delantera'),
          AlertDialogAction(key: 'cancel', label: 'Cancelar'),
        ]);
    if (response1 == 'yes') {
      firstCamera = cameras.first;
    }
    if (response1 == 'no') {
      firstCamera = cameras.last;
    }

    if (response1 != 'cancel') {
      Response? response = await Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => TakePictureScreen(
                    camera: firstCamera,
                  )));
      if (response != null) {
        setState(() {
          _photoChanged = true;
          _image = response.result;
        });
      }
    }
  }

//***********************************************************************
//******************** Método SelectPicture *****************************
//***********************************************************************
  void _selectPicture() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _photoChanged = true;
        _image = image;
      });
    }
  }

//***********************************************************************
//******************** Método getTournaments ****************************
//***********************************************************************
  Future<Null> _getTournaments() async {
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
            AlertDialogAction(key: null, label: 'Aceptar'),
          ]);
      return;
    }

    Response response = await ApiHelper.getTournaments(widget.token);

    setState(() {
      _showLoader = false;
    });

    if (!response.isSuccess) {
      await showAlertDialog(
          context: context,
          title: 'Error',
          message: response.message,
          actions: <AlertDialogAction>[
            AlertDialogAction(key: null, label: 'Aceptar'),
          ]);
      return;
    }

    setState(() {
      _tournaments = response.result;
      _tournaments.sort((a, b) {
        return a.name
            .toString()
            .toLowerCase()
            .compareTo(b.name.toString().toLowerCase());
      });
    });
  }

//-----------------------------------------------------------------------
//-------------------------- showButtons -------------------------------
//-----------------------------------------------------------------------
  Widget _showButtons() {
    return Center(
      child: Container(
        width: double.infinity,
        margin: EdgeInsets.only(left: 10, right: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            _showSaveButton(),
          ],
        ),
      ),
    );
  }

//-----------------------------------------------------------------------
//-------------------------- showSaveButton -----------------------------
//-----------------------------------------------------------------------
  Widget _showSaveButton() {
    return Expanded(
      child: ElevatedButton(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.save),
            SizedBox(
              width: 15,
            ),
            Text('Guardar'),
          ],
        ),
        style: ElevatedButton.styleFrom(
          primary: Color.fromARGB(255, 8, 69, 48),
          minimumSize: Size(double.infinity, 50),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
        ),
        onPressed: () => _save(),
      ),
    );
  }

//***********************************************************************
//******************** save *********************************************
//***********************************************************************
  void _save() {
    if (!validateFields()) {
      return;
    }
    _saveRecord();
  }

//***********************************************************************
//******************** Método validateFields ****************************
//***********************************************************************
  bool validateFields() {
    bool isValid = true;
    errorPhoto = '';
    if (!_photoChanged) {
      errorPhoto = 'El Grupo debe tener una foto';
      isValid = false;
    }

    if (_name.isEmpty) {
      isValid = false;
      _nameShowError = true;
      _nameError = 'Debes ingresar un nombre';
    } else {
      _nameShowError = false;
    }

    if (_tournamentSelected == 0) {
      isValid = false;
      _tournamentSelectedShowError = true;
      _tournamentSelectedError = 'Debes ingresar un Torneo';
    } else {
      _tournamentSelectedShowError = false;
    }
    setState(() {});

    return isValid;
  }

//***********************************************************************
//******************** saveRecord ***************************************
//***********************************************************************
  _saveRecord() async {
    setState(() {
      _showLoader = true;
    });

    String base64image = '';
    if (_photoChanged) {
      List<int> imageBytes = await _image.readAsBytes();
      base64image = base64Encode(imageBytes);
    }

    Map<String, dynamic> request = {
      'name': _name,
      'tournamentId': _tournamentSelected,
      'pictureArray': base64image,
      'playerEmail': widget.user.email,
      'creationDate': DateTime.now().toString(),
    };

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
            AlertDialogAction(key: null, label: 'Aceptar'),
          ]);
      return;
    }

    Response response =
        await ApiHelper.post('/api/GroupBets/', request, widget.token);

    setState(() {
      _showLoader = false;
    });

    if (!response.isSuccess) {
      await showAlertDialog(
          context: context,
          title: 'Error',
          message: response.message,
          actions: <AlertDialogAction>[
            AlertDialogAction(key: null, label: 'Aceptar'),
          ]);
      return;
    }
    Navigator.pop(context, 'yes');
  }
}
