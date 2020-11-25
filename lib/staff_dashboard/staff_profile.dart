// import 'package:flutter/material.dart';
// import 'package:lacasa/localization/app_localization.dart';
// import 'package:lacasa/utils/colors.dart';
// import 'package:lacasa/utils/size_config.dart';
// import 'package:lacasa/utils/validator.dart';
//
// class StaffProfile extends StatefulWidget {
//   @override
//   _StaffProfileState createState() => _StaffProfileState();
// }
//
// class _StaffProfileState extends State<StaffProfile> {
//   TextEditingController name_cont = TextEditingController();
//   TextEditingController email_cont = TextEditingController();
//   TextEditingController pass_cont = TextEditingController();
//   final GlobalKey<FormState> _formKey_profile = GlobalKey<FormState>();
//   bool autoValidation_profile = false;
//
//   var selectTile = 1;
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     selectTile = 1;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     SizeConfig().init(context);
//     return GestureDetector(
//       onTap: () {
//         FocusScope.of(context).requestFocus(new FocusNode());
//       },
//       child: Scaffold(
//         backgroundColor: whiteColor,
//         body: SingleChildScrollView(
//           child: Container(
//               child: Column(
//             children: [
//               SizedBox(
//                 height: SizeConfig.blockSizeVertical * 1,
//               ),
//               Container(
//                 width: SizeConfig.blockSizeHorizontal * 100,
//                 height: SizeConfig.blockSizeHorizontal * 13,
//                 child: Row(
//                   children: [
//                     Expanded(
//                       flex: 4,
//                       child: _select_tile(1, "profile"),
//                     ),
//                     Expanded(
//                       flex: 5,
//                       child: _select_tile(2, "change_password"),
//                     ),
//                   ],
//                 ),
//               ),
//               selectTile == 1
//                   ? Container(
//                       padding: EdgeInsets.only(
//                           top: SizeConfig.blockSizeVertical * 5),
//                       margin: EdgeInsets.symmetric(
//                           horizontal: SizeConfig.blockSizeHorizontal * 10),
//                       child: Column(
//                         children: [
//                           _text_field(1, name_cont, FieldValidator.validatename,
//                               "Enter Name", "your_name"),
//                           _spacer(1, 0),
//                           _text_field(
//                               1,
//                               email_cont,
//                               FieldValidator.validateEmail,
//                               "Enter Email",
//                               "your_email"),
//                           _spacer(1, 0),
//                           _text_field(
//                               1,
//                               pass_cont,
//                               FieldValidator.validatePassword,
//                               "Enter Password",
//                               "current_password"),
//                           _spacer(3, 0),
//                           Container(
//                             alignment: Alignment.center,
//                             width: SizeConfig.blockSizeHorizontal * 100,
//                             height: SizeConfig.blockSizeHorizontal * 14,
//                             decoration: BoxDecoration(
//                                 color: buttonColor,
//                                 borderRadius: BorderRadius.circular(10)),
//                             child: Text(
//                               AppLocalization.of(context)
//                                   .getTranslatedValues("update"),
//                               style: TextStyle(
//                                   color: whiteColor,
//                                   fontWeight: FontWeight.bold,
//                                   fontSize: SizeConfig.blockSizeHorizontal * 4),
//                             ),
//                           )
//                         ],
//                       ),
//                     )
//                   : Container(
//                       padding: EdgeInsets.only(
//                           top: SizeConfig.blockSizeVertical * 5),
//                       margin: EdgeInsets.symmetric(
//                           horizontal: SizeConfig.blockSizeHorizontal * 10),
//                       child: Column(
//                         children: [
//                           _text_field(1, name_cont, FieldValidator.validatename,
//                               "your_old_Password", "your_old_Password"),
//                           _spacer(1, 0),
//                           _text_field(
//                               1,
//                               email_cont,
//                               FieldValidator.validateEmail,
//                               "your_new_Password",
//                               "your_new_Password"),
//                           _spacer(1, 0),
//                           _text_field(
//                               1,
//                               pass_cont,
//                               FieldValidator.validatePassword,
//                               "your_new_Password",
//                               "confirm_Password"),
//                           _spacer(3, 0),
//                           Container(
//                             alignment: Alignment.center,
//                             width: SizeConfig.blockSizeHorizontal * 100,
//                             height: SizeConfig.blockSizeHorizontal * 14,
//                             decoration: BoxDecoration(
//                                 color: buttonColor,
//                                 borderRadius: BorderRadius.circular(10)),
//                             child: Text(
//                               AppLocalization.of(context)
//                                   .getTranslatedValues("update"),
//                               style: TextStyle(
//                                   color: whiteColor,
//                                   fontWeight: FontWeight.bold,
//                                   fontSize: SizeConfig.blockSizeHorizontal * 4),
//                             ),
//                           )
//                         ],
//                       ),
//                     )
//             ],
//           )),
//         ),
//       ),
//     );
//   }
//
//   Widget _spacer(double h, double w) {
//     return SizedBox(
//       width: SizeConfig.blockSizeHorizontal * w,
//       height: SizeConfig.blockSizeVertical * h,
//     );
//   }
//
//   Widget _select_tile(int index, String tile) {
//     return GestureDetector(
//       onTap: () {
//         setState(() {
//           selectTile = index;
//         });
//       },
//       child: Container(
//         padding: EdgeInsets.all(10),
//         alignment: Alignment.center,
//         decoration: BoxDecoration(
//             border: Border(
//                 bottom: BorderSide(
//                     color: selectTile == index
//                         ? Colors.grey
//                         : Colors.grey.withOpacity(.10),
//                     width: 3))),
//         child: Text(
//           AppLocalization.of(context).getTranslatedValues(tile),
//           style: TextStyle(
//               color: selectTile == index ? blackColor : Colors.grey,
//               fontWeight: FontWeight.bold),
//         ),
//       ),
//     );
//   }
//
//   Widget _text_field(int index, TextEditingController controller,
//       Function validator, String hint, String lable) {
//     return TextFormField(
//       controller: controller,
//       cursorColor: blackColor,
//       validator: validator,
//       decoration: InputDecoration(
//         isDense: true,
//         disabledBorder: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(5),
//             borderSide: BorderSide(color: Colors.white)),
//         enabledBorder: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(5),
//             borderSide: BorderSide(color: blackColor.withOpacity(.50))),
//         focusedBorder: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(5),
//             borderSide: BorderSide(color: Colors.grey)),
//         border: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(5),
//             borderSide: BorderSide(color: Colors.white)),
//         filled: true,
//         fillColor: whiteColor,
//         labelText: AppLocalization.of(context).getTranslatedValues(lable),
//         hintStyle: TextStyle(
//             fontSize: MediaQuery.of(context).size.height * .0175,
//             color: Colors.grey.withOpacity(.60),
//             fontFamily: 'babas'),
//         hintText: AppLocalization.of(context).getTranslatedValues(hint),
//       ),
//     );
//   }
// }
