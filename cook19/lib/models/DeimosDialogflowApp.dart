import 'package:flutter/material.dart';
import 'package:dialog_flowtter/dialog_flowtter.dart';

class DeimosDialogflowApp extends StatelessWidget {
  

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Help cook 19',
      theme: ThemeData(
        primarySwatch: Colors.red,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      // Se encarga de que no salga el banner de "Debug" en la app
      debugShowCheckedModeBanner: false,
          home: DeimosAppHome(), 
      
    );
  }
}

class DeimosAppHome extends StatefulWidget {
  @override
  _DeimosAppHomeState createState() => _DeimosAppHomeState();
}

class _DeimosAppHomeState extends State<DeimosAppHome> {

  final TextEditingController _controller = TextEditingController();

  // Creamos una instancia de DialogFlowtter en nuestra clase
  final DialogFlowtter _dialogFlowtter = DialogFlowtter();
  List<Map<String, dynamic>> messages = [];

  void sendMessage(String text) async  {
    
    // Verifica que el texto del usuario no esté vacío
    // si lo está, termina de ejecutar la función
    if (text.isEmpty) return;
    
    /// Añade nuestro texto enviado por el usuario en forma de 
    /// Message a nuestra lista y actualiza el estado del widget
    setState(() {
       Message userMessage = Message(text: DialogText(text: [text]));
      
      /// Cambiamos el viejo método por el nuevo
      /// Le indicamos a la función que el mensaje es de un usuario
      addMessage(userMessage, true);
    });

     /// Creamos la query que le enviaremos al agente
    /// a partir del texto del usuario
    QueryInput query = QueryInput(text: TextInput(text: text));

    // Esperamos a que el agente nos responda
    /// El keyword await indica a la función que espere a que detectIntent
    /// termine de ejecutarse para después continuar con lo que resta de la función
    DetectIntentResponse res = await _dialogFlowtter.detectIntent(
      queryInput: query,
    );
    
    /// Si el mensaje de la respuesta es nulo, no continuamos con la ejecución
    /// de la función
    if (res.message == null) return;

    /// Si hay un mensaje de respuesta, lo agregamos a la lista y actualizamos
    /// el estado de la app
    setState(() {

      /// el mensaje es del usuario
      addMessage(res.message);
    });
  }

  /// La función recibe un mensaje de tipo [Message].
  /// El segundo parámetro entre corchetes quiere decir que ese parámetro 
  /// es opcional y que si no se le pasa a la función, será falso
  void addMessage(Message message, [bool isUserMessage = false]) {
    messages.add({
      'message': message,
      'isUserMessage': isUserMessage,
    });
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Help cook 19')),
      body: Column(
        children: [
          /// Esta parte se asegura que la caja de texto se posicione hasta abajo de la pantalla
          /// // Cambiamos el container anterior por nuestro componente
        /// MessagesList y le pasamos la lista de mensajes
          Expanded(child: _MessagesList(messages: messages), 
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5,),
            color: Colors.white10,
            child: Row(
              children: [
                /// El Widget Expanded se asegura que el campo de texto ocupe
                /// toda la pantalla menos el ancho del IconButton
                Expanded(
                  child: TextField(style: TextStyle(color: Colors.black26),
                  controller: _controller, 
                  ),
                ),
                IconButton( 
                  color: Colors.black,
                  icon: Icon(Icons.send),
                  onPressed: () {
                    /// Mandamos a llamar la función 
                    sendMessage(_controller.text);
    
                    /// Limpiamos nuestro campo de texto 
                    _controller.clear();
                    },
                ),
              ],
            ), // Fin de la fila
          ), // Fin del contenedor
        ],
      ), // Fin de la columna
    );
  }

}

 /// Le agregamos el _ al principio del nombre para 
/// indicar que esta es una clase privada que sólo se 
/// usará dentro de este archivo
class _MessagesList extends StatelessWidget {
  /// El componente recibirá una lista de mensajes
  final List<Map<String, dynamic>>  messages;

  const _MessagesList({
    Key key,
    
    /// Le indicamos al componente que la lista estará vacía en
    /// caso de que no se le pase como argumento alguna otra lista
    this.messages = const [],
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    /// Regresaremos una ListView con el constructor separated
    /// para que después de cada elemento agregue un espacio
    return ListView.separated(
      /// Indicamos el número de items que tendrá
      itemCount: messages.length,
      
      // Agregamos espaciado
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
      
      /// Indicamos que agregue un espacio entre cada elemento
      separatorBuilder: (_, i) => const SizedBox(height: 10),
      itemBuilder: (context, i) {
        var obj = messages[messages.length - 1 - i];
        return _MessageContainer(
          /// Obtenemos el texto del mensaje y lo mostramos en un widget ext
          message: obj['message'],
          /// Diferenciamos si es un mensaje o una respuesta
          isUserMessage: obj['isUserMessage'],
        );
      },
        reverse: true,
    );
  }
}
class _MessageContainer extends StatelessWidget {
  final Message message;
  final bool isUserMessage;

  const _MessageContainer({
    Key key,
    
    /// Indicamos que siempre se debe mandar un mensaje
    @required this.message,
    this.isUserMessage = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      /// Cambia el lugar del mensaje
      mainAxisAlignment:
          isUserMessage ? MainAxisAlignment.end : MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          /// Limita nuestro contenedor a un ancho máximo de 250
          constraints: BoxConstraints(maxWidth: 250),
          child: Container(
            decoration: BoxDecoration(
              /// Cambia el color del contenedor del mensaje
              color: isUserMessage ? Colors.blue : Colors.orange,
              
              /// Le agrega border redondeados
              borderRadius: BorderRadius.circular(20),
            ),
            
            /// Espaciado
            padding: const EdgeInsets.all(10),
            child: Text(
              /// Obtenemos el texto del mensaje y lo pintamos. 
              /// Si es nulo, enviamos un string vacío.
              message?.text?.text[0] ?? '',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }
}