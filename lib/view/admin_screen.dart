// ignore_for_file: library_private_types_in_public_api

import 'package:admin_side_fashop/components/components.dart';
import 'package:admin_side_fashop/view/add_product.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../components/constants.dart';
import '../model/brand.dart';
import '../model/category.dart';

enum Page { dashboard, manage }

class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});

  @override
  _AdminScreenState createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  Page _selectedPage = Page.dashboard;
  TextEditingController categoryController = TextEditingController();
  TextEditingController brandController = TextEditingController();
  final GlobalKey<FormState> _categoryFormKey = GlobalKey();
  final GlobalKey<FormState> _brandFormKey = GlobalKey();
  final BrandService _brandService = BrandService();
  final CategoryService _categoryService = CategoryService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Row(
            children: <Widget>[
              Expanded(
                child: TextButton.icon(
                  onPressed: () {
                    setState(() => _selectedPage = Page.dashboard);
                  },
                  icon: Icon(
                    Icons.dashboard,
                    color: _selectedPage == Page.dashboard ? active : notActive,
                  ),
                  label: const Text(
                    'Dashboard',
                  ),
                ),
              ),
              Expanded(
                child: TextButton.icon(
                  onPressed: () {
                    setState(() => _selectedPage = Page.manage);
                  },
                  icon: Icon(
                    Icons.sort,
                    color: _selectedPage == Page.manage ? active : notActive,
                  ),
                  label: const Text(
                    'Manage',
                  ),
                ),
              ),
            ],
          ),
          elevation: 0.0,
          backgroundColor: Colors.white,
        ),
        body: _loadScreen());
  }

  Widget _loadScreen() {
    switch (_selectedPage) {
      case Page.dashboard:
        return Column(
          children: <Widget>[
            ListTile(
              subtitle: TextButton.icon(
                onPressed: null,
                icon: const Icon(
                  Icons.attach_money,
                  size: 30.0,
                  color: Colors.green,
                ),
                label: const Text('12,000',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 30.0, color: Colors.green)),
              ),
              title: const Text(
                'Revenue',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 24.0, color: Colors.grey),
              ),
            ),
            Expanded(
              child: GridView(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                ),
                children: <Widget>[
                  // Users Card
                  defaultCardDashboard(
                    onPressed: () {},
                    titleIcon: Icons.people_outline,
                    titleLabel: 'Users',
                    subTitleLabel: '7',
                  ),

                  // Categories Card
                  defaultCardDashboard(
                    onPressed: () {},
                    titleIcon: Icons.category,
                    titleLabel: 'Categories',
                    subTitleLabel: '23',
                  ),

                  // Products Card
                  defaultCardDashboard(
                    onPressed: () {},
                    titleIcon: Icons.track_changes,
                    titleLabel: 'Products',
                    subTitleLabel: '120',
                  ),

                  // Sold Card
                  defaultCardDashboard(
                    onPressed: () {},
                    titleIcon: Icons.tag_faces,
                    titleLabel: 'Sold',
                    subTitleLabel: '13',
                  ),

                  // Orders Card
                  defaultCardDashboard(
                    onPressed: () {},
                    titleIcon: Icons.shopping_cart,
                    titleLabel: 'Orders',
                    subTitleLabel: '5',
                  ),

                  // Return Card
                  defaultCardDashboard(
                    onPressed: () {},
                    titleIcon: Icons.close,
                    titleLabel: 'Return',
                    subTitleLabel: '0',
                  ),
                ],
              ),
            ),
          ],
        );
      case Page.manage:
        return ListView(
          children: <Widget>[
            // Add Product ListTile
            defaultManageListTile(
              onTap: ()
              {
                navigateTo(context, const AddProductScreen());
              },
              leadingIcon: Icons.add,
              title: 'Add product',
            ),

            const Divider(),

            // Add Product List ListTile
            defaultManageListTile(
              onTap: () {},
              leadingIcon: Icons.change_history,
              title: 'Products list',
            ),

            const Divider(),

            // Add Category ListTile
            defaultManageListTile(
              onTap: () {
                _categoryAlert();
              },
              leadingIcon: Icons.add_circle,
              title: 'Add category',
            ),

            const Divider(),

            // Add Category List ListTile
            defaultManageListTile(
              onTap: () {},
              leadingIcon: Icons.category,
              title: 'Category list',
            ),

            const Divider(),

            // Add Brand ListTile
            defaultManageListTile(
              onTap: () {
                _brandAlert();
              },
              leadingIcon: Icons.add_circle_outline,
              title: 'Add brand',
            ),

            const Divider(),

            // Add Brand List ListTile
            defaultManageListTile(
              onTap: () {},
              leadingIcon: Icons.library_books,
              title: 'Brand list',
            ),

            const Divider(),
          ],
        );
      default:
        return Container();
    }
  }

  void _categoryAlert() {
    var alert = AlertDialog(
      content: Form(
        key: _categoryFormKey,
        child: TextFormField(
          controller: categoryController,
          validator: (String? value) {
            if (value!.isEmpty) {
              return 'category cannot be empty';
            }
            return null;
          },
          decoration: const InputDecoration(hintText: "add category"),
        ),
      ),
      actions: <Widget>[
        TextButton(
            onPressed: () {
              if (categoryController.text != null) {
                _categoryService.createCategory(categoryController.text);
              }
              Fluttertoast.showToast(msg: 'category created');
              Navigator.pop(context);
            },
            child: const Text('ADD')),
        TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('CANCEL')),
      ],
    );

    showDialog(context: context, builder: (_) => alert);
  }

  void _brandAlert() {
    var alert = AlertDialog(
      content: Form(
        key: _brandFormKey,
        child: TextFormField(
          controller: brandController,
          validator: (String? value) {
            if (value!.isEmpty) {
              return 'category cannot be empty';
            }
            return null;
          },
          decoration: const InputDecoration(hintText: "add brand"),
        ),
      ),
      actions: <Widget>[
        TextButton(
            onPressed: () {
              if (brandController.text != null) {
                _brandService.createBrand(brandController.text);
              }
              Fluttertoast.showToast(msg: 'brand added');
              Navigator.pop(context);
            },
            child: const Text('ADD')),
        TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('CANCEL')),
      ],
    );

    showDialog(context: context, builder: (_) => alert);
  }
}
