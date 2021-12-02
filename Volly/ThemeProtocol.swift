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
   
}

class LightTheme: ThemeProtocol{
    var fontColor: UIColor = UIColor(ciColor: .black)
    var background: UIColor = UIColor(ciColor: .white)
}

class DarkTheme: ThemeProtocol{
    var fontColor: UIColor = UIColor(ciColor: .white)
    var background: UIColor = UIColor(ciColor: .black)
}
class Theme{
    static var theme: ThemeProtocol = LightTheme()
}
