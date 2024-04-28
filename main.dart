

import 'package:flutter/material.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'dart:convert';
import 'package:encrypt/encrypt.dart' as encrypt_package; // Add a prefix here
import 'package:country_picker/country_picker.dart';
import 'package:flutter_material_pickers/flutter_material_pickers.dart';
import 'globals.dart' as globals;
import 'package:intl/intl.dart';

//import 'package:fernet/fernet.dart';





main(){ runApp(const MaterialApp( 
title: "Fats Track", 
home: Main(),
));}



class Main extends StatelessWidget {
  const Main({super.key});

  @override

  
  Widget build(BuildContext context) {





    return  MaterialApp(
    home: Welcome_Screen()





    );}}

class  Welcome extends StatelessWidget {
  const Welcome({super.key});

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}



class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}






class Welcome_Screen extends StatefulWidget {
  @override
  _Welcome_ScreenState createState() => _Welcome_ScreenState();
}

class _Welcome_ScreenState extends State<Welcome_Screen> {
  int _start = 3;

  void startTimer() {
    const oneSec = const Duration(seconds: 1);
    Timer.periodic(
      oneSec,
      (Timer timer) => setState(
        () {
          if (_start < 1) {
            timer.cancel();
          } else {
            _start = _start - 1;
          }
        },
      ),
    );
  }

  @override
  void initState() {
    startTimer();
    super.initState();
  }


var hello = () async {
  var client = http.Client();
  try {
    var response = await client.get(Uri.parse('https://flutter.dev/'));
    print(response.body);
  } finally {
    client.close();
  }
};
  @override
  Widget build(BuildContext context) {
    var Main_signUp_Screen= Stack(
            children: [
              

              Align(

                alignment: AlignmentDirectional(0.00, 0.61),
                child: TextButton(
                  onPressed: () {Navigator.push(context,MaterialPageRoute(builder: (context) =>  LoginPage ()),);},
                  child: Text('LOGIN', style: TextStyle(
                          fontFamily: 'Mukta',
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: Colors.black
                        ),),
                  style: TextButton.styleFrom(
                    minimumSize: Size(275, 40),
                    backgroundColor: Color(0xFFE0DBDB),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)
                    ),
                    
                  
                ),
              ),),


              Align(
                alignment: AlignmentDirectional(0.00, 0.75),
                child: TextButton(
                  onPressed: () {
                    Navigator.push(context,MaterialPageRoute(builder: (context) =>  signup()),);
                  },
                  child: Text('SIGN UP', style: TextStyle(
                          fontFamily: 'Mukta',
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: Colors.white
                        ),),
                  style: TextButton.styleFrom(
                    minimumSize: Size(275, 40),
                    backgroundColor: Color(0xFF3F0679),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)
                    ),)),),





              Align(
                alignment: AlignmentDirectional(-0.0, -0.2),
                child: Text(
                  'Hello!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                        fontFamily: 'Readex Pro',
                        color: Colors.white,
                        fontSize: 45,
                        letterSpacing: 1.5,
                      ),),),

              Align(
                alignment: AlignmentDirectional(-0.0, -0.1),
                child: Text(
                  'Welcome,',
                  style: TextStyle(
                        fontFamily: 'Readex Pro',
                        color: Colors.white,
                        fontSize: 45,
                      ),),),            
            
              Align(
                alignment: AlignmentDirectional(0.08, 0.44),
                child: Text(
                  'A world of effortless travel \nand adventure is waiting for you ',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                        fontFamily: 'Readex Pro',
                        color: Color(0xFF848181),
                      ),),),
            ],
          );

    var MainLogo =Image.asset('Assets/images/Logo_animated.gif', height: 440, fit: BoxFit.cover,);
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Stack(

          children: <Widget>[



            Visibility(
              child: MainLogo,
             visible: _start > 1 && _start <= 3 ? true : false,
            ),
          



            Visibility(
              child: Main_signUp_Screen,
              visible: _start == 0 ? true : false,
            ),




          ],
        ),
      ),
    );
  }
}








class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool isError = false; // This is for password being wrong
  bool isErroremail = false;
  bool server_error=false;
  String email = ""; // Variable to store email
  String password = ""; // Variable to store password;
  final _formKey = GlobalKey<FormState>();
  final _formKey1 = GlobalKey<FormState>();
  bool _obscurePassword = true;
  bool pacmanloader=false;

  void _togglePasswordVisibility() {
    setState(() {
      _obscurePassword = !_obscurePassword;
    });
  }

  
String encryptFernet(String text) {
  final encrypt_package.Key key = encrypt_package.Key.fromBase64('c1563NcXz90uGYpMqpfm_k10rOLVF5Q37AY6D016n_4=');   // import Fernet key (32 bytes, Base64url encoded)
  final encrypt_package.Fernet fernet = encrypt_package.Fernet(key);
  final encrypt_package.Encrypter encrypter = encrypt_package.Encrypter(fernet);
  final encrypt_package.Encrypted encrypted = encrypter.encrypt(text);
  return encrypted.base64.replaceAll("+","-").replaceAll("/", "_");                                                 // Base64url encode
}



Future<String> loginAPI(String username, String password) async {
    String encrypted_username=encryptFernet(username);
    String encrypted_password=encryptFernet(password);
    final client = HttpClient();
    client.badCertificateCallback = (X509Certificate cert, String host, int port) {
      // Allow self-signed certificates or certificates that are not trusted by the system.
      print('celf signed certificates passed');
      return true;
    };

    try {
      final url = Uri.parse('https://127.0.0.1:8000/login?username=$encrypted_username&password=$encrypted_password');
      final request = await client.getUrl(url);
      final response = await request.close();

      if (response.statusCode == 200) {
        final responseBody = await response.transform(Utf8Decoder()).join();
        print('printing response body---');
        print(responseBody);
        return responseBody;
      } else {
        // Handle HTTP error here
        return 'HTTP Error: ${response.statusCode}';
      }
    } catch (e) {
      // Handle other exceptions, such as network errors
      return 'Error: $e';
    } finally {
      client.close();
    }
  }

  @override
  Widget build(BuildContext context) {








var main_stack= Stack(children: [


  Visibility(
    visible: pacmanloader,
    child: Align(
      alignment: AlignmentDirectional(0,0.15),
      child: Image.asset('Assets/images/pacman.gif', height: 100, fit: BoxFit.cover,))),
    

                  
                  
                  
                  
              Visibility( 
                visible: !pacmanloader,
                child:Align(
                alignment: AlignmentDirectional(0.00, 0.14),
                child: TextButton(
  onPressed: () async {
    


  if ((_formKey.currentState != null && _formKey.currentState!.validate()) &&
      (_formKey1.currentState != null && _formKey1.currentState!.validate())) {
        setState(() {
          pacmanloader=true;
        });


    
    String apiResponse = await loginAPI(email, password);
    print("api response is: $apiResponse");
    print(apiResponse.substring(1,5));

    setState(() {
      pacmanloader=false;
    });

    if (apiResponse == 'false') {
      setState(() {
        isError = true;
        isErroremail = false;
        print("isError variable is set to true");
      });
    } else if (apiResponse == '"username false"') {
      setState(() {
        isErroremail = true;
        isError = false;
        print("isErroremail variable is set to true");
      });
    } else if(apiResponse.substring(1,5)=='true') {
      setState(() {
        globals.jwtToken=apiResponse.substring(6, apiResponse.length-1);
        print(globals.jwtToken);
        isError = false;
        isErroremail = false;
        print("isError and isErroremail variables are reset.");
        
      });
      Navigator.push(context,MaterialPageRoute(builder: (context) =>  home_dashboard()),);
    } else { 

      setState(() {
        server_error=true;
      });

    }


  }
  print("button has been pressed");
},




                  child: Text('LOGIN', style: TextStyle(
                          fontFamily: 'Mukta',
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: Colors.black
                        ),),
                  style: TextButton.styleFrom(
                    minimumSize: Size(275, 40),
                    backgroundColor: Color(0xFFE0DBDB),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)
                    ),),),),),
                  



              Align(
                alignment: AlignmentDirectional(0.00, 0.35),
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.push(context,MaterialPageRoute(builder: (context) =>  signup()),);
                  },
                  child: Text('Dont Have Account?  -Sign Up', style: TextStyle(
                          fontFamily: 'Mukta',
                          fontSize: 9.5,
                          fontWeight: FontWeight.w500,
                          color: Colors.white
                        ),),
                  style: OutlinedButton.styleFrom(
                    minimumSize: Size(275, 40),
                    backgroundColor: Color.fromARGB(255, 0, 0, 0),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)
                    ),)),),
    
              Align(
                alignment: AlignmentDirectional(0.00, 0.48),
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                      MaterialPageRoute(builder: (context) => (EmailPage())),
                        );
                  },
                  child: Text('Reset Password', style: TextStyle(
                          fontFamily: 'Mukta',
                          fontSize: 9.5,
                          fontWeight: FontWeight.w500,
                          color: Colors.white
                        ),),
                  style: OutlinedButton.styleFrom(
                    minimumSize: Size(275, 40),
                    backgroundColor: Color.fromARGB(255, 0, 0, 0),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)
                    ),)),),


               Align(
                      alignment: AlignmentDirectional(0.00, -0.36),
                      child: Form(
                        key: _formKey1,
                        autovalidateMode: isErroremail ? AutovalidateMode.always : AutovalidateMode.onUserInteraction,
                        child: Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(8, 0, 8, 0),
                          child: Container(
                            width: 320,
                            child: TextFormField(
                              validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Please Fill in the form correctly!";
                              }
                              else if (isErroremail) {
                                return "Email address is incorrect";
                              }else if(server_error){ return 'server error';}


                              return null;
                            },
                             onChanged: (value) {
                                setState(() {
                                  email = value;
                                  isErroremail=false;
                                  server_error=false;
                                });
                                
                              },
                              autofocus: true,
                              autofillHints: [AutofillHints.email],
                              textCapitalization: TextCapitalization.none,
                              textInputAction: TextInputAction.next,
                              obscureText: false,
                              decoration: InputDecoration(
                                labelText: 'Type your Email Address ',
                                labelStyle: TextStyle(
                                  fontFamily: 'Readex Pro',
                                  color: Color(0xFF7B7B7B),
                                  fontWeight: FontWeight.normal,
                                ),
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.white,
                                    width: 3,
                                  ),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                errorBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: isErroremail ? Colors.red : Colors.white,
                                    width: 3,
                                  ),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                focusedErrorBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: isErroremail ? Colors.red : Colors.white,
                                    width: 3,
                                  ),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.white,
                                    width: 3,
                                  ),
                                  borderRadius: BorderRadius.circular(50),
                                ),
                                prefixIcon: Icon(
                                  Icons.email_outlined,
                                  color: Colors.white,
                                  size: 25,
                                ),
                              ),
                              style: TextStyle(
                                fontFamily: 'Readex Pro',
                                color: Colors.white,
                              ),
                              keyboardType: TextInputType.emailAddress,

                            ),
                          ),
                        ),
                      ),
                    ),
              Align(
                alignment: AlignmentDirectional(-0.72, -0.44),
                child: Text(
                  'Email Address ',
                  style: TextStyle(
                        fontFamily: 'Readex Pro',
                        color: Colors.white,
                        fontSize: 15,
                      ),
                ),
              ),
              Align(
      alignment: AlignmentDirectional(0.00, -0.1),
      child:  Form ( 
        key: _formKey, 
        autovalidateMode: isError ? AutovalidateMode.always : AutovalidateMode.onUserInteraction,
        child:
      
      Padding(
        padding: EdgeInsetsDirectional.fromSTEB(8, 0, 8, 0),
        child: Container(
          width: 320,
          
          child: TextFormField(
            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Please Fill in the form correctly!";
                              }
                              else if (isError) {
                                return "password is incorrect";
                              }else if(server_error){ return 'server error';}
                              return null;
                            },

            autofocus: true,
            textInputAction: TextInputAction.go,
            obscureText: _obscurePassword,
            onChanged: (value) {
                                setState(() {
                                  password = value;
                                  isError=false;
                                  server_error=false;
                                });

                                

                              }, 
            decoration: InputDecoration(
              labelText: 'Type Your Password',
              labelStyle: TextStyle(
                fontFamily: 'Readex Pro',
                color: Color(0xFF7B7B7B),
              ),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: Colors.white,
              width: 3,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: Colors.white,
              width: 3,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          errorBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: isError? Colors.red: Colors.white,
              width: 3,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          focusedErrorBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: isError? Colors.red: Colors.white,
              width: 3,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          prefixIcon: Icon(
            Icons.lock_outlined,
            color: Colors.white,
            size: 25,
          ),
          suffixIcon: IconButton(
            icon: Icon(
              _obscurePassword ? Icons.visibility : Icons.visibility_off,
              color: Colors.grey,
            ),
            onPressed: _togglePasswordVisibility,
          ),
        
          hintStyle: TextStyle(color: Colors.white),
        
          //labelStyle: TextStyle(color: Colors.white),
        ),
        style: TextStyle(color: Colors.white), 
       
      ),
    ),
      )),
),
              Align(
                alignment: AlignmentDirectional(-0.72, -0.18),
                child: Text(
                  'Password',
                  style: TextStyle(
                        fontFamily: 'Readex Pro',
                        color: Colors.white,
                        fontSize: 15,
                      ),
                ),
              ),
              Align(
                alignment: AlignmentDirectional(0.00, -0.66),
                child: Text(
                  'Login',
                  style: TextStyle(
                        fontFamily: 'Outfit',
                        color: Colors.white,
                        fontSize: 30,
                      ),
                ),
              ),
            ],
          );


    return Scaffold(backgroundColor: Colors.black, body: main_stack,);
  }
}











class dashboard extends StatefulWidget {
  @override
  _dashboardState createState() => _dashboardState();
}

class _dashboardState extends State<dashboard> {
  int _start = 5;

  void startTimer() {
    const oneSec = const Duration(seconds: 1);
    Timer.periodic(
      oneSec,
      (Timer timer) => setState(
        () {
          if (_start < 1) {
            timer.cancel();
          } else {
            _start = _start - 1;
          }
        },
      ),
    );
  }

  @override
  void initState() {
    startTimer();
    super.initState();
  }


var hello = () async {
  var client = http.Client();
  try {
    var response = await client.get(Uri.parse('https://flutter.dev/'));
    print(response.body);
  } finally {
    client.close();
  }
};
  @override
  Widget build(BuildContext context) {
    var Main_signUp_Screen= Stack(
            children: [
              

             





              Align(
                alignment: AlignmentDirectional(-0.0, -0.2),
                child: Text(
                  'Your',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                        fontFamily: 'Readex Pro',
                        color: Colors.white,
                        fontSize: 45,
                        letterSpacing: 1.5,
                      ),),),

              Align(
                alignment: AlignmentDirectional(-0.0, -0.1),
                child: Text(
                  'Dashboard',
                  style: TextStyle(
                        fontFamily: 'Readex Pro',
                        color: Colors.white,
                        fontSize: 45,
                      ),),),            
            
             
            ],
          );

    var MainLogo =Image.asset('Assets/images/pacman.gif', height: 200, fit: BoxFit.cover,);
    var loading_text= Text('Loading Your Dashboard...', style: TextStyle(
                          fontFamily: 'Mukta',
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: Colors.white
                        ),);
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Stack(

          children: <Widget>[


            Align(
              alignment: AlignmentDirectional(0.00, 0.00),  

                
            child: Visibility(
              child: MainLogo,
             visible: _start > 1 && _start <= 5 ? true : false,
            ),),

            Align(

                alignment: AlignmentDirectional(0.00, -0.31),
                child:Visibility(
              child: loading_text,
             visible: _start > 1 && _start <= 5 ? true : false,
            ),),
          



            Visibility(
              child: Main_signUp_Screen,
              visible: _start == 0 ? true : false,
            ),




          ],
        ),
      ),
    );
  }
}


class signup extends StatefulWidget {
  @override
  _signupState createState() => _signupState();
}

class _signupState extends State<signup> {


  
  @override
  


  bool name=true ;
  bool emailNpassword =false;
  bool countryselected=false;
  bool usrtype=false;
  bool usrage=false;
  bool usrinterest=false;

  bool emailerror=false;
  bool emailuse=false;
  bool passworderror=false;
  bool isError=false; 
  bool second_server_error=false;
  bool passwordmatch=false;





  bool pacman=false;
  bool time_out=false;
  String user_verification_code='';
  String actual_verification_code='';
  bool code_getter=false;
  bool code_error=false;



  String first_name="";
  String second_name="";
  String emailaddr ='';
  String passwrd ='';
  String usrcountry='';
  String family ='';
  String solo='';
  String friends='';
  String age='20';
  String second_password='';
  bool isPressed=false;
  bool isPressed1=false;
  bool isPressed2=false;
  final List<String> availableinterests = ['interests', 'interests1','interests2','interests3','interests4','interests5','interests6',];
  List<String> selectedinterest = [];
  



  bool _obscurePassword = true;

  void _togglePasswordVisibility() {
    setState(() {
      _obscurePassword = !_obscurePassword;
    });
  }





  final _formKey = GlobalKey<FormState>();
  final _formKey1 = GlobalKey<FormState>();
  final _formKey2 = GlobalKey<FormState>();
  final _formKey3 = GlobalKey<FormState>();
  final _formKeyX = GlobalKey<FormState>();
  final _formKeyY = GlobalKey<FormState>();




 Widget back_button(current, previous){ return Align(
  alignment: AlignmentDirectional(-0.8,-0.85),
  child:IconButton(
    icon: const Icon(Icons.arrow_back, color: Colors.white,),
    onPressed: () async{
      setState(() {
        current=false;
        previous=true;
      });
    },

    
    )
);  }



  String encryptFernet(String text) {
  final encrypt_package.Key key = encrypt_package.Key.fromBase64('c1563NcXz90uGYpMqpfm_k10rOLVF5Q37AY6D016n_4=');   // import Fernet key (32 bytes, Base64url encoded)
  final encrypt_package.Fernet fernet = encrypt_package.Fernet(key);
  final encrypt_package.Encrypter encrypter = encrypt_package.Encrypter(fernet);
  final encrypt_package.Encrypted encrypted = encrypter.encrypt(text);
  return encrypted.base64.replaceAll("+","-").replaceAll("/", "_");                                                 // Base64url encode
}


String decryptFernet(String encryptedBase64) {
  final encrypt_package.Key key =
  encrypt_package.Key.fromBase64('c1563NcXz90uGYpMqpfm_k10rOLVF5Q37AY6D016n_4=');
  final encrypt_package.Fernet fernet = encrypt_package.Fernet(key);
  final encrypt_package.Encrypter encrypter = encrypt_package.Encrypter(fernet);
  String encryptedText = encryptedBase64.replaceAll("-", "+").replaceAll("_", "/");
  final encrypt_package.Encrypted encrypted = encrypt_package.Encrypted.fromBase64(encryptedText);
  final decrypted = encrypter.decrypt(encrypted);
  return decrypted;
}



int _start = 30;

  void startTimer() {
    const oneSec = const Duration(seconds: 1);
    Timer.periodic(
      oneSec,
      (Timer timer) => setState(
        () {
          if (_start < 1) {
            timer.cancel();
          } else {
            _start = _start - 1;
          }
        },
      ),
    );
  }




  Future signupAPI()async{




    String finalusername=encryptFernet(emailaddr);
    String finalpassword=encryptFernet(passwrd);
    

    final client = HttpClient();
    client.badCertificateCallback = (X509Certificate cert, String host, int port) {
      // Allow self-signed certificates or certificates that are not trusted by the system.
      print('self signed certificates passed');
      return true;
    };

    try {
      final url = Uri.parse('https://127.0.0.1:8000/signup?email=$finalusername&password=$finalpassword&name1=$first_name&name2=$second_name&homeBase=$usrcountry&age=$age&family=$family&solo=$solo&friends=$friends&interests=$selectedinterest');

      final request = await client.getUrl(url);
      final response = await request.close();
      final responseBody = await response.transform(Utf8Decoder()).join();
      print(responseBody);
      return responseBody;

     
      
      }catch (e) {
      // Handle other exceptions, such as network errors
      return 'Error: $e';
    } finally {
      client.close();
    }

}



Future<String> verifyemailAPI(String user_email)async{

      String encrypted_email=encryptFernet(user_email);
      final client = HttpClient();
      client.badCertificateCallback = (X509Certificate cert, String host, int port) {
      // Allow self-signed certificates or certificates that are not trusted by the system.
      print('self signed certificates passed');
      return true;
    };

    try {
      final url = Uri.parse('https://127.0.0.1:8000/email_send_code?enc_email=$encrypted_email');
      final request = await client.getUrl(url);
      final response = await request.close();

      if (response.statusCode == 200) {
        final responseBody = await response.transform(Utf8Decoder()).join();
        print('printing response body---');
        print(responseBody);
        setState(() {
          actual_verification_code=responseBody;
        });
        return responseBody;
      } else {
        // Handle HTTP error here
        return 'HTTP Error: ${response.statusCode}';
      }
    } catch (e) {
      // Handle other exceptions, such as network errors
      return 'Error: $e';
    } finally {
      client.close();
    }

  

}





Future<String> verifyAPI(String username, String password) async {
    String encrypted_username=encryptFernet(username);
    String encrypted_password=encryptFernet(password);
    final client = HttpClient();
    client.badCertificateCallback = (X509Certificate cert, String host, int port) {
      // Allow self-signed certificates or certificates that are not trusted by the system.
      print('self signed certificates passed');
      return true;
    };

    try {
      final url = Uri.parse('https://127.0.0.1:8000/verify?enc_email=$encrypted_username&enc_password=$encrypted_password');
      final request = await client.getUrl(url);
      final response = await request.close();

      if (response.statusCode == 200) {
        final responseBody = await response.transform(Utf8Decoder()).join();
        print('printing response body---');
        print(responseBody);
        return responseBody;
      } else {
        // Handle HTTP error here
        return 'HTTP Error: ${response.statusCode}';
      }
    } catch (e) {
      // Handle other exceptions, such as network errors
      return 'Error: $e';
    } finally {
      client.close();
    }
  }


  @override
  Widget build(BuildContext context) {
  


var get_usr_interests = Visibility(
  visible: usrinterest,
  child: Stack(
    children: [





      Align(
  alignment: AlignmentDirectional(-0.8,-0.85),
  child:IconButton(
    icon: const Icon(Icons.arrow_back, color: Colors.white,),
    onPressed: () async{
      setState(() {
        usrinterest=false;
        usrtype=true;
      });
    },

    
    )
),


      Align(
        alignment: AlignmentDirectional(0.00, 0.0),
        child: Wrap(
          spacing: 8.0,
          runSpacing: 8.0,
          children: availableinterests.map((String item) {
            bool isSelected = selectedinterest.contains(item);

            return Chip(
              label: Text(item),
              backgroundColor: isSelected ? Color.fromARGB(255, 117, 93, 197) : null,
              deleteIcon: isSelected ? null : Icon(Icons.circle),
              onDeleted: () {
                setState(() {
                  if (isSelected) {
                    selectedinterest.remove(item);
                  } else {
                    selectedinterest.add(item);
                  }
                });
              },
            );
          }).toList(),
        ),
      ),

    Visibility(
    visible: pacman,
    child: 
    Align(
    alignment: AlignmentDirectional(0,0), 
    child:Image.asset('Assets/images/pacman.gif', height: 300, fit: BoxFit.cover,)) ),


      Align(
        alignment: AlignmentDirectional(0.00, 0.6),
        child: TextButton(
          onPressed: () async {
            setState(() {
              usrinterest = false;
              pacman=true;

            });
             String response=signupAPI().toString();
             if (response.substring(1,5)=='true'){

            setState(() {
              pacman=false;
              globals.jwtToken=response.substring(6, response.length-1);
            });

          Navigator.push(context,MaterialPageRoute(builder: (context) =>  home_dashboard()),);

          }},
          child: Text(
            'Proceed',
            style: TextStyle(
              fontFamily: 'Mukta',
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
          ),
          style: TextButton.styleFrom(
            minimumSize: Size(275, 40),
            backgroundColor: Color(0xFFE0DBDB),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
        ),
      ),
    ],
  ),
);







var get_user_type=Visibility(visible:usrtype, child: 

Stack(
  children: [







    Align(
  alignment: AlignmentDirectional(-0.8,-0.85),
  child:IconButton(
    icon: const Icon(Icons.arrow_back, color: Colors.white,),
    onPressed: () async{
      setState(() {
        usrtype=false;
        usrage=true;
      });
    },

    
    )
),

    Align(
     alignment: AlignmentDirectional(0.00, 0.0),
     child: TextButton(
      onPressed: () async {
      if (isPressed1==false){ setState(() {
        isPressed1=true;
        family='y';
      });} else if (isPressed1==true){setState(() {
        isPressed1=false;
        family='n';
      });};
      
      },




                  child: Text('Family', style: TextStyle(
                          fontFamily: 'Mukta',
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: Colors.black
                        ),),
                  style: TextButton.styleFrom(
                    minimumSize: Size(275, 40),
                    backgroundColor: isPressed1? Color.fromARGB(255, 177, 132, 218): const Color.fromARGB(255, 255, 255, 255),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)
                    ),),),),



    Align(
     alignment: AlignmentDirectional(0.00, 0.15),
     child: TextButton(
      onPressed: () async {
      if (isPressed2==false){ setState(() {
        isPressed2=true;
        solo='y';
      });} else if (isPressed2==true){setState(() {
        isPressed2=false;
        solo='n';
      });};
      
      },




                  child: Text('Solo', style: TextStyle(
                          fontFamily: 'Mukta',
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: Colors.black
                        ),),
                  style: TextButton.styleFrom(
                    minimumSize: Size(275, 40),
                    backgroundColor: isPressed2? Color.fromARGB(255, 177, 132, 218): const Color.fromARGB(255, 255, 255, 255),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)
                    ),),),),




    Align(
     alignment: AlignmentDirectional(0.00, 0.30),
     child: TextButton(
      onPressed: () async {
      if (isPressed==false){ setState(() {
        isPressed=true;
        friends='y';
      });} else if (isPressed==true){setState(() {
        isPressed=false;
        friends='n';
      });};
      },




                  child: Text('Friends', style: TextStyle(
                          fontFamily: 'Mukta',
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: Colors.black
                        ),),
                  style: TextButton.styleFrom(
                    minimumSize: Size(275, 40),
                    backgroundColor: isPressed? Color.fromARGB(255, 177, 132, 218): const Color.fromARGB(255, 255, 255, 255),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)
                    ),),),),


        Align(
                alignment: AlignmentDirectional(0.00, -0.66),
                child: Text(
                  'How Do you Often Travel?',
                  style: TextStyle(
                        fontFamily: 'Outfit',
                        color: Colors.white,
                        fontSize: 30,
                      ),
                ),
              ),
                    
     Align(
     alignment: AlignmentDirectional(0.00, 0.6),
     child: TextButton(
  onPressed: () async {
      setState(() {
        usrtype=false;
        usrinterest=true;
      });
      
      },




                  child: Text('Proceed', style: TextStyle(
                          fontFamily: 'Mukta',
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: Colors.black
                        ),),
                  style: TextButton.styleFrom(
                    minimumSize: Size(275, 40),
                    backgroundColor: Color(0xFFE0DBDB),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)
                    ),),),),                 

  ],

)

);






var get_age= Visibility(visible: usrage,  child: 
  
  Stack (children: [ 




    Align(
  alignment: AlignmentDirectional(-0.8,-0.85),
  child:IconButton(
    icon: const Icon(Icons.arrow_back, color: Colors.white,),
    onPressed: () async{
      setState(() {
        usrage=false;
        countryselected=true;
      });
    },

    
    )
),





    
  Align(
     alignment: AlignmentDirectional(0.00, 0.6),
     child: TextButton(
  onPressed: () async {
  if ( age.length > 0 && age != ' Please Select Your Age') {

      setState(() {
        // add email and password validation 
        usrage=false;
        usrtype=true;
      }); 
      
      } else { 

        setState(() {
          age=' Please Select Your Age';
        });

       }
      
      },




                  child: Text('Proceed', style: TextStyle(
                          fontFamily: 'Mukta',
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: Colors.black
                        ),),
                  style: TextButton.styleFrom(
                    minimumSize: Size(275, 40),
                    backgroundColor: Color(0xFFE0DBDB),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)
                    ),),),),
                  




    Align(
                alignment: AlignmentDirectional(0.00, -0.66),
                child: Text(
                  'Select Your Age',
                  style: TextStyle(
                        fontFamily: 'Outfit',
                        color: Colors.white,
                        fontSize: 30,
                      ),
                ),
              ),

    Align(
                alignment: AlignmentDirectional(0.00, 0.2),
                child: Text(
                  'You Are ${age} Years Old',
                  style: TextStyle(
                        fontFamily: 'Outfit',
                        color: Colors.white,
                        fontSize: 18,
                      ),
                ),
              ),




    
    Align( alignment:AlignmentDirectional(0,0), child:TextButton(
  
  
  
  onPressed: () async {

  showMaterialNumberPicker(
  
  context: context,
  backgroundColor: Color.fromARGB(255, 118, 104, 158),
  headerColor: Color.fromARGB(255, 118, 104, 158),
  buttonTextColor: Colors.white,
  title: 'Pick Your Age',
  maxNumber: 100,
  minNumber: 14,
  selectedNumber: int.parse(age),
  onChanged: (value) => setState(() => age = value.toString()),
);

  },




  child: Text('Tap Here to Select Your Age', style: TextStyle(
  fontFamily: 'Mukta',
  fontSize: 12,
  fontWeight: FontWeight.w500,
  color: Colors.black),),
  style: TextButton.styleFrom(
  minimumSize: Size(275, 40),
  backgroundColor: Color(0xFFE0DBDB),
  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(9)
),),),)



]));



var get_code=Visibility(

  visible: code_getter, child: Stack(

    children:[





      Align(
  alignment: AlignmentDirectional(-0.8,-0.85),
  child:IconButton(
    icon: const Icon(Icons.arrow_back, color: Colors.white,),
    onPressed: () async{
      setState(() {
        code_getter=false;
        emailNpassword=true;
      });
    },

    
    )
),


      Visibility(
        child: Align(
        alignment: AlignmentDirectional(0.0, 0.3),
        child:TextButton(
          onPressed: () async {
            String actualuserverificationcode=decryptFernet(actual_verification_code.replaceAll('"', ''));
            print(actualuserverificationcode);
            print(user_verification_code);
            if (_formKeyY.currentState != null && _formKeyY.currentState!.validate()){
              print('passed');
              if (actualuserverificationcode==user_verification_code){
                print('worked!');
                setState(() {
                code_getter=false;
                countryselected=true;                  
                });


              }else{setState(() {
                code_error=true;
              });}

            }
          },

          child: Text('Proceed', style: TextStyle(
                          fontFamily: 'Mukta',
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: Colors.black
                        ),), 
                    style: TextButton.styleFrom(
                    minimumSize: Size(275, 40),
                    backgroundColor: Color(0xFFE0DBDB),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)
                    ),),    





        )
        

      
      )),


      Visibility(
        visible: _start < 1,
        child: Align(
        alignment: AlignmentDirectional(0.0, 0.45),
        child:TextButton(
          onPressed: () async {
           
                verifyemailAPI(emailaddr);
                setState(() {
                  _start=30;
                });
            
          },

          child: Text('Resend Code', style: TextStyle(
                          fontFamily: 'Mukta',
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: Colors.black
                        ),), 
                    style: TextButton.styleFrom(
                    minimumSize: Size(275, 40),
                    backgroundColor: Color(0xFFE0DBDB),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)
                    ),),    





        )
        

      
      )),
Align(
                      alignment: AlignmentDirectional(0.00, -0.36),
                      child: Form(
                        key: _formKeyY,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        child: Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(8, 0, 8, 0),
                          child: Container(
                            width: 320,
                            child: TextFormField(
                              validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Please Fill in the form correctly!";
                              }else if(code_error){return 'Please enter valid code';}

                            
                              


                              return null;
                            },
                             onChanged: (value) {
                                setState(() {

                                  code_error=false;
                                  user_verification_code=value;


                                });
                                
                              },
                              autofocus: true,
                              autofillHints: [AutofillHints.email],
                              textCapitalization: TextCapitalization.none,
                              textInputAction: TextInputAction.next,
                              obscureText: false,
                              decoration: InputDecoration(
                                labelText: 'Type Your verfication code here ',
                                labelStyle: TextStyle(
                                  fontFamily: 'Readex Pro',
                                  color: Color(0xFF7B7B7B),
                                  fontWeight: FontWeight.normal,
                                ),
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.white,
                                    width: 3,
                                  ),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                errorBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color:  code_error?  Colors.red: Colors.white,
                                    width: 3,
                                  ),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                focusedErrorBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color:  code_error ?  Colors.red: Colors.white,
                                    width: 3,
                                  ),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.white,
                                    width: 3,
                                  ),
                                  borderRadius: BorderRadius.circular(50),
                                ),
                                prefixIcon: Icon(
                                  Icons.password_sharp,
                                  color: Colors.white,
                                  size: 25,
                                ),
                              ),
                              style: TextStyle(
                                fontFamily: 'Readex Pro',
                                color: Colors.white,
                              ),
                              keyboardType: TextInputType.number,

                            ),
                          ),
                        ),
                      ),
                    ),



    ]

  )


);






var  get_country= Visibility(visible: countryselected,  child: 
  
  Stack (children: [ 






    Align(
  alignment: AlignmentDirectional(-0.8,-0.85),
  child:IconButton(
    icon: const Icon(Icons.arrow_back, color: Colors.white,),
    onPressed: () async{
      setState(() {
        countryselected=false;
        emailNpassword=true;
      });
    },

    
    )
),





    
  Align(
     alignment: AlignmentDirectional(0.00, 0.6),
     child: TextButton(
  onPressed: () async {
  if ( usrcountry.length > 0 && usrcountry != ' Please Select A Country!') {

      setState(() {
        // add email and password validation 
        countryselected=false;
        usrage=true;
      }); 
      
      } else { 

        setState(() {
          usrcountry=' Please Select A Country!';
        });

       }
      
      },




                  child: Text('Proceed', style: TextStyle(
                          fontFamily: 'Mukta',
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: Colors.black
                        ),),
                  style: TextButton.styleFrom(
                    minimumSize: Size(275, 40),
                    backgroundColor: Color(0xFFE0DBDB),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)
                    ),),),),
                  




    Align(
                alignment: AlignmentDirectional(0.00, -0.66),
                child: Text(
                  'Select Your Home Base:',
                  style: TextStyle(
                        fontFamily: 'Outfit',
                        color: Colors.white,
                        fontSize: 30,
                      ),
                ),
              ),

    Align(
                alignment: AlignmentDirectional(0.00, 0.2),
                child: Text(
                  'You Selected: ${usrcountry}',
                  style: TextStyle(
                        fontFamily: 'Outfit',
                        color: Colors.white,
                        fontSize: 18,
                      ),
                ),
              ),




    
    Align( alignment:AlignmentDirectional(0,0), child:TextButton(
  
  
  
  onPressed: () async {

    showCountryPicker(
  context: context,
  countryListTheme: CountryListThemeData(
    flagSize: 25,
    backgroundColor: Color.fromARGB(255, 56, 39, 95),
    textStyle: TextStyle(fontSize: 16, color: const Color.fromARGB(255, 255, 255, 255)),
    bottomSheetHeight: 500, 
      borderRadius: BorderRadius.only(
      topLeft: Radius.circular(20.0),
      topRight: Radius.circular(20.0),
    ),
    //Optional. Styles the search field.
    inputDecoration: InputDecoration(
      labelText: 'Search',
      hintText: 'Start typing to search',
      prefixIcon: const Icon(Icons.search),
      border: OutlineInputBorder(
        borderSide: BorderSide(
          color: Color.fromARGB(255, 255, 255, 255).withOpacity(0.2),
        ),
      ),
    ),
  ),
  onSelect: (Country country) => setState(() {
    usrcountry=country.name +' '+country.flagEmoji;
    
  }),
);

  },




  child: Text('Tap Here to Select Your Home Base', style: TextStyle(
  fontFamily: 'Mukta',
  fontSize: 12,
  fontWeight: FontWeight.w500,
  color: Colors.black),),
  style: TextButton.styleFrom(
  minimumSize: Size(275, 40),
  backgroundColor: Color(0xFFE0DBDB),
  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(9)
),),),)



]));






var get_login= Visibility( visible: emailNpassword, child: Stack(
            children: [





              Align(
  alignment: AlignmentDirectional(-0.8,-0.85),
  child:IconButton(
    icon: const Icon(Icons.arrow_back, color: Colors.white, size:32 ,),
    tooltip: 'Back',
    onPressed: () async{
      setState(() {
        emailNpassword=false;
        name=true;
      });
    },

    
    )
),
              

             

                Visibility(
                  visible: time_out,
                  child: Align( 
                    alignment: AlignmentDirectional(0.00, 0.35),
                    child: Image.asset('Assets/images/pacman.gif', height: 100, fit: BoxFit.cover,))),



                 Visibility( 
                  visible: !time_out,
                  
                  child: Align(
                alignment: AlignmentDirectional(0.00, 0.3),
                child: TextButton(
  onPressed: () async {

  if ((_formKey2.currentState != null && _formKey2.currentState!.validate()) &&
      (_formKey3.currentState != null && _formKey3.currentState!.validate()) &&
      (_formKeyX.currentState != null && _formKeyX.currentState!.validate())
         ) {

        setState(() {
          
          time_out=true;

        });


        String apiResponse= await verifyAPI(emailaddr, passwrd);
        if (apiResponse=='false'){
          setState(() {
            isError=true;
            emailerror=true;
            time_out=false;
          });

        print('API RESPONSE IS :');
        print(apiResponse);

        }else if (apiResponse=='"email in use"'){
          setState(() {
            emailuse=true;
            time_out=false;
          });
        }else if (apiResponse=='"password weak"'){
          setState(() {
            passworderror=true;
            isError=true;
            time_out=false;
          });
        }else if (apiResponse=='false'){
          setState(() {
            emailerror=true;
            time_out=false;
          });}



         else if(second_password!=passwrd){

          setState(() {
            
            passwordmatch=true;
            time_out=false;
          });
         } 
        else if (apiResponse=='true'){
          startTimer();


        

      setState(() {
        // add email and password validation
        emailNpassword = false;
        code_getter=true;
        time_out=false;
        print(countryselected);
      }); verifyemailAPI(emailaddr);}else{
        print('API RESPONSE IS:');
        print(apiResponse);
        setState(() {
        second_server_error=true;
        time_out=false;
      });}

      

  



  }
  //print(first_name);
  //print(second_name);
  //print("button has been pressed");
},




                  child: Text('Proceed', style: TextStyle(
                          fontFamily: 'Mukta',
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: Colors.black
                        ),),
                  style: TextButton.styleFrom(
                    minimumSize: Size(275, 40),
                    backgroundColor: Color(0xFFE0DBDB),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)
                    ),),),),),
                  



              Align(
                alignment: AlignmentDirectional(0.00, 0.45),
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.push(context,MaterialPageRoute(builder: (context) =>  LoginPage()),);
                  },
                  child: Text('Already Have An Account?  -Login instead', style: TextStyle(
                          fontFamily: 'Mukta',
                          fontSize: 9.5,
                          fontWeight: FontWeight.w500,
                          color: Colors.white
                        ),),
                  style: OutlinedButton.styleFrom(
                    minimumSize: Size(275, 40),
                    backgroundColor: Color.fromARGB(255, 0, 0, 0),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)
                    ),)),),
    
              


               Align(
                      alignment: AlignmentDirectional(0.00, -0.36),
                      child: Form(
                        key: _formKey3,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        child: Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(8, 0, 8, 0),
                          child: Container(
                            width: 320,
                            child: TextFormField(
                              validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Please Fill in the form correctly!";
                              }else if(emailerror){return 'Please enter valid email!';}
                              else if(emailuse){return 'email in use already';}
                              else if(second_server_error){return 'server error'; }
                            
                              


                              return null;
                            },
                             onChanged: (value) {
                                setState(() {
                                  emailaddr = value;
                                  emailerror=false;
                                  emailuse=false;
                                  second_server_error=false;

                                });
                                
                              },
                              autofocus: true,
                              autofillHints: [AutofillHints.email],
                              textCapitalization: TextCapitalization.none,
                              textInputAction: TextInputAction.next,
                              obscureText: false,
                              decoration: InputDecoration(
                                labelText: 'Type your Email Address ',
                                labelStyle: TextStyle(
                                  fontFamily: 'Readex Pro',
                                  color: Color(0xFF7B7B7B),
                                  fontWeight: FontWeight.normal,
                                ),
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.white,
                                    width: 3,
                                  ),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                errorBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color:  emailerror | emailuse ?  Colors.red: Colors.white,
                                    width: 3,
                                  ),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                focusedErrorBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color:  emailerror | emailuse ?  Colors.red: Colors.white,
                                    width: 3,
                                  ),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.white,
                                    width: 3,
                                  ),
                                  borderRadius: BorderRadius.circular(50),
                                ),
                                prefixIcon: Icon(
                                  Icons.email,
                                  color: Colors.white,
                                  size: 25,
                                ),
                              ),
                              style: TextStyle(
                                fontFamily: 'Readex Pro',
                                color: Colors.white,
                              ),
                              keyboardType: TextInputType.emailAddress,

                            ),
                          ),
                        ),
                      ),
                    ),
              Align(
                alignment: AlignmentDirectional(-0.72, -0.44),
                child: Text(
                  'Email Address ',
                  style: TextStyle(
                        fontFamily: 'Readex Pro',
                        color: Colors.white,
                        fontSize: 15,
                      ),
                ),
              ),
              
              
              
              Align(
      alignment: AlignmentDirectional(0.00, -0.1),
      child:  Form ( 
        key: _formKey2, 
       autovalidateMode: AutovalidateMode.onUserInteraction,
        child:
      
      Padding(
        padding: EdgeInsetsDirectional.fromSTEB(8, 0, 8, 0),
        child: Container(
          width: 320,
          
          child: TextFormField(
            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Please Fill in the form correctly!";
                              }else if (passworderror){
                                return '''password is too weak! make sure no 
consecutive numbers or common names are there''';
                              }else if (second_server_error){return 'server error ';}
                              
                              return null;
                            },

            autofocus: true,
            textInputAction: TextInputAction.go,
            onChanged: (value) {
                                setState(() {
                                  passwrd = value;
                                  passworderror=false;
                                  second_server_error=false;
                                });

                                

                              }, 
            obscureText: _obscurePassword,                  
            decoration: InputDecoration(
              labelText: 'Create A Password',
              labelStyle: TextStyle(
                fontFamily: 'Readex Pro',
                color: Color(0xFF7B7B7B),
              ),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: Colors.white,
              width: 3,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: Colors.white,
              width: 3,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          errorBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color:  passworderror? Colors.red: Colors.white,
              width: 3,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          focusedErrorBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color:  passworderror? Colors.red: Colors.white,
              width: 3,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          prefixIcon: Icon(
            Icons.lock,
            color: Colors.white,
            size: 25,
          ),

          suffixIcon: IconButton(
            icon: Icon(
              _obscurePassword ? Icons.visibility : Icons.visibility_off,
              color: Colors.grey,
            ),
            onPressed: _togglePasswordVisibility,
          ),

        
          hintStyle: TextStyle(color: Colors.white),
        
          //labelStyle: TextStyle(color: Colors.white),
        ),
        style: TextStyle(color: Colors.white), 
       
      ),
    ),
      )),
),
              
              Align(
                alignment: AlignmentDirectional(-0.72, -0.44),
                child: Text(
                  'Email Address ',
                  style: TextStyle(
                        fontFamily: 'Readex Pro',
                        color: Colors.white,
                        fontSize: 15,
                      ),
                ),
              ),
              Align(
      alignment: AlignmentDirectional(0.0, 0.08),
      child:  Form ( 
        key: _formKeyX, 
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child:
      
      Padding(
        padding: EdgeInsetsDirectional.fromSTEB(8, 0, 8, 0),
        child: Container(
          width: 320,
          
          child: TextFormField(
            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Please Fill in the form correctly!";}
                             
                              else if (passwordmatch){ return 'password must match';}
                              
                              
                              return null;
                            },

            autofocus: true,
            textInputAction: TextInputAction.go,
            onChanged: (value) {
                                setState(() {
                                  second_password = value;
                                  isError=false;
                                  passworderror=false;
                                  second_server_error=false;
                                  passwordmatch=false;
                                });

                                

                              }, 
            obscureText: _obscurePassword,                  
            decoration: InputDecoration(
              labelText: 'Re enter your Password',
              labelStyle: TextStyle(
                fontFamily: 'Readex Pro',
                color: Color(0xFF7B7B7B),
              ),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: Colors.white,
              width: 3,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: Colors.white,
              width: 3,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          errorBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: isError | passworderror | passwordmatch? Colors.red: Colors.white,
              width: 3,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          focusedErrorBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: isError | passworderror | passwordmatch? Colors.red: Colors.white,
              width: 3,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          prefixIcon: Icon(
            Icons.lock,
            color: Colors.white,
            size: 25,
          ),

          

        
          hintStyle: TextStyle(color: Colors.white),
        
          //labelStyle: TextStyle(color: Colors.white),
        ),
        style: TextStyle(color: Colors.white), 
       
      ),
    ),
      )),
),              
              
              
              
              
              
              
              
              
              Align(
                alignment: AlignmentDirectional(-0.72, -0.18),
                child: Text(
                  'Password',
                  style: TextStyle(
                        fontFamily: 'Readex Pro',
                        color: Colors.white,
                        fontSize: 15,
                      ),
                ),
              ),
              Align(
                alignment: AlignmentDirectional(0.00, -0.66),
                child: Text(
                  'New User Registration',
                  style: TextStyle(
                        fontFamily: 'Outfit',
                        color: Colors.white,
                        fontSize: 30,
                      ),
                ),
              ),
            ],
          )
          );











    var get_names= Visibility( visible: name, child: Stack(
            children: [
              

             





                Align(
                alignment: AlignmentDirectional(0.00, 0.14),
                child: TextButton(
  onPressed: () async {
  if ((_formKey.currentState != null && _formKey.currentState!.validate()) &&
      (_formKey1.currentState != null && _formKey1.currentState!.validate())) {

      setState(() {
        name=false;
        emailNpassword = true;
      });


  }
  //print(first_name);
  //print(second_name);
  //print("button has been pressed");
},




                  child: Text('Proceed', style: TextStyle(
                          fontFamily: 'Mukta',
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: Colors.black
                        ),),
                  style: TextButton.styleFrom(
                    minimumSize: Size(275, 40),
                    backgroundColor: Color(0xFFE0DBDB),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)
                    ),),),),
                  



              Align(
                alignment: AlignmentDirectional(0.00, 0.35),
                child: OutlinedButton(
                  onPressed: () {
                    print("login button pressed");
                  },
                  child: Text('Already Have An Account?  -Login instead', style: TextStyle(
                          fontFamily: 'Mukta',
                          fontSize: 9.5,
                          fontWeight: FontWeight.w500,
                          color: Colors.white
                        ),),
                  style: OutlinedButton.styleFrom(
                    minimumSize: Size(275, 40),
                    backgroundColor: Color.fromARGB(255, 0, 0, 0),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)
                    ),)),),
    
              


               Align(
                      alignment: AlignmentDirectional(0.00, -0.36),
                      child: Form(
                        key: _formKey1,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        child: Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(8, 0, 8, 0),
                          child: Container(
                            width: 320,
                            child: TextFormField(
                              validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Please Fill in the form correctly!";
                              }
                              


                              return null;
                            },
                             onChanged: (value) {
                                setState(() {
                                  first_name = value;
                                });
                                
                              },
                              autofocus: true,
                              autofillHints: [AutofillHints.email],
                              textCapitalization: TextCapitalization.none,
                              textInputAction: TextInputAction.next,
                              obscureText: false,
                              decoration: InputDecoration(
                                labelText: 'Type your First Name ',
                                labelStyle: TextStyle(
                                  fontFamily: 'Readex Pro',
                                  color: Color(0xFF7B7B7B),
                                  fontWeight: FontWeight.normal,
                                ),
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.white,
                                    width: 3,
                                  ),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                errorBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color:  Colors.red,
                                    width: 3,
                                  ),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                focusedErrorBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color:  Colors.red, 
                                    width: 3,
                                  ),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.white,
                                    width: 3,
                                  ),
                                  borderRadius: BorderRadius.circular(50),
                                ),
                                prefixIcon: Icon(
                                  Icons.person_2_sharp,
                                  color: Colors.white,
                                  size: 25,
                                ),
                              ),
                              style: TextStyle(
                                fontFamily: 'Readex Pro',
                                color: Colors.white,
                              ),
                              keyboardType: TextInputType.emailAddress,

                            ),
                          ),
                        ),
                      ),
                    ),
              Align(
                alignment: AlignmentDirectional(-0.72, -0.44),
                child: Text(
                  'First Name ',
                  style: TextStyle(
                        fontFamily: 'Readex Pro',
                        color: Colors.white,
                        fontSize: 15,
                      ),
                ),
              ),
              Align(
      alignment: AlignmentDirectional(0.00, -0.1),
      child:  Form ( 
        key: _formKey, 
        autovalidateMode:  AutovalidateMode.onUserInteraction,
        child:
      
      Padding(
        padding: EdgeInsetsDirectional.fromSTEB(8, 0, 8, 0),
        child: Container(
          width: 320,
          
          child: TextFormField(
            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Please Fill in the form correctly!";
                              }
                              
                              return null;
                            },

            autofocus: true,
            textInputAction: TextInputAction.go,
            onChanged: (value) {
                                setState(() {
                                  second_name = value;
                                });

                                

                              }, 
            decoration: InputDecoration(
              labelText: 'Type Your Last Name',
              labelStyle: TextStyle(
                fontFamily: 'Readex Pro',
                color: Color(0xFF7B7B7B),
              ),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: Colors.white,
              width: 3,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: Colors.white,
              width: 3,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          errorBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: Colors.red,
              width: 3,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          focusedErrorBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color:  Colors.red,
              width: 3,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          prefixIcon: Icon(
            Icons.person_2_sharp,
            color: Colors.white,
            size: 25,
          ),

        
          hintStyle: TextStyle(color: Colors.white),
        
          //labelStyle: TextStyle(color: Colors.white),
        ),
        style: TextStyle(color: Colors.white), 
       
      ),
    ),
      )),
),
              Align(
                alignment: AlignmentDirectional(-0.72, -0.18),
                child: Text(
                  'Last Name',
                  style: TextStyle(
                        fontFamily: 'Readex Pro',
                        color: Colors.white,
                        fontSize: 15,
                      ),
                ),
              ),
              Align(
                alignment: AlignmentDirectional(0.00, -0.66),
                child: Text(
                  'New User Registration',
                  style: TextStyle(
                        fontFamily: 'Outfit',
                        color: Colors.white,
                        fontSize: 30,
                      ),
                ),
              ),
            ],
          )
          );



    var Mainscreen= Stack(children: [get_login, get_code, get_names, get_country, get_age, get_user_type, get_usr_interests],);
    return Scaffold(
      backgroundColor: Colors.black, body:Mainscreen //body: main_stack,
    );
  }
  
}


class EmailPage extends StatefulWidget {
  @override
  _EmailPageState createState() => _EmailPageState();
}

class _EmailPageState extends State<EmailPage> {
  final _emailController = TextEditingController();
  String _errorMessage = '';
  String code='';
  Future<String>send_email(email)async{
        final client = HttpClient();
      client.badCertificateCallback = (X509Certificate cert, String host, int port) {
      // Allow self-signed certificates or certificates that are not trusted by the system.
      print('self signed certificates passed');
      return true;
    };

    try {
      final url = Uri.parse('https://127.0.0.1:8000/email_reset?email=$email');
      final request = await client.getUrl(url);
      final response = await request.close();

      if (response.statusCode == 200) {
        final responseBody = await response.transform(Utf8Decoder()).join();
        print('printing response body---');
        print(responseBody);
        setState(() {
          code=responseBody;
        });
        return responseBody;
      } else {
        // Handle HTTP error here
        return 'HTTP Error: ${response.statusCode}';
      }
    } catch (e) {
      // Handle other exceptions, such as network errors
      return 'Error: $e';
    } finally {
      client.close();
    }
}


  void _submitEmail() async {
    // Basic email validation (you can add more robust checks)
    if (!_emailController.text.contains('@')) {
      setState(() {
        _errorMessage = 'Invalid email format';
      });
      return;
    }

    // Simulate sending the email and getting the code
    String generatedCode = await send_email(_emailController.text);

    // Navigate and pass the code 
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CodeVerificationPage(authCode: generatedCode, email:_emailController.text),
      ),
    );
  }







  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Enter Email')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(hintText: 'Enter Email'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _submitEmail,
              child: Text('Submit'),
            ),
            SizedBox(height: 10),
            Text(_errorMessage, style: TextStyle(color: Colors.red)),
          ],
        ),
      ),
    );
  }


}





class CodeVerificationPage extends StatefulWidget {
  CodeVerificationPage({required this.authCode, required this.email});

  final String authCode;
  final String email;

  _CodeVerificationPageState createState() => _CodeVerificationPageState();
}

class _CodeVerificationPageState extends State<CodeVerificationPage> {
  // Controllers for text fields
  final _codeController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  // State variables
  bool _obscurePassword = true;
  bool _showPasswordFields = false;
  String _errorMessage = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Code Verification')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _codeController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(hintText: 'Enter Code'),
            ),
            SizedBox(height: 20),

            ElevatedButton(
              onPressed: _verifyCode,
              child: Text('Verify Code'),
            ), 

            SizedBox(height: 20), 

            // Password Input (shown conditionally)
            if (_showPasswordFields) ...[
              TextField(
                controller: _passwordController,
                obscureText: _obscurePassword,
                decoration: InputDecoration(
                  hintText: 'Enter Password',
                  suffixIcon: IconButton(
                    icon: Icon(_obscurePassword
                        ? Icons.visibility_off
                        : Icons.visibility),
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                  ),
                ),
              ),
              SizedBox(height: 10),
              TextField(
                controller: _confirmPasswordController,
                obscureText: _obscurePassword,
                decoration: InputDecoration(hintText: 'Re-type Password'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _validateAndSubmit,
                child: Text('Submit'),
              ),
            ],

            SizedBox(height: 10),
            Text(_errorMessage, style: TextStyle(color: Colors.red)),
          ],
        ),
      ),
    );
  }

  void _verifyCode() {
    _errorMessage = '';
    print((_codeController.text));
    print(widget.authCode);
    if (_codeController.text == widget.authCode) {
      setState(() {
        _showPasswordFields = true; 
      });
    } else {
      setState(() {
        _errorMessage = 'Invalid code'; 
      });
    }
  }

  Future<String> check_function(password)async {

        final client = HttpClient();
      client.badCertificateCallback = (X509Certificate cert, String host, int port) {
      // Allow self-signed certificates or certificates that are not trusted by the system.
      print('self signed certificates passed');
      return true;
    };

    try {
      final url = Uri.parse('https://127.0.0.1:8000/reset_password?email=${widget.email}&password=${password}');
      final request = await client.getUrl(url);
      final response = await request.close();

      if (response.statusCode == 200) {
        final responseBody = await response.transform(Utf8Decoder()).join();
        print('printing response body---');
        print(responseBody);
        return responseBody;
      } else {
        // Handle HTTP error here
        return 'HTTP Error: ${response.statusCode}';
      }
    } catch (e) {
      // Handle other exceptions, such as network errors
      return 'Error: $e';
    } finally {
      client.close();
    }

  
}

  void _validateAndSubmit() {
    print(_passwordController.text);
    setState(() {
      _errorMessage = ''; 
    });

    if (_passwordController.text != _confirmPasswordController.text) {
      setState(() {
        _errorMessage = 'Passwords do not match';
      });
      return; 
    }

    // Call your check function
    if (check_function(_passwordController.text) != 'false') {
      // Success
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => LoginPage()));
    } else {
      setState(() {
        _errorMessage = 'An error occurred'; 
      });
    }
  }
}














class home_dashboard extends StatefulWidget {
  @override

  _home_dashboardState createState() => _home_dashboardState();

}









class _home_dashboardState extends State<home_dashboard> {




  @override  

    DateTime currentdate=DateTime.now();
    bool visible_dashboard=false;
    bool dummy=false;
    var trips=[];
    var parentActivityID=[];
    int temp_counter=0;

    var current_destination=['placeholder'];
    var current_departures=['01/01/2001'];
    var current_returns=['01/01/2001'];


    var destinations=['place holder'];
    var departures=['01/01/2001'];
    var returns=['01/01/2001'];
    int tapped = -1;







    bool current=false;
    bool upcoming=false;

    String token =globals.jwtToken;
    void initState(){
      super.initState();
      initial_dashboard_info();
  WidgetsBinding.instance.addPostFrameCallback((_) {
    // Now the widget is built and part of the widget tree
    _scrollController.animateTo(
      0.0,
      duration: Duration(seconds: 1),
      curve: Curves.easeInOut,
    );
  });
    }



ScrollController _scrollController = ScrollController();

DateTime parseDateString1(String dateString) {
  // Split the input string into day, month, and year parts
  List<String> dateParts = dateString.split('/');

  // Extract day, month, and year from the parts
  int day = int.parse(dateParts[0]);
  int month = int.parse(dateParts[1]);
  int year = int.parse(dateParts[2]);

  // Create a DateTime object
  DateTime dateTime = DateTime(year, month, day);

  return dateTime;
}



DateTime parseDateString(String dateString) {
  List<String> dateParts = dateString.split('/');
  int day = int.parse(dateParts[0]);
  int month = int.parse(dateParts[1]);
  int year = int.parse(dateParts[2]);
  return DateTime(year, month, day);
}


Future upcomingVScurrent()async{
  for (String i in departures){
    DateTime clean_date=parseDateString(i);
    if (clean_date.isBefore(currentdate)|| clean_date==currentdate){
        setState(() {
          current=true;
        });
       }else {setState(() {
         current=false;
       });};
  }

}

void handleContainerTap(int index) {
    setState(() {
      tapped = index;
      globals.PAiD=parentActivityID[index];
      print(parentActivityID);
      print(temp_counter);
    });
    Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => MainTripPage()),
  );
    
  }


Future<void> initial_dashboard_info() async {
  final String apiUrl = "https://127.0.0.1:8000/dashboard_info";
  final String jwtToken = token; 

  // Prepare headers
  Map<String, String> headers = {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $jwtToken',

  };

  final client = HttpClient();
  client.badCertificateCallback = (X509Certificate cert, String host, int port) => true; // Allow self-signed certificates

  try {
    final uri = Uri.parse(apiUrl);
    final request = await client.getUrl(uri);

    headers.forEach((key, value) {
      request.headers.set(key, value);
    });

    final response = await request.close();
    final responseBody = await utf8.decodeStream(response);

    if (response.statusCode == 200) {
      print('responseBODY');

      var data = json.decode(responseBody);
      print(data);
      setState(() {
        trips=data;

      });
      String resultString = trips.join(', ');
      

      if (resultString != 'error in api callback'){setState(() {
        visible_dashboard=true;
        
      });;
      
      for (var i in trips ){
        if (i!=false || i!='false'){
          
        for (var x in i ){

          

          if( parseDateString(x[3]).isBefore(currentdate) && currentdate.isBefore(parseDateString(x[4]))){
          
          print('X IS::::::::');
          print(x[0]);
          parentActivityID.add(x[0]);
          temp_counter=temp_counter+1;



            
            int index1=0;
            while(index1<current_departures.length && parseDateString(current_departures[index1]).isBefore( parseDateString( x[3] ) )){index1++;}
            setState(() {
          current_destination.insert(index1,x[1]);
          current_departures.insert(index1,x[3]);
          current_returns.insert(index1,x[4]);
          current=true;
            });


            
          }
          else if(parseDateString(x[3])==currentdate || parseDateString(x[4])==currentdate){
          
          print('X IS::::::::');
          print(x[0]);
          parentActivityID.add(x[0]);
          temp_counter=temp_counter+1;
          int index2=0;
            while(index2<current_departures.length && parseDateString(current_departures[index2]).isBefore(parseDateString(x[3]))){index2++;}

          setState(() {
          current_destination.insert(index2,x[1]);
          current_departures.insert(index2,x[3]);
          current_returns.insert(index2, x[4]);
          current=true;
            });            
          }
          else if(parseDateString(x[3]).isAfter(currentdate)){setState(() {
                      print('X IS::::::::');
          print(x[0]);
          parentActivityID.add(x[0]);
          temp_counter=temp_counter+1;
            int index3=0;
            while(index3<departures.length && parseDateString(departures[index3]).isBefore( parseDateString(x[3]))){index3++;}
            
          upcoming=true;
          destinations.insert(index3,x[1]);
          departures.insert(index3,x[3]);
          returns.insert(index3,x[4]);
          });}


      

        }
        }
      }



    }} else {

      print('Error: ${response.statusCode}');
      print('Body: $responseBody');
    }
  } catch (error) {

    print('Error: $error  catch ');
  } finally {
    client.close();
  }
}
 
Future<String> scrapePage(String url) async {
  try {
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      return response.body;
    } else {
      print('HTTP Error: ${response.statusCode}');
      return 'error';
    }
  } catch (e) {
    print('Error: $e');
    return 'error';
  }
}

String? extractFirstUploadLink(String text) {
  final pattern = RegExp(r'https://upload[^"]+');
  final match = pattern.firstMatch(text);

  return match?.group(0);
}

Future<String?> findImageLink(String? cityName) async {
  if (cityName == null) {
    print('Error: City name is null');
    return null;
  }

  final link = 'https://en.wikipedia.org/wiki/$cityName';
  print(cityName);
  return extractFirstUploadLink(await scrapePage(link));
}




 
Widget buildContainerWithPadding(List upc_dest, List cur_dest, List upc_dep, List upc_ret, List cur_dep, List cur_ret, ) {

  // List to store the generated Container widgets
  int num_of_trips=upc_dest.length+cur_dest.length-2;
  int num_of_current_trips=cur_dest.length-1;
  int num_of_upcoming_trips=upc_dest.length-1;


  double total=0;
  double paddings=0;
  int temp1=num_of_current_trips;


  List<Widget> containers = [];
  print('number of trips:');
  print(num_of_trips);

  if (num_of_trips==1){
    setState(() {
      num_of_trips=2;
    });
  }

  // Build Container widgets dynamically
  for (int i = 1; i < num_of_trips+1; i++) {
     
      int temp=0;
      if(num_of_current_trips==0){setState(() {
      temp=num_of_upcoming_trips;
    });}




      setState(() {
        paddings=16+(114*total);
      });

      
      String city_name='';
      String departure='';
      String returns='';
      bool active=false;


    if (num_of_current_trips>0){

      setState(() {

        city_name=cur_dest[i];
        departure=cur_dep[i];
        returns=cur_ret[i];
        active=true;
        num_of_current_trips=num_of_current_trips-1;
        total=total+1;

      });


    }
    
    
    else if (temp>0  ){
      print('temp');
      setState(() {

        city_name=upc_dest[i-temp1];
        departure=upc_dep[i-temp1];
        returns=upc_ret[i-temp1];
        active=false;
        num_of_upcoming_trips=num_of_upcoming_trips-1;
        total=total+1;
    });



    }

    if (city_name!=''){
    containers.add(
      GestureDetector(
      onTap: () {
        handleContainerTap(i - 1); // Subtract 1 to adjust for loop index
      },







child:Padding(
          padding: EdgeInsets.fromLTRB(25, paddings, 0, 0),
          child: Visibility(
          visible: num_of_trips>0,
          child:  Container(

            child:Stack(children:[

Visibility(
          visible: num_of_trips>0,
          child: Align (
            child: 
            Padding(
              padding:EdgeInsets.only(left:120, right:50) ,
              child:Text(city_name, 
              overflow:TextOverflow.ellipsis ,
              style:TextStyle(
                   fontFamily: 'Readex Pro',
                    fontWeight: FontWeight.w500,
                    fontSize: 23,
                    color: Colors.white
                            ))),
            alignment: AlignmentDirectional(-1,-0.85),
            ),
        ),



       FutureBuilder<String?>(
         future: findImageLink(city_name),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
              } else if (snapshot.hasError) {
                print('Error: ${snapshot.error}');
                return Text('Error loading image');
              } else if (snapshot.hasData) {
                return
                
                Opacity(  opacity: 1, child: Visibility(
                   visible: num_of_trips>0,
                    child: Align(
                    alignment: AlignmentDirectional(-0.95, -0.1),
                    child:  ClipRRect(
    borderRadius: BorderRadius.circular(24),
    child: Image.network(
      snapshot.data.toString(),
      height: 85,
      width: 95,
      fit: BoxFit.cover,
    ),
        ),)));} else {return Align(
                    alignment: AlignmentDirectional(-0.95, -0.1),
                    child:  ClipRRect(
    borderRadius: BorderRadius.circular(24),
    child: Image.network(
      'https://media.cnn.com/api/v1/images/stellar/prod/190823001700-14-asia-beautiful-town.jpg?q=w_1600,h_900,x_0,y_0,c_fill',
      height: 85,
      width: 95,
      fit: BoxFit.cover,
    ),
        ),);}
        },),


        Visibility(
          visible: num_of_trips>0,
          child: Align(
            alignment: AlignmentDirectional(-0.34,0),
            child:
            Icon(
              Icons.flight_takeoff,
              color: Color(0xFFBEBEBE),
              size:18
              )
          )), 

        Visibility(
          visible: num_of_trips>0,
          child: Align(
            alignment: AlignmentDirectional(0.15,0.0),
            child: 
           Text(
              'Departure: '+departure,
              style: TextStyle(
                   fontFamily: 'Mukta',
                    fontWeight: FontWeight.w500,
                    fontSize: 12,
                    overflow: TextOverflow.ellipsis,
                    color:  Color(0xFFBEBEBE)
                            ),
              )
          )),

                  Visibility(
          visible: num_of_trips>0,
          child: Align(
            alignment: AlignmentDirectional(-0.34,0.5),
            child:
            Icon(
              Icons.flight_land,
              color: Color(0xFFBEBEBE),
              size:18
              )
          )), 

        Visibility(
          visible: num_of_trips>0,
          child: Align(
            alignment: AlignmentDirectional(0.15,0.5),
            child: 
            Text(
              'Return: $returns      ',
              style: TextStyle(
                   fontFamily: 'Mukta',
                    fontWeight: FontWeight.w500,
                    fontSize: 12,
                    overflow: TextOverflow.ellipsis,
                    color:  Color(0xFFBEBEBE)
                            ),
              )
          )),
           Visibility(
          visible: active,
          child: Align(
            alignment: AlignmentDirectional(0.9,-0.73),
            child:Padding(
              padding: EdgeInsets.only(left:30),
             child:Icon(
              Icons.circle,
              color: Color.fromARGB(255, 57, 210, 192),
              size:18
              )
          ))),








            ]),
            width: 380,
            height: 100,
            decoration: BoxDecoration( color: Color.fromARGB(255, 44, 1, 72), borderRadius: BorderRadius.circular(25)),
            ),)),
    ));
  }}

  // Return a widget that contains the dynamically generated Container widgets
  return SingleChildScrollView(
            
              physics: const BouncingScrollPhysics(),
              controller: _scrollController,
        child:Stack(children: containers));
}










  
  Widget build(BuildContext context) {


    

    int num_of_trips=destinations.length+current_destination.length-2;


    var textstyle1=TextStyle(
                   fontFamily: 'Mukta',
                    fontWeight: FontWeight.w500,
                    fontSize: 25,
                    color: Colors.white
                            );


    var title_your_trips= Visibility(
          
          visible: num_of_trips>0,
          child: Align(
            alignment: AlignmentDirectional(-0.8,0.8),
            child:Text('Your Trips:', style: TextStyle(
                   fontFamily: 'Mukta',
                    fontWeight: FontWeight.bold,
                    fontSize: 23,
                    color: Colors.white
                            ),)));


    





    





    var icon_row=Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [

          IconButton(
            onPressed:() async{
              print(token);
              setState(() {
              dummy=false;
            });},
            color: Colors.white,
            iconSize: 40,
            icon: Icon(Icons.airplane_ticket)),

          IconButton(
            onPressed:() async{setState(() {
              dummy=false;
            });},
            color: Colors.white,
            iconSize: 40,
            icon: Icon(Icons.add_box)),

          IconButton(
            onPressed:() async{setState(() {
              dummy=false;
            });},
            color: Colors.white,
            iconSize: 40,
            icon: Icon(Icons.password)),
          
            
        ],);
      var icon_text_row= Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children:[
          Text('Past Trips', style:TextStyle(
                   fontFamily: 'Mukta',
                    fontWeight: FontWeight.w500,
                    fontSize: 9,
                    color: Colors.white
                            ) ,),
          Text('New Trip', style:TextStyle(
                   fontFamily: 'Mukta',
                    fontWeight: FontWeight.w500,
                    fontSize: 9,
                    color: Colors.white
                            ) ,),
          Text('Document', style:TextStyle(
                   fontFamily: 'Mukta',
                    fontWeight: FontWeight.w500,
                    fontSize: 9,
                    color: Colors.white
                            ) ,),

        ])
      ;





    var topnav=Stack(children:[Align(
        alignment: AlignmentDirectional(-0.6,-0.2),
        child: Text('Dashboard', style: textstyle1,)
      ), title_your_trips,

    
      
]);




    var mainscreen=ListView(
      controller: _scrollController,
      children: [Padding(
        padding: EdgeInsets.only(top:0),
        child:Container(
          height: 800,
      child:Stack(children: [
      
      
      
      
       Visibility(
        visible: !visible_dashboard,
        child:  Opacity(
        opacity: 0.5,
        child:Align(
          alignment: AlignmentDirectional(0.0,-0.23),
          child:Text(
            'You dont Have\nAny Upcoming Trips',
            textAlign: TextAlign.center,
            style:TextStyle(
                   fontFamily: 'Mukta',
                    fontWeight: FontWeight.w500,
                    fontSize: 30,
                    color: Colors.white
                            ),
          )
        )
        ),),

      Visibility(
        visible: !visible_dashboard,
        child:  Opacity(
        opacity: 0.2,
        child: Align(
          alignment: AlignmentDirectional(-0.35,0.31),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.asset(
              'Assets/images/Untitled-1-removebg-preview.png',
              width: 300,
              height: 553,
              fit: BoxFit.cover,
              )
          ),

        ),
        ),),
      
      Visibility(
        visible: !visible_dashboard,
        child:  Opacity(
        opacity: 0.3,
        child: Align(
          alignment: AlignmentDirectional(-0.4,0.09),
          child:Text(
            'Why not add one? ',
            style:TextStyle(
                   fontFamily: 'Mukta',
                    fontWeight: FontWeight.w500,
                    fontSize: 25,
                    color: Colors.white
                            ),

          )
        ),
        )),


      // Align(
      //   alignment: AlignmentDirectional(0, 0.98),
      //   child: Container(
      //     child:Column(
      //       mainAxisAlignment: MainAxisAlignment.center,
      //       children: [icon_row, icon_text_row],),
      //     width: 600,
      //     height: 98,
      //     decoration: BoxDecoration(
      //       color: Color(0xFF220852),
      //       shape: BoxShape.rectangle,
      //         ),
      //       ),
      //     ),  
      
      ],)))]);
    var _selectedIndex=0;
    var currentPageIndex=0;
void _onItemTapped(int index) {
  print(index);
  setState(() {
    _selectedIndex = index;
  });

 
  if (_selectedIndex != currentPageIndex) {

    if (_selectedIndex == 1) {
      Navigator.push(context,MaterialPageRoute(builder: (context) =>  _manualTripMakerState()),);
    }
  } else {
  }
}

    var acc_mainscreen= Stack( children:[mainscreen, buildContainerWithPadding(destinations, current_destination, departures, returns, current_departures, current_returns) ]);
return Scaffold(
  appBar: AppBar(
    backgroundColor: Color.fromARGB(255, 0, 0, 0),
    actions: [
      Container(
        child: topnav,
        width: 430,
        color: Color.fromARGB(255, 0, 0, 0),
      )
    ],
    toolbarHeight: 170,
    automaticallyImplyLeading: false,
  ),
  backgroundColor: Colors.black,
  body: acc_mainscreen,
  floatingActionButton: FloatingActionButton(
    backgroundColor: Color.fromARGB(255, 52, 11, 101),
    onPressed: () {
      _onItemTapped(1); // Call _onItemTapped function with parameter 1
    },
    child: Icon(Icons.add_box),
    tooltip: 'New Trip',
  ),
);

  }
}


class createtrip extends StatefulWidget {
  const createtrip({super.key});

  @override
  State<createtrip> createState() => _createtripState();
}

class _createtripState extends State<createtrip> {
  @override




  

var textstyle1=TextStyle(
                   fontFamily: 'Mukta',
                    fontWeight: FontWeight.w500,
                    fontSize: 28,
                    color: Colors.white
                            );

bool placegotten=false;





Widget build(BuildContext context) {
 
 
 var mainscreen1=
 
 Visibility(
  visible: !placegotten,
  child: 
 Stack(children:[

  Padding( padding: EdgeInsets.fromLTRB(30, 0, 0, 500), child:Align(child:Text('Would you like to use AI assistance?', style: textstyle1,), )),
  Align( 
    alignment: AlignmentDirectional(0,0.4),
    child: TextButton(
                  onPressed: () {print('hello1');},
                  child: Text('Use AI Assitance', style: TextStyle(
                          fontFamily: 'Mukta',
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: Colors.black
                        ),),
                  style: TextButton.styleFrom(
                    minimumSize: Size(275, 40),
                    backgroundColor: Color(0xFFE0DBDB),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)
                    ),
                    
                  
                ),
              ),), 
  Align( 
    alignment: AlignmentDirectional(0,0.6),
    child: TextButton(
                  onPressed: () {Navigator.push(context,MaterialPageRoute(builder: (context) =>  _manualTripMakerState()),);},
                  child: Text('Add Manually', style: TextStyle(
                          fontFamily: 'Mukta',
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: const Color.fromARGB(255, 255, 255, 255)
                        ),),
                  style: TextButton.styleFrom(
                    minimumSize: Size(275, 40),
                    backgroundColor: Color.fromARGB(255, 39, 15, 117),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)
                    ),
                    
                  
                ),
              ),), 

 ]
 ));
 
 
 
 
 
 
 
  var _selectedIndex=0;
  var currentPageIndex=1;
  void _onItemTapped(int index) {

  }
 return Scaffold(
  body:mainscreen1,
  backgroundColor: Colors.black,
  bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Color.fromARGB(255, 52, 11, 101),
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_box),
            label: 'New Trip',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.password),
            label: 'Documents',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Color.fromARGB(255, 255, 255, 255),
        unselectedItemColor: Color.fromARGB(255, 255, 255, 255),
        onTap: _onItemTapped,
      ),

 ); 
  }
}




abstract class CommonStatefulWidget extends StatefulWidget {
  const CommonStatefulWidget({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState();
}

abstract class CommonState<T extends StatefulWidget> extends State<T> {
  var parentActivityId='';
  var hotelnameC='';
  var airportnameC='';
  var arrivaltimeC='';
  var departuretimeC='';
  var arrivaldateC='';
  var departuredateC='';
  var checkoutC='';
  var cityC='';


}










class _manualTripMakerState extends CommonStatefulWidget {
  const _manualTripMakerState({super.key});

  @override
  State<_manualTripMakerState> createState() => __manualTripMakerStateState();
}

class __manualTripMakerStateState extends CommonState<_manualTripMakerState> {
  @override





  //-----------

final TextEditingController _controller = TextEditingController();
  List<String> _suggestions = [];
  String checkout_time='';
  String location='';
  bool gotten=false;
  bool time_gotten=false;
  bool mainvisibilityhotel=false;









  //---------

  bool isError = false; 
  bool flights= true;
  bool got=false;
  bool added=false;


  int trys=0;

  List userflight_dep=[0,0,0,0,0,0,0,0];
  List userflight_ret=[0,0,0,0,0,0,0,0,0];


  
  String flNumber_dep='';
  String flNumber_ret='';


  String dep_date='';
  String ret_date='';


  bool addedsuccessfully=false;
  
  
  
   // Variable to store password;
  final _formKeyh = GlobalKey<FormState>();
  final _formKeyy = GlobalKey<FormState>();
  final _formKeys = GlobalKey<FormState>();
  final _formKeysa = GlobalKey<FormState>();



  bool pacmanloader=false;

var textstyle1=TextStyle(
                   fontFamily: 'Mukta',
                    fontWeight: FontWeight.w500,
                    fontSize: 12,
                    color: Colors.white
                            );











int calculateDaysDifference(String date1, String date2) {
  // Split the date strings into year, month, and day
  List<String> date1Parts = date1.split('/');
  List<String> date2Parts = date2.split('/');

  // Convert parts into integers
  int year1 = int.parse(date1Parts[0]);
  int month1 = int.parse(date1Parts[1]);
  int day1 = int.parse(date1Parts[2]);

  int year2 = int.parse(date2Parts[0]);
  int month2 = int.parse(date2Parts[1]);
  int day2 = int.parse(date2Parts[2]);

  // Create DateTime objects for the two dates
  DateTime dateTime1 = DateTime(year1, month1, day1);
  DateTime dateTime2 = DateTime(year2, month2, day2);

  // Calculate the difference in days
  Duration difference = dateTime2.difference(dateTime1);

  // Return the total number of days difference (absolute value)
  return difference.inDays.abs();
}



Future add_to_db_hotel() async {









  final String apiUrl = "https://127.0.0.1:8000/add_hotel?hotel=$hotelnameC&Parent_Activity_Id=$parentActivityId&airportname=$airportnameC&arrivaltime=$arrivaltimeC&departuretime=$departuretimeC&arrivaldate=$arrivaldateC&departuredate=$departuredateC&checkout=$checkoutC";
  
  final String jwtToken = globals.jwtToken; 

  // Prepare headers
  Map<String, String> headers = {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $jwtToken',
  };

  final client = HttpClient();
  client.badCertificateCallback = (X509Certificate cert, String host, int port) => true; // Allow self-signed certificates

  try {
    final uri = Uri.parse(apiUrl);
    final request = await client.getUrl(uri);

    headers.forEach((key, value) {
      request.headers.set(key, value);
    });

    final response = await request.close();
    final responseBody = await utf8.decodeStream(response);

    if (response.statusCode == 200) {
      var data = json.decode(responseBody);
      print(data);
      if (data!='False'){
        print('added to db successfully');
        int daydiff=calculateDaysDifference(dep_date, ret_date);
        print('NEW NEW NEW $dep_date and return date $ret_date  $cityC');
        Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ThingsToDoWidget(
                  thingsToDo: ThingsToDo('$cityC', daydiff), 
                ),
              ),
            );
      }
       
       



    } else {
      setState(() {
        print('error');
      });
    } 
  } catch (e) {
    print(e);
  }
}

String convertDateFormat(String inputDate) {
  // Split the input date string using "/"
  List<String> dateParts = inputDate.split("/");

  // Ensure that the input date has three parts (YYYY, MM, DD)
  if (dateParts.length != 3) {
    throw ArgumentError("Invalid date format");
  }

  // Extract year, month, and day
  int year = int.parse(dateParts[0]);
  int month = int.parse(dateParts[1]);
  int day = int.parse(dateParts[2]);

  // Create a new date string in "DD/MM/YYYY" format
  String outputDate = "$day/${month.toString().padLeft(2, '0')}/$year";

  return outputDate;
}

 Future<List<dynamic>>get_flight_info(String fl_number, String date) async {
  final String apiUrl = "https://127.0.0.1:8000/flight_info?fnum=$fl_number&date=$date";
  final String jwtToken = globals.jwtToken; 

  // Prepare headers
  Map<String, String> headers = {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $jwtToken',
  };

  final client = HttpClient();
  client.badCertificateCallback = (X509Certificate cert, String host, int port) => true; // Allow self-signed certificates

  try {
    final uri = Uri.parse(apiUrl);
    final request = await client.getUrl(uri);

    headers.forEach((key, value) {
      request.headers.set(key, value);
    });

    final response = await request.close();
    final responseBody = await utf8.decodeStream(response);

    if (response.statusCode == 200) {
      var data = json.decode(responseBody);

      if (data != '"Error while fetching- enter detail properly"') {
        print(data);
        print('221');
        return data;
      } else {
        setState(() {
          isError = true;
          print('error');
          print(data);
          
        });
        return [0,0,0,0,0,0,0,0];
      }
    } else {
      setState(() {
        isError = true;
        print('error');
      });
    }
    return [0,0,0,0,0,0,0,0]; // Add this line to explicitly return a value
  } catch (e) {
    print(e);
    return [0,0,0,0,0,0,0,0,0,0,0]; // Add this line to explicitly return a value
  }
}





 Future add_to_db_city() async {




  final String apiUrl = "https://127.0.0.1:8000/add_parent_activity?location=${userflight_dep[1]}&origin=${userflight_dep[0]}&dep=${convertDateFormat(dep_date)}&ret=${convertDateFormat(ret_date)}";
  

  
  
  
  final String jwtToken = globals.jwtToken; 

  // Prepare headers
  Map<String, String> headers = {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $jwtToken',
  };

  final client = HttpClient();
  client.badCertificateCallback = (X509Certificate cert, String host, int port) => true; // Allow self-signed certificates

  try {
    final uri = Uri.parse(apiUrl);
    final request = await client.getUrl(uri);

    headers.forEach((key, value) {
      request.headers.set(key, value);
    });

    final response = await request.close();
    final responseBody = await utf8.decodeStream(response);

    if (response.statusCode == 200) {
      var data = json.decode(responseBody);
      if (data!='False'){
        setState(() {
          parentActivityId=data;
          globals.PAiD=data;
          added=true;
        });
      }
       
       



    } else {
      setState(() {
        isError = true;
        print('error');
      });
    } 
  } catch (e) {
    print(e);
  }
}



changevar(){
    print('PAY ATTENTION!');
    print(userflight_dep);
    setState(() {
    cityC=userflight_dep[1];
    airportnameC=userflight_dep[3];
    arrivaltimeC=userflight_dep[5];
    departuretimeC=userflight_ret[4];
    arrivaldateC=convertDateFormat(dep_date);

    departuredateC=convertDateFormat(ret_date);
  });
}


void showErrorDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Center(
          child: Text(
            "Error",
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Looks like we've been unable to add your flight, please consider adding manually:",
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {

                print("Add manually button pressed");
                Navigator.pop(context); 
              },
              child: Text("Add Manually"),
            ),
                        ElevatedButton(
              onPressed: () {

                setState(() {
                  trys=0;
                });
                Navigator.pop(context); 
              },
              child: Text("Try Again"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey,
            ),
        )],
        ),
      );
    },
  );
}






void _performAsyncOperation() async {
  setState(() {
    pacmanloader = true;
  });

  userflight_dep = await get_flight_info(flNumber_dep, dep_date.replaceAll('/', ''));
  await Future.delayed(Duration(seconds: 2));
  userflight_ret = await get_flight_info(flNumber_ret, ret_date.replaceAll('/', ''));

  setState(() {
    pacmanloader = false;
    flights = false;
    got=true;
  });

  if (userflight_dep[0]==0 || userflight_ret[0]==0){
    setState(() {
      flights=true;
      got=false;
      isError=true;

    });
  }
}






  Widget build(BuildContext context) {

  var hotel_main_screen=
  
  
  Visibility(
    
    visible: mainvisibilityhotel,
    child:
  Stack(children:
  
  
  
  [
    

    
    Padding(
      padding: EdgeInsets.fromLTRB(30, 260, 30, 0),
      child:
    Align(
    alignment: AlignmentDirectional(0,-1),
    child:Column(
          children: [
            TextFormField(
                            
                             onChanged: onSearchTextChanged,
                             controller:_controller,
                              autofocus: true,
                              autofillHints: [AutofillHints.email],
                              textCapitalization: TextCapitalization.none,
                              textInputAction: TextInputAction.next,
                              obscureText: false,
                              decoration: InputDecoration(
                                labelText: 'Enter Hotel/AirBnb/Reservation address ',
                                labelStyle: TextStyle(
                                  fontFamily: 'Readex Pro',
                                  color: Color(0xFF7B7B7B),
                                  fontWeight: FontWeight.normal,
                                ),
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.white,
                                    width: 3,
                                  ),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.white,
                                    width: 3,
                                  ),
                                  borderRadius: BorderRadius.circular(50),
                                ),
                                prefixIcon: Icon(
                                  Icons.pin_drop,
                                  color: Colors.white,
                                  size: 25,
                                ),
                              ),
                              style: TextStyle(
                                fontFamily: 'Readex Pro',
                                color: Colors.white,
                              ),
                              keyboardType: TextInputType.emailAddress,

                            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: _suggestions.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(_suggestions[index], style: TextStyle(color: Colors.grey),),
                    onTap: () {
                      setState(() {
                        location=_suggestions[index];
                        hotelnameC=location;
                        gotten=true;
                        _controller.text = location;
                        _suggestions = []; // Clear suggestions list
                      });
                      
                    },
                  );
                },
              ),
            ),
          ],
        ))),
       
       
       Padding (
        padding:EdgeInsets.fromLTRB(30, 0, 30, 0),
        child:
        Visibility(
          visible: gotten,
          child: Align(
          alignment: AlignmentDirectional(0,-0.2),
          child:TextFormField(
                            
                             onChanged: (value){
                              setState(() {
                                checkout_time=value;
                                checkoutC=checkout_time;
                             });},
                              autofocus: true,
                              autofillHints: [AutofillHints.email],
                              textCapitalization: TextCapitalization.none,
                              textInputAction: TextInputAction.next,
                              obscureText: false,
                              decoration: InputDecoration(
                                labelText: 'Enter Check Out time HH:MM',
                                labelStyle: TextStyle(
                                  fontFamily: 'Readex Pro',
                                  color: Color(0xFF7B7B7B),
                                  fontWeight: FontWeight.normal,
                                ),
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.white,
                                    width: 3,
                                  ),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.white,
                                    width: 3,
                                  ),
                                  borderRadius: BorderRadius.circular(50),
                                ),
                                prefixIcon: Icon(
                                  Icons.watch,
                                  color: Colors.white,
                                  size: 25,
                                ),
                              ),
                              style: TextStyle(
                                fontFamily: 'Readex Pro',
                                color: Colors.white,
                              ),
                              keyboardType: TextInputType.emailAddress,

                            ),
            
))),
              Visibility(
                visible:time_gotten|| !addedsuccessfully,
                child:Align(
                alignment: AlignmentDirectional(0.00, 0.64),
                child: TextButton(
                  onPressed: () async {
                    setState(() {
                     print('proceed pressed');
                     add_to_db_hotel();
                      time_gotten=false;
                      pacmanloader=true;
                    });


                      
                      },
                  child: Text('Proceed', style: TextStyle(
                          fontFamily: 'Mukta',
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: Colors.black
                        ),),
                  style: TextButton.styleFrom(
                    minimumSize: Size(275, 40),
                    backgroundColor: Color(0xFFE0DBDB),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)
                    ),),),)),


      ]));






  var mainscreenconfirm=Visibility(
    visible: got,
    child: Stack(
    children: [
        Align(
          alignment: AlignmentDirectional(0,-0.8),
          child:Text('Confrim Details:', style: TextStyle(
                   fontFamily: 'Mukta',
                    fontWeight: FontWeight.w500,
                    fontSize: 25,
                    color: Colors.white
                            ))

        ),

        Align(
          alignment: AlignmentDirectional(-0.45, -0.6 ),
          child:Text(' Departure: $dep_date', style:TextStyle(
                   fontFamily: 'Mukta',
                    fontWeight: FontWeight.w500,
                    fontSize: 18,
                    color: Colors.white
                            ))
        ),


        Align(
          alignment: AlignmentDirectional(-0.7,-0.5),
          child: 
          Icon(Icons.flight_takeoff, color: Colors.white, size: 40,),
        ),

        Align(
          
          alignment: AlignmentDirectional(-0.38, -0.49),
          child: Text('${userflight_dep[6]}', style:TextStyle(
                   fontFamily: 'Mukta',
                    fontWeight: FontWeight.w500,
                    fontSize: 25,
                    color: Colors.white
                            ) ),),
          Align(
          alignment: AlignmentDirectional(-0.7, -0.42),
          child: Padding ( 
            padding: EdgeInsetsDirectional.fromSTEB(60, 0, 200, 0),
            child:Text('${userflight_dep[2]}', style:TextStyle(
                   fontFamily: 'Mukta',
                    fontWeight: FontWeight.w500,
                    fontSize: 12,
                    color: Colors.white
                            ) ),)),

          Align(
          alignment: AlignmentDirectional(0.8, -0.48),
          child: Padding ( 
            padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
            child:Text('${userflight_dep[4]}', style:TextStyle(
                   fontFamily: 'Mukta',
                    fontWeight: FontWeight.w500,
                    fontSize: 20,
                    color: Colors.white
                            ) ),)),

//-------------------------------------------------------------------

         Align(
          alignment: AlignmentDirectional(-0.7,-0.3),
          child: 
          Icon(Icons.flight_land, color: Colors.white, size: 40,),
        ),

        Align(
          alignment: AlignmentDirectional(-0.38, -0.29),
          child: Text('${userflight_dep[7]}', style:TextStyle(
                   fontFamily: 'Mukta',
                    fontWeight: FontWeight.w500,
                    fontSize: 25,
                    color: Colors.white
                            ) ),),
          Align(
          alignment: AlignmentDirectional(-0.7, -0.22),
          child: Padding ( 
            padding: EdgeInsetsDirectional.fromSTEB(60, 0, 200, 0),
            child:Text('${userflight_dep[3]}', style:TextStyle(
                   fontFamily: 'Mukta',
                    fontWeight: FontWeight.w500,
                    fontSize: 12,
                    color: Colors.white
                            ) ),)),

          Align(
          alignment: AlignmentDirectional(0.8, -0.28),
          child: Padding ( 
            padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
            child:Text('${userflight_dep[5]}', style:TextStyle(
                   fontFamily: 'Mukta',
                    fontWeight: FontWeight.w500,
                    fontSize: 20,
                    color: Colors.white
                            ) ),)),

        Align(
          alignment: AlignmentDirectional(0, -0.1),
          child: Padding(
            padding: EdgeInsetsDirectional.all(30),
             child:Container(height:0.9, width: 350, color: Colors.white)
        )),
///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
        Align(
          alignment: AlignmentDirectional(-0.55, 0 ),
          child:Text(' Return: $ret_date', style:TextStyle(
                   fontFamily: 'Mukta',
                    fontWeight: FontWeight.w500,
                    fontSize: 18,
                    color: Colors.white
                            ))
        ),


        Align(
          alignment: AlignmentDirectional(-0.7,0.1),
          child: 
          Icon(Icons.flight_takeoff, color: Colors.white, size: 40,),
        ),

        Align(
          alignment: AlignmentDirectional(-0.38, 0.11),
          child: Text('${userflight_ret[6]}', style:TextStyle(
                   fontFamily: 'Mukta',
                    fontWeight: FontWeight.w500,
                    fontSize: 25,
                    color: Colors.white
                            ) ),),
          Align(
          alignment: AlignmentDirectional(-0.7, 0.18),
          child: Padding ( 
            padding: EdgeInsetsDirectional.fromSTEB(60, 0, 200, 0),
            child:Text('${userflight_ret[2]}', style:TextStyle(
                   fontFamily: 'Mukta',
                    fontWeight: FontWeight.w500,
                    fontSize: 12,
                    color: Colors.white
                            ) ),)),

          Align(
          alignment: AlignmentDirectional(0.8, 0.12),
          child: Padding ( 
            padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
            child:Text('${userflight_ret[4]}', style:TextStyle(
                   fontFamily: 'Mukta',
                    fontWeight: FontWeight.w500,
                    fontSize: 20,
                    color: Colors.white
                            ) ),)),

//-------------------------------------------------------------------

         Align(
          alignment: AlignmentDirectional(-0.7,0.3),
          child: 
          Icon(Icons.flight_land, color: Colors.white, size: 40,),
        ),

        Align(
          alignment: AlignmentDirectional(-0.38, 0.31),
          child: Text('${userflight_ret[7]}', style:TextStyle(
                   fontFamily: 'Mukta',
                    fontWeight: FontWeight.w500,
                    fontSize: 25,
                    color: Colors.white
                            ) ),),
          Align(
          alignment: AlignmentDirectional(-0.7, 0.38),
          child: Padding ( 
            padding: EdgeInsetsDirectional.fromSTEB(60, 0, 200, 0),
            child:Text('${userflight_ret[3]}', style:TextStyle(
                   fontFamily: 'Mukta',
                    fontWeight: FontWeight.w500,
                    fontSize: 12,
                    color: Colors.white
                            ) ),)),

          Align(
          alignment: AlignmentDirectional(0.8, 0.32),
          child: Padding ( 
            padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
            child:Text('${userflight_ret[5]}', style:TextStyle(
                   fontFamily: 'Mukta',
                    fontWeight: FontWeight.w500,
                    fontSize: 20,
                    color: Colors.white
                            ) ),)),







        Visibility(
          visible: !pacmanloader,
          child:  Align(
          alignment: AlignmentDirectional(0,0.8),
          child:TextButton(
                  onPressed: () async {
                    changevar();
                    print('done');
        
                    print([ 'hello [][][]',parentActivityId, hotelnameC, airportnameC, arrivaltimeC, departuretimeC, arrivaldateC, departuredateC, checkoutC, ]);

                    setState(() {
                      pacmanloader=true;
                    });
                    add_to_db_city();

                    setState(() {
                      pacmanloader=false;
                      got=false; 
                       mainvisibilityhotel=true;
                    });
                     
                    
                },
                  child: Text('Proceed', style: TextStyle(
                          fontFamily: 'Mukta',
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: Colors.black
                        ),),
                  style: TextButton.styleFrom(
                    minimumSize: Size(275, 40),
                    backgroundColor: Color(0xFFE0DBDB),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)
                    ),),) ,
          )),
    
    ],
  ));
  
  
  
  
  
  
  
    var mainscreen=
    Visibility (
      
      visible: flights || isError,
      child:
    
    Stack(children: [
        Visibility(
          visible: pacmanloader,
          child: Align(
            alignment: AlignmentDirectional(0,0.64),
            child: Image.asset('Assets/images/pacman.gif', height: 100, fit: BoxFit.cover,))),
          


              Visibility( 
                visible: !pacmanloader,
                child:Align(
                alignment: AlignmentDirectional(0.00, 0.64),
                child: TextButton(
                  onPressed: () {

                        trys = trys + 1;
                        if (trys < 4) {
                          _performAsyncOperation();
                        } else {
                          print('error triggered here 1232');
                          showErrorDialog(context);
                        }

                      },
                  child: Text('Proceed', style: TextStyle(
                          fontFamily: 'Mukta',
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: Colors.black
                        ),),
                  style: TextButton.styleFrom(
                    minimumSize: Size(275, 40),
                    backgroundColor: Color(0xFFE0DBDB),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)
                    ),),),),),
                  



              Align(
                alignment: AlignmentDirectional(0.00, 0.75),
                child: OutlinedButton(
                  onPressed: () {
                    print('pressed');
                  },
                  child: Text('Dont Have Flight Number?- Add Manually', style: TextStyle(
                          fontFamily: 'Mukta',
                          fontSize: 9.5,
                          fontWeight: FontWeight.w500,
                          color: Colors.white
                        ),),
                  style: OutlinedButton.styleFrom(
                    minimumSize: Size(275, 40),
                    backgroundColor: Color.fromARGB(255, 0, 0, 0),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)
                    ),)),),
    
              


               Align(
                      alignment: AlignmentDirectional(0.00, -0.5),
                      child: Form(
                        key: _formKeyy,
                        autovalidateMode: isError ? AutovalidateMode.always : AutovalidateMode.onUserInteraction,
                        child: Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(8, 0, 8, 0),
                          child: Container(
                            width: 320,
                            child: TextFormField(
                              validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Please Fill in the form correctly!";
                              }
                              else if (isError) {
                                return "Enter Detail Correctly!";
                              }


                              return null;
                            },
                             onChanged: (value) {
                                setState(() {
                                  flNumber_dep = value;
                                  isError=false;
                                });
                                
                              },
                              autofocus: true,
                              autofillHints: [AutofillHints.email],
                              textCapitalization: TextCapitalization.none,
                              textInputAction: TextInputAction.next,
                              obscureText: false,
                              decoration: InputDecoration(
                                labelText: 'Enter Departure Flight Number',
                                labelStyle: TextStyle(
                                  fontFamily: 'Readex Pro',
                                  color: Color(0xFF7B7B7B),
                                  fontWeight: FontWeight.normal,
                                ),
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.white,
                                    width: 3,
                                  ),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                errorBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: isError ? Colors.red : Colors.white,
                                    width: 3,
                                  ),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                focusedErrorBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: isError ? Colors.red : Colors.white,
                                    width: 3,
                                  ),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.white,
                                    width: 3,
                                  ),
                                  borderRadius: BorderRadius.circular(50),
                                ),
                                prefixIcon: Icon(
                                  Icons.flight_takeoff,
                                  color: Colors.white,
                                  size: 25,
                                ),
                              ),
                              style: TextStyle(
                                fontFamily: 'Readex Pro',
                                color: Colors.white,
                              ),
                              keyboardType: TextInputType.emailAddress,

                            ),
                          ), 
                        ),
                      ),
                    ),
              Align(
                alignment: AlignmentDirectional(-0.56, -0.55),
                child: Text(
                  'Flight Number',
                  style: TextStyle(
                        fontFamily: 'Readex Pro',
                        color: Colors.white,
                        fontSize: 15,
                      ),
                ),
              ),
              Align(
      alignment: AlignmentDirectional(0.00, -0.3),
      child:  Form ( 
        key: _formKeys, 
        autovalidateMode: isError ? AutovalidateMode.always : AutovalidateMode.onUserInteraction,
        child:
      
      Padding(
        padding: EdgeInsetsDirectional.fromSTEB(8, 0, 8, 0),
        child: Container(
          width: 320,
          
          child: TextFormField(
            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Please Fill in the form correctly!";
                              }
                              else if (isError) {
                                return "Enter Detail Correcly!";
                              }
                              return null;
                            },

            autofocus: true,
            textInputAction: TextInputAction.go,
            onChanged: (value) {
                                setState(() {
                                  flNumber_ret = value;
                                  isError=false;
                                });

                                

                              }, 
            decoration: InputDecoration(
              labelText: 'Enter Return Flight Number',
              labelStyle: TextStyle(
                fontFamily: 'Readex Pro',
                color: Color(0xFF7B7B7B),
              ),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: Colors.white,
              width: 3,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: Colors.white,
              width: 3,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          errorBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: isError? Colors.red: Colors.white,
              width: 3,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          focusedErrorBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: isError? Colors.red: Colors.white,
              width: 3,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          prefixIcon: Icon(
            Icons.flight_land,
            color: Colors.white,
            size: 25,
          ),
          
        
          hintStyle: TextStyle(color: Colors.white),
        
          //labelStyle: TextStyle(color: Colors.white),
        ),
        style: TextStyle(color: Colors.white), 
       
      ),
    ),
      )),
),
              Align(
                alignment: AlignmentDirectional(-0.6, -0.36),
                child: Text(
                  'Flight Number',
                  style: TextStyle(
                        fontFamily: 'Readex Pro',
                        color: Colors.white,
                        fontSize: 15,
                      ),
                ),
              ),
              Align(
                alignment: AlignmentDirectional(0.00, -0.7),
                child: Text(
                  'Enter Flight Details',
                  style: TextStyle(
                        fontFamily: 'Outfit',
                        color: Colors.white,
                        fontSize: 30,
                      ),
                ),
              ),









       
       
       Align(
                      alignment: AlignmentDirectional(0.3, 0.38),
                      child: Container(
                        width: 340,
                        height: 150,
                        decoration: BoxDecoration(
    borderRadius: BorderRadius.circular(10.0), 
    border: Border.all(
      color: Colors.white, 
      width: 2.0,
    )),
                        
                        child: Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(20, 16, 20, 20),
                          child:Text('If you have a connecting flight then please only add the last flight of your connecting flight. For Example if you are traveling from London to Tokyo with a connection in Dubai please only enter the flight number for Dubai->Tokyo. When Entering the return Flight enter the First flight so in this case it would be Tokyo->Dubai', style: textstyle1,)))),
       
       
       
       
       
       Align(
                alignment: AlignmentDirectional(-0.65, -0.05),
                child: Text(
                  'Departure Date',
                  style: TextStyle(
                        fontFamily: 'Readex Pro',
                        color: Colors.white,
                        fontSize: 15,
                      ),
                ),
              ),
          
          
Align(
                      alignment: AlignmentDirectional(-0.65, 0),
                      child: Container(
                        width: 180,
                        height: 90,
                        decoration: BoxDecoration(
    borderRadius: BorderRadius.circular(10.0), 
    border: Border.all(
      color: Colors.white, 
      width: 2.0,
    )),
                        
                        child: Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(0, 20, 20, 0),
                          child:Form(
                        key: _formKeyh,
                        autovalidateMode: isError? AutovalidateMode.always : AutovalidateMode.onUserInteraction,
                        child: Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(8, 0, 8, 0),
                          child: Container(
                            width: 320,
                            child: TextFormField(
                              validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Please Fill in the form correctly!";
                              }
                              else if (isError) {
                                return "Date Format YYYY/MM/DD";
                              }


                              return null;
                            },
                             onChanged: (value) {
                                setState(() {
                                  dep_date = value;
                                  isError=false;

                                });
                                
                              },
                              autofocus: true,
                              autofillHints: [AutofillHints.birthdayDay],
                              textCapitalization: TextCapitalization.none,
                              textInputAction: TextInputAction.next,
                              obscureText: false,
                              decoration: InputDecoration(
                                labelText: 'YYYY/MM/DD',
                                labelStyle: TextStyle(
                                  fontFamily: 'Readex Pro',
                                  color: Color(0xFF7B7B7B),
                                  fontWeight: FontWeight.normal,
                                ),
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.white,
                                    width: 3,
                                  ),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                errorBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: isError? Colors.red : Colors.white,
                                    width: 3,
                                  ),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                focusedErrorBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: isError? Colors.red : Colors.white,
                                    width: 3,
                                  ),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.white,
                                    width: 3,
                                  ),
                                  borderRadius: BorderRadius.circular(50),
                                ),
                                prefixIcon: Icon(
                                  Icons.flight_takeoff,
                                  color: Colors.white,
                                  size: 25,
                                ),
                              ),
                              style: TextStyle(
                                fontFamily: 'Readex Pro',
                                color: Colors.white,
                              ),
                              keyboardType: TextInputType.emailAddress,

                            ),
                          ), 
                        ),
                      ),
                    ),)),
    






       Align(
                alignment: AlignmentDirectional(0.45, -0.05),
                child: Text(
                  'Return Date',
                  style: TextStyle(
                        fontFamily: 'Readex Pro',
                        color: Colors.white,
                        fontSize: 15,
                      ),
                ),
              ),
          
          
Align(
                      alignment: AlignmentDirectional(0.85, 0),
                      child: Container(
                        width: 180,
                        height: 90,
                        decoration: BoxDecoration(
    borderRadius: BorderRadius.circular(10.0), 
    border: Border.all(
      color: Colors.white, 
      width: 2.0,
    )),
                        
                        child: Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(0, 20, 20, 0),
                          child:Form(
                        key: _formKeysa,
                        autovalidateMode: isError ? AutovalidateMode.always : AutovalidateMode.onUserInteraction,
                        child: Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(8, 0, 8, 0),
                          child: Container(
                            width: 320,
                            child: TextFormField(
                              validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Please Fill in the form correctly!";
                              }
                              else if (isError) {
                                return "Date Format: YYYY/MM/DD";
                              }


                              return null;
                            },
                             onChanged: (value) {
                                setState(() {
                                  ret_date = value;
                                  isError=false;

                                });
                                
                              },
                              autofocus: true,
                              autofillHints: [AutofillHints.email],
                              textCapitalization: TextCapitalization.none,
                              textInputAction: TextInputAction.next,
                              obscureText: false,
                              decoration: InputDecoration(
                                labelText: 'YYYY/MM/DD',
                                labelStyle: TextStyle(
                                  fontFamily: 'Readex Pro',
                                  color: Color(0xFF7B7B7B),
                                  fontWeight: FontWeight.normal,
                                ),
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.white,
                                    width: 3,
                                  ),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                errorBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: isError ? Colors.red : Colors.white,
                                    width: 3,
                                  ),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                focusedErrorBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: isError ? Colors.red : Colors.white,
                                    width: 3,
                                  ),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.white,
                                    width: 3,
                                  ),
                                  borderRadius: BorderRadius.circular(50),
                                ),
                                prefixIcon: Icon(
                                  Icons.flight_land,
                                  color: Colors.white,
                                  size: 25,
                                ),
                              ),
                              style: TextStyle(
                                fontFamily: 'Readex Pro',
                                color: Colors.white,
                              ),
                              keyboardType: TextInputType.emailAddress,

                            ),
                          ), 
                        ),
                      ),
                    ),)),
 ],)) ;




    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack( children:[mainscreen, mainscreenconfirm, hotel_main_screen])
    );
  }
  void onSearchTextChanged(String query) async {
    final String apiKey = 'AIzaSyCIwodz3NUBEQIs0ToIyRB7yI_KdxF8VS4'; // Replace with your Google Places API key
    final String baseUrl =
        'https://maps.googleapis.com/maps/api/place/autocomplete/json';

    final String input = Uri.encodeComponent(query);

    final String url = '$baseUrl?input=$input&key=$apiKey';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['status'] == 'OK') {
        setState(() {
          _suggestions = List<String>.from(
            data['predictions'].map((prediction) => prediction['description']),
          );
        });
      } else {
        setState(() {
          _suggestions = [];
        });
      }
    } else {
      setState(() {
        _suggestions = [];
      });
    }
  }

}









class ThingsToDo {
  final String city;
  final int days;

  ThingsToDo(this.city, this.days);
}

class ThingsToDoWidget extends StatefulWidget {
  final ThingsToDo thingsToDo;

  const ThingsToDoWidget({Key? key, required this.thingsToDo}) : super(key: key);

  @override
  _ThingsToDoWidgetState createState() => _ThingsToDoWidgetState();
}

class _ThingsToDoWidgetState extends State<ThingsToDoWidget> {
  List<String> names = [];
  List<String> locations = [];
  Set<String> selectedNames = Set();
  Set<String> selectedLocations = Set();


  
  

  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    fetchData();
    
  }

  Future<void> fetchData() async {
    final String apiUrl = "https://127.0.0.1:8000/attractions?city=${widget.thingsToDo.city}";
    print(widget.thingsToDo.city);
    print(widget.thingsToDo.days);

    // Replace this with your actual token mechanism
    final String jwtToken = globals.jwtToken;

    // Prepare headers
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $jwtToken',
    };

    final client = HttpClient();
    client.badCertificateCallback = (X509Certificate cert, String host, int port) => true; // Allow self-signed certificates

    try {
      final uri = Uri.parse(apiUrl);
      final request = await client.getUrl(uri);

      headers.forEach((key, value) {
        request.headers.set(key, value);
      });

      final response = await request.close();
      final responseBody = await utf8.decodeStream(response);

      parseApiResponse(responseBody);
    } catch (e) {
      setState(() {
        errorMessage = "Error fetching data: $e";
        isLoading = false;
      });
    }
  }
  
Future<String> feed_data() async {


  print(selectedLocations);
  print(selectedNames);
    final String apiUrl = "https://127.0.0.1:8000/update_db_ca?poi_key=${selectedNames}&pa_id=${globals.PAiD}";


    // Replace this with your actual token mechanism
    final String jwtToken = globals.jwtToken;

    // Prepare headers
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $jwtToken',
    };

    final client = HttpClient();
    client.badCertificateCallback = (X509Certificate cert, String host, int port) => true; // Allow self-signed certificates

    try {
      final uri = Uri.parse(apiUrl);
      final request = await client.getUrl(uri);

      headers.forEach((key, value) {
        request.headers.set(key, value);
      });

      final response = await request.close();
      final responseBody = await utf8.decodeStream(response);
      return responseBody;

    } catch (e) {
      setState(() {
        errorMessage = "Error fetching data: $e";
        isLoading = false; 
      });
    }
    return 'false';
  }






void parseApiResponse(String response) {
  final Map<String, dynamic> jsonResponse = json.decode(response);
  print(response);

  names.clear();
  locations.clear();

  jsonResponse.forEach((name, address) {
    names.add(name);
    locations.add(address);
  });

  setState(() {
    isLoading = false;
  });
}

  void toggleSelection(int index) {
    final name = names[index];
    final location = locations[index];

    setState(() {
      if (selectedNames.contains(name)) {
        selectedNames.remove(name);
        selectedLocations.remove(location);
      } else {
        selectedNames.add(name);
        selectedLocations.add(location);
      }
    });
  }

void navigateToNextPage() async {
  setState(() {
    isLoading = true; // Set loading to true when initiating navigation
  });
  
  final feedDataResponse = await feed_data(); // Wait for feed data to return
  print(feedDataResponse);
  if (feedDataResponse == '"True"') {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => (TodoList())),
    );
  } else {
    setState(() {
      isLoading = false; // Set loading to false if feed data doesn't return true
      errorMessage = "Error: Feed data did not return True";
    });
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Things To Do'),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : errorMessage != null
              ? Center(child: Text(errorMessage!))
              : names.isEmpty || locations.isEmpty
                  ? Center(child: Text('No data available'))
                  : ListView.builder(
                      itemCount: names.length,
                      itemBuilder: (context, index) {
                        final isSelected = selectedNames.contains(names[index]);

                        return GestureDetector(
                          onTap: () => toggleSelection(index),
                          child: Container(
                            margin: EdgeInsets.all(10),
                            child: Card(
                              color: isSelected ? Colors.blue.withOpacity(0.5) : null,
                              child: ListTile(
                                title: Text(names[index]),
                                subtitle: Text(locations[index]),
                                trailing: isSelected ? Icon(Icons.check_circle, color: Colors.green) : null,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
      floatingActionButton: FloatingActionButton(
        onPressed: navigateToNextPage,
        child: Icon(Icons.arrow_forward),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

 
class Task {
  String name;
  DateTime date;

  Task({required this.name, required this.date});
}

class TodoList extends StatefulWidget {
  @override
  _TodoListState createState() => _TodoListState();
}

class _TodoListState extends State<TodoList> {
  TextEditingController _controller = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  List<Task> _tasks = [];
  List<Task> _tempTasks = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      print('initialized');
      get_data();
    });
  }

  void _addTask(String taskName, DateTime date) {
    try {
      setState(() {
        _tasks.add(Task(name: taskName, date: date));
      });
      _controller.clear();
    } catch (e) {
      print('Error adding task: $e');
    }
  }

  void _temp_Add_Task(String taskName, DateTime date) {
    try {
      setState(() {
        _tempTasks.add(Task(name: taskName, date: date));
      });
      _controller.clear();
    } catch (e) {
      print('Error adding task: $e yemp');
    }
  }

  void check_difference() {
    if (_tempTasks != _tasks) {





      delete_task_todb();
      print('difference _found!');
      _tasks.forEach((element) {


          print([element.name, element.date]);
          add_task_todb(element.name, element.date);

      });






    }
  }

  void add_task_todb(String taskName1, DateTime date1) async {
    String formattedDate = DateFormat('dd/MM/yyyy').format(date1);
    print('testingsfdsffsdfdsfsdf');
    print(taskName1);
    print(formattedDate);
    final String apiUrl =
        "https://127.0.0.1:8000/update_single?pa_id=${globals.PAiD}&date=${formattedDate}&item=${taskName1}";

    final String jwtToken = globals.jwtToken;
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $jwtToken',
    };

    final client = HttpClient();
    client.badCertificateCallback =
        (X509Certificate cert, String host, int port) => true;

    final uri = Uri.parse(apiUrl);
    final request = await client.getUrl(uri);

    headers.forEach((key, value) {
      request.headers.set(key, value);
    });

    final response = await request.close();

  }




void delete_task_todb() async {
    final String apiUrl =
        "https://127.0.0.1:8000/delete_elemetns?pa_id=${globals.PAiD}";

    final String jwtToken = globals.jwtToken;
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $jwtToken',
    };

    final client = HttpClient();
    client.badCertificateCallback =
        (X509Certificate cert, String host, int port) => true;

    final uri = Uri.parse(apiUrl);
    final request = await client.getUrl(uri);

    headers.forEach((key, value) {
      request.headers.set(key, value);
    });

    final response = await request.close();
    final responseBody = await utf8.decodeStream(response);
  }






  void _editTask(int index, String newName) {
    setState(() {
      _tasks[index].name = newName;
    });
  }

  void _deleteTask(int index) {
    setState(() {
      _tasks.removeAt(index);
    });
  }

  void _updateTasksOrder(int oldIndex, int newIndex) {
    setState(() {
      if (oldIndex < newIndex) {
        newIndex -= 1;
      }
      final Task item = _tasks.removeAt(oldIndex);
      _tasks.insert(newIndex, item);
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate)
      setState(() {
        _selectedDate = picked;
      });
  }

  Future<void> get_data() async {
    final String apiUrl =
        "https://127.0.0.1:8000/routine_lookup?paid=${globals.PAiD}";

    final String jwtToken = globals.jwtToken;
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $jwtToken',
    };

    final client = HttpClient();
    client.badCertificateCallback =
        (X509Certificate cert, String host, int port) => true;

    final uri = Uri.parse(apiUrl);
    final request = await client.getUrl(uri);

    headers.forEach((key, value) {
      request.headers.set(key, value);
    });

    final response = await request.close();
    final responseBody = await utf8.decodeStream(response);


    print(responseBody);
    if (responseBody!='false'){ 
    String correctedInput = responseBody.replaceAll("'", '"');
    List<dynamic> decodedList = jsonDecode(correctedInput);
    List<List<String>> dataList =
        decodedList.map((dynamic item) => List<String>.from(item)).toList();
    print(dataList);
    dataList.forEach((entry) {
      if (entry.length >= 2) {
        final String dateString =
            entry[0].trim().replaceAll('"', '');
        final String eventName = entry[1].trim();

        final List<String> dateParts = dateString.split('/');
        if (dateParts.length == 3) {
          final int? year = int.tryParse(dateParts[2]);
          final int? month = int.tryParse(dateParts[1]);
          final int? day = int.tryParse(dateParts[0]);

          if (year != null && month != null && day != null) {
            final DateTime eventDate = DateTime(year, month, day);

            _addTask(eventName, eventDate);
            _temp_Add_Task(eventName, eventDate);
                  print('ACTUAL TASKS:::::::');
      print(_tasks);
      print(_tempTasks);
          }
        }
      }
    });};
  }

  void printTasks() {
    print(_tasks);
    print("Tasks:");
    _tasks.forEach((task) {
      print("${task.name} - ${task.date}");
    });
  }

  Widget build(BuildContext context) {
  _tasks.sort((a, b) => a.date.compareTo(b.date)); // Sort tasks by date

  Map<DateTime, List<Task>> groupedTasks = {};
  _tasks.forEach((task) {
    DateTime key = DateTime(task.date.year, task.date.month, task.date.day);
    if (!groupedTasks.containsKey(key)) {
      groupedTasks[key] = [];
    }
    groupedTasks[key]!.add(task);
  });

  return Scaffold(
    appBar: AppBar(
      title: Text('To-Do List'),
    ),
    body: ListView(
      children: groupedTasks.entries.map((entry) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: ExpansionTile(
            title: Text(
              DateFormat('EEEE, d MMMM').format(entry.key),
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            children: [
              ReorderableListView(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                onReorder: _updateTasksOrder,
                children: entry.value.map((task) {
                  return ListTile(
                    key: ValueKey(task),
                    title: Text(task.name),
                    trailing: IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () => _deleteTask(_tasks.indexOf(task)),
                    ),
                    onTap: () async {
                      final editedName = await showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Edit Task'),
                            content: TextField(
                              controller: TextEditingController(text: task.name),
                              autofocus: true,
                              onChanged: (value) {
                                task.name = value;
                              },
                            ),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text('Cancel'),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop(task.name);
                                },
                                child: Text('Save'),
                              ),
                            ],
                          );
                        },
                      );
                      if (editedName != null) {
                        _editTask(_tasks.indexOf(task), editedName);
                      }
                    },
                  );
                }).toList(),
              ),
            ],
          ),
        );
      }).toList(),
    ),
    floatingActionButton: Padding(
      padding: EdgeInsets.only(bottom: 60),
      child: FloatingActionButton(
        onPressed: () async {
          final newTask = await showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Add Task'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    TextField(
                      controller: _controller,
                      decoration: InputDecoration(labelText: 'Task'),
                    ),
                    SizedBox(height: 20.0),
                    Row(
                      children: <Widget>[
                        Text('Select Date:'),
                        SizedBox(width: 10),
                        TextButton(
                          onPressed: () => _selectDate(context),
                          child: Text(
                            '${DateFormat('EEEE, d MMMM').format(_selectedDate)}',
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () {
                      final taskName = _controller.text;
                      if (taskName.isNotEmpty) {
                        _addTask(taskName, _selectedDate);
                        Navigator.of(context).pop(taskName);
                      }
                    },
                    child: Text('Add'),
                  ),
                ],
              );
            },
          );
        },
        child: Icon(Icons.add),
      ),
    ),
    floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    bottomNavigationBar: BottomAppBar(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          ElevatedButton(
            onPressed: () {
              check_difference();
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SharedListPage()),
              );
            },
            child: Text('Continue'),
          ),
        ],
      ),
    ),
  );
}}



class SharedListPage extends StatefulWidget {
  @override
  _SharedListPageState createState() => _SharedListPageState();
}

class _SharedListPageState extends State<SharedListPage> {
  // Replace this with the data you get from display_shares function
  final List<String> sharedUsers = [];
  final List<String> sharedUsers_temp = [];
  bool isLoading = true;
  @override
  void initState(){
    super.initState();
    get_data();
  }




  Future<void> get_data() async {
  final String apiUrl = "https://127.0.0.1:8000/display_shares?paid=${globals.PAiD}";

  final String jwtToken = globals.jwtToken;
  Map<String, String> headers = {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $jwtToken',
  };

  final client = HttpClient();
  client.badCertificateCallback =
      (X509Certificate cert, String host, int port) => true;

  final uri = Uri.parse(apiUrl);
  final request = await client.getUrl(uri);

  headers.forEach((key, value) {
    request.headers.set(key, value);
  });

  final response = await request.close();
  final responseBody = await utf8.decodeStream(response);
  print(responseBody.runtimeType);
  print(responseBody);

  // Parse the response body as JSON array
  final List<dynamic> responseList = json.decode(responseBody);

  // Extract emails from the response and add them to sharedUsers
  setState(() {
    sharedUsers.addAll(responseList.map((email) => email.toString()));
    sharedUsers_temp.addAll(responseList.map((email) => email.toString()));
    isLoading = false;
  });
}
    



Future<bool> share_db_update(String email) async {
  final String apiUrl =
      "https://127.0.0.1:8000/share_db?email=${email}&pa_id=${globals.PAiD}";

  final String jwtToken = globals.jwtToken;
  Map<String, String> headers = {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $jwtToken',
  };

  final client = HttpClient();
  client.badCertificateCallback =
      (X509Certificate cert, String host, int port) => true;

  final uri = Uri.parse(apiUrl);
  final request = await client.getUrl(uri);

  headers.forEach((key, value) {
    request.headers.set(key, value);
  });

  final response = await request.close();
  final responseBody = await utf8.decodeStream(response);

  print(responseBody);

  if (responseBody == 'false') {
    // Show error dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text('The person is not currently registered in the app.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );

    return false; // Return false when unsuccessful
  }

  return true; // Return true otherwise
}




Future<void> deleteShare_db_update(email) async {
  final String apiUrl = "https://127.0.0.1:8000/delte_share?email=${email}&pa_id=${globals.PAiD}";

  final String jwtToken = globals.jwtToken;
  Map<String, String> headers = {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $jwtToken',
  };

  final client = HttpClient();
  client.badCertificateCallback =
      (X509Certificate cert, String host, int port) => true;

  final uri = Uri.parse(apiUrl);
  final request = await client.getUrl(uri);

  headers.forEach((key, value) {
    request.headers.set(key, value);
  });

  final response = await request.close();
  final responseBody = await utf8.decodeStream(response);
  print(responseBody.runtimeType);
  print(responseBody);
}





  void add_share() {
    print('asdasdas');
    showDialog(
      context: context,
      builder: (context) {
        final emailController = TextEditingController();
        return AlertDialog(
          title: Text("Add Share"),
          content: TextField(
            controller: emailController,
            decoration: InputDecoration(hintText: "Enter email address"),
          ),
          actions: [
            TextButton(
              child: Text("Cancel"),
              onPressed: () => Navigator.of(context).pop(),
            ),
            ElevatedButton(
              child: Text("Share"),
              onPressed: () {
                if (emailController.text.isNotEmpty) {
                  print(emailController.text);
                  print('asdasdas');
                  var x=share_db_update(emailController.text);
                  print(x);
                  print('X IS ^^^^^');
                  if (x!=false){
                  setState(() {
                    sharedUsers.add(emailController.text);
                  });
                  Navigator.of(context).pop(); }
                  // Close dialog
                }
              },
            ),
          ],
        );
      },
    );
  }
 void delete_shares(user) {
    deleteShare_db_update(user);
    setState(() {
      sharedUsers.remove(user);

    });
  }


  Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: Text("Shared With"),
    ),
    body: isLoading
        ? Center(child: CircularProgressIndicator()) // Show loading indicator
        : Column( 
            children: [
              Expanded( // Make ListView take available space
                child: ListView.builder(
                  itemCount: sharedUsers.length,
                  itemBuilder: (context, index) {
                    final user = sharedUsers[index];
                    return Dismissible(
                      key: UniqueKey(),
                      direction: DismissDirection.endToStart,
                      background: Container(
                        color: Colors.red,
                        child: Icon(
                          Icons.delete,
                          color: Colors.white,
                        ),
                      ), 
                      onDismissed: (direction) {
                        delete_shares(user);
                        setState(() {
                          sharedUsers.remove(user);
                        });
                      },
                      child: ListTile(
                        title: Text(user),
                      ),
                    );
                  },
                ),
              ),
              Padding(padding: EdgeInsetsDirectional.only(bottom: 70), child:
              ElevatedButton( // The "Continue" button
                child: Text("Continue"),                
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MainTripPage()),
                  );
                },
              ),),
            ],
          ),
    floatingActionButton: FloatingActionButton(
      onPressed: add_share, // Simplified call
      child: Icon(Icons.share),
    ),
  );
}}






class MainTripPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Main Trip'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            
            
            
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ManageTripPage()),
                );
              },
              child: Text('Manage Trip'),
            ),
            SizedBox(height: 20),
            
            
            
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SharedListPage()),
                );
              },
              child: Text('Share Trip'),
            ),
            SizedBox(height: 20),
            
            
            
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => TodoList()),
                );
              },
              child: Text('View Itinerary'),
            ),

          Padding(
            padding: EdgeInsets.only(top:120),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => home_dashboard()),
                    );
                  },
                  child: Text('GO TO DASHBOARD'),
                ),
                SizedBox(height: 50),
              ],
            ),
          ),




          ],
        ),
      ),
    );
  }
}



class ManageTripPage extends StatelessWidget {
  Future<void> delete() async {
  final String apiUrl = "https://127.0.0.1:8000/delete_trip?pa_id=${globals.PAiD}";

  final String jwtToken = globals.jwtToken;
  Map<String, String> headers = {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $jwtToken',
  };

  final client = HttpClient();
  client.badCertificateCallback =
      (X509Certificate cert, String host, int port) => true;

  final uri = Uri.parse(apiUrl);
  final request = await client.getUrl(uri);

  headers.forEach((key, value) {
    request.headers.set(key, value);
  });

  final response = await request.close();
  final responseBody = await utf8.decodeStream(response);
  print(responseBody.runtimeType);
  print(responseBody);
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Manage Trip'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Manage Trip Page',
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Delete Trip?'),
                      content: Text('Are you sure you want to delete this trip?'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop(); // Close the dialog
                          },
                          child: Text('CANCEL'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            delete();



                            // Add code here to handle trip deletion
                            Navigator.of(context).pop(); // Close the dialog
                            // Navigate back to home_dashboard() after deleting trip
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (context) => home_dashboard()),
                            );
                          },
                          child: Text('DELETE'),
                        ),
                      ],
                    );
                  },
                );
              },
              child: Container(
                width: 200,
                height: 100,
                alignment: Alignment.center,
                child: Text(
                  'DELETE TRIP',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red, // Background color of button
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30), // Rounded corners
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


