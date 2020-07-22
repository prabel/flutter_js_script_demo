function js_function(message) {
  var Web3 = require('web3');
  var web3 = new Web3();
  var account = web3.eth.accounts.create();
  var signedMessage = web3.eth.accounts.sign(message, account.privateKey);
  return signedMessage;
}

js_function('test_message');