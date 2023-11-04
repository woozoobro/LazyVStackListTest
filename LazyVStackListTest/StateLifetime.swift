//
//  StateLifetime.swift
//  LazyVStackListTest
//
//  Created by 우주형 on 2023/10/31.
//

import SwiftUI

fileprivate
struct Item: View {
  var id: Int
  @State private var counter = 0
  var body: some View {
    VStack {
      Text("Item \(id)")
      Button("Counter: \(counter)") {
        counter += 1
      }
    }
  }
}

fileprivate
struct ItemWrapper: View {
  var id: Int
  
  var body: some View {
    ZStack {
      Item(id: id)
    }
  }
}

fileprivate
final class MyObject: ObservableObject {
  init() { print("Allocating") }
}

fileprivate
struct StateObjectItemTest: View {
  @StateObject private var object = MyObject()
  let body = Text("Hello")
}

fileprivate
struct StateItemTest: View {
  @State var item: Int = {
    print("Initing")
    return 0
  }()
  let body = Text("Hello")
}

struct StateLifetime: View {
  var body: some View {
    NavigationStack {
      VStack {
        NavigationLink("State Objects") {
          List(0..<1000) { id in
            //                      let _ = Self._printChanges()
            StateObjectItemTest()
          }
        }
        NavigationLink("State Values") {
          List(0..<1000) { id in
            StateItemTest()
          }
        }
        NavigationLink("Indirect State") {
          List(0..<1000) { id in
            ItemWrapper(id: id)
          }
        }
        NavigationLink("Direct State") {
          List(0..<1000) { id in
            Item(id: id)
          }
        }
      }
    }
  }
}

struct StateLifetime_Previews: PreviewProvider {
  static var previews: some View {
    StateLifetime()
  }
}
