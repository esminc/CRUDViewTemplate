//
//  «FILENAME»
//  «PROJECTNAME»
//
//  Created by «FULLUSERNAME» on «DATE».
//  Copyright «YEAR» «ORGANIZATIONNAME». All rights reserved.
//

@class DetailedCrudViewController;

@interface CrudViewController : UIViewController <UITableViewDelegate, UITableViewDataSource> {
    NSFetchedResultsController *fetchedResultsController;
    IBOutlet DetailedCrudViewController *detailViewController;
}

@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;

- (NSArray *)attributeShowingOrder;
- (NSArray *)attributeShowingNames;

@end
