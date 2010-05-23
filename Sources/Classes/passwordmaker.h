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

#ifndef PASSWORDMAKER_H
#define PASSWORDMAKER_H

#include "shared/pwm_common.h"

extern char base93Set[];

class Hasher; // So that main.cpp doesn't need to see this class

class PasswordMaker
{
public:
	PasswordMaker(void);
	~PasswordMaker(void);

	// The mack daddy function of the the class. Actually, the only exposed function that's needed.
	// leetLevel = 1 - 9
	std::string generatePassword(std::string masterPassword = "",
		hashType algorithm = PWM_MD5, bool hmac = false, bool trim = true, std::string url = "", int length = 12,
		std::string characters = base93Set, leetType useLeet = LEET_NONE,
		int leetLevel = 0, std::string username = "",
		std::string modifier = "", std::string prefix = "",
		std::string suffix = "", bool sha256_bug = true);
	bool initialized();
	// Allows us to set where to look for the gethash.js, if it's needed
	// Must end with '/' or '\' (blackslash on Windows only)
	void setPath(std::string path);

private:
	Hasher *hasher;
};

#endif //PASSWORDMAKER_H
