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
#import <UIKit/UIKit.h>


@interface ProfileSelectionController : UITableViewController {
	Hasher* hasher ;	
	NSArray* profiles ;
	BOOL reallyImEditing ;
}

@property (retain, nonatomic) NSArray* profiles ;
- (id) initWithHasher:(Hasher*)hashObj ;

- (void) editPressed:(id)item ;
- (void) donePressed:(id)item ;

@end
