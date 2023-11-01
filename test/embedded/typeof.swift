// RUN: %target-swift-emit-ir -verify %s -enable-experimental-feature Embedded -wmo

// REQUIRES: optimized_stdlib
// REQUIRES: VENDOR=apple
// REQUIRES: OS=macosx

public func unsafeWriteArray<T, R>(_ elementType: R.Type, array: inout T, index n: Int, value: R) {
  precondition(_isPOD(elementType))
  precondition(_isPOD(type(of: array))) // expected-error {{cannot use metatype of type '(Int, Int, Int, Int)' in embedded Swift}}
  // expected-note@-1 {{called from here}}

  return withUnsafeMutableBytes(of: &array) { ptr in
    let buffer = ptr.bindMemory(to: R.self)
    precondition(n >= 0)
    precondition(n < buffer.count)
    buffer[n] = value
  }
}

public func test() {
  var args: (Int, Int, Int, Int) = (0, 0, 0, 0)
  let n = 2
  let value = 42
  unsafeWriteArray(type(of: args.0), array: &args, index: n, value: value)
}
