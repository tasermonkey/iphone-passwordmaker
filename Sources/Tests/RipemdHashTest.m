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

#import "RipemdHashTest.h"
#import "ripemd.h"
#import "Hasher.h"
#include <stdio.h>

const char * fancy( unsigned char* data, mutils_word32 len, unsigned char* output_in ) {
	char tmp[6] ;
	char * output = (char*)output_in ;
	const char* ret = output ;
	*output++ = '{' ;
	for (int i = 0; i < len; ++i) {
		sprintf(tmp, "0x%x,", (int)data[i]) ;
		int len = strlen(tmp) ;
		strcpy(output, tmp) ;
		output+=len ;
	}
	*output++ = '}' ;
	*output++ = ';' ;
	return ret ;
}

@implementation RipmdHashTest

- (void) testHash {
	NSString* text = @"Hello World" ;
	const char *cStrTxt = [text UTF8String]; /* since some characters are more than 1 char wide  */
	mutils_word32 cStrTxtLen = strlen(cStrTxt) ;
	unsigned char result[RIPEMD160_DIGESTSIZE];
	hash160_ripemd(cStrTxt, cStrTxtLen, result) ;
	unsigned char expected[RIPEMD160_DIGESTSIZE] =  {0xa8,0x30,0xd7,0xbe,0xb0,0x4e,0xb7,0x54,
		0x9c,0xe9,0x90,0xfb,0x7d,0xc9,0x62,0xe4,0x99,0xa2,0x72,0x30 } ;
	unsigned char expStr[RIPEMD160_DIGESTSIZE*5 + 1] ;
	STAssertTrue(memcmp(result, expected, RIPEMD160_DIGESTSIZE) == 0, @"Generated value is wrong! for \"%s\"",
				 fancy(result, RIPEMD160_DIGESTSIZE, expStr) );
	
}

- (void) setUp {
	hasher = [[Hasher alloc] init] ;	
	hasher.hashAlgo = @"RIPEMD-160" ;
}

- (void) tearDown {
	[hasher release] ;
}

- (void) testBasic {
	NSString* genPass = [hasher generatePasswordWithMasterPassword:@"hello" Url:@"google.com" Username:@""] ;
	STAssertTrue([genPass isEqualToString:@"NJmQwwPKH0uR"], @"Generated password is wrong! Value \"%@\"", genPass) ;
}

- (void) testWithUsername {
	NSString* genPass = [hasher generatePasswordWithMasterPassword:@"hello" Url:@"google.com" Username:@"james"] ;
	STAssertTrue([genPass isEqualToString:@"GExbTcUMSVib"], @"Generated password is wrong! Value \"%@\"", genPass) ;
}

- (void) testWithUsernameAndModifier {
	hasher.counter = @"aaa" ;
	NSString* genPass = [hasher generatePasswordWithMasterPassword:@"hello" Url:@"google.com" Username:@"james"] ;
	STAssertTrue([genPass isEqualToString:@"Yn7NafD7qdRj"], @"Generated password is wrong! Value \"%@\"", genPass) ;
}

- (void) testWithSuffix {
	hasher.suffix = @"sW" ;
	NSString* genPass = [hasher generatePasswordWithMasterPassword:@"hello" Url:@"google.com" Username:@"james"] ;
	STAssertTrue([genPass isEqualToString:@"GExbTcUMSVsW"], @"Generated password is wrong! Value \"%@\"", genPass) ;
}

- (void) testWithPrefix {
	hasher.prefix = @"r213" ;
	NSString* genPass = [hasher generatePasswordWithMasterPassword:@"hello" Url:@"google.com" Username:@"james"] ;
	STAssertTrue([genPass isEqualToString:@"r213GExbTcUM"], @"Generated password is wrong! Value \"%@\"", genPass) ;
}

- (void) testWithPrefixAndSuffix {
	hasher.prefix = @"r213" ;
	hasher.suffix = @"sW" ;
	NSString* genPass = [hasher generatePasswordWithMasterPassword:@"hello" Url:@"google.com" Username:@"james"] ;
	STAssertTrue([genPass isEqualToString:@"r213GExbTcsW"], @"Generated password is wrong! Value \"%@\"", genPass) ;
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
	STAssertTrue([genPass isEqualToString:@"GExbTcUM"], @"Generated password is wrong! Value \"%@\"", genPass) ;
	hasher.maxLen = 2 ;
	genPass = [hasher generatePasswordWithMasterPassword:@"hello" Url:@"google.com" Username:@"james"] ;
	STAssertTrue([genPass isEqualToString:@"GE"], @"Generated password is wrong! Value \"%@\"", genPass) ;
	hasher.maxLen = 64 ;
	genPass = [hasher generatePasswordWithMasterPassword:@"hello" Url:@"google.com" Username:@"james"] ;
	STAssertTrue([genPass isEqualToString:@"GExbTcUMSVibmpBsvxJnyymOdsNPDBxd0uuIZ2m41MNfrxqI3AE35AG7hHqFWCjK"], @"Generated password is wrong! Value \"%@\"", genPass) ;
	hasher.maxLen = 1024 ; // something thats really really long ...
	genPass = [hasher generatePasswordWithMasterPassword:@"hello" Url:@"google.com" Username:@"james"] ;
	STAssertTrue([genPass isEqualToString:@"GExbTcUMSVibmpBsvxJnyymOdsNPDBxd0uuIZ2m41MNfrxqI3AE35AG7hHqFWCjKEQlEkolaPX39bKYVnZLn1B77O5YsfAolGFAWEKiFLn1ODO9op493ShTe5f1L303bnL6qJP3KlBMGitS02a4r5H34PoHuQ34u5nFem9fmHb8MiOtzMVdJuEbT6psf7TachlHF0XY65t8lZpkcQqBLwTdFSO9jfwJwuC1cJaZaXqbNfRiijSLRRvKDb3zGgqJpx0RWBdGjJQ6e3NNE65KMa5RsGzsQIl9BCJTSQHbtqGsKdCD5RePOvR6P5HmvC5Jn26dxNqDhGxWFM7qtFx0UMvnLyoehqFXJdOCJH7GcbqPVerV6H4sycdybdPRjopLOtOUByrBW8nBFoQjc0h5LkDWnDtCWCGqBQOaHXGVsiXhcYK7PZ9ImwhW160wpzR92yJz6g4IGXTXDV7XXp1AVnYeqAIWKOZglH1mUa8RVd2w3PMjotweUIJ0cGpzWG3H6XNT8yk557NIpZXMjeoGeuwFGQOZDT4HKTTKSTEzJp1y58EF4cN219sxLtj15at2WSfNAGFvSU70Ae0zdYZC4MwtHtmVM65Oz2DD84uQg37oZKEkWF2ubMZN9iXUNAO9rXo5WA1QaOyxsPAGIV2etDN9VilByrUOlJ2JD5uJwg1PU7eEeYG0tAXAtXj7M0X5KqKBmpzsec4u5a0h9PMMJ8fTNhj1J1y4ChwxHwUoWySUw2zQlnSogddwDRkg2rVRU6P4pJFNXlVDWDzT68RNXGdF3UynddjhT6U5SnfjBsQa1Fm0KuDQJ7ctAGOdwLsEQomCTVcdpCa1enc1SHU9y2a5w0NtNyCIfcCK3QAfTbCs0LXGBDyNGqrXvOLuP11d3iJBMoeYAzljD7XHUZBHtVlbWjEo32gZLkUzqJ3rTBsxCAdtRlcFVb7UcUQCXqzKAkomD7SZ5KKPqFAZ9fJifggHNC8Gggl0OA7D3Ud2yfPqAc6lWx28kXD0fOB5uy1TT"], @"Generated password is wrong! Value \"%@\"", genPass) ;
}

- (void) testLeetBeforeLevel3 {
	hasher.leetLevel = 3 ;
	hasher.leetSpeak = LEET_BEFORE ;
	hasher.characters = @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789`~!@#$%^&*()_-+={}|[]\\:\";'<>?,./";
	NSString* genPass = [hasher generatePasswordWithMasterPassword:@"hello" Url:@"google.com" Username:@""] ;
	STAssertTrue([genPass isEqualToString:@"F9[eHelcN=fq"], @"Generated password is wrong! Value \"%@\"", genPass) ;
}

- (void) testLeetAfterLevel7 {
	hasher.leetLevel = 7 ;
	hasher.leetSpeak = LEET_AFTER ;
	NSString* genPass = [hasher generatePasswordWithMasterPassword:@"hello" Url:@"google.com" Username:@""] ;
	STAssertTrue([genPass isEqualToString:@"^/,|^^9\\/\\/\\"], @"Generated password is wrong! Value \"%@\"", genPass) ;
}

- (void) testLeetBothLevel9 {
	hasher.leetLevel = 9 ;
	hasher.leetSpeak = LEET_BOTH ;
	NSString* genPass = [hasher generatePasswordWithMasterPassword:@"hello" Url:@"google.com" Username:@""] ;
	STAssertTrue([genPass isEqualToString:@"2(,)||5(,)|_"], @"Generated password is wrong! Value \"%@\"", genPass) ;
}

@end
