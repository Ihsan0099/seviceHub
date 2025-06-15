import 'package:flutter/material.dart';

class RoundButton extends StatelessWidget {
  final bool loading ;
  final String title;
  final VoidCallback ontap;
  const RoundButton({super.key,
    required this.title,
    required this.ontap,
    this.loading = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: ontap,
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          color: Colors.deepPurple,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: loading ? const CircularProgressIndicator(strokeWidth: 3, color: Colors.white,) :
          Text(title, style: const TextStyle(
              color: Colors.white
          ), ),
        ),

      ),
    );
  }
}


