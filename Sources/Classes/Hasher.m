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

#include <stdlib.h>
#include <math.h>
#include <CommonCrypto/CommonDigest.h> 
#import "Hasher.h"
#import "leet.h"
#include "HMacer.h"
#include "ripemd.h"

@implementation Hasher
@synthesize profileName, counter, prefix, suffix, hashAlgo, maxLen ;
@synthesize characters, leetSpeak, leetLevel ;
- (id) init {
	if ( self = [super init] ) {
		self.profileName = @"" ;
		self.counter = @"" ;
		self.prefix = @"" ;
		self.suffix = @"" ;
		self.hashAlgo = @"MD5" ;
		self.maxLen = 12 ;
		self.characters = @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789" ;
		self.leetLevel = 0 ;
		self.leetSpeak = LEET_NONE ;
		isHmac = NO ;
	}
	return self ;
}

- (NSArray*) allHashAlgos {
	return [NSArray arrayWithObjects:@"MD5", @"HMAC-MD5",@"SHA1", @"HMAC-SHA1", @"SHA256", 
			@"HMAC-SHA256", @"MD4", @"HMAC-MD4", @"RIPEMD-160", @"HMAC-RIPEMD-160", nil] ;
}

- (void) setHashAlgo:(NSString *)algoStr {
	isHmac = NO ;
	if ( [algoStr isEqualToString:@"MD5"]  ) {
		algo = HASHTYPE_MD5 ;
	} else if ( [algoStr isEqualToString:@"SHA1"] ) {
		algo = HASHTYPE_SHA1 ;
	} else if ( [algoStr isEqualToString:@"SHA256"] ) {
		algo = HASHTYPE_SHA256 ;
	} else if ( [algoStr isEqualToString:@"MD4"] ) {
		algo = HASHTYPE_MD4 ;
	} else if ( [algoStr isEqualToString:@"HMAC-MD5"] ) {
		algo = HASHTYPE_HMAC_MD5 ;
		isHmac = YES ;
	} else if ( [algoStr isEqualToString:@"HMAC-SHA1"] ) {
		algo = HASHTYPE_HMAC_SHA1 ;
		isHmac = YES ;
	} else if ( [algoStr isEqualToString:@"HMAC-SHA256"] ) {
		algo = HASHTYPE_HMAC_SHA256 ;
		isHmac = YES ;
	} else if ( [algoStr isEqualToString:@"HMAC-MD4"] ) {
		algo = HASHTYPE_HMAC_MD4 ;
		isHmac = YES ;
	} else if ( [algoStr isEqualToString:@"RIPEMD-160"] ) {
		algo = HASHTYPE_RIPEMD160 ;
	} else if ( [algoStr isEqualToString:@"HMAC-RIPEMD-160"] ) {
		algo = HASHTYPE_HMAC_RIPEMD160 ;	
		isHmac = YES;
	} else {
		return ;
	}
	hashAlgo = [algoStr retain];
}

-(NSString*) generatePassword:(NSString*)key withData:(NSString*)text {
	if ( isHmac == NO ) {
		key = [key stringByAppendingString:text] ;
		return [self hashText:key WithAlgo:algo AndCharacterSet:characters] ;
	} else {
		return [self hMacHashKey:key Text:text WithAlgo:algo AndCharacterSet:characters] ; 
	}
}

- (NSString*) generatePasswordWithMasterPassword:(NSString*)masterPass 
											 Url:(NSString*)url Username:(NSString*)user {
	NSString* password = @"" ;
	NSInteger count = 0 ;
	NSInteger leetLev = self.leetLevel - 1 ;
	NSString* data = [NSString stringWithFormat:@"%@%@%@", url, user, counter] ;
	
	if ( leetSpeak == LEET_BEFORE || leetSpeak == LEET_BOTH ) {
		masterPass = leetConvert(leetLev, masterPass ) ;
		data = leetConvert(leetLev, data ) ;
	}
	
	while ( [password length] < maxLen ) {
		NSString* buildPass = nil ;
		if ( count == 0 ) {
			buildPass = [self generatePassword:masterPass withData:data] ;
		} else {
			buildPass = [self generatePassword:[masterPass stringByAppendingFormat:@"\n%d",count]
									  withData:data] ;
		}
		password = [password stringByAppendingString:buildPass] ;
		count++ ;
	}
	
	if ( leetSpeak == LEET_AFTER || leetSpeak == LEET_BOTH ) {
		password = leetConvert( leetLev, password ) ;
	}
	
	if ( [prefix length] > 0 ) {
		password = [prefix stringByAppendingString:password] ;
	} 
	if ( [suffix length] > 0 ) {
		NSRange rng ;
		rng.location = maxLen - [suffix length] ;
		rng.length = [suffix length] ;
		password = [password stringByReplacingCharactersInRange:rng withString:suffix] ;
	}
	if ( [password length] > maxLen ) {
		password = [password substringToIndex:maxLen] ;
	}
	return password ;
}

- (NSString*) hashText:(NSString*)text WithAlgo:(enum HASHTYPE)hash_algo
	   AndCharacterSet:(NSString*)charSet {

	const char *cStr = [text UTF8String]; /* since some characters are more than 1 char wide  */
	CC_LONG cStrLen = strlen(cStr) ;

	if ( algo == HASHTYPE_MD5 ) 
	{	
		unsigned char result[CC_MD5_DIGEST_LENGTH];
		CC_MD5( cStr, cStrLen, result );
		return [Hasher rstr2any:result charSet:charSet length:CC_MD5_DIGEST_LENGTH] ;	
	} else if ( algo == HASHTYPE_SHA1 ) {
		unsigned char result[CC_SHA1_DIGEST_LENGTH];
		CC_SHA1( cStr, cStrLen, result );
		return [Hasher rstr2any:result charSet:charSet length:CC_SHA1_DIGEST_LENGTH] ;
	} else if ( algo == HASHTYPE_SHA256 ) {
		unsigned char result[CC_SHA256_DIGEST_LENGTH];
		CC_SHA256( cStr, cStrLen, result );
		return [Hasher rstr2any:result charSet:charSet length:CC_SHA256_DIGEST_LENGTH] ;		
	} else if ( algo == HASHTYPE_MD4 ) {
		unsigned char result[CC_MD4_DIGEST_LENGTH];
		CC_MD4( cStr, cStrLen, result );
		return [Hasher rstr2any:result charSet:charSet length:CC_MD4_DIGEST_LENGTH] ;
	} else if ( algo == HASHTYPE_RIPEMD160 ) {
		unsigned char result[RIPEMD160_DIGESTSIZE];
		hash160_ripemd(  cStr, cStrLen, result ) ;
		return [Hasher rstr2any:result charSet:charSet length:RIPEMD160_DIGESTSIZE] ;		 
	} else {
		return @"" ;
	}
}

- (NSString*) hMacHashKey:(NSString*)key Text:(NSString*)text WithAlgo:(enum HASHTYPE)hash_algo
		  AndCharacterSet:(NSString*)charSet {
	const char *cStr = [key UTF8String]; /* since some characters are more than 1 char wide  */
	CC_LONG cStrLen = strlen(cStr) ;
	
	const char *cStrTxt = [text UTF8String]; /* since some characters are more than 1 char wide  */
	CC_LONG cStrTxtLen = strlen(cStrTxt) ;
	
	if ( algo == HASHTYPE_HMAC_MD5 ) {
		unsigned char result[CC_MD5_DIGEST_LENGTH];
		hmac_md5( cStrTxt, cStrTxtLen, cStr, cStrLen, result ) ;
		return [Hasher rstr2any:result charSet:charSet length:CC_MD5_DIGEST_LENGTH] ;		
	} else if ( algo == HASHTYPE_HMAC_SHA1 ) {
		unsigned char result[CC_SHA1_DIGEST_LENGTH];
		hmac_sha1( cStrTxt, cStrTxtLen, cStr, cStrLen, result ) ;
		return [Hasher rstr2any:result charSet:charSet length:CC_SHA1_DIGEST_LENGTH] ;
	} else if ( algo == HASHTYPE_HMAC_SHA256 ) {
		unsigned char result[CC_SHA256_DIGEST_LENGTH];
		hmac_sha256( cStrTxt, cStrTxtLen, cStr, cStrLen, result ) ;
		return [Hasher rstr2any:result charSet:charSet length:CC_SHA256_DIGEST_LENGTH] ;		
	} else if ( algo == HASHTYPE_HMAC_MD4 ) {
		unsigned char result[CC_MD4_DIGEST_LENGTH];
		hmac_md4( cStrTxt, cStrTxtLen, cStr, cStrLen, result ) ;
		return [Hasher rstr2any:result charSet:charSet length:CC_MD4_DIGEST_LENGTH] ;	
	} else if ( algo == HASHTYPE_HMAC_RIPEMD160 ) {		
		unsigned char result[RIPEMD160_DIGESTSIZE];
		hmac_ripemd160( cStrTxt, cStrTxtLen, cStr, cStrLen, result ) ;
 		return [Hasher rstr2any:result charSet:charSet length:RIPEMD160_DIGESTSIZE] ;	
	} else {
		return @"" ;
	}
}


+ (NSString*) rstr2any:(unsigned char *)input charSet:(NSString*)encoding length:(NSInteger)length
{
	int divisor;
	int full_length;
	int *dividend;
	int *remainders;
	int dividend_length;
	// Counter 
	int i, j;
	BOOL trim = YES ;
	// Can't handle odd lengths for input correctly with this function
	if (length % 2) {
		NSLog(@"Odd length blocksize!");
		return @"";
	}
	
	divisor = (int)[encoding length] ;
	dividend_length = (int)ceil((double)length/2);
	dividend = (int*)malloc( sizeof(int) * dividend_length );
	for (i = 0; i < dividend_length; i++)
	{
		dividend[i] = (((int) input[i*2]) << 8)
		| ((int) input[i*2+1]);
	}
	
	full_length = (int)ceil((double)length * 8
							/ (log((double)[encoding length] ) / log((double)2)));
	remainders = (int*)malloc( sizeof(int) * full_length );
	
	if (trim)
	{
		int remainders_count = 0; // for use with trimming zeros method
		while(dividend_length > 0)
		{
			int *quotient;
			int quotient_length = 0;
			int qCounter = 0;
			int x = 0;
			
			quotient = (int*)malloc( sizeof(int) * dividend_length );
			for(i = 0; i < dividend_length; i++)
			{
				int q;
				x = (x << 16) + dividend[i];
				q = (int)floor((double)x / divisor);
				x -= q * divisor;
				if (quotient_length > 0 || q > 0)
				{
					quotient[qCounter++] = q;
					quotient_length++;
				}
			}
			remainders[remainders_count++] = x;
			free( dividend ) ;
			dividend_length = quotient_length;
			dividend = quotient;
		}
		full_length = remainders_count;
	} else {
		for (j = 0; j < full_length; j++)
		{
			int *quotient;
			int quotient_length = 0;
			int qCounter = 0;
			int x = 0;
			
			quotient = (int*)malloc( sizeof(int) * dividend_length );
			for(i = 0; i < dividend_length; i++)
			{
				int q;
				x = (x << 16) + dividend[i];
				q = (int)floor((double)x / divisor);
				x -= q * divisor;
				if (quotient_length > 0 || q > 0)
				{
					quotient[qCounter++] = q;
					quotient_length++;
				}
			}
			remainders[j] = x;
			free(dividend);
			dividend_length = quotient_length;
			dividend = quotient;
		}
	}
	free(dividend);	
	unsigned char* output = (unsigned char*)malloc(sizeof(unsigned char) * full_length + 1) ;
	for (i = full_length - 1; i>=0; i--) {
		output[full_length - i - 1] = [encoding characterAtIndex:remainders[i]] ;
	}
	output[full_length] = '\0' ;

	free(remainders);
	NSString* retVal = [NSString stringWithUTF8String:(char*)output] ;
	free(output);
	return retVal ;
}

- (void) dealloc
{
	[characters release] ;
	[hashAlgo release ] ;
	[suffix release ];
	[prefix release ] ; 
	[counter release] ;
	[profileName release] ;
	[super dealloc];
}

@end
