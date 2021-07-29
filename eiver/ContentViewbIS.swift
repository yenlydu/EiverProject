//
//  ContentViewbIS.swift
//  eiver
//
//  Created by Duong Yen-Ly on 22/07/2021.
//
import AVKit
import SwiftUI

protocol DataServiceYtb
{
    func loadData(id: String, _ completionHandler: @escaping(_ genres: [FilmYoutubeVideo]?) -> ())
}

struct FilmYoutubeVideo: Codable, Identifiable, Hashable
{
    let id : String
    var key: String
    var name: String
    var type: String
    var published_at: String
}

class GetYtb : ObservableObject, DataServiceYtb
{
    
    func loadData(id: String, _ completionHandler: @escaping(_ genres: [FilmYoutubeVideo]?) -> ()){
        var books: [FilmYoutubeVideo] = []
            print("entered load ytb", "http://api.themoviedb.org/3/movie/\(id)/videos?api_key=b5c692622885db92d8a2eaa07c8e096c")
                guard let url = URL(string: "http://api.themoviedb.org/3/movie/\(id)/videos?api_key=b5c692622885db92d8a2eaa07c8e096c") else {
    // http://api.themoviedb.org/3/movie/181808/videos?api_key=b5c692622885db92d8a2eaa07c8e096c
                print("Invalid url...")
                return
            }
            var movieData = [String: Any]()
            
        URLSession.shared.dataTask(with: url) { data, response, error in

                guard let data = data, error == nil else {
                    return
                }
                do {
                    movieData = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String: Any]
                    let jsonData = try JSONSerialization.data(withJSONObject: movieData, options: [])
//                    books = try! JSONDecoder().decode([FilmYoutubeVideo].self, from: jsonData)
//                    print (books)

                    print ("entering moviedata ", movieData["results"])
                    return completionHandler(nil)
                } catch let error as NSError {
                    print(error)
                }
            }.resume()
        
    }

}

extension UIImage {
    var averageColor: UIColor? {
        guard let inputImage = CIImage(image: self) else { return nil }
        let extentVector = CIVector(x: inputImage.extent.origin.x, y: inputImage.extent.origin.y, z: inputImage.extent.size.width, w: inputImage.extent.size.height)

        guard let filter = CIFilter(name: "CIAreaAverage", parameters: [kCIInputImageKey: inputImage, kCIInputExtentKey: extentVector]) else { return nil }
        guard let outputImage = filter.outputImage else { return nil }

        var bitmap = [UInt8](repeating: 0, count: 4)
        let context = CIContext(options: [.workingColorSpace: kCFNull])
        context.render(outputImage, toBitmap: &bitmap, rowBytes: 4, bounds: CGRect(x: 0, y: 0, width: 1, height: 1), format: .RGBA8, colorSpace: nil)

        return UIColor(red: CGFloat(bitmap[0]) / 255, green: CGFloat(bitmap[1]) / 255, blue: CGFloat(bitmap[2]) / 255, alpha: CGFloat(bitmap[3]) / 255)
    }
}
struct ContentViewbIS: View {
    var film: Film?
    var api = GetYtb()
    
    var image : UIImage = UIImage()
    init(film: Film?) {
        self.film = film
        let url = URL(string: "https://image.tmdb.org/t/p/original/\(film!.poster_path)")!
        let data = try? Data(contentsOf: url)

        if let imageData = data {
            image = UIImage(data: imageData)!
        }
        api.loadData(id: String(film!.id), {film in
            if let film = film {
            }
        })
    }

    var body: some View {
//        NavigationView{
        ZStack {
            Color(image.averageColor!).opacity(0.3).ignoresSafeArea()
          VStack {
            Image(uiImage: image)
                .resizable()        .cornerRadius(10).padding()
                .frame(width: 200.0, height: 300.0)

            HStack{
                Text("Release date : ").font(.system(size: 20))
                Text (film!.release_date ?? "nIL").italic()
            }.padding(.bottom)
            Text(film?.overview ?? "No description").padding()
            let player = AVPlayer(url: URL(string: "https://www.youtube.com/watch?v=SUXWAEX2jlg")!)
            VideoPlayer(player: player).onAppear(){
                player.play()
            }

          } // VStack
        } // ZStack
    }
}

struct ContentViewbIS_Previews: PreviewProvider {
    static var previews: some View {
        
        ContentViewbIS(film: nil)
    }
}
