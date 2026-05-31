import 'package:flutter/material.dart';
import 'package:houzi_package/widgets/caribbean_map_placeholder.dart';
import 'constants/suristay_colors.dart';

class CaricomMapPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Caribbean Map'),
        backgroundColor: SuriStayColors.darkGreen,
      ),
      body: Container(
        color: SuriStayColors.darkGreen,
        child: CaribbeanMapPlaceholder(
          title: "Caribbean Real Estate Map",
          height: MediaQuery.of(context).size.height - 100,
          onCountrySelected: (country) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Selected $country - Properties available!'),
                backgroundColor: SuriStayColors.warningOrange,
              ),
            );
          },
        ),
      ),
    );
  }
}
