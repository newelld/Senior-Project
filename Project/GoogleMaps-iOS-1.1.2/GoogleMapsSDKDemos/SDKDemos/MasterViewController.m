#import "SDKDemos/MasterViewController.h"
#import "SDKDemos/SDKDemosAppDelegate.h"

#include <objc/runtime.h>

// The static set of MapSample implementations, created via +initialize.
static NSArray *samples;

@interface UIViewController (Sample)
/**
 * Notes may be optionally implemented by samples to describe their contents.
 */
+ (NSString *)notes;
@end

@implementation MasterViewController {
  BOOL isPhone_;
  UIPopoverController *popover_;
  UIBarButtonItem *samplesButton_;
  __weak UIViewController *controller_;
}

- (id)init {
  if ((self = [super initWithNibName:@"MasterViewController" bundle:nil])) {
    self.title = NSLocalizedString(@"SDKDemos", @"SDKDemos");
    isPhone_ = ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone);
    if (!isPhone_) {
      self.clearsSelectionOnViewWillAppear = NO;
    }
  }
  return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil
               bundle:(NSBundle *)nibBundleOrNil {
  // Create MasterViewController with init.
  [self doesNotRecognizeSelector:_cmd];
  return nil;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  if (!isPhone_) {
    [self loadSample:[samples objectAtIndex:0]];
  }
}

+ (void)initialize {
  samples = [self findAllOf:[UIViewController class]];

  // Filter out this class, as it should not be pushed onto itself.
  id filter = ^(Class class, NSDictionary *bindings) {
    if (class == [self class]) {
      return NO;
    }
    return YES;
  };
  NSPredicate *predicate = [NSPredicate predicateWithBlock:filter];
  samples = [samples filteredArrayUsingPredicate:predicate];
}

// Find all subclasses of |defaultClass| that exist in the same bundle as this
// class (i.e., in the app bundle).
+ (NSArray *)findAllOf:(Class)defaultClass {
  int count = objc_getClassList(NULL, 0);
  if (count <= 0) {
    @throw @"Couldn't retrieve Obj-C class-list";
    return [NSArray arrayWithObject:defaultClass];
  }

  NSBundle *thisBundle = [NSBundle bundleForClass:self];

  NSMutableArray *output = [NSMutableArray array];
  Class *classes = (Class *) malloc(sizeof(Class) * count);
  objc_getClassList(classes, count);
  for (int i = 0; i < count; ++i) {
    Class class = classes[i];
    if ([NSBundle bundleForClass:class] != thisBundle) {
      continue;
    }
    while ((class = class_getSuperclass(class)) != Nil) {
      if (class == defaultClass) {
        [output addObject:classes[i]];
        break;
      }
    }
  }
  free(classes);
  return [NSArray arrayWithArray:output];
}

#pragma mark - UITableViewController

- (NSInteger)tableView:(UITableView *)tableView
    numberOfRowsInSection:(NSInteger)section {
  return [samples count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  static NSString *reusableId = @"Cell";

  UITableViewCell *cell =
      [tableView dequeueReusableCellWithIdentifier:reusableId];
  if (cell == nil) {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                  reuseIdentifier:reusableId];
    if (isPhone_) {
      cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
  }

  // Update the cell with information about the UIViewController being displayed
  // as a sample.
  Class class = [samples objectAtIndex:indexPath.row];
  cell.textLabel.text = [class description];
  NSString *notes = nil;
  if ([class respondsToSelector:@selector(notes)]) {
    notes = [class notes];
  }
  cell.detailTextLabel.text = notes;

  return cell;
}

- (void)tableView:(UITableView *)tableView
    didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  // The user has chosen a sample; load it and clear the selection!
  Class sample = [samples objectAtIndex:indexPath.row];
  [self loadSample:sample];
  [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - Split view

- (void)splitViewController:(UISplitViewController *)splitController
     willHideViewController:(UIViewController *)viewController
          withBarButtonItem:(UIBarButtonItem *)barButtonItem
       forPopoverController:(UIPopoverController *)popoverController {
  popover_ = popoverController;
  samplesButton_ = barButtonItem;
  samplesButton_.title = NSLocalizedString(@"Samples", @"Samples");
  samplesButton_.style = UIBarButtonItemStyleDone;
  [self updateSamplesButton];
}

- (void)splitViewController:(UISplitViewController *)splitController
     willShowViewController:(UIViewController *)viewController
  invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem {
  popover_ = nil;
  samplesButton_ = nil;
  [self updateSamplesButton];
}

#pragma mark - Private methods

- (void)loadSample:(Class)sample {
  UIViewController *controller = [[sample alloc] init];
  controller_ = controller;

  // If the given sample does not have a title, use its static description
  // (which is used in the table view anyway).
  if ([controller.title length] == 0) {
    controller.navigationItem.title = [[sample class] description];
  }

  if (isPhone_) {
    [self.navigationController pushViewController:controller animated:YES];
  } else {
    [self.appDelegate setSample:controller];
    [popover_ dismissPopoverAnimated:YES];
  }
  [self updateSamplesButton];
}

// This method is invoked when the left 'back' button in the split view
// controller on iPad should be updated (either made visible or hidden).
// It assumes that the left bar button item may be safely modified to contain
// the samples button.
- (void)updateSamplesButton {
  controller_.navigationItem.leftBarButtonItem = samplesButton_;
}

@end
