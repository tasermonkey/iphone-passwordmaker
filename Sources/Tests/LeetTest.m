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

#import "LeetTest.h"
#import "leet.h"

@implementation LeetTest
- (void) setUp {
}

- (void) tearDown {
}

- (void) testBadLeetLevel {
	NSString* result = leetConvert(-1, @"ApPles") ;
	STAssertTrue([result isEqualToString:@"ApPles"], @"Generated value is wrong! Value \"%@\"", result) ;	
	result = leetConvert(9, @"ApPles") ;
	STAssertTrue([result isEqualToString:@"ApPles"], @"Generated value is wrong! Value \"%@\"", result) ;	
	result = leetConvert(15, @"ApPles") ;
	STAssertTrue([result isEqualToString:@"ApPles"], @"Generated value is wrong! Value \"%@\"", result) ;	
}

- (void) testLeet0 {
	NSString* result = leetConvert(0, @"ApPles") ;
	STAssertTrue([result isEqualToString:@"4pp13s"], @"Generated value is wrong! Value \"%@\"", result) ;
}

- (void) testLeet1 {
	NSString* result = leetConvert(1, @"ApPles") ;
	STAssertTrue([result isEqualToString:@"4pp135"], @"Generated value is wrong! Value \"%@\"", result) ;
	result = leetConvert(1, @"Italy") ;
	STAssertTrue([result isEqualToString:@"1741y"], @"Generated value is wrong! Value \"%@\"", result) ;	
}

- (void) testLeet2 {
	NSString* result = leetConvert(2, @"ApPles") ;
	STAssertTrue([result isEqualToString:@"4pp135"], @"Generated value is wrong! Value \"%@\"", result) ;
	result = leetConvert(2, @"Italy") ;
	STAssertTrue([result isEqualToString:@"'741'/"], @"Generated value is wrong! Value \"%@\"", result) ;	
}

- (void) testLeet3 {
	NSString* result = leetConvert(3, @"ApPles") ;
	STAssertTrue([result isEqualToString:@"@pp135"], @"Generated value is wrong! Value \"%@\"", result) ;
	result = leetConvert(3, @"Italy") ;
	STAssertTrue([result isEqualToString:@"'7@1'/"], @"Generated value is wrong! Value \"%@\"", result) ;	
}

- (void) testLeet4 {
	NSString* result = leetConvert(4, @"ApPles") ;
	STAssertTrue([result isEqualToString:@"@|>|>13$"], @"Generated value is wrong! Value \"%@\"", result) ;
	result = leetConvert(4, @"Italy") ;
	STAssertTrue([result isEqualToString:@"!7@1'/"], @"Generated value is wrong! Value \"%@\"", result) ;	
}

- (void) testLeet5 {
	NSString* result = leetConvert(5, @"ApPles") ;
	STAssertTrue([result isEqualToString:@"@|>|>1&$"], @"Generated value is wrong! Value \"%@\"", result) ;
	result = leetConvert(5, @"Italy") ;
	STAssertTrue([result isEqualToString:@"!7@1'/"], @"Generated value is wrong! Value \"%@\"", result) ;	
}

- (void) testLeet6 {
	NSString* result = leetConvert(6, @"ApPles") ;
	STAssertTrue([result isEqualToString:@"@|*|*1&5"], @"Generated value is wrong! Value \"%@\"", result) ;
	result = leetConvert(6, @"Italy") ;
	STAssertTrue([result isEqualToString:@"!7@1'/"], @"Generated value is wrong! Value \"%@\"", result) ;	
}

- (void) testLeet7 {
	NSString* result = leetConvert(7, @"ApPles") ;
	STAssertTrue([result isEqualToString:@"@|>|>1&$"], @"Generated value is wrong! Value \"%@\"", result) ;
	result = leetConvert(7, @"Italy") ;
	STAssertTrue([result isEqualToString:@"!|@1'/"], @"Generated value is wrong! Value \"%@\"", result) ;	
}

- (void) testLeet8 {
	NSString* result = leetConvert(8, @"ApPles") ;
	STAssertTrue([result isEqualToString:@"@|>|>|_&$"], @"Generated value is wrong! Value \"%@\"", result) ;
	result = leetConvert(8, @"Italy") ;
	STAssertTrue([result isEqualToString:@"!|@|_'/"], @"Generated value is wrong! Value \"%@\"", result) ;	
}

- (void) testLeetWithSpecialChars {
	NSString* result = leetConvert(2, @"ApP3les") ;
	STAssertTrue([result isEqualToString:@"4pp3135"], @"Generated value is wrong! Value \"%@\"", result) ;
	result = leetConvert(2, @"459234") ;
	STAssertTrue([result isEqualToString:@"459234"], @"Generated value is wrong! Value \"%@\"", result) ;
	result = leetConvert(2, @"ApP3l{%es") ;
	STAssertTrue([result isEqualToString:@"4pp31{%35"], @"Generated value is wrong! Value \"%@\"", result) ;
	
}

@end