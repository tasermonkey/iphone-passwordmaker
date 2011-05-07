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
#include "HMacer.h"
#include "stddef.h"
#include <string.h>
#include "ripemd.h"

int ripemd160_init_apple(struct ripemd_ctx *ctx){
	ripemd160_init(ctx) ;
	return 1 ;
}

int ripemd_update_apple(struct ripemd_ctx *ctx, const void *buffer, mutils_word32 len){
	ripemd_update(ctx, buffer, len) ;
	return 1 ;
}

int ripemd_final_apple(unsigned char *s, struct ripemd_ctx *ctx) {
	ripemd_final(ctx) ;
	ripemd_digest(ctx, (mutils_word8*)s) ;
	return 1 ;
}

template <typename ContextT >
struct HashTraits {
	typedef ContextT Context ;
	typedef  int (*InitFunction)(ContextT*) ;
	typedef  int (*UpdateFunction)(ContextT*, const void* data, CC_LONG len)  ; 
	typedef  int (*FinalFunction)(unsigned char* md, ContextT* len) ; 
	
	static InitFunction Init ;
	static UpdateFunction Update ;
	static FinalFunction Final ;
	static const int digest_size ;
	static const int block_size ;
} ;

template<> HashTraits< CC_MD4_CTX>::InitFunction HashTraits< CC_MD4_CTX >::Init = &CC_MD4_Init ;
template<> HashTraits< CC_MD4_CTX>::UpdateFunction HashTraits< CC_MD4_CTX >::Update  = &CC_MD4_Update ;
template<> HashTraits< CC_MD4_CTX>::FinalFunction HashTraits< CC_MD4_CTX >::Final  = &CC_MD4_Final ;
template<> const int HashTraits< CC_MD4_CTX >::digest_size = CC_MD4_DIGEST_LENGTH ;
template<> const int HashTraits< CC_MD4_CTX >::block_size = CC_MD4_BLOCK_BYTES ;



template<> HashTraits< CC_MD5_CTX>::InitFunction HashTraits< CC_MD5_CTX >::Init = &CC_MD5_Init ;
template<> HashTraits< CC_MD5_CTX>::UpdateFunction HashTraits< CC_MD5_CTX >::Update  = &CC_MD5_Update ;
template<> HashTraits< CC_MD5_CTX>::FinalFunction HashTraits< CC_MD5_CTX >::Final  = &CC_MD5_Final ;
template<> const int HashTraits< CC_MD5_CTX >::digest_size = CC_MD5_DIGEST_LENGTH ;
template<> const int HashTraits< CC_MD5_CTX >::block_size = CC_MD5_BLOCK_BYTES ;



template<> HashTraits< CC_SHA1_CTX>::InitFunction HashTraits< CC_SHA1_CTX >::Init = &CC_SHA1_Init ;
template<> HashTraits< CC_SHA1_CTX>::UpdateFunction HashTraits< CC_SHA1_CTX >::Update  = &CC_SHA1_Update ;
template<> HashTraits< CC_SHA1_CTX>::FinalFunction HashTraits< CC_SHA1_CTX >::Final  = &CC_SHA1_Final ;
template<> const int HashTraits< CC_SHA1_CTX >::digest_size = CC_SHA1_DIGEST_LENGTH ;
template<> const int HashTraits< CC_SHA1_CTX >::block_size = CC_SHA1_BLOCK_BYTES ;


template<> HashTraits< CC_SHA256_CTX>::InitFunction HashTraits< CC_SHA256_CTX >::Init = &CC_SHA256_Init ;
template<> HashTraits< CC_SHA256_CTX>::UpdateFunction HashTraits< CC_SHA256_CTX >::Update  = &CC_SHA256_Update ;
template<> HashTraits< CC_SHA256_CTX>::FinalFunction HashTraits< CC_SHA256_CTX >::Final  = &CC_SHA256_Final ;
template<> const int HashTraits< CC_SHA256_CTX >::digest_size = CC_SHA256_DIGEST_LENGTH ;
template<> const int HashTraits< CC_SHA256_CTX >::block_size = CC_SHA256_BLOCK_BYTES ;


template<> HashTraits< RIPEMD_CTX>::InitFunction HashTraits< RIPEMD_CTX >::Init = &ripemd160_init_apple ;
template<> HashTraits< RIPEMD_CTX>::UpdateFunction HashTraits< RIPEMD_CTX >::Update  = &ripemd_update_apple ;
template<> HashTraits< RIPEMD_CTX>::FinalFunction HashTraits< RIPEMD_CTX >::Final  = &ripemd_final_apple  ;
template<> const int HashTraits< RIPEMD_CTX >::digest_size = RIPEMD160_DIGESTSIZE ;
template<> const int HashTraits< RIPEMD_CTX >::block_size = RIPEMD_DATASIZE ;



template< typename Funs >
unsigned char* hmac_general(const unsigned char *inText, CC_LONG inTextLength, 
							unsigned char* inKey, CC_LONG inKeyLength, unsigned char *outDigest )
{
	/*
	 based on this: (from: http://en.wikipedia.org/wiki/HMAC )
	 function hmac (key, message)
	 if (length(key) > blocksize) then
	 key = hash(key) // keys longer than blocksize are shortened
	 else if (length(key) < blocksize) then
	 key = key ∥ zeroes(blocksize - length(key)) // keys shorter than blocksize are zero-padded
	 end if
	 
	 opad = [0x5c * blocksize] ⊕ key // Where blocksize is that of the underlying hash function
	 ipad = [0x36 * blocksize] ⊕ key // Where ⊕ is exclusive or (XOR)
	 
	 return hash(opad ∥ hash(ipad ∥ message)) // Where ∥ is concatenation
	 end function
	*/
	
	const size_t B = Funs::block_size ;
	const size_t L = Funs::digest_size;
	
	typename Funs::Context theContext ;
	unsigned char k_ipad[B + 1]; /* inner padding - key XORd with ipad */
	unsigned char k_opad[B + 1]; /* outer padding - key XORd with opad */
	
	/* if key is longer than BlockSize of bytes reset it to key=hashFun(key) */
	if (inKeyLength > B)
	{
		Funs::Init(&theContext);
		Funs::Update(&theContext, inKey, inKeyLength);
		Funs::Final(inKey, &theContext);
		inKeyLength = L;
	}
	
	/* start out by storing key in pads */
	memset(k_ipad, 0, sizeof k_ipad);
	memset(k_opad, 0, sizeof k_opad);
	memcpy(k_ipad, inKey, inKeyLength); // Since above the memory is zeroed this will zero padd
	memcpy(k_opad, inKey, inKeyLength);
	
	/* XOR key with ipad and opad values */
	int i;
	for (i = 0; i < B; i++)
	{
		k_ipad[i] ^= 0x36; 
		k_opad[i] ^= 0x5c;
	}
	
	/*
	 * perform inner Hash - hash(ipad | text )
	 */ 
	Funs::Init(&theContext);
	Funs::Update(&theContext, k_ipad, B);
	Funs::Update(&theContext, (unsigned char *)inText, inTextLength);
	Funs::Final((unsigned char *)outDigest, &theContext);
	
	/*
	 * perform outer Hash - hash(opad | text )
	 */
	Funs::Init(&theContext);
	Funs::Update(&theContext, k_opad, B);
	Funs::Update(&theContext, outDigest, L);
	Funs::Final(outDigest, &theContext);
	return outDigest ;
}
extern "C" {
	unsigned char* hmac_sha1( const unsigned char *inText, CC_LONG inTextLength, unsigned char* inKey, CC_LONG inKeyLength, unsigned char *outDigest ) {
		return hmac_general< HashTraits<CC_SHA1_CTX> >(inText, inTextLength, inKey, inKeyLength, outDigest ) ;
	}
	
	unsigned char* hmac_sha256( const unsigned char *inText, CC_LONG inTextLength, unsigned char* inKey, CC_LONG inKeyLength, unsigned char *outDigest ) {
		return hmac_general< HashTraits<CC_SHA256_CTX> >(inText, inTextLength, inKey, inKeyLength, outDigest ) ;
	}
	
	unsigned char* hmac_md5( const unsigned char *inText, CC_LONG inTextLength, unsigned char* inKey, CC_LONG inKeyLength, unsigned char *outDigest ) {
		return hmac_general< HashTraits<CC_MD5_CTX> >(inText, inTextLength, inKey, inKeyLength, outDigest ) ;
	}
	
	unsigned char* hmac_md4( const unsigned char *inText, CC_LONG inTextLength, unsigned char* inKey, CC_LONG inKeyLength, unsigned char *outDigest ) {
		return hmac_general< HashTraits<CC_MD4_CTX> >(inText, inTextLength, inKey, inKeyLength, outDigest ) ;
	}
	
	unsigned char* hmac_ripemd160( const unsigned char *inText, CC_LONG inTextLength, unsigned char* inKey, CC_LONG inKeyLength, unsigned char *outDigest ) {
		return hmac_general< HashTraits<RIPEMD_CTX> >(inText, inTextLength, inKey, inKeyLength, outDigest ) ;		
	}
}