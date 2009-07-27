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

@interface ListedCrudViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate> {
    NSFetchedResultsController *fetchedResultsController;
    IBOutlet DetailedCrudViewController *detailedViewController;
    IBOutlet UITableView *tableView;
    UIBarButtonItem *addButton;
    UIBarButtonItem *editButton;
    UIBarButtonItem *doneEditingButton;    
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
@class EditCrudPropertyViewController;

@interface DetailedCrudViewController : UIViewController <UITableViewDelegate, UITableViewDataSource> {
    NSManagedObject* managedObject;
    IBOutlet ListedCrudViewController *listedViewController;
    IBOutlet EditCrudPropertyViewController *editPropertyViewController;
    IBOutlet UITableView *tableView;
}

@property (nonatomic, retain) NSManagedObject *managedObject;

@end

////////////////////////////////////////////////////////////////////////////////
//
// Edit Property ViewController
//
////////////////////////////////////////////////////////////////////////////////
@interface EditCrudPropertyViewController : UIViewController {
    NSManagedObject *managedObject;
    NSString *keyName;
    IBOutlet UILabel *label;
    IBOutlet UITextField *valueInput;
    IBOutlet UILabel *validationError;
}

- (void) setUp:(NSManagedObject*)aManagedObject keyName:(NSString*)aKeyName;

@property (nonatomic, retain) NSManagedObject *managedObject;
@property (nonatomic, retain) NSString *keyName;

@end