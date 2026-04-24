// Automatic FlutterFlow imports
import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart';
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';

Future<String> uploadAudioToCloudinary(String? audioPath) async {
  const cloudName = 'dw2emfset';
  const uploadPreset = 'voice_preset'; // ✅ موحّد مع api_calls.dart

  if (audioPath == null || audioPath.isEmpty) {
    print('uploadAudioToCloudinary: audioPath is null or empty');
    return '';
  }

  try {
    final file = File(audioPath);
    if (!await file.exists()) {
      print('uploadAudioToCloudinary: file not found at $audioPath');
      return '';
    }

    final audioBytes = await file.readAsBytes();
    final url =
        Uri.parse('https://api.cloudinary.com/v1_1/$cloudName/video/upload');

    final request = http.MultipartRequest('POST', url)
      ..fields['upload_preset'] = uploadPreset
      ..files.add(http.MultipartFile.fromBytes(
        'file',
        audioBytes,
        filename: 'audio_${DateTime.now().millisecondsSinceEpoch}.m4a',
      ));

    final streamedResponse = await request.send();
    final responseData = await streamedResponse.stream.bytesToString();

    if (streamedResponse.statusCode != 200) {
      print(
          'uploadAudioToCloudinary: HTTP ${streamedResponse.statusCode} — $responseData');
      return '';
    }

    final jsonData = jsonDecode(responseData);
    final secureUrl = jsonData['secure_url'] as String? ?? '';
    print('uploadAudioToCloudinary: ✅ uploaded → $secureUrl');
    return secureUrl;
  } catch (e) {
    print('uploadAudioToCloudinary: ❌ error — $e');
    return '';
  }
}
