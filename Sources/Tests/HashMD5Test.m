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


#import "HashMD5Test.h"
#import "Hasher.h"

@implementation HashMD5Tests
- (void) testBasic {
	Hasher* hasher = [[Hasher alloc] init] ;
	NSString* genPass = [hasher generatePasswordWithMasterPassword:@"hello" Url:@"google.com" Username:@""] ;
	STAssertTrue([genPass isEqualToString:@"U9HGvsEd0JfP"], @"Generated password is wrong! Value \"%@\"", genPass) ;
}

- (void) testWithUsername {
	Hasher* hasher = [[Hasher alloc] init] ;
	NSString* genPass = [hasher generatePasswordWithMasterPassword:@"hello" Url:@"google.com" Username:@"james"] ;
	STAssertTrue([genPass isEqualToString:@"CMlyOT11tXAi"], @"Generated password is wrong! Value \"%@\"", genPass) ;
}

- (void) testWithUsernameAndModifier {
	Hasher* hasher = [[Hasher alloc] init] ;
	hasher.counter = @"aaa" ;
	NSString* genPass = [hasher generatePasswordWithMasterPassword:@"hello" Url:@"google.com" Username:@"james"] ;
	STAssertTrue([genPass isEqualToString:@"CeqlaYYFF184"], @"Generated password is wrong! Value \"%@\"", genPass) ;
}

- (void) testWithSuffix {
	Hasher* hasher = [[Hasher alloc] init] ;
	hasher.suffix = @"sW" ;
	NSString* genPass = [hasher generatePasswordWithMasterPassword:@"hello" Url:@"google.com" Username:@"james"] ;
	STAssertTrue([genPass isEqualToString:@"CMlyOT11tXsW"], @"Generated password is wrong! Value \"%@\"", genPass) ;
}

- (void) testWithPrefix {
	Hasher* hasher = [[Hasher alloc] init] ;
	hasher.prefix = @"r213" ;
	NSString* genPass = [hasher generatePasswordWithMasterPassword:@"hello" Url:@"google.com" Username:@"james"] ;
	STAssertTrue([genPass isEqualToString:@"r213CMlyOT11"], @"Generated password is wrong! Value \"%@\"", genPass) ;
}

- (void) testWithPrefixAndSuffix {
	Hasher* hasher = [[Hasher alloc] init] ;
	hasher.prefix = @"r213" ;
	hasher.suffix = @"sW" ;
	NSString* genPass = [hasher generatePasswordWithMasterPassword:@"hello" Url:@"google.com" Username:@"james"] ;
	STAssertTrue([genPass isEqualToString:@"r213CMlyOTsW"], @"Generated password is wrong! Value \"%@\"", genPass) ;
}

- (void) testWithPrefixAndSuffixComplete {
	Hasher* hasher = [[Hasher alloc] init] ;
	// One more charector than maxLen
	hasher.maxLen = 12 ;
	hasher.prefix = @"r213Ty2" ; 
	hasher.suffix = @"sWwww3" ;
	NSString* genPass = [hasher generatePasswordWithMasterPassword:@"hello" Url:@"google.com" Username:@"james"] ;
	STAssertTrue([genPass isEqualToString:@"r213TysWwww3"], @"Generated password is wrong! Value \"%@\"", genPass) ;
}

- (void) testMaxLen {
	Hasher* hasher = [[Hasher alloc] init] ;
	// One more charector than maxLen
	hasher.maxLen = 8 ;
	NSString* genPass = [hasher generatePasswordWithMasterPassword:@"hello" Url:@"google.com" Username:@"james"] ;
	STAssertTrue([genPass isEqualToString:@"CMlyOT11"], @"Generated password is wrong! Value \"%@\"", genPass) ;
	hasher.maxLen = 2 ;
	genPass = [hasher generatePasswordWithMasterPassword:@"hello" Url:@"google.com" Username:@"james"] ;
	STAssertTrue([genPass isEqualToString:@"CM"], @"Generated password is wrong! Value \"%@\"", genPass) ;
	hasher.maxLen = 64 ;
	genPass = [hasher generatePasswordWithMasterPassword:@"hello" Url:@"google.com" Username:@"james"] ;
	STAssertTrue([genPass isEqualToString:@"CMlyOT11tXAis3JXsJcxiVBgxFgEcLycnQ0hDLfX5SCaD683GGR3M4upIxxZ0MYx"], @"Generated password is wrong! Value \"%@\"", genPass) ;
	hasher.maxLen = 1024 ; // something thats really really long ...
	genPass = [hasher generatePasswordWithMasterPassword:@"hello" Url:@"google.com" Username:@"james"] ;
	STAssertTrue([genPass isEqualToString:@"CMlyOT11tXAis3JXsJcxiVBgxFgEcLycnQ0hDLfX5SCaD683GGR3M4upIxxZ0MYxrbDPzgAJfOGM6N33h3ujXM9eG7963t7KVUIPwXhIuQX5POGPn3fTTaGFn24AlY0KQMQGDdbKiMhHsoCHSIXLMTvJcFGBpfQauuqd66fbclMyY7ftB9CkBd8YCMZt1KtWg8E48hEJUxazdG0ZuZLFzmEFVYFE1YLu6MfNBwWQ4COd6QdrbCLhC82tcG2e0yNNYFqdZo8Cp8r2g0eaut63PBDCvadHLFxa8fJMjLTQPGXD8Yw46U2HNIQdOZcrEp8TDvbQawKD6EvZ3Q2WKAPzCjhJe9eUpm0cX0yJLD08AbRBI96TtrzOHfMDLboO9jkI1gMcCAnYiZCy6Dewjsufu8QrUGGJMzCWCjXixb5dWsclFGH3nLuvRixvfHSVay12HJXRkk3wxWFEwVu7zjayEvaoTfkbrdeyIBcC5TwJ4HEauLWTCQ6L69lGTnNBjsnpI5dN5OSG93MMFHJ3OyKTdaF9viPrQ978RxBHgYOhmOG9380uGFVgad00QEIsSJj9rrBqmVLX8CTx64DGyH52c5YtRMyJq4tW2gIAdGfynAuC7uV2jd90FXnZBOXFpfejzhL7H2m9BKRG2CHTaEJqsl9vejqPEOV5MLbQx5lBWy1G5HJ74u1NWdUljrhsGDcvdT87bWJaoDCfmDmrM79C4yzBft6cBllDbsQdMdv4iF70rCVHTmwtEAjjzLbD2RmFpUq0MwOMHsMiAgF4YvTZuCp4fCEQy09S3EJcQUytTBQGNjbzEta1CJUugJ3UMejbCD8iK1a7wEprtoeIP6l9cn7FVdqO6SBI5B6noORq8WW9sCDIvkgYmFTETj1c7wZQY0fE2fP0eREMRA1gZ7Yiz8yXVE83j7MYBL64D14fVQuH7E8GwP5j3pCzUiCpOropvAyuiEJi8Wd7u7Y1awCn0CMjnxeDa7YnhhTGcToFk1zSXeJAFGNRSeKDirhCUAD5"], @"Generated password is wrong! Value \"%@\"", genPass) ;
}

- (void) testLeetBeforeLevel3 {
	Hasher* hasher = [[Hasher alloc] init] ;
	hasher.leetLevel = 3 ;
	hasher.leetSpeak = LEET_BEFORE ;
	hasher.characters = @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789`~!@#$%^&*()_-+={}|[]\\:\";'<>?,./";
	NSString* genPass = [hasher generatePasswordWithMasterPassword:@"hello" Url:@"google.com" Username:@""] ;
	STAssertTrue([genPass isEqualToString:@"IQ`iA[}E-/pB"], @"Generated password is wrong! Value \"%@\"", genPass) ;
}

- (void) testLeetAfterLevel7 {
	Hasher* hasher = [[Hasher alloc] init] ;
	hasher.leetLevel = 7 ;
	hasher.leetSpeak = LEET_AFTER ;
	NSString* genPass = [hasher generatePasswordWithMasterPassword:@"hello" Url:@"google.com" Username:@""] ;
	STAssertTrue([genPass isEqualToString:@"(_)9#6\\/5&|)"], @"Generated password is wrong! Value \"%@\"", genPass) ;
}

- (void) testLeetBothLevel9 {
	Hasher* hasher = [[Hasher alloc] init] ;
	hasher.leetLevel = 9 ;
	hasher.leetSpeak = LEET_BOTH ;
	NSString* genPass = [hasher generatePasswordWithMasterPassword:@"hello" Url:@"google.com" Username:@""] ;
	STAssertTrue([genPass isEqualToString:@"&'/|\\||>\\/(,"], @"Generated password is wrong! Value \"%@\"", genPass) ;
}

@end