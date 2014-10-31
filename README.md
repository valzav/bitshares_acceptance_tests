# BitShares Acceptance Testing

This repository holds the BitShares acceptance tests implemented on top of Ruby's cucumber framework.

## Installation
Install Ruby and bundler gem:

  $ apt-get install ruby
  $ gem install bundler
  
Now you can install all dependencies by typing 'bundle' inside bitshares_acceptance_tests dir.
 
Next define environment variable BTS_BUILD with path to your bitshares toolkit's build directory, e.g.:

  $ export BTS_BUILD=/home/user/bitshares/bitshares_toolkit
  
## Using
  
Bootstrap the test net:

  $ ruby testnet.rb
  
After a little while your test net is ready and you can run tests (features) via 'cucumber' command.
