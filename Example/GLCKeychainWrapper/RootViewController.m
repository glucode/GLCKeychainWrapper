//
//  RootViewController.m
//  GLCKeychainWrapper
//
//  Created by Nico du Plessis on 2016/01/04.
//  Copyright © 2016 Nico du Plessis. All rights reserved.
//

#import "RootViewController.h"
#import "GLCKeychainWrapper.h"

@interface RootViewController ()

@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)addItem
{
    GLCKeychainWrapper *keychain = [GLCKeychainWrapper new];
    
    NSData *data = [@"secret value" dataUsingEncoding:NSUTF8StringEncoding];

    [keychain deleteDataForKey:@"username" serviceName:@"com.glucode.GLCKeychainWrapper" completion:^(GLCKeychainWrapperResult result) {
        NSLog(@"Deleting");
        
        SecAccessControlRef sac = [GLCKeychainWrapper touchIDCurrentSetWhenUnlockedThisDeviceOnlySAC];
        
        [keychain setData:data forKey:@"username" accessControl:sac serviceName:@"com.glucode.GLCKeychainWrapper" completion:^(GLCKeychainWrapperResult result) {
            
            if (result == GLCKeychainWrapperResultSuccess) {
                NSLog(@"Successfully added item");
            }
        }];
    }];
}

- (IBAction)readItem:(id)sender
{
    GLCKeychainWrapper *keychain = [GLCKeychainWrapper new];
    [keychain stringForKey:@"username" serviceName:@"com.glucode.GLCKeychainWrapper" completion:^(GLCKeychainWrapperResult result, NSString * _Nullable value) {
        
        NSLog(@"%@", value);
        
    }];
}

@end
