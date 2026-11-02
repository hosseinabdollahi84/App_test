# Soft Shop (UI test build)

A UI-only Flutter shop demo in a soft, cotton-like style: Products and Profile
screens, a floating bottom nav, and a hero transition into product details.
All data is mock data from `lib/data/mock_data.dart`; there is no backend.

## Run

```sh
flutter pub get
flutter run          # on a connected device or emulator
flutter test         # widget smoke tests (incl. small/large phone sizes)
```

Product and avatar photos load from Unsplash, so the device needs internet
access; without it, soft placeholders are shown instead.

## Structure

- `lib/theme/app_theme.dart` – colors, spacing, radii, shadows, type, motion
- `lib/data/mock_data.dart`, `lib/models/product.dart` – mock data
- `lib/screens/` – app shell (tabs), home, product detail, profile
- `lib/widgets/` – ProductCard, SoftButton, BottomNav, CategoryChips, etc.
- `assets/fonts/` – Nunito (SIL Open Font License, see `OFL.txt`)
