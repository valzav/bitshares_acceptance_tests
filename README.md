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


### Note

Testnet is being recreated from scratch before each scenario, so each scenario is started with a clean state.
  
If you want to pause scenarios execution and keep testnet running after scenario to inspect the nodes via http rpc, insert @pause tag before scenario.

In order to access the nodes via web wallet you need to create htdocs symlink to web_wallet/generated or to web_wallet/build, e.g. 

  $ ln -s ../web_wallet/generated htdocs
  
And open http://localhost:5690 (or 5691/5692) in your browser.
