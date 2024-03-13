import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/product.dart';
import '../providers/products.dart';

class EditProductScreen extends StatefulWidget {
  static const routeName = '/edit-product';

  const EditProductScreen({super.key});

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();
  final _imageUrlFocusNode = FocusNode();
  final _form = GlobalKey<FormState>();

  bool _isLoading = false;

  var _initialValue = {
    'id': '',
    'title': '',
    'description': '',
    'imageUrl': '',
    'price': 0,
  };

  Product _editedProduct = Product(
    id: '',
    title: '',
    description: '',
    imageUrl: '',
    price: 0,
  );

  void _updateImageUrl() {
    final notValid = _imageUrlController.text.isEmpty ||
        (!_imageUrlController.text.startsWith("http") ||
                !_imageUrlController.text.startsWith("https")) &&
            (!_imageUrlController.text.endsWith(".jpg") ||
                !_imageUrlController.text.endsWith(".png") ||
                !_imageUrlController.text.endsWith(".jpeg"));

    if (!_imageUrlFocusNode.hasFocus && !notValid) {
      setState(() {});
    }
  }

  Future<void> _saveForm() async {
    if (!_form.currentState!.validate()) return;

    final addProduct = Provider.of<Products>(context, listen: false).addProduct;

    final updateProduct =
        Provider.of<Products>(context, listen: false).updateProduct;

    _form.currentState?.save();

    setState(() {
      _isLoading = true;
    });

    try {
      _editedProduct.id != ''
          ? await updateProduct(_editedProduct.id, _editedProduct)
          : await addProduct(_editedProduct);
    } catch (error) {
      await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('An error occurred!'),
          content: Text(error.toString()),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OKay'),
            ),
          ],
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });

      Navigator.of(context).pop();
    }
  }

  @override
  void initState() {
    _imageUrlFocusNode.addListener(_updateImageUrl);

    super.initState();
  }

  @override
  void didChangeDependencies() {
    final id = ModalRoute.of(context)?.settings.arguments;
    if (id != null) {
      _editedProduct =
          Provider.of<Products>(context, listen: false).findById(id as String);

      _initialValue = {
        'id': _editedProduct.id,
        'title': _editedProduct.title,
        'description': _editedProduct.description,
        // 'imageUrl': _editedProduct.imageUrl,
        'price': _editedProduct.price.toString(),
      };

      _imageUrlController.text = _editedProduct.imageUrl;
    }

    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _imageUrlFocusNode.removeListener(_updateImageUrl);
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imageUrlController.dispose();
    _imageUrlFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Product'),
        actions: [
          IconButton(
            onPressed: () => _saveForm(),
            icon: const Icon(Icons.save),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _form,
                child: ListView(
                  children: [
                    TextFormField(
                      initialValue: _initialValue['title'].toString(),
                      decoration: const InputDecoration(labelText: 'Title'),
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) =>
                          FocusScope.of(context).requestFocus(_priceFocusNode),
                      validator: (value) =>
                          value!.isEmpty ? "Please enter a title" : null,
                      onSaved: (newValue) {
                        _editedProduct = Product(
                          id: _editedProduct.id,
                          title: newValue ?? "",
                          description: _editedProduct.description,
                          price: _editedProduct.price,
                          imageUrl: _editedProduct.imageUrl,
                          isFavorite: _editedProduct.isFavorite,
                        );
                      },
                    ),
                    TextFormField(
                      initialValue: _initialValue['price'].toString(),
                      decoration: const InputDecoration(labelText: 'Price'),
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.number,
                      focusNode: _priceFocusNode,
                      onFieldSubmitted: (_) => FocusScope.of(context)
                          .requestFocus(_descriptionFocusNode),
                      validator: (value) {
                        if (value!.isEmpty) return "Please enter a price";
                        if (double.tryParse(value) == null) {
                          return "Please enter a valid number.";
                        }
                        if (double.parse(value) <= 0) {
                          return "Please enter a number geater than zero.";
                        }

                        return null;
                      },
                      onSaved: (newValue) {
                        _editedProduct = Product(
                          id: _editedProduct.id,
                          title: _editedProduct.title,
                          description: _editedProduct.description,
                          price: newValue != ''
                              ? double.parse(newValue as String)
                              : 0.0,
                          imageUrl: _editedProduct.imageUrl,
                          isFavorite: _editedProduct.isFavorite,
                        );
                      },
                    ),
                    TextFormField(
                      initialValue: _initialValue['description'].toString(),
                      decoration:
                          const InputDecoration(labelText: 'Description'),
                      maxLines: 3,
                      keyboardType: TextInputType.multiline,
                      focusNode: _descriptionFocusNode,
                      validator: (value) {
                        if (value!.isEmpty) return "Please enter a decription";
                        if (value.length < 10) {
                          return "Should be at least 10 characters long.";
                        }

                        return null;
                      },
                      onSaved: (newValue) {
                        _editedProduct = Product(
                          id: _editedProduct.id,
                          title: _editedProduct.title,
                          description: newValue ?? "",
                          price: _editedProduct.price,
                          imageUrl: _editedProduct.imageUrl,
                          isFavorite: _editedProduct.isFavorite,
                        );
                      },
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                          width: 100,
                          height: 100,
                          margin: const EdgeInsets.only(top: 8, right: 10),
                          decoration: BoxDecoration(
                            border: Border.all(
                              width: 1,
                              color: Colors.grey,
                            ),
                          ),
                          child: _imageUrlController.text.isEmpty
                              ? const Text('Enter a Url')
                              : Image.network(
                                  _imageUrlController.text,
                                  fit: BoxFit.cover,
                                ),
                        ),
                        Expanded(
                          child: TextFormField(
                            decoration:
                                const InputDecoration(labelText: 'Image Url'),
                            keyboardType: TextInputType.url,
                            textInputAction: TextInputAction.done,
                            controller: _imageUrlController,
                            focusNode: _imageUrlFocusNode,
                            onFieldSubmitted: (_) => _saveForm(),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Please enter a image url";
                              }

                              if (!value.startsWith("http") ||
                                  !value.startsWith("https")) {
                                return "Please enter a valid url";
                              }

                              return null;
                            },
                            onSaved: (newValue) {
                              _editedProduct = Product(
                                id: _editedProduct.id,
                                title: _editedProduct.title,
                                description: _editedProduct.description,
                                price: _editedProduct.price,
                                imageUrl: newValue ?? "",
                                isFavorite: _editedProduct.isFavorite,
                              );
                            },
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
    );
  }
}
