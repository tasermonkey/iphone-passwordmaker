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

#import "HashSelectionController.h"
#import "Hasher.h"

@implementation HashSelectionController

- (id) initWithHasher:(Hasher*)hashObj {
    if ( self = [super initWithStyle:UITableViewStyleGrouped] ) {
		hasher = [hashObj retain] ;
    }
    return self ;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    self.navigationItem.title = @"Hash Algorithm Selection" ;
	hashAlgos = [[hasher allHashAlgos] retain] ;
}

- (void)viewDidUnload {
	[hashAlgos release] ;
}

#pragma mark selection
- (NSString*) selected {
	return hasher.hashAlgo ;
}

- (void) setSelected:(NSString *)selHash {
	hasher.hashAlgo = selHash ;
}

#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [hashAlgos count] ;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"HashAlgoCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
	NSString* item = [hashAlgos objectAtIndex:indexPath.row] ;
	BOOL sele = [item isEqualToString:self.selected] ;
	cell.textLabel.text = item ;
	cell.accessoryType = ( sele ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone ) ;
	cell.selectionStyle = UITableViewCellSelectionStyleNone ;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	self.selected = [hashAlgos objectAtIndex:indexPath.row];
	[tableView reloadData] ;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO ;
}

- (void)dealloc {
	[hasher release] ;
    [super dealloc];
}


@end

