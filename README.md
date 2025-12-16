# WeatherApp

A SwiftUI weather application built with Clean Architecture and MVVM pattern. The app fetches weather data from the OpenWeatherMap API and supports multiple cities with offline caching.

## Features

- View current weather for multiple cities
- Add and remove cities from your list
- View detailed weather information
- Historical weather data
- Offline support with Core Data persistence
- Localization support (English & Arabic)
- Network debugging with Pulse

## Requirements

- **Xcode**: 16.1 or later
- **iOS**: 18.0+
- **Ruby**: 3.3.0 (for build tools)
- **Homebrew**: Required for installing development tools

## Quick Start

### 1. Clone the Repository

```bash
git clone <repository-url>
cd WeatherAppTask
```

### 2. Install Ruby 3.3.0

If you don't have Ruby 3.3.0 installed, use rbenv:

```bash
brew install rbenv ruby-build
rbenv install 3.3.0
rbenv local 3.3.0
```

### 3. Run Setup

The project includes a Rakefile that automates the setup process:

```bash
rake setup
```

This command will:
- Check Ruby version
- Install Bundler
- Install Ruby dependencies (Arkana, Fastlane, etc.)
- Install Git hooks
- Setup Arkana for secrets management
- Install SwiftFormat and SwiftLint via Homebrew

### 4. Configure Environment Variables

Create or update the `.env` file in the project root with your OpenWeatherMap API credentials:

```env
####################### GLOBAL KEYS ################################
####################### DEBUG KEYS ################################
baseURLDebug=https://api.openweathermap.org/data/2.5
apiKeyDebug=YOUR_API_KEY_HERE
####################### RELEASE KEYS ################################
baseURLRelease=https://api.openweathermap.org/data/2.5
apiKeyRelease=YOUR_API_KEY_HERE
```

> **Note**: Get your free API key from [OpenWeatherMap](https://openweathermap.org/api)

### 5. Generate Secrets

After configuring your `.env` file, generate the secrets package:

```bash
bundle exec arkana
```

This creates the `WeatherAppSecrets` local Swift package that securely stores your API credentials.

### 6. Open in Xcode

```bash
open WeatherApp.xcodeproj
```

Select your target device/simulator and run the app (Cmd + R).

## Project Structure

```
WeatherAppTask/
├── WeatherApp/
│   ├── Core/
│   │   ├── App/                    # App entry point & plugins
│   │   ├── Business/               # Use cases & entities
│   │   ├── Data/                   # Repositories & DTOs
│   │   ├── DataSource/             # Network & cache layers
│   │   ├── DesignSystem/           # Reusable UI components
│   │   ├── Localization/           # String catalogs & L10n
│   │   └── Resources/              # Assets & generated code
│   └── Modules/
│       ├── AddCity/                # Add city feature
│       ├── Cities/                 # Cities list feature
│       └── WeatherDetail/          # Weather detail feature
├── WeatherAppTests/                # Unit & snapshot tests
├── Packages/
│   └── WeatherAppSecrets/          # Generated secrets package
├── Scripts/                        # Build scripts
└── Templates/                      # Code templates
```

## Architecture

The app follows **Clean Architecture** principles:

- **Presentation Layer**: SwiftUI Views + ViewModels (MVVM)
- **Domain Layer**: Use Cases & Entity models
- **Data Layer**: Repositories, DTOs & Data Sources

## Dependencies

| Package | Purpose |
|---------|---------|
| [Pulse](https://github.com/kean/Pulse) | Network logging & debugging |
| [SwiftMoLogger](https://github.com/MoElnaggar14/SwiftMoLogger) | Structured logging |
| [SnapshotTesting](https://github.com/pointfreeco/swift-snapshot-testing) | UI snapshot tests |
| [Arkana](https://github.com/rogerluan/arkana) | Secrets management |

## Available Rake Tasks

| Command | Description |
|---------|-------------|
| `rake setup` | Complete project setup |
| `rake format` | Format all Swift code |
| `rake lint` | Lint all Swift code |
| `rake check` | Run linting and formatting |
| `rake generate` | Generate code from assets (colors, strings, etc.) |
| `rake clean` | Clean build artifacts |

Run `rake -T` to see all available tasks.

## Running Tests

### From Xcode

1. Open `WeatherApp.xcodeproj`
2. Press `Cmd + U` to run all tests

### From Command Line

```bash
xcodebuild test -project WeatherApp.xcodeproj -scheme WeatherApp -destination 'platform=iOS Simulator,name=iPhone 16'
```

## Troubleshooting

### Arkana fails to generate secrets

Ensure your `.env` file exists and contains all required keys:
- `baseURLDebug`
- `apiKeyDebug`
- `baseURLRelease`
- `apiKeyRelease`

### Ruby version mismatch

```bash
rbenv install 3.3.0
rbenv local 3.3.0
eval "$(rbenv init -)"
```

### SwiftFormat/SwiftLint not found

```bash
brew install swiftformat swiftlint
```

### Build fails with missing secrets

Run Arkana to regenerate the secrets package:
```bash
bundle exec arkana
```

## License

See [LICENSE.md](LICENSE.md) for details.
