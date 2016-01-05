//
//  GLCKeychainWrapper.h
//  Pods
//
//  Created by Nico du Plessis on 2015/12/24.
//
//

#import <Foundation/Foundation.h>

typedef enum {
    GLCKeychainWrapperResultSuccess,
    GLCKeychainWrapperResultFailureDuplicateItem,
    GLCKeychainWrapperResultFailureItemNotFound,
    GLCKeychainWrapperResultFailureAuthFailed,
    GLCKeychainWrapperResultFailureUnknown,
} GLCKeychainWrapperResult;

@interface GLCKeychainWrapper : NSObject

/**
 Sets data for key in Keychain.
 @param data The data to store.
 @param key The key for the data.
 @param sac The key for the data.
 @param serviceName The key for the data.
 @param completionBlock The key for the data.
 */
- (void)setData:(nonnull NSData *)data forKey:(nonnull NSString *)key accessControl:(nullable SecAccessControlRef)sac serviceName:(nullable NSString *)serviceName completion:(void (^ _Nullable)(GLCKeychainWrapperResult result))completionBlock;

/**
 Sets a string for key in Keychain.
 @param data The string to store.
 @param key The key for the data.
 */
- (void)setString:(nonnull NSString *)string forKey:(nonnull NSString *)key serviceName:(nullable NSString *)serviceName accessControl:(nullable SecAccessControlRef)sac completion:(void (^ _Nullable)(GLCKeychainWrapperResult result))completionBlock;

- (void)stringForKey:(nonnull NSString *)key serviceName:(nullable NSString *)serviceName completion:(void (^ _Nullable)(GLCKeychainWrapperResult result, NSString * _Nullable value))completionBlock;

/**
 Deletes data from Keychain.
 @param key The key for the data.
 */
- (void)deleteDataForKey:(nonnull NSString *)key serviceName:(nullable NSString *)serviceName completion:(void ( ^ _Nullable )(GLCKeychainWrapperResult result))completionBlock;

+ (nullable SecAccessControlRef)touchIDCurrentSetWhenUnlockedThisDeviceOnlySAC;

@end
