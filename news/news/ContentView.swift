//
//  ContentView.swift
//  news
//
//  Created by Tyhoo Wu on 2023/11/26.
//
//

import SwiftUI

struct ContentView: View {
    @State private var articles: [Article] = []

    var body: some View {
        List(articles, id: \.id) { article in
            HStack {
                // 图片
                if let imageURL = URL(string: article.thumb),
                   let imageData = try? Data(contentsOf: imageURL),
                   let uiImage = UIImage(data: imageData) {
                    Image(uiImage: uiImage)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 112, height: 84)
                            .clipped()
                }

                // 文本
                VStack(alignment: .leading) {
                    Text(article.title)
                            .font(.headline)
                }
            }
        }
                .onAppear {
                    fetchData()
                }
    }

    func fetchData() {
        if let url = URL(string: "https://api.dongqiudi.com/v3/archive/app/tabs/getlists?id=1&platform=iphone&version=808&isTeenager=0&isDarkMode=0") {
            URLSession.shared.dataTask(with: url) { data, _, error in
                        if let error = error {
                            print("Error: \(error)")
                        } else if let data = data {
                            do {
                                let decoder = JSONDecoder()
                                decoder.keyDecodingStrategy = .convertFromSnakeCase
                                let result = try decoder.decode(APIResponse.self, from: data)
                                DispatchQueue.main.async {
                                    self.articles = result.articles
                                }
                            } catch {
                                print("Error decoding JSON: \(error)")

                                if let jsonString = String(data: data, encoding: .utf8) {
                                    print("JSON String: \(jsonString)")
                                }
                            }
                        }
                    }
                    .resume()
        }
    }
}

// 定义 'APIResponse' 结构体
struct APIResponse: Codable {
    var id: Int
    var label: String
    var articles: [Article]
}

// Article 结构体
struct Article: Identifiable, Codable {
    var id: Int
    var title: String
    var thumb: String
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
