import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TextFieldTest extends StatefulWidget {
  const TextFieldTest({Key? key}) : super(key: key);

  @override
  State<TextFieldTest> createState() => _TextFieldTestState();
}

class _TextFieldTestState extends State<TextFieldTest> {
  final _focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('TextFiled Test')),
      body: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: _onTap,
        child: Column(
          children: [
            _buildTextField(),
            _buildForm(),
          ],
        ),
      ),
    );
  }

  /// 输入框
  Widget _buildTextField() {
    return Padding(
      padding: const EdgeInsets.all(30.0),
      child: TextField(
        focusNode: _focusNode,
        // showCursor: false,
        // enabled: false,
        maxLength: 10,
        maxLengthEnforcement: MaxLengthEnforcement.none,
        keyboardType: TextInputType.multiline,
        textInputAction: TextInputAction.continueAction,
        decoration: const InputDecoration(
          icon: Icon(Icons.person),
          prefixIcon: Icon(Icons.upcoming_outlined),
          suffixIcon: Icon(Icons.downhill_skiing),
          border: OutlineInputBorder(),
          labelText: 'Enter your username',
          errorStyle: TextStyle(color: Colors.redAccent),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.yellow, width: 3),
          ), // 未选中时候的边框
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.green, width: 3),
          ), // 选中时候的边框
          disabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.blue, width: 3),
          ), // 禁用时的边框
          errorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.deepOrangeAccent, width: 3),
          ), // 错误时的未选中的边框
          focusedErrorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.purple, width: 3),
          ), // 错误时选中的边框
        ),
      ),
    );
  }

  /// 表单
  Widget _buildForm() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Form(
        child: Column(
          children: [
            TextFormField(
              autovalidateMode: AutovalidateMode.disabled,
              decoration: const InputDecoration(
                label: Text('五个字'),
                hintText: '请输入少于5个字的内容',
                border: OutlineInputBorder(),
              ),
              onSaved: (value) {
                debugPrint('五个字-onSaved: $value');
              },
              validator: (value) {
                if (value != null && value.length > 5) return '已超过5个字';
                return null;
              },
            ),
            const SizedBox(height: 20),
            TextFormField(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              decoration: const InputDecoration(
                label: Text('七个字'),
                hintText: '请输入少于7个字的内容',
                border: OutlineInputBorder(),
              ),
              onSaved: (value) {
                debugPrint('七个字-onSaved: $value');
              },
              validator: (value) {
                if (value != null && value.length > 7) return '已超过7个字';
                return null;
              },
            ),
            Builder(
              builder: (ctx) => ElevatedButton(
                onPressed: () {
                  final form = Form.maybeOf(ctx);
                  if (form == null) return;

                  final r = form.validate();
                  if (r != true) return;

                  form.save();
                },
                child: const Text('提交'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onTap() {
    _focusNode.unfocus();
  }
}
