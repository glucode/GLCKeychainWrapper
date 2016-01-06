//
//  GLCKeychainWrapper.m
//  Pods
//
//  Created by Nico du Plessis on 2015/12/24.
//
//

#import "GLCKeychainWrapper.h"

@import LocalAuthentication;

@implementation GLCKeychainWrapper

#pragma mark - Item creation

+ (BOOL)touchIDIsAvailable
{
    LAContext *context = [[LAContext alloc] init];
    NSError *error;
    // test if we can evaluate the policy, this test will tell us if Touch ID is available and enrolled
    return [context canEvaluatePolicy: LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&error];
}

+ (void)setData:(nonnull NSData *)data forKey:(nonnull NSString *)key accessControl:(nullable SecAccessControlRef)sac serviceName:(nullable NSString *)serviceName completion:(void (^ _Nullable)(GLCKeychainWrapperResult result))completionBlock
{
    // Check for nil params
    
    // we want the operation to fail if there is an item which needs authentication so we will use
    // kSecUseNoAuthenticationUI
    NSMutableDictionary *attributes = [NSMutableDictionary dictionaryWithDictionary:@{
                                 (__bridge id)kSecClass: (__bridge id)kSecClassGenericPassword,
                                 (__bridge id)kSecAttrAccount: key,
                                 (__bridge id)kSecAttrService: serviceName, 
                                 (__bridge id)kSecValueData: data,
                                 (__bridge id)kSecUseNoAuthenticationUI: @YES,
                                 }];
    
    if (sac != NULL) {
        [attributes setObject:(__bridge id)sac forKey:(__bridge id)kSecAttrAccessControl];
    }
    
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        OSStatus status = SecItemAdd((__bridge CFDictionaryRef)attributes, nil);
        
        // If a duplicate is found, just delete it and add the item again.
        if (status == errSecDuplicateItem) {
            [self syncDeleteDataForKey:key serviceName:serviceName];
            status = SecItemAdd((__bridge CFDictionaryRef)attributes, nil);
        }
        
        GLCKeychainWrapperResult result;
        
        switch (status) {
            case errSecSuccess:
                result = GLCKeychainWrapperResultSuccess;
                break;
            case errSecDuplicateItem:
                result = GLCKeychainWrapperResultFailureDuplicateItem;
                break;
            case errSecItemNotFound :
                result = GLCKeychainWrapperResultFailureItemNotFound;
                break;
            case errSecAuthFailed:
                result = GLCKeychainWrapperResultFailureAuthFailed;
                break;
            default:
                result = GLCKeychainWrapperResultFailureUnknown;
                break;
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            completionBlock(result);
        });
        
    });
}

+ (void)setString:(nonnull NSString *)string forKey:(nonnull NSString *)key serviceName:(nullable NSString *)serviceName accessControl:(nullable SecAccessControlRef)sac completion:(void (^ _Nullable)(GLCKeychainWrapperResult result))completionBlock
{
    [GLCKeychainWrapper setData:[string dataUsingEncoding:NSUTF8StringEncoding] forKey:key accessControl:sac serviceName:serviceName completion:completionBlock];
}

#pragma mark - Item deletion

+ (GLCKeychainWrapperResult)syncDeleteDataForKey:(nonnull NSString *)key serviceName:(nullable NSString *)serviceName
{
    NSMutableDictionary *query = [NSMutableDictionary dictionaryWithDictionary:@{
                                                                                 (__bridge id)kSecClass: (__bridge id)kSecClassGenericPassword,
                                                                                 (__bridge id)kSecAttrAccount: key,
                                                                                 (__bridge id)kSecAttrService: serviceName
                                                                                 }];
    
    OSStatus status = SecItemDelete((__bridge CFDictionaryRef)query);
    
    GLCKeychainWrapperResult result;
    switch (status) {
        case errSecSuccess:
            result = GLCKeychainWrapperResultSuccess;
            break;
        case errSecItemNotFound :
            result = GLCKeychainWrapperResultFailureItemNotFound;
            break;
        default:
            result = GLCKeychainWrapperResultFailureUnknown;
            break;
    }
    return result;
}

+ (void)deleteValueForKey:(nonnull NSString *)key serviceName:(nullable NSString *)serviceName completion:(void ( ^ _Nullable )(GLCKeychainWrapperResult result))completionBlock;
{
    
    NSMutableDictionary *query = [NSMutableDictionary dictionaryWithDictionary:@{
                            (__bridge id)kSecClass: (__bridge id)kSecClassGenericPassword,
                            (__bridge id)kSecAttrAccount: key,
                            (__bridge id)kSecAttrService: serviceName
                            }];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        OSStatus status = SecItemDelete((__bridge CFDictionaryRef)query);
        
        GLCKeychainWrapperResult result;
        switch (status) {
            case errSecSuccess:
                result = GLCKeychainWrapperResultSuccess;
                break;
            case errSecItemNotFound :
                result = GLCKeychainWrapperResultFailureItemNotFound;
                break;
            default:
                result = GLCKeychainWrapperResultFailureUnknown;
                break;
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            completionBlock(result);
        });
    });
}

+ (void)stringForKey:(nonnull NSString *)key serviceName:(nullable NSString *)serviceName completion:(void (^ _Nullable)(GLCKeychainWrapperResult result, NSString * _Nullable value))completionBlock
{
    NSDictionary *query = @{
                            (__bridge id)kSecClass: (__bridge id)kSecClassGenericPassword,
                            (__bridge id)kSecAttrService: serviceName,
                            (__bridge id)kSecReturnData: @YES,
                            (__bridge id)kSecUseOperationPrompt: @"Authenticate to access service password",
                            };
    
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        CFTypeRef dataTypeRef = NULL;
        OSStatus status = SecItemCopyMatching((__bridge CFDictionaryRef)(query), &dataTypeRef);

        NSData *resultData = (__bridge_transfer NSData *)dataTypeRef;
        __block NSString *value = [[NSString alloc] initWithData:resultData encoding:NSUTF8StringEncoding];
        
        GLCKeychainWrapperResult result;
        switch (status) {
            case errSecSuccess:
                result = GLCKeychainWrapperResultSuccess;
                break;
            case errSecItemNotFound :
                result = GLCKeychainWrapperResultFailureItemNotFound;
                break;
            default:
                result = GLCKeychainWrapperResultFailureUnknown;
                break;
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            completionBlock(result, value);
        });

    });
}

#pragma mark - Access control helpers

+ (nullable SecAccessControlRef)touchIDCurrentSetWhenUnlockedThisDeviceOnlySAC;
{
    CFErrorRef error = NULL;
    
    // Should be the secret invalidated when passcode is removed? If not then use kSecAttrAccessibleWhenUnlocked
    SecAccessControlRef sacObject = SecAccessControlCreateWithFlags(kCFAllocatorDefault,
                                                                    kSecAttrAccessibleWhenPasscodeSetThisDeviceOnly,
                                                                    kSecAccessControlTouchIDCurrentSet, &error);

    return sacObject;
}

@end
