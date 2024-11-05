import SwiftUI

struct ContentView: View {
    @State var loggedIn: Bool = false

    var body: some View {
        if !loggedIn {
            TabView {
                LoginView(loggedIn: $loggedIn)
            }
        } else {
            TabView {
                DashBoard()
                    .tabItem {
                        Image(systemName: "house.fill")
                        Text("Active")
                    }
                
                MyAuctionsView()
                    .tabItem {
                        Image(systemName: "hammer")
                        Text("My Auctions")
                    }
                
                MySalesView()
                    .tabItem {
                        Image(systemName: "cart.fill")
                        Text("My Sales")
                    }
                
                PersonalAreaView()
                    .tabItem {
                        Image(systemName: "person.crop.circle")
                        Text("Profile")
                    }
            }
        }
    }
}

struct ContentView_Preview: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
