//
//  CrudListViewController.h
//  CrudView
//
//  Created by MORITA Hideyuki on 09/04/27.
//  Copyright 2009 Eiwa System Management, Inc. All rights reserved.
//

@class CrudDetailViewController;

@interface CrudListViewController : UIViewController <UITableViewDelegate, UITableViewDataSource> {
    NSFetchedResultsController *fetchedResultsController;
    IBOutlet CrudDetailViewController *detailViewController;
}

@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;

- (NSArray *)attributeShowingOrder;
- (NSArray *)attributeShowingNames;

@end
