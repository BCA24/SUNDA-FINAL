import 'package:flutter/material.dart';
import 'package:houzi_package/common/constants.dart';
import 'package:houzi_package/models/article.dart';
import 'package:houzi_package/widgets/article_box_widgets/article_box_design.dart';
import 'package:houzi_package/files/generic_methods/utility_methods.dart';

class TestHouseCarousel extends StatelessWidget {
  const TestHouseCarousel({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print("🏠 TEST HOUSE CAROUSEL IS BEING BUILT! 🏠");
    // Create test house data
    List<Article> testHouses = _createTestHouses();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "🏠 Test Houses For Sale",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.green[800],
                ),
              ),
              Text(
                "View All",
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.green[600],
                  decoration: TextDecoration.underline,
                ),
              ),
            ],
          ),
        ),
        
        // Carousel
        SizedBox(
          height: ArticleBoxDesign().getArticleBoxDesignHeight(design: DESIGN_01),
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: testHouses.length,
            itemBuilder: (BuildContext context, int itemIndex) {
              var house = testHouses[itemIndex];
              var heroId = "test-house-${house.id}-$itemIndex";
              
              return Container(
                width: 300,
                margin: const EdgeInsets.only(right: 15),
                child: ArticleBoxDesign().getArticleBoxDesign(
                  buildContext: context,
                  article: house,
                  heroId: heroId,
                  design: DESIGN_01,
                  onTap: () {
                    // Show a simple dialog for test
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text("Test House"),
                        content: Text("🎉 Test advertisement clicked!\n\nHouse: ${house.title}\nPrice: ${house.propertyInfo?.price}\nBedrooms: ${house.features?.bedrooms}\nBathrooms: ${house.features?.bathrooms}"),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: Text("Close"),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ),
        
        const SizedBox(height: 20),
      ],
    );
  }

  List<Article> _createTestHouses() {
    return [
      _createTestHouse(
        id: 1001,
        title: "🌊 Beautiful Beach Villa",
        price: "\$850,000",
        bedrooms: "4",
        bathrooms: "3",
        area: "2,500",
        address: "123 Ocean Drive, Miami Beach",
        image: "assets/settings/dummy_property_image.jpg",
        status: "For Sale",
        type: "Villa",
      ),
      _createTestHouse(
        id: 1002,
        title: "🏡 Modern Family Home",
        price: "\$650,000",
        bedrooms: "3",
        bathrooms: "2",
        area: "1,800",
        address: "456 Maple Street, Suburban Heights",
        image: "assets/settings/dummy_property_image_01.jpg",
        status: "For Sale",
        type: "House",
      ),
      _createTestHouse(
        id: 1003,
        title: "🏢 Luxury Downtown Condo",
        price: "\$750,000",
        bedrooms: "2",
        bathrooms: "2",
        area: "1,200",
        address: "789 City Center, Downtown District",
        image: "assets/settings/dummy_property_image.jpg",
        status: "For Sale",
        type: "Condo",
      ),
      _createTestHouse(
        id: 1004,
        title: "🌴 Caribbean Paradise Estate",
        price: "\$1,200,000",
        bedrooms: "5",
        bathrooms: "4",
        area: "3,500",
        address: "321 Palm Paradise, Barbados",
        image: "assets/settings/dummy_property_image_01.jpg",
        status: "For Sale",
        type: "Estate",
      ),
    ];
  }

  Article _createTestHouse({
    required int id,
    required String title,
    required String price,
    required String bedrooms,
    required String bathrooms,
    required String area,
    required String address,
    required String image,
    required String status,
    required String type,
  }) {
    // Create Address
    Address houseAddress = Address(
      address: address,
      city: "Test City",
      state: "Test State",
      country: "Test Country",
    );

    // Create Features  
    Features houseFeatures = Features(
      bedrooms: bedrooms,
      bathrooms: bathrooms,
      propertyArea: area,
      propertyAreaUnit: "Sq Ft",
      garage: "2",
      yearBuilt: "2020",
    );

    // Create Property Info
    PropertyInfo propertyInfo = PropertyInfo(
      price: price,
      propertyStatus: status,
      propertyType: type,
      featured: "1", // Make it featured
      isFeatured: true,
    );

    // Create Article
    Article article = Article(
      id: id,
      title: title,
      image: image,
      imageList: [image],
      content: "This is a beautiful test property with modern amenities and great location. Perfect for testing the home carousel functionality.",
      status: status,
      isFav: false,
      type: "property",
    );

    // Assign related objects
    article.address = houseAddress;
    article.features = houseFeatures;
    article.propertyInfo = propertyInfo;

    return article;
  }
}