import 'dart:io';

import 'package:firebase/models/product_dao.dart';
import 'package:firebase/providers/firebase_provider.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AgregarProduct extends StatefulWidget {
  const AgregarProduct({Key? key}) : super(key: key);

  @override
  _AgregarProductState createState() => _AgregarProductState();
}

class _AgregarProductState extends State<AgregarProduct> {

  ImagePicker image = ImagePicker();
  File? file;
  String url="";

  getImage() async {
    var img = await image.pickImage(source: ImageSource.gallery);
    setState(() {
      file = File(img!.path);
    });
  }

  SubirImagen() async {

    print(url);
  }

  late FirebaseProvider _firebaseProvider;

  TextEditingController _controllerNom = TextEditingController();
  TextEditingController _controllerDes = TextEditingController();
  TextEditingController _controllerimg = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _firebaseProvider = FirebaseProvider();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('AGREGAR PRODUCTO'),
      ),
      body: Container(
        margin: EdgeInsets.only(left: 20, right: 20),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                SizedBox(height: 15,),
                Text('Introduce los datos del producto',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                SizedBox(height: 20,),
                _TextFieldNom(),
                SizedBox(height: 15,),
                _TextFieldDesc(),
                SizedBox(height: 15,),
                SizedBox(height: 20,),
                Text("SELECCIONA UNA IMAGEN", style: TextStyle(fontWeight: FontWeight.bold),),
                CircleAvatar(
                  radius: 80,
                  backgroundImage: file == null ? AssetImage("assets/activity_indicator.gif"):FileImage(File(file!.path)) as ImageProvider,
                ),
                IconButton(
                    onPressed: () {
                          getImage();
                    },
                    icon: Icon(Icons.image),
                  color: Colors.black,
                  iconSize: 55,
                ),
                SizedBox(height: 15,),
                SizedBox(
                  width: 150,
                  height: 50,
                  child: RaisedButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                      color: Colors.lightBlue,
                      child: Text('Guardar Producto'),
                      onPressed: () async {
                        if(_formKey.currentState!.validate())
                        {
                          var imagepath = FirebaseStorage.instance.ref().child("path").child("/.jpg");
                          UploadTask task = imagepath.putFile(file!);
                          TaskSnapshot snapshot = await task;
                          url = await snapshot.ref.getDownloadURL();

                          ProductDAO product = ProductDAO(
                            cveprod: _controllerNom.text,
                            descprod: _controllerDes.text,
                            imgprod: url
                          );
                          _firebaseProvider.saveProduct(product).then(
                                  (value) {
                                  var nav = Navigator.of(context);
                                  nav.pop();
                              }
                          );
                        }
                      }
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _TextFieldNom(){
    return TextFormField(
      controller: _controllerNom,
      validator: (val) => val!.isEmpty ?  "Campo Obligatorio" : null,
      autofocus: true,
      autocorrect: true,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        labelText: "Nombre del Producto",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25),
        ),
      ),
    );
  }

  Widget _TextFieldDesc(){
    return TextFormField(
      controller: _controllerDes,
      validator: (val) => val!.isEmpty ?  "Campo Obligatorio" : null,
      autofocus: true,
      autocorrect: true,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        labelText: "Descripcion del producto",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25),
        ),
      ),
    );
  }

  Widget _TextFieldImg(){
    return TextFormField(
      controller: _controllerimg,
      validator: (val) => val!.isEmpty ?  "Campo Obligatorio" : null,
      autofocus: true,
      autocorrect: true,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        labelText: "Introduce URL de Imagen",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25),
        ),
      ),
    );
  }





}
