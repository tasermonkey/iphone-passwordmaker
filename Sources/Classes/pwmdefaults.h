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

#ifndef PWMDEFAULTS_H
#define PWMDEFAULTS_H

#include <string>

/**
	This class reads "passwordmaker.rdf" and sets defaults based on
	that. Then you can use the get functions to get defaults for use
	with command line options.
*/
class pwmDefaults
{
public:
	pwmDefaults(std::string filepath = "", std::string account = "", int account_count = 0);
	~pwmDefaults(void);

	std::string getMasterPassword() { return masterPassword; };
	std::string getCharset() { return characters; };
	std::string getUserName() { return username; };
	std::string getModifier() { return modifier; };
	std::string getUseLeet() { return useLeet; };
	std::string getAlgorithm() { return algorithm; };
	std::string getPrefix() { return prefix; };
	std::string getSuffix() { return suffix; };
	std::string getURL() { return url; };
	int getPasswordLength() { return length; };
	int getLeetLevel() { return leetLevel; };
	bool getHmac() { return hmac; };
	bool getTrim() { return trim; };
	bool usedFile() { return used_file; };

private:
	std::string masterPassword, useLeet, algorithm, characters, username, modifier,
		prefix, suffix, url;
	int length, leetLevel;
	bool hmac, trim, used_file;
};

#endif // PWMDEFAULTS_H
