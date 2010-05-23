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

#import "LeetSelectionController.h"


@implementation LeetSelectionController

- (id) initWithHasher:(Hasher*)hashObj {
    if ( self = [super initWithStyle:UITableViewStyleGrouped] ) {
		hasher = [hashObj retain] ;
		leetEnabled = [[UISwitch alloc] initWithFrame:CGRectMake(198.0, 12.0, 94.0, 27.0)] ;
		[leetEnabled addTarget:self action:@selector(enableSwitch:) forControlEvents:UIControlEventValueChanged];
		leetType = [[UISegmentedControl alloc] initWithItems:
					[NSArray arrayWithObjects:@"Before", @"After", @"Both", nil ]] ;
		leetType.frame = CGRectMake(100.0, 8.0, 194.0, 29.0) ;		
		[leetType addTarget:self action:@selector(leetTypeSeg:) forControlEvents:UIControlEventValueChanged];
		leetLevel = [[UISlider alloc] initWithFrame:CGRectMake(100.0, 12.0, 174, 7.0) ] ;
		leetLevel.minimumValue = 1 ;
		leetLevel.maximumValue = 9 ;
		leetLevel.continuous = YES;
		[leetLevel addTarget:self action:@selector(leetLevelAction:) forControlEvents:UIControlEventValueChanged];
		leetLevelTxt = [[UILabel alloc] initWithFrame:CGRectMake(275, 8.0, 15, 29.0)] ;
		leetLevelTxt.textAlignment = UITextAlignmentRight ;
		
		leetLevel.value = ( hasher.leetLevel >= 1 && hasher.leetLevel <= 9 ? hasher.leetLevel : 1 );
		leetLevelTxt.text = [[NSNumber numberWithInt:hasher.leetLevel] stringValue] ;
		switch ( hasher.leetSpeak ) {
			case LEET_BEFORE:
				leetType.selectedSegmentIndex = 0;
				[leetEnabled setOn:YES] ;
				break ;
			case LEET_AFTER:
				leetType.selectedSegmentIndex = 1;
				[leetEnabled setOn:YES] ;
				break ;
			case LEET_BOTH:
				leetType.selectedSegmentIndex = 2;
				[leetEnabled setOn:YES] ;
				break ;
			case LEET_NONE:
			default:
				leetType.selectedSegmentIndex = 0;
				[leetEnabled setOn:NO] ;
				break ;
		} ;
		
		oldLeetTypeIndex = leetType.selectedSegmentIndex ;
		if ( oldLeetTypeIndex == -1 ) oldLeetTypeIndex = 0 ;
	    [self enableSwitch:leetEnabled];
    }
    return self ;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	self.navigationItem.title = @"Leet Options" ;
	
}

- (NSString*) selected {
	return hasher.characters ;
}

- (void) setSelected:(NSString *)selChars {
	hasher.characters = selChars ;
}


#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
	NSString *CellIdentifier = [NSString stringWithFormat:@"Cell%d", indexPath.row] ;
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Set up the cell...
	switch ( indexPath.row ) {
		case 0:
			cell.textLabel.text = @"Enabled" ;
			[cell.contentView addSubview:leetEnabled] ;
			break;
		case 1:
			cell.textLabel.text = @"Type" ;
			[cell.contentView addSubview:leetType] ;
			break;
		case 2:
			cell.textLabel.text = @"Level" ;
			[cell.contentView addSubview:leetLevel] ;
			[cell.contentView addSubview:leetLevelTxt] ;
			break;
	 }
	cell.selectionStyle = UITableViewCellSelectionStyleNone ;
    return cell;
}

- (void) enableSwitch:(UISwitch*)ctrl {
	BOOL controlsEnabled = ctrl.on ;
	leetLevel.enabled = controlsEnabled ;
	leetType.enabled = controlsEnabled ;
	if ( ! controlsEnabled ) oldLeetTypeIndex = leetType.selectedSegmentIndex ;
	leetType.selectedSegmentIndex = ( controlsEnabled ? oldLeetTypeIndex : -1 ) ;
	
	[self leetTypeSeg:leetType] ;
}

- (void) leetTypeSeg:(UISegmentedControl*)seg {
	switch (seg.selectedSegmentIndex) {
		case 0:
			hasher.leetSpeak = LEET_BEFORE ;
			break ;
		case 1:
			hasher.leetSpeak = LEET_AFTER ;
			break ;
		case 2:
			hasher.leetSpeak = LEET_BOTH ;
			break ;
		case -1:
		default:
			hasher.leetSpeak = LEET_NONE ;
			break;
	};
}

- (void) leetLevelAction:(UISlider*)slider {
	hasher.leetLevel = (NSInteger)slider.value ;
	leetLevelTxt.text = [[NSNumber numberWithInt:hasher.leetLevel] stringValue];
}

- (void)dealloc {
	[leetType release];
	[leetLevel release];
	[leetEnabled release];
	[leetLevelTxt release];
	[hasher release];
    [super dealloc];
}


@end

