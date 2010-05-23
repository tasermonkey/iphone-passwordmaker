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
#include "pwmdefaults.h"
#include "tinyxml.h"

using namespace std;

extern char base93Set[]; // This is defined in passwordmaker.cpp

pwmDefaults::pwmDefaults(string filepath, string account, int account_count) {
	masterPassword = "\x01";
	algorithm = "MD5";
	hmac = false;
	trim = true;
	length = 8;
	characters = base93Set;
	useLeet = "none";
	leetLevel = 0;
	username = "";
	modifier = "";
	prefix = "";
	suffix = "";
	used_file = false;

	// Try to open the rdf with tinyxml
	TiXmlDocument document(filepath);
	document.LoadFile();
	string ns;

	if (!document.Error()) {
		TiXmlHandle docHandle(&document);
		TiXmlElement *defaultNode = docHandle.FirstChildElement("RDF:RDF").Element();
		int acc_cnt = 0;
		if (defaultNode) {
			TiXmlAttribute *attrib = defaultNode->FirstAttribute();
			// Find the namespace
			while (attrib) {
				if (!strcmp(attrib->Value(), "http://passwordmaker.mozdev.org/rdf#")) {
					ns = attrib->Name();
					ns.erase(ns.begin(), ns.begin() + (ns.find(':') + 1));
					break;
				}
				attrib = attrib->Next();
			}
			if (ns.empty()) {
				// Namespace was not found. Not a valid file?
				defaultNode = NULL;
			} else {
				defaultNode = docHandle.FirstChildElement("RDF:RDF").FirstChildElement("RDF:Description").Element();
				while (defaultNode) {
					if (account.empty()) {
						// Now get the node that contains the default settings
						if (!strcmp(defaultNode->Attribute("RDF:about"), "http://passwordmaker.mozdev.org/defaults")) {
							break;
						}
					} else {
						// Now to find the node with the account name we're using
						if (defaultNode->Attribute(ns+":autoPopulate") && !strcmp(defaultNode->Attribute(ns+":name"), account.c_str())
							&& acc_cnt++ == account_count) {
							break;
						}
					}
					defaultNode = defaultNode->NextSiblingElement("RDF:Description");
				}
			}
		}
		if (defaultNode) {
			used_file = true;
			char *tmpStr;
			masterPassword = "\x01"; // Doesn't support stored passwords, yet
			// Grab the characterset
			tmpStr = (char*)defaultNode->Attribute(ns+":charset");
			characters = (tmpStr) ? tmpStr : base93Set;
			// Grab the username
			tmpStr = (char*)defaultNode->Attribute(ns+":usernameTB");
			username = (tmpStr) ? tmpStr : "";
			// Grab the modifier, which was called counter in an earlier version of the Firefox extension
			tmpStr = (char*)defaultNode->Attribute(ns+":counter");
			modifier = (tmpStr) ? tmpStr : "";
			// Grab the prefix
			tmpStr = (char*)defaultNode->Attribute(ns+":prefix");
			prefix = (tmpStr) ? tmpStr : "";
			// Grab the suffix
			tmpStr = (char*)defaultNode->Attribute(ns+":suffix");
			suffix = (tmpStr) ? tmpStr : "";
			// Grab the url
			tmpStr = (char*)defaultNode->Attribute(ns+":urlToUse");
			url = (tmpStr) ? tmpStr : "";
			// Get the password length
			tmpStr = (char*)defaultNode->Attribute(ns+":passwordLength", &length);
			if (!tmpStr)
				length = 8;
			// Get the leet level
			tmpStr = (char*)defaultNode->Attribute(ns+":leetLevelLB", &leetLevel);
			if (!tmpStr)
				leetLevel = 1;
			// Find hash algorithm to use, and if it's HMAC
			tmpStr = (char*)defaultNode->Attribute(ns+":hashAlgorithmLB");
			if (!tmpStr)
				tmpStr = "md5";
			if (strstr(tmpStr, "hmac")) {
				hmac = true;
			} else {
				hmac = false;
			}
			if (strstr(tmpStr, "md4"))
				algorithm = "MD4";
			if (strstr(tmpStr, "md5"))
				algorithm = "MD5";
			if (strstr(tmpStr, "sha1"))
				algorithm = "SHA1";
			if (strstr(tmpStr, "sha256"))
				algorithm = "SHA256";
			if (strstr(tmpStr, "rmd160"))
				algorithm = "RIPEMD160";
			// Get where to apply leet (and convert to commandline value
			tmpStr = (char*)defaultNode->Attribute(ns+":whereLeetLB");
			if (!tmpStr)
				tmpStr = "off";
			if (strstr(tmpStr, "off"))
				useLeet = "none";
			if (strstr(tmpStr, "before-hashing"))
				useLeet = "before";
			if (strstr(tmpStr, "after-hashing"))
				useLeet = "after";
			if (strstr(tmpStr, "both"))
				useLeet = "both";
		}
	}
}

pwmDefaults::~pwmDefaults(void) {
}
