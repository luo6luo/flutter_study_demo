import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class HttpTest extends StatefulWidget {
  const HttpTest({super.key});

  @override
  State<HttpTest> createState() => _HttpTestState();
}

class _HttpTestState extends State<HttpTest> {
  late final Dio _dio;
  final _path = 'https://pub.dev';

  @override
  void initState() {
    super.initState();

    _dio = Dio(
      BaseOptions(
        baseUrl: _path,
        connectTimeout: const Duration(seconds: 5),
        sendTimeout: const Duration(seconds: 5),
        receiveTimeout: const Duration(seconds: 5),
        extra: {'test': 111},
        validateStatus: (status) => status == 200,
      ),
    );

    /// 拦截器
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          debugPrint('请求之前');
          return handler.next(options);
        },
        onResponse: (response, handler) {
          debugPrint('响应之前');
          return handler.next(response);
        },
        onError: (DioException e, handler) {
          debugPrint('错误之前');
          return handler.next(e);
        },
      ),
    );

    _dio.httpClientAdapter = IOHttpClientAdapter(
      createHttpClient: () {
        /// 设置代理
        final client = HttpClient();
        client.findProxy = (uri) => 'localhost:8888';
        return client;
      },

      /// 校验证书
      validateCertificate: (cert, host, port) => true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('HttpTest')),
      body: Center(
        child: Column(
          children: [
            ElevatedButton(onPressed: _get, child: const Text('GET')),
            ElevatedButton(onPressed: _post, child: const Text('POST')),
            ElevatedButton(onPressed: _download, child: const Text('DOWNLOAD')),
            ElevatedButton(onPressed: _upload, child: const Text('UPLOAD')),
          ],
        ),
      ),
    );
  }

  /// get请求
  void _get() async {
    // final params = {'name': '张三', 'age': '18'};
    final response = await _dio.get(
      _path,
      // queryParameters: params,
      options: Options(
        responseType: ResponseType.json,
        extra: {'test': 222},
      ),
    );

    /// 注意: response.extra 和 response.requestOptions.extra 是不同的对象
    /// 此处 response.requestOptions.extra 有值
    debugPrint(response.data);
  }

  /// post请求
  void _post() async {
    final params = {'name': '张三', 'age': '18'};
    final response = await _dio.post(
      _path,
      data: params,
    );
    debugPrint(response.toString());
  }

  /// 下载
  void _download() async {
    final savePath =
        '${(await getApplicationDocumentsDirectory()).path}flutter.svg';
    final response = await _dio.download(
      _path,
      savePath,
      onReceiveProgress: (received, total) {
        if (total <= 0) return;
        debugPrint(
            'percentage: ${(received / total * 100).toStringAsFixed(1)}%');
      },
    );
    debugPrint(response.toString());
  }

  void _upload() async {
    final formData = FormData.fromMap({
      'name': 'upload',
      'date': DateTime.now().toIso8601String(),
      'file': await MultipartFile.fromFile('path'),
    });
    final response = await _dio.post(
      _path,
      data: formData,
      onSendProgress: (sent, total) {
        if (total <= 0) return;
        debugPrint('percentage: ${(sent / total * 100).toStringAsFixed(1)}%');
      },
    );
  }
}
