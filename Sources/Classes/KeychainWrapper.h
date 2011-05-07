/*
 * Derived heavily from:
 **
 File: KeychainItemWrapper.h
 Abstract: 
 Objective-C wrapper for accessing a single keychain item.
 Copyright (C) 2010 Apple Inc. All Rights Reserved.
 **
 Modified and used pursuant to the Apple license, which permits redistribution of a modified version without including the license. 
 See the Keychain Services Programming Guide and the GenericKeychainsample project for more information.
 */ 

#import <UIKit/UIKit.h>
#import <Security/Security.h>

//Define an Objective-C wrapper class to hold Keychain Services code.
@interface KeychainWrapper : NSObject {
    NSMutableDictionary        *keychainData;
    NSMutableDictionary        *genericPasswordQuery;
}

@property (nonatomic, retain) NSMutableDictionary *keychainData;
@property (nonatomic, retain) NSMutableDictionary *genericPasswordQuery;
@property (nonatomic, retain) NSString *password;

- (void)setObject:(id)inObject forKey:(id)key;
- (id)objectForKey:(id)key;
- (void)resetKeychainItem;

@end

//Unique string used to identify the keychain item:
static const UInt8 kKeychainItemIdentifier[]    = "com.tasermonkeys.passwordmaker.keychain\0";
