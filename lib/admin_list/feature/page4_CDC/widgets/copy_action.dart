import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'theme.dart';
import 'vtable.dart';

class CopyToClipboardAction<T> extends StatelessWidget {
  const CopyToClipboardAction({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.copy),
      tooltip: 'Copy table data to clipboard',
      iconSize: defaultIconSize,
      onPressed: () => _copyTableToClipboard(context),
    );
  }
}

void _copyTableToClipboard(BuildContext context) {
  final table = context.findAncestorWidgetOfExactType<VTable>()!;

  final buf = StringBuffer();

  buf.writeln(table.columns.map((c) => c.label).join(','));

  for (final item in table.items) {
    buf.writeln(table.columns.map((column) {
      String val = column.transformFunction != null
          ? column.transformFunction!(item)
          : '$item';
      return val.contains(',') ? '"$val"' : val;
    }).join(','));
  }

  Clipboard.setData(ClipboardData(text: buf.toString()));

  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(content: Text('Copied as CSV to clipboard')),
  );
}
