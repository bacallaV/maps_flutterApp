import 'package:dio/dio.dart';


class TrafficInterceptor extends Interceptor {

  final accessToken = 'pk.eyJ1IjoiYmFjYWxsYXYiLCJhIjoiY2wyOGY4aGV0MDhwdTNlbnpxNHhlb3BjMSJ9.vDCBFXfWcc-8Nwz-P0x4Mw';
  
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.queryParameters.addAll({
      'alternatives': true,
      'geometries'  : 'polyline6',
      'overview'    : 'simplified',
      'steps'       : false,
      'access_token': accessToken
    });
    super.onRequest(options, handler);
  }
}