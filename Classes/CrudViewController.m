//
//  «FILENAME»
//  «PROJECTNAME»
//
//  Created by «FULLUSERNAME» on «DATE».
//  Copyright «YEAR» «ORGANIZATIONNAME». All rights reserved.
//

#import "CrudViewController.h"

#import "DetailedCrudViewController.h"

@implementation CrudViewController

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

	cell.textLabel.text = [[managedObject valueForKey:@"title"] description];
	
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
	// AnotherViewController *anotherViewController = [[AnotherViewController alloc] initWithNibName:@"AnotherView" bundle:nil];
	// [self.navigationController pushViewController:anotherViewController];
	// [anotherViewController release];
    
    // DetailedCrudViewController *DetailedCrudViewController = [[DetailedCrudViewController alloc] initWithNibName:@"DetailedCrudViewController" bundle:nil];
    // DetailedCrudViewController.managedObject = [[self fetchedResultsController] objectAtIndexPath:indexPath];
    
    detailViewController.managedObject = [[self fetchedResultsController] objectAtIndexPath:indexPath];
    
    [self.navigationController pushViewController:detailViewController animated:YES];
    
    // [DetailedCrudViewController release];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (NSArray *)attributeShowingOrder {
    return [NSArray arrayWithObjects:@"title", @"timeStamp", nil];
}

- (NSArray *)attributeShowingNames {
    return [NSArray arrayWithObjects:@"Title", @"Time Stamp", nil];
}

- (void)dealloc {
    [fetchedResultsController release];
    [detailViewController release];
    [super dealloc];
}


@end
