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
  final Map<String, String> _selectedOptions = {};

  @override
  void initState() {
    super.initState();
    // Pre-select required modifiers if they have options
    for (var modifier in widget.item.modifiers) {
      if (modifier.isRequired && modifier.options.isNotEmpty) {
        _selectedOptions[modifier.id] = modifier.options[0].id;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final posProvider = Provider.of<PosProvider>(context, listen: false);

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
      clipBehavior: Clip.antiAlias,
      child: Container(
        width: 1000,
        height: 700,
        color: Colors.white,
        child: Row(
          children: [
            // Left: Large Image
            Expanded(
              flex: 4,
              child: Image.network(
                widget.item.imageUrl,
                fit: BoxFit.cover,
                height: double.infinity,
              ),
            ),
            
            // Right: Info & Customization
            Expanded(
              flex: 6,
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
                    const SizedBox(height: 12),
                    Text(
                      widget.item.description,
                      style: TextStyle(fontSize: 16, color: Colors.grey.shade600, height: 1.5),
                    ),
                    const SizedBox(height: 24),
                    
                    Expanded(
                      child: ListView(
                        children: [
                          ...widget.item.modifiers.map((modifier) => Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    modifier.name,
                                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                  ),
                                  if (modifier.isRequired)
                                    Padding(
                                      padding: const EdgeInsets.only(left: 8),
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                        decoration: BoxDecoration(
                                          color: Colors.red.shade50,
                                          borderRadius: BorderRadius.circular(4),
                                        ),
                                        child: const Text('REQUIRED', style: TextStyle(color: Colors.red, fontSize: 10, fontWeight: FontWeight.bold)),
                                      ),
                                    ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Wrap(
                                spacing: 12,
                                runSpacing: 12,
                                children: modifier.options.map((option) {
                                  final isSelected = _selectedOptions[modifier.id] == option.id;
                                  return ChoiceChip(
                                    label: Text('${option.name} ${option.price > 0 ? '(+\$${option.price.toStringAsFixed(2)})' : ''}'),
                                    selected: isSelected,
                                    onSelected: (selected) {
                                      setState(() {
                                        if (selected) {
                                          _selectedOptions[modifier.id] = option.id;
                                        } else if (!modifier.isRequired) {
                                          _selectedOptions.remove(modifier.id);
                                        }
                                      });
                                    },
                                    selectedColor: Theme.of(context).primaryColor,
                                    labelStyle: TextStyle(
                                      color: isSelected ? Colors.white : Colors.black87,
                                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                    ),
                                  );
                                }).toList(),
                              ),
                              const SizedBox(height: 24),
                            ],
                          )),
                          
                          // Quantity Selector
                          const Text('Quantity', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade100,
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    _IconButton(
                                      icon: Icons.remove_rounded,
                                      onPressed: _quantity > 1 ? () => setState(() => _quantity--) : null,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 16),
                                      child: Text(
                                        '$_quantity',
                                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
                                      ),
                                    ),
                                    _IconButton(
                                      icon: Icons.add_rounded,
                                      onPressed: () => setState(() => _quantity++),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 40),
                        ],
                      ),
                    ),
                    
                    // Add to Order Button
                    SizedBox(
                      width: double.infinity,
                      height: 80,
                      child: ElevatedButton(
                        onPressed: _canAdd() ? () {
                          String notes = '';
                          _selectedOptions.forEach((modId, optId) {
                            final mod = widget.item.modifiers.firstWhere((m) => m.id == modId);
                            final opt = mod.options.firstWhere((o) => o.id == optId);
                            notes += '${mod.name}: ${opt.name}\n';
                          });
                          
                          posProvider.addToCart(
                            widget.item, 
                            quantity: _quantity, 
                            notes: notes.trim().isEmpty ? null : notes.trim(),
                          );
                          Navigator.pop(context);
                        } : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).primaryColor,
                          foregroundColor: Colors.white,
                          disabledBackgroundColor: Colors.grey.shade300,
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

  bool _canAdd() {
    for (var modifier in widget.item.modifiers) {
      if (modifier.isRequired && !_selectedOptions.containsKey(modifier.id)) {
        return false;
      }
    }
    return true;
  }
}

class _IconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onPressed;

  const _IconButton({required this.icon, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(icon, size: 20),
      onPressed: onPressed,
      style: IconButton.styleFrom(
        backgroundColor: Colors.white,
        padding: const EdgeInsets.all(8),
      ),
    );
  }
}
