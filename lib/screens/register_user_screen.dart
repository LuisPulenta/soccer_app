import 'dart:convert';
import 'dart:io';

import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:camera/camera.dart';
import 'package:connectivity/connectivity.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../components/loader_component.dart';
import '../helpers/api_helper.dart';
import '../models/models.dart';
import 'screens.dart';

class RegisterUserScreen extends StatefulWidget {
  final Token token;
  final User user;
  final bool myProfile;

  const RegisterUserScreen(
      {super.key,
      required this.token,
      required this.user,
      required this.myProfile});

  @override
  _RegisterUserScreenState createState() => _RegisterUserScreenState();
}

class _RegisterUserScreenState extends State<RegisterUserScreen> {
//***********************************************************************
//******************** Declaración de Variables *************************
//***********************************************************************
  bool _showLoader = false;
  bool _photoChanged = false;
  late XFile _image;

  String _firstName = '';
  String _firstNameError = '';
  bool _firstNameShowError = false;
  final TextEditingController _firstNameController = TextEditingController();

  String _lastName = '';
  String _lastNameError = '';
  bool _lastNameShowError = false;
  final TextEditingController _lastNameController = TextEditingController();

  String _nickName = '';
  String _nickNameError = '';
  bool _nickNameShowError = false;
  final TextEditingController _nickNameController = TextEditingController();

  String _email = '';
  String _emailError = '';
  bool _emailShowError = false;
  final TextEditingController _emailController = TextEditingController();

  bool _passwordShow = false;

  String _password = '';
  String _passwordError = '';
  bool _passwordShowError = false;
  final TextEditingController _passwordController = TextEditingController();

  String _confirm = '';
  String _confirmError = '';
  bool _confirmShowError = false;
  final TextEditingController _confirmController = TextEditingController();

  int _leagueSelected = 0;
  String _leagueSelectedError = '';
  bool _leagueSelectedShowError = false;
  List<League> _leagues = [];

  int _teamSelected = 0;
  String _teamSelectedError = '';
  bool _teamSelectedShowError = false;
  List<Team> _teams = [];

//***********************************************************************
//******************** Init State ***************************************
//***********************************************************************
  @override
  void initState() {
    super.initState();
    _getLeagues();
  }

//***********************************************************************
//******************** Pantalla *****************************************
//***********************************************************************
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xFF00D99D),
        appBar: AppBar(
          title: widget.myProfile == false
              ? const Text('Nuevo Usuario')
              : Text('${widget.user.firstName} ${widget.user.lastName}'),
          centerTitle: true,
          backgroundColor: const Color.fromARGB(255, 8, 69, 48),
        ),
        body: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  _showPhoto(),
                  _showFirstName(),
                  _showLastName(),
                  _showNickName(),
                  _showLeagues(),
                  _showTeams(),
                  _showEmail(),
                  _showPassword(),
                  _showConfirm(),
                  _showButtons(),
                  const SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),
            _showLoader
                ? const LoaderComponent(
                    text: 'Por favor espere...',
                  )
                : Container(),
          ],
        ));
  }

//-----------------------------------------------------------------------
//-------------------------- showPhoto ----------------------------------
//-----------------------------------------------------------------------
  Widget _showPhoto() {
    return InkWell(
      child: Stack(children: <Widget>[
        Container(
          margin: const EdgeInsets.only(top: 10),
          child: widget.user.userId.isEmpty && !_photoChanged
              ? const Image(
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
                      : CachedNetworkImage(
                          imageUrl: widget.user.pictureFullPath,
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.error),
                          fit: BoxFit.cover,
                          height: 160,
                          width: 160,
                          placeholder: (context, url) => const Image(
                            image: AssetImage('assets/nouser.png'),
                            fit: BoxFit.cover,
                            height: 160,
                            width: 160,
                          ),
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
                  child: const Icon(
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
                  child: const Icon(
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
//-------------------------- showFirstName ----------------------------------
//-----------------------------------------------------------------------
  Widget _showFirstName() {
    return Container(
      padding: const EdgeInsets.all(10),
      child: TextField(
        controller: _firstNameController,
        decoration: InputDecoration(
            isDense: true,
            contentPadding: const EdgeInsets.symmetric(horizontal: 10),
            hintText: 'Ingresa nombres...',
            labelText: 'Nombres',
            errorText: _firstNameShowError ? _firstNameError : null,
            suffixIcon: const Icon(Icons.person),
            fillColor: Colors.white,
            filled: true,
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
        onChanged: (value) {
          _firstName = value;
        },
      ),
    );
  }

//-----------------------------------------------------------------------
//-------------------------- showLastName -------------------------------
//-----------------------------------------------------------------------
  Widget _showLastName() {
    return Container(
      padding: const EdgeInsets.all(10),
      child: TextField(
        controller: _lastNameController,
        decoration: InputDecoration(
            isDense: true,
            contentPadding: const EdgeInsets.symmetric(horizontal: 10),
            hintText: 'Ingresa nombres...',
            labelText: 'Apellido',
            errorText: _lastNameShowError ? _lastNameError : null,
            suffixIcon: const Icon(Icons.person),
            fillColor: Colors.white,
            filled: true,
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
        onChanged: (value) {
          _lastName = value;
        },
      ),
    );
  }

//-----------------------------------------------------------------------
//-------------------------- showNickName -------------------------------
//-----------------------------------------------------------------------
  Widget _showNickName() {
    return Container(
      padding: const EdgeInsets.all(10),
      child: TextField(
        controller: _nickNameController,
        decoration: InputDecoration(
            isDense: true,
            contentPadding: const EdgeInsets.symmetric(horizontal: 10),
            hintText: 'Ingresa apodo...',
            labelText: 'Apodo',
            errorText: _nickNameShowError ? _nickNameError : null,
            suffixIcon: const Icon(Icons.sentiment_satisfied),
            fillColor: Colors.white,
            filled: true,
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
        onChanged: (value) {
          _nickName = value;
        },
      ),
    );
  }

//-----------------------------------------------------------------------
//-------------------------- showLeagues --------------------------------
//-----------------------------------------------------------------------
  Widget _showLeagues() {
    return Container(
      padding: const EdgeInsets.all(10),
      child: _leagues.isEmpty
          ? const Text('')
          : DropdownButtonFormField(
              isDense: true,
              items: _getComboLeagues(),
              value: _leagueSelected,
              onChanged: (option) {
                _leagueSelected = option as int;
                _teams = [];
                _teamSelected = 0;

                for (var league in _leagues) {
                  if (league.id == _leagueSelected) {
                    _teams = league.teams;
                  }
                }

                _teams.sort((a, b) {
                  return a.name
                      .toString()
                      .toLowerCase()
                      .compareTo(b.name.toString().toLowerCase());
                });

                _getComboTeams();

                _teamSelected = 0;
                setState(() {});
              },
              decoration: InputDecoration(
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                hintText: 'Seleccione una Liga...',
                labelText: 'Liga',
                fillColor: Colors.white,
                filled: true,
                errorText:
                    _leagueSelectedShowError ? _leagueSelectedError : null,
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              )),
    );
  }

//-----------------------------------------------------------------------
//-------------------------- showTeams --------------------------------
//-----------------------------------------------------------------------
  Widget _showTeams() {
    return _teams.isEmpty
        ? Container()
        : Container(
            padding: const EdgeInsets.all(10),
            child: DropdownButtonFormField(
                isDense: true,
                items: _getComboTeams(),
                value: _teamSelected,
                onChanged: (option) {
                  _teamSelected = option as int;
                  setState(() {});
                },
                decoration: InputDecoration(
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                  hintText: 'Seleccione un Equipo...',
                  labelText: 'Equipo',
                  fillColor: Colors.white,
                  filled: true,
                  errorText: _teamSelectedShowError ? _teamSelectedError : null,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)),
                )),
          );
  }

//-----------------------------------------------------------------------
//-------------------------- showEMail ----------------------------------
//-----------------------------------------------------------------------
  Widget _showEmail() {
    return widget.myProfile == false
        ? Container(
            padding: const EdgeInsets.all(10),
            child: TextField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 5),
                  hintText: 'Ingresa Email...',
                  labelText: 'Email',
                  errorText: _emailShowError ? _emailError : null,
                  suffixIcon: const Icon(Icons.email),
                  fillColor: Colors.white,
                  filled: true,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10))),
              onChanged: (value) {
                _email = value;
              },
            ),
          )
        : Container();
  }

//-----------------------------------------------------------------------
//-------------------------- showPassword -------------------------------
//-----------------------------------------------------------------------
  Widget _showPassword() {
    return widget.myProfile == false
        ? Container(
            padding: const EdgeInsets.all(10),
            child: TextField(
              obscureText: !_passwordShow,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(horizontal: 5),
                hintText: 'Ingresa una contraseña...',
                labelText: 'Contraseña',
                errorText: _passwordShowError ? _passwordError : null,
                prefixIcon: const Icon(Icons.lock),
                fillColor: Colors.white,
                filled: true,
                suffixIcon: IconButton(
                  icon: _passwordShow
                      ? const Icon(Icons.visibility)
                      : const Icon(Icons.visibility_off),
                  onPressed: () {
                    setState(() {
                      _passwordShow = !_passwordShow;
                    });
                  },
                ),
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
              onChanged: (value) {
                _password = value;
              },
            ),
          )
        : Container();
  }

//-----------------------------------------------------------------------
//-------------------------- showConfirm --------------------------------
//-----------------------------------------------------------------------
  Widget _showConfirm() {
    return widget.myProfile == false
        ? Container(
            padding: const EdgeInsets.all(10),
            child: TextField(
              obscureText: !_passwordShow,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(horizontal: 5),
                hintText: 'Ingresa la confirmación de contraseña...',
                labelText: 'Confirmación de contraseña',
                errorText: _confirmShowError ? _confirmError : null,
                prefixIcon: const Icon(Icons.lock),
                fillColor: Colors.white,
                filled: true,
                suffixIcon: IconButton(
                  icon: _passwordShow
                      ? const Icon(Icons.visibility)
                      : const Icon(Icons.visibility_off),
                  onPressed: () {
                    setState(() {
                      _passwordShow = !_passwordShow;
                    });
                  },
                ),
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
              onChanged: (value) {
                _confirm = value;
              },
            ),
          )
        : Container();
  }

//-----------------------------------------------------------------------
//-------------------------- showButtons -------------------------------
//-----------------------------------------------------------------------
  Widget _showButtons() {
    return Container(
      margin: const EdgeInsets.only(left: 10, right: 10, top: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          _showRegisterButton(),
          widget.user.userId.isEmpty
              ? Container()
              : const SizedBox(
                  width: 20,
                ),
          widget.user.userId.isEmpty
              ? Container()
              : widget.myProfile
                  ? Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFB4161B),
                          minimumSize: const Size(100, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                        onPressed: () => _changePassword(),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(Icons.lock),
                            SizedBox(
                              width: 15,
                            ),
                            Text('Contraseña'),
                          ],
                        ),
                      ),
                    )
                  : Container()
        ],
      ),
    );
  }

//-----------------------------------------------------------------------
//-------------------------- showRegisterButton -------------------------
//-----------------------------------------------------------------------
  Widget _showRegisterButton() {
    return Expanded(
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color.fromARGB(255, 8, 69, 48),
          minimumSize: const Size(double.infinity, 50),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
        ),
        onPressed: () => _save(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.person_add),
            const SizedBox(
              width: 15,
            ),
            widget.myProfile == false
                ? const Text('Registrar usuario')
                : const Text('Guardar usuario'),
          ],
        ),
      ),
    );
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
          const AlertDialogAction(key: 'no', label: 'Trasera'),
          const AlertDialogAction(key: 'yes', label: 'Delantera'),
          const AlertDialogAction(key: 'cancel', label: 'Cancelar'),
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
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _photoChanged = true;
        _image = image;
      });
    }
  }

//***********************************************************************
//******************** Método register **********************************
//***********************************************************************
  void _register() async {
    if (!validateFields()) {
      return;
    }
    _addRecord();
  }

//***********************************************************************
//******************** Método validateFields ****************************
//***********************************************************************
  bool validateFields() {
    bool isValid = true;

    if (_firstName.isEmpty) {
      isValid = false;
      _firstNameShowError = true;
      _firstNameError = 'Debes ingresar un nombre';
    } else {
      _firstNameShowError = false;
    }

    if (_lastName.isEmpty) {
      isValid = false;
      _lastNameShowError = true;
      _lastNameError = 'Debes ingresar un apellido';
    } else {
      _lastNameShowError = false;
    }

    if (_nickName.isEmpty) {
      isValid = false;
      _nickNameShowError = true;
      _nickNameError = 'Debes ingresar un apodo';
    } else {
      _lastNameShowError = false;
    }

    if (_leagueSelected == 0) {
      isValid = false;
      _leagueSelectedShowError = true;
      _leagueSelectedError = 'Debes ingresar una Liga';
    } else {
      _leagueSelectedShowError = false;
    }

    if (_teamSelected == 0) {
      isValid = false;
      _teamSelectedShowError = true;
      _teamSelectedError = 'Debes ingresar un Equipo';
    } else {
      _teamSelectedShowError = false;
    }

    if (_email.isEmpty) {
      isValid = false;
      _emailShowError = true;
      _emailError = 'Debes ingresar tu Email';
    } else if (!EmailValidator.validate(_email)) {
      isValid = false;
      _emailShowError = true;
      _emailError = 'Debes ingresar un Email válido';
    } else {
      _emailShowError = false;
    }

    if (_password.isEmpty) {
      isValid = false;
      _passwordShowError = true;
      _passwordError = 'Debes ingresar una contraseña';
    } else {
      if (_password.length < 6) {
        isValid = false;
        _passwordShowError = true;
        _passwordError =
            'Debes ingresar una contraseña de al menos 6 caracteres';
      } else {
        _passwordShowError = false;
      }
    }

    if (_confirm.isEmpty) {
      isValid = false;
      _confirmShowError = true;
      _confirmError = 'Debes ingresar una confirmación de contraseña';
    } else {
      if (_confirm.length < 6) {
        isValid = false;
        _confirmShowError = true;
        _confirmError =
            'Debes ingresar una Confirmación de Contraseña de al menos 6 caracteres';
      } else {
        _confirmShowError = false;
      }
    }

    if ((_password.length >= 6) &&
        (_confirm.length >= 6) &&
        (_confirm != _password)) {
      isValid = false;
      _passwordShowError = true;
      _confirmShowError = true;
      _passwordError = 'La contraseña y la confirmación no son iguales';
      _confirmError = 'La contraseña y la confirmación no son iguales';
    }

    setState(() {});

    return isValid;
  }

//***********************************************************************
//******************** Método addRecord *********************************
//***********************************************************************
  void _addRecord() async {
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
          ]);
      return;
    }

    String base64image = '';
    if (_photoChanged) {
      List<int> imageBytes = await _image.readAsBytes();
      base64image = base64Encode(imageBytes);
    }

    Map<String, dynamic> request = {
      'firstName': PLMayusc(_firstName),
      'lastName': PLMayusc(_lastName),
      'nickName': PLMayusc(_nickName),
      'email': _email,
      'userName': _email,
      'password': _password,
      'passwordConfirm': _confirm,
      'leagueId': _leagueSelected,
      'teamId': _teamSelected,
      'pictureArray': base64image,
    };

    Response response = await ApiHelper.postNoToken('/api/Account/', request);

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
          ]);
      return;
    }

    await showAlertDialog(
        context: context,
        title: 'Confirmación',
        message:
            'Se ha enviado un correo con las instrucciones para activar el usuario. Por favor actívelo para poder ingresar a la Aplicación.',
        actions: <AlertDialogAction>[
          const AlertDialogAction(key: null, label: 'Aceptar'),
        ]);

    Navigator.pop(context, 'yes');
  }

//***********************************************************************
//******************** Método PLMayusc **********************************
//***********************************************************************
  String PLMayusc(String string) {
    String name = '';
    bool isSpace = false;
    String letter = '';
    for (int i = 0; i < string.length; i++) {
      if (isSpace || i == 0) {
        letter = string[i].toUpperCase();
        isSpace = false;
      } else {
        letter = string[i].toLowerCase();
        isSpace = false;
      }

      if (string[i] == ' ') {
        isSpace = true;
      } else {
        isSpace = false;
      }

      name = name + letter;
    }
    return name;
  }

//***********************************************************************
//******************** Método getComboLeagues ***************************
//***********************************************************************
  List<DropdownMenuItem<int>> _getComboLeagues() {
    List<DropdownMenuItem<int>> list = [];
    list.add(const DropdownMenuItem(
      value: 0,
      child: Text('Seleccione una Liga...'),
    ));

    for (var league in _leagues) {
      list.add(DropdownMenuItem(
        value: league.id,
        child: Text(league.name),
      ));
    }

    return list;
  }

//***********************************************************************
//******************** Método getLeagues ********************************
//***********************************************************************
  Future<void> _getLeagues() async {
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
          ]);
      return;
    }

    Response response = await ApiHelper.getLeagues();

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
          ]);
      return;
    }

    setState(() {
      _leagues = response.result;
      _leagues.sort((a, b) {
        return a.name
            .toString()
            .toLowerCase()
            .compareTo(b.name.toString().toLowerCase());
      });
    });

    widget.myProfile ? _loadFieldValues() : () {};
  }

//***********************************************************************
//******************** Método getComboTeams *****************************
//***********************************************************************
  List<DropdownMenuItem<int>> _getComboTeams() {
    List<DropdownMenuItem<int>> list = [];
    list.add(const DropdownMenuItem(
      value: 0,
      child: Text('Seleccione un Equipo...'),
    ));

    for (var team in _teams) {
      list.add(DropdownMenuItem(
        value: team.id,
        child: Text(team.name),
      ));
    }

    _teams.sort((a, b) {
      return a.name
          .toString()
          .toLowerCase()
          .compareTo(b.name.toString().toLowerCase());
    });

    return list;
  }

//***********************************************************************
//******************** Método loadFieldValues ***************************
//***********************************************************************
  void _loadFieldValues() {
    _firstName = widget.user.firstName;
    _firstNameController.text = _firstName;

    _lastName = widget.user.lastName;
    _lastNameController.text = _lastName;

    _nickName = widget.user.nickName;
    _nickNameController.text = _nickName;

    _email = widget.user.email;
    _emailController.text = _email;

    _password = 'xxxxxx';
    _confirm = 'xxxxxx';

    _leagueSelected = widget.user.team.leagueId;

    _teamSelected = widget.user.team.id;

    for (var league in _leagues) {
      if (league.id == _leagueSelected) {
        _teams = league.teams;
      }
    }
    _teams.sort((a, b) {
      return a.name
          .toString()
          .toLowerCase()
          .compareTo(b.name.toString().toLowerCase());
    });
  }

//***********************************************************************
//******************** save *********************************************
//***********************************************************************
  void _save() {
    if (!validateFields()) {
      return;
    }
    widget.user.userId.isEmpty ? _register() : _saveRecord();
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
      'id': widget.user.userId,
      'firstName': _firstName,
      'lastName': _lastName,
      'nickName': _nickName,
      'email': _email,
      'userName': _email,
      'leagueId': _leagueSelected,
      'teamId': _teamSelected,
      'pictureArray': base64image,
      'password': 'xxxxxx',
      'passwordConfirm': 'xxxxxx',
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
            const AlertDialogAction(key: null, label: 'Aceptar'),
          ]);
      return;
    }

    Response response =
        await ApiHelper.put('/api/Account/', request, widget.token);

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
          ]);
      return;
    }
    Navigator.pop(context, 'yes');
  }

//***********************************************************************
//******************** Método changePassword ****************************
//***********************************************************************
  void _changePassword() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ChangePasswordScreen(
                  user: widget.user,
                  token: widget.token,
                )));
  }
}
