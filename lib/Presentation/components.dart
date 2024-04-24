import 'package:flutter/material.dart';
import 'package:lifeline/Utils/constants.dart';

class Components {
  static commonTextfield(
          {required String txt,
          required TextEditingController controller,
          required TextInputType inputtype,
          Function(dynamic)? onChanged,
          bool readOnly = false,
          IconData? icons}) =>
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            txt,
            style: const TextStyle(fontSize: 15),
          ),
          const SizedBox(
            height: 4,
          ),
          TextField(
            readOnly: readOnly,
            controller: controller,
            keyboardType: inputtype,
            onChanged: onChanged,
            textInputAction: TextInputAction.none,
            decoration: InputDecoration(
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                isCollapsed: true,
                suffixIcon: Icon(icons, color: Constants.primaryColor),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: Colors.black87,
                  ),
                )),
          )
        ],
      );
  static commonDialog(BuildContext context, String title, Widget content,
      {List<Widget>? actions, Function()? ontapOfClose}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          insetPadding: EdgeInsets.all(10),
          actions: actions != null && actions.isNotEmpty ? actions : null,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(12))),
          title: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Text(
                      title,
                      style: TextStyle(
                          color: Constants.mutedColor,
                          fontWeight: FontWeight.w500,
                          fontSize: 15),
                    ),
                  ),
                  InkWell(
                    onTap: ontapOfClose == null
                        ? () {
                            Navigator.pop(context);
                          }
                        : ontapOfClose,
                    child: CircleAvatar(
                      radius: 12,
                      backgroundColor: Constants.mutedColor,
                      child: Icon(
                        Icons.close,
                        color: Colors.white,
                        size: 15,
                      ),
                    ),
                  )
                ],
              ),
              Divider(
                color: Constants.lightGrey,
              ),
            ],
          ),
          content: SizedBox(
              width: MediaQuery.of(context).size.width,
              // height: MediaQuery.of(context).size.height,
              child: content),
        );
      },
    );
  }
}
