import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

class EditionBottomModal extends StatefulWidget {
  const EditionBottomModal({
    Key? key,
    required this.itemId,
    this.description,
    this.value,
    required this.handle,
  }) : super(key: key);

  final int itemId;
  final String? description;
  final String? value;
  final Function handle;

  @override
  State<EditionBottomModal> createState() => _EditionBottomModalState();
}

class _EditionBottomModalState extends State<EditionBottomModal> {
  TextEditingController _ctr = TextEditingController();

  @override
  void initState() {
    super.initState();
    _ctr = TextEditingController(text: widget.value);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      height: 140,
      child: Center(
        child: Column(
            // mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded(flex: 1, child: Text('Edit ${widget.description}:')),
              Expanded(
                flex: 3,
                child: TextFormField(
                    textAlign: TextAlign.center,
                    controller: _ctr,
                    autofocus: true,
                    autovalidateMode: AutovalidateMode.always,
                    validator: (v) {
                      if (v == null || v.toString() == '') {
                        return '                    Cannot be empty!';
                      }
                      return null;
                    }),
              ),
              Expanded(
                flex: 2,
                child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                  TextButton(
                      onPressed: () => context.router.pop(),
                      child: const Text('Cancel')),
                  TextButton(
                      onPressed: () {
                        if (_ctr.value.text.isNotEmpty) {
                          widget.handle(widget.itemId, _ctr.value.text);
                          context.router.pop();
                        }
                      },
                      child: const Text('OK'))
                ]),
              )
            ]),
      ),
    );
  }
}
