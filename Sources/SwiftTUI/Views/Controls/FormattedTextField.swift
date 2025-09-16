import Foundation

/// Input formatters for specialized text input
public protocol InputFormatter {
    func format(_ input: String) -> String
    func isValid(_ input: String) -> Bool
}

/// Number formatter for currency input
public struct CurrencyFormatter: InputFormatter {
    public let currencyCode: String
    public let locale: Locale
    
    public init(currencyCode: String = "USD", locale: Locale = .current) {
        self.currencyCode = currencyCode
        self.locale = locale
    }
    
    public func format(_ input: String) -> String {
        // Remove all non-digit characters except decimal point
        let cleanInput = input.filter { $0.isNumber || $0 == "." }
        
        // Convert to number and format as currency
        if let value = Double(cleanInput) {
            let formatter = NumberFormatter()
            formatter.numberStyle = .currency
            formatter.currencyCode = currencyCode
            formatter.locale = locale
            return formatter.string(from: NSNumber(value: value)) ?? cleanInput
        }
        
        return cleanInput
    }
    
    public func isValid(_ input: String) -> Bool {
        let cleanInput = input.filter { $0.isNumber || $0 == "." }
        return Double(cleanInput) != nil || cleanInput.isEmpty
    }
}

/// Phone number formatter
public struct PhoneFormatter: InputFormatter {
    public let format: String // e.g., "(###) ###-####"
    
    public init(format: String = "(###) ###-####") {
        self.format = format
    }
    
    public func format(_ input: String) -> String {
        let digits = input.filter { $0.isNumber }
        var result = ""
        var digitIndex = 0
        
        for char in format {
            if char == "#" && digitIndex < digits.count {
                let digitChar = digits[digits.index(digits.startIndex, offsetBy: digitIndex)]
                result.append(digitChar)
                digitIndex += 1
            } else if char != "#" {
                result.append(char)
            }
        }
        
        return result
    }
    
    public func isValid(_ input: String) -> Bool {
        let digits = input.filter { $0.isNumber }
        return digits.count <= format.filter { $0 == "#" }.count
    }
}

/// Email formatter
public struct EmailFormatter: InputFormatter {
    public init() {}
    
    public func format(_ input: String) -> String {
        // Basic email formatting - convert to lowercase
        return input.lowercased()
    }
    
    public func isValid(_ input: String) -> Bool {
        if input.isEmpty { return true }
        
        // Simple email validation without NSPredicate
        let components = input.split(separator: "@")
        guard components.count == 2 else { return false }
        
        let localPart = components[0]
        let domainPart = components[1]
        
        // Basic validation
        guard !localPart.isEmpty && !domainPart.isEmpty else { return false }
        guard domainPart.contains(".") else { return false }
        
        let domainComponents = domainPart.split(separator: ".")
        guard domainComponents.count >= 2 else { return false }
        guard domainComponents.last!.count >= 2 else { return false }
        
        return true
    }
}

/// Date formatter
public struct DateFormatter: InputFormatter {
    public let dateFormat: String
    
    public init(format: String = "MM/dd/yyyy") {
        self.dateFormat = format
    }
    
    public func format(_ input: String) -> String {
        let digits = input.filter { $0.isNumber }
        var result = ""
        var digitIndex = 0
        
        for char in dateFormat {
            if (char == "M" || char == "d" || char == "y") && digitIndex < digits.count {
                let digitChar = digits[digits.index(digits.startIndex, offsetBy: digitIndex)]
                result.append(digitChar)
                digitIndex += 1
            } else if char == "/" && !result.isEmpty && result.last != "/" {
                result.append(char)
            }
        }
        
        return result
    }
    
    public func isValid(_ input: String) -> Bool {
        if input.isEmpty { return true }
        
        let components = input.split(separator: "/")
        if components.count > 3 { return false }
        
        // Basic validation for MM/dd/yyyy format
        if components.count >= 1, let month = Int(components[0]) {
            if month < 1 || month > 12 { return false }
        }
        if components.count >= 2, let day = Int(components[1]) {
            if day < 1 || day > 31 { return false }
        }
        if components.count == 3, let year = Int(components[2]) {
            if year < 1900 || year > 2100 { return false }
        }
        
        return true
    }
}

/// Enhanced TextField with formatting support
extension TextField {
    /// Creates a formatted text field for currency input
    public static func currency<V: BinaryFloatingPoint & LosslessStringConvertible>(
        _ title: String,
        value: Binding<V>,
        currencyCode: String = "USD"
    ) -> FormattedTextField<V> {
        FormattedTextField(
            title: title,
            value: value,
            formatter: CurrencyFormatter(currencyCode: currencyCode)
        )
    }
    
    /// Creates a formatted text field for phone numbers
    public static func phone(
        _ title: String,
        text: Binding<String>,
        format: String = "(###) ###-####"
    ) -> FormattedTextField<String> {
        FormattedTextField(
            title: title,
            value: text,
            formatter: PhoneFormatter(format: format)
        )
    }
    
    /// Creates a formatted text field for email addresses
    public static func email(
        _ title: String,
        text: Binding<String>
    ) -> FormattedTextField<String> {
        FormattedTextField(
            title: title,
            value: text,
            formatter: EmailFormatter()
        )
    }
    
    /// Creates a formatted text field for dates
    public static func date(
        _ title: String,
        text: Binding<String>,
        format: String = "MM/dd/yyyy"
    ) -> FormattedTextField<String> {
        FormattedTextField(
            title: title,
            value: text,
            formatter: DateFormatter(format: format)
        )
    }
}

/// A text field with input formatting and validation
public struct FormattedTextField<Value>: View {
    private let title: String
    private let value: Binding<Value>
    private let formatter: InputFormatter
    
    @State private var displayText: String = ""
    @State private var isValid: Bool = true
    
    public init(
        title: String,
        value: Binding<Value>,
        formatter: InputFormatter
    ) {
        self.title = title
        self.value = value
        self.formatter = formatter
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 1) {
            TextField(title, text: $displayText)
                .foregroundColor(isValid ? Color.white : Color.red)
                .border(isValid ? Color.gray : Color.red)
                .onChange(of: displayText) { _, newValue in
                    updateValue(newValue)
                }
                // .onAppear {
                //     initializeDisplay()
                // }
            
            if !isValid {
                Text("Invalid format")
                    .foregroundColor(Color.red)
            }
        }
    }
    
    private func updateValue(_ input: String) {
        let formattedInput = formatter.format(input)
        isValid = formatter.isValid(formattedInput)
        
        // Update the binding if valid
        if isValid {
            if let stringValue = formattedInput as? Value {
                value.wrappedValue = stringValue
            } else if let numericValue = Double(formattedInput.filter { $0.isNumber || $0 == "." }) as? Value {
                value.wrappedValue = numericValue
            }
        }
        
        // Update display text to formatted version
        if displayText != formattedInput {
            displayText = formattedInput
        }
    }
    
    private func initializeDisplay() {
        if let stringValue = value.wrappedValue as? String {
            displayText = stringValue
        } else {
            displayText = String(describing: value.wrappedValue)
        }
    }
}

/// Extension to add onChange modifier support
extension View {
    /// Adds an action to perform when the specified value changes
    public func onChange<V: Equatable>(
        of value: V,
        perform action: @escaping (V, V) -> Void
    ) -> some View {
        // Simplified implementation - in a full version this would track value changes
        self
    }
}