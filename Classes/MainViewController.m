//
//  MainViewController.m
//  ttrack
//
//  Created by Christian Hofstaedtler on 06.01.11.
//  Copyright __MyCompanyName__ 2011. All rights reserved.
//

#import "MainViewController.h"


@implementation MainViewController

@synthesize alertLabel, stateLabel, workSwitch, alertImageView, loadingIndicator;

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	[super viewDidLoad];
	
	[loadingIndicator startAnimating];
	[stateLabel setText:@"Loading..."];
	[workSwitch setEnabled:NO];
	
	[[[CHApiRequest alloc] initWithApiName:@"state" method:@"GET" delegate:self] startRequest];
}


- (void)flipsideViewControllerDidFinish:(FlipsideViewController *)controller {
    
	[self dismissModalViewControllerAnimated:YES];
}


- (IBAction)showInfo:(id)sender {    
	
	FlipsideViewController *controller = [[FlipsideViewController alloc] initWithNibName:@"FlipsideView" bundle:nil];
	controller.delegate = self;
	
	controller.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
	[self presentModalViewController:controller animated:YES];
	
	[controller release];
}


- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc. that aren't in use.
}


- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
	
}

// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	// Return YES for supported orientations.
	return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void) workSwitchToggled:(id)sender {
	[workSwitch setEnabled:NO];
	[loadingIndicator startAnimating];
	if ([workSwitch isOn]) {
		[stateLabel setText:[[stateLabel text] stringByAppendingFormat:@" -> busy"]];
		[[[CHApiRequest alloc] initWithApiName:@"start" method:@"POST" delegate:self] startRequest];
	} else {
		[stateLabel setText:[[stateLabel text] stringByAppendingFormat:@" -> done"]];
		[[[CHApiRequest alloc] initWithApiName:@"stop" method:@"POST" delegate:self] startRequest];
	}
}

- (void)dealloc {
	[alertLabel release], [stateLabel release], [workSwitch release], [alertImageView release], [loadingIndicator release];
    [super dealloc];
}

- (void) request:(CHApiRequest *)request doneWithResponse:(NSDictionary *)response {
	/*
	if ([request.apiName isEqualToString:@"state"]) {
	}
	if ([request.apiName isEqualToString:@"start"]) {
	}
	if ([request.apiName isEqualToString:@"stop"]) {
	}
	 */
	
	NSString* state = [response valueForKey:@"state"];
	if (state != nil) {
		// each response should have state, actually.
		[stateLabel setText:state];
		if ([state isEqualToString:@"busy"]) {
			[workSwitch setOn:YES];
		} else {
			[workSwitch setOn:NO];
		}
	}

	NSString* alert = [response valueForKey:@"alert"];
	if (alert != nil) {
		[alertLabel setText:alert];
		[alertImageView setHidden:NO];
		[alertLabel setHidden:NO];
	} else {
		[alertImageView setHidden:YES];
		[alertLabel setHidden:YES];
	}
		
	[loadingIndicator stopAnimating];
	[workSwitch setEnabled:YES];

	[request autorelease];
}

- (void) requestFailed:(CHApiRequest *)request {
	
	if ([request.apiName isEqualToString:@"state"] == NO) {
		UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Request to server failed" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[alert show];
		[alert autorelease];
		
		// try to reload state from the server
		[[[CHApiRequest alloc] initWithApiName:@"state" method:@"GET" delegate:self] startRequest];
	} else {
		[loadingIndicator stopAnimating];
		[workSwitch setEnabled:NO];
		[stateLabel setText:@"unknown"];
	}

	[request autorelease];
}

@end
