import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/menu_item.dart';
import '../providers/pos_provider.dart';

class ProductDetailDialog extends StatefulWidget {
  final MenuItem item;

  const ProductDetailDialog({super.key, required this.item});

  @override
  State<ProductDetailDialog> createState() => _ProductDetailDialogState();
}

class _ProductDetailDialogState extends State<ProductDetailDialog> {
  int _quantity = 1;
  final TextEditingController _notesController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final posProvider = Provider.of<PosProvider>(context, listen: false);

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
      clipBehavior: Clip.antiAlias,
      child: Container(
        width: 800,
        height: 600,
        color: Colors.white,
        child: Row(
          children: [
            // Left: Large Image
            Expanded(
              flex: 1,
              child: Image.network(
                widget.item.imageUrl,
                fit: BoxFit.cover,
                height: double.infinity,
              ),
            ),
            
            // Right: Info & Customization
            Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.all(40.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            widget.item.name,
                            style: const TextStyle(fontSize: 32, fontWeight: FontWeight.w900),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close_rounded),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      '\$${widget.item.price.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w900,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      widget.item.description,
                      style: TextStyle(fontSize: 18, color: Colors.grey.shade600, height: 1.5),
                    ),
                    const Spacer(),
                    
                    // Quantity Selector
                    const Text('Quantity', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _IconButton(
                            icon: Icons.remove_rounded,
                            onPressed: _quantity > 1 ? () => setState(() => _quantity--) : null,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 24),
                            child: Text(
                              '$_quantity',
                              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900),
                            ),
                          ),
                          _IconButton(
                            icon: Icons.add_rounded,
                            onPressed: () => setState(() => _quantity++),
                          ),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 32),
                    
                    // Add to Order Button
                    SizedBox(
                      width: double.infinity,
                      height: 80,
                      child: ElevatedButton(
                        onPressed: () {
                          posProvider.addToCart(
                            widget.item, 
                            quantity: _quantity, 
                            notes: _notesController.text.isEmpty ? null : _notesController.text,
                          );
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).primaryColor,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                          elevation: 0,
                        ),
                        child: const Text('Add to Order', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _IconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onPressed;

  const _IconButton({required this.icon, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(icon),
      onPressed: onPressed,
      style: IconButton.styleFrom(
        backgroundColor: Colors.white,
        padding: const EdgeInsets.all(12),
      ),
    );
  }
}
