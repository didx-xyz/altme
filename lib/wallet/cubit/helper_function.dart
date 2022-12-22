part of 'wallet_cubit.dart';

///helper function to generate Tezos/Ethereum AssociatedAddressCredential
Future<CredentialModel?> generateAssociatedWalletCredential({
  required String accountName,
  required String walletAddress,
  required String ssiKey,
  required DIDKitProvider didKitProvider,
  required DIDCubit didCubit,
  String? oldId,
  required BlockchainType blockchainType,
}) async {
  final log = getLogger('WalletCubit - generateAssociatedWalletCredential');
  log.i(blockchainType);
  try {
    const didMethod = AltMeStrings.defaultDIDMethod;
    final didSsi = didCubit.state.did!;
    final issuer = didKitProvider.keyToDID(didMethod, ssiKey);

    final verificationMethod =
        await didKitProvider.keyToVerificationMethod(didMethod, ssiKey);

    final options = {
      'proofPurpose': 'assertionMethod',
      'verificationMethod': verificationMethod
    };

    final verifyOptions = {'proofPurpose': 'assertionMethod'};
    final id = 'urn:uuid:${const Uuid().v4()}';
    final formatter = DateFormat('yyyy-MM-ddTHH:mm:ss');
    final issuanceDate = '${formatter.format(DateTime.now())}Z';

    late dynamic associatedAddressCredential;

    switch (blockchainType) {
      case BlockchainType.tezos:
        associatedAddressCredential = TezosAssociatedAddressCredential(
          id: id,
          issuer: issuer,
          issuanceDate: issuanceDate,
          credentialSubjectModel: TezosAssociatedAddressModel(
            id: didSsi,
            accountName: accountName,
            associatedAddress: walletAddress,
          ),
        );
        break;
      case BlockchainType.ethereum:
        associatedAddressCredential = EthereumAssociatedAddressCredential(
          id: id,
          issuer: issuer,
          issuanceDate: issuanceDate,
          credentialSubjectModel: EthereumAssociatedAddressModel(
            id: didSsi,
            accountName: accountName,
            associatedAddress: walletAddress,
          ),
        );
        break;
      case BlockchainType.fantom:
        associatedAddressCredential = FantomAssociatedAddressCredential(
          id: id,
          issuer: issuer,
          issuanceDate: issuanceDate,
          credentialSubjectModel: FantomAssociatedAddressModel(
            id: didSsi,
            accountName: accountName,
            associatedAddress: walletAddress,
          ),
        );
        break;
      case BlockchainType.polygon:
        associatedAddressCredential = PolygonAssociatedAddressCredential(
          id: id,
          issuer: issuer,
          issuanceDate: issuanceDate,
          credentialSubjectModel: PolygonAssociatedAddressModel(
            id: didSsi,
            accountName: accountName,
            associatedAddress: walletAddress,
          ),
        );
        break;
      case BlockchainType.binance:
        associatedAddressCredential = BinanceAssociatedAddressCredential(
          id: id,
          issuer: issuer,
          issuanceDate: issuanceDate,
          credentialSubjectModel: BinanceAssociatedAddressModel(
            id: didSsi,
            accountName: accountName,
            associatedAddress: walletAddress,
          ),
        );
        break;
    }

    final String vc = await didKitProvider.issueCredential(
      jsonEncode(associatedAddressCredential.toJson()),
      jsonEncode(options),
      ssiKey,
    );

    final result =
        await didKitProvider.verifyCredential(vc, jsonEncode(verifyOptions));
    final jsonVerification = jsonDecode(result) as Map<String, dynamic>;

    if ((jsonVerification['warnings'] as List<dynamic>).isNotEmpty) {
      log.w(
        'credential verification return warnings',
        jsonVerification['warnings'],
      );
    }

    final credentialManifest = blockchainType.credentialManifest;

    if ((jsonVerification['errors'] as List<dynamic>).isNotEmpty) {
      log.e('failed to verify credential, ${jsonVerification['errors']}');
      if (jsonVerification['errors'][0] != 'No applicable proof') {
        throw ResponseMessage(
          ResponseString
              .RESPONSE_STRING_FAILED_TO_VERIFY_SELF_ISSUED_CREDENTIAL,
        );
      } else {
        return _createCredential(vc, oldId, credentialManifest);
      }
    } else {
      return _createCredential(vc, oldId, credentialManifest);
    }
  } catch (e, s) {
    log.e('something went wrong e: $e, stackTrace: $s', e, s);
    return null;
  }
}

Future<CredentialModel> _createCredential(
  String vc,
  String? oldId,
  CredentialManifest credentialManifest,
) async {
  final jsonCredential = jsonDecode(vc) as Map<String, dynamic>;
  final id = oldId ?? 'urn:uuid:${const Uuid().v4()}';
  return CredentialModel(
    id: id,
    image: 'image',
    data: jsonCredential,
    display: Display.emptyDisplay()..toJson(),
    shareLink: '',
    credentialPreview: Credential.fromJson(jsonCredential),
    credentialManifest: credentialManifest,
    activities: [Activity(acquisitionAt: DateTime.now())],
  );
}

Future<CredentialModel?> generateDeviceInfoCredential({
  required String ssiKey,
  required DIDKitProvider didKitProvider,
  required DIDCubit didCubit,
  String? oldId,
}) async {
  final log = getLogger('WalletCubit - generateDeviceInfoCredential');
  try {
    const didMethod = AltMeStrings.defaultDIDMethod;
    final didSsi = didCubit.state.did!;
    final did = didKitProvider.keyToDID(didMethod, ssiKey);

    final verificationMethod =
        await didKitProvider.keyToVerificationMethod(didMethod, ssiKey);

    final options = {
      'proofPurpose': 'assertionMethod',
      'verificationMethod': verificationMethod
    };
    final verifyOptions = {'proofPurpose': 'assertionMethod'};
    final id = 'urn:uuid:${const Uuid().v4()}';
    final formatter = DateFormat('yyyy-MM-ddTHH:mm:ss');
    final issuanceDate = '${formatter.format(DateTime.now())}Z';

    final credentialManifest = CredentialManifest.fromJson(
      ConstantsJson.deviceInfoCredentialManifestJson,
    );

    late String device;
    late String systemName;
    late String systemVersion;

    if (isAndroid()) {
      final androidDeviceInfo = await DeviceInfoPlugin().androidInfo;
      device = androidDeviceInfo.model;
      systemName = 'android';
      systemVersion = androidDeviceInfo.version.codename;
    } else {
      final iosDeviceInfo = await DeviceInfoPlugin().iosInfo;
      device = iosDeviceInfo.utsname.machine ?? '';
      systemName = 'iOS';
      systemVersion = iosDeviceInfo.systemVersion ?? '';
    }

    final deviceInfoModel = DeviceInfoModel(
      id: didSsi,
      systemName: systemName,
      device: device,
      systemVersion: systemVersion,
      type: 'DeviceInfo',
    );

    final deviceInfoCredential = DeviceInfoCredential(
      id: id,
      issuer: did,
      issuanceDate: issuanceDate,
      credentialSubjectModel: deviceInfoModel,
    );

    log.i('deviceInfoCredential: ${deviceInfoCredential.toJson()}');

    final vc = await didKitProvider.issueCredential(
      jsonEncode(deviceInfoCredential.toJson()),
      jsonEncode(options),
      ssiKey,
    );

    final result =
        await didKitProvider.verifyCredential(vc, jsonEncode(verifyOptions));
    final jsonVerification = jsonDecode(result) as Map<String, dynamic>;

    if ((jsonVerification['warnings'] as List<dynamic>).isNotEmpty) {
      log.w(
        'credential verification return warnings',
        jsonVerification['warnings'],
      );
    }

    if ((jsonVerification['errors'] as List<dynamic>).isNotEmpty) {
      log.e('failed to verify credential, ${jsonVerification['errors']}');
      if (jsonVerification['errors'][0] != 'No applicable proof') {
        throw ResponseMessage(
          ResponseString
              .RESPONSE_STRING_FAILED_TO_VERIFY_SELF_ISSUED_CREDENTIAL,
        );
      } else {
        return _createCredential(vc, oldId, credentialManifest);
      }
    } else {
      return _createCredential(vc, oldId, credentialManifest);
    }
  } catch (e, s) {
    log.e('something went wrong e: $e, stackTrace: $s', e, s);
    return null;
  }
}
