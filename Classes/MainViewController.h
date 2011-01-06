//
//  MainViewController.h
//  ttrack
//
//  Created by Christian Hofstaedtler on 06.01.11.
//  Copyright __MyCompanyName__ 2011. All rights reserved.
//

#import "FlipsideViewController.h"
#import "CHApiRequest.h"

@interface MainViewController : UIViewController <FlipsideViewControllerDelegate, CHApiRequestDelegate> {

	UILabel* alertLabel;
	UILabel* stateLabel;
	UISwitch* workSwitch;
	UIImageView* alertImageView;
	UIActivityIndicatorView* loadingIndicator;

}

@property (nonatomic, retain) IBOutlet UILabel* alertLabel;
@property (nonatomic, retain) IBOutlet UILabel* stateLabel;
@property (nonatomic, retain) IBOutlet UISwitch* workSwitch;
@property (nonatomic, retain) IBOutlet UIImageView* alertImageView;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView* loadingIndicator;


- (IBAction)showInfo:(id)sender;
- (IBAction)workSwitchToggled:(id)sender;

@end
