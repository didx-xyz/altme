import 'package:altme/app/app.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'profile.g.dart';

@JsonSerializable()
class ProfileModel extends Equatable {
  const ProfileModel({
    required this.firstName,
    required this.lastName,
    required this.phone,
    required this.location,
    required this.email,
    required this.polygonIdNetwork,
    required this.didKeyType,
    required this.isEnterprise,
    required this.isBiometricEnabled,
    required this.userConsentForIssuerAccess,
    required this.userConsentForVerifierAccess,
    required this.userPINCodeForAuthentication,
    required this.enableJWKThumbprint,
    required this.enableCryptographicHolderBinding,
    required this.enableScopeParameter,
    required this.useBasicClientAuthentication,
    this.companyName = '',
    this.companyWebsite = '',
    this.jobTitle = '',
    required this.enableSecurity,
    required this.isDeveloperMode,
    required this.enable4DigitPINCode,
    required this.clientId,
    required this.clientSecret,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) =>
      _$ProfileModelFromJson(json);

  factory ProfileModel.empty() => ProfileModel(
        firstName: '',
        lastName: '',
        phone: '',
        location: '',
        email: '',
        companyName: '',
        companyWebsite: '',
        jobTitle: '',
        polygonIdNetwork: PolygonIdNetwork.PolygonMainnet.toString(),
        isEnterprise: false,
        isBiometricEnabled: false,
        userConsentForIssuerAccess: true,
        userConsentForVerifierAccess: true,
        userPINCodeForAuthentication: true,
        didKeyType: DidKeyType.ebsiv3.toString(),
        enableSecurity: false,
        isDeveloperMode: false,
        enable4DigitPINCode: false,
        enableJWKThumbprint: false,
        enableCryptographicHolderBinding: true,
        enableScopeParameter: false,
        useBasicClientAuthentication: false,
        clientId: Parameters.clientId,
        clientSecret: Parameters.clientSecret,
      );

  final String firstName;
  final String lastName;
  final String phone;
  final String location;
  final String email;
  final String companyName;
  final String companyWebsite;
  final String jobTitle;
  final String polygonIdNetwork;
  final String didKeyType;
  final bool isEnterprise;
  final bool isBiometricEnabled;
  final bool userConsentForIssuerAccess;
  final bool userConsentForVerifierAccess;
  final bool userPINCodeForAuthentication;

  final bool enableSecurity;
  final bool isDeveloperMode;
  final bool enable4DigitPINCode;
  final bool enableJWKThumbprint;
  final bool enableCryptographicHolderBinding;
  final bool enableScopeParameter;
  final bool useBasicClientAuthentication;
  final String clientId;
  final String clientSecret;

  @override
  List<Object> get props => [
        firstName,
        lastName,
        phone,
        location,
        email,
        polygonIdNetwork,
        didKeyType,
        companyName,
        companyWebsite,
        jobTitle,
        isEnterprise,
        isBiometricEnabled,
        userConsentForIssuerAccess,
        userConsentForVerifierAccess,
        userPINCodeForAuthentication,
        enableSecurity,
        isDeveloperMode,
        enable4DigitPINCode,
        enableJWKThumbprint,
        enableCryptographicHolderBinding,
        enableScopeParameter,
        useBasicClientAuthentication,
        clientId,
        clientSecret,
      ];

  Map<String, dynamic> toJson() => _$ProfileModelToJson(this);

  ProfileModel copyWith({
    String? firstName,
    String? lastName,
    String? phone,
    String? location,
    String? email,
    String? companyName,
    String? companyWebsite,
    String? jobTitle,
    String? polygonIdNetwork,
    TezosNetwork? tezosNetwork,
    String? didKeyType,
    bool? isEnterprise,
    bool? isBiometricEnabled,
    bool? userConsentForIssuerAccess,
    bool? userConsentForVerifierAccess,
    bool? userPINCodeForAuthentication,
    bool? enableSecurity,
    bool? isDeveloperMode,
    bool? enable4DigitPINCode,
    bool? enableJWKThumbprint,
    bool? enableCryptographicHolderBinding,
    bool? enableScopeParameter,
    bool? useBasicClientAuthentication,
    String? clientId,
    String? clientSecret,
  }) {
    return ProfileModel(
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      phone: phone ?? this.phone,
      location: location ?? this.location,
      email: email ?? this.email,
      companyName: companyName ?? this.companyName,
      companyWebsite: companyWebsite ?? this.companyWebsite,
      jobTitle: jobTitle ?? this.jobTitle,
      polygonIdNetwork: polygonIdNetwork ?? this.polygonIdNetwork,
      didKeyType: didKeyType ?? this.didKeyType,
      isEnterprise: isEnterprise ?? this.isEnterprise,
      isBiometricEnabled: isBiometricEnabled ?? this.isBiometricEnabled,
      enableJWKThumbprint: enableJWKThumbprint ?? this.enableJWKThumbprint,
      enableCryptographicHolderBinding: enableCryptographicHolderBinding ??
          this.enableCryptographicHolderBinding,
      enableScopeParameter: enableScopeParameter ?? this.enableScopeParameter,
      useBasicClientAuthentication:
          useBasicClientAuthentication ?? this.useBasicClientAuthentication,
      clientId: clientId ?? this.clientId,
      clientSecret: clientSecret ?? this.clientSecret,
      userConsentForIssuerAccess:
          userConsentForIssuerAccess ?? this.userConsentForIssuerAccess,
      userConsentForVerifierAccess:
          userConsentForVerifierAccess ?? this.userConsentForVerifierAccess,
      userPINCodeForAuthentication:
          userPINCodeForAuthentication ?? this.userPINCodeForAuthentication,
      enableSecurity: enableSecurity ?? this.enableSecurity,
      isDeveloperMode: isDeveloperMode ?? this.isDeveloperMode,
      enable4DigitPINCode: enable4DigitPINCode ?? this.enable4DigitPINCode,
    );
  }
}
