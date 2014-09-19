// RUN: %target-run-simple-swift

#if os(OSX)
import AppKit
#endif
#if os(iOS)
import UIKit
#endif

let foo: [CGColor] = [CGColorGetConstantColor(kCGColorBlack)]

let bar: NSArray = foo

// CHECK: CGColor
println(bar[0])
