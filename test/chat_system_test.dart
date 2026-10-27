import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:projetmascara/core/config/app_config.dart';
import 'package:projetmascara/core/data/hive_config.dart';
import 'package:projetmascara/core/services/hive_message_repository.dart';
import 'package:projetmascara/features/messaging/models/message_model.dart';
import 'package:projetmascara/core/services/chat_repository.dart';
import 'package:projetmascara/features/professional/models/chat_message.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  final Map<String, String> mockSecureStorage = {};
  late Directory tempDir;

  setUpAll(() async {
    AppConfig.init(env: Environment.dev);
    tempDir = await Directory.systemTemp.createTemp('hive_chat_test');

    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
          const MethodChannel('plugins.flutter.io/path_provider'),
          (MethodCall methodCall) async {
            if (methodCall.method == 'getApplicationDocumentsDirectory') {
              return tempDir.path;
            }
            return null;
          },
        );

    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
          const MethodChannel('plugins.it_nomads.com/flutter_secure_storage'),
          (MethodCall methodCall) async {
            if (methodCall.method == 'write') {
              final Map<dynamic, dynamic> args = methodCall.arguments;
              mockSecureStorage[args['key']] = args['value'];
              return null;
            } else if (methodCall.method == 'read') {
              final Map<dynamic, dynamic> args = methodCall.arguments;
              return mockSecureStorage[args['key']];
            } else if (methodCall.method == 'delete') {
              final Map<dynamic, dynamic> args = methodCall.arguments;
              mockSecureStorage.remove(args['key']);
              return null;
            } else if (methodCall.method == 'deleteAll') {
              mockSecureStorage.clear();
              return null;
            }
            return null;
          },
        );

    await HiveConfig.init();
  });

  tearDownAll(() async {
    await Hive.close();
    if (await tempDir.exists()) {
      await tempDir.delete(recursive: true);
    }
  });

  group(
    'Client-Psychologist Message System (MessageModel & HiveMessageRepository)',
    () {
      test(
        'Should send and retrieve messages in chronological order',
        () async {
          final repository = HiveMessageRepository();

          final msg1 = MessageModel(
            id: 1,
            fromUserId: 'client_1',
            toUserId: 'psy_1',
            content: 'Bonjour Docteur',
            createdAt: DateTime.now().subtract(const Duration(minutes: 5)),
          );

          final msg2 = MessageModel(
            id: 2,
            fromUserId: 'psy_1',
            toUserId: 'client_1',
            content: 'Bonjour, comment puis-je vous aider ?',
            createdAt: DateTime.now(),
          );

          await repository.sendMessage(msg1);
          await repository.sendMessage(msg2);

          final conversation = await repository.getConversation(
            'client_1',
            'psy_1',
          );
          expect(conversation.length, equals(2));
          expect(conversation[0].content, equals('Bonjour Docteur'));
          expect(
            conversation[1].content,
            equals('Bonjour, comment puis-je vous aider ?'),
          );
        },
      );
    },
  );

  group('Professional Chat Repository (ChatMessage & ChatRepository)', () {
    test(
      'Should verify if ChatRepository can handle ChatMessage serialization',
      () async {
        final repository = ChatRepository();
        final msg = ChatMessage(
          id: 'msg_uuid_1',
          senderId: 'client_1',
          receiverId: 'psy_1',
          content: 'Test message',
          timestamp: DateTime.now(),
        );

        // We expect this to either succeed or throw a Hive exception if ChatMessage has no adapter
        try {
          await repository.sendMessage(msg);
          print(
            'SUCCESS: ChatRepository successfully serialized and saved ChatMessage',
          );
        } catch (e) {
          print('CRITICAL FAILURE: ChatRepository failed with: $e');
          rethrow;
        }
      },
    );
  });
}
