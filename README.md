# mas-purchases.sh
Take HTML of Mac App Store “Purchased” page and convert it an alphabetical list (HTML page and MultiMarkdown)

## Have you ever wanted…

…to be able to search through your Mac App Store purchases? Or see them in an alphabetized list? Maybe you just wanted a quick way to find the links to them.

The App Store app will *show* you your purchases, but it uses a Reverse Chronological list (newest on top). There's no way to search, and there’s no way to sort alphabetically.

That’s where this script comes in.

## How To Use This Script

1. You **MUST** have the “Debug” menu enabled in the App Store app. This can be done very simply:
	* quit the App Store app (if it is running)
	* paste this line into Terminal.app: 

		`defaults write com.apple.appstore ShowDebugMenu -bool true`

2. 	You will also need the `multimarkdown` tool. 

	* If you use [Homebrew](http://mxcl.github.com/homebrew/), just use

		`brew install multimarkdown`

	* if you don’t use `brew`, then get the “Mac Installer” from <http://fletcherpenney.net/multimarkdown/download/> and install it that way.

3. Then, simply launch the App Store app, click on the “Purchased” tab (label “1” in the image below), then the “Debug” menu (label “2”), and “Save page source to disk” (label “3”):
 
<img src='https://raw.githubusercontent.com/tjluoma/mas-purchases.sh/master/img/MAS-Debug-Save-Page-Source.jpg' width='750'>

That will create an HTML page at `~/Library/Containers/com.apple.appstore/Data/Library/Documentation/pageSource.html` on your Mac, but it’s heinously ugly.

That’s why I wrote this script.

## How do I get/install this script?

If you don’t have a folder where you keep scripts (such as `/usr/local/bin/`) you can just download it to your Desktop. These 4 lines will download the file, make it executable, and run it: 

		cd ~/Desktop/
	
		curl -fLO http://luo.ma/mas-purchases.sh

		chmod 755 mas-purchases.sh

		./mas-purchases.sh

That's it! You can copy and paste those lines into Terminal.app if you want to make sure to avoid any typos.

It will check to make sure that the “pageSource.html” file (above) is in the right place. If it is, the script will run and open the resulting HTML file in Safari.

If you want to use a different browser, just edit the script and change this line:

		BROWSER='Safari'

to

		BROWSER='Google Chrome'

or whichever browser you prefer.

## Do you use Keyboard Maestro?

If so, you might want to check out [this Keyboard Maestro macro](https://forum.keyboardmaestro.com/t/export-mac-app-store-purchases-to-html-macro/2160) which uses this same script and will walk you through the whole process. The Keyboard Maestro macro already includes this script, so you do not need to download it unless you want to use it outside of Keyboard Maestro.


