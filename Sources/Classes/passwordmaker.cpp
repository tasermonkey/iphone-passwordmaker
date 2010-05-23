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
*/

#include "stdafx.h"
#include "passwordmaker.h"
#include "shared/hasher.h"
#include "leet.h"

using namespace std;

char base93Set[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789`~!@#$%^&*()_-+={}|[]\\:\";'<>?,./";

PasswordMaker::PasswordMaker(void)
{
	hasher = new Hasher;
}

PasswordMaker::~PasswordMaker(void)
{
	delete hasher; // Don't what a memory leak
}

bool PasswordMaker::initialized() {
	return hasher->initialized();
}

void PasswordMaker::setPath(string path) {
	if (!hasher->initialized()) {
		delete hasher;
		hasher = new Hasher(path);
	}
}

string PasswordMaker::generatePassword(std::string masterPassword,
	hashType algorithm, bool hmac, bool trim, std::string url, int length,
	std::string characters, leetType useLeet, int leetLevel,
	std::string username, std::string modifier, std::string prefix,
	std::string suffix, bool sha256_bug)
{
	string data, password = "";
	int count = 0;

	
	leetLevel--;
	data = url + username + modifier;
	// Never *ever, ever* allow the character set length < 2 else
	// the hash algorithms will run indefinitely
	if (characters.length() < 2)
		return "Invalid arguments: the minimum number of characters is two.";

	if (useLeet == LEET_BEFORE || useLeet == LEET_BOTH) {
		masterPassword = leetConvert(leetLevel, masterPassword);
		data = leetConvert(leetLevel, data);
	}

	while ((int)password.length() < length) {
		char tempvalue[12];
		sprintf(tempvalue, "%i", count);
		if (count == 0) {
			password = hasher->hash(algorithm, hmac, trim, characters, data, masterPassword, sha256_bug);
		} else {
			password += hasher->hash(algorithm, hmac, trim, characters, data, masterPassword+"\n"+tempvalue, sha256_bug);
		}
		count++;
	}

	if (useLeet == LEET_AFTER || useLeet == LEET_BOTH)
		password = leetConvert(leetLevel, password);

	password = prefix + password;
	password = password.substr(0, length-suffix.length()) + suffix;

	return password.substr(0, length);
}

