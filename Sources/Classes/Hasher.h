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

#import <Foundation/Foundation.h>
#import "hash_type_enum.h"

@interface Hasher : NSObject {
	NSString* profileName ;
	NSString* counter ;
	NSString* prefix ;
	NSString* suffix ;
	NSString* hashAlgo ;
	NSString* characters ;
	NSInteger maxLen ;
	enum HASHTYPE algo ;
	enum leetType leetSpeak ;
	BOOL isHmac ;
	NSInteger leetLevel ;
	
	NSString* savedPasswordHash ;
}

- (id) init ;

@property (retain, nonatomic) NSString* profileName ;
@property (retain, nonatomic) NSString* counter ;
@property (retain, nonatomic) NSString* prefix ;
@property (retain, nonatomic) NSString* suffix ;
@property (retain, nonatomic) NSString* hashAlgo ;
@property (retain, nonatomic) NSString* characters ;
@property (assign, nonatomic) NSInteger maxLen ;
@property (assign, nonatomic) enum leetType leetSpeak ;
@property (assign, nonatomic) NSInteger leetLevel ;

@property (retain, nonatomic) NSString* savedPasswordHash ;

- (NSArray*) allHashAlgos ;


- (NSString*) generatePasswordWithMasterPassword:(NSString*)masterPass 
											 Url:(NSString*)url Username:(NSString*)user ;
// private:
- (NSString*) hash:(NSString*)key Text:(NSString*)text;
+ (NSString*) rstr2any:(unsigned char *)input charSet:(NSString*)encoding length:(NSInteger)length ;
@end
