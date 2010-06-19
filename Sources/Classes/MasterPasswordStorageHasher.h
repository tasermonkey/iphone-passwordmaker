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
#import "hasher.h"


@interface MasterPasswordStorageHasher : Hasher {
	NSString* savedPasswordHash ;
}

- (id) initWithPasswordHash:(NSString*)initialHash ;

@property (readonly, nonatomic) NSString* savedPasswordHash ;
@property (readonly, nonatomic) BOOL noMasterPasswordStored ;


- (BOOL) matchesPassword:(NSString*)password ;

- (void) setNewMasterPassword:(NSString*)masterPass ;

- (NSString*) _genHash:(NSString*)password;

- (NSString*) _hash:(NSString*)hash ;



@end
