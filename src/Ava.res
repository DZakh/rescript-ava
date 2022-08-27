module ThrowsException = {
  type t
  type message = String(string) | Re(Js.Re.t) | Fn((~message: string) => bool)

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

type meta = {
  file: string,
  snapshotDirectory: string,
}

type ava = {meta: meta}

@module("ava") external ava: ava = "default"

let test = (ava: ava, title: string, implementation: ExecutionContext.t<'context> => unit): unit =>
  (ava->Obj.magic)(. title, implementation)
let asyncTest = (
  ava: ava,
  title: string,
  implementation: ExecutionContext.t<'context> => Js.Promise.t<unit>,
): unit => (ava->Obj.magic)(. title, implementation)

@send
external todo: (ava, string) => unit = "todo"
@send
external beforeEach: (ava, ExecutionContext.t<'context> => unit) => unit = "beforeEach"
@send
external asyncBeforeEach: (ava, ExecutionContext.t<'context> => Js.Promise.t<unit>) => unit =
  "beforeEach"
@send
external before: (ava, ExecutionContext.t<'context> => unit) => unit = "before"
@send
external asyncBefore: (ava, ExecutionContext.t<'context> => Js.Promise.t<unit>) => unit = "before"
@send
external afterEach: (ava, ExecutionContext.t<'context> => unit) => unit = "afterEach"
@send
external asyncAfterEach: (ava, ExecutionContext.t<'context> => Js.Promise.t<unit>) => unit =
  "afterEach"
@send
external after: (ava, ExecutionContext.t<'context> => unit) => unit = "after"
@send
external asyncAfter: (ava, ExecutionContext.t<'context> => Js.Promise.t<unit>) => unit = "after"

module Failing = {
  @send
  external test: (ava, string, ExecutionContext.t<'context> => unit) => unit = "failing"
  @send
  external asyncTest: (ava, string, ExecutionContext.t<'context> => Js.Promise.t<unit>) => unit =
    "failing"
  @send @scope("failing")
  external only: (ava, string, ExecutionContext.t<'context> => unit) => unit = "only"
  @send @scope("failing")
  external asyncOnly: (ava, string, ExecutionContext.t<'context> => Js.Promise.t<unit>) => unit =
    "only"
  @send @scope("failing")
  external skip: (ava, string, ExecutionContext.t<'context> => unit) => unit = "skip"
  @send @scope("failing")
  external asyncSkip: (ava, string, ExecutionContext.t<'context> => Js.Promise.t<unit>) => unit =
    "skip"
}

module Only = {
  @send
  external test: (ava, string, ExecutionContext.t<'context> => unit) => unit = "only"
  @send
  external asyncTest: (ava, string, ExecutionContext.t<'context> => Js.Promise.t<unit>) => unit =
    "only"
}

module Skip = {
  @send
  external test: (ava, string, ExecutionContext.t<'context> => unit) => unit = "skip"
  @send
  external asyncTest: (ava, string, ExecutionContext.t<'context> => Js.Promise.t<unit>) => unit =
    "skip"

  @send @scope("beforeEach")
  external beforeEach: (ava, ExecutionContext.t<'context> => unit) => unit = "skip"
  @send @scope("beforeEach")
  external asyncBeforeEach: (ava, ExecutionContext.t<'context> => Js.Promise.t<unit>) => unit =
    "skip"
  @send @scope("before")
  external before: (ava, ExecutionContext.t<'context> => unit) => unit = "skip"
  @send @scope("before")
  external asyncBefore: (ava, ExecutionContext.t<'context> => Js.Promise.t<unit>) => unit = "skip"
  @send @scope("afterEach")
  external afterEach: (ava, ExecutionContext.t<'context> => unit) => unit = "skip"
  @send @scope("afterEach")
  external asyncAfterEach: (ava, ExecutionContext.t<'context> => Js.Promise.t<unit>) => unit =
    "skip"
  @send @scope("after")
  external after: (ava, ExecutionContext.t<'context> => unit) => unit = "skip"
  @send @scope("after")
  external asyncAfter: (ava, ExecutionContext.t<'context> => Js.Promise.t<unit>) => unit = "skip"
}

module Always = {
  @send @scope("afterEach")
  external afterEach: (ava, ExecutionContext.t<'context> => unit) => unit = "always"
  @send @scope("afterEach")
  external asyncAfterEach: (ava, ExecutionContext.t<'context> => Js.Promise.t<unit>) => unit =
    "always"
  @send @scope("after")
  external after: (ava, ExecutionContext.t<'context> => unit) => unit = "always"
  @send @scope("after")
  external asyncAfter: (ava, ExecutionContext.t<'context> => Js.Promise.t<unit>) => unit = "always"

  module Skip = {
    @send @scope(("afterEach", "always"))
    external afterEach: (ava, ExecutionContext.t<'context> => unit) => unit = "skip"
    @send @scope(("afterEach", "always"))
    external asyncAfterEach: (ava, ExecutionContext.t<'context> => Js.Promise.t<unit>) => unit =
      "skip"
    @send @scope(("after", "always"))
    external after: (ava, ExecutionContext.t<'context> => unit) => unit = "skip"
    @send @scope(("after", "always"))
    external asyncAfter: (ava, ExecutionContext.t<'context> => Js.Promise.t<unit>) => unit = "skip"
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
