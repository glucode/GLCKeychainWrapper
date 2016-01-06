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

#pragma mark - Writing data

+ (BOOL)touchIDIsAvailable;

/**
 Sets data for key in Keychain.
 @param data The data to store.
 @param key The key for the data.
 @param sac The SecAccessControlRef object specifying the ACL for the data protection. This value can be nil.
 @param serviceName The service name. This value can be nil.
 @param completionBlock The completion block that will be called once the operation completes.
 */
+ (void)setData:(nonnull NSData *)data forKey:(nonnull NSString *)key accessControl:(nullable SecAccessControlRef)sac serviceName:(nullable NSString *)serviceName completion:(void (^ _Nullable)(GLCKeychainWrapperResult result))completionBlock;

/**
 Sets a string for key in Keychain.
 @param string The string to store.
 @param key The key for the data.
 @param sac The SecAccessControlRef object specifying the ACL for the data protection. This value can be nil.
 @param serviceName The service name. This value can be nil.
 @param completionBlock The completion block that will be called once the operation completes.
 */
+ (void)setString:(nonnull NSString *)string forKey:(nonnull NSString *)key serviceName:(nullable NSString *)serviceName accessControl:(nullable SecAccessControlRef)sac completion:(void (^ _Nullable)(GLCKeychainWrapperResult result))completionBlock;

#pragma mark - Reading data

+ (void)stringForKey:(nonnull NSString *)key serviceName:(nullable NSString *)serviceName completion:(void (^ _Nullable)(GLCKeychainWrapperResult result, NSString * _Nullable value))completionBlock;

#pragma mark - Deleting data

/**
 Deletes data from Keychain.
 @param key The key for the data.
 @param serviceName The service name. This value can be nil.
 */
+ (void)deleteValueForKey:(nonnull NSString *)key serviceName:(nullable NSString *)serviceName completion:(void ( ^ _Nullable )(GLCKeychainWrapperResult result))completionBlock;


+ (nullable SecAccessControlRef)touchIDCurrentSetWhenUnlockedThisDeviceOnlySAC;

@end
