import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MainTextField extends StatefulWidget {
  final String? fieldTitle;
  final TextEditingController? controller;
  final Function(String)? onChanged;
  final Function(String)? onSubmitted;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final bool? autofocus;
  final FocusNode? focusNode;
  final String? hintText;
  final TextInputAction? textInputAction;
  final double? width;
  final double? height;
  const MainTextField({
    Key? key,
    this.fieldTitle,
    this.controller,
    this.onChanged,
    this.onSubmitted,
    this.keyboardType,
    this.inputFormatters,
    this.autofocus,
    this.focusNode,
    this.hintText,
    this.textInputAction,
    this.width,
    this.height,
  }) : super(key: key);

  @override
  State<MainTextField> createState() => _MainTextFieldState();
}

class _MainTextFieldState extends State<MainTextField> {
  FocusNode myFocusNode = FocusNode();

  @override
  void initState() {
    if (widget.focusNode != null) {
      myFocusNode = widget.focusNode!;
    }
    myFocusNode.addListener(() {
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double circular =
        widget.height == null ? height * 0.02 : widget.height! * 0.24;
    return Material(
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
              focusNode: myFocusNode,
              controller: widget.controller,
              onChanged: widget.onChanged,
              onSubmitted: widget.onSubmitted,
              textInputAction: widget.textInputAction,
              keyboardType: widget.keyboardType,
              inputFormatters: widget.inputFormatters,
              autofocus: widget.autofocus ?? false,
              style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                  color: Colors.black),
              decoration: InputDecoration(
                hintText: widget.hintText,
                floatingLabelBehavior: FloatingLabelBehavior.always,
                isDense: true,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 15.0, vertical: 12),
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
    );
  }
}
