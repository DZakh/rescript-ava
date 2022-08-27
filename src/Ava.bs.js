


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

function test(ava, title, implementation) {
  ava(title, implementation);
}

function asyncTest(ava, title, implementation) {
  ava(title, implementation);
}

var Failing = {};

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

export {
  ThrowsException ,
  ExecutionContext ,
  test ,
  asyncTest ,
  Failing ,
  Only ,
  Skip$1 as Skip,
  Always ,
  Assert ,
}
/* No side effect */
