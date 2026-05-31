import 'package:flutter/material.dart';
import 'package:houzi_package/files/app_preferences/app_preferences.dart';
import 'package:houzi_package/files/generic_methods/utility_methods.dart';
import 'package:houzi_package/widgets/generic_text_widget.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class CaricomCountryDropdown extends StatefulWidget {
  final String? initialCountryCode;
  final String? initialCountryName;
  final Function(Map<String, dynamic>) onCountrySelected;
  final bool isRequired;

  const CaricomCountryDropdown({
    Key? key,
    this.initialCountryCode,
    this.initialCountryName,
    required this.onCountrySelected,
    this.isRequired = true,
  }) : super(key: key);

  @override
  State<CaricomCountryDropdown> createState() => _CaricomCountryDropdownState();
}

class _CaricomCountryDropdownState extends State<CaricomCountryDropdown> {
  List<Map<String, dynamic>> _countries = [];
  Map<String, dynamic>? _selectedCountry;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadCountries();
  }

  Future<void> _loadCountries() async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });

      // HARDCODED with EXACT database IDs - no API needed!
      setState(() {
        _countries = [
          {'id': 1, 'code': 'JAM', 'name': 'Jamaica', 'region': 'West', 'currency_code': 'JMD', 'property_count': 0},
          {'id': 2, 'code': 'BHS', 'name': 'Bahamas', 'region': 'West', 'currency_code': 'BSD', 'property_count': 0},
          {'id': 3, 'code': 'CUB', 'name': 'Cuba', 'region': 'West', 'currency_code': 'CUP', 'property_count': 0},
          {'id': 4, 'code': 'HTI', 'name': 'Haiti', 'region': 'West', 'currency_code': 'HTG', 'property_count': 0},
          {'id': 5, 'code': 'DOM', 'name': 'Dominican Republic', 'region': 'West', 'currency_code': 'DOP', 'property_count': 0},
          {'id': 6, 'code': 'PRI', 'name': 'Puerto Rico', 'region': 'West', 'currency_code': 'USD', 'property_count': 0},
          {'id': 7, 'code': 'TTO', 'name': 'Trinidad and Tobago', 'region': 'West', 'currency_code': 'TTD', 'property_count': 0},
          {'id': 8, 'code': 'CUW', 'name': 'Curaçao', 'region': 'West', 'currency_code': 'ANG', 'property_count': 0},
          {'id': 9, 'code': 'ABW', 'name': 'Aruba', 'region': 'West', 'currency_code': 'AWG', 'property_count': 0},
          {'id': 10, 'code': 'BRB', 'name': 'Barbados', 'region': 'East', 'currency_code': 'BBD', 'property_count': 0},
          {'id': 11, 'code': 'LCA', 'name': 'Saint Lucia', 'region': 'East', 'currency_code': 'XCD', 'property_count': 0},
          {'id': 12, 'code': 'GRD', 'name': 'Grenada', 'region': 'East', 'currency_code': 'XCD', 'property_count': 0},
          {'id': 13, 'code': 'VCT', 'name': 'Saint Vincent and the Grenadines', 'region': 'East', 'currency_code': 'XCD', 'property_count': 0},
          {'id': 14, 'code': 'DMA', 'name': 'Dominica', 'region': 'East', 'currency_code': 'XCD', 'property_count': 0},
          {'id': 15, 'code': 'ATG', 'name': 'Antigua and Barbuda', 'region': 'East', 'currency_code': 'XCD', 'property_count': 0},
          {'id': 16, 'code': 'KNA', 'name': 'Saint Kitts and Nevis', 'region': 'East', 'currency_code': 'XCD', 'property_count': 0},
          {'id': 17, 'code': 'MTQ', 'name': 'Martinique', 'region': 'East', 'currency_code': 'EUR', 'property_count': 0},
          {'id': 18, 'code': 'GLP', 'name': 'Guadeloupe', 'region': 'East', 'currency_code': 'EUR', 'property_count': 0},
          {'id': 19, 'code': 'VGB', 'name': 'British Virgin Islands', 'region': 'East', 'currency_code': 'USD', 'property_count': 0},
          {'id': 20, 'code': 'VIR', 'name': 'US Virgin Islands', 'region': 'East', 'currency_code': 'USD', 'property_count': 0},
          {'id': 21, 'code': 'GUY', 'name': 'Guyana', 'region': 'Mainland', 'currency_code': 'GYD', 'property_count': 0},
          {'id': 22, 'code': 'SUR', 'name': 'Suriname', 'region': 'Mainland', 'currency_code': 'SRD', 'property_count': 0},
          {'id': 23, 'code': 'GUF', 'name': 'French Guiana', 'region': 'Mainland', 'currency_code': 'EUR', 'property_count': 0},
          {'id': 24, 'code': 'BLZ', 'name': 'Belize', 'region': 'Mainland', 'currency_code': 'BZD', 'property_count': 0},
        ];
          
        _isLoading = false;

        // Set initial selection
        if (widget.initialCountryCode != null) {
          _selectedCountry = _countries.firstWhere(
            (c) => c['code'] == widget.initialCountryCode,
            orElse: () => _countries.isNotEmpty ? _countries[0] : {},
          );
        } else if (widget.initialCountryName != null) {
          _selectedCountry = _countries.firstWhere(
            (c) => c['name'] == widget.initialCountryName,
            orElse: () => _countries.isNotEmpty ? _countries[0] : {},
          );
        }
      });
    } catch (e) {
      print('Error loading countries: $e');
      setState(() {
        _error = 'Error: $e';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Container(
        padding: const EdgeInsets.only(top: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GenericTextWidget(
              'Country${widget.isRequired ? ' *' : ''}',
              style: AppThemePreferences().appTheme.labelTextStyle,
            ),
            SizedBox(height: 8),
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(
                  color: AppThemePreferences().appTheme.dividerColor!,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                  SizedBox(width: 12),
                  Text('Loading CARICOM countries...'),
                ],
              ),
            ),
          ],
        ),
      );
    }

    if (_error != null || _countries.isEmpty) {
      return Container(
        padding: const EdgeInsets.only(top: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GenericTextWidget(
              'Country${widget.isRequired ? ' *' : ''}',
              style: AppThemePreferences().appTheme.labelTextStyle,
            ),
            SizedBox(height: 8),
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.1),
                border: Border.all(color: Colors.red),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(Icons.error, color: Colors.red, size: 20),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Failed to load countries',
                          style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Make sure the API server is running',
                          style: TextStyle(color: Colors.red, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                  TextButton(
                    onPressed: _loadCountries,
                    child: Text('Retry'),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.only(top: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GenericTextWidget(
            'CARICOM Country${widget.isRequired ? ' *' : ''}',
            style: AppThemePreferences().appTheme.labelTextStyle,
          ),
          SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: AppThemePreferences().appTheme.dividerColor!,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: DropdownButtonFormField<Map<String, dynamic>>(
              value: _selectedCountry,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                border: InputBorder.none,
                hintText: 'Select a CARICOM country',
                hintStyle: AppThemePreferences().appTheme.hintTextStyle,
              ),
              isExpanded: true,
              icon: Icon(Icons.arrow_drop_down),
              items: _countries.map((country) {
                return DropdownMenuItem<Map<String, dynamic>>(
                  value: country,
                  child: Row(
                    children: [
                      Container(
                        width: 40,
                        child: Text(
                          country['code'],
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: AppThemePreferences().appTheme.primaryColor,
                          ),
                        ),
                      ),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          country['name'],
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (country['property_count'] > 0)
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppThemePreferences().appTheme.primaryColor?.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            '${country['property_count']}',
                            style: TextStyle(
                              fontSize: 11,
                              color: AppThemePreferences().appTheme.primaryColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                    ],
                  ),
                );
              }).toList(),
              onChanged: (Map<String, dynamic>? newValue) {
                if (newValue != null) {
                  setState(() {
                    _selectedCountry = newValue;
                  });
                  widget.onCountrySelected(newValue);
                }
              },
              validator: widget.isRequired
                  ? (value) {
                      if (value == null) {
                        return 'Please select a country';
                      }
                      return null;
                    }
                  : null,
            ),
          ),
          if (_selectedCountry != null)
            Padding(
              padding: const EdgeInsets.only(top: 8.0, left: 4),
              child: Text(
                'Region: ${_selectedCountry!['region']} • Currency: ${_selectedCountry!['currency_code']}',
                style: AppThemePreferences().appTheme.hintTextStyle?.copyWith(
                  fontSize: 12,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
