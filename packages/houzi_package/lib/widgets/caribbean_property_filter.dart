import 'package:flutter/material.dart';
import '../../constants/suristay_colors.dart';

class PropertyFilterCriteria {
  final int? bedrooms;
  final int? bathrooms;
  final double minPrice;
  final double maxPrice;
  final String? propertyType;
  final String? selectedCity;
  final bool nearSea;
  final bool hasPool;
  final bool hasGym;
  final bool hasSecurity;
  final bool hasGarden;
  final bool hasBalcony;
  final bool hasParking;
  final String? furnished;
  final int? constructionYear;

  PropertyFilterCriteria({
    this.bedrooms,
    this.bathrooms,
    this.minPrice = 0,
    this.maxPrice = 2000000,
    this.propertyType,
    this.selectedCity,
    this.nearSea = false,
    this.hasPool = false,
    this.hasGym = false,
    this.hasSecurity = false,
    this.hasGarden = false,
    this.hasBalcony = false,
    this.hasParking = false,
    this.furnished,
    this.constructionYear,
  });

  @override
  String toString() {
    return 'PropertyFilterCriteria(bedrooms: $bedrooms, bathrooms: $bathrooms, price: \$${minPrice.toInt()}-\$${maxPrice.toInt()}, type: $propertyType, city: $selectedCity, nearSea: $nearSea, hasPool: $hasPool, furnished: $furnished)';
  }
}

class CaribbeanPropertyFilter extends StatefulWidget {
  final Function(PropertyFilterCriteria) onFiltersChanged;
  
  const CaribbeanPropertyFilter({
    Key? key,
    required this.onFiltersChanged,
  }) : super(key: key);

  @override
  State<CaribbeanPropertyFilter> createState() => _CaribbeanPropertyFilterState();
}

class _CaribbeanPropertyFilterState extends State<CaribbeanPropertyFilter>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _expandAnimation;
  bool _isExpanded = false; // Start closed by default

  // Filter values
  String? selectedPropertyType;
  String? selectedCity;
  RangeValues priceRange = const RangeValues(0, 2000000);
  RangeValues areaRange = const RangeValues(0, 1000);
  int? selectedBedrooms;
  int? selectedBathrooms;
  String? selectedFeature;
  bool nearBeach = false;
  bool furnished = false;
  bool hasPool = false;
  bool hasGarden = false;
  bool hasParking = false;
  bool newConstruction = false;
  bool oceanView = false;
  bool gatedCommunity = false;

  // Filter options
  final List<String> propertyTypes = [
    'Apartment',
    'Villa',
    'House',
    'Condo',
    'Townhouse',
    'Penthouse',
    'Beach House',
    'Resort Property',
    'Commercial',
    'Land/Plot'
  ];

  final List<String> caribbeanCities = [
    'Kingston, Jamaica',
    'Nassau, Bahamas',
    'Port of Spain, Trinidad',
    'Port-au-Prince, Haiti',
    'Santo Domingo, Dominican Republic',
    'San Juan, Puerto Rico',
    'Bridgetown, Barbados',
    'Willemstad, Curaçao',
    'Oranjestad, Aruba',
    'Castries, Saint Lucia',
    'St. George\'s, Grenada',
    'Fort-de-France, Martinique',
    'Pointe-à-Pitre, Guadeloupe',
    'Road Town, British Virgin Islands',
    'Charlotte Amalie, US Virgin Islands'
  ];

  final List<String> specialFeatures = [
    'Beachfront',
    'Waterfront',
    'Mountain View',
    'City Center',
    'Golf Course Access',
    'Marina Access',
    'Historic Property',
    'Eco-Friendly',
    'Smart Home',
    'Investment Property'
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
      value: 0.0, // Start closed
    );
    _expandAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _toggleExpansion() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    });
  }

  PropertyFilterCriteria _getCurrentFilters() {
    return PropertyFilterCriteria(
      propertyType: selectedPropertyType,
      selectedCity: selectedCity,
      minPrice: priceRange.start,
      maxPrice: priceRange.end,
      bedrooms: selectedBedrooms,
      bathrooms: selectedBathrooms,
      nearSea: nearBeach,
      hasPool: hasPool,
      hasGarden: hasGarden,
      hasParking: hasParking,
      furnished: furnished ? 'Yes' : 'No',
      hasSecurity: gatedCommunity,
      hasBalcony: oceanView,
      hasGym: false, // You can map this to one of your existing features if needed
    );
  }

  void _applyFilters() {
    widget.onFiltersChanged(_getCurrentFilters());
    _toggleExpansion();
  }

  void _clearFilters() {
    setState(() {
      selectedPropertyType = null;
      selectedCity = null;
      priceRange = const RangeValues(0, 2000000);
      areaRange = const RangeValues(0, 1000);
      selectedBedrooms = null;
      selectedBathrooms = null;
      selectedFeature = null;
      nearBeach = false;
      furnished = false;
      hasPool = false;
      hasGarden = false;
      hasParking = false;
      newConstruction = false;
      oceanView = false;
      gatedCommunity = false;
    });
    widget.onFiltersChanged(PropertyFilterCriteria());
  }

  @override
  Widget build(BuildContext context) {
    print('🔍 CaribbeanPropertyFilter building...'); // Debug log
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      decoration: BoxDecoration(
        color: Colors.lightBlue.shade50, // More visible background
        border: Border.all(color: SuriStayColors.darkGreen, width: 2), // Debug border
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          // Filter Header
          InkWell(
            onTap: _toggleExpansion,
            borderRadius: BorderRadius.circular(15),
            child: Container(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  Icon(
                    Icons.tune,
                    color: SuriStayColors.darkGreen,
                    size: 24,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Property Filters',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: SuriStayColors.darkGreen,
                      ),
                    ),
                  ),
                  AnimatedRotation(
                    turns: _isExpanded ? 0.5 : 0.0,
                    duration: const Duration(milliseconds: 300),
                    child: Icon(
                      Icons.keyboard_arrow_down,
                      color: SuriStayColors.darkGreen,
                      size: 28,
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // Expandable Filter Content
          SizeTransition(
            sizeFactor: _expandAnimation,
            child: Container(
              padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Divider(),
                  const SizedBox(height: 15),
                  
                  // Property Type & City Row
                  Row(
                    children: [
                      Expanded(
                        child: _buildDropdown(
                          'Property Type',
                          selectedPropertyType,
                          propertyTypes,
                          (value) => setState(() => selectedPropertyType = value),
                        ),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: _buildDropdown(
                          'City',
                          selectedCity,
                          caribbeanCities,
                          (value) => setState(() => selectedCity = value),
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 20),
                  
                  // Price Range
                  _buildRangeSlider(
                    'Price Range (USD)',
                    priceRange,
                    0,
                    5000000,
                    (values) => setState(() => priceRange = values),
                    (value) => '\$${value.round()}',
                  ),
                  
                  const SizedBox(height: 20),
                  
                  // Area Range
                  _buildRangeSlider(
                    'Area (sqm)',
                    areaRange,
                    0,
                    2000,
                    (values) => setState(() => areaRange = values),
                    (value) => '${value.round()}m²',
                  ),
                  
                  const SizedBox(height: 20),
                  
                  // Bedrooms & Bathrooms
                  Row(
                    children: [
                      Expanded(
                        child: _buildNumberSelector(
                          'Bedrooms',
                          selectedBedrooms,
                          [1, 2, 3, 4, 5, 6],
                          (value) => setState(() => selectedBedrooms = value),
                        ),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: _buildNumberSelector(
                          'Bathrooms',
                          selectedBathrooms,
                          [1, 2, 3, 4, 5, 6],
                          (value) => setState(() => selectedBathrooms = value),
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 20),
                  
                  // Special Features
                  _buildDropdown(
                    'Special Features',
                    selectedFeature,
                    specialFeatures,
                    (value) => setState(() => selectedFeature = value),
                  ),
                  
                  const SizedBox(height: 20),
                  
                  // Amenities Checkboxes
                  Text(
                    'Amenities & Features',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: SuriStayColors.darkGreen,
                    ),
                  ),
                  const SizedBox(height: 10),
                  
                  _buildCheckboxGrid([
                    {'label': 'Near Beach', 'value': nearBeach, 'onChanged': (val) => setState(() => nearBeach = val!)},
                    {'label': 'Ocean View', 'value': oceanView, 'onChanged': (val) => setState(() => oceanView = val!)},
                    {'label': 'Swimming Pool', 'value': hasPool, 'onChanged': (val) => setState(() => hasPool = val!)},
                    {'label': 'Garden', 'value': hasGarden, 'onChanged': (val) => setState(() => hasGarden = val!)},
                    {'label': 'Parking', 'value': hasParking, 'onChanged': (val) => setState(() => hasParking = val!)},
                    {'label': 'Furnished', 'value': furnished, 'onChanged': (val) => setState(() => furnished = val!)},
                    {'label': 'New Construction', 'value': newConstruction, 'onChanged': (val) => setState(() => newConstruction = val!)},
                    {'label': 'Gated Community', 'value': gatedCommunity, 'onChanged': (val) => setState(() => gatedCommunity = val!)},
                  ]),
                  
                  const SizedBox(height: 25),
                  
                  // Action Buttons
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: _clearFilters,
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(color: SuriStayColors.darkGreen),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 15),
                          ),
                          child: Text(
                            'Clear All',
                            style: TextStyle(
                              color: SuriStayColors.darkGreen,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: _applyFilters,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: SuriStayColors.warningOrange,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 15),
                          ),
                          child: const Text(
                            'Apply Filters',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
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

  Widget _buildDropdown(String label, String? selectedValue, List<String> options, Function(String?) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: SuriStayColors.darkGreen,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(10),
          ),
          child: DropdownButtonFormField<String>(
            value: selectedValue,
            decoration: const InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 12),
            ),
            hint: Text(
              label == 'Property Type' ? 'Select Type' : 'Select City',
              style: const TextStyle(fontSize: 13),
              overflow: TextOverflow.ellipsis,
            ),
            items: options.map((option) => DropdownMenuItem(
              value: option,
              child: Text(
                option, 
                style: const TextStyle(fontSize: 13),
                overflow: TextOverflow.ellipsis,
              ),
            )).toList(),
            onChanged: onChanged,
            isExpanded: true,
          ),
        ),
      ],
    );
  }

  Widget _buildRangeSlider(String label, RangeValues values, double min, double max, Function(RangeValues) onChanged, String Function(double) formatValue) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: SuriStayColors.darkGreen,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Text(formatValue(values.start)),
            Expanded(
              child: RangeSlider(
                values: values,
                min: min,
                max: max,
                divisions: 20,
                activeColor: SuriStayColors.warningOrange,
                inactiveColor: SuriStayColors.warningOrange.withOpacity(0.3),
                onChanged: onChanged,
              ),
            ),
            Text(formatValue(values.end)),
          ],
        ),
      ],
    );
  }

  Widget _buildNumberSelector(String label, int? selectedValue, List<int> options, Function(int?) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: SuriStayColors.darkGreen,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          height: 50,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: options.map((number) {
              final isSelected = selectedValue == number;
              return Expanded(
                child: GestureDetector(
                  onTap: () => onChanged(isSelected ? null : number),
                  child: Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: isSelected ? SuriStayColors.warningOrange : Colors.transparent,
                      border: Border(
                        right: number != options.last ? BorderSide(color: Colors.grey.shade300) : BorderSide.none,
                      ),
                    ),
                    child: Text(
                      number.toString(),
                      style: TextStyle(
                        color: isSelected ? Colors.white : Colors.black,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildCheckboxGrid(List<Map<String, dynamic>> checkboxes) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      childAspectRatio: 4,
      children: checkboxes.map((checkbox) {
        return CheckboxListTile(
          title: Text(
            checkbox['label'],
            style: const TextStyle(fontSize: 13),
          ),
          value: checkbox['value'],
          onChanged: checkbox['onChanged'],
          activeColor: SuriStayColors.warningOrange,
          dense: true,
          contentPadding: EdgeInsets.zero,
        );
      }).toList(),
    );
  }
}
