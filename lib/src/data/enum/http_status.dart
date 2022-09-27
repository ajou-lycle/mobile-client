enum HttpStatusEnum {
  Continue(100, "진행 중입니다."),
  SwitchingProtocol(101, "프로토콜 변경 중입니다."),
  Processing(102, "아직 처리 중입니다."),
  Ok(200, "요청이 완료되었습니다."),
  Created(201, "생성이 완료되었습니다."),
  Accepted(202, "요청을 수신했습니다."),
  BadRequest(400, "요청이 잘못되었습니다."),
  Unauthorized(401, "권한이 없습니다."),
  Forbidden(403, "접근이 금지되었습니다."),
  NotFound(404, "리소스를 찾을 수 없습니다."),
  RequestTimeout(408, "시간제한을 초과하였습니다."),
  PayloadTooLarge(413, "요청이 너무 큽니다."),
  UnsupportedMediaType(415, "지원하지 않는 포맷입니다."),
  TooManyRequests(429, "요청을 너무 많이 보냈습니다."),
  RequestHeaderFieldsTooLarge(431, "요청의 헤더가 너무 큽니다."),
  InternalServerError(500, "서버에 문제가 발생했습니다."),
  NotImplemented(501, "지원하지 않는 기능입니다."),
  BadGateway(502, "잘못된 응답입니다."),
  ServiceUnavailable(503, "서비스를 사용할 수 없습니다."),
  GatewayTimeout(504, "서버가 시간제한을 초과하였습니다."),
  NetworkAuthenticationRequired(511, "네트워크 권한이 필요합니다."),
  Unknown(-1, "알 수 없는 오류입니다.");

  final int code;
  final String message;

  const HttpStatusEnum(this.code, this.message);

  factory HttpStatusEnum.getByCode(int code) =>
      HttpStatusEnum.values.firstWhere((value) => value.code == code,
          orElse: () => HttpStatusEnum.Unknown);
}
