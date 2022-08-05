import 'package:altme/app/app.dart';
import 'package:altme/theme/theme.dart';
import 'package:altme/withdrawal_tokens/withdrawal_tokens.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TokenAmountCalculatorView extends StatelessWidget {
  const TokenAmountCalculatorView({
    Key? key,
    required this.tokenSelectBoxController,
  }) : super(key: key);

  final TokenSelectBoxController tokenSelectBoxController;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<TokenAmountCalculatorCubit>(
      create: (_) => TokenAmountCalculatorCubit(
        tokenSelectBoxController: tokenSelectBoxController,
      ),
      child: const _TokenAmountCalculator(),
    );
  }
}

class _TokenAmountCalculator extends StatefulWidget {
  const _TokenAmountCalculator({
    Key? key,
  }) : super(key: key);

  @override
  State<_TokenAmountCalculator> createState() => _TokenAmountCalculatorState();
}

class _TokenAmountCalculatorState extends State<_TokenAmountCalculator> {
  final amountController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  void _insertKey(String key) {
    if (key.length > 1) return;
    final text = amountController.text;
    context.read<TokenAmountCalculatorCubit>().setAmount(amount: text + key);
  }

  void _setAmountControllerText(String text) {
    amountController.text = text;
    amountController.selection = TextSelection.fromPosition(
      TextPosition(offset: amountController.text.length),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          const SizedBox(
            height: Sizes.spaceLarge,
          ),
          BlocBuilder<TokenAmountCalculatorCubit, TokenAmountCalculatorState>(
            builder: (context, state) {
              _setAmountControllerText(state.amount);
              return Column(
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Padding(
                          padding: const EdgeInsets.all(Sizes.space2XSmall),
                          child: TextField(
                            controller: amountController,
                            style:
                                Theme.of(context).textTheme.headline6?.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                    ),
                            maxLines: 1,
                            cursorWidth: 4,
                            autofocus: false,
                            keyboardType: TextInputType.none,
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            cursorRadius: const Radius.circular(4),
                            onChanged: (value) {
                              if (value != amountController.text) {
                                context
                                    .read<TokenAmountCalculatorCubit>()
                                    .setAmount(amount: value);
                              }
                            },
                            textAlign: TextAlign.center,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: '0',
                              contentPadding: EdgeInsets.zero,
                            ),
                          ),
                        ),
                      ),
                      Text(
                        state.selectedToken.symbol,
                        style: Theme.of(context).textTheme.headline6?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w900,
                            ),
                      )
                    ],
                  ),
                  const UsdValueText(),
                  MaxButton(
                    onTap: () {
                      _setAmountControllerText(
                        state.selectedToken.calculatedBalance,
                      );
                      context
                          .read<TokenAmountCalculatorCubit>()
                          .setAmount(amount: amountController.text);
                    },
                  ),
                ],
              );
            },
          ),
          Expanded(
            child: Container(
              alignment: Alignment.bottomCenter,
              child: SingleChildScrollView(
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.7,
                  height: MediaQuery.of(context).size.width * 0.7,
                  child: LayoutBuilder(
                    builder: (_, constraint) {
                      return NumericKeyboard(
                        keyboardUIConfig: KeyboardUIConfig(
                          digitShape: BoxShape.rectangle,
                          spacing: 40,
                          digitInnerMargin: EdgeInsets.zero,
                          keyboardRowMargin: EdgeInsets.zero,
                          digitBorderWidth: 0,
                          digitTextStyle: Theme.of(context)
                              .textTheme
                              .calculatorKeyboardDigitTextStyle,
                          keyboardSize: constraint.biggest,
                        ),
                        leadingButton: KeyboardButton(
                          digitShape: BoxShape.rectangle,
                          digitBorderWidth: 0,
                          label: '.',
                          semanticsLabel: '.',
                          onTap: _insertKey,
                        ),
                        trailingButton: KeyboardButton(
                          digitShape: BoxShape.rectangle,
                          digitBorderWidth: 0,
                          semanticsLabel: 'delete',
                          icon: Image.asset(
                            IconStrings.keyboardDelete,
                            width: Sizes.icon2x,
                            color: Colors.white,
                          ),
                          onLongPress: (_) {
                            amountController.text = '';
                          },
                          onTap: (_) {
                            final text = amountController.text;
                            if (text.isNotEmpty) {
                              amountController.text =
                                  text.substring(0, text.length - 1);
                              amountController.selection =
                                  TextSelection.fromPosition(
                                TextPosition(
                                  offset: amountController.text.length,
                                ),
                              );
                            }
                          },
                        ),
                        onKeyboardTap: _insertKey,
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
