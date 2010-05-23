/* 
 * Copyright (C) 2010  James Stapleton
 *
 * This file is part of Iphone PasswordMaker.
 *
 * Iphone PasswordMaker is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * Iphone PasswordMaker is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 * You should have received a copy of the GNU General Public License
 * along with Iphone PasswordMaker.  If not, see <http://www.gnu.org/licenses/>.
 *
 */

#import "RootViewController.h"
#import "Hasher.h"

@interface PasswordMakerAppDelegate : NSObject <UIApplicationDelegate> {
    
    UIWindow *window;
    UINavigationController *navigationController;
	RootViewController* rootViewController ;
	NSDictionary* charSetNames ;
	Hasher* hasher ;
	NSMutableArray* profileList ;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UINavigationController *navigationController;
@property (nonatomic, retain) NSDictionary* charSetNames ;
@property (readonly, nonatomic) NSArray* profileList ;

- (enum leetType) leetTypeFromSettingString:(NSString*)str ;
- (NSString*) settingStringFromLeetType:(enum leetType)lt ;

- (void) saveHasherProfile ;
- (void) loadHasherProfile:(NSString*)profileName ;

- (void) addProfile:(NSString*)str ;
- (void) remProfile:(NSString*)str ;

- (void) setNewMasterPassword:(NSString*)password ;
- (BOOL) matchesSavedPassword:(NSString*)password ;

@end

