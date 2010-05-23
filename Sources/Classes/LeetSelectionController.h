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
#import "Hasher.h"

@interface LeetSelectionController : UITableViewController {
	Hasher* hasher ;
	UISwitch* leetEnabled ;
	UISegmentedControl* leetType ;
	UISlider* leetLevel ;
	UILabel* leetLevelTxt ;
	NSInteger oldLeetTypeIndex ;
}

- (id) initWithHasher:(Hasher*)hashObj ;
- (void) leetLevelAction:(UISlider*)slider ;
- (void) enableSwitch:(UISwitch*)ctrl ;
- (void) leetTypeSeg:(UISegmentedControl*)seg ;
@end
