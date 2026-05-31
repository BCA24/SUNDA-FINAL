class CaribbeanProperty {
  final String id;
  final String title;
  final String description;
  final double price;
  final String currency;
  final String propertyType;
  final String city;
  final String country;
  final String region; // West, East, Mainland
  final int bedrooms;
  final int bathrooms;
  final double area; // in square meters
  final List<String> images;
  final List<String> amenities;
  final bool nearBeach;
  final bool oceanView;
  final bool furnished;
  final bool hasPool;
  final bool hasGarden;
  final bool hasParking;
  final bool gatedCommunity;
  final bool newConstruction;
  final int constructionYear;
  final double latitude;
  final double longitude;
  final String contactPhone;
  final String contactEmail;
  final DateTime listedDate;
  final bool isAvailable;

  CaribbeanProperty({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    this.currency = 'USD',
    required this.propertyType,
    required this.city,
    required this.country,
    required this.region,
    required this.bedrooms,
    required this.bathrooms,
    required this.area,
    required this.images,
    required this.amenities,
    this.nearBeach = false,
    this.oceanView = false,
    this.furnished = false,
    this.hasPool = false,
    this.hasGarden = false,
    this.hasParking = false,
    this.gatedCommunity = false,
    this.newConstruction = false,
    required this.constructionYear,
    required this.latitude,
    required this.longitude,
    required this.contactPhone,
    required this.contactEmail,
    required this.listedDate,
    this.isAvailable = true,
  });

  // Helper method to get formatted price
  String get formattedPrice {
    if (price >= 1000000) {
      return '\$${(price / 1000000).toStringAsFixed(1)}M';
    } else if (price >= 1000) {
      return '\$${(price / 1000).toStringAsFixed(0)}K';
    } else {
      return '\$${price.toStringAsFixed(0)}';
    }
  }

  // Helper method to get main image
  String get mainImage => images.isNotEmpty ? images.first : '';

  // Helper method to check if property matches filter criteria
  bool matchesFilter({
    String? propertyType,
    String? selectedCity,
    double? minPrice,
    double? maxPrice,
    int? bedrooms,
    int? bathrooms,
    bool? nearSea,
    bool? hasPoolFilter,
    bool? hasGardenFilter,
    bool? hasParkingFilter,
    bool? furnishedFilter,
    bool? gatedCommunityFilter,
    bool? oceanViewFilter,
    bool? newConstructionFilter,
  }) {
    // Property type filter
    if (propertyType != null && propertyType.isNotEmpty && this.propertyType != propertyType) {
      return false;
    }

    // City filter
    if (selectedCity != null && selectedCity.isNotEmpty && !city.contains(selectedCity.split(',').first)) {
      return false;
    }

    // Price range filter
    if (minPrice != null && price < minPrice) return false;
    if (maxPrice != null && price > maxPrice) return false;

    // Bedrooms filter
    if (bedrooms != null && this.bedrooms != bedrooms) return false;

    // Bathrooms filter
    if (bathrooms != null && this.bathrooms != bathrooms) return false;

    // Amenity filters
    if (nearSea == true && !nearBeach) return false;
    if (hasPoolFilter == true && !hasPool) return false;
    if (hasGardenFilter == true && !hasGarden) return false;
    if (hasParkingFilter == true && !hasParking) return false;
    if (furnishedFilter == true && !furnished) return false;
    if (gatedCommunityFilter == true && !gatedCommunity) return false;
    if (oceanViewFilter == true && !oceanView) return false;
    if (newConstructionFilter == true && !newConstruction) return false;

    return true;
  }
}

// Test data for Caribbean properties
class CaribbeanPropertyData {
  static List<CaribbeanProperty> getAllProperties() {
    return [
      // Jamaica Properties (West Region)
      CaribbeanProperty(
        id: 'JM001',
        title: 'Luxury Beachfront Villa in Montego Bay',
        description: 'Stunning 4-bedroom villa with private beach access, infinity pool, and panoramic ocean views. Perfect for vacation rental or permanent residence.',
        price: 1250000,
        propertyType: 'Villa',
        city: 'Montego Bay',
        country: 'Jamaica',
        region: 'West',
        bedrooms: 4,
        bathrooms: 3,
        area: 350,
        images: ['https://example.com/jamaica1.jpg'],
        amenities: ['Private Beach', 'Infinity Pool', 'Ocean View', 'Garden', 'Parking'],
        nearBeach: true,
        oceanView: true,
        furnished: true,
        hasPool: true,
        hasGarden: true,
        hasParking: true,
        gatedCommunity: true,
        newConstruction: false,
        constructionYear: 2018,
        latitude: 18.4762,
        longitude: -77.8939,
        contactPhone: '+1-876-555-0123',
        contactEmail: 'info@jamaicavillas.com',
        listedDate: DateTime.now().subtract(const Duration(days: 15)),
      ),

      CaribbeanProperty(
        id: 'JM002',
        title: 'Modern Apartment in Kingston',
        description: 'Contemporary 2-bedroom apartment in the heart of Kingston with city views and modern amenities.',
        price: 185000,
        propertyType: 'Apartment',
        city: 'Kingston',
        country: 'Jamaica',
        region: 'West',
        bedrooms: 2,
        bathrooms: 2,
        area: 120,
        images: ['https://example.com/jamaica2.jpg'],
        amenities: ['City View', 'Gym', 'Security', 'Parking'],
        nearBeach: false,
        oceanView: false,
        furnished: false,
        hasPool: false,
        hasGarden: false,
        hasParking: true,
        gatedCommunity: true,
        newConstruction: true,
        constructionYear: 2023,
        latitude: 18.0179,
        longitude: -76.8099,
        contactPhone: '+1-876-555-0124',
        contactEmail: 'sales@kingstonapts.com',
        listedDate: DateTime.now().subtract(const Duration(days: 8)),
      ),

      // Bahamas Properties (West Region)
      CaribbeanProperty(
        id: 'BS001',
        title: 'Paradise Island Penthouse',
        description: 'Exclusive penthouse with 360-degree ocean views, private rooftop terrace, and resort amenities.',
        price: 2800000,
        propertyType: 'Penthouse',
        city: 'Nassau',
        country: 'Bahamas',
        region: 'West',
        bedrooms: 5,
        bathrooms: 4,
        area: 450,
        images: ['https://example.com/bahamas1.jpg'],
        amenities: ['Ocean View', 'Rooftop Terrace', 'Resort Access', 'Pool', 'Concierge'],
        nearBeach: true,
        oceanView: true,
        furnished: true,
        hasPool: true,
        hasGarden: false,
        hasParking: true,
        gatedCommunity: true,
        newConstruction: false,
        constructionYear: 2020,
        latitude: 25.0834,
        longitude: -77.3504,
        contactPhone: '+1-242-555-0125',
        contactEmail: 'luxury@paradiseisland.com',
        listedDate: DateTime.now().subtract(const Duration(days: 22)),
      ),

      CaribbeanProperty(
        id: 'BS002',
        title: 'Cable Beach Condo',
        description: 'Beautiful 3-bedroom condo steps from Cable Beach with shared pool and beach access.',
        price: 425000,
        propertyType: 'Condo',
        city: 'Nassau',
        country: 'Bahamas',
        region: 'West',
        bedrooms: 3,
        bathrooms: 2,
        area: 180,
        images: ['https://example.com/bahamas2.jpg'],
        amenities: ['Beach Access', 'Shared Pool', 'Balcony', 'Parking'],
        nearBeach: true,
        oceanView: true,
        furnished: false,
        hasPool: true,
        hasGarden: false,
        hasParking: true,
        gatedCommunity: false,
        newConstruction: false,
        constructionYear: 2015,
        latitude: 25.0657,
        longitude: -77.4203,
        contactPhone: '+1-242-555-0126',
        contactEmail: 'info@cablebeachcondos.com',
        listedDate: DateTime.now().subtract(const Duration(days: 5)),
      ),

      // Barbados Properties (East Region)
      CaribbeanProperty(
        id: 'BB001',
        title: 'Luxury Beach House in St. Lawrence Gap',
        description: 'Magnificent beachfront house with private pool, tropical gardens, and direct beach access.',
        price: 1850000,
        propertyType: 'Beach House',
        city: 'Bridgetown',
        country: 'Barbados',
        region: 'East',
        bedrooms: 6,
        bathrooms: 5,
        area: 420,
        images: ['https://example.com/barbados1.jpg'],
        amenities: ['Private Beach', 'Pool', 'Tropical Garden', 'Outdoor Kitchen', 'Parking'],
        nearBeach: true,
        oceanView: true,
        furnished: true,
        hasPool: true,
        hasGarden: true,
        hasParking: true,
        gatedCommunity: false,
        newConstruction: false,
        constructionYear: 2017,
        latitude: 13.0969,
        longitude: -59.6145,
        contactPhone: '+1-246-555-0127',
        contactEmail: 'sales@barbadosbeach.com',
        listedDate: DateTime.now().subtract(const Duration(days: 12)),
      ),

      CaribbeanProperty(
        id: 'BB002',
        title: 'Chattel House Renovation Project',
        description: 'Historic Chattel house on large lot, perfect for renovation. Great investment opportunity.',
        price: 95000,
        propertyType: 'House',
        city: 'Bridgetown',
        country: 'Barbados',
        region: 'East',
        bedrooms: 2,
        bathrooms: 1,
        area: 85,
        images: ['https://example.com/barbados2.jpg'],
        amenities: ['Large Lot', 'Historic Property', 'Investment Opportunity'],
        nearBeach: false,
        oceanView: false,
        furnished: false,
        hasPool: false,
        hasGarden: true,
        hasParking: true,
        gatedCommunity: false,
        newConstruction: false,
        constructionYear: 1950,
        latitude: 13.1132,
        longitude: -59.5988,
        contactPhone: '+1-246-555-0128',
        contactEmail: 'heritage@barbadosrealty.com',
        listedDate: DateTime.now().subtract(const Duration(days: 30)),
      ),

      // Trinidad Properties (West Region)
      CaribbeanProperty(
        id: 'TT001',
        title: 'Port of Spain Executive Townhouse',
        description: 'Modern 3-story townhouse in prestigious area with city and harbor views.',
        price: 320000,
        propertyType: 'Townhouse',
        city: 'Port of Spain',
        country: 'Trinidad',
        region: 'West',
        bedrooms: 4,
        bathrooms: 3,
        area: 220,
        images: ['https://example.com/trinidad1.jpg'],
        amenities: ['City View', 'Harbor View', 'Garage', 'Security System'],
        nearBeach: false,
        oceanView: false,
        furnished: false,
        hasPool: false,
        hasGarden: true,
        hasParking: true,
        gatedCommunity: true,
        newConstruction: false,
        constructionYear: 2019,
        latitude: 10.6596,
        longitude: -61.5089,
        contactPhone: '+1-868-555-0129',
        contactEmail: 'executive@trinidadrealty.com',
        listedDate: DateTime.now().subtract(const Duration(days: 18)),
      ),

      // Guyana Properties (Mainland Region)
      CaribbeanProperty(
        id: 'GY001',
        title: 'Georgetown Colonial Mansion',
        description: 'Restored colonial mansion with original features, large grounds, and modern updates.',
        price: 450000,
        propertyType: 'House',
        city: 'Georgetown',
        country: 'Guyana',
        region: 'Mainland',
        bedrooms: 8,
        bathrooms: 6,
        area: 650,
        images: ['https://example.com/guyana1.jpg'],
        amenities: ['Historic Property', 'Large Grounds', 'Original Features', 'Parking'],
        nearBeach: false,
        oceanView: false,
        furnished: false,
        hasPool: false,
        hasGarden: true,
        hasParking: true,
        gatedCommunity: false,
        newConstruction: false,
        constructionYear: 1890,
        latitude: 6.8013,
        longitude: -58.1551,
        contactPhone: '+592-555-0130',
        contactEmail: 'colonial@guyanaproperties.com',
        listedDate: DateTime.now().subtract(const Duration(days: 25)),
      ),

      // Suriname Properties (Mainland Region)
      CaribbeanProperty(
        id: 'SR001',
        title: 'Paramaribo Riverside Apartment',
        description: 'Modern apartment overlooking the Suriname River with balcony and river views.',
        price: 125000,
        propertyType: 'Apartment',
        city: 'Paramaribo',
        country: 'Suriname',
        region: 'Mainland',
        bedrooms: 2,
        bathrooms: 1,
        area: 95,
        images: ['https://example.com/suriname1.jpg'],
        amenities: ['River View', 'Balcony', 'Modern Kitchen', 'Parking'],
        nearBeach: false,
        oceanView: false,
        furnished: true,
        hasPool: false,
        hasGarden: false,
        hasParking: true,
        gatedCommunity: false,
        newConstruction: true,
        constructionYear: 2022,
        latitude: 5.8520,
        longitude: -55.2038,
        contactPhone: '+597-555-0131',
        contactEmail: 'riverside@surinameapts.com',
        listedDate: DateTime.now().subtract(const Duration(days: 7)),
      ),

      // Additional properties for better filtering examples
      CaribbeanProperty(
        id: 'AG001',
        title: 'Antigua Beachfront Resort Property',
        description: 'Investment opportunity - beachfront land with approved resort development plans.',
        price: 3500000,
        propertyType: 'Commercial',
        city: 'St. John\'s',
        country: 'Antigua',
        region: 'East',
        bedrooms: 0,
        bathrooms: 0,
        area: 5000,
        images: ['https://example.com/antigua1.jpg'],
        amenities: ['Beachfront', 'Development Approved', 'Investment Property'],
        nearBeach: true,
        oceanView: true,
        furnished: false,
        hasPool: false,
        hasGarden: false,
        hasParking: false,
        gatedCommunity: false,
        newConstruction: false,
        constructionYear: 2024,
        latitude: 17.1274,
        longitude: -61.8468,
        contactPhone: '+1-268-555-0132',
        contactEmail: 'development@antiguainvest.com',
        listedDate: DateTime.now().subtract(const Duration(days: 45)),
      ),

      CaribbeanProperty(
        id: 'LC001',
        title: 'St. Lucia Mountain Villa',
        description: 'Eco-friendly villa in the mountains with rainforest views and sustainable features.',
        price: 675000,
        propertyType: 'Villa',
        city: 'Castries',
        country: 'St. Lucia',
        region: 'East',
        bedrooms: 3,
        bathrooms: 2,
        area: 280,
        images: ['https://example.com/stlucia1.jpg'],
        amenities: ['Mountain View', 'Eco-Friendly', 'Rainforest', 'Solar Power'],
        nearBeach: false,
        oceanView: false,
        furnished: true,
        hasPool: true,
        hasGarden: true,
        hasParking: true,
        gatedCommunity: false,
        newConstruction: true,
        constructionYear: 2023,
        latitude: 14.0101,
        longitude: -60.9875,
        contactPhone: '+1-758-555-0133',
        contactEmail: 'eco@stluciaproperties.com',
        listedDate: DateTime.now().subtract(const Duration(days: 10)),
      ),
    ];
  }

  // Filter properties by region
  static List<CaribbeanProperty> getPropertiesByRegion(String region) {
    return getAllProperties().where((property) => property.region == region).toList();
  }

  // Filter properties by country
  static List<CaribbeanProperty> getPropertiesByCountry(String country) {
    return getAllProperties().where((property) => property.country == country).toList();
  }

  // Get properties with filters applied
  static List<CaribbeanProperty> getFilteredProperties({
    String? region,
    String? propertyType,
    String? selectedCity,
    double? minPrice,
    double? maxPrice,
    int? bedrooms,
    int? bathrooms,
    bool? nearSea,
    bool? hasPool,
    bool? hasGarden,
    bool? hasParking,
    bool? furnished,
    bool? gatedCommunity,
    bool? oceanView,
    bool? newConstruction,
  }) {
    List<CaribbeanProperty> properties = getAllProperties();

    // Filter by region first if specified
    if (region != null && region.isNotEmpty) {
      properties = properties.where((property) => property.region == region).toList();
    }

    // Apply other filters
    return properties.where((property) => property.matchesFilter(
      propertyType: propertyType,
      selectedCity: selectedCity,
      minPrice: minPrice,
      maxPrice: maxPrice,
      bedrooms: bedrooms,
      bathrooms: bathrooms,
      nearSea: nearSea,
      hasPoolFilter: hasPool,
      hasGardenFilter: hasGarden,
      hasParkingFilter: hasParking,
      furnishedFilter: furnished,
      gatedCommunityFilter: gatedCommunity,
      oceanViewFilter: oceanView,
      newConstructionFilter: newConstruction,
    )).toList();
  }
}
