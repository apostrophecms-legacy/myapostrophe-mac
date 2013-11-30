# myapostrophe-mac

This is a REALLY simple way to install Apostrophe 2 on a Mac. But if you have a Windows or Linux system, you can still use Apostrophe! We run it on Linux every day. Just [check out the Apostrophe sandbox documentation.](http://github.com/punkave/apostrophe-sandbox)

Mac Pros who dig node, macports, homebrew and the command line will probably want to [go straight to the sandbox project too.](http://github.com/punkave/apostrophe-sandbox)

## Installing the Apostrophe Sandbox on Your Mac

**One line install:** just run this command! Be sure to copy and paste this to your terminal window as **one line**:

    curl -L -o apos-install.sh https://raw.github.com/punkave/myapostrophe/master/install.sh && sh apos-install.sh

The installer will download everything you need, then launch the Apostrophe sandbox site, running on your computer. It'll even open your browser so you can check it out.

Your shiny new Apostrophe site will live here:

    ~/myapostrophe/sites/apostrophe-sandbox

(That "~" means "my personal home directory." In the terminal you can always get there by typing "cd ~" and pressing enter.)

You can shut it down at any time by pressing control-C in the terminal window.

### Starting Up Again Later

To start it up again later, type:

    apos-start

In a terminal window. Now visit:

http://localhost:3000/

To see your site. You do *not* need to run the installer again.

### Your Second Site

To start another site, copy the `apostrophe-sandbox` folder to another nice, short name with no spaces, like `xyzcorp`. Edit `app.js` and be sure to change `shortname` to match. Then you can type:

    apos-start xyzcorp

(Note: you can't run two sites at once this way, unless you change the port number for one of them. TODO: make this easy too.)

### Updating Apostrophe

You can update to the latest Apostrophe version for any of your projects by using the `cd` command to enter the folder for that site, then typing `npm update`.

### Making Changes

You can change the appearance of your site by editing `public/css/site.less`, `public/css/site.js`, `views/layout.html`, `views/default.html`, `views/home.html` and more. Some changes require restarting the site. See the [sandbox documentation](http://github.com/punkave/apostrophe-sandbox) for more information.

To further enhance your sites, deploy them and everything else... well, time to [start reading the Apostrophe sandbox docs](http://github.com/punkave/apostrophe-sandbox)!

