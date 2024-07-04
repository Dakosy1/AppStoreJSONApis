import Foundation

class Service {
    static let shared = Service()
    
    func fetchApps(completion: @escaping ([Result], Error?) -> ()) {
        print("Fetching itunes apps from Service layer")
        
        let urlString = "https://itunes.apple.com/search?term=instagram&entity=software"
        guard let url = URL(string: urlString) else { return }
        
                //fetch data from internet
        URLSession.shared.dataTask(with: url) { data, resp, err in
            if let err = err {
                print("Failed to fetch apps", err)
                completion([], nil)
                return
            }
            
            guard let data = data else { return }
            
            do{
                let searchResult = try JSONDecoder().decode(SearchResult.self, from: data)
                print(searchResult)
                
                completion(searchResult.results, nil)
                
            } catch let jsonErr{
                print("Failed to decode JSON:", jsonErr)
                completion([], jsonErr)
            }
            
        }.resume() // fires off the request
    }
}
