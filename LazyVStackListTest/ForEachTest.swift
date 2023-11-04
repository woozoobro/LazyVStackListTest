//
//  ForEachTest.swift
//  LazyVStackListTest
//
//  Created by 우주형 on 2023/10/31.
//

import SwiftUI

//MARK: - Version Direct Model
class ForEachTestViewModl: ObservableObject {
  @Published var lists: [Int] = Array(0...100)
  
  func updateIndex(with element: Int) {
    if let firstIndex = lists.firstIndex(where: {$0 == element}) {
      lists[firstIndex] += 200
    }
  }
}

struct ForEachTest: View {
  @StateObject private var vm = ForEachTestViewModl()
  
  var body: some View {
    let _ = Self._printChanges()
    ScrollView {
      LazyVStack {
        ForEach(vm.lists, id: \.self) { element in
          Text("\(element)")
            .font(.largeTitle)
            .onTapGesture {
              vm.updateIndex(with: element)
            }
        }
      }
    }
  }
}


/*
//MARK: - Version Index
class ForEachTestViewModl: ObservableObject {
  @Published var lists: [Int] = Array(0...100)
  
  func updateIndex(index: Int) {
    lists[index] += 200
  }
}

struct ForEachTest: View {
  @StateObject private var vm = ForEachTestViewModl()
  
  var body: some View {
    let _ = Self._printChanges()
    ScrollView {
      LazyVStack {
        ForEach(vm.lists.indices, id: \.self) { index in
          let _ = Self._printChanges
          Text("\(vm.lists[index])")
            .font(.largeTitle)
            .onTapGesture {
              vm.updateIndex(index: index)
            }
        }
      }
    }
  }
}
*/


struct ForEachTest_Previews: PreviewProvider {
  static var previews: some View {
    ForEachTest()
  }
}
