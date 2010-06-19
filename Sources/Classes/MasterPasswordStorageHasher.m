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

#import "MasterPasswordStorageHasher.h"


#define hash_seed       @"q#-f21@xNh9sJaKv6TLv8ipR%YgT&RnwMP4Zz2pMya&C44B137+wRkk7C08BF*b1"
#define mstpass_charset @"0123456789abcdef"
#define sha256_charset  @"FByDU98TAfzvkuaxgUH3HuMJ1jspdFu9"
#define sha1_charset    @"0cOJL6EsNlHFMWkbyPCU0EoBOZ80Ck2j"
#define md5_charset     @"BPVB1oCrr2BJzhH6qM43kq9lLUqMQWxj"
#define md4_charset     @"szPBOPb2WZwWCOYylDNb0kda4HPdp9I7"
@implementation MasterPasswordStorageHasher
@synthesize savedPasswordHash ;


- (id) initWithPasswordHash:(NSString*)hsh {
	if ( self = [super init] ) {
		savedPasswordHash = [hsh retain] ;
	}
	return self ;
}

- (BOOL) noMasterPasswordStored {
	return ! savedPasswordHash || [savedPasswordHash length] == 0 ;
}

- (BOOL) matchesPassword:(NSString*)password {
	if ( savedPasswordHash == nil ) return NO ;
	NSString* newHash = [self _genHash:password] ;
	return [newHash compare:savedPasswordHash] == NSOrderedSame ;
}

- (void) setNewMasterPassword:(NSString*)masterPass {
	savedPasswordHash = [[self _genHash:masterPass] retain];
}

- (NSString*) _genHash:(NSString*)masterPass {
	NSString* hash = [self hashText:masterPass WithAlgo:HASHTYPE_HMAC_SHA256 AndCharacterSet:mstpass_charset] ;
	return [self _hash:hash] ;
}

- (NSString*) _hash:(NSString*)hash {
	for (int i = 0; i < 16; ++i) {
		hash = [self hashText:[hash stringByAppendingString:hash_seed] WithAlgo:HASHTYPE_HMAC_SHA256 AndCharacterSet:sha256_charset] ;
		hash = [self hashText:[hash stringByAppendingString:hash_seed] WithAlgo:HASHTYPE_HMAC_SHA1 AndCharacterSet:sha1_charset] ;
		hash = [self hashText:[hash stringByAppendingString:hash_seed] WithAlgo:HASHTYPE_HMAC_MD5 AndCharacterSet:md5_charset] ;
		hash = [self hashText:[hash stringByAppendingString:hash_seed] WithAlgo:HASHTYPE_HMAC_MD4 AndCharacterSet:md4_charset] ;
	}
	hash = [hash stringByReplacingCharactersInRange:NSMakeRange(0, 1) withString:@"n"] ;
	return hash ;
}

- (void) dealloc
{
	[savedPasswordHash release] ;
	[super dealloc] ;
}

@end
