//
//  «FILENAME»
//  «PROJECTNAME»
//
//  Created by «FULLUSERNAME» on «DATE».
//  Copyright «YEAR» «ORGANIZATIONNAME». All rights reserved.
//

#import "CrudViewController.h"

////////////////////////////////////////////////////////////////////////////////
//
// Listeded ViewController
//
////////////////////////////////////////////////////////////////////////////////
@implementation ListedCrudViewController

@synthesize fetchedResultsController;
@synthesize addButton;
@synthesize editButton;
@synthesize doneEditingButton;

- (id)init {
    return [super initWithNibName:@"CrudViewController" bundle:nil];
}

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
 - (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
 if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
 // Custom initialization
 }
 return self;
 }
 */

- (void)viewWillAppear:(BOOL)animated {
	NSIndexPath* selectedPath = [tableView indexPathForSelectedRow];
	if (selectedPath) [tableView deselectRowAtIndexPath:selectedPath animated:YES];
    [tableView reloadData];
}

- (void)viewDidAppear:(BOOL)animated {
	[tableView flashScrollIndicators];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.addButton = [[[UIBarButtonItem alloc]
                  initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                  target:self
                  action:@selector(addAction:)] retain];
    self.editButton = [[[UIBarButtonItem alloc]
                   initWithBarButtonSystemItem:UIBarButtonSystemItemEdit
                   target:self
                   action:@selector(editAction:)] retain]; 
    self.doneEditingButton = [[[UIBarButtonItem alloc]
                          initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                          target:self
                          action:@selector(doneEditingAction:)] retain];
    
    NSError *error;
	if (![self.fetchedResultsController performFetch:&error]) {
		// Handle the error...
	}
    
    self.fetchedResultsController.delegate = self;
    
    NSEntityDescription *entity = [[self.fetchedResultsController fetchRequest] entity];
    self.title = [[entity name] stringByAppendingString: @" List"];
    
	[self.navigationItem setHidesBackButton:YES animated:NO];
    self.navigationItem.rightBarButtonItem = self.addButton;
    self.navigationItem.leftBarButtonItem = self.editButton;
}

/*
 // Override to allow orientations other than the default portrait orientation.
 - (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
 // Return YES for supported orientations
 return (interfaceOrientation == UIInterfaceOrientationPortrait);
 }
 */

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}

- (void)setEditing:(BOOL)editting animated:(BOOL)animated {
    [super setEditing:editting animated:animated];
    [tableView setEditing:editting animated:animated];
    
    if (editting) {
        [self.navigationItem setLeftBarButtonItem:self.doneEditingButton animated:animated];
    } else {
        [self.navigationItem setLeftBarButtonItem:self.editButton animated:animated];
    }
}

- (void)addAction:(id)sender {
	NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
	NSEntityDescription *entity = [[self.fetchedResultsController fetchRequest] entity];
	NSManagedObject *newManagedObject = [NSEntityDescription insertNewObjectForEntityForName:[entity name] inManagedObjectContext:context];
    
    detailedViewController.managedObject = newManagedObject;
    [detailedViewController setEditing:YES animated:NO];
    
    UINavigationController *navigationController = [[[UINavigationController alloc] initWithRootViewController:detailedViewController] autorelease];
    [self presentModalViewController:navigationController animated:YES];
}

- (void)editAction:(id)sender {
    [self setEditing:YES animated:YES];
}

- (void)doneEditingAction:(id)sender {
    [self setEditing:NO animated:YES];
}

#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)aTableView {
    return [[[self fetchedResultsController] sections] count];
}


- (NSInteger)tableView:(UITableView *)aTableView numberOfRowsInSection:(NSInteger)section {
	id <NSFetchedResultsSectionInfo> sectionInfo = [[[self fetchedResultsController] sections] objectAtIndex:section];
    return [sectionInfo numberOfObjects];
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"ListedCrudViewCell";
    
    UITableViewCell *cell = [aTableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
	// Configure the cell.
    NSManagedObject *managedObject = [[self fetchedResultsController] objectAtIndexPath:indexPath];
    cell.textLabel.text = [[managedObject valueForKey:[[self attributeNames] objectAtIndex:0]] description];
	
    return cell;
}

- (void)tableView:(UITableView *)aTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
	// AnotherViewController *anotherViewController = [[AnotherViewController alloc] initWithNibName:@"AnotherView" bundle:nil];
	// [self.navigationController pushViewController:anotherViewController];
	// [anotherViewController release];
    
    detailedViewController.managedObject = [[self fetchedResultsController] objectAtIndexPath:indexPath];
    
    [self.navigationController pushViewController:detailedViewController animated:YES];
    
    [aTableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)tableView:(UITableView *)aTableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the managed object for the given index path
        NSUInteger beforeSectionCount = [[fetchedResultsController sections] count];
        NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
        [context deleteObject:[self.fetchedResultsController objectAtIndexPath:indexPath]];
        
        // Save the context.
        NSError *error;
        if (![context save:&error]) {
            // Update to handle the error appropriately.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            exit(-1);  // Fail
        }
        
        if (beforeSectionCount > [[fetchedResultsController sections] count]) {
            [aTableView deleteSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationFade];
        } else {
            [aTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        }
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
    }   
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    if (!tableView.editing) [tableView reloadData];
}

- (NSArray *)attributes {
    NSEntityDescription *entity = [[self.fetchedResultsController fetchRequest] entity];
    
    NSMutableArray *attributes = [[[NSMutableArray alloc] init] autorelease];
    for(NSPropertyDescription *property in [entity properties]) {
        if ([property isKindOfClass:[NSAttributeDescription class]]) {
            [attributes addObject:property];
        }
    }
    
    return attributes;
}

- (NSArray *)attributeNames {
    NSMutableArray *attributeNames = [[[NSMutableArray alloc] init] autorelease];
    for (NSAttributeDescription *attribute in [self attributes]) {
        [attributeNames addObject:[attribute name]];
    }
    
    return attributeNames;
}

- (NSArray *)attributeShowingOrder {
    // return [NSArray arrayWithObjects:@"title", @"Time Stamp", nil];
    return [self attributeNames];
}

- (NSArray *)attributeShowingNames {
    // return [NSArray arrayWithObjects:@"Title", @"Time Stamp", nil];
    return nil;
}

- (void)dealloc {
    [fetchedResultsController release];
    [addButton release];
    [editButton release];
    [doneEditingButton release];    
    [super dealloc];
}

@end


////////////////////////////////////////////////////////////////////////////////
//
// Detailed ViewController
//
////////////////////////////////////////////////////////////////////////////////
@implementation DetailedCrudViewController

@synthesize managedObject;

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
 - (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
 if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
 // Custom initialization
 }
 return self;
 }
 */

- (NSString *)title {
    return [[[managedObject entity] name] stringByAppendingString: @" Detail"];
}

- (void)viewWillAppear:(BOOL)animated {
	NSIndexPath* selectedPath = [tableView indexPathForSelectedRow];
	if (selectedPath) [tableView deselectRowAtIndexPath:selectedPath animated:YES];
    
    [tableView reloadData];
}

- (void)viewDidAppear:(BOOL)animated {
	[tableView flashScrollIndicators];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
    tableView.allowsSelection = NO;
    [self setEditing:NO animated:NO];
}

/*
 // Override to allow orientations other than the default portrait orientation.
 - (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
 // Return YES for supported orientations
 return (interfaceOrientation == UIInterfaceOrientationPortrait);
 }
 */

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}

- (NSString *)attributeNameAtSectionIndex:(NSInteger)section {
    NSArray *order;
    if (order = [listedViewController attributeShowingOrder]) {
        return [order objectAtIndex:section];
    } else {
        NSArray *attributes = [listedViewController attributes];
        return [[attributes objectAtIndex:section] name];
    }
}

#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)aTableView {
    NSArray *order;
    if (order = [listedViewController attributeShowingOrder]) {
        return [order count];
    }
    
    NSEntityDescription *entity = [managedObject entity];
    
    NSMutableArray *attributes = [[[NSMutableArray alloc] init] autorelease];
    for(NSPropertyDescription *property in [entity properties]) {
        if ([property isKindOfClass:[NSAttributeDescription class]]) {
            [attributes addObject:property];
        }
    }
    
    return [attributes count];
}

//- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
//    return [[NSArray alloc] initWithObjects:@"title", @"timeStamp", nil];
//}

- (NSString *)tableView:(UITableView *)aTableView titleForHeaderInSection:(NSInteger)section {
    NSArray *names;
    if (names = [listedViewController attributeShowingNames]) {
        return [names objectAtIndex:section];
    } else {
        return [self attributeNameAtSectionIndex:section];
    }
}

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)aTableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"DetailedCrudViewCell";
    
    UITableViewCell *cell = [aTableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Set up the cell...
    
    int section = [indexPath section];
    // int row = [indexPath row];
    
    cell.textLabel.text = [[managedObject valueForKey:[self attributeNameAtSectionIndex:section]] description];
    cell.accessoryType = UITableViewCellAccessoryNone;    
    cell.editingAccessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

- (void)tableView:(UITableView *)aTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
	// AnotherViewController *anotherViewController = [[AnotherViewController alloc] initWithNibName:@"AnotherView" bundle:nil];
	// [self.navigationController pushViewController:anotherViewController];
	// [anotherViewController release];
    
    int section = [indexPath section];
    
    NSArray *names;    
    NSString *keyName;
    if (names = [listedViewController attributeShowingNames]) {
        keyName = [names objectAtIndex:section];
    } else {
        keyName = [self attributeNameAtSectionIndex:section];
    }
    
    [editPropertyViewController setUp:self.managedObject keyName:keyName];
    [self.navigationController pushViewController:editPropertyViewController animated:YES];
}

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)aTableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

- (UITableViewCellEditingStyle)tableView:(UITableView *)aTableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleNone;
}

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)aTableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
 
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
 }   
 else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }   
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)aTableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)aTableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    [super setEditing:editing animated:animated];
    [tableView setEditing:editing animated:animated];
    
    [self.navigationItem setHidesBackButton:editing animated:animated];
    if (editing) {
        [self.navigationItem setLeftBarButtonItem:[[[UIBarButtonItem alloc]
                                                    initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                                    target:self
                                                    action:@selector(editCancel:)] autorelease]
                                         animated:animated];
        [self.navigationItem setRightBarButtonItem:[[[UIBarButtonItem alloc]
                                                     initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                     target:self
                                                     action:@selector(editDone:)] autorelease]
                                         animated:animated];
    } else {
        [self.navigationItem setLeftBarButtonItem:nil animated:animated];
        [self.navigationItem setRightBarButtonItem:[[[UIBarButtonItem alloc]
                                                     initWithBarButtonSystemItem:UIBarButtonSystemItemEdit
                                                     target:self
                                                     action:@selector(editAction:)] autorelease]
                                          animated:animated];
    }
}

- (BOOL)isModal {
    return self.navigationController.parentViewController ? YES : NO;
}

- (void)editAction:(id)sender {
    [self setEditing:YES animated:YES];
}

- (void)editDone:(id)sender {
    [self setEditing:NO animated:YES];
    
    if ([self isModal]) {
        [self dismissModalViewControllerAnimated:YES];
    }
}

- (void)editCancel:(id)sender {
    [self setEditing:NO animated:YES];
    
    if ([self isModal]) {
        [managedObject.managedObjectContext deleteObject:managedObject];
        [self dismissModalViewControllerAnimated:YES];
    }
}

- (void)dealloc {
    [managedObject release];
    [super dealloc];
}

@end


////////////////////////////////////////////////////////////////////////////////
//
// Edit Property ViewController
//
////////////////////////////////////////////////////////////////////////////////
@implementation EditCrudPropertyViewController

@synthesize managedObject;
@synthesize keyName;

- (void)viewDidLoad {
    self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc]
                                              initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                              target:self
                                              action:@selector(editCancel:)] autorelease];
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc]
                                               initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                               target:self
                                               action:@selector(editDone:)] autorelease];
}

- (void) setUp:(NSManagedObject*)aManagedObject keyName:(NSString*)aKeyName {
    self.managedObject = aManagedObject;
    self.keyName = aKeyName;
    valueInput.text = [[aManagedObject valueForKey:aKeyName] description];
    validationError.hidden = YES;
    self.navigationItem.title = aKeyName;
}

- (NSAttributeType)typeByKeyName:(NSString*)aKeyName {
    NSEntityDescription *entity = [managedObject entity];
    NSDictionary *attributes = [entity attributesByName];
    
    NSAttributeDescription *attribute = [attributes valueForKey:aKeyName];
    
    return [attribute attributeType];
}

- (id)toValueObjectFrom:(NSString*)stringValue keyName:(NSString*)aKeyName{
    NSAttributeType type = [self typeByKeyName:aKeyName];
    
    if (type == NSInteger16AttributeType) {
        return [NSNumber numberWithInteger:[stringValue integerValue]];
    } else if (type == NSInteger32AttributeType) {
        return [NSNumber numberWithInteger:[stringValue integerValue]];
    } else if (type == NSInteger64AttributeType) {
        return [NSNumber numberWithInteger:[stringValue integerValue]];
    } else if (type == NSDecimalAttributeType) {
        return [NSNumber numberWithInteger:[stringValue integerValue]];
    } else if (type == NSDoubleAttributeType) {
        return [NSNumber numberWithDouble:[stringValue doubleValue]];
    } else if (type == NSFloatAttributeType) {
        return [NSNumber numberWithFloat:[stringValue floatValue]];
    } else if (type == NSStringAttributeType) {
        return stringValue;
    } else if (type == NSBooleanAttributeType) {
        return [NSNumber numberWithBool:[stringValue boolValue]];
    } else if (type == NSDateAttributeType) {
        NSDateFormatter *formatter = [[[NSDateFormatter alloc] init] autorelease];
        [formatter setTimeStyle:NSDateFormatterFullStyle];
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss Z"];
        NSDate *date = [formatter dateFromString:stringValue];
        if (date == nil) {
            NSException *exception = [NSException exceptionWithName:@"CanNotFormatException"
                                                             reason:@"string value is not formatted." userInfo:nil];
            @throw exception;
        }
        return date;
    } else {
        return stringValue;
    }
}

- (void)setValueFromValueInput {
    [managedObject setValue:[self toValueObjectFrom:valueInput.text keyName:self.keyName] forKey:self.keyName];
}

- (void)editCancel:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)editDone:(id)sender {
    @try {
        [self setValueFromValueInput];
        [self.navigationController popViewControllerAnimated:YES];
    }
    @catch (NSException *exception) {
        if([[exception name] isEqual:@"CanNotFormatException"]) {
            validationError.hidden = NO;
        } else {
            @throw;
        }
    }
    @finally {
    }
}

- (void)dealloc {
    [managedObject release];
    [keyName release];
    [super dealloc];
}

@end

