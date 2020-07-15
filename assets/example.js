function js_function(message) {
   var web3 = new Web3();
  var account = web3.eth.accounts.create();
  var signedMessage = web3.eth.accounts.sign(message, account.privateKey);
  return signedMessage;
}

function dart_function() {
  return js_function(message);
}

js_function('test_message');