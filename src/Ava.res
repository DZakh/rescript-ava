module ThrowsException = {
  type t
  @live
  type message = String(string) | Re(Js.Re.t) | Fn((~message: string) => bool)

  @live
  let make = (
    ~message: option<message>=?,
    ~name: option<string>=?,
    ~is: option<Js.Exn.t>=?,
    ~code: option<'code>=?,
    ~instanceOf: option<'instanceOf>=?,
    (),
  ): t => {
    let result = %raw(`{}`)
    if message != None {
      %raw(`result.message = message._0`)
    }
    if name != None {
      %raw(`result.name = name`)
    }
    if is != None {
      %raw(`result.is = is`)
    }
    if code != None {
      %raw(`result.code = code`)
    }
    if instanceOf != None {
      %raw(`result.instanceOf = instanceOf`)
    }
    result
  }
}

module ExecutionContext = {
  @live
  type t<'context> = {
    mutable context: 'context,
    title: string,
    passed: bool,
  }

  @send external plan: (t<'context>, int) => unit = "plan"
  @send
  external teardown: (t<'context>, unit => Js.Promise.t<unit>) => Js.Promise.t<unit> = "teardown"
  @send external timeout: (t<'context>, float, ~message: string=?, unit) => unit = "timeout"

  module Skip = {
    @send @scope("plan") external plan: (t<'context>, int) => unit = "skip"
    @send @scope("teardown")
    external teardown: (t<'context>, unit => Js.Promise.t<unit>) => Js.Promise.t<unit> = "skip"
    @send @scope("timeout")
    external timeout: (t<'context>, float, ~message: string=?, unit) => unit = "skip"
  }
}

@live
type meta = {
  file: string,
  snapshotDirectory: string,
}

@module("ava") @scope("default") external meta: meta = "meta"

@module("ava")
external test: (string, ExecutionContext.t<'context> => unit) => unit = "default"
@module("ava")
external asyncTest: (string, ExecutionContext.t<'context> => Js.Promise.t<unit>) => unit = "default"

@module("ava") @scope("default")
external todo: string => unit = "todo"
@module("ava") @scope("default")
external beforeEach: (ExecutionContext.t<'context> => unit) => unit = "beforeEach"
@module("ava") @scope("default")
external asyncBeforeEach: (ExecutionContext.t<'context> => Js.Promise.t<unit>) => unit =
  "beforeEach"
@module("ava") @scope("default")
external before: (ExecutionContext.t<'context> => unit) => unit = "before"
@module("ava") @scope("default")
external asyncBefore: (ExecutionContext.t<'context> => Js.Promise.t<unit>) => unit = "before"
@module("ava") @scope("default")
external afterEach: (ExecutionContext.t<'context> => unit) => unit = "afterEach"
@module("ava") @scope("default")
external asyncAfterEach: (ExecutionContext.t<'context> => Js.Promise.t<unit>) => unit = "afterEach"
@module("ava") @scope("default")
external after: (ExecutionContext.t<'context> => unit) => unit = "after"
@module("ava") @scope("default")
external asyncAfter: (ExecutionContext.t<'context> => Js.Promise.t<unit>) => unit = "after"

module Failing = {
  @module("ava") @scope("default")
  external test: (string, ExecutionContext.t<'context> => unit) => unit = "failing"
  @module("ava") @scope("default")
  external asyncTest: (string, ExecutionContext.t<'context> => Js.Promise.t<unit>) => unit =
    "failing"
  @module("ava") @scope(("default", "failing"))
  external only: (string, ExecutionContext.t<'context> => unit) => unit = "only"
  @module("ava") @scope(("default", "failing"))
  external asyncOnly: (string, ExecutionContext.t<'context> => Js.Promise.t<unit>) => unit = "only"
  @module("ava") @scope(("default", "failing"))
  external skip: (string, ExecutionContext.t<'context> => unit) => unit = "skip"
  @module("ava") @scope(("default", "failing"))
  external asyncSkip: (string, ExecutionContext.t<'context> => Js.Promise.t<unit>) => unit = "skip"
}

module Only = {
  @module("ava") @scope("default")
  external test: (string, ExecutionContext.t<'context> => unit) => unit = "only"
  @module("ava") @scope("default")
  external asyncTest: (string, ExecutionContext.t<'context> => Js.Promise.t<unit>) => unit = "only"
}

module Skip = {
  @module("ava") @scope("default")
  external test: (string, ExecutionContext.t<'context> => unit) => unit = "skip"
  @module("ava") @scope("default")
  external asyncTest: (string, ExecutionContext.t<'context> => Js.Promise.t<unit>) => unit = "skip"

  @module("ava") @scope(("default", "beforeEach"))
  external beforeEach: (ExecutionContext.t<'context> => unit) => unit = "skip"
  @module("ava") @scope(("default", "beforeEach"))
  external asyncBeforeEach: (ExecutionContext.t<'context> => Js.Promise.t<unit>) => unit = "skip"
  @module("ava") @scope(("default", "before"))
  external before: (ExecutionContext.t<'context> => unit) => unit = "skip"
  @module("ava") @scope(("default", "before"))
  external asyncBefore: (ExecutionContext.t<'context> => Js.Promise.t<unit>) => unit = "skip"
  @module("ava") @scope(("default", "afterEach"))
  external afterEach: (ExecutionContext.t<'context> => unit) => unit = "skip"
  @module("ava") @scope(("default", "afterEach"))
  external asyncAfterEach: (ExecutionContext.t<'context> => Js.Promise.t<unit>) => unit = "skip"
  @module("ava") @scope(("default", "after"))
  external after: (ExecutionContext.t<'context> => unit) => unit = "skip"
  @module("ava") @scope(("default", "after"))
  external asyncAfter: (ExecutionContext.t<'context> => Js.Promise.t<unit>) => unit = "skip"
}

module Always = {
  @module("ava") @scope(("default", "afterEach"))
  external afterEach: (ExecutionContext.t<'context> => unit) => unit = "always"
  @module("ava") @scope(("default", "afterEach"))
  external asyncAfterEach: (ExecutionContext.t<'context> => Js.Promise.t<unit>) => unit = "always"
  @module("ava") @scope(("default", "after"))
  external after: (ExecutionContext.t<'context> => unit) => unit = "always"
  @module("ava") @scope(("default", "after"))
  external asyncAfter: (ExecutionContext.t<'context> => Js.Promise.t<unit>) => unit = "always"

  module Skip = {
    @module("ava") @scope(("default", "afterEach", "always"))
    external afterEach: (ExecutionContext.t<'context> => unit) => unit = "skip"
    @module("ava") @scope(("default", "afterEach", "always"))
    external asyncAfterEach: (ExecutionContext.t<'context> => Js.Promise.t<unit>) => unit = "skip"
    @module("ava") @scope(("default", "after", "always"))
    external after: (ExecutionContext.t<'context> => unit) => unit = "skip"
    @module("ava") @scope(("default", "after", "always"))
    external asyncAfter: (ExecutionContext.t<'context> => Js.Promise.t<unit>) => unit = "skip"
  }
}

module Assert = {
  @send
  external is: (ExecutionContext.t<'context>, 'actual, 'actual, ~message: string=?, unit) => unit =
    "is"
  @send
  external unsafeIs: (
    ExecutionContext.t<'context>,
    'actual,
    'expected,
    ~message: string=?,
    unit,
  ) => unit = "is"
  @send
  external deepEqual: (
    ExecutionContext.t<'context>,
    'actual,
    'actual,
    ~message: string=?,
    unit,
  ) => unit = "deepEqual"
  @send
  external unsafeDeepEqual: (
    ExecutionContext.t<'context>,
    'actual,
    'expected,
    ~message: string=?,
    unit,
  ) => unit = "deepEqual"
  @send
  external regex: (
    ExecutionContext.t<'context>,
    string,
    Js.Re.t,
    ~message: string=?,
    unit,
  ) => unit = "regex"
  @send
  external throws: (
    ExecutionContext.t<'context>,
    unit => unit,
    ~expectations: ThrowsException.t=?,
    ~message: string=?,
    unit,
  ) => unit = "throws"
  @send
  external throwsAsync: (
    ExecutionContext.t<'context>,
    Js.Promise.t<unit>,
    ~expectations: ThrowsException.t=?,
    ~message: string=?,
    unit,
  ) => Js.Promise.t<unit> = "throwsAsync"
  @send
  external not: (
    ExecutionContext.t<'context>,
    'actual,
    'expected,
    ~message: string=?,
    unit,
  ) => unit = "not"
  @send
  external notDeepEqual: (
    ExecutionContext.t<'context>,
    'actual,
    'expected,
    ~message: string=?,
    unit,
  ) => unit = "notDeepEqual"
  @send
  external notRegex: (
    ExecutionContext.t<'context>,
    string,
    Js.Re.t,
    ~message: string=?,
    unit,
  ) => unit = "notRegex"
  @send
  external snapshot: (ExecutionContext.t<'context>, 'expected, ~message: string=?, unit) => unit =
    "snapshot"
  @send
  external notThrows: (
    ExecutionContext.t<'context>,
    unit => unit,
    ~message: string=?,
    unit,
  ) => unit = "notThrows"
  @send
  external notThrowsAsync: (
    ExecutionContext.t<'context>,
    Js.Promise.t<unit>,
    ~message: string=?,
    unit,
  ) => Js.Promise.t<unit> = "notThrowsAsync"
  @send external fail: (ExecutionContext.t<'context>, string) => 'any = "fail"
  @send external pass: (ExecutionContext.t<'context>, ~message: string=?, unit) => unit = "pass"
  @send
  external like: (
    ExecutionContext.t<'context>,
    'actual,
    'selector,
    ~message: string=?,
    unit,
  ) => unit = "like"
  @send
  external falsy: (ExecutionContext.t<'context>, 'actual, ~message: string=?, unit) => unit =
    "falsy"
  @send
  external truthy: (ExecutionContext.t<'context>, 'actual, ~message: string=?, unit) => unit =
    "truthy"
  @send
  external isFalse: (ExecutionContext.t<'context>, 'actual, ~message: string=?, unit) => unit =
    "false"
  @send
  external isTrue: (ExecutionContext.t<'context>, 'actual, ~message: string=?, unit) => unit =
    "true"

  module Skip = {
    @send @scope("is")
    external is: (ExecutionContext.t<'context>, 'value, 'value, ~message: string=?, unit) => unit =
      "skip"
    @send @scope("is")
    external unsafeIs: (
      ExecutionContext.t<'context>,
      'actual,
      'expected,
      ~message: string=?,
      unit,
    ) => unit = "skip"
    @send @scope("deepEqual")
    external deepEqual: (
      ExecutionContext.t<'context>,
      'value,
      'value,
      ~message: string=?,
      unit,
    ) => unit = "skip"
    @send @scope("deepEqual")
    external unsafeDeepEqual: (
      ExecutionContext.t<'context>,
      'actual,
      'expected,
      ~message: string=?,
      unit,
    ) => unit = "skip"
    @send @scope("regex")
    external regex: (
      ExecutionContext.t<'context>,
      string,
      Js.Re.t,
      ~message: string=?,
      unit,
    ) => unit = "skip"
    @send @scope("throws")
    external throws: (
      ExecutionContext.t<'context>,
      unit => unit,
      ~expectations: ThrowsException.t=?,
      ~message: string=?,
      unit,
    ) => unit = "skip"
    @send @scope("throwsAsync")
    external throwsAsync: (
      ExecutionContext.t<'context>,
      Js.Promise.t<unit>,
      ~expectations: ThrowsException.t=?,
      ~message: string=?,
      unit,
    ) => Js.Promise.t<unit> = "skip"
    @send @scope("not")
    external not: (
      ExecutionContext.t<'context>,
      'actual,
      'expected,
      ~message: string=?,
      unit,
    ) => unit = "skip"
    @send @scope("notDeepEqual")
    external notDeepEqual: (
      ExecutionContext.t<'context>,
      'actual,
      'expected,
      ~message: string=?,
      unit,
    ) => unit = "skip"
    @send @scope("notRegex")
    external notRegex: (
      ExecutionContext.t<'context>,
      string,
      Js.Re.t,
      ~message: string=?,
      unit,
    ) => unit = "skip"
    @send @scope("snapshot")
    external snapshot: (ExecutionContext.t<'context>, 'expected, ~message: string=?, unit) => unit =
      "skip"
    @send @scope("notRegex")
    external notThrows: (
      ExecutionContext.t<'context>,
      unit => unit,
      ~message: string=?,
      unit,
    ) => unit = "skip"
    @send @scope("notThrowsAsync")
    external notThrowsAsync: (
      ExecutionContext.t<'context>,
      Js.Promise.t<unit>,
      ~message: string=?,
      unit,
    ) => Js.Promise.t<unit> = "skip"
    @send @scope("fail") external fail: (ExecutionContext.t<'context>, string) => 'any = "skip"
    @send @scope("pass")
    external pass: (ExecutionContext.t<'context>, ~message: string=?, unit) => unit = "skip"
    @send @scope("like")
    external like: (
      ExecutionContext.t<'context>,
      'actual,
      'selector,
      ~message: string=?,
      unit,
    ) => unit = "skip"
    @send @scope("falsy")
    external falsy: (ExecutionContext.t<'context>, 'actual, ~message: string=?, unit) => unit =
      "skip"
    @send @scope("truthy")
    external truthy: (ExecutionContext.t<'context>, 'actual, ~message: string=?, unit) => unit =
      "skip"
    @send @scope("false")
    external isFalse: (ExecutionContext.t<'context>, 'actual, ~message: string=?, unit) => unit =
      "skip"
    @send @scope("true")
    external isTrue: (ExecutionContext.t<'context>, 'actual, ~message: string=?, unit) => unit =
      "skip"
  }
}
