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

#import "ProfileSelectionController.h"
#import "ApplicationDelegate.h"
#import "AlertPrompt.h"

@implementation ProfileSelectionController
@synthesize profiles ;
- (id) initWithHasher:(Hasher*)hashObj {
    if ( self = [super initWithStyle:UITableViewStyleGrouped] ) {
		hasher = [hashObj retain] ;
		reallyImEditing = FALSE ;
    }
    return self ;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
	self.navigationItem.rightBarButtonItem = 
	[[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit 
												   target:self action:@selector(editPressed:)] autorelease] ;
	self.navigationItem.title = @"Profiles" ;
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	if ( reallyImEditing )
		return 2 ;
	return 1 ;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	if ( section == 0 ) {
		self.profiles = [[UIApplication getAppDelegate].profileList sortedArrayUsingSelector:
					 @selector(caseInsensitiveCompare:)] ;
		return [self.profiles count] + 1;
	} else {
		return 1 ;
	}
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
	if ( indexPath.section == 1 ) {
		cell.textLabel.text = @"Add new row" ;
	} else {
		NSString* text ;
		if ( indexPath.row == 0 ) 
			text = @"Default" ;
		else
			text = [self.profiles objectAtIndex:indexPath.row - 1] ;
		
		cell.textLabel.text = text ;
		NSString* currentProfile = hasher.profileName ;
		if ( indexPath.row == 0 && [currentProfile isEqualToString:@""] )
			cell.accessoryType = UITableViewCellAccessoryCheckmark ;
		else if ( [text isEqualToString:currentProfile] ) 
			cell.accessoryType = UITableViewCellAccessoryCheckmark ;
		else
			cell.accessoryType = UITableViewCellAccessoryNone ;
	}
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
	// AnotherViewController *anotherViewController = [[AnotherViewController alloc] initWithNibName:@"AnotherView" bundle:nil];
	// [self.navigationController pushViewController:anotherViewController];
	// [anotherViewController release];
	if ( indexPath.section == 0 ) {
		if ( indexPath.row == 0 ) {
			[[UIApplication getAppDelegate] loadHasherProfile:nil] ;
		} else {
			[[UIApplication getAppDelegate] loadHasherProfile:[self.profiles objectAtIndex:indexPath.row - 1]] ;
		}
		[self.navigationController popViewControllerAnimated:YES] ;
	} else if ( indexPath.section == 1 ) {

	}
}

- (void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex != [alertView cancelButtonIndex])
    {
        NSString *entered = [(AlertPrompt *)alertView enteredText];
		BOOL found = ( [profiles indexOfObject:entered] != NSNotFound ) ;
		if (found) {
			UIAlertView* av = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Profile by that name already exists"
														delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] ;
			[av show] ;
			[av release] ;
		} else {
			[[UIApplication getAppDelegate] addProfile:entered];
			self.profiles = [[UIApplication getAppDelegate].profileList sortedArrayUsingSelector:
							 @selector(caseInsensitiveCompare:)] ;
			NSIndexPath* indexPath = [NSIndexPath indexPathForRow:[self.profiles indexOfObject:entered] + 1
										   inSection:0] ;
			[self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES] ;
		}
    }
}



// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
	
	if ( indexPath.section == 0 ) {
		return indexPath.row > 0 ;
	} else if ( indexPath.section == 1 ) {
		return YES ;
	}
	return NO ;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
	if ( indexPath.section == 1 ) {
		return UITableViewCellEditingStyleInsert ;
	} else if ( indexPath.section == 0 && indexPath.row > 0 ) {
		return UITableViewCellEditingStyleDelete ;
	} else {
		return UITableViewCellEditingStyleNone ;
	}
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
		NSString* profName = [self.profiles objectAtIndex:indexPath.row-1] ;
		[[UIApplication getAppDelegate] remProfile:profName] ;
		self.profiles = [[UIApplication getAppDelegate].profileList sortedArrayUsingSelector:
						 @selector(caseInsensitiveCompare:)] ;
		[tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
		
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
		AlertPrompt *prompt = [AlertPrompt alloc];
		prompt = [prompt initWithTitle:@"New Profile" message:@"" delegate:self 
					 cancelButtonTitle:@"Cancel" okButtonTitle:@"Okay"];
		[prompt show];
		[prompt release];
    }   
}

// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return NO;
}

- (void) editPressed:(id)item {
	reallyImEditing = YES ;
	self.tableView.editing = YES ;
	self.navigationItem.rightBarButtonItem = 
	[[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone 
												   target:self action:@selector(donePressed:)] autorelease] ;
	[self.tableView reloadData] ;
}

- (void) donePressed:(id)item {
	reallyImEditing = NO ;
	self.tableView.editing = NO ;
	self.navigationItem.rightBarButtonItem = 
	[[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit 
												   target:self action:@selector(editPressed:)] autorelease] ;
	[self.tableView reloadData] ;
}


- (void)dealloc {
	self.profiles = nil ;
	[hasher release];
    [super dealloc];
}


@end

