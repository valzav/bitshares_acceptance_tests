# BitShares Acceptance Testing

This repository holds the BitShares acceptance tests implemented on top of Ruby's cucumber framework.

## Installation
Install Ruby and bundler gem:

  $ apt-get install ruby
  $ gem install bundler
  
Now you can install all dependencies by typing 'bundle' inside bitshares_acceptance_tests dir.
 
Next define environment variable BTS_BUILD with path to your bitshares toolkit's build directory, e.g.:

  $ export BTS_BUILD=/home/user/bitshares/bitshares_toolkit
  
## Usage
  
Bootstrap the test net:

  $ ruby testnet.rb
  
After a little while your test net is ready and you can run tests (features) via 'cucumber' command.

Please note that after all the tests it doesn't exit until you press any key, while it's running you can access the nodes via http on the following ports:

delegate node: port 5690

alice's node: port 5691

bob's node: port 5692


You can access these nodes via web wallet if you create htdocs symlink to web_wallet/generated or to web_wallet/build, e.g. 

  $ ln -s ../web_wallet/generated htdocs
  
And open http://localhost:5690 (or 5691/5692) in your browser.
