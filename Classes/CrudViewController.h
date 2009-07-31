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
    UIBarButtonItem *addButton;
    UIBarButtonItem *editButton;
    UIBarButtonItem *doneEditingButton;
    IBOutlet DetailedCrudViewController *detailedViewController;
    IBOutlet UITableView *tableView;
}

@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, retain) UIBarButtonItem *addButton;
@property (nonatomic, retain) UIBarButtonItem *editButton;
@property (nonatomic, retain) UIBarButtonItem *doneEditingButton;

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
    NSManagedObjectContext *temporaryManagedObjectContext;
    IBOutlet ListedCrudViewController *listedViewController;
    IBOutlet EditCrudPropertyViewController *editPropertyViewController;
    IBOutlet UITableView *tableView;
    BOOL isAdding;
}

@property (nonatomic, retain) NSManagedObject *managedObject;
@property (nonatomic, retain) NSManagedObjectContext *temporaryManagedObjectContext;
@property (nonatomic, assign) BOOL isAdding;

- (void)setupManagedObject:(NSManagedObject*)aManagedObject isAdding:(BOOL)adding;

@end

////////////////////////////////////////////////////////////////////////////////
//
// Edit Property ViewController
//
////////////////////////////////////////////////////////////////////////////////
@interface EditCrudPropertyViewController : UIViewController {
    NSManagedObject *managedObject;
    NSString *keyName;
    IBOutlet UITextField *valueInput;
    IBOutlet UILabel *validationError;
}

- (void) setUp:(NSManagedObject*)aManagedObject keyName:(NSString*)aKeyName;

@property (nonatomic, retain) NSManagedObject *managedObject;
@property (nonatomic, retain) NSString *keyName;

@end