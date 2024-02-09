import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:projeto_imobiliaria/core/models/imobiliaria_form_data.dart';

class CadImobiliariaForm extends StatefulWidget {
  final bool isDarkMode;
  final void Function(ImobiliariaFormData) onSubmit;

  const CadImobiliariaForm(
      {Key? key, required this.isDarkMode, required this.onSubmit})
      : super(key: key);

  @override
  State<CadImobiliariaForm> createState() => _CadImobiliariaFormState();
}

class _CadImobiliariaFormState extends State<CadImobiliariaForm> {
  bool loading = false;
  final _formKey = GlobalKey<FormState>();
  final _formData = ImobiliariaFormData();

  void _submit() {
    final isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid) return;

    if (_formData.nome == '' || _formData.url_base == '') {
      return _showError('Preencha os campos.');
    }

    widget.onSubmit(_formData);
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: Theme.of(context).errorColor,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Card(
        margin: const EdgeInsets.all(20),
        child: Container(
          decoration: BoxDecoration(
            color: !widget.isDarkMode ? Colors.white : Colors.black38,
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding:
                        EdgeInsets.all(15), //apply padding to all four sides
                    child: Text(
                      "Nome",
                      style: TextStyle(
                        color: Color(0xFF6e58e9),
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  TextFormField(
                    key: const ValueKey('name'),
                    initialValue: _formData.nome,
                    onChanged: (name) => _formData.nome = name,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.black12,
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    style: TextStyle(
                        color:
                            !widget.isDarkMode ? Colors.black : Colors.white),
                    validator: (localName) {
                      final name = localName ?? '';
                      if (name.trim().length < 5) {
                        return 'Nome deve ter no mínimo 5 caracteres.';
                      }
                      return null;
                    },
                  ),
                  Padding(
                    padding:
                        EdgeInsets.all(15), //apply padding to all four sides
                    child: Text(
                      "Link Imobiliaria",
                      style: TextStyle(
                        color: Color(0xFF6e58e9),
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                    TextFormField(
  key: const ValueKey('url_base'),
  initialValue: _formData.url_base,
  onChanged: (url_base) => _formData.url_base = url_base,
  decoration: InputDecoration(
    filled: true,
    fillColor: Colors.black12,
    border: OutlineInputBorder(
      borderSide: BorderSide.none,
      borderRadius: BorderRadius.circular(20),
    ),
    
  ),
   style: TextStyle(color: !widget.isDarkMode ? Colors.black : Colors.white), 
  validator: (localName) {
    final name = localName ?? '';
    if (name.trim().length < 5) {
      return 'Nome deve ter no mínimo 5 caracteres.';
    }
    return null;
  },
),
                  Padding(
                    padding:
                        EdgeInsets.all(15), //apply padding to all four sides
                    child: Text(
                      "Link URL",
                      style: TextStyle(
                        color: Color(0xFF6e58e9),
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                    TextFormField(
  key: const ValueKey('url_logo'),
  initialValue: _formData.url_logo,
  onChanged: (url_logo) => _formData.url_logo = url_logo,
  decoration: InputDecoration(
    filled: true,
    fillColor: Colors.black12,
    border: OutlineInputBorder(
      borderSide: BorderSide.none,
      borderRadius: BorderRadius.circular(20),
    ),
    
  ),
   style: TextStyle(color: !widget.isDarkMode ? Colors.black : Colors.white), 
  validator: (localName) {
    final name = localName ?? '';
    if (name.trim().length < 5) {
      return 'Nome deve ter no mínimo 5 caracteres.';
    }
    return null;
  },
),
                  SizedBox(
                    height: 10,
                  ),
                  ElevatedButton(
                    onPressed: _submit,
                    child: Text('Salvar'),
                    style: ElevatedButton.styleFrom(
                      elevation: 10.0,
                      backgroundColor: Color(0xFF6e58e9),
                      padding: EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 20.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
