import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:soccer_app/models/response.dart';

class DisplayPictureScreen extends StatefulWidget {
  final XFile image;

  DisplayPictureScreen({required this.image});

  @override
  _DisplayPictureScreenState createState() => _DisplayPictureScreenState();
}

class _DisplayPictureScreenState extends State<DisplayPictureScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Vista previa de la foto'),
        centerTitle: true,
        backgroundColor: Color.fromARGB(255, 8, 69, 48),
      ),
      body: Column(
        children: [
          Image.file(
            File(widget.image.path),
            width: MediaQuery.of(context).size.width,
            fit: BoxFit.cover,
          ),
          Container(
              margin: EdgeInsets.all(10),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: ElevatedButton(
                      child: Text('Usar Foto'),
                      style: ElevatedButton.styleFrom(
                        primary: Color.fromARGB(255, 8, 69, 48),
                        minimumSize: Size(100, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                      onPressed: () {
                        Response response =
                            Response(isSuccess: true, result: widget.image);
                        Navigator.pop(context, response);
                      },
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: ElevatedButton(
                      child: Text('Volver a tomar'),
                      style: ElevatedButton.styleFrom(
                        primary: Color.fromARGB(255, 7, 222, 11),
                        minimumSize: Size(100, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ],
              )),
        ],
      ),
    );
  }
}
