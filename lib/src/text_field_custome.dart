import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// A customizable text field widget that supports various input types, validation,
/// and picker functionalities like date, time, and year selection.
///
/// This widget extends [StatelessWidget] and provides a rich set of features including:
/// * Custom border and styling options
/// * Date, time, and year picker integration
/// * Form validation support
/// * Prefix and suffix icons
/// * Error message display
/// * Copy and paste control
/// * Input formatting
// ignore: must_be_immutable
class BorderTextField extends StatelessWidget {
  /// The text to display as the field's label
  String labelText;

  /// The placeholder text shown when the field is empty
  String hintText;

  /// Callback function triggered when the field's value changes
  Function(dynamic value) onChanged;

  /// Controller for managing the text field's content
  TextEditingController controller;

  /// Whether to obscure the text (useful for password fields)
  bool obscureText;

  /// Optional widget to display before the text input
  Widget? prefixIcon;

  /// Optional widget to display after the text input
  Widget? sufixIcon;

  /// Color for the prefix and suffix icons
  Color? iconColor;

  /// The type of keyboard to display for editing the text
  TextInputType inputType;

  /// Optional list of input formatters to control text input
  List<TextInputFormatter>? inputFormatters;

  /// Whether the text field should be filled with a background color
  bool filled;

  /// The background color when [filled] is true
  Color? fillColor;

  /// Error message to display when validation fails
  String? errorMessage;

  /// Maximum number of lines for the text field
  int? maxLine;

  /// Maximum length of text allowed in the field
  int? maxLength;

  /// Whether the text field is enabled for user interaction
  bool enable;

  /// Whether the field is mandatory (displays a red asterisk if true)
  bool isMandatory;

  /// Whether to show the label text
  bool isLabelRequired;

  /// Whether to show a date picker when the field is tapped
  bool isDatePicker;

  /// Whether to show a year picker when the field is tapped
  bool isYearPicker;

  /// Whether to show a time picker when the field is tapped
  bool isTimePicker;

  /// Whether the field should be visible
  bool isVisible;

  /// Selected time when using time picker
  TimeOfDay? timeOfDay;

  /// Whether to use 24-hour format for time picker
  bool is24Hour;

  /// Top margin for the text field container
  int marginTop;

  /// Validation function that returns an error message string if validation fails
  final String? Function(String?)? validator;

  /// First selectable date for date picker
  DateTime? firstDate;

  /// Last selectable date for date picker
  DateTime? lastDate;

  /// Text alignment within the field
  TextAlign? textAlign;

  /// Whether to allow text copying
  final bool enableCopy;

  /// Whether to enable text selection
  final bool enableInteractiveSelection;

  /// Creates a [BorderTextField] widget.
  ///
  /// The [labelText], [hintText], [onChanged], and [controller] parameters are required.
  /// Other parameters are optional and provide additional customization options.
  BorderTextField({
    super.key,
    required this.labelText,
    required this.hintText,
    required this.onChanged,
    required this.controller,
    this.obscureText = false,
    this.prefixIcon,
    this.sufixIcon,
    this.iconColor,
    this.inputType = TextInputType.text,
    this.filled = false,
    this.errorMessage,
    this.maxLine = 1,
    this.enable = true,
    this.maxLength,
    this.fillColor = Colors.white,
    this.isMandatory = false,
    this.isLabelRequired = false,
    this.isDatePicker = false,
    this.isYearPicker = false,
    this.isTimePicker = false,
    this.isVisible = true,
    this.inputFormatters,
    this.is24Hour = false,
    this.timeOfDay,
    this.marginTop = 0,
    this.firstDate,
    this.lastDate,
    this.textAlign = TextAlign.start,
    this.validator,
    this.enableCopy = false, // Default to true for backward compatibility
    this.enableInteractiveSelection =
        false, // Default to true to show by default
  });

  /// Builds the widget tree for the text field.
  ///
  /// If [isVisible] is false, an empty [SizedBox] is returned to hide the widget.
  @override
  Widget build(BuildContext context) {
    // If the field is not visible, return an empty container (hide the widget)
    if (!isVisible) {
      return const SizedBox.shrink(); // Hides the widget
    }
    firstDate ??= DateTime(1900);
    lastDate ??= DateTime(2100);
    return Container(
      margin: EdgeInsets.only(top: marginTop.toDouble()),
      child: Column(
        children: [
          if (isLabelRequired)
            Row(
              children: [
                if (isMandatory)
                  Text(
                    "*",
                    style: Theme.of(
                      context,
                    ).textTheme.titleMedium!.copyWith(color: Colors.red),
                  ),
                Flexible(
                  child: Text(
                    labelText,
                    style: Theme.of(context).textTheme.titleMedium!,
                  ),
                ),
              ],
            ),
          const SizedBox(height: 4),
          IntrinsicHeight(
            //constraints: BoxConstraints(maxHeight: maxHeight, minHeight: 45),
            child: TextFormField(
              style: Theme.of(context).textTheme.titleMedium,
              obscureText: obscureText,
              decoration: InputDecoration(
                fillColor: fillColor,
                filled: filled,
                counterText: '',
                border: const OutlineInputBorder(),
                //labelText: setLabel(labelText),
                hintText: hintText,
                errorText: getErrorMessage(errorMessage, labelText),
                prefixIcon: prefixIcon,
                suffixIcon: sufixIcon,
                prefixIconColor: iconColor,
                suffixIconColor: iconColor,
                hintStyle: Theme.of(context).textTheme.titleMedium!.copyWith(
                      color: Colors.black.withValues(alpha: 0.6),
                    ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
              controller: controller,
              onChanged: (value) => onChanged(value),
              onTap: isDatePicker
                  ? () => _selectDate(context, firstDate!, lastDate!)
                  : isTimePicker
                      ? () => _selectTime(context)
                      : null,
              maxLines: maxLine ?? maxLine,
              minLines: null,
              expands: maxLine! >= 1 ? false : true,
              maxLength: maxLength,
              enabled: enable,
              validator: validator,
              textAlign: textAlign!,
              inputFormatters: inputFormatters,
              enableInteractiveSelection:
                  enableInteractiveSelection, // Control text selection
              contextMenuBuilder: enableCopy
                  ? null
                  : (context, editableTextState) {
                      // Return empty container when copy is disabled
                      return const SizedBox.shrink();
                    },
              textAlignVertical: TextAlignVertical.top,
              keyboardType: isDatePicker ? TextInputType.none : inputType,
            ),
          ),
        ],
      ),
    );
  }

  /// Returns an error message string if [errorMessage] is not null.
  ///
  /// The error message is prefixed with the [labelText] to provide context.
  String? getErrorMessage(String? errorMessage, String label) {
    if (errorMessage == null) {
      return null;
    } else {
      return "$errorMessage $label";
    }
  }

  /// Displays a date picker dialog and updates the text field with the selected date.
  ///
  /// The [context], [firstDate], and [lastDate] parameters are used to configure the date picker.
  Future<void> _selectDate(
    BuildContext context,
    DateTime firstDate,
    DateTime lastDate,
  ) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: firstDate,
      lastDate: lastDate,
    );
    if (picked != null) {
      controller.text = "${picked.toLocal()}".split(' ')[0]; // Format date
      onChanged(controller.text);
    }
  }

  /// Displays a time picker dialog and updates the text field with the selected time.
  ///
  /// The [context] parameter is used to configure the time picker.
  Future<void> _selectTime(BuildContext context) async {
    TimeOfDay? selectedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (BuildContext context, Widget? child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: false),
          child: child!,
        );
      },
    );
    if (selectedTime != null) {
      controller.text =
          "${selectedTime.hour}:${selectedTime.minute}"; // Format date
      onChanged(controller.text);
    }
  }
}
