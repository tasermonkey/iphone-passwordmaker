//
//  MasterPasswordStorageHasher.h
//  PasswordMaker
//
//  Created by James Stapleton on 6/17/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

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
