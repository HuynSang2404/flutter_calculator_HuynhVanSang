import 'package:flutter/material.dart';

void main() {
  runApp(const CalculatorApp());
}

class CalculatorApp extends StatelessWidget {
  const CalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Simple Mobile Calculator',
      debugShowCheckedModeBanner: false, // Ẩn chữ debug
      theme: ThemeData(
        fontFamily: 'Inter',
        colorScheme: const ColorScheme.dark(background: Color(0xFF1C1C1C)),
      ),
      home: const CalculatorScreen(),
    );
  }
}

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

// Các biến State theo đúng yêu cầu đề bài Lab
class _CalculatorScreenState extends State<CalculatorScreen> {
  String _display = '0';
  String _equation = '';
  double _num1 = 0;
  double _num2 = 0;
  String _operation = '';
  // Biến cờ hiệu để biết lúc nào bắt đầu nhập số mới (sau khi bấm dấu + - * /)
  bool _isNewNumber = false;

  // Hàm xử lý loại bỏ đuôi .0 nếu là số nguyên cho đẹp
  String _formatNumber(double result) {
    if (result.isInfinite || result.isNaN) {
      return 'Error';
    }
    String s = result.toString();
    if (s.endsWith('.0')) {
      s = s.substring(0, s.length - 2);
    }
    return s;
  }

  void _onButtonPressed(String buttonText) {
    setState(() {
      if (buttonText == '( )') {
        return;
      }

      // C / CE
      if (buttonText == 'C') {
        if (_display != '0' && !_isNewNumber) {
          // xóa từng số
          _display = _display.substring(0, _display.length - 1);
          if (_display == '' || _display == '-') {
            _display = '0';
          }
        } else {
          // xóa hết
          _display = '0';
          _equation = '';
          _num1 = 0;
          _num2 = 0;
          _operation = '';
          _isNewNumber = false;
        }
      }
      // =
      else if (buttonText == '=') {
        if (_operation != '') {
          _num2 = double.parse(_display);

          _equation = _equation + ' ${_formatNumber(_num2)} =';

          if (_operation == '+') _num1 = _num1 + _num2;
          if (_operation == '-') _num1 = _num1 - _num2;
          if (_operation == '×') _num1 = _num1 * _num2;
          if (_operation == '÷') {
            if (_num2 == 0) {
              _display = 'Error';
              _operation = '';
              _isNewNumber = true;
              return;
            } else {
              _num1 = _num1 / _num2;
            }
          }

          _display = _formatNumber(_num1);
          _operation = '';
          _isNewNumber = true;
        }
      }
      // +/-
      else if (buttonText == '+/-') {
        if (_display != '0' && _display != 'Error') {
          if (_display.contains('-')) {
            _display = _display.replaceAll('-', '');
          } else {
            _display = '-' + _display;
          }
        }
      }
      // %
      else if (buttonText == '%') {
        if (_display != '0' && _display != 'Error') {
          double temp = double.parse(_display);
          _display = _formatNumber(temp / 100);
          _isNewNumber = true;
        }
      }
      // + - × ÷
      else if (buttonText == '+' ||
          buttonText == '-' ||
          buttonText == '×' ||
          buttonText == '÷') {
        if (_display != 'Error') {
          if (_isNewNumber && _operation != '') {
            // bấm 2 phép tính liên tiếp -> đổi
            _operation = buttonText;
            if (_equation.isNotEmpty) {
              _equation =
                  _equation.substring(0, _equation.length - 1) + buttonText;
            }
          } else {
            if (_operation != '') {
              _num2 = double.parse(_display);

              _equation = _equation + ' ${_formatNumber(_num2)} $buttonText';

              if (_operation == '+') _num1 = _num1 + _num2;
              if (_operation == '-') _num1 = _num1 - _num2;
              if (_operation == '×') _num1 = _num1 * _num2;
              if (_operation == '÷') {
                if (_num2 == 0) {
                  _display = 'Error';
                  _operation = '';
                  _isNewNumber = true;
                  return;
                }
                _num1 = _num1 / _num2;
              }
              _display = _formatNumber(_num1);
            } else {
              _num1 = double.parse(_display);
              _equation = '${_formatNumber(_num1)} $buttonText';
            }
            _operation = buttonText;
            _isNewNumber = true;
          }
        }
      }
      // nhập số
      else {
        if (_display == 'Error') {
          _display = '0';
        }

        if (_isNewNumber) {
          if (buttonText == '.') {
            _display = '0.';
          } else {
            _display = buttonText;
          }
          _isNewNumber = false;
        } else {
          if (_display == '0') {
            if (buttonText == '.') {
              _display = '0.';
            } else {
              _display = buttonText;
            }
          } else {
            if (buttonText == '.') {
              if (!_display.contains('.')) {
                _display += buttonText;
              }
            } else {
              _display += buttonText;
            }
          }
        }
      }
    });
  }

  // tạo nút
  Widget _buildButton(
    String text,
    Color bgColor, {
    Color textColor = Colors.white,
  }) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5),
        child: AspectRatio(
          aspectRatio: 1,
          child: Container(
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(100),
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(100),
                onTap: () {
                  _onButtonPressed(text);
                },
                child: Center(
                  child: Text(
                    text,
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.w400,
                      color: textColor,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1C1C1C),
      body: SafeArea(
        child: Column(
          children: [
            // display
            Expanded(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 16,
                ),
                alignment: Alignment.bottomRight,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    // equation
                    Text(
                      _equation,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w400,
                        color: Colors.white54,
                      ),
                    ),
                    const SizedBox(height: 8),
                    // số hiện tại
                    Text(
                      _display,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 64,
                        fontWeight: FontWeight.w400,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // các nút
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 16),
              child: Column(
                children: [
                  // hàng 1
                  Row(
                    children: [
                      _buildButton('C', const Color(0xFF963E3E)),
                      _buildButton('( )', const Color(0xFF272727)),
                      _buildButton('%', const Color(0xFF272727)),
                      _buildButton('÷', const Color(0xFF394734)),
                    ],
                  ),
                  const SizedBox(height: 10),
                  // hàng 2
                  Row(
                    children: [
                      _buildButton('7', const Color(0xFF272727)),
                      _buildButton('8', const Color(0xFF272727)),
                      _buildButton('9', const Color(0xFF272727)),
                      _buildButton('×', const Color(0xFF394734)),
                    ],
                  ),
                  const SizedBox(height: 10),
                  // hàng 3
                  Row(
                    children: [
                      _buildButton('4', const Color(0xFF272727)),
                      _buildButton('5', const Color(0xFF272727)),
                      _buildButton('6', const Color(0xFF272727)),
                      _buildButton('-', const Color(0xFF394734)),
                    ],
                  ),
                  const SizedBox(height: 10),
                  // hàng 4
                  Row(
                    children: [
                      _buildButton('1', const Color(0xFF272727)),
                      _buildButton('2', const Color(0xFF272727)),
                      _buildButton('3', const Color(0xFF272727)),
                      _buildButton('+', const Color(0xFF394734)),
                    ],
                  ),
                  const SizedBox(height: 10),
                  // hàng 5
                  Row(
                    children: [
                      _buildButton('+/-', const Color(0xFF272727)),
                      _buildButton('0', const Color(0xFF272727)),
                      _buildButton('.', const Color(0xFF272727)),
                      _buildButton('=', const Color(0xFF076544)),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
