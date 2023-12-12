import 'package:altme/app/app.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:oidc4vc/oidc4vc.dart';

part 'profile_setting.g.dart';

@JsonSerializable()
class ProfileSetting extends Equatable {
  const ProfileSetting({
    required this.blockchainOptions,
    required this.generalOptions,
    required this.helpCenterOptions,
    required this.selfSovereignIdentityOptions,
    required this.settingsMenu,
    required this.version,
    required this.walletSecurityOptions,
  });

  factory ProfileSetting.fromJson(Map<String, dynamic> json) =>
      _$ProfileSettingFromJson(json);

  factory ProfileSetting.initial() => ProfileSetting(
        blockchainOptions: BlockchainOptions.initial(),
        generalOptions: GeneralOptions.empty(),
        helpCenterOptions: HelpCenterOptions.initial(),
        selfSovereignIdentityOptions: SelfSovereignIdentityOptions.initial(),
        settingsMenu: SettingsMenu.initial(),
        version: '',
        walletSecurityOptions: WalletSecurityOptions.initial(),
      );

  final BlockchainOptions? blockchainOptions;
  final GeneralOptions generalOptions;
  final HelpCenterOptions helpCenterOptions;
  final SelfSovereignIdentityOptions selfSovereignIdentityOptions;
  final SettingsMenu settingsMenu;
  final String version;
  final WalletSecurityOptions walletSecurityOptions;

  Map<String, dynamic> toJson() => _$ProfileSettingToJson(this);

  @override
  List<Object?> get props => [
        blockchainOptions,
        generalOptions,
        helpCenterOptions,
        selfSovereignIdentityOptions,
        settingsMenu,
        version,
        walletSecurityOptions,
      ];
}

@JsonSerializable()
class BlockchainOptions extends Equatable {
  const BlockchainOptions({
    required this.bnbSupport,
    required this.ethereumSupport,
    required this.fantomSupport,
    required this.hederaSupport,
    required this.infuraRpcNode,
    required this.polygonSupport,
    required this.tezosSupport,
    required this.tzproRpcNode,
    this.tzproApiKey,
    this.infuraApiKey,
  });

  factory BlockchainOptions.fromJson(Map<String, dynamic> json) =>
      _$BlockchainOptionsFromJson(json);

  factory BlockchainOptions.initial() => const BlockchainOptions(
        bnbSupport: true,
        ethereumSupport: true,
        fantomSupport: true,
        hederaSupport: true,
        infuraRpcNode: false,
        polygonSupport: true,
        tezosSupport: true,
        tzproRpcNode: false,
      );

  final bool bnbSupport;
  final bool ethereumSupport;
  final bool fantomSupport;
  final bool hederaSupport;
  final String? infuraApiKey;
  final bool infuraRpcNode;
  final bool polygonSupport;
  final bool tezosSupport;
  final String? tzproApiKey;
  final bool tzproRpcNode;

  Map<String, dynamic> toJson() => _$BlockchainOptionsToJson(this);

  @override
  List<Object?> get props => [
        bnbSupport,
        ethereumSupport,
        fantomSupport,
        hederaSupport,
        infuraApiKey,
        infuraRpcNode,
        polygonSupport,
        tezosSupport,
        tzproApiKey,
        tzproRpcNode,
      ];
}

@JsonSerializable()
class GeneralOptions extends Equatable {
  const GeneralOptions({
    required this.walletType,
    required this.companyName,
    required this.companyWebsite,
    required this.companyLogo,
    required this.tagLine,
    required this.profileName,
    required this.profileVersion,
    required this.published,
    required this.profileId,
    required this.customerPlan,
  });

  factory GeneralOptions.fromJson(Map<String, dynamic> json) =>
      _$GeneralOptionsFromJson(json);

  factory GeneralOptions.empty() => GeneralOptions(
        walletType: WalletAppType.altme,
        companyName: 'Altme',
        companyWebsite: 'https://altme.io',
        companyLogo: 'https://talao.co/static/img/icon.png',
        tagLine: '',
        profileName: '',
        profileVersion: '',
        published: DateTime.now(),
        profileId: '',
        customerPlan: '',
      );

  final WalletAppType walletType;
  final String companyName;
  final String companyWebsite;
  final String companyLogo;
  final String tagLine;
  final String profileName;
  final String profileVersion;
  final DateTime published;
  final String profileId;
  final String customerPlan;

  Map<String, dynamic> toJson() => _$GeneralOptionsToJson(this);

  @override
  List<Object?> get props => [
        walletType,
        companyName,
        companyWebsite,
        companyLogo,
        tagLine,
        profileName,
        profileVersion,
        published,
        profileId,
        customerPlan,
      ];
}

@JsonSerializable()
class HelpCenterOptions extends Equatable {
  const HelpCenterOptions({
    required this.customChatSupport,
    this.customChatSupportName,
    this.customEmail,
    required this.customEmailSupport,
    required this.displayChatSupport,
    required this.displayEmailSupport,
  });

  factory HelpCenterOptions.fromJson(Map<String, dynamic> json) =>
      _$HelpCenterOptionsFromJson(json);

  factory HelpCenterOptions.initial() => const HelpCenterOptions(
        customChatSupport: false,
        customEmailSupport: false,
        displayChatSupport: true,
        displayEmailSupport: true,
      );

  final bool customChatSupport;
  final String? customChatSupportName;
  final String? customEmail;
  final bool customEmailSupport;
  final bool displayChatSupport;
  final bool displayEmailSupport;

  Map<String, dynamic> toJson() => _$HelpCenterOptionsToJson(this);

  @override
  List<Object?> get props => [
        customChatSupport,
        customChatSupportName,
        customEmail,
        customEmailSupport,
        displayChatSupport,
        displayEmailSupport,
      ];
}

@JsonSerializable()
class SelfSovereignIdentityOptions extends Equatable {
  const SelfSovereignIdentityOptions({
    required this.customOidc4VcProfile,
    required this.displayManageDecentralizedId,
    required this.displaySsiAdvancedSettings,
    required this.displayVerifiableDataRegistry,
    required this.oidv4VcProfile,
  });

  factory SelfSovereignIdentityOptions.fromJson(Map<String, dynamic> json) =>
      _$SelfSovereignIdentityOptionsFromJson(json);

  factory SelfSovereignIdentityOptions.initial() =>
      SelfSovereignIdentityOptions(
        customOidc4VcProfile: CustomOidc4VcProfile.initial(),
        displayManageDecentralizedId: true,
        displaySsiAdvancedSettings: true,
        displayVerifiableDataRegistry: true,
        oidv4VcProfile: 'custom',
      );

  final CustomOidc4VcProfile customOidc4VcProfile;
  final bool displayManageDecentralizedId;
  final bool displaySsiAdvancedSettings;
  final bool displayVerifiableDataRegistry;
  final String oidv4VcProfile;

  Map<String, dynamic> toJson() => _$SelfSovereignIdentityOptionsToJson(this);

  @override
  List<Object?> get props => [
        customOidc4VcProfile,
        displayManageDecentralizedId,
        displaySsiAdvancedSettings,
        displayVerifiableDataRegistry,
        oidv4VcProfile,
      ];
}

@JsonSerializable()
class CustomOidc4VcProfile extends Equatable {
  const CustomOidc4VcProfile({
    required this.clientAuthentication,
    required this.credentialManifestSupport,
    required this.cryptoHolderBinding,
    required this.defaultDid,
    required this.oidc4VciDraft,
    required this.oidc4VpDraft,
    required this.scope,
    required this.securityLevel,
    required this.siopv2Draft,
    required this.subjectSyntaxeType,
    required this.userPinDigits,
    this.clientId,
    this.clientSecret,
  });

  factory CustomOidc4VcProfile.fromJson(Map<String, dynamic> json) =>
      _$CustomOidc4VcProfileFromJson(json);

  factory CustomOidc4VcProfile.initial() => const CustomOidc4VcProfile(
        clientAuthentication: ClientAuthentication.none,
        credentialManifestSupport: true,
        cryptoHolderBinding: true,
        defaultDid: DidKeyType.p256,
        oidc4VciDraft: OIDC4VCIDraftType.draft11,
        oidc4VpDraft: OIDC4VPDraftType.draft18,
        scope: false,
        securityLevel: SecurityLevel.low,
        siopv2Draft: SIOPV2DraftType.draft12,
        subjectSyntaxeType: SubjectSyntax.did,
        userPinDigits: UserPinDigits.six,
      );

  final ClientAuthentication clientAuthentication;
  final bool credentialManifestSupport;
  @JsonKey(name: 'client_id')
  final String? clientId;
  @JsonKey(name: 'client_secret')
  final String? clientSecret;
  final bool cryptoHolderBinding;
  final DidKeyType defaultDid;
  final OIDC4VCIDraftType oidc4VciDraft;
  final OIDC4VPDraftType oidc4VpDraft;
  final bool scope;
  final SecurityLevel securityLevel;
  final SIOPV2DraftType siopv2Draft;
  final SubjectSyntax subjectSyntaxeType;
  final UserPinDigits userPinDigits;

  Map<String, dynamic> toJson() => _$CustomOidc4VcProfileToJson(this);

  @override
  List<Object?> get props => [
        clientAuthentication,
        credentialManifestSupport,
        clientId,
        clientSecret,
        cryptoHolderBinding,
        defaultDid,
        oidc4VciDraft,
        oidc4VpDraft,
        scope,
        securityLevel,
        siopv2Draft,
        subjectSyntaxeType,
        userPinDigits,
      ];
}

@JsonSerializable()
class SettingsMenu extends Equatable {
  const SettingsMenu({
    required this.displayDeveloperMode,
    required this.displayHelpCenter,
    required this.displayProfile,
  });

  factory SettingsMenu.fromJson(Map<String, dynamic> json) =>
      _$SettingsMenuFromJson(json);

  factory SettingsMenu.initial() => const SettingsMenu(
        displayDeveloperMode: true,
        displayHelpCenter: true,
        displayProfile: true,
      );

  final bool displayDeveloperMode;
  final bool displayHelpCenter;
  final bool displayProfile;

  Map<String, dynamic> toJson() => _$SettingsMenuToJson(this);

  @override
  List<Object?> get props => [
        displayDeveloperMode,
        displayHelpCenter,
        displayProfile,
      ];
}

@JsonSerializable()
class WalletSecurityOptions extends Equatable {
  const WalletSecurityOptions({
    required this.confirmSecurityVerifierAccess,
    required this.displaySecurityAdvancedSettings,
    required this.secureSecurityAuthenticationWithPinCode,
    required this.verifySecurityIssuerWebsiteIdentity,
  });

  factory WalletSecurityOptions.fromJson(Map<String, dynamic> json) =>
      _$WalletSecurityOptionsFromJson(json);

  factory WalletSecurityOptions.initial() => const WalletSecurityOptions(
        confirmSecurityVerifierAccess: false,
        displaySecurityAdvancedSettings: true,
        secureSecurityAuthenticationWithPinCode: false,
        verifySecurityIssuerWebsiteIdentity: false,
      );

  final bool confirmSecurityVerifierAccess;
  final bool displaySecurityAdvancedSettings;
  final bool secureSecurityAuthenticationWithPinCode;
  final bool verifySecurityIssuerWebsiteIdentity;

  Map<String, dynamic> toJson() => _$WalletSecurityOptionsToJson(this);

  @override
  List<Object?> get props => [
        confirmSecurityVerifierAccess,
        displaySecurityAdvancedSettings,
        secureSecurityAuthenticationWithPinCode,
        verifySecurityIssuerWebsiteIdentity,
      ];
}
