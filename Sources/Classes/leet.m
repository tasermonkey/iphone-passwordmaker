/**
 * PasswordMaker - Creates and manages passwords
 * Copyright (C) 2005 Eric H. Jung and LeahScape, Inc.
 * http://passwordmaker.org/
 * grimholtz@yahoo.com
 *
 * This library is free software; you can redistribute it and/or modify it
 * under the terms of the GNU Lesser General Public License as published by
 * the Free Software Foundation; either version 2.1 of the License, or (at
 * your option) any later version.
 *
 * This library is distributed in the hope that it will be useful, but WITHOUT
 * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
 * FITNESSFOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License
 * for more details.
 *
 * You should have received a copy of the GNU Lesser General Public License
 * along with this library; if not, write to the Free Software Foundation,
 * Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
 * 
 * Written by Miquel Burns <miquelfire@gmail.com> and Eric H. Jung
 * Modified by James Stapleton<jstaplet@tasermonkeys.com> for easy use in objective-c
 */

#import "leet.h"

// Unless we make an Array class, we can only do this with
static NSString* levels[][26] = {
	{@"4", @"b", @"c", @"d", @"3", @"f", @"g", @"h", @"i", @"j", @"k", @"1",
		@"m", @"n", @"0", @"p", @"9", @"r", @"s", @"7", @"u", @"v", @"w", @"x",
		@"y", @"z"},
	{@"4", @"b", @"c", @"d", @"3", @"f", @"g", @"h", @"1", @"j", @"k", @"1",
		@"m", @"n", @"0", @"p", @"9", @"r", @"5", @"7", @"u", @"v", @"w", @"x",
		@"y", @"2"},
	{@"4", @"8", @"c", @"d", @"3", @"f", @"6", @"h", @"'", @"j", @"k", @"1",
		@"m", @"n", @"0", @"p", @"9", @"r", @"5", @"7", @"u", @"v", @"w", @"x",
		@"'/", @"2"},
	{@"@", @"8", @"c", @"d", @"3", @"f", @"6", @"h", @"'", @"j", @"k", @"1",
		@"m", @"n", @"0", @"p", @"9", @"r", @"5", @"7", @"u", @"v", @"w", @"x",
		@"'/", @"2"},
	{@"@", @"|3", @"c", @"d", @"3", @"f", @"6", @"#", @"!", @"7", @"|<", @"1",
		@"m", @"n", @"0", @"|>", @"9", @"|2", @"$", @"7", @"u", @"\\/", @"w",
		@"x", @"'/", @"2"},
	{@"@", @"|3", @"c", @"|)", @"&", @"|=", @"6", @"#", @"!", @",|", @"|<",
		@"1", @"m", @"n", @"0", @"|>", @"9", @"|2", @"$", @"7", @"u", @"\\/",
		@"w", @"x", @"'/", @"2"},
	{@"@", @"|3", @"[", @"|)", @"&", @"|=", @"6", @"#", @"!", @",|", @"|<",
		@"1", @"^^", @"^/", @"0", @"|*", @"9", @"|2", @"5", @"7", @"(_)", @"\\/",
		@"\\/\\/", @"><", @"'/", @"2"},
	{@"@", @"8", @"(", @"|)", @"&", @"|=", @"6", @"|-|", @"!", @"_|", @"|(",
		@"1", @"|\\/|", @"|\\|", @"()", @"|>", @"(,)", @"|2", @"$", @"|", @"|_|",
		@"\\/", @"\\^/", @")(", @"'/", @"\"/_"},
	{@"@", @"8", @"(", @"|)", @"&", @"|=", @"6", @"|-|", @"!", @"_|", @"|{",
		@"|_", @"/\\/\\", @"|\\|", @"()", @"|>", @"(,)", @"|2", @"$", @"|",
		@"|_|", @"\\/", @"\\^/", @")(", @"'/", @"\"/_"}
};

/**
 * Convert the string in _message_ to l33t-speak
 * using the l33t level specified by _leetLevel_.
 * l33t levels are 0-8 with 0 being the simplest
 * form of l33t-speak and 8 being the most complex.
 *
 * Note that _message_ is converted to lower-case if
 * the l33t conversion is performed. To maintain
 * backwards compatibility, do not change this function
 * so it uses mixed-case.
 *
 * Using a _leetLevel_ <= 0 results in the original message
 * being returned.
 *
 */
NSString* leetConvert(int level, NSString* message)
{
	if (level > -1 && level < 9) {
		NSInteger multipler = ( level > 6 ? 3 : level >= 5 ? 2 : 1 ) ;
		NSMutableString* ret = [[NSMutableString alloc] initWithCapacity:[message length]*multipler] ;
		NSString* string = [message lowercaseString] ;
		NSInteger stringlen = [message length] ;
		for ( NSInteger index = 0; index < stringlen; index++ ) {
			unichar i = [string characterAtIndex:index] ;
			if (i >= 'a' && i <= 'z') {
				[ret appendString:levels[level][i - 'a']];
			} else {
				[ret appendFormat:@"%c", i];
			}
		}
		NSString* toret = [NSString stringWithString:ret] ;
		[ret release] ;
		return toret ;
	}
	return message;
}
