import 'package:flutter/material.dart';

class CategoryList extends StatelessWidget {
  const CategoryList({Key? key}) : super(key: key);

  static const List<Map<String, dynamic>> categories = [
    {
      'icon': 'assets/icons/beachfront.png',
      'label': 'Beachfront',
      'isSelected': true,
    },
    {
      'icon': 'assets/icons/amazing_views.png',
      'label': 'Amazing views',
      'isSelected': false,
    },
    {
      'icon': 'assets/icons/countryside.png',
      'label': 'Countryside',
      'isSelected': false,
    },
    {
      'icon': 'assets/icons/pools.png',
      'label': 'Amazing pools',
      'isSelected': false,
    },
    {
      'icon': 'assets/icons/mansions.png',
      'label': 'Mansions',
      'isSelected': false,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: 80,
      child: _CategoryListView(),
    );
  }
}

class _CategoryListView extends StatelessWidget {
  const _CategoryListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: CategoryList.categories.length,
      itemBuilder: (context, index) {
        final category = CategoryList.categories[index];
        return Container(
          margin: const EdgeInsets.only(right: 32),
          child: Column(
            children: [
              // Icon
              Container(
                width: 32,
                height: 32,
                margin: const EdgeInsets.only(bottom: 8),
                child: ImageIcon(
                  AssetImage(category['icon']),
                  color: category['isSelected'] ? Colors.black : Colors.grey,
                ),
              ),
              // Label
              Text(
                category['label'],
                style: TextStyle(
                  fontSize: 12,
                  color: category['isSelected'] ? Colors.black : Colors.grey,
                  fontWeight: category['isSelected']
                      ? FontWeight.bold
                      : FontWeight.normal,
                ),
              ),
              // Selected Indicator
              if (category['isSelected'])
                Container(
                  margin: const EdgeInsets.only(top: 8),
                  width: 16,
                  height: 2,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(1),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
