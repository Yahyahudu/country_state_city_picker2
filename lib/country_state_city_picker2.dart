library country_state_city_picker2;

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'model/select_status_model.dart' as StatusModel;

class SelectState extends StatefulWidget {
  final ValueChanged<String?> onCountryChanged;
  final ValueChanged<String?> onStateChanged;
  final ValueChanged<String?> onCityChanged;
  final TextStyle? style;
  final Color? dropdownColor;

  // Country parameters
  final String? countryLabel;
  final bool countryIsOptional;
  final String? countryHint;
  final InputDecoration? countryDecoration;
  final String? Function(String?)? countryValidator;

  // State parameters
  final String? stateLabel;
  final bool stateIsOptional;
  final String? stateHint;
  final InputDecoration? stateDecoration;
  final String? Function(String?)? stateValidator;

  // City parameters
  final String? cityLabel;
  final bool cityIsOptional;
  final String? cityHint;
  final InputDecoration? cityDecoration;
  final String? Function(String?)? cityValidator;

  const SelectState({
    Key? key,
    required this.onCountryChanged,
    required this.onStateChanged,
    required this.onCityChanged,
    this.style,
    this.dropdownColor,
    this.countryLabel,
    this.countryIsOptional = false,
    this.countryHint,
    this.countryDecoration,
    this.countryValidator,
    this.stateLabel,
    this.stateIsOptional = false,
    this.stateHint,
    this.stateDecoration,
    this.stateValidator,
    this.cityLabel,
    this.cityIsOptional = false,
    this.cityHint,
    this.cityDecoration,
    this.cityValidator,
  }) : super(key: key);

  @override
  _SelectStateState createState() => _SelectStateState();
}

class _SelectStateState extends State<SelectState> {
  List<String> _cities = [];
  List<String> _countries = [];
  List<String> _states = [];
  String? _selectedCity;
  String? _selectedCountry;
  String? _selectedState;

  bool _isCountryFocused = false;
  bool _isStateFocused = false;
  bool _isCityFocused = false;
  late FocusNode _countryFocusNode;
  late FocusNode _stateFocusNode;
  late FocusNode _cityFocusNode;

  @override
  void initState() {
    _countryFocusNode = FocusNode();
    _stateFocusNode = FocusNode();
    _cityFocusNode = FocusNode();
    _setupFocusListeners();
    getCountries();
    super.initState();
  }

  void _setupFocusListeners() {
    _countryFocusNode.addListener(() => setState(() => _isCountryFocused = _countryFocusNode.hasFocus));
    _stateFocusNode.addListener(() => setState(() => _isStateFocused = _stateFocusNode.hasFocus));
    _cityFocusNode.addListener(() => setState(() => _isCityFocused = _cityFocusNode.hasFocus));
  }

  @override
  void dispose() {
    _countryFocusNode.dispose();
    _stateFocusNode.dispose();
    _cityFocusNode.dispose();
    super.dispose();
  }

  Future<dynamic> getResponse() async {
    final res = await rootBundle.loadString('packages/country_state_city_picker/lib/assets/country.json');
    return jsonDecode(res);
  }

  Future<void> getCountries() async {
    final response = await getResponse();
    final countries = response
        .map<String>((data) => '${data['emoji']}    ${data['name']}')
        .toList();
    if (mounted) {
      setState(() => _countries = countries);
    }
  }

  Future<void> getStates() async {
    if (_selectedCountry == null) return;
    
    final response = await getResponse();
    final states = response
        .map((map) => StatusModel.StatusModel.fromJson(map))
        .where((item) => '${item.emoji}    ${item.name}' == _selectedCountry)
        .expand((item) => item.state ?? [])
        .map<String>((state) => state.name)
        .toList();

    if (mounted) {
      setState(() => _states = states);
    }
  }

  Future<void> getCities() async {
    if (_selectedCountry == null || _selectedState == null) return;

    final response = await getResponse();
    final cities = response
        .map((map) => StatusModel.StatusModel.fromJson(map))
        .where((item) => '${item.emoji}    ${item.name}' == _selectedCountry)
        .expand((item) => item.state ?? [])
        .where((state) => state.name == _selectedState)
        .expand((state) => state.city ?? [])
        .map<String>((city) => city.name)
        .toList();

    if (mounted) {
      setState(() => _cities = cities);
    }
  }

  InputDecoration _buildDecoration(InputDecoration? baseDecoration, String hint, bool isFocused) {
    return (baseDecoration ?? const InputDecoration()).copyWith(
      hintText: hint,
      contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
      filled: true,
      fillColor: isFocused ? Colors.green.shade50 : Colors.grey.shade50,
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Colors.grey.shade300, width: 1.5),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Colors.green, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Colors.red, width: 1.5),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Colors.red, width: 2),
      ),
    );
  }

  Widget _buildDropdown({
    required String? label,
    required bool isOptional,
    required String? hint,
    required InputDecoration? decoration,
    required String? value,
    required List<String> items,
    required FocusNode focusNode,
    required bool isFocused,
    required ValueChanged<String?> onChanged,
    required String? Function(String?)? validator,
    required String type,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null)
          Row(children: [
            Text(label, style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.grey.shade700,
            )),
            if (isOptional)
              Padding(
                padding: const EdgeInsets.only(left: 4),
                child: Text('(Optional)', style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade500,
                )),
              ),
          ]),
        if (label != null) const SizedBox(height: 8),
        AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            boxShadow: isFocused ? [
              BoxShadow(
                color: Colors.green.withOpacity(0.1),
                blurRadius: 8,
                spreadRadius: 2,
                offset: const Offset(0, 2),
              )
            ] : [],
          ),
          child: DropdownButtonFormField<String>(
            value: value,
            focusNode: focusNode,
            decoration: _buildDecoration(decoration, hint ?? 'Choose $type', isFocused),
            items: items.map((String value) => DropdownMenuItem(
              value: value,
              child: Text(value, style: widget.style),
            )).toList(),
            onChanged: onChanged,
            validator: validator,
            dropdownColor: widget.dropdownColor,
            isExpanded: true,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildDropdown(
          label: widget.countryLabel,
          isOptional: widget.countryIsOptional,
          hint: widget.countryHint,
          decoration: widget.countryDecoration,
          value: _selectedCountry,
          items: _countries,
          focusNode: _countryFocusNode,
          isFocused: _isCountryFocused,
          onChanged: (value) {
            setState(() {
              _selectedCountry = value;
              _selectedState = null;
              _selectedCity = null;
              _states.clear();
              _cities.clear();
              widget.onCountryChanged(value);
              getStates();
            });
          },
          validator: widget.countryValidator,
          type: 'Country',
        ),
        const SizedBox(height: 16),
        _buildDropdown(
          label: widget.stateLabel,
          isOptional: widget.stateIsOptional,
          hint: widget.stateHint,
          decoration: widget.stateDecoration,
          value: _selectedState,
          items: _states,
          focusNode: _stateFocusNode,
          isFocused: _isStateFocused,
          onChanged: (value) {
            setState(() {
              _selectedState = value;
              _selectedCity = null;
              _cities.clear();
              widget.onStateChanged(value);
              getCities();
            });
          },
          validator: widget.stateValidator,
          type: 'State',
        ),
        const SizedBox(height: 16),
        _buildDropdown(
          label: widget.cityLabel,
          isOptional: widget.cityIsOptional,
          hint: widget.cityHint,
          decoration: widget.cityDecoration,
          value: _selectedCity,
          items: _cities,
          focusNode: _cityFocusNode,
          isFocused: _isCityFocused,
          onChanged: (value) {
            setState(() => _selectedCity = value);
            widget.onCityChanged(value);
          },
          validator: widget.cityValidator,
          type: 'City',
        ),
      ],
    );
  }
}