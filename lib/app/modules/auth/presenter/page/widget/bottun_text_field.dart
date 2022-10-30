import 'package:flutter/material.dart';

class ButtonTextField extends StatefulWidget {
  final String? fieldTitle;
  final void Function()? onTap;
  final double width;
  final double height;
  final TextEditingController? controller;
  const ButtonTextField({
    Key? key,
    this.fieldTitle,
    this.onTap,
    required this.width,
    required this.height,
    this.controller,
  }) : super(key: key);

  @override
  State<ButtonTextField> createState() => _ButtonTextFieldState();
}

class _ButtonTextFieldState extends State<ButtonTextField> {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double circular = widget.height * 0.24;
    return GestureDetector(
      onTap: widget.onTap,
      child: Material(
        color: const Color.fromARGB(0, 255, 255, 255),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            widget.fieldTitle == null
                ? const SizedBox()
                : Text(
                    widget.fieldTitle!,
                    style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: Colors.white),
                  ),
            SizedBox(
              height: height * 0.007,
            ),
            Container(
              width: widget.width,
              height: widget.height,
              padding: const EdgeInsets.all(2),
              child: TextField(
                controller: widget.controller,
                enabled: false,
                style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                    color: Colors.black),
                decoration: InputDecoration(
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  isDense: true,
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 15.0, vertical: 12),
                  fillColor: Colors.white,
                  hoverColor: Colors.white,
                  filled: true,
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(width: 0, color: Colors.white),
                    borderRadius: BorderRadius.circular(circular),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(width: 0, color: Colors.white),
                    borderRadius: BorderRadius.circular(circular),
                  ),
                  disabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(width: 0, color: Colors.white),
                    borderRadius: BorderRadius.circular(circular),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderSide: const BorderSide(width: 0, color: Colors.white),
                    borderRadius: BorderRadius.circular(circular),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderSide: const BorderSide(width: 0, color: Colors.white),
                    borderRadius: BorderRadius.circular(circular),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
