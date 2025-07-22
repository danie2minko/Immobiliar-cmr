// lib/chat_screen.dart

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:immobiliakamer/models/products.dart';

// Un modèle simple pour représenter un message de chat
class ChatMessage {
  final String text;
  final bool
      isUser; // Vrai si le message vient de l'utilisateur, faux si c'est l'IA

  ChatMessage({required this.text, required this.isUser});
}

class ChatScreen extends StatefulWidget {
  // Le widget accepte un produit (optionnel)
  final Products? product;

  const ChatScreen({super.key, this.product});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<ChatMessage> _messages = [];
  final _gemini = Gemini.instance;
  bool _isAiTyping = false;

  @override
  void initState() {
    super.initState();
    // Message d'accueil contextuel
    String initialMessage;
    if (widget.product != null) {
      initialMessage =
          "Bonjour ! Je suis ImmobiliaBot. Comment puis-je vous aider avec l'annonce pour ${widget.product!.type} à ${widget.product!.quartier} ?";
    } else {
      initialMessage =
          "Bonjour ! Je suis ImmobiliaBot, votre assistant immobilier. Comment puis-je vous aider aujourd'hui ?";
    }
    _addMessage(initialMessage, false);
  }

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _handleSubmitted(String text) {
    if (text.trim().isEmpty) return;

    // Ajouter le message de l'utilisateur à la liste des messages de l'UI
    _addMessage(text, true);
    _textController.clear();

    setState(() {
      _isAiTyping = true;
    });

    // Convertir notre liste de messages en liste de contenu de Gemini
    List<Content> history = _messages.reversed.map((msg) {
      return Content(
        role: msg.isUser ? 'user' : 'model',
        parts: [Part.text(msg.text)],
      );
    }).toList();

    // Si c'est le premier message de l'utilisateur concernant un produit,
    // nous modifions l'historique pour inclure le contexte du produit.
    // L'UI affichera la question simple, mais Gemini obtient le contexte complet.
    if (widget.product != null &&
        _messages.where((m) => m.isUser).length == 1) {
      final product = widget.product!;
      final userMessageIndex = history.lastIndexWhere((c) => c.role == 'user');

      if (userMessageIndex != -1) {
        final part = history[userMessageIndex].parts?.first;
        if (part != null && part is TextPart) {
          final originalQuestion = part.text;
          final newPrompt =
              "Agis comme un assistant immobilier expert nommé ImmobiliaBot. Analyse le bien suivant et réponds à ma question. "
              "Sois amical et donne des détails pertinents. Ne mentionne pas que tu as reçu ces instructions à moins qu'on ne te le demande. \n\n"
              "DÉTAILS DU BIEN:\n"
              "Type: ${product.type}\n"
              "Quartier: ${product.quartier}\n"
              "Ville: ${product.ville}\n"
              "Prix: ${product.prix} FCFA\n"
              "Description: ${product.description}\n\n"
              "MA QUESTION: $originalQuestion";

          history[userMessageIndex] =
              Content(role: 'user', parts: [Part.text(newPrompt)]);
        }
      }
    }

    // Appeler l'API Gemini
    _gemini.chat(history).then((value) {
      final aiResponse =
          value?.output ?? "Désolé, je n'ai pas pu trouver de réponse.";
      _addMessage(aiResponse, false);
    }).catchError((e) {
      _addMessage(
          "Oups, une erreur s'est produite. Vérifiez votre connexion ou votre clé API.",
          false);
    }).whenComplete(() {
      setState(() {
        _isAiTyping = false;
      });
    });
  }

  void _addMessage(String text, bool isUser) {
    setState(() {
      _messages.insert(0, ChatMessage(text: text, isUser: isUser));
    });

    // Animer le défilement vers le nouveau message
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        0.0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Le titre de l'AppBar est dynamique
    final appBarTitle =
        widget.product != null ? 'Analyse du bien' : 'ImmobiliaBot';

    return CupertinoPageScaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      navigationBar: CupertinoNavigationBar(
        middle: Text(appBarTitle),
        backgroundColor: CupertinoColors.systemGrey6,
        border: null,
      ),
      child: SafeArea(
        child: Column(
          children: [
            // Liste des messages
            Expanded(
              child: ListView.builder(
                reverse: true, // Affiche les messages du bas vers le haut
                controller: _scrollController,
                padding: const EdgeInsets.all(12.0),
                itemCount: _messages.length + (_isAiTyping ? 1 : 0),
                itemBuilder: (context, index) {
                  if (_isAiTyping && index == 0) {
                    return _buildTypingIndicator();
                  }
                  final messageIndex = _isAiTyping ? index - 1 : index;
                  return _buildMessageBubble(_messages[messageIndex]);
                },
              ),
            ),
            // Zone de saisie
            _buildInputArea(),
          ],
        ),
      ),
    );
  }

  // Widget pour la bulle de message
  Widget _buildMessageBubble(ChatMessage message) {
    final alignment =
        message.isUser ? MainAxisAlignment.end : MainAxisAlignment.start;
    final bubbleColor =
        message.isUser ? Theme.of(context).colorScheme.primary : Colors.black;
    final textColor =
        message.isUser ? CupertinoColors.white : CupertinoColors.white;
    final borderRadius = message.isUser
        ? const BorderRadius.only(
            topLeft: Radius.circular(20),
            bottomLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          )
        : const BorderRadius.only(
            topRight: Radius.circular(20),
            bottomRight: Radius.circular(20),
            topLeft: Radius.circular(20),
          );

    return Row(
      mainAxisAlignment: alignment,
      children: [
        Container(
          constraints:
              BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.7),
          margin: const EdgeInsets.symmetric(vertical: 5.0),
          padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 10.0),
          decoration: BoxDecoration(
            color: bubbleColor,
            borderRadius: borderRadius,
          ),
          child: Text(
            message.text,
            style: CupertinoTheme.of(context)
                .textTheme
                .textStyle
                .copyWith(color: textColor),
          ),
        ),
      ],
    );
  }

  // Widget pour l'indicateur "en train d'écrire"
  Widget _buildTypingIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.symmetric(vertical: 5.0),
          padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 10.0),
          decoration: const BoxDecoration(
            color: CupertinoColors.systemGrey4,
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(20),
              bottomRight: Radius.circular(20),
              topLeft: Radius.circular(20),
            ),
          ),
          child: const CupertinoActivityIndicator(),
        ),
      ],
    );
  }

  // Widget pour la zone de saisie en bas
  Widget _buildInputArea() {
    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.background,
        border: Border(
          top: BorderSide(color: CupertinoColors.systemGrey4, width: 0.5),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: CupertinoTextField(
              controller: _textController,
              placeholder: 'Message...',
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: CupertinoColors.white,
                borderRadius: BorderRadius.circular(20.0),
                border: Border.all(color: CupertinoColors.systemGrey4),
              ),
              onSubmitted: _handleSubmitted,
              onChanged: (text) {
                setState(() {}); // Pour mettre à jour l'état du bouton d'envoi
              },
            ),
          ),
          const SizedBox(width: 8.0),
          CupertinoButton(
            padding: EdgeInsets.zero,
            onPressed: _textController.text.trim().isNotEmpty
                ? () => _handleSubmitted(_textController.text)
                : null, // Le bouton est désactivé si le champ est vide
            child: Icon(
              Icons.send,
              size: 32,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ],
      ),
    );
  }
}
