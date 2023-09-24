import 'package:flutter/material.dart';

class TextPasswordField extends StatefulWidget {
  const TextPasswordField({super.key, required this.controller});

  final TextEditingController controller;

  @override
  State<TextPasswordField> createState() => _TextPasswordFieldState();
}

class _TextPasswordFieldState extends State<TextPasswordField> {
  var obscureText = true;
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      obscureText: obscureText,
      decoration: InputDecoration(
          label: Text('Password'),
          border: OutlineInputBorder(),
          prefixIcon: const Icon(Icons.lock, color: Color(0XFF4FBF26)),
          suffixIcon: GestureDetector(
            onTap: () {
              setState(() {
                obscureText = !obscureText;
              });
            },
            child: obscureText
                ? const Icon(
                    Icons.visibility_off,
                    color: Colors.grey,
                  )
                : const Icon(
                    Icons.visibility,
                    color: Color(0XFF4FBF26),
                  ),
          )),
    );
  }
}
