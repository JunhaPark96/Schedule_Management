// import 'package:flutter/material.dart';
// import 'package:flutter_quill/flutter_quill.dart' as quill;

// class InputFormQuill extends StatelessWidget {
//   const InputFormQuill({super.key});

//   // final quill.QuillController controller;

//   // const QuillEditor({
//   //   super.key,
//   //   required this.controller,
//   // });

//   @override
//   Widget build(BuildContext context) {
//     final quill.QuillController controller = quill.QuillController.basic();
//     return Column(
//       children: [
//         quill.QuillToolbar(
//           child: Container(
//             padding: const EdgeInsets.all(10),
//             decoration: BoxDecoration(
//               border: Border.all(color: Colors.teal),
//               borderRadius: BorderRadius.circular(8),
//             ),
//           ),
//         ),
//         Expanded(
//           child: Container(
//             padding: const EdgeInsets.all(10),
//             decoration: BoxDecoration(
//               border: Border.all(color: Colors.teal),
//               borderRadius: BorderRadius.circular(8),
//             ),
//             child: quill.QuillEditor(
//               focusNode: ,
//               controller: controller,
              
//             )
//           ),
//         ),
//       ],
//     );
//   }
// }
