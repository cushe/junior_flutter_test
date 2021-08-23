import 'dart:async';

import 'package:junior_test/model/RootResponse.dart';

import 'mall_api_provider.dart';

class Repository {
  final mallApiProvider = MallApiProvider();

  Future<RootResponse> fetchActionInfo(int id) =>
      mallApiProvider.fetchActionInfo(id);

  Future<RootResponse> fetchActionsList(int page, int count) =>
      mallApiProvider.fetchActionsList(page, count);
}
