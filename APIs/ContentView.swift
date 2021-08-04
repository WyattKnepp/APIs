//
//  ContentView.swift
//  APIs
//
//  Created by Wyatt Knepp on 8/4/21.
//

import SwiftUI

struct ContentView: View {
	@State private var entries = [Entry]()
	@State private var showingAlert = false
	
	var body: some View {
		
		NavigationView {
			
			List(entries) { entry in
				Link(destination: URL(string: entry.link)!, label: {
					Text(entry.title)
				})
			}
			.navigationTitle("Good Boys")
			
		}
		.onAppear(perform: {
			queryAPI()
		})
		.alert(isPresented: $showingAlert, content: {
			Alert(title: Text("Error"),
			      message: Text("Data wouldn't load"),
			      dismissButton: .default(Text("K")))
		})
	}
	func queryAPI() {
		let apiKey = "?rapidapi-key=f59e2b55ebmsh66bfe4e6e09fee8p1aa206jsn60690112c227"
		let query = "https://google-search3.p.rapidapi.com/api/v1/search/q=dog&num=100\(apiKey)"
		
		if let url = URL(string: query) {
			if let data = try? Data(contentsOf: url) {
				let json = try! JSON(data: data)
				let contents = json["results"].arrayValue
				for item in contents {
					let title = item["title"].stringValue
					let link = item["link"].stringValue
					let entry = Entry(title: title, link: link)
					
					entries.append(entry)
				}
				return
			}
		}
		showingAlert = true
	}
	
}
struct ContentView_Previews: PreviewProvider {
	static var previews: some View {
		ContentView()
	}
}
struct Entry: Identifiable {
	let id = UUID()
	let title: String
	let link: String
}
