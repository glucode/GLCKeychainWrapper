# GLCKeychainWrapper

[![CI Status](http://img.shields.io/travis/Nico du Plessis/GLCKeychainWrapper.svg?style=flat)](https://travis-ci.org/Nico du Plessis/GLCKeychainWrapper)
[![Version](https://img.shields.io/cocoapods/v/GLCKeychainWrapper.svg?style=flat)](http://cocoapods.org/pods/GLCKeychainWrapper)
[![License](https://img.shields.io/cocoapods/l/GLCKeychainWrapper.svg?style=flat)](http://cocoapods.org/pods/GLCKeychainWrapper)
[![Platform](https://img.shields.io/cocoapods/p/GLCKeychainWrapper.svg?style=flat)](http://cocoapods.org/pods/GLCKeychainWrapper)

## Usage

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Installation

GLCKeychainWrapper is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "GLCKeychainWrapper"
```

## Adding items

### With Touch ID

```Objective-C
SecAccessControlRef sac = [GLCKeychainWrapper touchIDCurrentSetWhenUnlockedThisDeviceOnlySAC];

[keychain setData:data forKey:@"username" accessControl:sac serviceName:@"com.glucode.GLCKeychainWrapper" completion:^(GLCKeychainWrapperResult result) {
    if (result == GLCKeychainWrapperResultSuccess) {
        NSLog(@"Successfully added item");
    }
}];
```

## Author

Nico du Plessis, duplessis.nico@gmail.com

## License

GLCKeychainWrapper is available under the MIT license. See the LICENSE file for more info.
