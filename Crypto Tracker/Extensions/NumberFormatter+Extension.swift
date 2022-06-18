import Foundation

extension NumberFormatter {

    ///    Formatter which creates float numbers money format,
    public static private(set) var moneyFormatter: NumberFormatter = moneyFormatterBuilder
    
    private static var moneyFormatterBuilder: NumberFormatter {
        let nf = NumberFormatter()
        nf.locale = Locale.current
        nf.allowsFloats = true
        nf.numberStyle = .currency
        nf.formatterBehavior = .default
        return nf
    }
}
