
import UIKit
class ViewController: UIViewController {
    
    var entry: Entry?
    
    @IBOutlet weak var squareImage: UIImageView!
    @IBOutlet weak var personNameLabel: UILabel!
    @IBOutlet weak var birthDayLabel: UILabel!
    @IBOutlet weak var finalWorthLabel: UILabel!
    
    var queue = DispatchQueue(label: "downloadImage")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        personNameLabel.text = entry?.personName
        if let birthDate = entry?.birthDate {
            //birthDayLabel.text = String(birthDate)
        }
        if let finalWorth = entry?.finalWorth {
            finalWorthLabel.text = String(finalWorth)
        }
        self.setImageAsync()
    }

    func setImageAsync() {
        
        queue.async {
            if let urlString = self.entry?.squareImage {
                if let url = URL(string: urlString) {
                    let image = self.download(image_url: url)
                    DispatchQueue.main.async {
                        self.squareImage.image = image
                        print("done")
                    }
                }
            }
            
            
        }
        
    }
    
    func download(image_url: URL) -> UIImage {
        
        if let data = try? Data(contentsOf: image_url) {
            if let image = UIImage(data: data) {
                return image
            }
        }
        return UIImage()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
