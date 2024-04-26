import 'dart:async';

import 'package:coozy_cafe/widgets/country_pickers/countries.dart';
import 'package:coozy_cafe/widgets/country_pickers/country.dart';
import 'package:coozy_cafe/widgets/country_pickers/country_picker_dialog.dart';
import 'package:coozy_cafe/widgets/country_pickers/utils/utils.dart';
import 'package:coozy_cafe/widgets/phone_number_text_form_widget/helpers.dart';
import 'package:coozy_cafe/widgets/phone_number_text_form_widget/phone_number.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';

class PhoneNumberTextFormField extends StatefulWidget {
  /// show which Country need show first
  final List<Country>? priorityList;

  /// show which Countries need to appear in list of dialog
  final List<Country>? countryList;

  /// Whether to hide the text being edited (e.g., for passwords).
  final bool obscureText;

  /// How the text should be aligned horizontally.
  final TextAlign textAlign;

  /// How the text should be aligned vertically.
  final TextAlignVertical? textAlignVertical;
  final VoidCallback? onTap;

  /// {@macro flutter.widgets.editableText.readOnly}
  final bool readOnly;
  final FormFieldSetter<PhoneNumber>? onSaved;

  /// {@macro flutter.widgets.editableText.onChanged}
  ///
  /// See also:
  ///
  ///  * [inputFormatters], which are called before [onChanged]
  ///    runs and can validate and change ("format") the input value.
  ///  * [onEditingComplete], [onSubmitted], [onSelectionChanged]:
  ///    which are more specialized input change notifications.
  final ValueChanged<PhoneNumber>? onChanged;

  final ValueChanged<Country>? onCountryChanged;

  /// An optional method that validates an input. Returns an error string to display if the input is invalid, or null otherwise.
  ///
  /// A [PhoneNumber] is passed to the validator as argument.
  /// The validator can handle asynchronous validation when declared as a [Future].
  /// Or run synchronously when declared as a [Function].
  ///
  /// By default, the validator checks whether the input number length is between selected country's phone numbers min and max length.
  /// If `disableLengthCheck` is not set to `true`, your validator returned value will be overwritten by the default validator.
  /// But, if `disableLengthCheck` is set to `true`, your validator will have to check phone number length itself.
  final FutureOr<String?> Function(PhoneNumber?)? validator;

  /// {@macro flutter.widgets.editableText.keyboardType}
  final TextInputType? keyboardType;

  /// Controls the text being edited.
  ///
  /// If null, this widget will create its own [TextEditingController].
  final TextEditingController? controller;

  /// Defines the keyboard focus for this widget.
  ///
  /// The [focusNode] is a long-lived object that's typically managed by a
  /// [StatefulWidget] parent. See [FocusNode] for more information.
  ///
  /// To give the keyboard focus to this widget, provide a [focusNode] and then
  /// use the current [FocusScope] to request the focus:
  ///
  /// ```dart
  /// FocusScope.of(context).requestFocus(myFocusNode);
  /// ```
  ///
  /// This happens automatically when the widget is tapped.
  ///
  /// To be notified when the widget gains or loses the focus, add a listener
  /// to the [focusNode]:
  ///
  /// ```dart
  /// focusNode.addListener(() { print(myFocusNode.hasFocus); });
  /// ```
  ///
  /// If null, this widget will create its own [FocusNode].
  ///
  /// ## Keyboard
  ///
  /// Requesting the focus will typically cause the keyboard to be shown
  /// if it's not showing already.
  ///
  /// On Android, the user can hide the keyboard - without changing the focus -
  /// with the system back button. They can restore the keyboard's visibility
  /// by tapping on a text field.  The user might hide the keyboard and
  /// switch to a physical keyboard, or they might just need to get it
  /// out of the way for a moment, to expose something it's
  /// obscuring. In this case requesting the focus again will not
  /// cause the focus to change, and will not make the keyboard visible.
  ///
  /// This widget builds an [EditableText] and will ensure that the keyboard is
  /// showing when it is tapped by calling [EditableTextState.requestKeyboard()].
  final FocusNode? focusNode;

  /// {@macro flutter.widgets.editableText.onSubmitted}
  ///
  /// See also:
  ///
  ///  * [EditableText.onSubmitted] for an example of how to handle moving to
  ///    the next/previous field when using [TextInputAction.next] and
  ///    [TextInputAction.previous] for [textInputAction].
  final void Function(String)? onSubmitted;

  /// If false the widget is "disabled": it ignores taps, the [TextFormField]'s
  /// [decoration] is rendered in grey,
  /// [decoration]'s [InputDecoration.counterText] is set to `""`,
  /// and the drop down icon is hidden no matter [showDropdownIcon] value.
  ///
  /// If non-null this property overrides the [decoration]'s
  /// [Decoration.enabled] property.
  final bool enabled;

  /// The appearance of the keyboard.
  ///
  /// This setting is only honored on iOS devices.
  ///
  /// If unset, defaults to the brightness of [ThemeData.brightness].
  final Brightness? keyboardAppearance;

  /// Initial Value for the field.
  /// This property can be used to pre-fill the field.
  final String? initialValue;

  /// 2 letter ISO Code or country dial code.
  ///
  /// ```dart
  /// initialCountryCode: 'IN', // India
  /// initialCountryCode: '+225', // Côte d'Ivoire
  /// ```
  final String? initialCountryCode;

  // /// List of Country to display see countries.dart for format
  // final List<Country>? countries;

  /// The decoration to show around the text field.
  ///
  /// By default, draws a horizontal line under the text field but can be
  /// configured to show an icon, label, hint text, and error text.
  ///
  /// Specify null to remove the decoration entirely (including the
  /// extra padding introduced by the decoration to save space for the labels).
  final InputDecoration decoration;

  /// The style to use for the text being edited.
  ///
  /// This text style is also used as the base style for the [decoration].
  ///
  /// If null, defaults to the `subtitle1` text style from the current [Theme].
  final TextStyle? style;

  /// Disable view Min/Max Length check
  final bool disableLengthCheck;

  /// Won't work if [enabled] is set to `false`.
  final bool showDropdownIcon;

  final BoxDecoration dropdownDecoration;

  /// The style use for the country dial code.
  final TextStyle? dropdownTextStyle;

  /// {@macro flutter.widgets.editableText.inputFormatters}
  final List<TextInputFormatter>? inputFormatters;

  /// The text that describes the search input field.
  ///
  /// When the input field is empty and unfocused, the label is displayed on top of the input field (i.e., at the same location on the screen where text may be entered in the input field).
  /// When the input field receives focus (or if the field is non-empty), the label moves above (i.e., vertically adjacent to) the input field.
  final String searchText;

  /// Position of an icon [leading, trailing]
  final IconPosition dropdownIconPosition;

  /// Icon of the drop down button.
  ///
  /// Default is [Icon(Icons.arrow_drop_down)]
  final Icon dropdownIcon;

  /// Whether this text field should focus itself if nothing else is already focused.
  final bool autofocus;

  /// Autovalidate mode for text form field.
  ///
  /// If [AutovalidateMode.onUserInteraction], this FormField will only auto-validate after its content changes.
  /// If [AutovalidateMode.always], it will auto-validate even without user interaction.
  /// If [AutovalidateMode.disabled], auto-validation will be disabled.
  ///
  /// Defaults to [AutovalidateMode.onUserInteraction].
  final AutovalidateMode? autovalidateMode;

  /// Whether to show or hide country flag.
  ///
  /// Default value is `true`.
  final bool showCountryFlag;

  /// Message to be displayed on autoValidate error
  ///
  /// Default value is `Invalid Mobile Number`.
  final String? invalidNumberMessage;

  /// The color of the cursor.
  final Color? cursorColor;

  /// How tall the cursor will be.
  final double? cursorHeight;

  /// How rounded the corners of the cursor should be.
  final Radius? cursorRadius;

  /// How thick the cursor will be.
  final double cursorWidth;

  /// Whether to show cursor.
  final bool? showCursor;

  /// The padding of the Flags Button.
  ///
  /// The amount of insets that are applied to the Flags Button.
  ///
  /// If unset, defaults to [EdgeInsets.zero].
  final EdgeInsetsGeometry flagsButtonPadding;

  /// The type of action button to use for the keyboard.
  final TextInputAction? textInputAction;

  /// The margin of the country selector button.
  ///
  /// The amount of space to surround the country selector button.
  ///
  /// If unset, defaults to [EdgeInsets.zero].
  final EdgeInsets flagsButtonMargin;

  //enable the autofill hint for phone number
  final bool disableAutoFillHints;

  const PhoneNumberTextFormField({
    super.key,
    this.countryList,
    this.initialCountryCode,
    this.disableAutoFillHints = false,
    this.obscureText = false,
    this.textAlign = TextAlign.left,
    this.textAlignVertical,
    this.onTap,
    this.readOnly = false,
    this.initialValue,
    this.keyboardType = TextInputType.phone,
    this.controller,
    this.focusNode,
    this.decoration = const InputDecoration(),
    this.style,
    this.dropdownTextStyle,
    this.onSubmitted,
    this.validator,
    this.onChanged,
    // this.countries,
    this.onCountryChanged,
    this.onSaved,
    this.showDropdownIcon = true,
    this.dropdownDecoration = const BoxDecoration(),
    this.inputFormatters,
    this.enabled = true,
    this.keyboardAppearance,
    this.searchText = 'Search country',
    this.dropdownIconPosition = IconPosition.leading,
    this.dropdownIcon = const Icon(Icons.arrow_drop_down),
    this.autofocus = false,
    this.textInputAction,
    this.autovalidateMode = AutovalidateMode.onUserInteraction,
    this.showCountryFlag = true,
    this.cursorColor,
    this.disableLengthCheck = false,
    this.flagsButtonPadding = EdgeInsets.zero,
    this.invalidNumberMessage = 'Invalid Mobile Number',
    this.cursorHeight,
    this.cursorRadius = Radius.zero,
    this.cursorWidth = 2.0,
    this.showCursor = true,
    this.flagsButtonMargin = EdgeInsets.zero,
    this.priorityList,
  });

  @override
  State<PhoneNumberTextFormField> createState() =>
      _PhoneNumberTextFormFieldState();
}

class _PhoneNumberTextFormFieldState extends State<PhoneNumberTextFormField> {
  late List<Country> _countryList;
  late Country _selectedCountry;
  late List<Country> filteredCountries;
  late String number;

  String? validatorMessage;

  @override
  void initState() {
    super.initState();
    // _countryList = widget.countries ?? countryList;
    _countryList = countryList;
    filteredCountries = _countryList;
    number = widget.initialValue ?? '';
    if (widget.initialCountryCode == null && number.startsWith('+')) {
      number = number.substring(1);
      // parse initial value
      _selectedCountry = countryList.firstWhere(
          (country) => number.startsWith(country.fullCountryCode),
          orElse: () => _countryList.first);

      // remove country code from the initial number value
      number = number.replaceFirst(
          RegExp("^${_selectedCountry.fullCountryCode}"), "");
    } else {
      _selectedCountry = _countryList.firstWhere(
          (item) => item.isoCode == (widget.initialCountryCode ?? 'US'),
          orElse: () => _countryList.first);

      // remove country code from the initial number value
      if (number.startsWith('+')) {
        number = number.replaceFirst(
            RegExp("^\\+${_selectedCountry.fullCountryCode}"), "");
      } else {
        number = number.replaceFirst(
            RegExp("^${_selectedCountry.fullCountryCode}"), "");
      }
    }

    if (widget.autovalidateMode == AutovalidateMode.always) {
      final initialPhoneNumber = PhoneNumber(
        countryISOCode: _selectedCountry.isoCode,
        countryCode: '+${_selectedCountry.phoneCode}',
        number: widget.initialValue ?? '',
      );

      final value = widget.validator?.call(initialPhoneNumber);

      if (value is String) {
        validatorMessage = value;
      } else {
        (value as Future).then((msg) {
          validatorMessage = msg;
        });
      }
    }
  }

  // Future<void> _changeCountry() async {
  //   filteredCountries = _countryList;
  //   await showDialog(
  //     context: context,
  //     useRootNavigator: false,
  //     builder: (context) => StatefulBuilder(
  //       builder: (ctx, setState) => CountryPickerDialog(
  //         languageCode: widget.languageCode.toLowerCase(),
  //         style: widget.pickerDialogStyle,
  //         filteredCountries: filteredCountries,
  //         searchText: widget.searchText,
  //         countryList: _countryList,
  //         selectedCountry: _selectedCountry,
  //         onCountryChanged: (Country country) {
  //           _selectedCountry = country;
  //           widget.onCountryChanged?.call(country);
  //           setState(() {});
  //         },
  //       ),
  //     ),
  //   );
  //   if (mounted) setState(() {});
  // }

  Future<void> _openCountryPickerDialog() async {
    showDialog(
      context: context,
      builder: (context) => Theme(
        data: Theme.of(context),
        child: CountryPickerDialog(
          contentPadding: const EdgeInsets.all(8.0),
          titlePadding: const EdgeInsets.all(8.0),
          searchCursorColor: Theme.of(context).primaryColorLight,
          searchInputDecoration: InputDecoration(
            hintText: 'Search...',
            label: const Text("Search"),
            isDense: true,
            prefixIcon: const Icon(
              Icons.search,
              size: 24,
            ),
            border: OutlineInputBorder(
              borderSide: BorderSide(
                color: Theme.of(context).colorScheme.primary,
                width: 2,
              ),
              borderRadius: BorderRadius.circular(5),
            ),
            disabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Theme.of(context).disabledColor,
              ),
              borderRadius: BorderRadius.circular(5),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Theme.of(context).colorScheme.primary,
              ),
              borderRadius: BorderRadius.circular(5),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Theme.of(context).colorScheme.primary,
                width: 2,
              ),
              borderRadius: BorderRadius.circular(5),
            ),
            errorBorder: OutlineInputBorder(
              borderSide:
                  BorderSide(color: Theme.of(context).colorScheme.error),
              borderRadius: BorderRadius.circular(5),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderSide:
                  BorderSide(color: Theme.of(context).colorScheme.error),
              borderRadius: BorderRadius.circular(5),
            ),
          ),
          isSearchable: true,
          searchEmptyView: Padding(
            padding: const EdgeInsets.only(
                left: 20.0, right: 20.0, top: 10, bottom: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Center(
                  child: Container(
                    child: Lottie.asset(
                      "assets/lottie/country_location.json",
                      repeat: true,
                      alignment: Alignment.center,
                      fit: BoxFit.fitHeight,
                      height: MediaQuery.of(context).size.height * 0.30,
                    ),
                  ),
                ),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Expanded(
                      child: Text("Please enter proper world name..",
                          textAlign: TextAlign.center),
                    ),
                  ],
                ),
              ],
            ),
          ),
          title: Row(
            children: [
              Flexible(
                  child: Text('Select your phone code',
                      textAlign: TextAlign.start,
                      style: Theme.of(context).textTheme.bodyMedium)),
            ],
          ),
          onValuePicked: (country) async {
            _selectedCountry = country;
            widget.onCountryChanged?.call(country);
            setState(() {});
          },
          itemBuilder: _buildDialogItem,
          priorityList: widget.priorityList,
          itemFilter: (country) {
            // Check if widget.countryList is not null and contains the country
            if (widget.countryList != null && widget.countryList!.contains(country)) {
              return true;
            }
            // If neither widget.countryList nor widget.countries contains the country, exclude it
            return false;
          },
        ),
      ),
    );
    if (mounted) setState(() {});
  }

  Widget _buildDialogItem(Country country) => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          CountryPickerUtils.getDefaultFlagImage(country),
          const SizedBox(width: 8.0),
          Expanded(
            child: Text(
              country.name,
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          const SizedBox(width: 8.0),
          Text("+${country.phoneCode}"),
        ],
      );

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: (widget.controller == null) ? number : null,
      keyboardType: widget.keyboardType ?? TextInputType.phone,
      autofillHints: widget.disableAutoFillHints
          ? null
          : [AutofillHints.telephoneNumberNational],
      readOnly: widget.readOnly,
      obscureText: widget.obscureText,
      textAlign: widget.textAlign,
      textAlignVertical: widget.textAlignVertical,
      cursorColor: widget.cursorColor,
      onTap: widget.onTap,
      controller: widget.controller,
      focusNode: widget.focusNode,
      cursorHeight: widget.cursorHeight,
      cursorRadius: widget.cursorRadius,
      cursorWidth: widget.cursorWidth,
      showCursor: widget.showCursor,
      onFieldSubmitted: widget.onSubmitted,
      decoration: widget.decoration.copyWith(
        prefixIcon: _buildFlagsButton(),
        counterText: !widget.enabled ? '' : null,
      ),
      style: widget.style,
      onSaved: (value) {
        widget.onSaved?.call(
          PhoneNumber(
            countryISOCode: _selectedCountry.isoCode,
            countryCode:
                '+${_selectedCountry.phoneCode}${_selectedCountry.regionCode}',
            number: value!,
          ),
        );
      },
      onChanged: (value) async {
        final phoneNumber = PhoneNumber(
          countryISOCode: _selectedCountry.isoCode,
          countryCode: '+${_selectedCountry.fullCountryCode}',
          number: value,
        );

        if (widget.autovalidateMode != AutovalidateMode.disabled) {
          validatorMessage = await widget.validator?.call(phoneNumber);
        }

        widget.onChanged?.call(phoneNumber);
      },
      validator: (value) {
        if (value == null || !isNumeric(value)) return validatorMessage;
        if (!widget.disableLengthCheck) {
          return value.length >= _selectedCountry.minLength &&
                  value.length <= _selectedCountry.maxLength
              ? null
              : widget.invalidNumberMessage;
        }

        return validatorMessage;
      },
      maxLength: widget.disableLengthCheck ? null : _selectedCountry.maxLength,
      inputFormatters: widget.inputFormatters,
      enabled: widget.enabled,
      keyboardAppearance: widget.keyboardAppearance,
      autofocus: widget.autofocus,
      textInputAction: widget.textInputAction,
      autovalidateMode: widget.autovalidateMode,
    );
  }

  Container _buildFlagsButton() {
    return Container(
      margin: widget.flagsButtonMargin,
      child: DecoratedBox(
        decoration: widget.dropdownDecoration,
        child: InkWell(
          borderRadius: widget.dropdownDecoration.borderRadius as BorderRadius?,
          onTap: widget.enabled ? _openCountryPickerDialog : null,
          child: Padding(
            padding: widget.flagsButtonPadding,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const SizedBox(
                  width: 4,
                ),
                if (widget.enabled &&
                    widget.showDropdownIcon &&
                    widget.dropdownIconPosition == IconPosition.leading) ...[
                  widget.dropdownIcon,
                  const SizedBox(width: 4),
                ],
                if (widget.showCountryFlag) ...[
                  kIsWeb
                      ? Image.asset(
                          'assets/images/flags/${_selectedCountry.isoCode.toLowerCase()}.png',
                          width: 32,
                        )
                      : Image.asset(
                          'assets/images/flags/${_selectedCountry.isoCode.toLowerCase()}.png',
                          width: 32,
                        ),
                  const SizedBox(width: 10),
                ],
                FittedBox(
                  child: Text(
                    '+${_selectedCountry.phoneCode}',
                    style: widget.dropdownTextStyle,
                  ),
                ),
                if (widget.enabled &&
                    widget.showDropdownIcon &&
                    widget.dropdownIconPosition == IconPosition.trailing) ...[
                  const SizedBox(width: 4),
                  widget.dropdownIcon,
                ],
                const SizedBox(width: 8),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

enum IconPosition {
  leading,
  trailing,
}
