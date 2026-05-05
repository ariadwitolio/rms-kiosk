# Handover Document: Restaurant POS Mobile/Tablet Prototype

## Overview
This prototype serves as a reference for the mobile development team to build a cross-platform POS application. It demonstrates responsive layouts, state management, and a clean widget architecture.

## Architecture Decisions
- **State Management**: Used `Provider` for simplicity and scalability in a prototype. It handles the cart logic and menu filtering.
- **Responsiveness**: Implemented a `ResponsiveLayout` helper that switches between `MobileDashboard` and `TabletDashboard` based on screen width (800px threshold).
- **Navigation**:
    - **Tablet**: Uses a `NavigationRail` for primary navigation to maximize horizontal space.
    - **Mobile**: Uses a `BottomNavigationBar` and a bottom sheet for the cart to optimize for one-handed use.
- **UI/UX**: Follows Material 3 principles with a custom color palette defined in `AppTheme`.

## Key Components
- `PosProvider`: The "brain" of the application. Developers should expand this to include API calls in the production version.
- `CartPanel`: A reusable widget that displays the current order summary. It is used as a persistent side panel on tablets and a modal on mobile.
- `MenuGrid`: Responsive grid that adjusts column count based on the device type.

## Mock Data Implementation
Currently, all data is stored in `lib/providers/pos_provider.dart`. 
**Next Steps for Dev Team:**
1. Replace mock data with REST API or GraphQL integration.
2. Implement local storage (e.g., Sqflite or Hive) for offline capabilities.
3. Integrate with payment gateways.
4. Add printer integration for receipts.

## UI Assets
- Images are currently loaded from Unsplash via URLs.
- Typography uses 'Inter' from Google Fonts.
- Icons are standard Material Icons.

## Platform Support
- **Android/iOS**: Fully supported via Flutter's default rendering.
- **Web**: Supported. Ensure web-specific optimizations (like hover effects) are added if needed.
