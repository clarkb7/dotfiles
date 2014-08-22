#xscreensaver is not detecting full-screen applications, so I run this to prevent
#  the screensaver from activating during movies.

import os
import time
while 1==1:
   os.system("xscreensaver-command -deactivate")
   time.sleep(5*60)

