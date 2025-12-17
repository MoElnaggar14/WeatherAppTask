# Weather App - Interview Questions & Answers

This document contains potential interview questions about this project and comprehensive answers to help you prepare.

---

## Table of Contents

1. [Architecture & Design Patterns](#architecture--design-patterns)
2. [SwiftUI & iOS Development](#swiftui--ios-development)
3. [Networking & Data Layer](#networking--data-layer)
4. [Data Persistence](#data-persistence)
5. [Error Handling](#error-handling)
6. [Testing](#testing)
7. [Security](#security)
8. [Performance](#performance)
9. [Code Quality](#code-quality)
10. [General iOS Questions](#general-ios-questions)

---

## Architecture & Design Patterns

### Q1: What architecture pattern did you use and why?

**Answer:**
I used **Clean Architecture** combined with **MVVM** (Model-View-ViewModel) pattern.

**Layers:**
- **Presentation Layer**: SwiftUI Views + ViewModels using the `@Observable` macro
- **Domain Layer**: Use Cases and Entity models (business logic)
- **Data Layer**: Repositories, DTOs, and Data Sources

**Why Clean Architecture?**
1. **Separation of Concerns**: Each layer has a single responsibility
2. **Testability**: Business logic is isolated and easily testable
3. **Scalability**: Easy to add new features without affecting existing code
4. **Dependency Rule**: Inner layers don't know about outer layers
5. **Flexibility**: Can swap implementations (e.g., change database) without affecting business logic

```
View → ViewModel → UseCase → Repository → DataSource (Network/Local)
```

### Q2: Explain the Dependency Inversion Principle in your implementation.

**Answer:**
The app follows DIP through protocol-based abstractions:

```swift
// Protocol definition (abstraction)
protocol WeatherRepositoryProtocol {
    func fetchWeather(for cityName: String) async throws -> Weather
    func getAllCities() async throws -> [City]
}

// Concrete implementation
final class WeatherRepository: WeatherRepositoryProtocol {
    private let networkManager: NetworkProtocol
    private let localDataSource: LocalDataSourceProtocol
    // Implementation...
}

// Use case depends on abstraction, not concrete class
final class FetchWeatherUseCase {
    private let repository: WeatherRepositoryProtocol

    init(repository: WeatherRepositoryProtocol = WeatherRepository()) {
        self.repository = repository
    }
}
```

**Benefits:**
- High-level modules don't depend on low-level modules
- Easy to mock for testing
- Supports dependency injection

### Q3: What is the purpose of Use Cases in your architecture?

**Answer:**
Use Cases encapsulate business logic and represent a single action the user can perform:

```swift
final class FetchWeatherUseCase: FetchWeatherUseCaseProtocol {
    private let repository: WeatherRepositoryProtocol

    func execute(cityName: String) async throws -> Weather {
        // Business logic here
        let weather = try await repository.fetchWeather(for: cityName)
        try await repository.addWeather(weather, to: city)
        return weather
    }
}
```

**Benefits:**
1. **Single Responsibility**: Each use case does one thing
2. **Reusability**: Can be used by multiple ViewModels
3. **Testability**: Easy to test in isolation
4. **Documentation**: Self-documenting code - use case names describe what the app does

### Q4: How do you handle navigation in the app?

**Answer:**
I use SwiftUI's native navigation with `NavigationStack` and `NavigationPath`:

```swift
@State private var navigationPath = NavigationPath()

NavigationStack(path: $navigationPath) {
    // Content
}
.navigationDestination(for: City.self) { city in
    HistoricalWeatherView(city: city)
}
```

For modal presentations, I use sheets:
```swift
.sheet(isPresented: $viewModel.showAddCity) {
    AddCityView { city in
        // Handle city added
    }
}
```

**Why this approach?**
- Type-safe navigation
- Supports deep linking
- Easy state management
- Native SwiftUI patterns

---

## SwiftUI & iOS Development

### Q5: Why did you use `@Observable` instead of `ObservableObject`?

**Answer:**
`@Observable` (introduced in iOS 17) offers several advantages:

```swift
@MainActor
@Observable
final class CitiesViewModel {
    private(set) var cities: [City] = []
    private(set) var isLoading = false
}
```

**Advantages over ObservableObject:**
1. **Automatic tracking**: No need for `@Published` wrappers
2. **Granular updates**: Only views using changed properties re-render
3. **Better performance**: Reduces unnecessary view updates
4. **Cleaner syntax**: Less boilerplate code
5. **Works with value types**: Can observe computed properties

**Usage in View:**
```swift
@State private var viewModel = CitiesViewModel()
// No need for @StateObject or @ObservedObject
```

### Q6: How do you handle async/await in SwiftUI?

**Answer:**
I use `.task` modifier and `Task` blocks:

```swift
struct CitiesListView: View {
    var body: some View {
        List { /* ... */ }
        .task {
            await viewModel.loadCities()
        }
        .refreshable {
            await viewModel.loadCities()
        }
    }
}
```

For user-triggered actions:
```swift
Button("Delete") {
    Task {
        await viewModel.deleteCity(city)
    }
}
```

**Key considerations:**
- `.task` automatically cancels when view disappears
- ViewModels are marked `@MainActor` for UI updates
- Use `Task.isCancelled` to handle cancellation

### Q7: Explain your approach to building reusable UI components.

**Answer:**
I created a Design System with reusable components:

```swift
// AppTheme.swift - Centralized design tokens
enum AppTheme {
    enum Colors {
        static let accent = Color("AccentColor")
        static let background = Color("Background")
    }

    enum Typography {
        static let headline = Font.system(size: 17, weight: .semibold)
    }

    enum Spacing {
        static let md: CGFloat = 16
    }
}

// Reusable components
struct ErrorView: View {
    let error: AppError
    let retryAction: (() -> Void)?
    // Consistent error display across app
}

struct WeatherCard: View {
    let iconURL: URL?
    let description: String
    let temperature: String
    // Reusable weather display
}
```

**Benefits:**
- Consistent UI across the app
- Easy to update design system-wide
- Reduces code duplication
- Follows Apple Human Interface Guidelines

### Q8: How do you handle different screen states (loading, error, empty, content)?

**Answer:**
I use explicit state handling in ViewModels and Views:

```swift
// ViewModel
@Observable
final class CitiesViewModel {
    private(set) var isLoading = false
    private(set) var error: Error?
    private(set) var cities: [City] = []

    var appError: AppError? {
        guard let error else { return nil }
        return AppError.from(error)
    }
}

// View
var body: some View {
    if viewModel.isLoading && viewModel.cities.isEmpty {
        ProgressView()
    } else if let error = viewModel.appError, viewModel.cities.isEmpty {
        ErrorView(error: error, retryAction: { /* retry */ })
    } else if viewModel.cities.isEmpty {
        EmptyStateView()
    } else {
        ContentView()
    }
}
```

---

## Networking & Data Layer

### Q9: Describe your networking layer architecture.

**Answer:**
The networking layer follows a protocol-oriented design:

```swift
// Endpoint protocol for type-safe API definitions
protocol Endpoint {
    var path: String { get }
    var method: HTTPMethod { get }
    var parameters: [String: Any]? { get }
    var encoding: ParameterEncoding { get }
}

// Concrete endpoint
enum WeatherEndpoint: Endpoint {
    case weather(city: String)

    var path: String {
        switch self {
        case .weather: return "/weather"
        }
    }
}

// Network manager protocol
protocol NetworkProtocol {
    func send<T: Decodable>(api: Endpoint, model: T.Type) async throws -> T
}
```

**Features:**
- Type-safe API definitions
- Centralized error handling
- Easy to mock for testing
- Supports different parameter encodings

### Q10: How do you handle API responses and DTOs?

**Answer:**
I use separate DTOs (Data Transfer Objects) that map to domain entities:

```swift
// DTO - matches API response
struct WeatherResponse: Codable {
    let weather: [WeatherInfo]
    let main: MainInfo

    struct WeatherInfo: Codable {
        let description: String
        let icon: String
    }

    struct MainInfo: Codable {
        let temp: Double
        let humidity: Int
    }
}

// Domain Entity - clean model for business logic
struct Weather: Identifiable, Equatable {
    let id: UUID
    let description: String
    let temperature: Double
    let humidity: Int
    let iconCode: String
}

// Mapping
extension WeatherResponse {
    var toDomain: Weather {
        Weather(
            description: weather.first?.description ?? "",
            temperature: main.temp,
            humidity: main.humidity,
            iconCode: weather.first?.icon ?? ""
        )
    }
}
```

**Why separate DTOs?**
- API changes don't affect business logic
- Domain entities stay clean
- Validation happens during mapping
- Easy to test mapping logic

### Q11: How do you handle secrets like API keys?

**Answer:**
I use **Arkana** for secrets management:

```yaml
# .arkana.yml
import_name: WeatherAppSecrets
namespace: WeatherAppSecrets
package_manager: spm
environments:
  - Debug
  - Release
environment_secrets:
  - baseURL
  - apiKey
```

**How it works:**
1. Secrets stored in `.env` file (not committed)
2. Arkana generates obfuscated Swift code
3. Secrets are compiled into binary
4. Different values for Debug/Release environments

**Usage:**
```swift
import WeatherAppSecrets

let apiKey = WeatherAppSecrets.Global.apiKey
```

---

## Data Persistence

### Q12: Why did you choose Core Data for persistence?

**Answer:**
Core Data was chosen for several reasons:

1. **Complex relationships**: City has many Weather records
2. **Built-in**: No external dependencies
3. **Performance**: Efficient for querying and filtering
4. **Migration support**: Schema versioning built-in
5. **Apple ecosystem**: Best integration with SwiftUI

**Entity structure:**
```swift
@objc(CityEntity)
class CityEntity: NSManagedObject {
    @NSManaged var id: UUID
    @NSManaged var name: String
    @NSManaged var weatherHistory: Set<WeatherInfoEntity>
}
```

### Q13: How do you handle Core Data in a thread-safe way?

**Answer:**
I use background contexts for write operations:

```swift
@MainActor
final class CoreDataLocalDataSource: LocalDataSourceProtocol {
    private let coreDataStack: CoreDataStack

    func saveCity(_ city: City) async throws {
        let context = coreDataStack.newBackgroundContext()

        try await context.perform {
            // All Core Data operations here
            let entity = CityEntity(context: context)
            entity.update(from: city, in: context)

            if context.hasChanges {
                try context.save()
            }
        }
    }
}
```

**Key practices:**
- `viewContext` for reading on main thread
- `newBackgroundContext()` for writes
- `context.perform {}` for thread confinement
- Async/await for clean asynchronous code

---

## Error Handling

### Q14: Describe your error handling strategy.

**Answer:**
I implemented a comprehensive error handling system:

```swift
// Typed errors for the app
enum AppError: LocalizedError, Equatable {
    case networkError(message: String)
    case cityNotFound
    case noInternetConnection
    case serverError
    case deleteFailed
    case unknown

    var errorDescription: String? {
        switch self {
        case .cityNotFound:
            return "City not found. Please check the city name."
        case .noInternetConnection:
            return "No internet connection."
        // ...
        }
    }

    var recoverySuggestion: String? { /* ... */ }
    var iconName: String { /* ... */ }
}
```

**Error conversion:**
```swift
static func from(_ error: Error) -> AppError {
    if let horizonError = error as? HorizonError {
        // Map network errors
    }
    if nsError.domain == NSURLErrorDomain {
        // Map URL errors
    }
    return .unknown
}
```

**UI display:**
```swift
struct ErrorView: View {
    let error: AppError
    let retryAction: (() -> Void)?

    var body: some View {
        VStack {
            Image(systemName: error.iconName)
            Text(error.errorDescription ?? "")
            Text(error.recoverySuggestion ?? "")
            if let retryAction {
                Button("Try Again", action: retryAction)
            }
        }
    }
}
```

### Q15: How do you show errors to users?

**Answer:**
Multiple UI patterns for different scenarios:

1. **Full screen errors** (when no content):
```swift
if let error = viewModel.appError, viewModel.cities.isEmpty {
    ErrorView(error: error, retryAction: { /* ... */ })
}
```

2. **Toast notifications** (non-blocking):
```swift
.toast(isPresented: $showError, message: errorMessage, isError: true)
```

3. **Confirmation dialogs** (destructive actions):
```swift
.confirmationDialog("Delete City", isPresented: $showConfirm) {
    Button("Delete", role: .destructive) { /* ... */ }
    Button("Cancel", role: .cancel) { }
}
```

---

## Testing

### Q16: What testing strategies do you use?

**Answer:**
I implement multiple testing levels:

1. **Unit Tests** - Business logic:
```swift
final class CitiesViewModelTests: XCTestCase {
    var sut: CitiesViewModel!
    var mockRepository: MockWeatherRepository!

    func test_loadCities_success() async {
        // Given
        mockRepository.citiesToReturn = [City.mock]

        // When
        await sut.loadCities()

        // Then
        XCTAssertEqual(sut.cities.count, 1)
        XCTAssertFalse(sut.isLoading)
    }
}
```

2. **Snapshot Tests** - UI consistency:
```swift
final class ComponentSnapshotTests: XCTestCase {
    func test_errorView() {
        let view = ErrorView(error: .noInternetConnection, retryAction: nil)
        assertSnapshot(of: view, as: .image)
    }
}
```

3. **Entity Tests** - Model behavior:
```swift
func test_city_addingWeather() {
    let city = City(name: "London")
    let weather = Weather(description: "Sunny", ...)

    let updated = city.addingWeather(weather)

    XCTAssertEqual(updated.weatherHistory.count, 1)
}
```

### Q17: How do you make your code testable?

**Answer:**
Key practices for testability:

1. **Protocol-based dependencies:**
```swift
protocol WeatherRepositoryProtocol {
    func fetchWeather(for city: String) async throws -> Weather
}

// Mock for testing
class MockWeatherRepository: WeatherRepositoryProtocol {
    var weatherToReturn: Weather?
    var errorToThrow: Error?

    func fetchWeather(for city: String) async throws -> Weather {
        if let error = errorToThrow { throw error }
        return weatherToReturn!
    }
}
```

2. **Dependency injection:**
```swift
final class FetchWeatherUseCase {
    private let repository: WeatherRepositoryProtocol

    init(repository: WeatherRepositoryProtocol = WeatherRepository()) {
        self.repository = repository
    }
}
```

3. **Preview support in ViewModels:**
```swift
init(isPreview: Bool = false, mockCities: [City] = []) {
    self.isPreview = isPreview
    if isPreview {
        cities = mockCities
    }
}
```

---

## Security

### Q18: What security considerations did you implement?

**Answer:**

1. **API Key Protection:**
   - Using Arkana for obfuscated secrets
   - Keys not stored in source control
   - Different keys per environment

2. **Network Security:**
   - HTTPS only (App Transport Security)
   - Certificate pinning consideration

3. **Data Protection:**
   - Core Data stored in protected container
   - No sensitive data in UserDefaults

4. **Input Validation:**
   - Sanitize user inputs before API calls
   - Validate API responses before processing

---

## Performance

### Q19: What performance optimizations did you implement?

**Answer:**

1. **Lazy Loading:**
```swift
LazyVStack(spacing: 0) {
    ForEach(cities) { city in
        CityRowView(city: city)
    }
}
```

2. **Image Caching:**
   - Weather icons cached by URL session
   - AsyncImage with placeholder

3. **Debouncing:**
```swift
func search(query: String) async {
    searchTask?.cancel()
    searchTask = Task {
        try? await Task.sleep(nanoseconds: 300_000_000)
        guard !Task.isCancelled else { return }
        // Perform search
    }
}
```

4. **Weather Caching:**
```swift
func fetchWeather() async {
    // Skip if recent data exists
    if let latest = city.latestWeather,
       Date().timeIntervalSince(latest.requestDate) < 60 {
        return
    }
    // Fetch new data
}
```

5. **Background Context for writes:**
   - Main thread not blocked during saves
   - Smooth UI during data operations

### Q20: How do you handle memory management?

**Answer:**

1. **Automatic Reference Counting (ARC):**
   - No retain cycles in closures
   - Weak references where needed

2. **Task Cancellation:**
```swift
private var searchTask: Task<Void, Never>?

func search(query: String) async {
    searchTask?.cancel()  // Cancel previous
    searchTask = Task { /* ... */ }
}
```

3. **View Lifecycle:**
   - `.task` modifier auto-cancels
   - No manual cleanup needed

---

## Code Quality

### Q21: What tools do you use for code quality?

**Answer:**

1. **SwiftLint** - Linting:
```yaml
# .swiftlint.yml
disabled_rules:
  - trailing_whitespace
opt_in_rules:
  - empty_count
  - closure_spacing
```

2. **SwiftFormat** - Formatting:
```
# .swiftformat
--indent 4
--trimwhitespace always
```

3. **Rake Tasks:**
```bash
rake lint    # Run SwiftLint
rake format  # Run SwiftFormat
rake check   # Both
```

### Q22: How do you organize your code?

**Answer:**

1. **MARK comments:**
```swift
// MARK: - Properties
// MARK: - Lifecycle
// MARK: - Public Methods
// MARK: - Private Methods
```

2. **File structure:**
```
WeatherApp/
├── Core/
│   ├── App/
│   ├── Business/        # Use Cases, Entities
│   ├── Data/            # Repositories, DTOs
│   ├── DataSource/      # Network, Cache
│   └── DesignSystem/    # Reusable UI
└── Modules/
    ├── Cities/
    ├── AddCity/
    └── WeatherDetail/
```

3. **Naming conventions:**
   - ViewModels: `{Feature}ViewModel`
   - Views: `{Feature}View`
   - Use Cases: `{Action}UseCase`

---

## General iOS Questions

### Q23: What iOS features are you using?

**Answer:**

1. **iOS 17+ Features:**
   - `@Observable` macro
   - SwiftUI navigation improvements
   - String Catalogs for localization

2. **SwiftUI Features:**
   - `NavigationStack` with type-safe paths
   - `.searchable` modifier
   - `.confirmationDialog`
   - Pull-to-refresh with `.refreshable`

3. **Swift Concurrency:**
   - async/await throughout
   - `@MainActor` for UI safety
   - Structured concurrency with Task

### Q24: How do you handle localization?

**Answer:**
Using String Catalogs (`.xcstrings`):

```swift
// Generated L10n enum
public enum L10n {
    public static let citiesTitle = L10n.tr("cities_title", fallback: "Cities")

    public static func weatherInformationForReceivedOn(_ p1: CVarArg) -> String {
        return L10n.tr("WEATHER INFORMATION FOR %@ RECEIVED ON", p1)
    }
}
```

**Usage:**
```swift
Text(L10n.citiesTitle)
Text(L10n.weatherInformationForReceivedOn(city.name))
```

**Supported languages:** English, Arabic (with RTL support)

### Q25: What would you improve if you had more time?

**Answer:**

1. **Features:**
   - Weather forecast (not just current)
   - Location-based weather
   - Widgets and Watch app
   - Push notifications for weather alerts

2. **Technical:**
   - Offline-first with sync
   - Better caching strategy
   - Analytics integration
   - Accessibility improvements

3. **Testing:**
   - UI tests with XCUITest
   - Integration tests
   - Performance tests
   - Higher code coverage

---

## Quick Reference

### Key Files to Know:
- `WeatherRepository.swift` - Data layer hub
- `CitiesViewModel.swift` - Main screen logic
- `AppError.swift` - Error handling
- `AppTheme.swift` - Design system
- `CoreDataLocalDataSource.swift` - Persistence

### Architecture Flow:
```
User Action → View → ViewModel → UseCase → Repository → DataSource
                                                      ↓
                                              Network / CoreData
```

### Key Patterns Used:
- Clean Architecture
- MVVM
- Repository Pattern
- Dependency Injection
- Protocol-Oriented Programming
- Coordinator Pattern (implicit in NavigationStack)

---

*Good luck with your interview!*
