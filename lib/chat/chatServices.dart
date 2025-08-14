import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:immobiliakamer/models/message.dart';

class ChatServices {
  // Récupérer la liste des conversations de l'utilisateur
  Stream<QuerySnapshot> getUserConversations(String userId) {
    return _firestore
        .collection('chat_rooms')
        .where('participants', arrayContains: userId)
        .orderBy('lastMessageTime', descending: true)
        .snapshots();
  }

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  //userstream

  /*
  
  List<Map<String,dynamic> =

  []
  {
    'email':noiruzinoir@gmail.com,
    'id':..
    
  },
   {
    'email':germann@gmail.com,
    'id':..
    
  },
  ]
  */
  Stream<List<Map<String, dynamic>>> getUsersStream() {
    return _firestore.collection('Users').snapshots().map((snapshots) {
      return snapshots.docs.map((doc) {
        final user = doc.data();
        return user;
      }).toList();
    });
  }

  // Envoyer un message
  Future<void> sendMessage(String receiverId, String message) async {
    // Récupérer les informations de l'utilisateur actuel
    final String currentUserId = _auth.currentUser!.uid;
    final String? currentUserEmail = _auth.currentUser!.email;
    final Timestamp timestamp = Timestamp.now();

    // Créer le nouveau message
    Message newMessage = Message(
      senderId: currentUserId,
      senderEmail: currentUserEmail ?? '', // Gérer le cas où l'email est null
      receiverId: receiverId,
      message: message,
      timestamp: timestamp,
    );

    // Construire l'ID de la salle de chat pour assurer l'unicité
    List<String> ids = [currentUserId, receiverId];
    ids.sort(); // Trier les IDs pour que la salle de chat soit la même pour les deux utilisateurs
    String chatRoomId = ids.join('_');

    // Ajouter le nouveau message à la base de données
    await _firestore
        .collection('chat_rooms')
        .doc(chatRoomId)
        .collection('messages')
        .add(newMessage.toMap());

    // Mettre à jour les métadonnées de la salle de chat
    await _firestore.collection('chat_rooms').doc(chatRoomId).update({
      'lastMessage': message,
      'lastMessageTime': timestamp,
    });
  }

  // Récupérer les messages
  Stream<QuerySnapshot> getMessages(String userId, String otherUserId) {
    // Construire l'ID de la salle de chat
    List<String> ids = [userId, otherUserId];
    ids.sort();
    String chatRoomId = ids.join('_');

    return _firestore
        .collection('chat_rooms')
        .doc(chatRoomId)
        .collection('messages')
        .orderBy('timestamp', descending: false)
        .snapshots();
  }
}
