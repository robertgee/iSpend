/*
     File: MyDocument_Toolbar.m
 Abstract: This category implements toolbar support for MyDocument
  Version: 1.2
 
 Disclaimer: IMPORTANT:  This Apple software is supplied to you by Apple
 Inc. ("Apple") in consideration of your agreement to the following
 terms, and your use, installation, modification or redistribution of
 this Apple software constitutes acceptance of these terms.  If you do
 not agree with these terms, please do not use, install, modify or
 redistribute this Apple software.
 
 In consideration of your agreement to abide by the following terms, and
 subject to these terms, Apple grants you a personal, non-exclusive
 license, under Apple's copyrights in this original Apple software (the
 "Apple Software"), to use, reproduce, modify and redistribute the Apple
 Software, with or without modifications, in source and/or binary forms;
 provided that if you redistribute the Apple Software in its entirety and
 without modifications, you must retain this notice and the following
 text and disclaimers in all such redistributions of the Apple Software.
 Neither the name, trademarks, service marks or logos of Apple Inc. may
 be used to endorse or promote products derived from the Apple Software
 without specific prior written permission from Apple.  Except as
 expressly stated in this notice, no other rights or licenses, express or
 implied, are granted by Apple herein, including but not limited to any
 patent rights that may be infringed by your derivative works or by other
 works in which the Apple Software may be incorporated.
 
 The Apple Software is provided by Apple on an "AS IS" basis.  APPLE
 MAKES NO WARRANTIES, EXPRESS OR IMPLIED, INCLUDING WITHOUT LIMITATION
 THE IMPLIED WARRANTIES OF NON-INFRINGEMENT, MERCHANTABILITY AND FITNESS
 FOR A PARTICULAR PURPOSE, REGARDING THE APPLE SOFTWARE OR ITS USE AND
 OPERATION ALONE OR IN COMBINATION WITH YOUR PRODUCTS.
 
 IN NO EVENT SHALL APPLE BE LIABLE FOR ANY SPECIAL, INDIRECT, INCIDENTAL
 OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
 SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
 INTERRUPTION) ARISING IN ANY WAY OUT OF THE USE, REPRODUCTION,
 MODIFICATION AND/OR DISTRIBUTION OF THE APPLE SOFTWARE, HOWEVER CAUSED
 AND WHETHER UNDER THEORY OF CONTRACT, TORT (INCLUDING NEGLIGENCE),
 STRICT LIABILITY OR OTHERWISE, EVEN IF APPLE HAS BEEN ADVISED OF THE
 POSSIBILITY OF SUCH DAMAGE.
 
 Copyright (C) 2012 Apple Inc. All Rights Reserved.
 
 */


#import "MyDocument.h"
static NSString *iSpendDocToolbarIdentifier     = @"iSpend Document Toolbar Identifier";
static NSString *AddItemToolbarItemIdentifier   = @"Add Item Identifier";
static NSString *DeleteItemToolbarItemIdentifier = @"Delete Item Identifier";
static NSString *SaveDocToolbarItemIdentifier     = @"Save Document Item Identifier";
static NSString *SearchToolbarItemIdentifier = @"Search Item Identifier";

@implementation MyDocument(Toolbar)

// ============================================================
// NSToolbar Related Methods
// ============================================================
- (void)setupToolbarForWindow:(NSWindow *)theWindow {
    // Create a new toolbar instance, and attach it to our document window 
    NSToolbar *toolbar = [[NSToolbar alloc] initWithIdentifier: iSpendDocToolbarIdentifier];

    // Set up toolbar properties: Allow customization, give a default display mode, and remember state in user defaults 
    [toolbar setAllowsUserCustomization: YES];
    [toolbar setAutosavesConfiguration: YES];
    toolbar.displayMode = NSToolbarDisplayModeIconAndLabel;
    
    // We are the delegate
    toolbar.delegate = self;

    // Attach the toolbar to the document window 
    theWindow.toolbar = toolbar;
}

- (NSToolbarItem *)toolbar:(NSToolbar *)toolbar itemForItemIdentifier:(NSString *)itemIdent willBeInsertedIntoToolbar:(BOOL)willBeInserted {
    // Required delegate method:  Given an item identifier, this method returns an item 
    // The toolbar will use this method to obtain toolbar items that can be displayed in the customization sheet, or in the toolbar itself 
    NSToolbarItem *toolbarItem = [[NSToolbarItem alloc] initWithItemIdentifier: itemIdent];

    if ([itemIdent isEqual:AddItemToolbarItemIdentifier]) {
        // Set the text label to be displayed in the toolbar and customization palette 
        toolbarItem.label = @"Add";
        toolbarItem.paletteLabel = @"Add";
        
        // Set up a reasonable tooltip, and image   Note, these aren't localized, but you will likely want to localize many of the item's properties 
        toolbarItem.toolTip = @"Add New Transaction";
        toolbarItem.image = [NSImage imageNamed: @"add"];

        // Tell the item what message to send when it is clicked 
        toolbarItem.target = self;
        toolbarItem.action = @selector(add:);
        
    } else if ([itemIdent isEqual:DeleteItemToolbarItemIdentifier]) {
        // Set the text label to be displayed in the toolbar and customization palette 
        toolbarItem.label = @"Delete";
        toolbarItem.paletteLabel = @"Delete";
        
        // Set up a reasonable tooltip, and image   Note, these aren't localized, but you will likely want to localize many of the item's properties 
        toolbarItem.toolTip = @"Delete Transaction";
        toolbarItem.image = [NSImage imageNamed: @"delete"];
        
        // Tell the item what message to send when it is clicked 
        toolbarItem.target = self;
        toolbarItem.action = @selector(delete:);
        
    } else if ([itemIdent isEqual:SaveDocToolbarItemIdentifier]) {        
        // Set the text label to be displayed in the toolbar and customization palette 
        toolbarItem.label = @"Save";
        toolbarItem.paletteLabel = @"Save";
        
        // Set up a reasonable tooltip, and image   Note, these aren't localized, but you will likely want to localize many of the item's properties 
        toolbarItem.toolTip = @"Save Your Document";
        toolbarItem.image = [NSImage imageNamed: @"save"];
        
        // Tell the item what message to send when it is clicked 
        toolbarItem.target = self;
        toolbarItem.action = @selector(saveDocument:);
        
    } else if([itemIdent isEqual: SearchToolbarItemIdentifier]) {
        // Set up the standard properties 
        toolbarItem.label = @"Search";
        toolbarItem.paletteLabel = @"Search";
        toolbarItem.toolTip = @"Search Your Document";
        
        // Use a custom view, an NSSearchField, in the toolbar item
        toolbarItem.view = searchFieldOutlet;
        
        toolbarItem.minSize = NSMakeSize(30, NSHeight(searchFieldOutlet.frame));
        toolbarItem.maxSize = NSMakeSize(400,NSHeight(searchFieldOutlet.frame));
        
    } else {
        // itemIdent refered to a toolbar item that is not provide or supported by us or cocoa 
        // Returning nil will inform the toolbar this kind of item is not supported 
        toolbarItem = nil;
    }
    return toolbarItem;
}

- (NSArray *)toolbarDefaultItemIdentifiers:(NSToolbar*)toolbar {
    /* Required method.  Returns the ordered list of items to be shown in the toolbar by default.   If during initialization, no overriding values are found in the user defaults, or if the user chooses to revert to the default items this set will be used. */
    return @[AddItemToolbarItemIdentifier, DeleteItemToolbarItemIdentifier,
            NSToolbarFlexibleSpaceItemIdentifier, NSToolbarSeparatorItemIdentifier, 
            SaveDocToolbarItemIdentifier, SearchToolbarItemIdentifier];
}

- (NSArray *)toolbarAllowedItemIdentifiers:(NSToolbar*)toolbar {
    /* Required method.  Returns the list of all allowed items by identifier.  By default, the toolbar does not assume any items are allowed, even the separator.  So, every allowed item must be explicitly listed.  The set of allowed items is used to construct the customization palette.  The order of items does not necessarily guarantee the order of appearance in the palette.  At minimum, you should return the default item list.*/
    return @[AddItemToolbarItemIdentifier, DeleteItemToolbarItemIdentifier, SaveDocToolbarItemIdentifier,
            NSToolbarFlexibleSpaceItemIdentifier, NSToolbarSpaceItemIdentifier, 
            NSToolbarSeparatorItemIdentifier, NSToolbarCustomizeToolbarItemIdentifier,
            NSToolbarShowFontsItemIdentifier, NSToolbarShowColorsItemIdentifier, NSToolbarPrintItemIdentifier, SearchToolbarItemIdentifier];
}

- (BOOL)validateToolbarItem:(NSToolbarItem *)toolbarItem {
    /* NSToolbarItemValidation extends the standard validation idea by introducing this new method which is sent to validators for each visible standard NSToolbarItem with a valid target/action pair.  Note: This message is sent from NSToolbarItem's validate method, howevever validate will not send this message for items that have custom views. */
    BOOL enable = NO;
    if ([toolbarItem.itemIdentifier isEqual:AddItemToolbarItemIdentifier]) {
        enable = YES;
    } else if ([toolbarItem.itemIdentifier isEqual:DeleteItemToolbarItemIdentifier]) {
        enable = ([_transactionController selectedObjects].count > 0);
    } else if ([toolbarItem.itemIdentifier isEqual:SaveDocToolbarItemIdentifier]) {
        enable = YES;
    } else if ([toolbarItem.itemIdentifier isEqual:SearchToolbarItemIdentifier]) {
        enable = YES;
    }    
    return enable;
}

@end
