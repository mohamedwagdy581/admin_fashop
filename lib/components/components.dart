import 'package:flutter/material.dart';

import 'constants.dart';

// Reusable Navigate Function and return to the previous screen
void navigateTo(context, widget) => Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => widget,
      ),
    );

// Reusable Navigate Function and remove the previous screen
void navigateAndFinish(context, widget) => Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => widget,
      ),
      (route) => false,
    );

Widget defaultCardDashboard({
  required VoidCallback onPressed,
  required IconData titleIcon,
  required String titleLabel,
  required String subTitleLabel,
}) =>
    Padding(
      padding: const EdgeInsets.all(18.0),
      child: Card(
        child: ListTile(
          title: TextButton.icon(
            onPressed: onPressed,
            icon: Icon(
              titleIcon,
              color: notActive,
            ),
            label: Text(
              titleLabel,
              style: const TextStyle(
                color: notActive,
              ),
            ),
          ),
          subtitle: Text(
            subTitleLabel,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: active,
              fontSize: 60.0,
            ),
          ),
        ),
      ),
    );

Widget defaultManageListTile({
  required VoidCallback onTap,
  required IconData leadingIcon,
  required String title,
}) =>
    ListTile(
      leading: Icon(
        leadingIcon,
      ),
      title: Text(
        title,
      ),
      onTap: onTap,
    );

Widget defaultOutlineAddButton({
  required VoidCallback onPressed,
  required Widget child,
}) =>
    Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: OutlinedButton(
          style: OutlinedButton.styleFrom(
            side: BorderSide(width: 2.5, color: notActive.withOpacity(0.5),),
          ),
          onPressed: onPressed,
          child: child,
        ),
      ),
    );

Widget defaultSigningInRowButton({
  required String title,
  TextStyle? titleStyle,
  required double width,
  required IconData icon,
  Color iconColor = Colors.black,
  Color rowBackgroundColor = Colors.white,
  required VoidCallback onPressed,
}) =>
    Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: MaterialButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        color: rowBackgroundColor,
        onPressed: onPressed,
        child: Row(
          // mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 15.0),
              child: Icon(
                icon,
                color: iconColor,
              ),
            ),
            SizedBox(
              width: width,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                title,
                style: titleStyle,
              ),
            ),
          ],
        ),
      ),
    );


// Reusable TextFormField Function with validator
Widget defaultTextFormField({
  required TextEditingController? controller,
  required TextInputType keyboardType,
  required String? label,
  TextStyle? textStyle,
  VoidCallback? onTap,
  required String? Function(String?)? validator,
  Function(String)? onSubmitted,
  bool secure = false,
  required IconData? prefix,
  Color? prefixColor,
  IconData? suffix,
  Color? suffixColor,
  VoidCallback? suffixPressed,
  bool? isClickable,
}) =>
    Container(
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        color: Colors.white60,
      ),
      child: TextFormField(
        style: textStyle,
        controller: controller,
        keyboardType: keyboardType,
        onTap: onTap,
        enabled: isClickable,
        validator: validator,
        obscureText: secure,
        onFieldSubmitted: onSubmitted,
        decoration: InputDecoration(
            labelText: label,
            prefixIcon: Icon(
              prefix,
              color: prefixColor,
            ),
            suffixIcon: IconButton(
              icon: Icon(suffix),
              onPressed: suffixPressed,
              color: suffixColor,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
            )),
      ),
    );
