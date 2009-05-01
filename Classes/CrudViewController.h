//
//  «FILENAME»
//  «PROJECTNAME»
//
//  Created by «FULLUSERNAME» on «DATE».
//  Copyright «YEAR» «ORGANIZATIONNAME». All rights reserved.
//

////////////////////////////////////////////////////////////////////////////////
//
// Listeded ViewController
//
////////////////////////////////////////////////////////////////////////////////
@class DetailedCrudViewController;

@interface ListedCrudViewController : UIViewController <UITableViewDelegate, UITableViewDataSource> {
    NSFetchedResultsController *fetchedResultsController;
    IBOutlet DetailedCrudViewController *detailedViewController;
}

@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;

- (NSArray *)attributeNames;
- (NSArray *)attributeShowingOrder;
- (NSArray *)attributeShowingNames;

@end


////////////////////////////////////////////////////////////////////////////////
//
// Detailed ViewController
//
////////////////////////////////////////////////////////////////////////////////
@interface DetailedCrudViewController : UIViewController <UITableViewDelegate, UITableViewDataSource> {
    NSManagedObject* managedObject;
    IBOutlet ListedCrudViewController *listedViewController;
}

@property (nonatomic, retain) NSManagedObject *managedObject;

@end

