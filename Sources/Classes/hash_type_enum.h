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

enum HASHTYPE { HASHTYPE_MD5, HASHTYPE_SHA1, HASHTYPE_SHA256, HASHTYPE_MD4, 
	            HASHTYPE_RIPEMD160,
	            HASHTYPE_HMAC_MD5, HASHTYPE_HMAC_SHA1, HASHTYPE_HMAC_SHA256, HASHTYPE_HMAC_MD4,
	            HASHTYPE_HMAC_RIPEMD160
} ;

enum leetType {
	LEET_NONE,
	LEET_BEFORE,
	LEET_AFTER,
	LEET_BOTH
};