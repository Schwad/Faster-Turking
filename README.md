# Faster-Turking
This project in process aims to scrape certain Mechanical Turk forums for quality HITs and open them for the user. This should speed up time between HITs by eliminating scrolling/clicking/searching on forums.

When you fire up the script it will prompt you for the current link you wish to scrape. The CLI will update you on the progress, and also filter out links where there are no more HITs available. It will then use launchy to open the good links 15 at a time, and you just enter a keystroke and hit enter to open another 15 batch until it is done.
