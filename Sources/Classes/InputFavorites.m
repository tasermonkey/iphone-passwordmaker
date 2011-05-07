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

#import "InputFavorites.h"
#import "AlertPrompt.h"


@implementation InputFavorites


#pragma mark -
#pragma mark Initialization

- (id) initWithTextField:(UITextField*)outputField andFavorites:(NSMutableArray*)favoriteItems {
    if ( self = [super initWithStyle:UITableViewStyleGrouped] ) {
		output = [outputField retain];
		favorite = [favoriteItems retain];
    }
    return self ;
}


/*
- (id)initWithStyle:(UITableViewStyle)style {
    // Override initWithStyle: if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
    if ((self = [super initWithStyle:style])) {
    }
    return self;
}
*/


#pragma mark -
#pragma mark View lifecycle


- (void)viewDidLoad {
    [super viewDidLoad];

	self.navigationItem.title = @"Input Favorites" ;	
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
	if ( favorite.count == 0 )
		self.editing = YES;
	
	
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	AlertPrompt* ap = (AlertPrompt*)alertView;
	[favorite addObject:ap.enteredText];
	[self.tableView reloadData];
}

/*
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
*/
/*
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
*/
/*
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}
*/
/*
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}
*/

// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
	return (interfaceOrientation == UIInterfaceOrientationLandscapeRight || 
			interfaceOrientation ==  UIInterfaceOrientationPortrait);
}


#pragma mark -
#pragma mark Table view data source

- (void) setEditing:(BOOL)editing animated:(BOOL)animated {
    [super setEditing: editing animated: animated];
    [self.tableView setEditing:editing animated:animated];
	[self.tableView reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
	if ( self.editing )
		return [favorite count] + 1;
	else
		return [favorite count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
	
	if ( indexPath.row < favorite.count) {
		cell.textLabel.text = [favorite objectAtIndex:indexPath.row];
	}
	else {
		cell.textLabel.text = @"New Favorite";
	}
	cell.accessoryType = UITableViewCellAccessoryNone;


    return cell;
}



// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == [favorite count])
        return UITableViewCellEditingStyleInsert;
    else
        return UITableViewCellEditingStyleDelete;
}


// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
		[favorite removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
		AlertPrompt* prompt = [[[AlertPrompt alloc] initWithTitle:@"New Favorite" 
														 message:@"Input Text" 
														delegate:self cancelButtonTitle:@"Cancel" 
												   okButtonTitle:@"Insert"] autorelease];
		prompt.textField.autocorrectionType = UITextAutocorrectionTypeNo;
		prompt.textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
		prompt.textField.keyboardType = UIKeyboardTypeURL;
		[prompt show];
    } 
}



// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
	NSString *row = [favorite objectAtIndex:fromIndexPath.row];
    [favorite removeObjectAtIndex:fromIndexPath.row];
    [favorite insertObject:row atIndex:toIndexPath.row];
}




// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return indexPath.row < [favorite count];
}



#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	if ( indexPath.row < favorite.count ) {
		output.text = [favorite objectAtIndex:indexPath.row];
		[self.navigationController popViewControllerAnimated:true];
	}
}


#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}


- (void)dealloc {
	[output release];
	[favorite release];
    [super dealloc];
}


@end

