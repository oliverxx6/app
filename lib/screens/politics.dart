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
Condiciones de Uso
- QUIQLIQ es una plataforma que conecta entre clientes, profesionales para ofrecer servicios con un proceso fácil, seguro y formal.  
- Solo pueden acceder usuarios registrados y miembros verificados mediante un proceso de filtro y recomendación.  
- Las transacciones y comunicaciones deben realizarse exclusivamente dentro de la plataforma para garantizar seguridad y protección de pagos.  
- Los profesionales deberán pagar una comisión del 10% por tarea finalizada.  
- El pago se libera al profesional solo después de la confirmación de la entrega o trabajo completado por el cliente.  
- Está prohibido operar fuera de la plataforma; hacerlo puede generar bloqueo de cuenta y riesgos de fraude.  

Políticas de Seguridad y Privacidad  
- Todos los miembros pasan filtros rigurosos de verificación para asegurar un entorno confiable.  
- La plataforma protege la información personal, no mostrando datos sensibles como dirección, número de cuenta o tarjeta.  
- Se usan procesos de verificación en dos pasos vía email y Whatsapp para proteger contra cuentas falsas y spams.  
- Todo el historial de comunicaciones y transacciones queda registrado para posibles auditorías y resolución de conflictos.  
- Se promueve la comunicación en espacios seguros y públicos cuando sea necesario la interacción presencial.  

Protección de Pagos  
- Los pagos se retienen en garantía hasta la confirmación de la entrega satisfactoria por parte del cliente.  
- Si se detecta  el incumplimiento de las labores para las que fue contratado el profesional, el cliente tiene derecho a reembolso completo.  
- Se aceptan diversos métodos de pago, incluyendo transferencias bancarias y tarjetas.  

Comportamiento y Normas  
- Se exige un trato respetuoso y prohibición de agresiones, insultos o acoso.  
- Cualquier violación de normas puede derivar en advertencias y bloqueo de cuenta.  
- La plataforma no tolera acciones que pongan en riesgo la confianza, como cancelaciones reiteradas o creación de cuentas falsas.  

Soporte y Resolución de Conflictos  
- QUIQLIQ actúa como mediador en desacuerdos entre clientes y profesionales.  
- Hay disponibilidad de atención al cliente para resolver incidencias con prioridad.  
- La plataforma tiene mecanismos de reporte ante solicitudes de pagos o entregas fuera de la plataforma para proteger usuarios.  

Requisitos para usuarios  
- Ser mayor de edad.  
- Enviar identificación y planilla de servicios básicos.  
- Aprobar el filtro para seguridad de todos en la comunidad.  

Este resumen refleja las medidas principales para mantener un ambiente seguro, confiable y transparente en la plataforma QUIQLIQ, protegiendo tanto a clientes como a profesionales en todas las fases de contratación, prestación de servicio y pago.
La inscripción en la aplicación móvil tiene una mínima inversión de USD 10.00 
Este aporte se destina exclusivamente a financiar las verificaciones del filtro de seguridad, las cuales son fundamentales para garantizar un entorno seguro y confiable para todos los usuarios. Al realizar esta inversión, usted contribuye directamente a mantener la integridad y protección dentro de la plataforma.

Para cualquier duda o sugerencia puede escribirnos a los siguientes correos electrónicos: soporte@quiqliq.com, soluciones@quiqliq.com, info@quiqliq.com.

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
                  textAlign: TextAlign.center,
                  "Condiciones y Políticas de Uso y Privacidad de QUIQLIQ",
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
              ),
              SizedBox(height: 10),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  politics,
                  style: TextStyle(fontSize: 18, color: Colors.white),
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
