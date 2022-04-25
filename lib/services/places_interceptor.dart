import 'package:dio/dio.dart';


class PlacesInterceptor extends Interceptor {

  final accessToken = 'pk.eyJ1IjoiYmFjYWxsYXYiLCJhIjoiY2wyOGY4aGV0MDhwdTNlbnpxNHhlb3BjMSJ9.vDCBFXfWcc-8Nwz-P0x4Mw';

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.queryParameters.addAll({
      'languaje'    : 'es',
      'access_token': accessToken,
    });
    super.onRequest(options, handler);
  }
}