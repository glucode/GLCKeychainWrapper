# GLCKeychainWrapper

[![CI Status](http://img.shields.io/travis/glucode/GLCKeychainWrapper.svg?style=flat)](https://travis-ci.org/glucode/GLCKeychainWrapper)
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

## Using GLCKeychainWrapper

### Adding items to Keychain

#### Without any access control

```Objective-C
[keychain setData:data forKey:@"username" accessControl:nil serviceName:@"com.glucode.GLCKeychainWrapper" completion:^(GLCKeychainWrapperResult result) {
    if (result == GLCKeychainWrapperResultSuccess) {
        NSLog(@"Successfully added item");
    }
}];
```

#### With Touch ID access control

```Objective-C
SecAccessControlRef sac = [GLCKeychainWrapper touchIDCurrentSetWhenUnlockedThisDeviceOnlySAC];

[keychain setData:data forKey:@"username" accessControl:sac serviceName:@"com.glucode.GLCKeychainWrapper" completion:^(GLCKeychainWrapperResult result) {
    if (result == GLCKeychainWrapperResultSuccess) {
        NSLog(@"Successfully added item");
    }
}];
```

### Reading items from Keychain

```Objective-C
GLCKeychainWrapper *keychain = [GLCKeychainWrapper new];
[keychain stringForKey:@"username" serviceName:@"com.glucode.GLCKeychainWrapper" completion:^(GLCKeychainWrapperResult result, NSString * _Nullable value) {
   
   NSLog(@"%@", value);
   
}];
```

## Author

Nico du Plessis, duplessis.nico@gmail.com

## License

GLCKeychainWrapper is available under the MIT license. See the LICENSE file for more info.
