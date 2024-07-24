import 'package:flutter/material.dart';
import 'package:todo_app/reusable_widgets/list_widget.dart';

class TODOScreen extends StatefulWidget {
  const TODOScreen({super.key});

  @override
  State<TODOScreen> createState() => _TODOScreenState();
}

class _TODOScreenState extends State<TODOScreen> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(20.0),
            child: Column(
              children: [
                Row(
                  children: [
                    Text(
                      "TO-DO",
                      style: TextStyle(
                        fontSize: 24.0,
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 30.0,
                ),
                ListWidget(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
