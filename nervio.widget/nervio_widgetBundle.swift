//
//  nervio_widgetBundle.swift
//  nervio.widget
//
//  Created by Florin Sima on 12/05/2026.
//

import WidgetKit
import SwiftUI

@main
struct nervio_widgetBundle: WidgetBundle {
    var body: some Widget {
        NervioRecoveryWidget()
        NervioStressWidget()
    }
}
