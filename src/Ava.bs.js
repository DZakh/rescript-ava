'use strict';


function make(message, name, is, code, instanceOf, param) {
  var result = {};
  if (message !== undefined) {
    ((result.message = message._0));
  }
  if (name !== undefined) {
    ((result.name = name));
  }
  if (is !== undefined) {
    ((result.is = is));
  }
  if (code !== undefined) {
    ((result.code = code));
  }
  if (instanceOf !== undefined) {
    ((result.instanceOf = instanceOf));
  }
  return result;
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
