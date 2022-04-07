//
//  WebBrowser.swift
//  Github
//
//  Created by Renato F. dos Santos Jr on 06/04/22.
//

import Foundation
import SafariServices

protocol WebBrowser: SFSafariViewControllerDelegate {
    func goTo(url: String)
}
