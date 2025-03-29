import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/*
  Created By Amol Gahukar 29-03-2025
*/
// ignore: must_be_immutable
class BorderTextField extends StatelessWidget {
  String labelText;

  String hintText;
  Function(dynamic value) onChanged;
  TextEditingController controller;
  bool obscureText;
  Widget? prefixIcon;
  Widget? sufixIcon;
  Color? iconColor;
  TextInputType inputType;
  List<TextInputFormatter>? inputFormatters;
  bool filled;
  Color? fillColor;
  String? errorMessage;

  int? maxLine;
  int? maxLength;
  bool enable;
  bool isMandatory;
  bool isLabelRequired;
  bool isDatePicker;
  bool isYearPicker;
  bool isTimePicker;
  bool isVisible;
  TimeOfDay? timeOfDay;
  bool is24Hour;
  int marginTop;
  final String? Function(String?)? validator;
  DateTime? firstDate;
  DateTime? lastDate;
  TextAlign? textAlign;
  final bool enableCopy; // New property to control text copying
  final bool enableInteractiveSelection;

  // New visibility property

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

  String? getErrorMessage(String? errorMessage, String label) {
    if (errorMessage == null) {
      return null;
    } else {
      return "$errorMessage $label";
    }
  }

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
