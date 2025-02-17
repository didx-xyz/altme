part of 'qr_code_scan_cubit.dart';

@JsonSerializable()
class QRCodeScanState extends Equatable {
  const QRCodeScanState({
    this.status = QrScanStatus.init,
    this.uri,
    this.route,
    this.isScan = false,
    this.message,
  });

  factory QRCodeScanState.fromJson(Map<String, dynamic> json) =>
      _$QRCodeScanStateFromJson(json);

  final QrScanStatus status;
  final Uri? uri;
  @JsonKey(includeFromJson: false, includeToJson: false)
  final Route<dynamic>? route;
  final bool isScan;

  final StateMessage? message;

  Map<String, dynamic> toJson() => _$QRCodeScanStateToJson(this);

  QRCodeScanState loading({bool? isScan}) {
    return QRCodeScanState(
      status: QrScanStatus.loading,
      isScan: isScan ?? this.isScan,
      uri: uri,
    );
  }

  QRCodeScanState acceptHost() {
    return QRCodeScanState(
      status: QrScanStatus.acceptHost,
      isScan: isScan,
      uri: uri,
    );
  }

  QRCodeScanState error({required StateMessage message}) {
    return QRCodeScanState(
      status: QrScanStatus.error,
      message: message,
      isScan: isScan,
      uri: uri,
    );
  }

  QRCodeScanState copyWith({
    QrScanStatus qrScanStatus = QrScanStatus.idle,
    StateMessage? message,
    Route<dynamic>? route,
    Uri? uri,
    bool? isScan,
  }) {
    return QRCodeScanState(
      status: qrScanStatus,
      message: message,
      isScan: isScan ?? this.isScan,
      uri: uri ?? this.uri,
      route: route, // route should be cleared when one route is done
    );
  }

  @override
  List<Object?> get props => [status, uri, route, isScan, message];
}
