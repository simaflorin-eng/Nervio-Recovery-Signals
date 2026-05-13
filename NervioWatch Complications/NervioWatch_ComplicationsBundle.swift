import SwiftUI
import WidgetKit

@main
struct NervioWatch_ComplicationsBundle: WidgetBundle {
    var body: some Widget {
        NervioRecoveryComplication()
        NervioStressComplication()
        NervioStepsComplication()
    }
}
