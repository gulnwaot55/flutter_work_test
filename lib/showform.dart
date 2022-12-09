import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


class ShowForm extends StatelessWidget {
  final String label;
  final IconData? iconData;
  final IconButton iconButton;
  final bool? obsecu;
  final TextEditingController? controller;
  const ShowForm({
    Key? key,
    required this.label,
     this.iconData,
    this.obsecu,
    required this.iconButton,
    final TextInputType? textInputType, this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 16),
      width: 320,
      height: 50,
      child: TextFormField(controller: controller,
        keyboardType: TextInputType.text,
        obscureText: obsecu ?? false,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          contentPadding:
              const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
          suffixIcon: IconButton(onPressed: (){}, icon: iconButton),
          label: Text(label),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey),
            borderRadius: BorderRadius.circular(10),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey),
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }
}
