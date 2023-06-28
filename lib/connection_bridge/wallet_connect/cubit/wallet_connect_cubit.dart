import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:altme/app/app.dart';
import 'package:altme/connection_bridge/connection_bridge.dart';
import 'package:altme/wallet/wallet.dart';
import 'package:bloc/bloc.dart';
import 'package:convert/convert.dart';
import 'package:equatable/equatable.dart';
import 'package:eth_sig_util/eth_sig_util.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:secure_storage/secure_storage.dart';
import 'package:wallet_connect/wallet_connect.dart';
import 'package:walletconnect_flutter_v2/walletconnect_flutter_v2.dart';
import 'package:web3dart/web3dart.dart';

part 'wallet_connect_cubit.g.dart';
part 'wallet_connect_state.dart';

class WalletConnectCubit extends Cubit<WalletConnectState> {
  WalletConnectCubit({
    required this.connectedDappRepository,
    required this.secureStorageProvider,
  }) : super(WalletConnectState()) {
    initialise();
  }

  final ConnectedDappRepository connectedDappRepository;
  final SecureStorageProvider secureStorageProvider;

  final log = getLogger('WalletConnectCubit');

  Web3Wallet? _web3Wallet;

  Web3Wallet? get web3Wallet => _web3Wallet;

  Future<void> initialise() async {
    try {
      //log.i('initialise');
      // final List<SavedDappData> savedDapps =
      //     await connectedDappRepository.findAll();

      // final connectedDapps = List.of(savedDapps).where(
      //   (element) => element.blockchainType != BlockchainType.tezos,
      // );

      // Await the initialization of the web3wallet

      // final List<WCClient> wcClients = List.empty(growable: true);
      // for (final element in connectedDapps) {
      //   final sessionStore = element.wcSessionStore;

      //   final WCClient? wcClient = createWCClient(element.wcSessionStore);

      //   await wcClient!.connectFromSessionStore(sessionStore!);
      //   log.i('sessionStore: ${wcClient.sessionStore.toJson()}');
      //   wcClients.add(wcClient);
      //}

      // emit(
      //   state.copyWith(
      //     status: WalletConnectStatus.idle,
      //     // wcClients: wcClients,
      //   ),
      // );

      final String? savedCryptoAccount =
          await secureStorageProvider.get(SecureStorageKeys.cryptoAccount);

      log.i('Create the web3wallet');
      await dotenv.load();
      final projectId = dotenv.get('WALLET_CONNECT_PROJECT_ID');
      _web3Wallet = await Web3Wallet.createInstance(
        relayUrl:
            'wss://relay.walletconnect.com', // The relay websocket URL, leave blank to use the default
        projectId: projectId,
        metadata: const PairingMetadata(
          name: 'Wallet (Altme)',
          description: 'Altme Wallet',
          url: 'https://altme.io',
          icons: [],
        ),
      );

      log.i('Setup our accounts');

      if (savedCryptoAccount != null && savedCryptoAccount.isNotEmpty) {
        //load all the content of walletAddress
        final cryptoAccountJson =
            jsonDecode(savedCryptoAccount) as Map<String, dynamic>;
        final CryptoAccount cryptoAccount =
            CryptoAccount.fromJson(cryptoAccountJson);

        final eVMAccounts = cryptoAccount.data
            .where((e) => e.blockchainType != BlockchainType.tezos)
            .toList();

        final events = ['chainChanged', 'accountsChanged'];

        for (final accounts in eVMAccounts) {
          log.i(accounts.blockchainType);
          log.i('registerAccount');
          _web3Wallet!.registerAccount(
            chainId: accounts.blockchainType.chain,
            accountAddress: accounts.walletAddress,
          );

          log.i('registerEventEmitter');
          for (final String event in events) {
            _web3Wallet!.registerEventEmitter(
              chainId: accounts.blockchainType.chain,
              event: event,
            );
          }

          log.i('registerRequestHandler');
          _web3Wallet!.registerRequestHandler(
            chainId: accounts.blockchainType.chain,
            method: Parameters.PERSONAL_SIGN,
            handler: personalSign,
          );
          _web3Wallet!.registerRequestHandler(
            chainId: accounts.blockchainType.chain,
            method: Parameters.ETH_SIGN,
            handler: ethSign,
          );
          _web3Wallet!.registerRequestHandler(
            chainId: accounts.blockchainType.chain,
            method: Parameters.ETH_SIGN_TRANSACTION,
            handler: ethSignTransaction,
          );
          _web3Wallet!.registerRequestHandler(
            chainId: accounts.blockchainType.chain,
            method: Parameters.ETH_SIGN_TYPE_DATA,
            handler: ethSignTransaction,
          );
          _web3Wallet!.registerRequestHandler(
            chainId: accounts.blockchainType.chain,
            method: Parameters.ETH_SEND_TRANSACTION,
            handler: ethSignTypedData,
          );
        }
      }

      log.i('Setup our listeners');
      _web3Wallet!.core.pairing.onPairingInvalid.subscribe(_onPairingInvalid);
      _web3Wallet!.core.pairing.onPairingCreate.subscribe(_onPairingCreate);
      _web3Wallet!.pairings.onSync.subscribe(_onPairingsSync);
      _web3Wallet!.onSessionProposal.subscribe(_onSessionProposal);
      _web3Wallet!.onSessionProposalError.subscribe(_onSessionProposalError);
      _web3Wallet!.onSessionConnect.subscribe(_onSessionConnect);
      _web3Wallet!.onAuthRequest.subscribe(_onAuthRequest);

      log.i('web3wallet init');
      await _web3Wallet!.init();
      log.i('metadata');
      log.i(_web3Wallet!.metadata);

      log.i('pairings');
      log.i(_web3Wallet!.pairings.getAll());
      log.i('sessions');
      log.i(_web3Wallet!.sessions.getAll());
      log.i('completeRequests');
      log.i(_web3Wallet!.completeRequests.getAll());
    } catch (e) {
      log.e(e);
    }
  }

  Future<void> connect(String walletConnectUri) async {
    log.i('walletConnectUri - $walletConnectUri');
    // final WCSession session = WCSession.from(walletConnectUri);
    // final WCPeerMeta walletPeerMeta = WCPeerMeta(
    //   name: 'Altme',
    //   url: 'https://altme.io',
    //   description: 'Altme Wallet',
    //   icons: [],
    // );

    // final WCClient? wcClient = createWCClient(null);
    // log.i('wcClient: $wcClient');
    // if (wcClient == null) return;

    // await wcClient.connectNewSession(
    //   session: session,
    //   peerMeta: walletPeerMeta,
    // );

    // final wcClients = List.of(state.wcClients)..add(wcClient);
    // emit(
    //   state.copyWith(
    //     status: WalletConnectStatus.idle,
    //     wcClients: wcClients,
    //   ),
    // );
    final Uri uriData = Uri.parse(walletConnectUri);
    final PairingInfo pairingInfo = await _web3Wallet!.pair(
      uri: uriData,
    );
    log.i(pairingInfo);
  }

  WCClient? createWCClient(WCSessionStore? sessionStore) {
    WCPeerMeta? currentPeerMeta = sessionStore?.remotePeerMeta;
    String? currentPeerId = sessionStore?.remotePeerId;
    return WCClient(
      onConnect: () {
        log.i('connected');
      },
      onDisconnect: (code, reason) {
        log.i('onDisconnect - code: $code reason:  $reason');
      },
      onFailure: (dynamic error) {
        log.e('Failed to connect: $error');
      },
      onSessionRequest: (int id, String dAppPeerId, WCPeerMeta dAppPeerMeta) {
        log.i('onSessionRequest');
        log.i('id: $id');

        currentPeerId = dAppPeerId;
        currentPeerMeta = dAppPeerMeta;

        log.i('dAppPeerId: $currentPeerId');
        log.i('currentDAppPeerMeta: $currentPeerMeta');
        emit(
          state.copyWith(
            sessionId: id,
            status: WalletConnectStatus.permission,
            currentDappPeerId: dAppPeerId,
            currentDAppPeerMeta: currentPeerMeta,
          ),
        );
      },
      onEthSign: (int id, WCEthereumSignMessage message) {
        log.i('onEthSign');
        log.i('id: $id');
        //log.i('message: ${message.raw}');
        log.i('data: ${message.data}');
        log.i('type: ${message.type}');
        log.i('dAppPeerId: $currentPeerId');
        log.i('currentDAppPeerMeta: $currentPeerMeta');

        switch (message.type) {
          case WCSignType.MESSAGE:
          case WCSignType.TYPED_MESSAGE:
            final wcClient = state.wcClients.firstWhereOrNull(
              (element) => element.remotePeerId == currentPeerId,
            );
            if (wcClient != null) {
              wcClient.rejectRequest(id: id);
            }
            break;
          case WCSignType.PERSONAL_MESSAGE:
            emit(
              state.copyWith(
                signId: id,
                status: WalletConnectStatus.signPayload,
                signMessage: message,
                currentDappPeerId: currentPeerId,
                currentDAppPeerMeta: currentPeerMeta,
              ),
            );
            break;
        }
      },
      onEthSendTransaction: (int id, WCEthereumTransaction transaction) {
        log.i('onEthSendTransaction');
        log.i('id: $id');
        log.i('tx: $transaction');
        log.i('dAppPeerId: $currentPeerId');
        log.i('currentDAppPeerMeta: $currentPeerMeta');
        emit(
          state.copyWith(
            signId: id,
            status: WalletConnectStatus.operation,
            transactionId: id,
            transaction: transaction,
            currentDappPeerId: currentPeerId,
            currentDAppPeerMeta: currentPeerMeta,
          ),
        );
      },
      onEthSignTransaction: (id, tx) {
        log.i('onEthSignTransaction');
        log.i('id: $id');
        log.i('tx: $tx');
      },
    );
  }

  void _onPairingInvalid(PairingInvalidEvent? args) {
    print('Pairing Invalid Event: $args');
  }

  void _onPairingsSync(StoreSyncEvent? args) {
    if (args != null) {
      //pairings.value = _web3Wallet!.pairings.getAll();
      log.i('onPairingsSync');
      print(_web3Wallet!.pairings.getAll());
    }
  }

  void _onSessionProposal(SessionProposalEvent? args) {
    log.i('onSessionProposal');
    if (args != null) {
      log.i('sessionProposalEvent - $args');
      emit(
        state.copyWith(
          status: WalletConnectStatus.permission,
          sessionProposalEvent: args,
        ),
      );
    }
  }

  void _onSessionProposalError(SessionProposalErrorEvent? args) {
    log.i('onSessionProposalError');
    print(args);
  }

  void _onSessionConnect(SessionConnect? args) {
    if (args != null) {
      print(args);
      print(args.session);
      //sessions.value.add(args.session);
    }
  }

  void _onPairingCreate(PairingEvent? args) {
    print('Pairing Create Event: $args');
  }

  Future<void> _onAuthRequest(AuthRequest? args) async {
    if (args != null) {
      print(args);
      // List<ChainKey> chainKeys = GetIt.I<IKeyService>().getKeysForChain(
      //   'eip155:1',
      // );
      // Create the message to be signed
      //final String iss = 'did:pkh:eip155:1:${chainKeys.first.publicKey}';

      // print(args);
      //   final Widget w = WCRequestWidget(
      //     child: WCConnectionRequestWidget(
      //       wallet: _web3Wallet!,
      //       authRequest: WCAuthRequestModel(
      //         iss: iss,
      //         request: args,
      //       ),
      //     ),
      //   );
      //   final bool? auth = await _bottomSheetHandler.queueBottomSheet(
      //     widget: w,
      //   );

      //   if (auth != null && auth) {
      //     final String message = _web3Wallet!.formatAuthMessage(
      //       iss: iss,
      //       cacaoPayload: CacaoRequestPayload.fromPayloadParams(
      //         args.payloadParams,
      //       ),
      //     );

      //     // EthPrivateKey credentials =
      //     //     EthPrivateKey.fromHex(chainKeys.first.privateKey);
      //     // final String sig = utf8.decode(
      //     //   credentials.signPersonalMessageToUint8List(
      //     //     Uint8List.fromList(message.codeUnits),
      //     //   ),
      //     // );

      //     final String sig = EthSigUtil.signPersonalMessage(
      //       message: Uint8List.fromList(message.codeUnits),
      //       privateKey: chainKeys.first.privateKey,
      //     );

      //     await _web3Wallet!.respondAuthRequest(
      //       id: args.id,
      //       iss: iss,
      //       signature: CacaoSignature(
      //         t: CacaoSignature.EIP191,
      //         s: sig,
      //       ),
      //     );
      //   } else {
      //     await _web3Wallet!.respondAuthRequest(
      //       id: args.id,
      //       iss: iss,
      //       error: Errors.getSdkError(
      //         Errors.USER_REJECTED_AUTH,
      //       ),
      //     );
      //   }
      // }
    }
  }

  // Future<String?> requestAuthorization(String text) async {
  //   final bool? approved = await _bottomSheetService.queueBottomSheet(
  //     widget: WCRequestWidget(
  //       child: WCConnectionWidget(
  //         title: 'Sign Transaction',
  //         info: [
  //           WCConnectionModel(
  //             text: text,
  //           ),
  //         ],
  //       ),
  //     ),
  //   );

  //   if (approved != null && approved == false) {
  //     return 'User rejected signature';
  //   }

  //   return null;
  // }

  Future<String> personalSign(String topic, dynamic parameters) async {
    print('received personal sign request: $parameters');

    final String message = getUtf8Message(parameters[0].toString());

    // final String? authAcquired = await requestAuthorization(message);
    // if (authAcquired != null) {
    //   return authAcquired;
    // }

    try {
      // Load the private key

      final Credentials credentials =
          EthPrivateKey.fromHex('keys[0].privateKey');

      final String signature = hex.encode(
        credentials.signPersonalMessageToUint8List(
          Uint8List.fromList(
            utf8.encode(message),
          ),
        ),
      );

      return '0x$signature';
    } catch (e) {
      print(e);
      return 'Failed';
    }
  }

  Future<String> ethSign(String topic, dynamic parameters) async {
    print('received eth sign request: $parameters');

    final String message = getUtf8Message(parameters[1].toString());

    // final String? authAcquired = await requestAuthorization(message);
    // if (authAcquired != null) {
    //   return authAcquired;
    // }

    try {
      // Load the private key

      final EthPrivateKey credentials = EthPrivateKey.fromHex(
        'keys[0].privateKey',
      );
      final String signature = hex.encode(
        credentials.signPersonalMessageToUint8List(
          Uint8List.fromList(
            utf8.encode(message),
          ),
        ),
      );
      print(signature);

      return '0x$signature';
    } catch (e) {
      print('error:');
      print(e);
      return 'Failed';
    }
  }

  Future<String> ethSignTransaction(String topic, dynamic parameters) async {
    print('received eth sign transaction request: $parameters');
    // final String? authAcquired = await requestAuthorization(
    //   jsonEncode(
    //     parameters[0],
    //   ),
    // );
    // if (authAcquired != null) {
    //   return authAcquired;
    // }

    // Load the private key

    final Credentials credentials = EthPrivateKey.fromHex(
      '0xkeys[0].privateKey',
    );

    final EthereumTransaction ethTransaction = EthereumTransaction.fromJson(
      parameters[0] as Map<String, dynamic>,
    );

    // Construct a transaction from the EthereumTransaction object
    final transaction = Transaction(
      from: EthereumAddress.fromHex(ethTransaction.from),
      to: EthereumAddress.fromHex(ethTransaction.to),
      value: EtherAmount.fromUnitAndValue(
        EtherUnit.wei,
        BigInt.tryParse(ethTransaction.value) ?? BigInt.zero,
      ),
      gasPrice: ethTransaction.gasPrice != null
          ? EtherAmount.fromUnitAndValue(
              EtherUnit.gwei,
              BigInt.tryParse(ethTransaction.gasPrice!) ?? BigInt.zero,
            )
          : null,
      maxFeePerGas: ethTransaction.maxFeePerGas != null
          ? EtherAmount.fromUnitAndValue(
              EtherUnit.gwei,
              BigInt.tryParse(ethTransaction.maxFeePerGas!) ?? BigInt.zero,
            )
          : null,
      maxPriorityFeePerGas: ethTransaction.maxPriorityFeePerGas != null
          ? EtherAmount.fromUnitAndValue(
              EtherUnit.gwei,
              BigInt.tryParse(ethTransaction.maxPriorityFeePerGas!) ??
                  BigInt.zero,
            )
          : null,
      maxGas: int.tryParse(ethTransaction.gasLimit ?? ''),
      nonce: int.tryParse(ethTransaction.nonce ?? ''),
      data: (ethTransaction.data != null && ethTransaction.data != '0x')
          ? Uint8List.fromList(hex.decode(ethTransaction.data!))
          : null,
    );

    try {
      await dotenv.load();
      final infuraApiKey = dotenv.get('INFURA_API_KEY');
      final ethRpcUrl = Urls.infuraBaseUrl + infuraApiKey;
      final httpClient = Client();

      final Web3Client ethClient = Web3Client(ethRpcUrl, httpClient);

      final Uint8List sig = await ethClient.signTransaction(
        credentials,
        transaction,
      );

      // Sign the transaction
      final String signedTx = hex.encode(sig);

      // Return the signed transaction as a hexadecimal string
      return '0x$signedTx';
    } catch (e) {
      print(e);
      return 'Failed';
    }
  }

  Future<String> ethSignTypedData(String topic, dynamic parameters) async {
    print('received eth sign typed data request: $parameters');
    final String data = parameters[1] as String;
    // final String? authAcquired = await requestAuthorization(data);
    // if (authAcquired != null) {
    //   return authAcquired;
    // }

    // final List<ChainKey> keys = GetIt.I<IKeyService>().getKeysForChain(
    //   getChainId(),
    // );

    // EthPrivateKey credentials = EthPrivateKey.fromHex(keys[0].privateKey);
    // credentials.

    return EthSigUtil.signTypedData(
      privateKey: 'keys[0].privateKey',
      jsonData: data,
      version: TypedDataVersion.V4,
    );
  }

  Future<void> dispose() async {
    log.i('web3wallet dispose');
    _web3Wallet!.core.pairing.onPairingInvalid.unsubscribe(_onPairingInvalid);
    _web3Wallet!.pairings.onSync.unsubscribe(_onPairingsSync);
    _web3Wallet!.onSessionProposal.unsubscribe(_onSessionProposal);
    _web3Wallet!.onSessionProposalError.unsubscribe(_onSessionProposalError);
    _web3Wallet!.onSessionConnect.unsubscribe(_onSessionConnect);
    // _web3Wallet!.onSessionRequest.unsubscribe(_onSessionRequest);
    _web3Wallet!.onAuthRequest.unsubscribe(_onAuthRequest);
  }
}
