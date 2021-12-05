//
//  ThemeProtocol.swift
//  Volly
//
//  Created by Jason Hoover on 12/2/21.
//

import UIKit
protocol ThemeProtocol{
    var fontColor: UIColor { get }
    var background: UIColor { get }
    var font: String { get }
}

class LonghornTheme: ThemeProtocol{
    var fontColor: UIColor = UIColor(ciColor: .white)
    var background: UIColor = UIColor.orange
    var font: String = "Damascus"
}

class DarkTheme: ThemeProtocol{
    var fontColor: UIColor = UIColor(ciColor: .white)
    var background: UIColor = UIColor(ciColor: .black)
    var font: String = "Damascus"
}

class CowboyTheme: ThemeProtocol{
    var fontColor: UIColor = UIColor.lightGray
    var background: UIColor = UIColor.blue
    var font: String = "Avenir-Light"
}

class OUTheme: ThemeProtocol{
    var fontColor: UIColor = UIColor(ciColor: .white)
    var background: UIColor = UIColor.red
    var font: String = "Futura"
}
class Theme{
    static var theme: ThemeProtocol = LonghornTheme()
}
