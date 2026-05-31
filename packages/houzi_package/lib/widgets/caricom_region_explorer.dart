import 'package:flutter/material.dart';
import '../../constants/suristay_colors.dart';
import 'caribbean_map_widget.dart';
import 'real_caribbean_map_screen.dart';
import '../pages/country_properties_page.dart';
import 'caribbean_property_filter.dart';
import '../models/caribbean_property.dart';

class CaricomRegionExplorer extends StatefulWidget {
  const CaricomRegionExplorer({Key? key}) : super(key: key);

  @override
  State<CaricomRegionExplorer> createState() => _CaricomRegionExplorerState();
}

class _CaricomRegionExplorerState extends State<CaricomRegionExplorer> {
  int selectedRegion = 0;
  PropertyFilterCriteria? currentFilters;
  List<CaribbeanProperty> filteredProperties = [];

  final List<String> regions = ['West', 'East', 'Mainland'];
  
  final Map<String, List<CaricomCountry>> regionData = {
    'West': [
      CaricomCountry('Jamaica', 'JM', '4.2K properties', 18.1096, -77.2975),
      CaricomCountry('Bahamas', 'BS', '3.8K properties', 25.0343, -77.3963),
      CaricomCountry('Haiti', 'HT', '1.2K properties', 18.9712, -72.2852),
      CaricomCountry('Trinidad', 'TT', '2.7K properties', 10.6918, -61.2225),
      CaricomCountry('Belize', 'BZ', '890 properties', 17.1899, -88.4976),
      CaricomCountry('Montserrat', 'MS', '156 properties', 16.7425, -62.1874),
    ],
    'East': [
      CaricomCountry('Barbados', 'BB', '3.1K properties', 13.1939, -59.5432),
      CaricomCountry('Antigua', 'AG', '1.4K properties', 17.0608, -61.7964),
      CaricomCountry('Dominica', 'DM', '675 properties', 15.4150, -61.3710),
      CaricomCountry('Grenada', 'GD', '892 properties', 12.1165, -61.6790),
      CaricomCountry('St. Lucia', 'LC', '1.2K properties', 13.9094, -60.9789),
      CaricomCountry('St. Vincent', 'VC', '543 properties', 12.9843, -61.2872),
    ],
    'Mainland': [
      CaricomCountry('Guyana', 'GY', '2.3K properties', 4.8604, -58.9302),
      CaricomCountry('Suriname', 'SR', '1.8K properties', 3.9193, -56.0278),
    ],
  };

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: SuriStayColors.darkGreen,
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          const SizedBox(height: 20),
          // Add the property filter between header and region tabs
          CaribbeanPropertyFilter(
            onFiltersChanged: _onFiltersChanged,
          ),
          const SizedBox(height: 20),
          _buildRegionTabs(),
          const SizedBox(height: 20),
          _buildCountriesList(),
          const SizedBox(height: 20),
          _buildFilteredPropertiesSection(),
          const SizedBox(height: 20),
          _buildMapButton(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            SuriStayColors.turquoise.withOpacity(0.1),
            SuriStayColors.warningOrange.withOpacity(0.05),
          ],
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: SuriStayColors.warningOrange.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  '🌴',
                  style: TextStyle(fontSize: 32),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Select Your CARICOM Region',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Discover Caribbean Properties',
                      style: TextStyle(
                        fontSize: 16,
                        color: SuriStayColors.warningOrange,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRegionTabs() {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: regions.asMap().entries.map((entry) {
          int index = entry.key;
          String region = entry.value;
          bool isSelected = selectedRegion == index;
          
          return Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  selectedRegion = index;
                });
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                margin: EdgeInsets.only(right: index < regions.length - 1 ? 4 : 0),
                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                decoration: BoxDecoration(
                  gradient: isSelected ? LinearGradient(
                    colors: [
                      SuriStayColors.warningOrange,
                      SuriStayColors.vibrantRed,
                    ],
                  ) : null,
                  color: isSelected ? null : Colors.transparent,
                  borderRadius: BorderRadius.circular(26),
                  boxShadow: isSelected ? [
                    BoxShadow(
                      color: SuriStayColors.warningOrange.withOpacity(0.4),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ] : null,
                ),
                child: Text(
                  region,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: isSelected ? Colors.white : SuriStayColors.darkGreen,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildCountriesList() {
    String currentRegion = regions[selectedRegion];
    List<CaricomCountry> countries = regionData[currentRegion] ?? [];
    
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.1,
      ),
      itemCount: countries.length,
      itemBuilder: (context, index) {
        return _buildCountryCard(countries[index]);
      },
    );
  }

  Widget _buildCountryCard(CaricomCountry country) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => _showCountryDetails(country),
        borderRadius: BorderRadius.circular(15),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(
              color: SuriStayColors.warningOrange.withOpacity(0.3),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: SuriStayColors.warningOrange.withOpacity(0.2),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: SuriStayColors.warningOrange,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Center(
                  child: Text(
                    country.code,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                country.name,
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: SuriStayColors.darkGreen,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                country.propertyCount,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  color: SuriStayColors.turquoise,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMapButton() {
    return Container(
      margin: const EdgeInsets.only(top: 20),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: _openCaribbeanMap,
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 18),
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25),
            ),
          ),
          child: Ink(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  SuriStayColors.turquoise,
                  SuriStayColors.darkGreen,
                ],
              ),
              borderRadius: BorderRadius.circular(25),
            ),
            child: Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(vertical: 18),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.map, color: Colors.white, size: 24),
                  SizedBox(width: 12),
                  Text(
                    'Explore Caribbean Map',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
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

  void _showCountryDetails(CaricomCountry country) {
    // Direct navigation to property listings instead of showing dialog
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CountryPropertiesPage(countryName: country.name),
      ),
    );
  }

  void _openCaribbeanMap() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const RealCaribbeanMapScreen(),
      ),
    );
  }

  void _openCountryMap(CaricomCountry country) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CountryPropertiesPage(countryName: country.name),
      ),
    );
  }

  // Filter callback method
  void _onFiltersChanged(PropertyFilterCriteria filters) {
    setState(() {
      currentFilters = filters;
      // Apply filters to get filtered properties
      String currentRegion = regions[selectedRegion];
      filteredProperties = CaribbeanPropertyData.getFilteredProperties(
        region: currentRegion,
        propertyType: filters.propertyType,
        selectedCity: filters.selectedCity,
        minPrice: filters.minPrice,
        maxPrice: filters.maxPrice,
        bedrooms: filters.bedrooms,
        bathrooms: filters.bathrooms,
        nearSea: filters.nearSea,
        hasPool: filters.hasPool,
        hasGarden: filters.hasGarden,
        hasParking: filters.hasParking,
        furnished: filters.furnished == 'Yes',
        gatedCommunity: filters.hasSecurity,
        oceanView: filters.hasBalcony,
        newConstruction: filters.constructionYear != null && filters.constructionYear! > 2020,
      );
    });
    
    print('🔍 Filter applied: ${filters.toString()}');
    print('📊 Found ${filteredProperties.length} properties matching filters');
  }

  // Build filtered properties section
  Widget _buildFilteredPropertiesSection() {
    if (filteredProperties.isEmpty) {
      return Container(); // Don't show anything if no filters applied or no results
    }

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.filter_list,
                color: SuriStayColors.darkGreen,
                size: 24,
              ),
              const SizedBox(width: 8),
              Text(
                'Filtered Properties (${filteredProperties.length})',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: SuriStayColors.darkGreen,
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          SizedBox(
            height: 200,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: filteredProperties.length,
              itemBuilder: (context, index) {
                return _buildPropertyCard(filteredProperties[index]);
              },
            ),
          ),
        ],
      ),
    );
  }

  // Build individual property card
  Widget _buildPropertyCard(CaribbeanProperty property) {
    return Container(
      width: 280,
      margin: const EdgeInsets.only(right: 15),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: SuriStayColors.turquoise.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Property image placeholder
          Container(
            height: 100,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  SuriStayColors.turquoise.withOpacity(0.3),
                  SuriStayColors.warningOrange.withOpacity(0.3),
                ],
              ),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Center(
              child: Icon(
                Icons.home,
                size: 40,
                color: SuriStayColors.darkGreen,
              ),
            ),
          ),
          // Property details
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    property.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: SuriStayColors.darkGreen,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${property.city}, ${property.country}',
                    style: TextStyle(
                      fontSize: 12,
                      color: SuriStayColors.turquoise,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Text(
                        property.formattedPrice,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: SuriStayColors.warningOrange,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        '${property.bedrooms}BR',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CaricomCountry {
  final String name;
  final String code;
  final String propertyCount;
  final double latitude;
  final double longitude;

  CaricomCountry(this.name, this.code, this.propertyCount, this.latitude, this.longitude);
}
