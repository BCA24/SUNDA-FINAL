import 'package:flutter/material.dart';
import 'package:houzi_package/common/constants.dart';
import 'package:houzi_package/files/generic_methods/utility_methods.dart';
import 'package:houzi_package/files/item_design_files/item_design_notifier.dart';
import 'package:houzi_package/models/article.dart';
import 'package:houzi_package/widgets/article_box_widgets/article_box_design.dart';
import 'package:houzi_package/widgets/shimmer_effect_error_widget.dart';

typedef PropertiesListingGenericWidgetListener = Function();

class PropertiesListingGenericWidget extends StatelessWidget {
  final List<dynamic> propertiesList;
  final ItemDesignNotifier? itemDesignNotifier;
  final String? design;
  final String? listingView;
  final PropertiesListingGenericWidgetListener? listener;
  final void Function(Article, int, String)? onPropArticleTap;

  const PropertiesListingGenericWidget({
    Key? key,
    required this.propertiesList,
    this.itemDesignNotifier,
    this.design,
    this.listingView,
    this.listener,
    this.onPropArticleTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (propertiesList.isEmpty) {
      return Container();
    }

    return SizedBox(
      height: ArticleBoxDesign().getArticleBoxDesignHeight(
        design: design ?? DESIGN_01,
      ),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: propertiesList.length,
        itemBuilder: (BuildContext context, int itemIndex) {
          var item = propertiesList[itemIndex];
          if (item is Article) {
            var heroId = "${item.id}-${UtilityMethods.getRandomNumber()}-CAROUSEL";
            
            return Container(
              width: 300, // Fixed width for carousel items
              margin: const EdgeInsets.only(right: 10),
              child: ArticleBoxDesign().getArticleBoxDesign(
                buildContext: context,
                article: item,
                heroId: heroId,
                design: design ?? DESIGN_01,
                onTap: () {
                  if (onPropArticleTap != null) {
                    onPropArticleTap!(item, item.id!, heroId);
                  }
                },
              ),
            );
          }
          return Container();
        },
      ),
    );
  }
}

Widget genericLoadingWidgetForCarousalWithShimmerEffect(BuildContext context) {
  return SizedBox(
    height: ArticleBoxDesign().getArticleBoxDesignHeight(design: DESIGN_01),
    child: ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: 3, // Show 3 shimmer items
      itemBuilder: (BuildContext context, int itemIndex) {
        return Container(
          width: 300,
          margin: const EdgeInsets.only(right: 10),
          child: const ShimmerEffectErrorWidget(),
        );
      },
    ),
  );
}
