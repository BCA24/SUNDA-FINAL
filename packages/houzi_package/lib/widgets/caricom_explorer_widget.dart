import 'package:flutter/material.dart';
import 'package:houzi_package/files/app_preferences/app_preferences.dart';
import 'package:houzi_package/pages/map_view.dart';

class CaricomExplorerWidget extends StatefulWidget {
  final Function(String)? onCountrySelected;
  
  const CaricomExplorerWidget({
    Key? key,
    this.onCountrySelected,
  }) : super(key: key);

  @override
  State<CaricomExplorerWidget> createState() => _CaricomExplorerWidgetState();
}

class _CaricomExplorerWidgetState extends State<CaricomExplorerWidget> {
  int selectedRegionIndex = 0;
  
  final List<String> regions = ['West Caribbean', 'East Caribbean', 'Mainland'];
  
  final Map<String, List<CaricomCountry>> regionCountries = {
    'West Caribbean': [
      CaricomCountry('JM', 'Jamaica', '4.2K properties', '🇯🇲'),
      CaricomCountry('BS', 'Bahamas', '3.8K properties', '🇧🇸'),
      CaricomCountry('TT', 'Trinidad', '2.7K properties', '🇹🇹'),
      CaricomCountry('BZ', 'Belize', '890 properties', '🇧🇿'),
      CaricomCountry('HT', 'Haiti', '1.2K properties', '🇭🇹'),
      CaricomCountry('MS', 'Montserrat', '156 properties', '🇲🇸'),
    ],
    'East Caribbean': [
      CaricomCountry('BB', 'Barbados', '3.1K properties', '🇧🇧'),
      CaricomCountry('AG', 'Antigua', '1.4K properties', '🇦🇬'),
      CaricomCountry('GD', 'Grenada', '892 properties', '🇬🇩'),
      CaricomCountry('LC', 'St. Lucia', '1.2K properties', '🇱🇨'),
      CaricomCountry('DM', 'Dominica', '675 properties', '🇩🇲'),
      CaricomCountry('VC', 'St. Vincent', '543 properties', '🇻🇨'),
    ],
    'Mainland': [
      CaricomCountry('GY', 'Guyana', '2.3K properties', '🇬🇾'),
      CaricomCountry('SR', 'Suriname', '1.8K properties', '🇸🇷'),
    ],
  };

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(20),
      child: Column(
        children: [
          _buildHeader(),
          const SizedBox(height: 20),
          _buildRegionTabs(),
          const SizedBox(height: 20),
          _buildCountryGrid(),
          const SizedBox(height: 20),
          _buildMapSearchButton(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF009688), Color(0xFF4CAF50)],
        ),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('🌴', style: TextStyle(fontSize: 24)),
              SizedBox(width: 8),
              Text(
                'CARICOM Explorer',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Discover Caribbean Paradise',
            style: TextStyle(
              fontSize: 14,
              color: Colors.white.withOpacity(0.9),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRegionTabs() {
    return Row(
      children: regions.asMap().entries.map((entry) {
        int index = entry.key;
        String region = entry.value;
        bool isActive = selectedRegionIndex == index;
        
        return Expanded(
          child: GestureDetector(
            onTap: () {
              setState(() {
                selectedRegionIndex = index;
              });
            },
            child: Container(
              margin: EdgeInsets.only(right: index < regions.length - 1 ? 8 : 0),
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
              decoration: BoxDecoration(
                gradient: isActive 
                  ? const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Color(0xFF009688), Color(0xFF4CAF50)],
                    )
                  : null,
                color: isActive ? null : const Color(0xFFF5F5F5),
                borderRadius: BorderRadius.circular(25),
                boxShadow: isActive ? [
                  BoxShadow(
                    color: const Color(0xFF009688).withOpacity(0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ] : null,
              ),
              child: Text(
                _getRegionDisplayName(region),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: isActive ? Colors.white : const Color(0xFF666666),
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  String _getRegionDisplayName(String region) {
    switch (region) {
      case 'West Caribbean':
        return '🌴 West Caribbean';
      case 'East Caribbean':
        return '🌴 East Caribbean';
      case 'Mainland':
        return '🏛️ Mainland';
      default:
        return region;
    }
  }

  Widget _buildCountryGrid() {
    String selectedRegion = regions[selectedRegionIndex];
    List<CaricomCountry> countries = regionCountries[selectedRegion] ?? [];
    
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 15,
        mainAxisSpacing: 15,
        childAspectRatio: 1.1,
      ),
      itemCount: countries.length,
      itemBuilder: (context, index) {
        return _buildCountryCard(countries[index]);
      },
    );
  }

  Widget _buildCountryCard(CaricomCountry country) {
    return GestureDetector(
      onTap: () {
        if (widget.onCountrySelected != null) {
          widget.onCountrySelected!(country.name);
        }
        _showCountryDialog(country);
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: Colors.transparent, width: 2),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 45,
              height: 45,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF009688), Color(0xFF4CAF50)],
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Text(
                  country.code,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              country.name,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFF333333),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              country.properties,
              style: const TextStyle(
                fontSize: 11,
                color: Color(0xFF666666),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMapSearchButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MapView(
                [],
                showWaitingWidget: false,
                zoomToAllLocations: true,
                selectedArticleIndex: -1,
                snapCameraToSelectedIndex: false,
                googleMapsKey: const Key('caricom_map'),
                hideMap: false,
              ),
            ),
          );
        },
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 15),
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
        ).copyWith(
          backgroundColor: MaterialStateProperty.all(Colors.transparent),
        ),
        child: Ink(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF009688), Color(0xFF4CAF50)],
            ),
            borderRadius: BorderRadius.circular(25),
          ),
          child: Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(vertical: 15),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('🗺️', style: TextStyle(fontSize: 18)),
                SizedBox(width: 8),
                Text(
                  'Search on Maps',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showCountryDialog(CaricomCountry country) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: Row(
            children: [
              Text(country.flag, style: const TextStyle(fontSize: 24)),
              const SizedBox(width: 10),
              Text(
                'Welcome to ${country.name}!',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          content: Text(
            'Exploring properties in ${country.name}...\n\n${country.properties} available',
            style: const TextStyle(fontSize: 16),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(
                'Close',
                style: TextStyle(color: Color(0xFF009688)),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                // Here you would typically navigate to properties for this country
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF009688),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'View Properties',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }
}

class CaricomCountry {
  final String code;
  final String name;
  final String properties;
  final String flag;

  CaricomCountry(this.code, this.name, this.properties, this.flag);
}
