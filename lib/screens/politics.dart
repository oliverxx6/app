import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:quicklick/services/auth.dart';
import 'package:quicklick/services/preferences.dart';

class Politics extends StatefulWidget {
  const Politics({super.key});

  @override
  State<Politics> createState() => _PoliticsState();
}

class _PoliticsState extends State<Politics> {
  final String politics = """
  1. Introducción
Al utilizar nuestra aplicación (en adelante, "QUIQLIQ"), usted acepta los siguientes Términos y Condiciones de Uso y nuestra Política de Privacidad. Estos documentos rigen su acceso y uso de los servicios proporcionados. Si no está de acuerdo con los términos, no podrá utilizar la App.

2. Requisitos de edad
Al registrarse y utilizar la App, usted declara que es mayor de 18 años. Nos reservamos el derecho de eliminar o bloquear el acceso de cualquier usuario que proporcione información falsa sobre su edad.

3. Recopilación y uso de datos personales
Al utilizar la App, usted acepta proporcionar ciertos datos personales, que incluyen pero no se limitan a:

Fotografías que usted decida subir a la App.

Información relacionada con su perfil de usuario.

Estos datos serán utilizados exclusivamente para los fines establecidos en esta política, como mejorar su experiencia en la App y permitir interacciones entre usuarios.

4. Uso de su imagen
Al subir fotos a la App, usted otorga a QUIQLIQ una licencia no exclusiva, libre de regalías, transferible y sublicenciable para usar, reproducir, distribuir, y mostrar públicamente dicho contenido dentro de los fines permitidos por la App. Usted declara ser el titular de los derechos de las imágenes compartidos y libera a QUIQLIQ de cualquier responsabilidad derivada de su uso.

5. Propiedad intelectual
Todos los contenidos de la App, excluyendo los proporcionados por los usuarios, son propiedad de Quicklick y están protegidos por las leyes de propiedad intelectual de Ecuador.

6. Responsabilidad del usuario
El usuario es el único responsable del contenido que suba a la App. Usted declara que:

Tiene el derecho de compartir las fotos subidas.

No subirá contenido que infrinja derechos de terceros, sea ofensivo o viole las leyes locales.

7. Protección de datos personales
Cumplimos con las leyes ecuatorianas de protección de datos personales. Sus datos serán tratados de manera confidencial y no serán compartidos con terceros sin su consentimiento, salvo obligación legal.

8. Aceptación de términos
Al crear una cuenta o utilizar la App, usted acepta estos Términos y Condiciones y declara haber leído y comprendido nuestra Política de Privacidad.

9. Cambios en las políticas
Nos reservamos el derecho de modificar estas políticas en cualquier momento. Notificaremos cualquier cambio a través de la App. Su uso continuado constituirá aceptación de las modificaciones.

10. Mensaualidad impaga
En el caso que usted como miembro de la app debera realizar un pago mensaual por el importe de establecido en dólares americanos incluido IVA, el no realizar el pago de manera puntual tendra como consecuencia el que su cuenta sea borrada de la plataforma y el uso de la app móvil sera bloqueado.

11. Contacto
Si tiene dudas o inquietudes acerca de estas políticas, puede ponerse en contacto con nosotros al correo quiqliq@hotmail.com.
""";

  Future<void> verification(BuildContext context) async {
    try {
      bool verificado = await AuthService.signInWithGoogle();
      if (verificado) {
        await Preferences.deletePreferences();
        await PreferencesRegister.deletePreferences();

        String email = AuthService.email;
        String uid = AuthService.uid;

        await Preferences.setEmail(email);
        await PreferencesRegister.setOk(uid);

        if (context.mounted) {
          Navigator.pushNamedAndRemoveUntil(
            context,
            "personalInfo",
            (Route<dynamic> route) => false,
          );
        }
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("No se pudo autenticar. Inténtalo de nuevo."),
            ),
          );
        }
      }
    } on FirebaseAuthException catch (e) {
      if (context.mounted) {
        Navigator.pushNamed(context, "/");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.message ?? "Upss...algosalio mal")),
        );
      }
    } catch (e) {
      if (context.mounted) {
        Navigator.pushNamed(context, "/");
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(e.toString())));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Color.fromARGB(221, 29, 29, 29),
        automaticallyImplyLeading: false,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        centerTitle: true,
        title: Text(
          "Políticas de Uso y Privacidad",
          style: TextStyle(fontSize: 25, color: Colors.white),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Center(
                child: Text(
                  "Politicas de uso y privacidad",
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  politics,
                  style: TextStyle(fontSize: 15, color: Colors.white),
                ),
              ),
              OutlinedButton(
                onPressed: () async {
                  await verification(context);
                },
                child: Text(
                  "Acepta términos de uso",
                  style: TextStyle(fontSize: 20),
                ),
              ),
              SizedBox(height: 5),
              OutlinedButton(
                onPressed: () {
                  SystemNavigator.pop();
                },
                child: Text(
                  "No acepto",
                  style: TextStyle(fontSize: 20, color: Colors.red),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
