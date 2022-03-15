import 'package:flutter/material.dart';
import 'package:whatsappclone/consts.dart';

class OtpTextField extends StatefulWidget {
  final TextEditingController masterTextEditingController;

  const OtpTextField({
    required this.masterTextEditingController,
    Key? key,
  }) : super(key: key);

  @override
  State<OtpTextField> createState() => _OtpTextFieldState();
}

class _OtpTextFieldState extends State<OtpTextField> {
  final FocusNode fn1 = FocusNode();
  final FocusNode fn2 = FocusNode();
  final FocusNode fn3 = FocusNode();
  final FocusNode fn4 = FocusNode();
  final FocusNode fn5 = FocusNode();
  final FocusNode fn6 = FocusNode();
  final TextEditingController tec1 = TextEditingController();
  final TextEditingController tec2 = TextEditingController();
  final TextEditingController tec3 = TextEditingController();
  final TextEditingController tec4 = TextEditingController();
  final TextEditingController tec5 = TextEditingController();
  final TextEditingController tec6 = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    fn2.onKey = fnOnKey(tec2, tec1, fn1);
    fn3.onKey = fnOnKey(tec3, tec2, fn2);
    fn4.onKey = fnOnKey(tec4, tec3, fn3);
    fn5.onKey = fnOnKey(tec5, tec4, fn4);
    fn6.onKey = fnOnKey(tec6, tec5, fn5);
    fn1.addListener(() => fListener(fn1, fn2, tec1, null, null));
    fn2.addListener(() => fListener(fn2, fn3, tec2, tec1, fn1));
    fn3.addListener(() => fListener(fn3, fn4, tec3, tec2, fn2));
    fn4.addListener(() => fListener(fn4, fn5, tec4, tec3, fn3));
    fn5.addListener(() => fListener(fn5, fn6, tec5, tec4, fn4));
    fn6.addListener(() => fListener(fn6, null, tec6, tec5, fn5));
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    fn1.removeListener(() => fListener(fn1, fn2, tec1, null, null));
    fn2.removeListener(() => fListener(fn2, fn3, tec2, tec1, fn1));
    fn3.removeListener(() => fListener(fn3, fn4, tec3, tec2, fn2));
    fn4.removeListener(() => fListener(fn4, fn5, tec4, tec3, fn3));
    fn5.removeListener(() => fListener(fn5, fn6, tec5, tec4, fn4));
    fn6.removeListener(() => fListener(fn6, null, tec6, tec5, fn5));
    fn1.dispose();
    fn2.dispose();
    fn3.dispose();
    fn4.dispose();
    fn5.dispose();
    fn6.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.text,
      child: GestureDetector(
        onTap: () {
          fn1.requestFocus();
        },
        child: Container(
          decoration: BoxDecoration(
              border:
                  Border(bottom: BorderSide(color: kPrimaryColor, width: 1))),
          width: 180,
          child: Row(children: [
            spacer(),
            digit(focusNode: fn1, cntrlr: tec1, fnn: fn2),
            digit(focusNode: fn2, cntrlr: tec2, fnn: fn3),
            digit(focusNode: fn3, cntrlr: tec3, fnn: fn4),
            spacer(),
            digit(focusNode: fn4, cntrlr: tec4, fnn: fn5),
            digit(focusNode: fn5, cntrlr: tec5, fnn: fn6),
            digit(focusNode: fn6, cntrlr: tec6),
            spacer(),
          ]),
        ),
      ),
    );
  }

  Expanded digit(
      {required FocusNode focusNode,
      required TextEditingController cntrlr,
      FocusNode? fnn}) {
    return Expanded(
      flex: 1,
      child: TextField(
        controller: cntrlr,
        focusNode: focusNode,
        onChanged: (value) {
          if (value != "") {
            fnn?.requestFocus();
          }
          widget.masterTextEditingController.text = tec1.text +
              tec2.text +
              tec3.text +
              tec4.text +
              tec5.text +
              tec6.text;
        },
        //readOnly: true,
        maxLength: 1,
        style: TextStyle(fontSize: 28),
        textAlign: TextAlign.center,
        decoration: InputDecoration(
            border: InputBorder.none, hintText: "-", counterText: ""),
      ),
    );
  }

  Expanded spacer() => Expanded(flex: 1, child: Container());

  fListener(FocusNode fn, FocusNode? fnn, TextEditingController cnt,
      TextEditingController? cntp, FocusNode? fnp) {
    if (fn.hasFocus && cnt.text != "") {
      fnn?.requestFocus();
    }
    if (fn.hasFocus && cntp?.text == "") {
      fnp?.requestFocus();
    }
  }

  fnOnKey(
      TextEditingController tec, TextEditingController tecp, FocusNode fnp) {
    return (node, event) {
      if (event.toStringShort().contains("RawKeyUpEvent")) {
        return KeyEventResult.ignored;
      }
      if (event.logicalKey.keyLabel == "Backspace" && tec.text == "") {
        fnp.requestFocus();
        tecp.text = "";
        return KeyEventResult.handled;
      } else {
        return KeyEventResult.ignored;
      }
    };
  }
}
