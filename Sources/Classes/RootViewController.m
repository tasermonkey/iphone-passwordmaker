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

#import "RootViewController.h"
#import "Hasher.h"
#import "HashSelectionController.h"
#import "CharacterSetSelectionController.h"
#import "LeetSelectionController.h"
#import "ProfileSelectionController.h"

static CGRect valueFrame ;
static CGRect textViewFrame ;
static CGRect buttonFrame ;
static UIColor *thatTableTextColor ;

#define PASSWORDTIMEOUT (60. * 5)

//#define PASSWORDTIMEOUT 10

@implementation RootViewController
+ (NSString*) LeetEnumToString:(enum leetType)lt WithLevel:(NSInteger)level {
	if ( level < 1 || level > 9 ) {
		lt = LEET_NONE ;
	}
	switch (lt) {
		case LEET_BEFORE:
			return [NSString stringWithFormat:@"Before level %d", level] ;
		case LEET_AFTER:
			return [NSString stringWithFormat:@"After level %d", level] ;
		case LEET_BOTH:
			return [NSString stringWithFormat:@"Both level %d", level] ;
		case LEET_NONE:
		default:
			return @"Leet Off" ;
	};
}

+ (void) initialize {
	valueFrame = CGRectMake(150, 10, 145, 38) ;
	textViewFrame = CGRectMake(150, 10, 145, 30) ;
	buttonFrame = CGRectMake(5, 5, 290, 33) ;
	thatTableTextColor = [[UIColor colorWithRed:0.243 green:0.306 blue:0.435 alpha:1.0] retain];

}

- (id) initWithHasher:(Hasher*)hashObj {
	if (self = [super initWithStyle:UITableViewStyleGrouped]) {
		hasher = [hashObj retain] ;
		inputURL = [self allocTextField:@"" keyboardType:UIKeyboardTypeURL] ;
	}
	return self ;
}

- (void)viewDidLoad {
	self.navigationItem.title = @"Password Maker" ;
    [super viewDidLoad];
	
	NSDate* lastAccess = [[NSUserDefaults standardUserDefaults] objectForKey:@"lastAccess"] ;
	NSString* strmasterPass = nil ;
	NSString* strinputUrl = nil ;
	NSString* strusername = nil ;
	NSInteger secSinceLastAccess =  -[lastAccess timeIntervalSinceNow] ; // since its in the past its negative
	if ( lastAccess != nil &&  secSinceLastAccess < PASSWORDTIMEOUT ) {
		strmasterPass = [[NSUserDefaults standardUserDefaults] objectForKey:@"masterPass"] ;
		strinputUrl = [[NSUserDefaults standardUserDefaults] objectForKey:@"inputUrl"] ;
		strusername = [[NSUserDefaults standardUserDefaults] objectForKey:@"username"] ;
	}
	if (strmasterPass == nil || strinputUrl == nil || strusername == nil ) {
		strmasterPass = @"" ;
		strinputUrl = @"" ;
		strusername = @"" ;
	}
	if ( [inputURL.text length] == 0 )
		inputURL.text = strinputUrl ;
	masterPassword = [self allocTextField:strmasterPass isPassword:YES] ;
	passLength = [self allocTextField:[[NSNumber numberWithInteger:hasher.maxLen] stringValue]] ;
	username = [self allocTextField:strusername] ;
	modifier = [self allocTextField:hasher.counter] ;
	prefix = [self allocTextField:hasher.prefix] ;
	suffix = [self allocTextField:hasher.suffix] ;
	generatedPassword = [self allocTextView:@"" readonly:YES ] ;
	copyPassword = [[UIButton buttonWithType:UIButtonTypeRoundedRect] retain] ;
	copyPassword.frame = buttonFrame ;
	[copyPassword setTitle:@"Copy Password" forState:UIControlStateNormal];
	[copyPassword addTarget:self action:@selector(copyPasswordClicked) forControlEvents:UIControlEventTouchUpInside] ;
	[self updateGeneratePassword];
	
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
	[self updateFieldsFromHasher] ;
	[self.tableView reloadData] ;
	[self updateGeneratePassword] ;
}

- (IBAction) updateFieldsFromHasher {
	passLength.text = [NSString stringWithFormat:@"%d", hasher.maxLen] ;
	modifier.text = hasher.counter ;
	prefix.text = hasher.prefix ;
	suffix.text = hasher.suffix ;
}

- (UITextField*) allocTextField:(NSString*)txt {
	UITextField* ret = [[UITextField alloc] initWithFrame:valueFrame] ;
	ret.text = txt ;
	ret.delegate = self ;
	ret.autocapitalizationType = UITextAutocapitalizationTypeNone ;
	ret.autocorrectionType = UITextAutocorrectionTypeNo ;
	ret.returnKeyType = UIReturnKeyDone ;
	ret.placeholder = @"<Enter Value>" ;
	ret.textColor = thatTableTextColor ;
	return ret ;
}

- (UITextField*) allocTextField:(NSString*)txt keyboardType:(UIKeyboardType)kbt {
	UITextField* ret = [self allocTextField:txt] ;
	ret.keyboardType = kbt ;
	return ret ;
}


- (UITextField*) allocTextField:(NSString*)txt isPassword:(BOOL)isPass {
	UITextField* ret = [self allocTextField:txt] ;
	ret.secureTextEntry = isPass ;
	return ret ;
}

- (UITextView*) allocTextView:(NSString*)txt readonly:(BOOL)readonly {
	UITextView* ret = [[UITextView alloc] initWithFrame:textViewFrame ] ;
	ret.text = txt ;
	ret.editable = ! readonly ;
	ret.scrollEnabled = NO ;
	return ret ;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
	[self updateGeneratePassword];
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
	return YES ;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	[textField resignFirstResponder] ;
	return NO ;
}

- (NSString*) inputURLText {
	return inputURL.text ;
}

- (void) setInputURLText:(NSString*)newUrl {
	inputURL.text = newUrl ;	
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void) applicationWillTerminate:(UIApplication *)application {
	[[NSUserDefaults standardUserDefaults] setObject:masterPassword.text forKey:@"masterPass"] ;
	[[NSUserDefaults standardUserDefaults] setObject:inputURL.text forKey:@"inputUrl"] ;
	[[NSUserDefaults standardUserDefaults] setObject:username.text forKey:@"username"] ;
	[[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:@"lastAccess"] ;
}


- (UITableViewCell*) makeForTableView:(UITableView*)tblView CellWithLabel:(NSString*)str 
					   andContentView:(UIView*)cview  {
	
    static NSString *CellIdentifier = nil;
    
    UITableViewCell *cell = [tblView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Set up the cell...
	cell.textLabel.text = str ;
	[cell.contentView addSubview:cview ];
	cell.selectionStyle = UITableViewCellSelectionStyleNone ;
    return cell;
}

- (UITableViewCell*) makeForTableView:(UITableView*)tblView CellWithLabel:(NSString*)str
						  andValueText:(NSString*)valueText accessType:(UITableViewCellAccessoryType)acc {
	
    static NSString *CellIdentifier = @"TextValueCellReuse";
    
    UITableViewCell *cell = [tblView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Set up the cell...
	cell.textLabel.text = str ;
	cell.detailTextLabel.text = valueText ;
	cell.selectionStyle = UITableViewCellSelectionStyleNone ;
	cell.accessoryType = acc ;
    return cell;	
}

#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 13;
}

- (NSString*) getCharacterSelDesc {
	
	NSString* name = [[UIApplication getAppDelegate].charSetNames objectForKey:hasher.characters] ;
	if ( name == nil ) return @"Custom" ;
	return name ;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	UIView* v = nil ;
	NSString* str = @"" ;
    switch (indexPath.row) {
		case 0: {
			[self update_password_fields_color] ;
			v = masterPassword ; 
			str = @"Master Pass" ; 
			break ;
		}
		case 1: v = inputURL ; str = @"Input URL" ; break ;
		case 2: {
			return [self makeForTableView:tableView CellWithLabel:@"Leet" 
							  andValueText:[RootViewController LeetEnumToString:hasher.leetSpeak WithLevel:hasher.leetLevel] 
								accessType:UITableViewCellAccessoryDetailDisclosureButton] ;
		}
		case 3: {
			return [self makeForTableView:tableView CellWithLabel:@"Hash Algo" 
							  andValueText:hasher.hashAlgo 
								accessType:UITableViewCellAccessoryDetailDisclosureButton] ;
		}
		case 4: v = passLength ; str = @"Pass Length" ; break ;
		case 5: v = username ; str = @"Username" ; break ;
		case 6: v = modifier ; str = @"Modifier" ; break ;
		case 7: {
			return [self makeForTableView:tableView CellWithLabel:@"Characters" 
							  andValueText:[self getCharacterSelDesc] 
								accessType:UITableViewCellAccessoryDetailDisclosureButton] ;
		}
		case 8: v = prefix ; str = @"Prefix" ; break ;
		case 9: v = suffix ; str = @"Suffix" ; break ;
		case 10: {
			NSString* pn = hasher.profileName ;
			if ( [pn isEqualToString:@""] ) pn = @"Default" ;
			return [self makeForTableView:tableView CellWithLabel:@"Profile" 
							  andValueText:pn
								accessType:UITableViewCellAccessoryDetailDisclosureButton] ;
		}
		case 11: v = generatedPassword ; str = @"Generated Pass" ; 
			[self update_password_fields_color];  break ;
		case 12: {
			UITableViewCell* tvc = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cppwd"] ;
			[tvc.contentView addSubview:copyPassword] ;
			return [tvc autorelease] ;
		}
		default: return nil ;
	}
	return [self makeForTableView:tableView CellWithLabel:str andContentView:v] ;
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {
	switch (indexPath.row) {
		case 2: {
			LeetSelectionController* leetSel = [[LeetSelectionController alloc] initWithHasher:hasher] ;
			[self.navigationController pushViewController:leetSel animated:YES] ;
			[leetSel release] ;
			break;
			
		}
		case 3: {
			HashSelectionController* hashSel = [[HashSelectionController alloc] initWithHasher:hasher] ;
			[self.navigationController pushViewController:hashSel animated:YES] ;
			[hashSel release] ;
			break;
		}
		case 7: {
			CharacterSetSelectionController* charSel = [[CharacterSetSelectionController alloc] initWithHasher:hasher] ;
			[self.navigationController pushViewController:charSel animated:YES] ;
			[charSel release] ;
			break;			
		}
		case 10: {
			ProfileSelectionController* profSel = [[ProfileSelectionController alloc] initWithHasher:hasher] ;
			[self.navigationController pushViewController:profSel animated:YES] ;
			[profSel release] ;
			break ;
		}
	}
}

- (IBAction) copyPasswordClicked {
	UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
	[pasteboard setValue:generatedPassword.text forPasteboardType:@"public.utf8-plain-text"];
	[[UIApplication getAppDelegate] setNewMasterPassword:generatedPassword.text] ;
	masterPasswordHashMatches = 
	[[UIApplication getAppDelegate] matchesSavedPassword:generatedPassword.text] ;
	[self update_password_fields_color];
}


- (void)viewDidUnload {
	// Release anything that can be recreated in viewDidLoad or on demand.
	// e.g. self.myOutlet = nil;
	[masterPassword release] ;
	[passLength release] ;
	[username release] ;
	[modifier release] ;
	[prefix release] ;
	[suffix release] ;
	[generatedPassword release] ;
	[copyPassword release] ;
	
}

- (void)dealloc {
	[hasher release] ;
	[inputURL release] ;
    [super dealloc];
}

- (IBAction) updateGeneratePassword {
	hasher.counter = modifier.text ;
	hasher.prefix = prefix.text ;
	hasher.suffix = suffix.text ;
	NSInteger maxLen ;
	[[NSScanner scannerWithString:passLength.text] scanInteger:&maxLen] ;
	if ( maxLen == 0 ) maxLen = 12 ;
	hasher.maxLen = maxLen ;
	generatedPassword.text = [hasher generatePasswordWithMasterPassword:masterPassword.text
																	Url:inputURL.text 
															   Username:username.text ] ;
	generatedPassword.contentOffset = CGPointMake(0, 0) ;
	generatedPassword.contentSize = CGSizeMake( 145, 30) ;
	masterPasswordHashMatches = 
	  [[UIApplication getAppDelegate] matchesSavedPassword:generatedPassword.text] ;

	[self update_password_fields_color];
}
- (void) update_password_fields_color { 
	if ( ! hasher.savedPasswordHash || [hasher.savedPasswordHash length] == 0 ) {
		masterPassword.textColor = [UIColor blackColor] ;
	}
	else if ( ! masterPasswordHashMatches ) {
		masterPassword.textColor = [UIColor redColor] ;
	} else {
		masterPassword.textColor = [UIColor greenColor] ;
	}
	generatedPassword.textColor = masterPassword.textColor ;
}

@end

