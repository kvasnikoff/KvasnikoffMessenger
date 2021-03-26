//
//  Logger.swift
//  KvasnikoffMessenger
//
//  Created by Peter Kvasnikov on 17.02.2021.
//

import UIKit

func printLog(log: String) {
    #if DEBUG
    print(log)
    #endif
}

func parseState(state: UIApplication.State) -> String {
    switch state {
    case .active: return "Active State"
    case .inactive: return "Inactive State"
    case .background: return "Background State"
    @unknown default:
        return ("Unknown State")
    }
}
