import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:provider/provider.dart';

import '../providers/products.dart';
import '../screens/edit_product_screen.dart';

class UserProductItem extends StatelessWidget {
  final String id;
  final String title;
  final String imageUrl;

  void _openGallery(BuildContext context) {
    Navigator.of(context)
        .pushNamed(GalleryWidget.routeName, arguments: imageUrl);
  }

  const UserProductItem({
    super.key,
    required this.id,
    required this.title,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    final scaffold = ScaffoldMessenger.of(context);

    return ListTile(
      title: Text(title),
      leading: GestureDetector(
        onTap: () => _openGallery(context),
        child: CircleAvatar(
          backgroundImage: NetworkImage(imageUrl),
        ),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            onPressed: () => Navigator.of(context).pushNamed(
              EditProductScreen.routeName,
              arguments: id,
            ),
            icon: const Icon(Icons.edit),
            color: Theme.of(context).primaryColor,
          ),
          IconButton(
            onPressed: () => showDialog(
                context: context,
                builder: (ctx) {
                  return AlertDialog(
                    title: const Text('Are you sure to delete this product?'),
                    alignment: Alignment.center,
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text('cancel'),
                      ),
                      TextButton(
                        onPressed: () async {
                          try {
                            await Provider.of<Products>(context, listen: false)
                                .deleteProduct(id)
                                .then((value) {
                              Navigator.of(context).pop();
                            });
                          } catch (e) {
                            print(e);
                            scaffold.showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Deleting failed!',
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            );
                            Navigator.of(context).pop();
                          }
                        },
                        child: const Text('sure'),
                      )
                    ],
                  );
                }),
            icon: const Icon(Icons.delete),
            color: Theme.of(context).errorColor,
          ),
        ],
      ),
    );
  }
}

class GalleryWidget extends StatefulWidget {
  static const routeName = '/gallery';

  const GalleryWidget({super.key});

  @override
  State<GalleryWidget> createState() => _GalleryWidgetState();
}

class _GalleryWidgetState extends State<GalleryWidget> {
  @override
  Widget build(BuildContext context) {
    final urlImage = ModalRoute.of(context)!.settings.arguments;

    return Scaffold(
      body: PhotoView(
        imageProvider: NetworkImage(urlImage as String),
        onTapDown: (ctx, detail, value) => Navigator.of(context).pop(),
      ),
    );
  }
}
