'use strict';


function make(message, messageRe, name, is, code, instanceOf, param) {
  return (function(message, messageRe, name, is, code, instanceOf) {
      var result = {},
        messageParam = message || messageRe;
      if (messageParam) result.message = messageParam;
      if (name) result.name = name;
      if (is) result.is = is;
      if (code) result.code = code;
      if (instanceOf) result.instanceOf = instanceOf;
      return result;
    })(message, messageRe, name, is, code, instanceOf);
}

var ThrowsException = {
  make: make
};

var Skip = {};

var ExecutionContext = {
  Skip: Skip
};

var Only = {};

var Skip$1 = {};

var Skip$2 = {};

var Always = {
  Skip: Skip$2
};

var Skip$3 = {};

var Assert = {
  Skip: Skip$3
};

exports.ThrowsException = ThrowsException;
exports.ExecutionContext = ExecutionContext;
exports.Only = Only;
exports.Skip = Skip$1;
exports.Always = Always;
exports.Assert = Assert;
/* No side effect */
