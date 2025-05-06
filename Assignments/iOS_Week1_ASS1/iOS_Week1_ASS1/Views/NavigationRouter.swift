import SwiftUI
import Observation

@Observable
class NavigationRouter : ObservableObject{
    var path = NavigationPath()
    
    func push(_ route: Route){
        path.append(route);
    }
    
    func pop(){
        if !path.isEmpty {
            path.removeLast()
        }
    }
    
    func reset(){
        path = NavigationPath()
    }
}

