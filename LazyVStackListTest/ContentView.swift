//
//  ContentView.swift
//  LazyVStackListTest
//
//  Created by 우주형 on 2023/10/27.
//

import SwiftUI
import Kingfisher

struct Post: Identifiable, Hashable {
   let id = UUID().uuidString
   let title: String
   var url: URL?
}

enum ViewOptions: Hashable {
   case destination(post: Post)
   @ViewBuilder func view() -> some View {
      switch self {
         case .destination(let post): Destination(post: post)
      }
   }
}

class NavigationPathFinder: ObservableObject {
   @Published var path: NavigationPath = .init()
   
   func addPath(options: ViewOptions) {
      path.append(options)
   }
}

class ContentViewModel: ObservableObject {
   @Published var list: [Post] = []
   
   @MainActor
   func getPosts() async {
      //    try? await Task.sleep(for: .seconds(1))
      for i in 0...1000 {
         list.append(Post(title: "\(i)번째 포스트", url: URL(string: "https://picsum.photos/id/\(i)/200")))
      }
      print("🧵현재 포스트 갯수",list.count)
   }
}


struct ContentView: View {
   @StateObject private var vm = ContentViewModel()
   @StateObject private var navPathFiner = NavigationPathFinder()
   
   var body: some View {
      let _ = Self._printChanges()
      NavigationStack(path: $navPathFiner.path) {
         //      TestList(vm: vm)
         TestScrollWithLazyVStack(vm: vm)
            .navigationDestination(for: ViewOptions.self) { destination in
               destination.view()
            }
      }
      .safeAreaInset(edge: .bottom, content: {
         Button {
            Task {
               await vm.getPosts()
            }
         } label: {
            Text("Fetch Posts")
         }
         .buttonStyle(.borderedProminent)
         
      })
      .environmentObject(navPathFiner)
      
   }
}

//MARK: - 스크롤 뷰와 LazyVStack
struct TestScrollWithLazyVStack: View {
   @ObservedObject var vm: ContentViewModel
   @EnvironmentObject private var navPathFinder: NavigationPathFinder
   
   var body: some View {
      ScrollViewReader { proxy in
         ScrollView {
            Circle()
               .frame(width: 1, height: 1)
               .opacity(0)
               .id("top")
            LazyVStack {
               ForEach($vm.list) { $post in
                  PostRow(post: $post)
               }
               
               Circle()
                  .frame(width: 1, height: 1)
                  .id("bottom")
            }
         }
         .safeAreaInset(edge: .bottom, alignment: .leading) {
            Button("바텀 이동") {
               withAnimation(.interactiveSpring()) {
                  proxy.scrollTo("bottom")
               }
            }
            .buttonStyle(.borderedProminent)
            .tint(.green)
         }
         .safeAreaInset(edge: .bottom, alignment: .trailing) {
            Button("탑 이동") {
               withAnimation(.interactiveSpring()) {
                  proxy.scrollTo("top")
               }
            }
            .buttonStyle(.borderedProminent)
            .tint(.pink)
         }
      }
   }
}

//MARK: - 리스트 뷰로
//struct TestList: View {
//  @ObservedObject var vm: ContentViewModel
//  @EnvironmentObject private var navPathFinder: NavigationPathFinder
//  var body: some View {
//    List {
//      ForEach(vm.list) { post in
//        PostRow(post: post)
//      }
//    }
//  }
//}

struct PostRow: View {
   @Binding var post: Post
   //  let post: Post
   @EnvironmentObject var navPathFinder: NavigationPathFinder
   var body: some View {
      Button {
         navPathFinder.addPath(options: .destination(post: post))
      } label: {
         HStack {
            RandomImage(url: post.url)
            AsyncImage(url: post.url)
               .frame(width: 100, height: 100)
            Text(post.title)
               .font(.largeTitle)
         }
      }
   }
}

struct Destination: View {
   let post: Post
   var body: some View {
      VStack {
         Text(post.title)
         
         RandomImage(url: post.url)
         AsyncImage(url: post.url)
      }
      .task {
         do {
            try await Task.sleep(for:.seconds(1))
            print("포스트 이름",post.title)
         } catch {
            print(error)
         }
      }
   }
}

struct RandomImage: View {
   let url: URL?
   var body: some View {
      KFImage(url)
         .placeholder { progress in
            ProgressView()
         }
         .resizable()
         .loadDiskFileSynchronously()
         .frame(width: 200, height: 200)
         .scaledToFill()
         .clipShape(Circle())
   }
}

struct ContentView_Previews: PreviewProvider {
   static var previews: some View {
      ContentView()
   }
}


