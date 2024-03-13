import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/cart.dart';

class CartItemWidget extends StatelessWidget {
  final String id;
  final String productId;
  final double price;
  final int quantity;
  final String title;

  const CartItemWidget({
    super.key,
    required this.id,
    required this.productId,
    required this.price,
    required this.quantity,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      builder: (context, snapshot) {
        return Dismissible(
          key: ValueKey(id),
          background: Container(color: Colors.green),
          secondaryBackground: Container(
            color: Theme.of(context).errorColor,
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.only(right: 20),
            child: const Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.0),
                child: Icon(
                  Icons.delete_outlined,
                  color: Colors.white,
                  size: 25,
                ),
              ),
            ),
          ),
          onDismissed: (dismiss) {
            return Provider.of<Cart>(context, listen: false)
                .removeItem(productId);
          },
          confirmDismiss: (direction) {
            // return showDialog(
            //   context: context,
            //   builder: (_) {
            //     return PanaraConfirmDialog.show(
            //       context,
            //       title: "Are you sure?",
            //       message: "Are you sure to remove product",
            //       confirmButtonText: "Confirm",
            //       cancelButtonText: "Cancel",
            //       onTapCancel: () => Navigator.of(context).pop(false),
            //       onTapConfirm: () => Navigator.of(context).pop(true),
            //       panaraDialogType: PanaraDialogType.error,
            //       barrierDismissible: false,
            //     );
            //   },
            // );

            return showDialog(
              context: context,
              builder: (_) {
                return AlertDialog(
                  title: const Text('Are you sure?'),
                  actions: [
                    TextButton(
                      child: const Text('No'),
                      onPressed: () => Navigator.of(context).pop(false),
                    ),
                    TextButton(
                      child: const Text('Yes'),
                      onPressed: () => Navigator.of(context).pop(true),
                    ),
                  ],
                );
              },
            );
          },
          direction: DismissDirection.endToStart,
          child: Card(
            margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: ListTile(
                leading: CircleAvatar(child: Text('\$$price')),
                title: Text(title),
                subtitle: Text('Total: \$${price * quantity}'),
                trailing: Text('$quantity x'),
              ),
            ),
          ),
        );
      },
    );
  }
}
