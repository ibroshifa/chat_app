import 'package:chat_app/models/user_model.dart';
import 'package:chat_app/models/message_model.dart' as ms;
import 'package:chat_app/widgets/time_counter.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_sound/flutter_sound.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:uuid/uuid.dart';
import '../cubits/chat_cubit.dart';
import '../cubits/chat_state.dart' as ch;
import '../repositories/chat_repository.dart';
import 'package:image_picker/image_picker.dart';
import 'package:voice_message_package/voice_message_package.dart';
import 'dart:io';

class ChatScreen extends StatefulWidget {
  final User user;
  final User receiver;

  ChatScreen({required this.user, required this.receiver});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late FlutterSoundRecorder _recorder = FlutterSoundRecorder();
  bool _isRecording = false;
  String _filePath = '';

  @override
  void dispose() {
    _recorder.closeRecorder();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          ChatCubit(currentUser: widget.user, chatRepository: ChatRepository())
            ..loadMessages(),
      child: Scaffold(
        appBar: AppBar(title: Text('${widget.receiver.name}')),
        body: Column(
          children: [
            Expanded(
              child: BlocBuilder<ChatCubit, ch.ChatState>(
                builder: (context, state) {
                  if (state is ch.ChatLoaded) {
                    state.messages.sort((b, a) =>
                        a.message.createdAt
                            ?.compareTo(b.message.createdAt ?? 0) ??
                        0);
                    final messages = state.messages
                        .where((e) =>
                            (e.user.id == widget.receiver.id &&
                                e.message.author.id == widget.user.id) ||
                            (e.user.id == widget.user.id &&
                                e.message.author.id == widget.receiver.id))
                        .map((m) => m.message)
                        .toList();
                    return Stack(
                      children: [
                        Chat(
                          listBottomWidget: Icon(
                            Icons.delete,
                            color: Colors.white,
                          ),
                          audioMessageBuilder: (types.AudioMessage audioMessage,
                              {required int messageWidth}) {
                            final isMine =
                                audioMessage.author.id == widget.user.id;
                            return VoiceMessageView(
                              // backgroundColor:
                              //     isMine ? Colors.blue : Colors.grey,
                              controller: VoiceController(
                                audioSrc: audioMessage.uri,
                                maxDuration: audioMessage.duration,
                                onComplete: () {},
                                onPause: () {},
                                onPlaying: () {},
                                isFile: false,
                              ),
                            );
                          },
                          messages: messages,
                          onSendPressed: (types.PartialText partialText) {
                            context
                                .read<ChatCubit>()
                                .sendMessage(ms.MessageModel(
                                  message: types.TextMessage(
                                      id: Uuid().v4(),
                                      author: types.User(
                                          id: widget.user.id,
                                          firstName: widget.user.name),
                                      createdAt:
                                          DateTime.now().millisecondsSinceEpoch,
                                      text: partialText.text,
                                      type: types.MessageType.text),
                                  user: widget.receiver,
                                ));
                          },
                          onAttachmentPressed: () =>
                              _handleImageSelection(context),
                          user: types.User(id: widget.user.id),
                        ),
                        Positioned(
                          bottom: 10,
                          right: 10,
                          child: IconButton(
                            color: Colors.white,
                            icon: Icon(_isRecording ? Icons.stop : Icons.mic),
                            onPressed: () async {
                              if (_isRecording) {
                                await stopRecording();
                                final audioUrl =
                                    await uploadAudio(File(_filePath));
                                if (audioUrl != null) {
                                  final duration = Duration.zero;
                                  sendAudioMessage(audioUrl,
                                      duration.inMilliseconds, context);
                                }
                              } else {
                                await requestPermissions();
                                await startRecording();
                              }
                            },
                          ),
                        ),
                        !_isRecording
                            ? SizedBox()
                            : Positioned(
                                bottom: 0,
                                child: Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.93,
                                  height: 60,
                                  margin: EdgeInsets.symmetric(horizontal: 15),
                                  color: Color(0xff1d1c21),
                                  child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        TextButton(
                                          child: Text(
                                            'cancel',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 14),
                                          ),
                                          onPressed: () async {
                                            await stopRecording();
                                            _isRecording = false;
                                          },
                                        ),
                                        TimeCounter(),
                                        IconButton(
                                          color: Colors.white,
                                          icon: Icon(Icons.send),
                                          onPressed: () async {
                                            await stopRecording();
                                            final audioUrl = await uploadAudio(
                                                File(_filePath));
                                            if (audioUrl != null) {
                                              final duration = Duration.zero;
                                              sendAudioMessage(
                                                  audioUrl,
                                                  duration.inMilliseconds,
                                                  context);
                                            }
                                          },
                                        ),
                                      ]),
                                ))
                      ],
                    );
                  }
                  return Center(child: CircularProgressIndicator());
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleImageSelection(BuildContext context) async {
    final result = await ImagePicker().pickImage(
      imageQuality: 70,
      maxWidth: 1440,
      source: ImageSource.gallery,
    );

    if (result != null) {
      context.read<ChatCubit>().sendImage(result, widget.receiver);
    }
  }

  Future<void> requestPermissions() async {
    await Permission.microphone.request();
    await Permission.storage.request();
  }

  Future<void> startRecording() async {
    Directory tempDir = await getTemporaryDirectory();
    _filePath =
        '${tempDir.path}/audio_${DateTime.now().millisecondsSinceEpoch}.aac';
    _recorder.openRecorder();
    await _recorder.startRecorder(toFile: _filePath);
    setState(() {
      _isRecording = true;
    });
  }

  Future<void> stopRecording() async {
    await _recorder.stopRecorder();
    setState(() {
      _isRecording = false;
    });
  }

  Future<String?> uploadAudio(File file) async {
    try {
      final ref =
          FirebaseStorage.instance.ref().child('chat_audio').child(Uuid().v4());
      await ref.putFile(file);
      return await ref.getDownloadURL();
    } catch (e) {
      print('Error: $e');
      return null;
    }
  }

  void sendAudioMessage(String audioUrl, int duration, BuildContext contx) {
    final message = types.AudioMessage(
        author: types.User(id: widget.user.id, firstName: widget.user.name),
        createdAt: DateTime.now().millisecondsSinceEpoch,
        id: Uuid().v4(),
        uri: audioUrl,
        duration: Duration(seconds: 10),
        name: '',
        size: 100);

    setState(() {
      contx.read<ChatCubit>().sendMessage(
          ms.MessageModel(message: message, user: widget.receiver));
    });
  }
}
