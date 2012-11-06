A MediaWiki client made in R for mediawiki.

Usage
======
To set up a script, begin by specifying your wiki's api (i'll be using wikipedia as an example so it might not match your api url exactly):

    bot = wiki('http://en.wikipedia.org/w/api.php')

This will set bot as your wiki's api. Now that the site is set up, you should login.

    login('Foo','Bar',bot)

'bot' is the variable that contains the wiki information so if you set it as something different, it shouldn't be specified as bot in the function. 

If you wanted to edit a page, do the following:

    text = edit('Foo',bot)

Again, bot is the variable and should be used accordingly.  In this example, Foo is the title. The text can be modified from this now or can be used for data... or anything you are planning to do with it.  

If you want to save the text to a page, do the following:

    save('Foo',text,bot)

In this example, 'Foo' is the title, text is the variable metioned above and bot is the variable for the wiki.  Though if no change is made to the text, no change will be made to the page.

History
========
The following will show as the script gets updated.  If you do not have the most recent version, consider updating.  The latest version will be included in the source too for reference.

Version 1.0 - Getting script set up. Has initial wiki function, login, edit and save functions.