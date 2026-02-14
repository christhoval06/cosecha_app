import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:intl/intl.dart';

import '../services/business_session.dart';
import '../utils/formatters.dart';

class FormBuilderCurrencyField extends StatelessWidget {
  const FormBuilderCurrencyField({
    super.key,
    required this.name,
    required this.labelText,
    this.controller,
    this.hintText,
    this.initialValue,
    this.validator,
    this.onChanged,
  });

  final String name;
  final String labelText;
  final TextEditingController? controller;
  final String? hintText;
  final String? initialValue;
  final FormFieldValidator<String>? validator;
  final ValueChanged<String?>? onChanged;

  @override
  Widget build(BuildContext context) {
    final prefix = currencyPrefixForCurrentBusiness();
    final decimalDigits = currencyDecimalDigitsForCurrentBusiness();

    return FormBuilderTextField(
      name: name,
      controller: controller,
      initialValue: initialValue,
      keyboardType: TextInputType.number,
      inputFormatters: [
        CurrencyAmountInputFormatter(decimalDigits: decimalDigits),
      ],
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        prefixText: prefix,
      ),
      validator: validator,
      onChanged: onChanged,
    );
  }
}

String? currencyPrefixForCurrentBusiness() {
  final business = BusinessSession.instance.current;
  final symbol = (business?.currencySymbol ?? '').trim();
  if (symbol.isNotEmpty) return '$symbol ';

  final code = (business?.currencyCode ?? '').trim();
  if (code.isNotEmpty) return '$code ';

  return null;
}

double? parseCurrencyInput(
  String? raw, {
  int? decimalDigits,
  String locale = 'en_US',
}) {
  if (raw == null) return null;
  final value = raw.trim();
  if (value.isEmpty) return null;

  final digits = decimalDigits ?? currencyDecimalDigitsForCurrentBusiness();
  final formatter = NumberFormat.decimalPatternDigits(
    locale: locale,
    decimalDigits: digits,
  );

  try {
    final parsed = formatter.parse(value);
    return parsed.toDouble();
  } catch (_) {
    final fallback = value.replaceAll(',', '.');
    return double.tryParse(fallback);
  }
}

class CurrencyAmountInputFormatter extends TextInputFormatter {
  CurrencyAmountInputFormatter({
    required this.decimalDigits,
    String locale = 'en_US',
  }) : _formatter = NumberFormat.decimalPatternDigits(
         locale: locale,
         decimalDigits: decimalDigits,
       );

  final int decimalDigits;
  final NumberFormat _formatter;

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final digits = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');
    if (digits.isEmpty) {
      return const TextEditingValue();
    }

    final units = BigInt.parse(digits);
    final amount = decimalDigits == 0
        ? units.toDouble()
        : units.toDouble() / math.pow(10, decimalDigits);
    final formatted = _formatter.format(amount);

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}
