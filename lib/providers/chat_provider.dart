import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import '../services/storage_service.dart';

enum MessageType { user, ai }

class ChatMessage {
  final String text;
  final MessageType type;
  ChatMessage({required this.text, required this.type});
}

class ChatProvider extends ChangeNotifier {
  final List<ChatMessage> _messages = [];
  bool _isLoading = false;
  String? _error;

  List<ChatMessage> get messages => _messages;
  bool get isLoading => _isLoading;
  String? get error => _error;

  ChatSession? _chatSession;

  void addMessage(String text, MessageType type) {
    _messages.add(ChatMessage(text: text, type: type));
    notifyListeners();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }

  Future<void> sendMessage(String text) async {
    if (!StorageService.isApiKeySet()) {
      _error = "Please enter your API Key in the sidebar first.";
      notifyListeners();
      return;
    }

    addMessage(text, MessageType.user);
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final apiKey = StorageService.getApiKey()!;
      final model = GenerativeModel(model: 'gemini-pro', apiKey: apiKey);

      if (_chatSession == null) {
        _chatSession = model.startChat();
      }

      final response = await _chatSession!.sendMessage(Content.text(text));
      final reply = response.text ?? "Sorry, no response generated.";
      
      addMessage(reply, MessageType.ai);
    } catch (e) {
      _error = "Network Error: ${e.toString()}";
      addMessage("Error: Could not fetch response. Check API Key or Internet.", MessageType.ai);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> triggerMasterPrompt() async {
    if (!StorageService.isApiKeySet()) {
      _error = "Please enter your API Key in the sidebar first.";
      notifyListeners();
      return;
    }

    final masterPrompt = StorageService.getMasterPrompt();
    if (masterPrompt == null || masterPrompt.isEmpty) {
      _error = "Master Prompt is empty. Please set it in settings.";
      notifyListeners();
      return;
    }

    await sendMessage(masterPrompt);
  }
}
