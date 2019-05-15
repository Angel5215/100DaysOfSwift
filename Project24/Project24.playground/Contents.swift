import UIKit
import Foundation

/*:
 # Strings are not arrays.
 */

let name = "Taylor"

//  String look like arrays but they are not arrays.
for letter in name {
    print("Give me a \(letter)")
}

//print(name[3]) // Error

//  T a y l o r
//  s-1-2-3
let letter = name[name.index(name.startIndex, offsetBy: 3)]

extension String {
    subscript(i: Int) -> String {
        return String(self[index(startIndex, offsetBy: i)])
    }
}

//  Possible with the extension.
print(name[3])

// It's always better to use someString.isEmpty rather than someString.count == 0 when looking for an empty String.
name.isEmpty

/*:
 # Working with Strings in Swift.
 */

//  Useful String methods
let password = "12345"
password.hasPrefix("123")
password.hasSuffix("345")


extension String {
    ///  Removes a prefix if it exists.
    func deletingPrefix(_ prefix: String) -> String {
        guard self.hasPrefix(prefix) else { return self }
        return String(self.dropFirst(prefix.count))
    }
    
    /// Deletes a suffix if it exists.
    func deletingSuffix(_ suffix: String) -> String {
        guard self.hasSuffix(suffix) else { return self }
        return String(self.dropLast(suffix.count))
    }
}

password.deletingPrefix("123")
password.deletingSuffix("45")

let weather = "it's going to rain"
print(weather.capitalized)

extension String {
    var capitalizedFirst: String {
        guard let firstLetter = self.first else { return "" }
        return firstLetter.uppercased() + self.dropFirst()
    }
}

weather.capitalizedFirst

let ß: Character = "ß"
ß.uppercased()

let input = "Swift is like Objective-C without the C"
input.contains("Swift")

let languages = ["Python", "Ruby", "Swift"]
languages.contains("Swift")


extension String {
    func containsAny(of array: [String]) -> Bool {
        for item in array {
            if self.contains(item) {
                return true
            }
        }
        
        return false
    }
}

input.containsAny(of: languages)

languages.contains(where: input.contains)

/*:
 ## Formatting strings with `NSAttributedString`
 */

let string = "This is a test String"
let attributes: [NSAttributedString.Key: Any] = [
    .foregroundColor: UIColor.white,
    .backgroundColor: UIColor.red,
    .font: UIFont.boldSystemFont(ofSize: 36)
]

NSAttributedString(string: string, attributes: attributes)

let attributedString = NSMutableAttributedString(string: string)
attributedString.addAttribute(.font, value: UIFont.systemFont(ofSize: 8), range: NSRange(location: 0, length: 4))
attributedString.addAttribute(.font, value: UIFont.systemFont(ofSize: 16), range: NSRange(location: 5, length: 2))
attributedString.addAttribute(.font, value: UIFont.systemFont(ofSize: 24), range: NSRange(location: 8, length: 1))
attributedString.addAttribute(.font, value: UIFont.systemFont(ofSize: 32), range: NSRange(location: 10, length: 4))
attributedString.addAttribute(.font, value: UIFont.systemFont(ofSize: 40), range: NSRange(location: 15, length: 6))

//  Challenge 1. Create a String extension that adds a withPrefix() method. If the string already contains the prefix it should return itself; if it doesn’t contain the prefix, it should return itself with the prefix added. For example: "pet".withPrefix("car") should return “carpet”.
extension String {
    func withPrefix(_ prefix: String) -> String {
        guard !self.hasPrefix(prefix) else { return self }
        return prefix + self
    }
}

"pet".withPrefix("car")

//  Challenge 2. Create a String extension that adds an isNumeric property that returns true if the string holds any sort of number. Tip: creating a Double from a String is a failable initializer.
extension String {
    func isNumeric() -> Bool {
        if let _ = Double(self) {
            return true
        }
        
        return false
    }
}

"380.399".isNumeric()
"-20".isNumeric()
"d3.1".isNumeric()


//  Challenge 3: Create a String extension that adds a lines property that returns an array of all the lines in a string. So, “this\nis\na\ntest” should return an array with four elements.
extension String {
    var lines: [String] {
        return self.components(separatedBy: .newlines)
    }
}

"this\nis\na\ntest".lines
