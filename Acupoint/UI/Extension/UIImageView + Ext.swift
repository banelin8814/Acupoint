import UIKit
import ImageIO
extension UIImageView {
    public func loadGif(name: String) {
        DispatchQueue.global().async {
            let image = UIImage.gif(name: name)
            DispatchQueue.main.async {
                self.image = image
            }
        }
    }
}
extension UIImage {
    public class func gif(data: Data) -> UIImage? {
        // Create source from data
        guard let source = CGImageSourceCreateWithData(data as CFData, nil) else {
            print("SwiftGif: Source for the image does not exist")
            return nil
        }
        return UIImage.animatedImageWithSource(source)
    }
    public class func gif(theUrl: String) -> UIImage? {
        // Validate URL
        guard let bundleURL = URL(string: theUrl) else {
            print("SwiftGif: This image named \"\(theUrl)\" does not exist")
            return nil
        }
        // Validate data
        guard let imageData = try? Data(contentsOf: bundleURL) else {
            print("SwiftGif: Cannot turn image named \"\(theUrl)\" into NSData")
            return nil
        }
        return gif(data: imageData)
    }
    public class func gif(name: String) -> UIImage? {
        // Check for existance of gif
        guard let bundleURL = Bundle.main
            .url(forResource: name, withExtension: "gif") else {
            print("SwiftGif: This image named \"\(name)\" does not exist")
            return nil
        }
        // Validate data
        guard let imageData = try? Data(contentsOf: bundleURL) else {
            print("SwiftGif: Cannot turn image named \"\(name)\" into NSData")
            return nil
        }
        return gif(data: imageData)
    }
    internal class func delayForImageAtIndex(_ index: Int, source: CGImageSource!) -> Double {
        var delay = 0.1
        // Get dictionaries
        let cfProperties = CGImageSourceCopyPropertiesAtIndex(source, index, nil)
        let gifPropertiesPointer = UnsafeMutablePointer<UnsafeRawPointer?>.allocate(capacity: 0)
        if CFDictionaryGetValueIfPresent(cfProperties, Unmanaged.passUnretained(kCGImagePropertyGIFDictionary).toOpaque(), gifPropertiesPointer) == false {
            return delay
        }
        let gifProperties:CFDictionary = unsafeBitCast(gifPropertiesPointer.pointee, to: CFDictionary.self)
        // Get delay time
        var delayObject: AnyObject = unsafeBitCast(
            CFDictionaryGetValue(gifProperties,
                                 Unmanaged.passUnretained(kCGImagePropertyGIFUnclampedDelayTime).toOpaque()),
            to: AnyObject.self)
        if delayObject.doubleValue == 0 {
            delayObject = unsafeBitCast(CFDictionaryGetValue(gifProperties,
                                                             Unmanaged.passUnretained(kCGImagePropertyGIFDelayTime).toOpaque()), to: AnyObject.self)
        }
        delay = delayObject as? Double ?? 0
        if delay < 0.1 {
            delay = 0.1 // Make sure they're not too fast
        }
        return delay
    }
    internal class func gcdForPair(_ aaaa: Int?, _ bbbb: Int?) -> Int {
        var aaaa = aaaa
        var bbbb = bbbb
        // Check if one of them is nil
        if bbbb == nil || aaaa == nil {
            if bbbb != nil {
                return bbbb!
            } else if aaaa != nil {
                return aaaa!
            } else {
                return 0
            }
        }
        // Swap for modulo
        if aaaa! < bbbb! {
            let cccc = aaaa
            aaaa = bbbb
            bbbb = cccc
        }
        // Get greatest common divisor
        var rest: Int
        while true {
            rest = aaaa! % bbbb!
            if rest == 0 {
                return bbbb! // Found it
            } else {
                aaaa = bbbb
                bbbb = rest
            }
        }
    }
    internal class func gcdForArray(_ array: Array<Int>) -> Int {
        if array.isEmpty {
            return 1
        }
        var theGcd = array[0]
        for theVal in array {
            theGcd = UIImage.gcdForPair(theVal, theGcd)
        }
        return theGcd
    }
    internal class func animatedImageWithSource(_ source: CGImageSource) -> UIImage? {
        let count = CGImageSourceGetCount(source)
        var images = [CGImage]()
        var delays = [Int]()
        // Fill arrays
        for iiii in 0..<count {
            // Add image
            if let image = CGImageSourceCreateImageAtIndex(source, iiii, nil) {
                images.append(image)
            }
            // At it's delay in cs
            let delaySeconds = UIImage.delayForImageAtIndex(Int(iiii),
                                                            source: source)
            delays.append(Int(delaySeconds * 1000.0)) // Seconds to ms
        }
        // Calculate full duration
        let duration: Int = {
            var theSum = 0
            for theVal: Int in delays {
                theSum += theVal
            }
            return theSum
        }()
        // Get frames
        let theGcd = gcdForArray(delays)
        var frames = [UIImage]()
        var frame: UIImage
        var frameCount: Int
        for iiiii in 0..<count {
            frame = UIImage(cgImage: images[Int(iiiii)])
            frameCount = Int(delays[Int(iiiii)] / theGcd)
            for _ in 0..<frameCount {
                frames.append(frame)
            }
        }
        // Heyhey
        let animation = UIImage.animatedImage(with: frames,
                                              duration: Double(duration) / 1000.0)
        return animation
    }
}