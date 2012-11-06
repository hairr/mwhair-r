#################################################################################
## MWHair-r - Mediawiki wrapper
## Description - This is a mediawiki client written by Hairr <hairrazerrr@gmail.com>
## It was orignally created to be used at http://runescape.wikia.com/
##
## This library is free software; you can redistribute it and/or modify it under
## the terms of the GNU Lesser General Public License as published by the Free
## Software Foundation; either version 2.1 of the License, or (at your option)
## any later version.
##
## This library is distributed in the hope that it will be useful, but WITHOUT
## ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
## FOR A PARTICULAR PURPOSE.  See the GNU Lesser General Public License for more
## details.
##
## You should have received a copy of the GNU General Public License along with
## this program.  If not, see <http://www.gnu.org/licenses/>.

library(RCurl)
library(rjson)

version <- '1.0'

wiki <- function(apiURL, verbose=FALSE){
  # description: Sets up the wiki linking to the api
  # use:
  # source('mwhair-r.r')
  # bot1 = wiki('http://en.wikipedia.org/w/api.php') # example with wikipedia
  # To use this on the other functions; for example with login:
  # login('Username','password',bot1)
  # This allows use for other wikis
  curlOpts = curlOptions(verbose=verbose,
                         header=TRUE, 
                         cookiefile="cookies.txt",
                         cookiejar="cookies.txt")
  
  bot = list(apiURL, curlOpts)
  names(bot) = c("apiURL", "curlOpts")
  return(bot)
}

tokens <- function(token, bot) {
  # description: Gets specific tokens for actions
  # use:
  # This isn't supposed to be used on personal scripts
  if (token == 'edit') {
    edit_token_data = postForm(bot$apiURL,
                          action='query',
                          prop='info',
                          titles='Main Page',
                          intoken='edit',
                          format='json',
                          .opts=bot$curlOpts)
    response = fromJSON(edit_token_data)
    edit_token = unique(unlist(response))[9]
    return(edit_token)
  }
}

login <- function(username, password, bot) {
  # description: Used to login to the wiki
  # use:
  # source('mwhair-r.r')
  # login('Username','Password',bot)
  login_data = postForm(bot$apiURL,
                        action='login',
                        lgname=username,
                        lgpassword=password,
                        format='json',
                        .opts=bot$curlOpts)
  response = fromJSON(login_data)
  token = response$login$token
  login_data_2 = postForm(bot$apiURL,
                          action='login',
                          lgname=username,
                          lgpassword=password,
                          lgtoken=token,
                          format='json',
                          .opts=bot$curlOpts)
  response = fromJSON(login_data_2)
  if (response$login$result == 'Success') {
    cat('Now logged in as ',response$login$lgusername)
  } else {
    cat('Error occured:', response$login$result)
  }
}

edit <- function(title, bot){
  # description: Gets page contents
  # use:
  # source('mwhair-r.r')
  # text = edit('Foo')
  edit_data = postForm(bot$apiURL,
                      action="query",
                      prop="revisions",
                      rvlimit="1",
                      rvprop="content",
                      format="json",
                      titles=title,
                      .opts=bot$curlOpts)
  content <- unique(unlist(fromJSON(edit_data), use.names = FALSE))[4]
  return(content)
}

save <- function(title, text, bot) {
  # description: Saves a page with specified text
  # use:
  # source('mwhair-r.r')
  # save('Foo','The new text is seen here', bot)
  # Tip: To append (or prepend) text, use:
  # paste(c(pagetext, 'appended text'), collapse="")
  save_data = postForm(bot$apiURL,
                       action='edit',
                       title=title,
                       text=text,
                       format='json',
                       token=tokens('edit',bot),
                       .opts=bot$curlOpts)
  return(TRUE)
}