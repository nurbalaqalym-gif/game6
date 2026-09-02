import 'package:flutter/material.dart';

void main() {
  runApp(const LunaShop());
}

// ============================================================
// APP
// ============================================================

class LunaShop extends StatelessWidget {
  const LunaShop({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'LUNA',
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF7F6F3),
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF222222)),
      ),
      home: const ShopHome(),
    );
  }
}

// ============================================================
// PRODUCT
// ============================================================

class Product {
  final int id;
  final String name;
  final String category;
  final double price;
  final String image;
  final String description;

  const Product({
    required this.id,
    required this.name,
    required this.category,
    required this.price,
    required this.image,
    required this.description,
  });
}

// ============================================================
// DATA
// ============================================================

final List<Product> allProducts = [
  Product(
    id: 1,
    name: 'Basic White T-Shirt',
    category: 'Clothes',
    price: 29,
    image: 'https://images.unsplash.com/photo-1521572163474-6864f9cf17ab?w=800',
    description:
        'A clean and comfortable basic T-shirt made from soft cotton. Perfect for everyday outfits.',
  ),
  Product(
    id: 2,
    name: 'Oversized Black Hoodie',
    category: 'Clothes',
    price: 59,
    image: 'https://images.unsplash.com/photo-1556821840-3a63f95609a7?w=800',
    description:
        'Stylish oversized hoodie with a soft interior. Comfortable and perfect for casual looks.',
  ),
  Product(
    id: 3,
    name: 'Classic Sneakers',
    category: 'Shoes',
    price: 89,
    image: 'https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=800',
    description:
        'Classic sneakers with a comfortable sole and modern minimal design.',
  ),
  Product(
    id: 4,
    name: 'Daily Running Shoes',
    category: 'Shoes',
    price: 99,
    image: 'https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=800',
    description:
        'Lightweight running shoes designed for comfort and everyday movement.',
  ),
  Product(
    id: 5,
    name: 'Elegant Leather Bag',
    category: 'Bags',
    price: 120,
    image: 'https://images.unsplash.com/photo-1584917865442-de89df76afd3?w=800',
    description:
        'Elegant everyday bag with a spacious interior and premium leather style.',
  ),
  Product(
    id: 6,
    name: 'Mini Shoulder Bag',
    category: 'Bags',
    price: 79,
    image: 'https://images.unsplash.com/photo-1594223274512-ad4803739b7c?w=800',
    description:
        'Small and stylish shoulder bag that works perfectly with everyday outfits.',
  ),
  Product(
    id: 7,
    name: 'Classic Watch',
    category: 'Watches',
    price: 75,
    image: 'https://images.unsplash.com/photo-1524805444758-089113d48a6d?w=800',
    description:
        'Minimal classic watch with an elegant design for everyday wear.',
  ),
  Product(
    id: 8,
    name: 'Luxury Gold Watch',
    category: 'Watches',
    price: 150,
    image: 'https://images.unsplash.com/photo-1523170335258-f5ed11844a49?w=800',
    description: 'Elegant gold-style watch with a premium appearance.',
  ),
];

// ============================================================
// MAIN APP
// ============================================================

class ShopHome extends StatefulWidget {
  const ShopHome({super.key});

  @override
  State<ShopHome> createState() => _ShopHomeState();
}

class _ShopHomeState extends State<ShopHome> {
  int currentPage = 0;

  final List<Product> cart = [];
  final List<Product> favorites = [];

  void toggleFavorite(Product product) {
    setState(() {
      if (favorites.any((item) => item.id == product.id)) {
        favorites.removeWhere((item) => item.id == product.id);
      } else {
        favorites.add(product);
      }
    });
  }

  bool isFavorite(Product product) {
    return favorites.any((item) => item.id == product.id);
  }

  void addToCart(Product product) {
    setState(() {
      cart.add(product);
    });
  }

  void openProduct(Product product) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ProductDetails(
          product: product,
          isFavorite: isFavorite(product),
          onFavorite: () {
            toggleFavorite(product);
          },
          onAddToCart: () {
            addToCart(product);
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      HomePage(
        favorites: favorites,
        onProductTap: openProduct,
        onFavorite: toggleFavorite,
        isFavorite: isFavorite,
        onCategory: (category) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => CategoryPage(
                category: category,
                onProductTap: openProduct,
                favorites: favorites,
                onFavorite: toggleFavorite,
                isFavorite: isFavorite,
              ),
            ),
          );
        },
      ),

      CatalogPage(
        products: allProducts,
        onProductTap: openProduct,
        favorites: favorites,
        onFavorite: toggleFavorite,
        isFavorite: isFavorite,
      ),

      FavoritesPage(
        favorites: favorites,
        onProductTap: openProduct,
        onFavorite: toggleFavorite,
        isFavorite: isFavorite,
      ),

      CartPage(
        cart: cart,
        onChanged: () {
          setState(() {});
        },
      ),

      const ProfilePage(),
    ];

    return Scaffold(
      body: pages[currentPage],

      bottomNavigationBar: NavigationBar(
        selectedIndex: currentPage,

        onDestinationSelected: (index) {
          setState(() {
            currentPage = index;
          });
        },

        destinations: [
          const NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Home',
          ),

          const NavigationDestination(
            icon: Icon(Icons.grid_view_outlined),
            selectedIcon: Icon(Icons.grid_view),
            label: 'Catalog',
          ),

          NavigationDestination(
            icon: Badge(
              isLabelVisible: favorites.isNotEmpty,
              label: Text('${favorites.length}'),
              child: const Icon(Icons.favorite_border),
            ),
            selectedIcon: const Icon(Icons.favorite),
            label: 'Favorites',
          ),

          NavigationDestination(
            icon: Badge(
              isLabelVisible: cart.isNotEmpty,
              label: Text('${cart.length}'),
              child: const Icon(Icons.shopping_bag_outlined),
            ),
            selectedIcon: const Icon(Icons.shopping_bag),
            label: 'Cart',
          ),

          const NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

// ============================================================
// HOME PAGE
// ============================================================

class HomePage extends StatelessWidget {
  final List<Product> favorites;
  final Function(Product) onProductTap;
  final Function(Product) onFavorite;
  final bool Function(Product) isFavorite;
  final Function(String) onCategory;

  const HomePage({
    super.key,
    required this.favorites,
    required this.onProductTap,
    required this.onFavorite,
    required this.isFavorite,
    required this.onCategory,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
            sliver: SliverToBoxAdapter(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Welcome back',
                        style: TextStyle(color: Colors.grey, fontSize: 14),
                      ),
                      SizedBox(height: 5),
                      Text(
                        'LUNA SHOP',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1,
                        ),
                      ),
                    ],
                  ),

                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Icon(Icons.person),
                  ),
                ],
              ),
            ),
          ),

          // BANNER
          SliverPadding(
            padding: const EdgeInsets.all(20),
            sliver: SliverToBoxAdapter(
              child: Container(
                height: 190,
                padding: const EdgeInsets.all(25),
                decoration: BoxDecoration(
                  color: const Color(0xFF202020),
                  borderRadius: BorderRadius.circular(28),
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'NEW COLLECTION',
                      style: TextStyle(
                        color: Colors.white60,
                        fontSize: 12,
                        letterSpacing: 2,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Find your\nperfect style.',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 29,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // CATEGORIES TITLE
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            sliver: SliverToBoxAdapter(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Categories',
                    style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
                  ),
                  TextButton(onPressed: () {}, child: const Text('All')),
                ],
              ),
            ),
          ),

          // CATEGORIES
          SliverToBoxAdapter(
            child: SizedBox(
              height: 115,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                children: [
                  CategoryButton(
                    icon: Icons.checkroom,
                    title: 'Clothes',
                    onTap: () => onCategory('Clothes'),
                  ),
                  CategoryButton(
                    icon: Icons.shopping_bag,
                    title: 'Bags',
                    onTap: () => onCategory('Bags'),
                  ),
                  CategoryButton(
                    icon: Icons.directions_run,
                    title: 'Shoes',
                    onTap: () => onCategory('Shoes'),
                  ),
                  CategoryButton(
                    icon: Icons.watch,
                    title: 'Watches',
                    onTap: () => onCategory('Watches'),
                  ),
                ],
              ),
            ),
          ),

          // POPULAR
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 15),
            sliver: SliverToBoxAdapter(
              child: const Text(
                'Popular products',
                style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
              ),
            ),
          ),

          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            sliver: SliverGrid(
              delegate: SliverChildBuilderDelegate((context, index) {
                final product = allProducts[index];

                return ProductCard(
                  product: product,
                  isFavorite: isFavorite(product),
                  onTap: () => onProductTap(product),
                  onFavorite: () => onFavorite(product),
                );
              }, childCount: allProducts.length),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 14,
                mainAxisSpacing: 18,
                childAspectRatio: .62,
              ),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 30)),
        ],
      ),
    );
  }
}

// ============================================================
// CATEGORY BUTTON
// ============================================================

class CategoryButton extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const CategoryButton({
    super.key,
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 82,
        margin: const EdgeInsets.only(right: 15),
        child: Column(
          children: [
            Container(
              width: 65,
              height: 65,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Icon(icon, size: 28),
            ),
            const SizedBox(height: 8),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================
// PRODUCT CARD
// ============================================================

class ProductCard extends StatelessWidget {
  final Product product;
  final bool isFavorite;
  final VoidCallback onTap;
  final VoidCallback onFavorite;

  const ProductCard({
    super.key,
    required this.product,
    required this.isFavorite,
    required this.onTap,
    required this.onFavorite,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Stack(
              children: [
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: Image.network(
                    product.image,
                    fit: BoxFit.cover,

                    loadingBuilder: (context, child, progress) {
                      if (progress == null) {
                        return child;
                      }

                      return const Center(child: CircularProgressIndicator());
                    },

                    errorBuilder: (context, error, stackTrace) {
                      return const Center(
                        child: Icon(
                          Icons.image_outlined,
                          size: 45,
                          color: Colors.grey,
                        ),
                      );
                    },
                  ),
                ),

                Positioned(
                  top: 10,
                  right: 10,
                  child: GestureDetector(
                    onTap: onFavorite,
                    child: Container(
                      width: 38,
                      height: 38,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        isFavorite ? Icons.favorite : Icons.favorite_border,
                        size: 20,
                        color: isFavorite ? Colors.red : Colors.black,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 8),

          Text(
            product.category,
            style: const TextStyle(color: Colors.grey, fontSize: 12),
          ),

          const SizedBox(height: 3),

          Text(
            product.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
          ),

          const SizedBox(height: 4),

          Text(
            '\$${product.price.toStringAsFixed(0)}',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// CATEGORY PAGE
// ============================================================

class CategoryPage extends StatelessWidget {
  final String category;
  final Function(Product) onProductTap;
  final List<Product> favorites;
  final Function(Product) onFavorite;
  final bool Function(Product) isFavorite;

  const CategoryPage({
    super.key,
    required this.category,
    required this.onProductTap,
    required this.favorites,
    required this.onFavorite,
    required this.isFavorite,
  });

  @override
  Widget build(BuildContext context) {
    final products = allProducts
        .where((product) => product.category == category)
        .toList();

    return Scaffold(
      appBar: AppBar(title: Text(category)),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: GridView.builder(
          itemCount: products.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 14,
            mainAxisSpacing: 18,
            childAspectRatio: .62,
          ),
          itemBuilder: (context, index) {
            final product = products[index];

            return ProductCard(
              product: product,
              isFavorite: isFavorite(product),
              onTap: () => onProductTap(product),
              onFavorite: () => onFavorite(product),
            );
          },
        ),
      ),
    );
  }
}

// ============================================================
// CATALOG
// ============================================================

class CatalogPage extends StatefulWidget {
  final List<Product> products;
  final Function(Product) onProductTap;
  final List<Product> favorites;
  final Function(Product) onFavorite;
  final bool Function(Product) isFavorite;

  const CatalogPage({
    super.key,
    required this.products,
    required this.onProductTap,
    required this.favorites,
    required this.onFavorite,
    required this.isFavorite,
  });

  @override
  State<CatalogPage> createState() => _CatalogPageState();
}

class _CatalogPageState extends State<CatalogPage> {
  String search = '';

  @override
  Widget build(BuildContext context) {
    final result = widget.products.where((product) {
      return product.name.toLowerCase().contains(search.toLowerCase()) ||
          product.category.toLowerCase().contains(search.toLowerCase());
    }).toList();

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Catalog',
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 20),

            TextField(
              onChanged: (value) {
                setState(() {
                  search = value;
                });
              },
              decoration: InputDecoration(
                hintText: 'Search products...',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(18),
                  borderSide: BorderSide.none,
                ),
              ),
            ),

            const SizedBox(height: 20),

            Expanded(
              child: GridView.builder(
                itemCount: result.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 14,
                  mainAxisSpacing: 18,
                  childAspectRatio: .62,
                ),
                itemBuilder: (context, index) {
                  final product = result[index];

                  return ProductCard(
                    product: product,
                    isFavorite: widget.isFavorite(product),
                    onTap: () => widget.onProductTap(product),
                    onFavorite: () => widget.onFavorite(product),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================
// FAVORITES
// ============================================================

class FavoritesPage extends StatelessWidget {
  final List<Product> favorites;
  final Function(Product) onProductTap;
  final Function(Product) onFavorite;
  final bool Function(Product) isFavorite;

  const FavoritesPage({
    super.key,
    required this.favorites,
    required this.onProductTap,
    required this.onFavorite,
    required this.isFavorite,
  });

  @override
  Widget build(BuildContext context) {
    if (favorites.isEmpty) {
      return SafeArea(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.all(20),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Favorites',
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
              ),
            ),

            const Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.favorite_border, size: 80, color: Colors.grey),
                    SizedBox(height: 15),
                    Text(
                      'No favorites yet',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      'Tap ❤️ on products you like',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    }

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Favorites',
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 20),

            Expanded(
              child: GridView.builder(
                itemCount: favorites.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 14,
                  mainAxisSpacing: 18,
                  childAspectRatio: .62,
                ),
                itemBuilder: (context, index) {
                  final product = favorites[index];

                  return ProductCard(
                    product: product,
                    isFavorite: true,
                    onTap: () => onProductTap(product),
                    onFavorite: () => onFavorite(product),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================
// PRODUCT DETAILS
// ============================================================

class ProductDetails extends StatelessWidget {
  final Product product;
  final bool isFavorite;
  final VoidCallback onFavorite;
  final VoidCallback onAddToCart;

  const ProductDetails({
    super.key,
    required this.product,
    required this.isFavorite,
    required this.onFavorite,
    required this.onAddToCart,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F6F3),

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text('Product details'),
        actions: [
          IconButton(
            onPressed: onFavorite,
            icon: Icon(
              isFavorite ? Icons.favorite : Icons.favorite_border,
              color: isFavorite ? Colors.red : Colors.black,
            ),
          ),
        ],
      ),

      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 15),
                    height: 380,
                    width: double.infinity,
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: Image.network(
                      product.image,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stack) {
                        return const Center(
                          child: Icon(
                            Icons.image,
                            size: 70,
                            color: Colors.grey,
                          ),
                        );
                      },
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(22),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product.category.toUpperCase(),
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 13,
                            letterSpacing: 1.5,
                          ),
                        ),

                        const SizedBox(height: 8),

                        Text(
                          product.name,
                          style: const TextStyle(
                            fontSize: 29,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 10),

                        Text(
                          '\$${product.price.toStringAsFixed(0)}',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 25),

                        const Text(
                          'Description',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 10),

                        Text(
                          product.description,
                          style: const TextStyle(
                            color: Colors.grey,
                            height: 1.6,
                            fontSize: 15,
                          ),
                        ),

                        const SizedBox(height: 25),

                        const Text(
                          'Size',
                          style: TextStyle(
                            fontSize: 19,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 12),

                        Row(
                          children: [
                            _size('S'),
                            _size('M'),
                            _size('L'),
                            _size('XL'),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          Container(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
            color: Colors.white,
            child: SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: () {
                  onAddToCart();

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Added to cart 🛒'),
                      duration: Duration(seconds: 1),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF222222),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(17),
                  ),
                ),
                child: const Text(
                  'ADD TO CART',
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _size(String size) {
    return Container(
      width: 50,
      height: 42,
      margin: const EdgeInsets.only(right: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Center(child: Text(size)),
    );
  }
}

// ============================================================
// CART
// ============================================================

class CartPage extends StatefulWidget {
  final List<Product> cart;
  final VoidCallback onChanged;

  const CartPage({super.key, required this.cart, required this.onChanged});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  Map<int, int> quantities = {};

  int quantity(Product product) {
    return quantities[product.id] ?? 1;
  }

  double get total {
    double sum = 0;

    for (final product in widget.cart) {
      sum += product.price * quantity(product);
    }

    return sum;
  }

  void remove(Product product) {
    setState(() {
      widget.cart.removeWhere((item) => item.id == product.id);
      quantities.remove(product.id);
    });

    widget.onChanged();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.cart.isEmpty) {
      return SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.shopping_bag_outlined,
                size: 85,
                color: Colors.grey,
              ),
              const SizedBox(height: 15),
              const Text(
                'Your cart is empty',
                style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 7),
              const Text(
                'Add products to your cart',
                style: TextStyle(color: Colors.grey),
              ),
            ],
          ),
        ),
      );
    }

    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(20),
            child: Text(
              'My Cart',
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
          ),

          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: widget.cart.length,
              itemBuilder: (context, index) {
                final product = widget.cart[index];

                return Container(
                  margin: const EdgeInsets.only(bottom: 15),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(14),
                        child: Image.network(
                          product.image,
                          width: 90,
                          height: 90,
                          fit: BoxFit.cover,
                        ),
                      ),

                      const SizedBox(width: 13),

                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              product.name,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),

                            const SizedBox(height: 7),

                            Text(
                              '\$${product.price.toStringAsFixed(0)}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            const SizedBox(height: 8),

                            Row(
                              children: [
                                _quantityButton(Icons.remove, () {
                                  setState(() {
                                    final q = quantity(product);

                                    if (q > 1) {
                                      quantities[product.id] = q - 1;
                                    }
                                  });
                                }),

                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                  ),
                                  child: Text(
                                    '${quantity(product)}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),

                                _quantityButton(Icons.add, () {
                                  setState(() {
                                    quantities[product.id] =
                                        quantity(product) + 1;
                                  });
                                }),
                              ],
                            ),
                          ],
                        ),
                      ),

                      IconButton(
                        onPressed: () => remove(product),
                        icon: const Icon(
                          Icons.delete_outline,
                          color: Colors.red,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),

          Container(
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Total',
                      style: TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '\$${total.toStringAsFixed(0)}',
                      style: const TextStyle(
                        fontSize: 23,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 15),

                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => CheckoutPage(total: total),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF222222),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(17),
                      ),
                    ),
                    child: const Text(
                      'CHECKOUT',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _quantityButton(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 28,
        height: 28,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, size: 16),
      ),
    );
  }
}

// ============================================================
// CHECKOUT
// ============================================================

class CheckoutPage extends StatefulWidget {
  final double total;

  const CheckoutPage({super.key, required this.total});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  final nameController = TextEditingController();

  final addressController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    addressController.dispose();
    super.dispose();
  }

  void order() {
    if (nameController.text.isEmpty || addressController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields')),
      );
      return;
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => OrderSuccessPage(name: nameController.text),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Checkout')),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Delivery information',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 20),

            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Full name',
                prefixIcon: Icon(Icons.person_outline),
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                  borderSide: BorderSide.none,
                ),
              ),
            ),

            const SizedBox(height: 15),

            TextField(
              controller: addressController,
              decoration: const InputDecoration(
                labelText: 'Delivery address',
                prefixIcon: Icon(Icons.location_on_outlined),
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                  borderSide: BorderSide.none,
                ),
              ),
              maxLines: 2,
            ),

            const SizedBox(height: 30),

            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Total',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '\$${widget.total.toStringAsFixed(0)}',
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 25),

            SizedBox(
              width: double.infinity,
              height: 58,
              child: ElevatedButton(
                onPressed: order,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF222222),
                  foregroundColor: Colors.white,
                ),
                child: const Text(
                  'PLACE ORDER',
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================
// SUCCESS
// ============================================================

class OrderSuccessPage extends StatelessWidget {
  final String name;

  const OrderSuccessPage({super.key, required this.name});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 100,
                height: 100,
                decoration: const BoxDecoration(
                  color: Color(0xFFE3F5E5),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.check, size: 60, color: Colors.green),
              ),

              const SizedBox(height: 25),

              const Text(
                'Order confirmed!',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 10),

              Text(
                'Thank you, $name!',
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.grey, fontSize: 17),
              ),

              const SizedBox(height: 40),

              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.popUntil(context, (route) => route.isFirst);
                  },
                  child: const Text('BACK TO SHOP'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ============================================================
// PROFILE
// ============================================================

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  void showMessage(BuildContext context, String title) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(title),
        content: Text('$title page is ready.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Profile',
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 30),

            Center(
              child: Column(
                children: [
                  Container(
                    width: 95,
                    height: 95,
                    decoration: const BoxDecoration(
                      color: Color(0xFFE4E0DA),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.person, size: 55),
                  ),

                  const SizedBox(height: 15),

                  const Text(
                    'Welcome!',
                    style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 5),

                  const Text(
                    'LUNA SHOP customer',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 35),

            _item(context, Icons.shopping_bag_outlined, 'My Orders'),

            _item(context, Icons.location_on_outlined, 'Delivery Address'),

            _item(context, Icons.favorite_border, 'My Favorites'),

            _item(context, Icons.notifications_outlined, 'Notifications'),

            _item(context, Icons.settings_outlined, 'Settings'),

            _item(context, Icons.help_outline, 'Help & Support'),
          ],
        ),
      ),
    );
  }

  Widget _item(BuildContext context, IconData icon, String title) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(17),
      ),
      child: ListTile(
        onTap: () => showMessage(context, title),

        leading: Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: const Color(0xFFF0EFEC),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon),
        ),

        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),

        trailing: const Icon(Icons.arrow_forward_ios, size: 15),
      ),
    );
  }
}
