/*

The MIT License (MIT)

Copyright (c) 2015 Cereopsis

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
*/

extension NSURL {
    
    /// Returns value of `NSURLTypeIdentifierKey` property
    var mimeType: String? {
        var tmp = AnyObject?()
        let _ = try? getResourceValue(&tmp, forKey: NSURLTypeIdentifierKey)
        return tmp as? String
    }
    
    /// Returns value of `NSURLCreationDateKey` property
    var creationDate: NSDate? {
        return getDateObject(forKey: NSURLCreationDateKey)
    }
    
    /// Returns value of `NSURLContentModificationDateKey` property
    var lastModified: NSDate? {
        return getDateObject(forKey: NSURLContentModificationDateKey)
    }
    
    /// Return named property as NSDate
    private func getDateObject(forKey key: String) -> NSDate? {
        var tmp = AnyObject?()
        let _ = try? getResourceValue(&tmp, forKey: key)
        return tmp as? NSDate
    }
    
    /// Return `lastPathComponent` minus any extension
    /// - important: Trailing path separators are ignored e.g /x/y/z/ resolves to `z`
    var resourceName: String? {
        if let name = lastPathComponent {
            switch pathExtension {
            case .Some(let x) where !x.isEmpty:
                let end = name.characters.indexOf(".")!
                return name.substringToIndex(end)
            default:
                return name
            }
        }
        
        return nil
    }
    
}
