//
//  CrudViewTemplateAppDelegate.m
//  CrudViewTemplate
//
//  Created by MORITA Hideyuki on 09/04/28.
//  Copyright Eiwa System Management, Inc 2009. All rights reserved.
//

#import "CrudViewTemplateAppDelegate.h"

#import "CrudViewController.h"

@implementation CrudViewTemplateAppDelegate

@synthesize window;


#pragma mark -
#pragma mark Application lifecycle

- (void)applicationDidFinishLaunching:(UIApplication *)application {    
    
    CrudViewController *crudViewController = [[CrudViewController alloc] init];
    
    // Create the fetch request for the entity.
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
	// Edit the entity name as appropriate.
	NSEntityDescription *entity = [NSEntityDescription entityForName:@"Event" inManagedObjectContext:self.managedObjectContext];
	[fetchRequest setEntity:entity];
	
	// Edit the sort key as appropriate.
	NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"timeStamp" ascending:YES];
	NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
	
	[fetchRequest setSortDescriptors:sortDescriptors];
	
	// Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
	NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:managedObjectContext sectionNameKeyPath:nil cacheName:@"Root"];
    // aFetchedResultsController.delegate = self;
	
    crudViewController.fetchedResultsController = aFetchedResultsController;
    
    [navigationController pushViewController:crudViewController animated:YES];
    
    NSManagedObject *event = (NSManagedObject *)[NSEntityDescription insertNewObjectForEntityForName: @"Event" inManagedObjectContext: self.managedObjectContext];
    [event setValue:@"HOGE FUGA" forKey:@"title"];
    [event setValue:[NSDate date] forKey:@"timeStamp"];
    
    [window addSubview:[navigationController view]];
	[window makeKeyAndVisible];

	[aFetchedResultsController release];
	[fetchRequest release];
	[sortDescriptor release];
	[sortDescriptors release];
}

/**
 applicationWillTerminate: saves changes in the application's managed object context before the application terminates.
 */
- (void)applicationWillTerminate:(UIApplication *)application {
	
    NSError *error;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
			// Handle error
			NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
			exit(-1);  // Fail
        } 
    }
}


#pragma mark -
#pragma mark Saving

/**
 Performs the save action for the application, which is to send the save:
 message to the application's managed object context.
 */
- (IBAction)saveAction:(id)sender {
	
    NSError *error;
    if (![[self managedObjectContext] save:&error]) {
		// Handle error
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		exit(-1);  // Fail
    }
}


#pragma mark -
#pragma mark Core Data stack

/**
 Returns the managed object context for the application.
 If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
 */
- (NSManagedObjectContext *) managedObjectContext {
	
    if (managedObjectContext != nil) {
        return managedObjectContext;
    }
	
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        managedObjectContext = [[NSManagedObjectContext alloc] init];
        [managedObjectContext setPersistentStoreCoordinator: coordinator];
    }
    return managedObjectContext;
}


/**
 Returns the managed object model for the application.
 If the model doesn't already exist, it is created by merging all of the models found in the application bundle.
 */
- (NSManagedObjectModel *)managedObjectModel {
	
    if (managedObjectModel != nil) {
        return managedObjectModel;
    }
    managedObjectModel = [[NSManagedObjectModel mergedModelFromBundles:nil] retain];    
    return managedObjectModel;
}


/**
 Returns the persistent store coordinator for the application.
 If the coordinator doesn't already exist, it is created and the application's store added to it.
 */
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
	
    if (persistentStoreCoordinator != nil) {
        return persistentStoreCoordinator;
    }
	
    NSURL *storeUrl = [NSURL fileURLWithPath: [[self applicationDocumentsDirectory] stringByAppendingPathComponent: @"CrudViewTemplate.sqlite"]];
	
	NSError *error;
    persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel: [self managedObjectModel]];
    if (![persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeUrl options:nil error:&error]) {
        // Handle error
    }    
	
    return persistentStoreCoordinator;
}


#pragma mark -
#pragma mark Application's documents directory

/**
 Returns the path to the application's documents directory.
 */
- (NSString *)applicationDocumentsDirectory {
	
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
    return basePath;
}


#pragma mark -
#pragma mark Memory management

- (void)dealloc {
	
    [managedObjectContext release];
    [managedObjectModel release];
    [persistentStoreCoordinator release];
    
	[window release];
	[super dealloc];
}


@end

