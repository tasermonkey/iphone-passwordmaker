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

#include "hash_type_enum.h"
#include <CommonCrypto/CommonDigest.h> 

unsigned char* hmac_sha1( const char* text, CC_LONG len, const char* key, CC_LONG keylen, unsigned char* md) ;
unsigned char* hmac_sha256( const char* text, CC_LONG len, const char* key, CC_LONG keylen, unsigned char* md) ;
unsigned char* hmac_md5( const char* text, CC_LONG len, const char* key, CC_LONG keylen, unsigned char* md) ;
unsigned char* hmac_md4( const char* text, CC_LONG len, const char* key, CC_LONG keylen, unsigned char* md) ;
unsigned char* hmac_ripemd160( const char* text, CC_LONG len, const char* key, CC_LONG keylen, unsigned char* md) ;