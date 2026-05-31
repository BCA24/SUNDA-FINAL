import 'package:flutter/material.dart';
import '../../constants/suristay_colors.dart';
import 'caribbean_map_widget.dart';

class CaribbeanMapScreen extends StatefulWidget {
  final String? selectedCountry;

  const CaribbeanMapScreen({
    Key? key,
    this.selectedCountry,
  }) : super(key: key);

  @override
  State<CaribbeanMapScreen> createState() => _CaribbeanMapScreenState();
}

class _CaribbeanMapScreenState extends State<CaribbeanMapScreen> {
  String? selectedCountry;

  final Map<String, CountryInfo> countryDetails = {
    'Jamaica': CountryInfo(
      'Jamaica',
      'JM',
      '4.2K properties',
      'Known for its beautiful beaches, Blue Mountains, and vibrant culture. Popular areas include Kingston, Montego Bay, and Negril.',
      ['Beachfront Villas', 'Mountain Retreats', 'City Apartments', 'Resort Properties'],
    ),
    'Bahamas': CountryInfo(
      'Bahamas',
      'BS',
      '3.8K properties',
      'A tropical paradise with crystal-clear waters and pristine beaches. Nassau and Paradise Island are prime locations.',
      ['Luxury Resorts', 'Private Islands', 'Beachfront Condos', 'Marina Properties'],
    ),
    'Barbados': CountryInfo(
      'Barbados',
      'BB',
      '3.1K properties',
      'The gem of the Caribbean with stunning beaches and rich history. Bridgetown and St. Lawrence Gap are popular areas.',
      ['Plantation Houses', 'Beach Villas', 'Golf Course Properties', 'Historic Homes'],
    ),
    'Trinidad': CountryInfo(
      'Trinidad',
      'TT',
      '2.7K properties',
      'The larger island of Trinidad and Tobago, known for Carnival and diverse culture. Port of Spain is the capital.',
      ['Urban Properties', 'Suburban Homes', 'Commercial Spaces', 'Waterfront Properties'],
    ),
    'Guyana': CountryInfo(
      'Guyana',
      'GY',
      '2.3K properties',
      'The only English-speaking country in South America, rich in natural resources and rainforests.',
      ['City Properties', 'Rural Estates', 'Mining Properties', 'Eco-Tourism Lodges'],
    ),
    'Suriname': CountryInfo(
      'Suriname',
      'SR',
      '1.8K properties',
      'A diverse country with Dutch colonial heritage and pristine rainforests. Paramaribo is the capital.',
      ['Colonial Houses', 'Riverside Properties', 'Urban Apartments', 'Nature Reserves'],
    ),
    'Antigua': CountryInfo(
      'Antigua',
      'AG',
      '1.4K properties',
      'Part of Antigua and Barbuda, famous for its 365 beaches and luxury resorts.',
      ['Resort Properties', 'Beach Houses', 'Yacht Club Properties', 'Historic Sites'],
    ),
    'Haiti': CountryInfo(
      'Haiti',
      'HT',
      '1.2K properties',
      'Rich in history and culture, sharing the island of Hispaniola with Dominican Republic.',
      ['Historic Properties', 'Mountain Homes', 'Coastal Properties', 'Cultural Sites'],
    ),
    'St. Lucia': CountryInfo(
      'St. Lucia',
      'LC',
      '1.2K properties',
      'Known for the iconic Pitons mountains and luxury resorts. Castries and Soufrière are key areas.',
      ['Piton View Properties', 'Resort Villas', 'Rainforest Lodges', 'Marina Properties'],
    ),
    'Belize': CountryInfo(
      'Belize',
      'BZ',
      '890 properties',
      'A Central American gem with the second-largest barrier reef and ancient Mayan ruins.',
      ['Reef Properties', 'Jungle Lodges', 'Colonial Houses', 'Island Properties'],
    ),
    'Grenada': CountryInfo(
      'Grenada',
      'GD',
      '892 properties',
      'The "Spice Island" known for nutmeg, beautiful beaches, and friendly people.',
      ['Spice Plantations', 'Beach Villas', 'Mountain Properties', 'Marina Homes'],
    ),
    'Dominica': CountryInfo(
      'Dominica',
      'DM',
      '675 properties',
      'The "Nature Island" with lush rainforests, waterfalls, and eco-tourism opportunities.',
      ['Eco-Lodges', 'Rainforest Properties', 'Waterfall Views', 'Nature Reserves'],
    ),
    'St. Vincent': CountryInfo(
      'St. Vincent',
      'VC',
      '543 properties',
      'Part of St. Vincent and the Grenadines, known for sailing and pristine beaches.',
      ['Sailing Properties', 'Beach Houses', 'Island Villas', 'Yacht Club Homes'],
    ),
    'Montserrat': CountryInfo(
      'Montserrat',
      'MS',
      '156 properties',
      'The "Emerald Isle" recovering from volcanic activity, offering unique investment opportunities.',
      ['Volcanic View Properties', 'Safe Zone Homes', 'Investment Properties', 'Eco-Tourism Sites'],
    ),
  };

  @override
  void initState() {
    super.initState();
    selectedCountry = widget.selectedCountry;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          selectedCountry != null 
              ? '$selectedCountry Properties'
              : 'Caribbean Map',
          style: TextStyle(
            color: SuriStayColors.darkGreen,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: SuriStayColors.darkGreen),
        actions: [
          if (selectedCountry != null)
            IconButton(
              icon: const Icon(Icons.clear),
              onPressed: () => setState(() => selectedCountry = null),
              tooltip: 'Show all countries',
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Interactive Map
            CaribbeanMapWidget(
              selectedCountry: selectedCountry,
              onCountryTap: (country) {
                setState(() {
                  selectedCountry = selectedCountry == country ? null : country;
                });
              },
            ),
            
            const SizedBox(height: 30),
            
            // Country Details Section
            if (selectedCountry != null) ...[
              _buildCountryDetailsSection(),
              const SizedBox(height: 30),
            ],
            
            // Statistics Section
            _buildStatisticsSection(),
            
            const SizedBox(height: 30),
            
            // Quick Actions
            _buildQuickActionsSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildCountryDetailsSection() {
    final country = countryDetails[selectedCountry];
    if (country == null) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white,
            SuriStayColors.turquoise.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      SuriStayColors.warningOrange,
                      SuriStayColors.vibrantRed,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Center(
                  child: Text(
                    country.code,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      country.name,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: SuriStayColors.darkGreen,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: SuriStayColors.turquoise.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        country.propertyCount,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: SuriStayColors.turquoise,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            country.description,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[700],
              height: 1.5,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Popular Property Types:',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: SuriStayColors.darkGreen,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: country.propertyTypes.map((type) => Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: SuriStayColors.warningOrange.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: SuriStayColors.warningOrange.withOpacity(0.3),
                ),
              ),
              child: Text(
                type,
                style: TextStyle(
                  fontSize: 14,
                  color: SuriStayColors.warningOrange,
                  fontWeight: FontWeight.w500,
                ),
              ),
            )).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildStatisticsSection() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text('📊', style: TextStyle(fontSize: 24)),
              const SizedBox(width: 12),
              Text(
                'Caribbean Market Overview',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: SuriStayColors.darkGreen,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: _buildStatCard('Total Properties', '24.8K+', SuriStayColors.turquoise),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatCard('Countries', '14', SuriStayColors.warningOrange),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildStatCard('Avg. Price', '\$285K', SuriStayColors.vibrantRed),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatCard('New Listings', '1.2K/mo', SuriStayColors.darkGreen),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, String value, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionsSection() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '🚀 Quick Actions',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: SuriStayColors.darkGreen,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildActionButton(
                  'Search Properties',
                  Icons.search,
                  SuriStayColors.turquoise,
                  () => _showComingSoonDialog('Property Search'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildActionButton(
                  'Save Favorites',
                  Icons.favorite_outline,
                  SuriStayColors.warningOrange,
                  () => _showComingSoonDialog('Favorites'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildActionButton(
                  'Contact Agent',
                  Icons.phone,
                  SuriStayColors.vibrantRed,
                  () => _showComingSoonDialog('Contact Agent'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildActionButton(
                  'Market Reports',
                  Icons.analytics,
                  SuriStayColors.darkGreen,
                  () => _showComingSoonDialog('Market Reports'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(String title, IconData icon, Color color, VoidCallback onTap) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: color.withOpacity(0.3)),
          ),
          child: Column(
            children: [
              Icon(icon, color: color, size: 24),
              const SizedBox(height: 8),
              Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showComingSoonDialog(String feature) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('🚧 Coming Soon'),
        content: Text('$feature functionality will be available in the next update!'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Got it!',
              style: TextStyle(color: SuriStayColors.turquoise),
            ),
          ),
        ],
      ),
    );
  }
}

class CountryInfo {
  final String name;
  final String code;
  final String propertyCount;
  final String description;
  final List<String> propertyTypes;

  CountryInfo(this.name, this.code, this.propertyCount, this.description, this.propertyTypes);
}
