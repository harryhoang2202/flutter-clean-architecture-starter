import 'package:flutter/material.dart';

class TextEntryDialog extends StatefulWidget {
  const TextEntryDialog({
    required this.title,
    required this.fieldLabel,
    required this.cancelLabel,
    required this.saveLabel,
    required this.fieldKey,
    this.initialValue = '',
    super.key,
  });

  final String title;
  final String fieldLabel;
  final String cancelLabel;
  final String saveLabel;
  final Key fieldKey;
  final String initialValue;

  @override
  State<TextEntryDialog> createState() => _TextEntryDialogState();
}

class _TextEntryDialogState extends State<TextEntryDialog> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.title),
      content: TextField(
        key: widget.fieldKey,
        controller: _controller,
        autofocus: true,
        decoration: InputDecoration(labelText: widget.fieldLabel),
        textInputAction: TextInputAction.done,
        onSubmitted: (_) => _submit(),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(widget.cancelLabel),
        ),
        FilledButton(onPressed: _submit, child: Text(widget.saveLabel)),
      ],
    );
  }

  void _submit() {
    final value = _controller.text.trim();
    if (value.isEmpty) {
      return;
    }

    Navigator.of(context).pop(value);
  }
}
