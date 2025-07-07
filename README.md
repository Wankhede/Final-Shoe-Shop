# SoleStyle - Premium Shoe Shop Flutter Application

A beautiful, feature-rich shoe shopping application built with Flutter that works seamlessly on both mobile and web platforms.

## Features

### User Features
- **Beautiful UI/UX**: Modern, responsive design with smooth animations
- **Category Browsing**: Browse shoes by categories (Men, Women, Kids, Sports)
- **Product Details**: Detailed product pages with multiple images, ratings, and features
- **Shopping Cart**: Add items to cart with size and color selection
- **User Authentication**: Secure login system with demo accounts
- **Responsive Design**: Works perfectly on mobile, tablet, and web

### Admin Features
- **Product Management**: Add, edit, and delete products
- **Image Upload**: Camera integration and gallery access for product photos
- **Inventory Control**: Manage stock status and product details
- **Dashboard Analytics**: Overview of products, orders, and users
- **Real-time Updates**: Instant reflection of changes across the app

### Technical Features
- **Cross-Platform**: Single codebase for iOS, Android, and Web
- **State Management**: Provider pattern for efficient state management
- **Image Handling**: Camera and gallery integration with image_picker
- **Caching**: Network image caching for better performance
- **Material Design**: Following Material Design 3 guidelines

## Getting Started

### Prerequisites
- Flutter SDK (>=3.10.0)
- Dart SDK (>=3.0.0)
- Android Studio / VS Code
- For web: Chrome browser
- For mobile: Android/iOS device or emulator

### Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd shoe_shop
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the application**
   
   For mobile:
   ```bash
   flutter run
   ```
   
   For web:
   ```bash
   flutter run -d chrome
   ```

### Demo Accounts

**Admin Access:**
- Email: `admin@shoeshop.com`
- Password: `admin`

**User Access:**
- Email: `user@example.com`
- Password: `user`

## Project Structure

```
lib/
├── main.dart                 # App entry point
├── models/                   # Data models
│   ├── user.dart
│   ├── shoe.dart
│   ├── category.dart
│   └── cart_item.dart
├── providers/                # State management
│   └── app_provider.dart
├── screens/                  # UI screens
│   ├── splash_screen.dart
│   ├── home_screen.dart
│   ├── login_screen.dart
│   ├── category_screen.dart
│   ├── product_detail_screen.dart
│   └── admin_dashboard.dart
├── widgets/                  # Reusable widgets
│   ├── custom_app_bar.dart
│   └── product_form.dart
├── data/                     # Mock data
│   └── mock_data.dart
└── utils/                    # Utilities
    └── theme.dart
```

## Key Dependencies

- **provider**: State management
- **image_picker**: Camera and gallery access
- **cached_network_image**: Image caching
- **flutter_rating_bar**: Star ratings
- **uuid**: Unique ID generation
- **camera**: Camera functionality
- **permission_handler**: Permission management

## Platform Support

- ✅ **Android** (API 21+)
- ✅ **iOS** (iOS 11+)
- ✅ **Web** (Chrome, Firefox, Safari, Edge)
- ✅ **Desktop** (Windows, macOS, Linux) - with minor adjustments

## Features in Detail

### User Experience
- Smooth navigation with hero animations
- Pull-to-refresh functionality
- Infinite scroll for product listings
- Search and filter capabilities
- Wishlist functionality
- Order tracking

### Admin Capabilities
- Bulk product operations
- Advanced analytics dashboard
- Order management system
- User management
- Inventory tracking
- Sales reporting

### Performance Optimizations
- Image lazy loading
- Efficient list rendering
- Memory management
- Network request optimization
- Local data caching

## Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Support

For support, email support@solestyle.com or create an issue in the repository.

---

Built with ❤️ using Flutter