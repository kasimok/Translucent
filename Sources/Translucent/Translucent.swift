import UIKit
import DeviceKit

public class Wallpaper: NSObject {
    
    private let wallpaperImage: UIImage
    
    private var phoneMappings: [String: Any]
    
    public init(_ img: UIImage) {
        self.wallpaperImage = img
        do{
            //  load mappings into code. mapping file is based on https://gist.github.com/CyberBatMan2077/8ac39f169066a4a20320ee4572e1eafa
            let mappings = Bundle.module.url(forResource: "mappings", withExtension: "json")!
            let jsonData = try Data(contentsOf: mappings)
            let jsonDictionary = try JSONDecoder().decode([String: Phone].self, from: jsonData)
            phoneMappings = jsonDictionary

        } catch {
            fatalError("unexpected resource..")
        }
    }
    
    required override init() {
        fatalError()
    }
    
    public func widgetBackground(for position: WidgetCropPosition) -> UIImage? {
        let height = Int(wallpaperImage.size.height)
        
        var heightKey = String(height)
        //  Extra setup needed for 2436-sized phones, i.e. for 13 mini, 12 mini / 11 Pro, XS, X
        if Device.current == .iPhone13Mini || Device.current == .iPhone12Mini{
            heightKey += "mini"
        } else if Device.current == .iPhoneX || Device.current == .iPhoneXS || Device.current == .iPhone11Pro{
            heightKey += "x"
        }
        
        guard let phone = phoneMappings["\(heightKey)"] as? Phone else {
            print("It looks like you selected an image that isn't an iPhone screenshot, or your iPhone is not supported. Try again with a different image.")
            return nil
        }
        
        var crop_x:CGFloat = 0
        var crop_y:CGFloat = 0
        var crop_w:CGFloat = 0
        var crop_h:CGFloat = 0
                
        switch position{
        case .smallTopLeft:
            crop_w = phone.small
            crop_h = phone.small
            crop_x = phone.left
            crop_y = phone.top
            
        case .smallTopRight:
            crop_w = phone.small
            crop_h = phone.small
            crop_x = phone.right
            crop_y = phone.top
            
        case .smallCenterLeft:
            crop_w = phone.small
            crop_h = phone.small
            crop_x = phone.left
            crop_y = phone.middle
            
        case .smallCenterRight:
            crop_w = phone.small
            crop_h = phone.small
            crop_x = phone.right
            crop_y = phone.middle
            
        case .smallBottomLeft:
            crop_w = phone.small
            crop_h = phone.small
            crop_x = phone.left
            crop_y = phone.bottom
            
        case .smallBottomRight:
            crop_w = phone.small
            crop_h = phone.small
            crop_x = phone.right
            crop_y = phone.bottom
            
        case .mediumTop:
            crop_w = phone.medium
            crop_h = phone.small
            crop_x = phone.left
            crop_y = phone.top
            
        case .mediumCenter:
            crop_w = phone.medium
            crop_h = phone.small
            crop_x = phone.left
            crop_y = phone.medium
            
        case .mediumBottom:
            crop_w = phone.medium
            crop_h = phone.small
            crop_x = phone.left
            crop_y = phone.bottom
            
        case .largeTop:
            crop_w = phone.medium
            crop_h = phone.large
            crop_x = phone.left
            crop_y = phone.top
            
        case .largeBottom:
            crop_w = phone.medium
            crop_h = phone.large
            crop_x = phone.left
            crop_y = phone.middle
        }
        
        let crop = wallpaperImage.cgImage?.cropping(to: CGRect(x: crop_x, y: crop_y, width: crop_w, height: crop_h))
        let croppedImage = UIImage(cgImage: crop!)
        
        return croppedImage
            
    }
}

struct Phone: Codable{
    var small:  CGFloat
    var medium: CGFloat
    var large:  CGFloat
    var left:   CGFloat
    var right:  CGFloat
    var top:    CGFloat
    var middle: CGFloat
    var bottom: CGFloat
}
