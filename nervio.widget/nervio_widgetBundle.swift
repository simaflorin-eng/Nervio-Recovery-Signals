//
//  nervio_widgetBundle.swift
//  nervio.widget
//
//  Created by Florin Sima on 15/05/2026.
//

import WidgetKit
import SwiftUI

@main
struct nervio_widgetBundle: WidgetBundle {
    @WidgetBundleBuilder
    var body: some Widget {
        NervioRecoveryWidget()
        NervioStressWidget()
        if #available(iOS 18.0, *) {
            nervio_widgetControl()
            nervio_widgetLiveActivity()
        }
    }
}
