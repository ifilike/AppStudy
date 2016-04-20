#!/bin/sh

#  analytics_gzip.sh
#  SourceTree
#
#  Created by Kieran Senior on 26/11/2013.
#  Copyright (c) 2013 Atlassian. All rights reserved.

#  This will write out to the target directory
gzip -c "$1" > "$2"