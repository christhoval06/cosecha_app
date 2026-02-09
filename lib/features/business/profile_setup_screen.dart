import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

import 'package:cosecha_app/core/constants/app_prefs.dart';
import 'package:cosecha_app/core/utils/file.dart';
import 'package:cosecha_app/core/widgets/avatar_image_picker.dart';
import 'package:cosecha_app/data/models/business.dart';
import 'package:cosecha_app/data/repositories/business_repository.dart';
import 'package:cosecha_app/l10n/app_localizations.dart';
import 'package:cosecha_app/core/constants/currencies.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cosecha_app/core/services/business_session.dart';
import 'package:cosecha_app/core/constants/app_routes.dart';

class ProfileSetupScreen extends StatefulWidget {
  const ProfileSetupScreen({super.key, this.isEdit = false});

  final bool isEdit;

  @override
  State<ProfileSetupScreen> createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends State<ProfileSetupScreen> {
  final _formKey = GlobalKey<FormBuilderState>();
  bool _isCustomCurrency = false;
  Business? _currentBusiness;

  @override
  void initState() {
    super.initState();
    _currentBusiness = BusinessRepository().getCurrent();
    if (widget.isEdit && _currentBusiness != null) {
      _isCustomCurrency = !defaultCurrencies.any(
        (currency) => currency.code == _currentBusiness!.currencyCode,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final defaultCurrency = defaultCurrencies.firstWhere(
      (currency) => currency.code == 'USD',
      orElse: () => defaultCurrencies.first,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.isEdit ? l10n.profileEditTitle : l10n.profileSetupTitle,
        ),
      ),
      body: FormBuilder(
        key: _formKey,
        initialValue: {
          if (widget.isEdit && _currentBusiness != null) ...{
            'logoPath': _currentBusiness!.logoPath ?? '',
            'business_name': _currentBusiness!.name,
            'currency': defaultCurrencies.firstWhere(
              (currency) => currency.code == _currentBusiness!.currencyCode,
              orElse: () => defaultCurrencies.first,
            ),
            'custom_symbol': _currentBusiness!.currencySymbol ?? '',
            'custom_code': _currentBusiness!.currencyCode,
          } else
            'currency': defaultCurrency,
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              FormBuilderField<String>(
                name: 'logoPath',
                validator: FormBuilderValidators.required(
                  errorText: l10n.profileSetupLogoRequired,
                ),
                builder: (field) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: AvatarImagePicker(
                          value: field.value,
                          onChanged: field.didChange,
                        ),
                      ),
                      if (field.errorText != null) ...[
                        const SizedBox(height: 8),
                        Text(
                          field.errorText!,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.error,
                          ),
                        ),
                      ],
                    ],
                  );
                },
              ),
              const SizedBox(height: 24),
              FormBuilderTextField(
                name: 'business_name',
                decoration: InputDecoration(
                  labelText: l10n.profileSetupNameLabel,
                ),
                validator: FormBuilderValidators.compose([
                  FormBuilderValidators.required(
                    errorText: l10n.profileSetupNameRequired,
                  ),
                  FormBuilderValidators.minLength(
                    3,
                    errorText: l10n.profileSetupNameMin(3),
                  ),
                ]),
              ),
              const SizedBox(height: 24),
              FormBuilderDropdown<Currency?>(
                name: 'currency',
                decoration: InputDecoration(
                  labelText: l10n.profileSetupCurrencyLabel,
                ),
                hint: Text(l10n.profileSetupCurrencyHint),
                items: [
                  ...defaultCurrencies.map((currency) {
                    return DropdownMenuItem<Currency?>(
                      value: currency,
                      child: Text(
                        '${_currencyLabel(l10n, currency)} (${currency.symbol})',
                      ),
                    );
                  }),
                  DropdownMenuItem<Currency?>(
                    value: null,
                    child: Text(
                      l10n.profileSetupCurrencyOtherOption,
                      style: TextStyle(fontStyle: FontStyle.italic),
                    ),
                  ),
                ],
                onChanged: (value) {
                  // La lógica para mostrar/ocultar los campos personalizados sigue siendo la misma
                  setState(() {
                    _isCustomCurrency = (value == null);
                  });
                },
                validator: (value) {
                  // Validación personalizada
                  if (value == null && !_isCustomCurrency) {
                    return l10n.profileSetupCurrencyRequired;
                  }
                  return null;
                },
              ),

              // --- CAMPOS PARA MONEDA PERSONALIZADA (VISIBLES CONDICIONALMENTE) ---
              if (_isCustomCurrency)
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: Column(
                    children: [
                      FormBuilderTextField(
                        name: 'custom_symbol',
                        decoration: InputDecoration(
                          labelText: l10n.profileSetupCustomSymbolLabel,
                        ),
                        validator: _isCustomCurrency
                            ? FormBuilderValidators.required(
                                errorText:
                                    l10n.profileSetupCustomSymbolRequired,
                              )
                            : null,
                      ),
                      const SizedBox(height: 16),
                      FormBuilderTextField(
                        name: 'custom_code',
                        decoration: InputDecoration(
                          labelText: l10n.profileSetupCustomCodeLabel,
                        ),
                        validator: _isCustomCurrency
                            ? FormBuilderValidators.required(
                                errorText: l10n.profileSetupCustomCodeRequired,
                              )
                            : null,
                      ),
                    ],
                  ),
                ),

              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _saveProfileAndNavigate,
                child: Text(widget.isEdit
                    ? l10n.profileSave
                    : l10n.profileSetupSaveContinue),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _currencyLabel(AppLocalizations l10n, Currency currency) {
    switch (currency.code) {
      case 'USD':
        return l10n.currencyNameUsd;
      case 'EUR':
        return l10n.currencyNameEur;
      case 'PEN':
        return l10n.currencyNamePen;
      case 'MXN':
        return l10n.currencyNameMxn;
      case 'COP':
        return l10n.currencyNameCop;
      default:
        return currency.code;
    }
  }

  Future<void> _saveProfileAndNavigate() async {
    if (!(_formKey.currentState?.saveAndValidate() ?? false)) {
      return;
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    try {
      final formData = _formKey.currentState!.value;
      final businessRepo = BusinessRepository();

      String? logoPath = await saveLocallyFromPath(formData['logoPath']!);

      final String businessName = formData['business_name'];
      final Currency? selectedCurrency = formData['currency'];

      String currencySymbol;
      String currencyCode;

      if (_isCustomCurrency) {
        currencySymbol = formData['custom_symbol'];
        currencyCode = formData['custom_code'];
      } else {
        currencySymbol = selectedCurrency!.symbol;
        currencyCode = selectedCurrency.code;
      }

      await businessRepo.saveProfile(
        Business(
          id: 'current_profile',
          name: businessName,
          logoPath: logoPath,
          currencySymbol: currencySymbol,
          currencyCode: currencyCode,
        ),
      );
      BusinessSession.instance.setCurrent(
        Business(
          id: 'current_profile',
          name: businessName,
          logoPath: logoPath,
          currencySymbol: currencySymbol,
          currencyCode: currencyCode,
        ),
      );

      final prefs = await SharedPreferences.getInstance();
      if (!widget.isEdit) {
        await prefs.setBool(AppPrefs.profileSetupComplete, true);
      }

      if (mounted) {
        Navigator.of(context).pop();
        if (!widget.isEdit) {
          Navigator.of(context).pushReplacementNamed(AppRoutes.home);
        } else {
          Navigator.of(context).pop();
        }
      }
    } catch (e) {
      if (mounted) {
        final l10n = AppLocalizations.of(context);
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${l10n.profileSetupSaveError}: $e')),
        );
      }
    }
  }
}
