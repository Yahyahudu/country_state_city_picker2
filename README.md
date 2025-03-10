# Country State City Picker 2 🌍🏙️

A highly customizable Flutter package for selecting country, state, and city with a unified text field-like appearance.

![Demo](https://via.placeholder.com/300x500.png?text=Demo+Preview)  
*(Add your screenshot/gif here)*

---

## ✨ Features
- Modern text field-like dropdown design
- Fully customizable appearance
- Optional labels and hints
- Built-in validation support
- Focus animations and effects
- Null safety
- Country → State → City dependency chaining
- Optional parameter markers
- Flexible input decorations

---

## 📦 Installation

Add the package to your `pubspec.yaml`:

```yaml
dependencies:
  country_state_city_picker2: ^<latest-version>
```

Run:

```sh
flutter pub get
```

---

## 🚀 Basic Usage

```dart
SelectState(
  onCountryChanged: (value) => _country = value,
  onStateChanged: (value) => _state = value,
  onCityChanged: (value) => _city = value,
)
```

---

## 🎨 Customization Options

### 🏳️ Country Dropdown
| Parameter          | Description                  |
|-------------------|------------------------------|
| `countryLabel`   | Label text above dropdown    |
| `countryHint`    | Hint text when no selection  |
| `countryDecoration` | Input decoration for dropdown |
| `countryValidator`  | Validation function         |
| `countryIsOptional` | Shows "(Optional)" text     |

*(Same parameters available for state and city with respective prefixes.)*

---

## 🔧 Full Customization Example

```dart
Form(
  key: _formKey,
  child: SelectState(
    onCountryChanged: (value) => _country = value,
    onStateChanged: (value) => _state = value,
    onCityChanged: (value) => _city = value,
    
    // Country Configuration
    countryLabel: 'Business Location',
    countryHint: 'Select your country',
    countryIsOptional: false,
    countryValidator: (value) => value == null ? 'Required field' : null,
    countryDecoration: InputDecoration(
      prefixIcon: Icon(Icons.public),
      border: OutlineInputBorder(),
    ),
    
    // State Configuration
    stateLabel: 'Region',
    stateHint: 'Choose state/province',
    stateDecoration: InputDecoration(
      prefixIcon: Icon(Icons.map),
    ),
    
    // City Configuration
    cityLabel: 'City',
    cityHint: 'Select city',
    cityIsOptional: true,
    
    // Global Styling
    dropdownColor: Colors.grey[50],
    style: TextStyle(
      fontSize: 16,
      color: Colors.black87,
    ),
  ),
)
```

---

## ✅ Validation

```dart
final _formKey = GlobalKey<FormState>();

Form(
  key: _formKey,
  child: SelectState(
    countryValidator: (value) => value == null ? 'Required' : null,
  ),
)

if (_formKey.currentState!.validate()) {
  // Proceed with valid data
}
```

---

## 🎯 Focus Effects
- Animated shadow on focus
- Background color change
- Customizable focus borders

---

## 📊 Data Handling

### Accessing Selected Values

```dart
String? _country, _state, _city;

SelectState(
  onCountryChanged: (value) => _country = value,
  onStateChanged: (value) => _state = value,
  onCityChanged: (value) => _city = value,
)
```

---

🚀 **Enjoy building with `country_state_city_picker2`!**
