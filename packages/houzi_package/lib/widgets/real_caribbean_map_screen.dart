import 'package:flutter/material.dart';
import 'openstreet_caribbean_map.dart';
import '../pages/country_properties_page.dart';
import '../../constants/suristay_colors.dart';

class RealCaribbeanMapScreen extends StatefulWidget {
  final String? selectedCountry;

  const RealCaribbeanMapScreen({
    Key? key,
    this.selectedCountry,
  }) : super(key: key);

  @override
  State<RealCaribbeanMapScreen> createState() => _RealCaribbeanMapScreenState();
}

class _RealCaribbeanMapScreenState extends State<RealCaribbeanMapScreen> {
  String? selectedCountry;

  @override
  void initState() {
    super.initState();
    selectedCountry = widget.selectedCountry;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: SuriStayColors.darkGreen,
      appBar: AppBar(
        backgroundColor: SuriStayColors.darkGreen,
        title: Text(
          selectedCountry != null 
              ? '$selectedCountry Properties'
              : 'Caribbean Real Estate Map',
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: IconThemeData(color: Colors.white),
        actions: [
          if (selectedCountry != null)
            IconButton(
              icon: const Icon(Icons.clear),
              onPressed: () => setState(() => selectedCountry = null),
              tooltip: 'Show all countries',
            ),
        ],
      ),
      body: Container(
        child: OpenStreetCaribbeanMap(
          selectedCountry: selectedCountry,
          height: double.infinity,
          onCountrySelected: (country) {
            if (country.isNotEmpty) {
              // Navigate to country properties page
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => CountryPropertiesPage(
                    countryName: country,
                  ),
                ),
              );
            }
            
            setState(() {
              selectedCountry = selectedCountry == country ? null : country;
            });
          },
        ),
      ),
    );
  }
}
