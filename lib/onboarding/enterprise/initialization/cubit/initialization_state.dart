part of 'initialization_cubit.dart';

@JsonSerializable()
class EnterpriseInitializationState extends Equatable {
  const EnterpriseInitializationState({
    this.status = AppStatus.init,
    this.message,
    this.isEmailFormatCorrect = false,
    this.isPasswordFormatCorrect = false,
    this.obscurePassword = true,
    this.walletProviderType = WalletProviderType.Talao,
  });

  factory EnterpriseInitializationState.fromJson(Map<String, dynamic> json) =>
      _$EnterpriseInitializationStateFromJson(json);

  final AppStatus status;
  final StateMessage? message;
  final bool isEmailFormatCorrect;
  final bool isPasswordFormatCorrect;
  final bool obscurePassword;
  final WalletProviderType walletProviderType;

  EnterpriseInitializationState loading() {
    return copyWith(
      status: AppStatus.loading,
      message: null,
    );
  }

  EnterpriseInitializationState error({required StateMessage message}) {
    return copyWith(
      status: AppStatus.error,
      message: message,
    );
  }

  EnterpriseInitializationState copyWith({
    required StateMessage? message,
    AppStatus? status,
    bool? isEmailFormatCorrect,
    bool? isPasswordFormatCorrect,
    bool? obscurePassword,
    WalletProviderType? walletProviderType,
  }) {
    return EnterpriseInitializationState(
      status: status ?? this.status,
      message: message,
      isEmailFormatCorrect: isEmailFormatCorrect ?? this.isEmailFormatCorrect,
      isPasswordFormatCorrect:
          isPasswordFormatCorrect ?? this.isPasswordFormatCorrect,
      obscurePassword: obscurePassword ?? this.obscurePassword,
      walletProviderType: walletProviderType ?? this.walletProviderType,
    );
  }

  Map<String, dynamic> toJson() => _$EnterpriseInitializationStateToJson(this);

  @override
  List<Object?> get props => [
        status,
        message,
        isEmailFormatCorrect,
        isPasswordFormatCorrect,
        obscurePassword,
        walletProviderType,
      ];
}
