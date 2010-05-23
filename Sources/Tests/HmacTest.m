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
#import "HmacTest.h"
#import "Hasher.h"
#import "HMacer.h" ;
#include <CommonCrypto/CommonDigest.h> 

@implementation HMacTest
- (void) setUp {
	hasher = [[Hasher alloc] init] ;	
	hasher.hashAlgo = @"HMAC-SHA1" ;
}

- (void) tearDown {
	[hasher release] ;
}

- (void) testHmacImpl {
	const char* text = "google.com" ;
	const CC_LONG txtLen = strlen(text) ;
	const char* key = "hello" ;
	const CC_LONG keyLen = strlen(key) ;
	unsigned char result[CC_SHA1_DIGEST_LENGTH];
	
	unsigned char* hmac_sha1( const char* text, CC_LONG len, const char* key, CC_LONG keylen, unsigned char* md) ;
	hmac_sha1( text, txtLen, key, keyLen, result ) ;
	NSString* genHash = [Hasher rstr2any:result charSet:hasher.characters length:CC_SHA1_DIGEST_LENGTH] ;
	STAssertTrue([genHash isEqualToString:@"a7XktxpWtnTkCwLlu5hywBG0t4k"], @"Generated password is wrong! Value \"%@\"", genHash) ;		
}

- (void) testBasic {
	NSString* genPass = [hasher generatePasswordWithMasterPassword:@"hello" Url:@"google.com" Username:@""] ;
	STAssertTrue([genPass isEqualToString:@"a7XktxpWtnTk"], @"Generated password is wrong! Value \"%@\"", genPass) ;
}

- (void) testWithUsername {
	NSString* genPass = [hasher generatePasswordWithMasterPassword:@"hello" Url:@"google.com" Username:@"james"] ;
	STAssertTrue([genPass isEqualToString:@"VkkKxIZt2vDQ"], @"Generated password is wrong! Value \"%@\"", genPass) ;
}

- (void) testWithUsernameAndModifier {
	hasher.counter = @"aaa" ;
	NSString* genPass = [hasher generatePasswordWithMasterPassword:@"hello" Url:@"google.com" Username:@"james"] ;
	STAssertTrue([genPass isEqualToString:@"GESVfssk9hY9"], @"Generated password is wrong! Value \"%@\"", genPass) ;
}

- (void) testWithSuffix {
	hasher.suffix = @"sW" ;
	NSString* genPass = [hasher generatePasswordWithMasterPassword:@"hello" Url:@"google.com" Username:@"james"] ;
	STAssertTrue([genPass isEqualToString:@"VkkKxIZt2vsW"], @"Generated password is wrong! Value \"%@\"", genPass) ;
}

- (void) testWithPrefix {
	hasher.prefix = @"r213" ;
	NSString* genPass = [hasher generatePasswordWithMasterPassword:@"hello" Url:@"google.com" Username:@"james"] ;
	STAssertTrue([genPass isEqualToString:@"r213VkkKxIZt"], @"Generated password is wrong! Value \"%@\"", genPass) ;
}

- (void) testWithPrefixAndSuffix {
	hasher.prefix = @"r213" ;
	hasher.suffix = @"sW" ;
	NSString* genPass = [hasher generatePasswordWithMasterPassword:@"hello" Url:@"google.com" Username:@"james"] ;
	STAssertTrue([genPass isEqualToString:@"r213VkkKxIsW"], @"Generated password is wrong! Value \"%@\"", genPass) ;
}

- (void) testWithPrefixAndSuffixComplete {
	// One more charector than maxLen
	hasher.maxLen = 12 ;
	hasher.prefix = @"r213Ty2" ; 
	hasher.suffix = @"sWwww3" ;
	NSString* genPass = [hasher generatePasswordWithMasterPassword:@"hello" Url:@"google.com" Username:@"james"] ;
	STAssertTrue([genPass isEqualToString:@"r213TysWwww3"], @"Generated password is wrong! Value \"%@\"", genPass) ;
}

- (void) testMaxLen {
	// One more charector than maxLen
	hasher.maxLen = 8 ;
	NSString* genPass = [hasher generatePasswordWithMasterPassword:@"hello" Url:@"google.com" Username:@"james"] ;
	STAssertTrue([genPass isEqualToString:@"VkkKxIZt"], @"Generated password is wrong! Value \"%@\"", genPass) ;
	hasher.maxLen = 2 ;
	genPass = [hasher generatePasswordWithMasterPassword:@"hello" Url:@"google.com" Username:@"james"] ;
	STAssertTrue([genPass isEqualToString:@"Vk"], @"Generated password is wrong! Value \"%@\"", genPass) ;
	hasher.maxLen = 64 ;
	genPass = [hasher generatePasswordWithMasterPassword:@"hello" Url:@"google.com" Username:@"james"] ;
	STAssertTrue([genPass isEqualToString:@"VkkKxIZt2vDQZ7e0RUSHOFfxA4SBuiiH3HLrHHrjoXxscwKeO1NrEvdYRg6SLe0M"], @"Generated password is wrong! Value \"%@\"", genPass) ;
	hasher.maxLen = 1024 ; // something thats really really long ...
	genPass = [hasher generatePasswordWithMasterPassword:@"hello" Url:@"google.com" Username:@"james"] ;
	STAssertTrue([genPass isEqualToString:@"VkkKxIZt2vDQZ7e0RUSHOFfxA4SBuiiH3HLrHHrjoXxscwKeO1NrEvdYRg6SLe0MNCc60ItyKNiScMS41UHMuhXIwsFVl0Fx9OsqIF6GcsOiIl1ZLz7zWlmh0GqOSnw8SwQQwknY6ICeMfiBzIxYu8b3ZG3hViL312doqlR63S9S2sFKjCOM5ediRbeU6cgnhbCU2ViVr6doInTD0j6yMlajbgSMCJEssxCRHLIigW2C8YKlIxOWqdhxdwtZetrCCJ0DmNkWQ1x7PGYkzbyh2PH5Myx5IfVEcVc2rLnzySzwoY7eoRTn8trVlPQreM0f8689fIaeuFjLORakkbhMAyVwVa6zyFIcXRI0BxkFuWjiVxGyd0QeRBXqPWKhy2BcsTaBAuT2i3zFTLQS5huu0BWRVXatpNnmTdjiUPGyyzTj7wSwZIKf6XC4qTNzqN14CzPbaqr8qAQBosevFFqIh3DbeQqMhk722SdviyZlYNlr4GxmfAQ3bTU7H51mJyi3lQnHf5P4F4P5lBbwqj8Hxsz93rg4GvUDtXOnbskKKw7QD6tZ7YUdLVlChvSJVxYZE7RXPilZieUmBjN6SRdKMVjEVLCb0ztnWcriOM1hurIXBOaOD9G30yGFgD0NiuSUPEQ7tInJP8cCwlxBZsiSTDL5c1yKB34nT5pEpTvxHAN9W5aC2OuZXkWuC9rPGTiqhDtEbSNiLOFSj7yYvicJkRgCRNlzAKbTZETtaaLRZlbbhZY2WdwUTrDLOLIEXjXeTc28QLfusQD1Rz4YYOXVNYuemsWEvzWdHMnCMcDSJGX8BMjOg2Bj1LCJk8xcbT2R95sDcRHyhdMUplJqlmDZBZdoRqGTgyn2Z1fl2QjZVxv0oHNXDI5ctBPATB8f5Gk2GC1sESmti5oEt6kHxyjphSNDztRMQQhv1PMoiYN3Ua1BKbk03LXjP1FvRfdBOIJNOUdlefVLLWRpHCLvpBWpz8QeHycNgbssgYTNntYWDrhqgi5owblGNsgh6SbIfV9G"], @"Generated password is wrong! Value \"%@\"", genPass) ;
}

- (void) testLeetBeforeLevel3 {
	hasher.leetLevel = 3 ;
	hasher.leetSpeak = LEET_BEFORE ;
	hasher.characters = @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789`~!@#$%^&*()_-+={}|[]\\:\";'<>?,./";
	NSString* genPass = [hasher generatePasswordWithMasterPassword:@"hello" Url:@"google.com" Username:@""] ;
	STAssertTrue([genPass isEqualToString:@"GK_t*E[coDaX"], @"Generated password is wrong! Value \"%@\"", genPass) ;
}

- (void) testLeetAfterLevel7 {
	hasher.leetLevel = 7 ;
	hasher.leetSpeak = LEET_AFTER ;
	NSString* genPass = [hasher generatePasswordWithMasterPassword:@"hello" Url:@"google.com" Username:@""] ;
	STAssertTrue([genPass isEqualToString:@"@7><|<7><|*\\"], @"Generated password is wrong! Value \"%@\"", genPass) ;
}

- (void) testLeetBothLevel9 {
	hasher.leetLevel = 9 ;
	hasher.leetSpeak = LEET_BOTH ;
	NSString* genPass = [hasher generatePasswordWithMasterPassword:@"hello" Url:@"google.com" Username:@""] ;
	STAssertTrue([genPass isEqualToString:@"8(,)|{|_||_|"], @"Generated password is wrong! Value \"%@\"", genPass) ;
}
@end
