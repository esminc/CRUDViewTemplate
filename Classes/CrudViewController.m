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

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSError *error;
	if (![[self fetchedResultsController] performFetch:&error]) {
		// Handle the error...
	}
    
    NSEntityDescription *entity = [[self.fetchedResultsController fetchRequest] entity];
    self.title = [[entity name] stringByAppendingString: @" List"];
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

#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [[[self fetchedResultsController] sections] count];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	id <NSFetchedResultsSectionInfo> sectionInfo = [[[self fetchedResultsController] sections] objectAtIndex:section];
    return [sectionInfo numberOfObjects];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
	// Configure the cell.
    NSManagedObject *managedObject = [[self fetchedResultsController] objectAtIndexPath:indexPath];
    cell.textLabel.text = [[managedObject valueForKey:[[self attributeNames] objectAtIndex:0]] description];
	
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
	// AnotherViewController *anotherViewController = [[AnotherViewController alloc] initWithNibName:@"AnotherView" bundle:nil];
	// [self.navigationController pushViewController:anotherViewController];
	// [anotherViewController release];
    
    // DetailedCrudViewController *DetailedCrudViewController = [[DetailedCrudViewController alloc] initWithNibName:@"DetailedCrudViewController" bundle:nil];
    // DetailedCrudViewController.managedObject = [[self fetchedResultsController] objectAtIndexPath:indexPath];
    
    detailedViewController.managedObject = [[self fetchedResultsController] objectAtIndexPath:indexPath];
    
    [self.navigationController pushViewController:detailedViewController animated:YES];
    
    // [DetailedCrudViewController release];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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
    [detailedViewController release];
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

- (NSString *) title {
    return [[[managedObject entity] name] stringByAppendingString: @" Detail"];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
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

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSArray *names;
    
    if (names = [listedViewController attributeShowingNames]) {
        return [names objectAtIndex:section];
    } else {
        return [self attributeNameAtSectionIndex:section];
    }
}

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Set up the cell...
    
    int section = [indexPath section];
    // int row = [indexPath row];
   
    cell.textLabel.text = [[managedObject valueForKey:[self attributeNameAtSectionIndex:section]] description];
	
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
	// AnotherViewController *anotherViewController = [[AnotherViewController alloc] initWithNibName:@"AnotherView" bundle:nil];
	// [self.navigationController pushViewController:anotherViewController];
	// [anotherViewController release];
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/


/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
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
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/


/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

- (void)dealloc {
    [managedObject release];
    [listedViewController release];
    [super dealloc];
}


@end

