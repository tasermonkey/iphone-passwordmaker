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


#import "HashSHA1Test.h"
#import "Hasher.h"

@implementation HashSHA1Test
- (void) setUp {
	hasher = [[Hasher alloc] init] ;	
	hasher.hashAlgo = @"SHA1" ;
}

- (void) tearDown {
	[hasher release] ;
}

- (void) testBasic {
	NSString* genPass = [hasher generatePasswordWithMasterPassword:@"hello" Url:@"google.com" Username:@""] ;
	STAssertTrue([genPass isEqualToString:@"GFx2T9FVauS5"], @"Generated password is wrong! Value \"%@\"", genPass) ;
}

- (void) testWithUsername {
	NSString* genPass = [hasher generatePasswordWithMasterPassword:@"hello" Url:@"google.com" Username:@"james"] ;
	STAssertTrue([genPass isEqualToString:@"D5XnIracRefA"], @"Generated password is wrong! Value \"%@\"", genPass) ;
}

- (void) testWithUsernameAndModifier {
	hasher.counter = @"aaa" ;
	NSString* genPass = [hasher generatePasswordWithMasterPassword:@"hello" Url:@"google.com" Username:@"james"] ;
	STAssertTrue([genPass isEqualToString:@"QDNVM3u3kXTP"], @"Generated password is wrong! Value \"%@\"", genPass) ;
}

- (void) testWithSuffix {
	hasher.suffix = @"sW" ;
	NSString* genPass = [hasher generatePasswordWithMasterPassword:@"hello" Url:@"google.com" Username:@"james"] ;
	STAssertTrue([genPass isEqualToString:@"D5XnIracResW"], @"Generated password is wrong! Value \"%@\"", genPass) ;
}

- (void) testWithPrefix {
	hasher.prefix = @"r213" ;
	NSString* genPass = [hasher generatePasswordWithMasterPassword:@"hello" Url:@"google.com" Username:@"james"] ;
	STAssertTrue([genPass isEqualToString:@"r213D5XnIrac"], @"Generated password is wrong! Value \"%@\"", genPass) ;
}

- (void) testWithPrefixAndSuffix {
	hasher.prefix = @"r213" ;
	hasher.suffix = @"sW" ;
	NSString* genPass = [hasher generatePasswordWithMasterPassword:@"hello" Url:@"google.com" Username:@"james"] ;
	STAssertTrue([genPass isEqualToString:@"r213D5XnIrsW"], @"Generated password is wrong! Value \"%@\"", genPass) ;
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
	STAssertTrue([genPass isEqualToString:@"D5XnIrac"], @"Generated password is wrong! Value \"%@\"", genPass) ;
	hasher.maxLen = 2 ;
	genPass = [hasher generatePasswordWithMasterPassword:@"hello" Url:@"google.com" Username:@"james"] ;
	STAssertTrue([genPass isEqualToString:@"D5"], @"Generated password is wrong! Value \"%@\"", genPass) ;
	hasher.maxLen = 64 ;
	genPass = [hasher generatePasswordWithMasterPassword:@"hello" Url:@"google.com" Username:@"james"] ;
	STAssertTrue([genPass isEqualToString:@"D5XnIracRefASbxbPJBDAdRdwedXgkmdr0IAV5Gq7jhoVhx9rKfaNDCO8GkoH1nJ"], @"Generated password is wrong! Value \"%@\"", genPass) ;
	hasher.maxLen = 1024 ; // something thats really really long ...
	genPass = [hasher generatePasswordWithMasterPassword:@"hello" Url:@"google.com" Username:@"james"] ;
	STAssertTrue([genPass isEqualToString:@"D5XnIracRefASbxbPJBDAdRdwedXgkmdr0IAV5Gq7jhoVhx9rKfaNDCO8GkoH1nJ0lvUu1jh4cHVbojCmbtdu0BonwvFq7g3m6aw5FwidHCFOQBempZ6V5AyCreNNnHDGAMyZtQQV4FPXTKy3NGrlALtkohGvkifexX9zkh6vPQocs618QgmFFhhzE5JBiEUxgQjpjhcWrmOYRCOAFy0qWM3D2WTDNLAxhcYUxwQU3mUG9RMJgTfdTjqVJmqtO8T40n9C8UnkgjKEwib6gbQemR0nkkXvaX0jAEXeOePsDvtD3XW3KvhD3LsqHdqW90FAQKTHBDfwZGSq9H3FhPwNAjDUZcueAagahlJFw3ZtYHq8OODMMxr4DYzjLXWchCu1C4iYc1GuU9guBgbmAfs0Lu3SaxlzCt0mzsvpLNXYj7vzHNaIrO7csj2H30sjjCR3ftBRqc7786UB5IkMQ31WdaV99NmlzZadfUdKiMlqd2eKnIipN8oaL70J9rUuLquBK1QI0xl5eRRzmoTD7bEb1QBQsmvHs5s5DGBtD6VtUofEq4LTyaLnj6aAr2zsJl9O0ttgDjCDw5mK9xsCgVLhKPZLOtHPs1cZaSeeWMQ6MpStbQBPP3gL16nzkPTK0mcDPVq3xRaOmeif7VpBYeR2UdORrJU9Y4Lh20DL4IkdKO2OL6NFaa5M31yfzEJVxMmrJpKmzHq8WAZBOsC2AdInWD0KGA3PwKM3Jj0JTua2wlSUJJC8AAYKe6JQen0xAgHtLl3qYmK9VUyefkOIbjxRtSvl19oPN4lE0QzH6CX1kUnhsC423ajXNH9eJ7EHUeTQioduT8WFi1KppHJib33t8eQvaNBBAkpE2WU6w4Q9AQQhihdAiwRuFpN6YIKmOkEtKY1XdoHcoeVFXIed6yXUKNWA393cI5L7Fu6PZp33Tx8DSxRAQV3kUJTdbkwT9YWuhD7ixAEA9a7I8DFxnZWY6afO0dZZwTWvKS08YsT7Bsz0WUeWkMIm53fDudahrl7"], @"Generated password is wrong! Value \"%@\"", genPass) ;
}

- (void) testLeetBeforeLevel3 {
	hasher.leetLevel = 3 ;
	hasher.leetSpeak = LEET_BEFORE ;
	hasher.characters = @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789`~!@#$%^&*()_-+={}|[]\\:\";'<>?,./";
	NSString* genPass = [hasher generatePasswordWithMasterPassword:@"hello" Url:@"google.com" Username:@""] ;
	STAssertTrue([genPass isEqualToString:@"B!u<qc(:!0NJ"], @"Generated password is wrong! Value \"%@\"", genPass) ;
}

- (void) testLeetAfterLevel7 {
	hasher.leetLevel = 7 ;
	hasher.leetSpeak = LEET_AFTER ;
	NSString* genPass = [hasher generatePasswordWithMasterPassword:@"hello" Url:@"google.com" Username:@""] ;
	STAssertTrue([genPass isEqualToString:@"6|=><279|=\\/"], @"Generated password is wrong! Value \"%@\"", genPass) ;
}

- (void) testLeetBothLevel9 {
	hasher.leetLevel = 9 ;
	hasher.leetSpeak = LEET_BOTH ;
	NSString* genPass = [hasher generatePasswordWithMasterPassword:@"hello" Url:@"google.com" Username:@""] ;
	STAssertTrue([genPass isEqualToString:@"!\\/(,)!\\^/!/"], @"Generated password is wrong! Value \"%@\"", genPass) ;
}


@end
