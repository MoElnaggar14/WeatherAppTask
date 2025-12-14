# SwiftGen Custom Templates

Custom SwiftGen templates for Swift 6 compliance with strict concurrency.

## xcassets-swift6.stencil

Swift 6 compliant template for generating color assets from `.xcassets`.

### Features

✅ **Swift 6 Compliant** - Full strict concurrency support
✅ **Sendable Types** - All types conform to Sendable
✅ **@MainActor Isolation** - UI-related properties properly isolated
✅ **Struct Instead of Class** - Immutable, value-type ColorAsset
✅ **No Mutable State** - Thread-safe by design
✅ **Modern iOS 17+** - No unnecessary availability checks

### Generated Code

```swift
public enum AppColors: Sendable {
  public static let primary = ColorAsset(name: "primary")
  // ...
}

public struct ColorAsset: Sendable {
  public let name: String  // Immutable

  // UIKit/AppKit (MainActor isolated)
  @MainActor
  public var uiColor: UIColor { /* ... */ }

  // SwiftUI (NOT MainActor isolated - can be used anywhere!)
  public var color: SwiftUI.Color { /* ... */ }
}

// Convenience initializer
extension SwiftUI.Color {
  public init(_ asset: ColorAsset)
}
```

### Key Differences from Default Template

| Feature | Default | Swift 6 Template |
|---------|---------|------------------|
| Base Type | `class` | `struct` |
| Sendable | ❌ | ✅ |
| MainActor | ❌ | ✅ |
| Mutable State | ❌ `lazy var` | ✅ Computed properties |
| Concurrency Safe | ❌ | ✅ |

### Usage

Already configured in `swiftgen.yml`:

```yaml
xcassets:
  - inputs:
      - WeatherApp/Core/Resources/Assets/Colors.xcassets
    outputs:
      - templatePath: Templates/SwiftGen/xcassets-swift6.stencil
        output: WeatherApp/Core/Resources/Assets/Generated/Colors+Generated.swift
```

Run `rake generate` to regenerate.

## Usage Examples

### SwiftUI (Recommended)

```swift
import SwiftUI

struct MyView: View {
    var body: some View {
        Text("Hello")
            .foregroundColor(AppColors.primary.color)  // ✅ Clean!

        // Or use convenience initializer
        Text("World")
            .foregroundColor(Color(AppColors.textPrimary))  // ✅ Also clean!
    }
}
```

### UIKit

```swift
import UIKit

class MyViewController: UIViewController {
    @MainActor
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = AppColors.background.uiColor  // ✅ MainActor isolated
    }
}
```

### Key Benefits

✅ **SwiftUI**: Just `.color` - natural and clean
✅ **UIKit**: `.uiColor` - explicit and safe
✅ **No MainActor issues**: SwiftUI Color construction is not MainActor isolated
✅ **Type-safe**: Compiler ensures correct usage
