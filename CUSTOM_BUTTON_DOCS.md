# CustomButton Widget Documentation

## Overview

The `CustomButton` is a highly reusable and customizable button widget that follows Flutter Material Design guidelines. It supports various layouts, styling options, and provides excellent accessibility features.

## Features

- **Multiple Layout Types**: Icon-only, text-only, or icon with text
- **Material Ink Splash Effect**: Built-in InkWell animations on press
- **Flexible Styling**: Customizable colors, sizes, padding, and border radius
- **Loading States**: Built-in loading indicator support
- **Accessibility**: Proper semantic labels and button semantics
- **Auto Color Contrast**: Automatically determines contrasting text colors

## Basic Usage

### Import the Widget
```dart
import 'package:my_refuge/views/widgets/buttons/custom_button.dart';
```

### Simple Examples

#### Text Only Button
```dart
CustomButton(
  text: "Entrar",
  onPressed: () {
    // Handle button press
  },
)
```

#### Icon Only Button
```dart
CustomButton(
  icon: Icons.favorite,
  onPressed: () {
    // Handle button press
  },
  semanticLabel: 'Mark as favorite', // Important for accessibility
)
```

#### Icon with Text Button
```dart
CustomButton(
  text: "Entrar",
  icon: Icons.login,
  onPressed: () {
    // Handle button press
  },
)
```

## Advanced Usage

### Custom Colors
```dart
CustomButton(
  text: "Custom Button",
  icon: Icons.star,
  backgroundColor: Colors.purple,
  textColor: Colors.white,
  iconColor: Colors.yellow,
  onPressed: () {},
)
```

### Different Sizes
```dart
// Large button
CustomButton(
  text: "Large Button",
  fontSize: 20,
  iconSize: 24,
  padding: EdgeInsets.symmetric(horizontal: 32, vertical: 20),
  onPressed: () {},
)

// Small button
CustomButton(
  text: "Small",
  fontSize: 12,
  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
  onPressed: () {},
)
```

### Loading States
```dart
CustomButton(
  text: isLoading ? "Loading..." : "Submit",
  icon: isLoading ? null : Icons.send,
  isLoading: isLoading,
  onPressed: isLoading ? null : () {
    // Handle submit
  },
)
```

### Custom Styling
```dart
CustomButton(
  text: "Rounded Button",
  borderRadius: 25.0,
  width: 200,
  height: 50,
  elevation: 8.0,
  backgroundColor: Colors.teal,
  onPressed: () {},
)
```

## Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `text` | `String?` | `null` | Text to display on the button |
| `onPressed` | `VoidCallback?` | `null` | Callback when button is pressed |
| `icon` | `IconData?` | `null` | Icon to display |
| `backgroundColor` | `Color?` | Theme primary | Background color |
| `textColor` | `Color?` | Auto-determined | Text color |
| `iconColor` | `Color?` | Same as text | Icon color |
| `width` | `double?` | `null` | Button width |
| `height` | `double?` | `null` | Button height |
| `borderRadius` | `double` | `8.0` | Corner radius |
| `padding` | `EdgeInsetsGeometry?` | Auto-calculated | Internal padding |
| `fontSize` | `double` | `16.0` | Text font size |
| `fontWeight` | `FontWeight` | `FontWeight.w600` | Text font weight |
| `iconSize` | `double?` | `fontSize + 4` | Icon size |
| `isLoading` | `bool` | `false` | Show loading indicator |
| `elevation` | `double` | `4.0` | Shadow elevation when enabled |
| `disabledElevation` | `double` | `0.0` | Shadow elevation when disabled |
| `iconTextSpacing` | `double` | `8.0` | Space between icon and text |
| `splashColor` | `Color?` | White 30% opacity | Ink splash color |
| `highlightColor` | `Color?` | White 10% opacity | Ink highlight color |
| `semanticLabel` | `String?` | `null` | Accessibility label |

## Layout Types and Default Padding

The widget automatically adjusts padding based on content:

- **Icon only**: `EdgeInsets.all(12.0)`
- **Text only**: `EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0)`
- **Icon + text**: `EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0)`

## Accessibility

The CustomButton includes built-in accessibility features:

- Proper button semantics
- Custom semantic labels support
- Enabled/disabled state announcements
- Screen reader compatibility

Always provide `semanticLabel` for icon-only buttons:

```dart
CustomButton(
  icon: Icons.delete,
  semanticLabel: 'Delete item',
  onPressed: () {},
)
```

## Best Practices

1. **Use semantic labels** for icon-only buttons
2. **Provide feedback** for user actions (SnackBar, navigation, etc.)
3. **Handle loading states** for async operations
4. **Choose contrasting colors** for better visibility
5. **Test with screen readers** for accessibility
6. **Use consistent sizing** throughout your app

## Migration from MainButton

If you're migrating from the existing `MainButton`, here's a quick reference:

| MainButton | CustomButton |
|------------|--------------|
| `text` | `text` |
| `onPressed` | `onPressed` |
| `backgroundColor` | `backgroundColor` |
| `textColor` | `textColor` |
| `icon` | `icon` |
| `isLoading` | `isLoading` |
| `borderRadius` | `borderRadius` |
| `padding` | `padding` |
| `textSize` | `fontSize` |
| `fontWeight` | `fontWeight` |
| `elevation` | `elevation` |

New features in CustomButton:
- `iconColor` for separate icon coloring
- `iconSize` for custom icon sizing
- `semanticLabel` for accessibility
- `iconTextSpacing` for layout control
- Better automatic padding based on content type

## Examples in the Repository

- See `/lib/views/pages/custom_button_test_page.dart` for comprehensive examples
- See `/lib/views/pages/custom_button_example_usage.dart` for real-world usage patterns