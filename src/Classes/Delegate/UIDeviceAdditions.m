//
//  UIDeviceAdditions.m
//
//  Created by Giulio Petek on 19.07.10.
//  Copyright 2010 BigRedSofa. All rights reserved.
//
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

#import "UIDeviceAdditions.h"
#include <sys/sysctl.h>  
#include <mach/mach.h>

// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

@implementation UIDevice (UIDeviceAdditions)

// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

- (double)currentMemoryUsage {
        vm_statistics_data_t vmStats;
        mach_msg_type_number_t infoCount = HOST_VM_INFO_COUNT;
        kern_return_t kernReturn = host_statistics(mach_host_self(), HOST_VM_INFO, (host_info_t)&vmStats, &infoCount);
        
        if(kernReturn == KERN_SUCCESS) 
                return vmStats.wire_count/1024.0;
        else return 0;
}

// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

@end