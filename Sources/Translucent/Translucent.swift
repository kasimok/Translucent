import UIKit
import DeviceKit

public class Wallpaper: NSObject {
    
    private let wallpaperImage: UIImage
    
    private var phoneMappings: [String: Any]

    private var isIOS18OrHigher: Bool

    
    public init(_ img: UIImage) {
        self.wallpaperImage = img
        do{

            let currentVersion = UIDevice.current.systemVersion
            let majorVersion = Int(currentVersion.split(separator: ".").first!) ?? 0
             self.isIOS18OrHigher = majorVersion >= 18
            
            let fileName: String
            if majorVersion >= 18 {
                fileName = "mappings-ios-18"
                print("Loading mappings-ios-18.json")
            } else {
                fileName = "mappings"
                print("Loading mappings.json")
            }

            //  load mappings into code. mapping file is based on https://gist.github.com/CyberBatMan2077/8ac39f169066a4a20320ee4572e1eafa
            guard let mappings = Bundle.module.url(forResource: fileName, withExtension: "json") else {
                fatalError("Mapping file not found.")
            }
            
            
            let jsonData = try Data(contentsOf: mappings)
            let jsonDictionary = try JSONDecoder().decode([String: PhoneModel].self, from: jsonData)
            phoneMappings = jsonDictionary

        } catch {
            fatalError("unexpected resource..")
        }
    }

    public func isIphoneScreenshot() -> Bool {
        let height = Int(wallpaperImage.size.height)

        var heightKey = String(height)
        //  Extra setup needed for 2436-sized phones, i.e. for 13 mini, 12 mini / 11 Pro, XS, X
    //    let device = Device.current
    //    let realModel: Device = device.isSimulator ? (device.simulatorModel ?? device) : device


    //    if realModel.isOneOf([.iPhone13Mini, .iPhone12Mini]) {
    //       heightKey += "mini"
    //    } else if realModel.isOneOf([.iPhoneX, .iPhoneXS, .iPhone11Pro]) {
    //       heightKey += "x"
    //    }

       // Debug logs
//     print("📏 Wallpaper image height: \(height)")
// print("📱 Detected device: \(device)")              // e.g. simulator(iPhone13Mini)
// print("🧭 Using model: \(realModel)")               // e.g. iPhone13Mini
// print("🔑 Computed heightKey: \(heightKey)")
        
        
        guard let _ = phoneMappings["\(heightKey)"] as? PhoneModel else {
            print("It looks like you selected an image that isn't an iPhone screenshot, or your iPhone is not supported. Try again with a different image.")
            return false
        }
        
        return true
    }
    
    required override init() {
        fatalError()
    }
    
    public func widgetBackground(for position: WidgetCropPosition, widgetType: Int = 1) -> UIImage? {
        let height = Int(wallpaperImage.size.height)

       
        var heightKey = String(height)
        //  Extra setup needed for 2436-sized phones, i.e. for 13 mini, 12 mini / 11 Pro, XS, X
        // if Device.current == .iPhone13Mini || Device.current == .iPhone12Mini{
        //     heightKey += "mini"
        // } else if Device.current == .iPhoneX || Device.current == .iPhoneXS || Device.current == .iPhone11Pro{
        //     heightKey += "x"
        // }
        
        guard let phone = phoneMappings["\(heightKey)"] as? PhoneModel else {
            print("It looks like you selected an image that isn't an iPhone screenshot, or your iPhone is not supported. Try again with a different image.")
            return nil
        }
        
        var crop_x:CGFloat = 0
        var crop_y:CGFloat = 0
        var crop_w:CGFloat = 0
        var crop_h:CGFloat = 0

        // Select the appropriate phone properties based on the widgetType
        let selectedPhone: Phone
        
        if isIOS18OrHigher {
            // For iOS 18 or higher, use the text or notext properties
            selectedPhone = widgetType == 1 ? phone.text : (phone.notext ?? phone.text)
            print("iOS 18 or higher")
            print(selectedPhone.small)
        } else {
            selectedPhone = phone.text
            print("Lower than iOS 18")
        }
          
                
        switch position{
        case .smallTopLeft:
            crop_w = selectedPhone.small
            crop_h = selectedPhone.small
            crop_x = selectedPhone.left
            crop_y = selectedPhone.top
            
        case .smallTopRight:
            crop_w = selectedPhone.small
            crop_h = selectedPhone.small
            crop_x = selectedPhone.right
            crop_y = selectedPhone.top
            
        case .smallCenterLeft:
            crop_w = selectedPhone.small
            crop_h = selectedPhone.small
            crop_x = selectedPhone.left
            crop_y = selectedPhone.middle
            
        case .smallCenterRight:
            crop_w = selectedPhone.small
            crop_h = selectedPhone.small
            crop_x = selectedPhone.right
            crop_y = selectedPhone.middle
            
        case .smallBottomLeft:
            crop_w = selectedPhone.small
            crop_h = selectedPhone.small
            crop_x = selectedPhone.left
            crop_y = selectedPhone.bottom
            
        case .smallBottomRight:
            crop_w = selectedPhone.small
            crop_h = selectedPhone.small
            crop_x = selectedPhone.right
            crop_y = selectedPhone.bottom
            
        case .mediumTop:
            crop_w = selectedPhone.medium
            crop_h = selectedPhone.small
            crop_x = selectedPhone.left
            crop_y = selectedPhone.top
            
        case .mediumCenter:
            crop_w = selectedPhone.medium
            crop_h = selectedPhone.small
            crop_x = selectedPhone.left
            crop_y = selectedPhone.middle
            
        case .mediumBottom:
            crop_w = selectedPhone.medium
            crop_h = selectedPhone.small
            crop_x = selectedPhone.left
            crop_y = selectedPhone.bottom
            
        case .largeTop:
            crop_w = selectedPhone.medium
            crop_h = selectedPhone.large
            crop_x = selectedPhone.left
            crop_y = selectedPhone.top
            
        case .largeBottom:
            crop_w = selectedPhone.medium
            crop_h = selectedPhone.large
            crop_x = selectedPhone.left
            crop_y = selectedPhone.middle
        }
        
        let crop = wallpaperImage.cgImage?.cropping(to: CGRect(x: crop_x, y: crop_y, width: crop_w, height: crop_h))
        let croppedImage = UIImage(cgImage: crop!)
        
        return croppedImage
            
    }
}
struct Phone: Codable {
    var small:  CGFloat
    var medium: CGFloat
    var large:  CGFloat
    var left:   CGFloat
    var right:  CGFloat
    var top:    CGFloat
    var middle: CGFloat
    var bottom: CGFloat
}

struct PhoneModel: Codable {
    var text: Phone
    var notext: Phone?
}
