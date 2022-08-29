import 'dart:io';

import 'package:admin_side_fashop/components/components.dart';
import 'package:admin_side_fashop/components/constants.dart';
import 'package:admin_side_fashop/model/brand.dart';
import 'package:admin_side_fashop/model/category.dart';
import 'package:admin_side_fashop/model/product.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';

import 'admin_screen.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({Key? key}) : super(key: key);

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final CategoryService _categoryService = CategoryService();
  final BrandService _brandService = BrandService();
  final ProductService _productService = ProductService();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _productNameController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  List<DocumentSnapshot> brands = <DocumentSnapshot>[];
  List<DocumentSnapshot> categories = <DocumentSnapshot>[];
  List<DropdownMenuItem<String>> brandsDropdown = <DropdownMenuItem<String>>[];
  List<DropdownMenuItem<String>> categoriesDropdown =
      <DropdownMenuItem<String>>[];
  String _currentBrand = '';
  String _currentCategory = 'test';
  List<String> selectedSizes = <String>[];
  final ImagePicker _picker = ImagePicker();
  File? _image1;
  File? _image2;
  File? _image3;
  bool isLoading = false;

  @override
  void initState() {
    // init state for categories
    _getCategory();

    // init state for Brands
    _getBrands();
    super.initState();
  }

  // =================== Categories Methods  ====================

  // Categories Methods
  List<DropdownMenuItem<String>> getCategoriesDropdown() {
    List<DropdownMenuItem<String>> items = <DropdownMenuItem<String>>[];

    for (int i = 0; i < categories.length; i++) {
      var categoriesData = categories[i].data() as Map;
      setState(() {
        items.insert(
          0,
          DropdownMenuItem(
            value: categoriesData['category'],
            child: Text(
              categoriesData['category'],
            ),
          ),
        );
      });
    }
    return items;
  }

  _getCategory() async {
    List<DocumentSnapshot> data = await _categoryService.getCategories();
    setState(() {
      categories = data;
      categoriesDropdown = getCategoriesDropdown();
      Map categoriesData = categories[0].data() as Map;
      _currentCategory = categoriesData['category'];
    });
  }

  changeSelectedCategory(String? selectedCategory) {
    setState(() => _currentCategory = selectedCategory!);
  }

  // =================== Brands Methods  ====================

  // Brand Methods
  List<DropdownMenuItem<String>> getBrandsDropdown() {
    List<DropdownMenuItem<String>> items = [];

    for (DocumentSnapshot brand in brands) {
      items.add(
        DropdownMenuItem(
          value: brand['brand'],
          child: Text(
            brand['brand'],
          ),
        ),
      );
    }
    return items;
  }

  _getBrands() async {
    List<DocumentSnapshot> data = await _brandService.getBrands();
    setState(() {
      brands = data;
      brandsDropdown = getBrandsDropdown();
      Map brandsData = brands[0].data() as Map;
      _currentBrand = brandsData['brand'];
    });
  }

  changeSelectedBrands(String? selectedBrands) {
    setState(() => _currentBrand = selectedBrands!);
  }

  // =================== Size Methods  ====================
  changeSelectedSize(String size) {
    if (selectedSizes.contains(size)) {
      setState(() {
        selectedSizes.remove(size);
      });
    } else {
      setState(() {
        selectedSizes.insert(0, size);
      });
    }
  }

  // =================== Picked Images Methods  ====================

  getImageFromGallery() async {
    final pickedFile = await _picker.getImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image1 = File(pickedFile.path);
      });
    }
  }

  _selectImage(int imageNumber) async {
    final pickedFile = await _picker.getImage(source: ImageSource.gallery);
    switch (imageNumber) {
      case 1:
        setState(() => _image1 = File(pickedFile!.path));
        break;
      case 2:
        setState(() => _image2 = File(pickedFile!.path));
        break;
      case 3:
        setState(() => _image3 = File(pickedFile!.path));
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.1,
        backgroundColor: white,
        title: const Text(
          'Add Product',
          style: TextStyle(
            color: black,
          ),
        ),
        leading: IconButton(
          onPressed: () {
            navigateAndFinish(context, const AdminScreen());
          },
          icon: const Icon(
            Icons.close,
            color: black,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: isLoading
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : Column(
                    children: [
                      Row(
                        children: [
                          defaultOutlineAddButton(
                            onPressed: () {
                              _selectImage(1);
                            },
                            child: _displayChild1(),
                          ),
                          defaultOutlineAddButton(
                            onPressed: () {
                              _selectImage(2);
                            },
                            child: _displayChild2(),
                          ),
                          defaultOutlineAddButton(
                            onPressed: () {
                              _selectImage(3);
                            },
                            child: _displayChild3(),
                          ),
                        ],
                      ),
                      // =================== Product Name Section  =======================
                      // ===============================================================
                      defaultTextFormField(
                        controller: _productNameController,
                        keyboardType: TextInputType.text,
                        label: 'Product Name',
                        validator: (String? value) {
                          if (value!.isEmpty) {
                            return 'Product Name must not be Empty';
                          }
                          return null;
                        },
                        prefix: Icons.production_quantity_limits,
                      ),

                      // =================== Categories And Brand Section  =======================
                      // ===============================================================
                      Row(
                        children: [
                          customBrandAndCategoryRow(
                            title: 'Category : ',
                            items: categoriesDropdown,
                            onChange: changeSelectedCategory,
                            currentIndex: _currentCategory,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 5.0),
                            child: customBrandAndCategoryRow(
                              title: 'Brand : ',
                              items: brandsDropdown,
                              onChange: changeSelectedBrands,
                              currentIndex: _currentBrand,
                            ),
                          ),
                        ],
                      ),

                      // =================== Quantity Section  ===========================
                      // ===============================================================
                      defaultTextFormField(
                        controller: _quantityController,
                        keyboardType: TextInputType.phone,
                        label: 'Quantity',
                        validator: (String? value) {
                          if (value!.isEmpty) {
                            return 'Quantity must not be Empty';
                          }
                          return null;
                        },
                        prefix: Icons.numbers,
                      ),

                      // =================== Price Section  ===========================
                      // ===============================================================
                      defaultTextFormField(
                        controller: _priceController,
                        keyboardType: TextInputType.phone,
                        label: 'Price',
                        validator: (String? value) {
                          if (value!.isEmpty) {
                            return 'Price must not be Empty';
                          }
                          return null;
                        },
                        prefix: Icons.monetization_on_outlined,
                      ),

                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          'Available Sizes',
                          style: TextStyle(
                            color: Colors.blue,
                            fontSize: 15.0,
                          ),
                        ),
                      ),

                      // =================== CheckBox Size Rows Section  ===========================
                      // ===============================================================
                      Row(
                        children: [
                          Checkbox(
                            value: selectedSizes.contains('S'),
                            onChanged: (value) => changeSelectedSize('S'),
                          ),
                          const Text('S'),
                          Checkbox(
                            value: selectedSizes.contains('M'),
                            onChanged: (value) => changeSelectedSize('M'),
                          ),
                          const Text('M'),
                          Checkbox(
                            value: selectedSizes.contains('L'),
                            onChanged: (value) => changeSelectedSize('L'),
                          ),
                          const Text('L'),
                          Checkbox(
                            value: selectedSizes.contains('XL'),
                            onChanged: (value) => changeSelectedSize('XL'),
                          ),
                          const Text('XL'),
                          Checkbox(
                            value: selectedSizes.contains('XXL'),
                            onChanged: (value) => changeSelectedSize('XXL'),
                          ),
                          const Text('XXL'),
                        ],
                      ),
                      Row(
                        children: [
                          Checkbox(
                            value: selectedSizes.contains('3XL'),
                            onChanged: (value) => changeSelectedSize('3XL'),
                          ),
                          const Text('3XL'),
                          Checkbox(
                            value: selectedSizes.contains('4XL'),
                            onChanged: (value) => changeSelectedSize('4XL'),
                          ),
                          const Text('4XL'),
                          Checkbox(
                            value: selectedSizes.contains('5XL'),
                            onChanged: (value) => changeSelectedSize('5XL'),
                          ),
                          const Text('5XL'),
                          Checkbox(
                            value: selectedSizes.contains('6XL'),
                            onChanged: (value) => changeSelectedSize('6XL'),
                          ),
                          const Text('6XL'),
                        ],
                      ),

                      // =================== CheckBox Size Rows Section  ===========================
                      // ===============================================================

                      Row(
                        children: [
                          Checkbox(
                            value: selectedSizes.contains('30'),
                            onChanged: (value) => changeSelectedSize('30'),
                          ),
                          const Text('30'),
                          Checkbox(
                            value: selectedSizes.contains('32'),
                            onChanged: (value) => changeSelectedSize('32'),
                          ),
                          const Text('32'),
                          Checkbox(
                            value: selectedSizes.contains('34'),
                            onChanged: (value) => changeSelectedSize('34'),
                          ),
                          const Text('34'),
                          Checkbox(
                            value: selectedSizes.contains('36'),
                            onChanged: (value) => changeSelectedSize('36'),
                          ),
                          const Text('36'),
                          Checkbox(
                            value: selectedSizes.contains('38'),
                            onChanged: (value) => changeSelectedSize('38'),
                          ),
                          const Text('38'),
                        ],
                      ),

                      Row(
                        children: [
                          Checkbox(
                            value: selectedSizes.contains('40'),
                            onChanged: (value) => changeSelectedSize('40'),
                          ),
                          const Text('40'),
                          Checkbox(
                            value: selectedSizes.contains('42'),
                            onChanged: (value) => changeSelectedSize('42'),
                          ),
                          const Text('42'),
                          Checkbox(
                            value: selectedSizes.contains('44'),
                            onChanged: (value) => changeSelectedSize('44'),
                          ),
                          const Text('44'),
                          Checkbox(
                            value: selectedSizes.contains('46'),
                            onChanged: (value) => changeSelectedSize('46'),
                          ),
                          const Text('46'),
                          Checkbox(
                            value: selectedSizes.contains('48'),
                            onChanged: (value) => changeSelectedSize('48'),
                          ),
                          const Text('48'),
                        ],
                      ),

                      // =================== Add Product Button Section  ===========================
                      // ===============================================================
                      MaterialButton(
                        onPressed: () {
                          validateAndUpload();
                        },
                        color: Colors.red,
                        textColor: Colors.white,
                        child: const Text(
                          'Add Product',
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }

  Widget customBrandAndCategoryRow({
    required String title,
    required List<DropdownMenuItem<String>> items,
    required void Function(String?) onChange,
    required String currentIndex,
  }) =>
      Row(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              title,
              style: const TextStyle(
                color: Colors.red,
                fontSize: 15.0,
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(
              top: 8.0,
              bottom: 8.0,
            ),
            padding: const EdgeInsets.only(
              left: 5.0,
              right: 3.0,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(
                5.0,
              ),
              color: Colors.grey[200],
            ),
            child: DropdownButton(
              style: const TextStyle(
                color: Colors.black,
                fontSize: 16.0,
                fontWeight: FontWeight.w600,
              ),
              items: items,
              onChanged: onChange,
              value: currentIndex,
            ),
          ),
        ],
      );

  // Display Image1
  Widget _displayChild1() {
    if (_image1 == null) {
      return const Padding(
        padding: EdgeInsets.fromLTRB(14.0, 50.0, 14.0, 50.0),
        child: Icon(
          Icons.add,
          color: notActive,
        ),
      );
    } else {
      return Image.file(
        _image1!,
        fit: BoxFit.cover,
        width: double.infinity,
      );
    }
  }

  // Display Image2
  Widget _displayChild2() {
    if (_image2 == null) {
      return const Padding(
        padding: EdgeInsets.fromLTRB(14.0, 50.0, 14.0, 50.0),
        child: Icon(
          Icons.add,
          color: notActive,
        ),
      );
    } else {
      return Image.file(
        _image2!,
        fit: BoxFit.fill,
        width: double.infinity,
      );
    }
  }

  // Display Image3
  Widget _displayChild3() {
    if (_image3 == null) {
      return const Padding(
        padding: EdgeInsets.fromLTRB(14.0, 50.0, 14.0, 50.0),
        child: Icon(
          Icons.add,
          color: notActive,
        ),
      );
    } else {
      return Image.file(
        _image3!,
        fit: BoxFit.fill,
        width: double.infinity,
      );
    }
  }

  // Validate And Upload Method

  validateAndUpload() async {
    setState(() => isLoading = true);
    if (_formKey.currentState!.validate()) {
      if (_image1 != null && _image2 != null && _image3 != null) {
        if (selectedSizes.isNotEmpty) {
          String imageUrl1;
          String imageUrl2;
          String imageUrl3;
          final FirebaseStorage storage = FirebaseStorage.instance;
          final String picture1 =
              '1${DateTime.now().millisecondsSinceEpoch.toString()}.jpg';
          UploadTask task1 = storage.ref().child(picture1).putFile(_image1!);
          final String picture2 =
              '2${DateTime.now().millisecondsSinceEpoch.toString()}.jpg';
          UploadTask task2 = storage.ref().child(picture2).putFile(_image2!);
          final String picture3 =
              '3${DateTime.now().millisecondsSinceEpoch.toString()}.jpg';
          UploadTask task3 = storage.ref().child(picture3).putFile(_image3!);

          TaskSnapshot snapshot1 = await task1;
          TaskSnapshot snapshot2 = await task2;
          TaskSnapshot snapshot3 = await task3;

          imageUrl1 = await snapshot1.ref.getDownloadURL();
          imageUrl2 = await snapshot2.ref.getDownloadURL();
          imageUrl3 = await snapshot3.ref.getDownloadURL();
          List<String> imageList = [
            imageUrl1,
            imageUrl2,
            imageUrl3,
          ];
            _productService.uploadProduct(
              productName: _productNameController.text,
              productCategory: _currentCategory,
              productBrand: _currentBrand,
              sizes: selectedSizes,
              images: imageList,
              productQuantity: int.parse(_quantityController.text),
              productPrice: double.parse(_priceController.text),
            );
            _formKey.currentState!.reset();
            setState(() => isLoading = false);
            Fluttertoast.showToast(msg: 'Product Added');
            Navigator.pop(context);

        } else {
          setState(() => isLoading = false);
          Fluttertoast.showToast(msg: 'Select at least one Size');
        }
      } else {
        setState(() => isLoading = false);
        Fluttertoast.showToast(msg: 'All Images must be Provided');
      }
    }
  }
}
