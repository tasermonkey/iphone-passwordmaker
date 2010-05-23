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
#import "CharacterSetSelectionController.h"
#import "Hasher.h"

@implementation CharacterSetSelectionController

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
	defaultList = [[NSArray alloc] initWithObjects:ALPANUMSYM, ALPHANUM, HEXS,NUMS, LETTERS, SYMS, nil] ;
	customCharListView = [[UITextView alloc] init] ;
	customCharListView.autocapitalizationType = UITextAutocapitalizationTypeNone ;
	customCharListView.autocorrectionType = UITextAutocorrectionTypeNo ;
	customCharListView.returnKeyType = UIReturnKeyDone ;
	customCharListView.keyboardAppearance = UIKeyboardAppearanceAlert ;
	customCharListView.delegate = self ;
}

- (void)viewDidUnload {
	[defaultList release] ;
}

- (NSString*) selected {
	return hasher.characters ;
}

- (void) setSelected:(NSString *)selChars {
	hasher.characters = selChars ;
}

- (NSString*) getCharacterSetDesc:(NSString*)charSet {
	NSString* name = [[UIApplication getAppDelegate].charSetNames objectForKey:charSet] ;
	if ( name == nil ) return @"Custom" ;
	return name ;
}

- (BOOL) isSelectedCustomCharSet {
	NSString* selChars = self.selected ;
	return [@"Custom" isEqualToString:[self getCharacterSetDesc:selChars]] ;
}

#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	[selectedCell release] ;
	selectedCell = nil ;
	return [defaultList count] + 1;

}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Set up the cell...
	if (indexPath.row < [defaultList count]) {
		NSString* str = [defaultList objectAtIndex:indexPath.row] ;
		BOOL sele =  [str isEqualToString:self.selected] ;
		NSString* display = [self getCharacterSetDesc:str] ;
		cell.textLabel.text =  display ;
		cell.accessoryType = (sele ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone) ;
		if ( sele ) {
			selectedCell.accessoryType = UITableViewCellAccessoryNone ;
			[selectedCell release];
			selectedCell = [cell retain];
		}
	} else {
		BOOL sele = [self isSelectedCustomCharSet] ;
		cell.textLabel.text = @"Custom" ;
		cell.accessoryType = (sele ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone) ;
		if ( sele ) {
			selectedCell.accessoryType = UITableViewCellAccessoryNone ;
			[selectedCell release];
			selectedCell = [cell retain];
		}		
	}
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
	// AnotherViewController *anotherViewController = [[AnotherViewController alloc] initWithNibName:@"AnotherView" bundle:nil];
	// [self.navigationController pushViewController:anotherViewController];
	// [anotherViewController release];
	UITableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath] ;
	BOOL defaultItem = [defaultList count] > indexPath.row ;
	if ( defaultItem && cell == selectedCell ) return ;
	if ( cell != selectedCell ) {
		selectedCell.accessoryType = UITableViewCellAccessoryNone ;
		cell.accessoryType = UITableViewCellAccessoryCheckmark ;
		[selectedCell release];
		selectedCell = [cell retain] ;
		[cell setSelected:NO animated:YES] ;
	}
	if ( defaultItem ) {
		self.selected = [defaultList objectAtIndex:indexPath.row] ;
	} else {
		customCharListView.text = self.selected ;
		UIViewController* txtViewController = [[UIViewController alloc] init] ; 
		txtViewController.view = customCharListView ;
		txtViewController.navigationItem.title = @"Custom Characters" ;

		UINavigationController * controller = [[UINavigationController alloc]
											   initWithRootViewController:txtViewController] ;		
		[self.navigationController presentModalViewController:controller animated:YES] ;
		[customCharListView becomeFirstResponder] ;
		[controller release];
		[txtViewController release];
	}
}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return [defaultList count] <= indexPath.row ;
}

#pragma mark TextViewDelegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range 
 replacementText:(NSString *)text
{
    // Any new character added is passed in as the "text" parameter
    if (textView.returnKeyType == UIReturnKeyDone && [text isEqualToString:@"\n"]) {
        // Be sure to test for equality using the "isEqualToString" message
        [textView resignFirstResponder];
		self.selected = customCharListView.text ;
		[self.tableView reloadData] ;
		[self.navigationController dismissModalViewControllerAnimated:YES] ;
		
        // Return FALSE so that the final '\n' character doesn't get added
        return FALSE;
    }
    // For any other character return TRUE so that the text gets added to the view
    return TRUE;
}

- (void)dealloc {
	[hasher release] ;
	[customCharListView release] ;
	[selectedCell release] ;
    [super dealloc];
}


@end

