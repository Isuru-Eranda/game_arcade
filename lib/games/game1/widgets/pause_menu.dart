import 'package:flame/palette.dart';
import 'package:flutter/material.dart';

class PauseMenu extends StatelessWidget {
  final VoidCallback onResumePressed;

  const PauseMenu({super.key, required this.onResumePressed})
      // ignore: unnecessary_null_comparison
      : assert(onResumePressed != null);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        // ignore: deprecated_member_use
        color: Colors.black.withOpacity(0.5),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 100.0, vertical: 50.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Game Paused',
                style: TextStyle(
                  fontFamily: 'Audiowide',
                  fontSize: 35.0,
                  color: BasicPalette.green.color,
                ),
              ),
                    IconButton(
                    icon: Icon(
                      Icons.play_arrow,
                      color: Colors.white,
                      size: 35.0,
                    ),
                    onPressed: onResumePressed, // Call the resume function
                  ),
                  
          
        
            ],
          ),
        ),
      ),
    );
  }
}

