> Note: If you want to use package published on npm go here: https://github.com/resinfo/rescript-ava

# rescript-ava

[ReScript](https://github.com/rescript-lang) bindings for [Ava](https://github.com/avajs/ava)

## Status

- rescript-ava depends on ReScript 9.1.4, Ava 4.0.1 and @ryyppy/rescript-promise 2.1.0
- rescript-ava has bindings for ~95% original functionality. If you find some bindings you need are missing, contributions are welcome

## Usage

### Installation

```sh
npm install --save-dev DZakh/rescript-ava#latest-commit-hash
```

Then add `rescript-ava` to `bs-dev-dependencies` in your `bsconfig.json`:

```diff
{
  ...
+ "bs-dev-dependencies": ["rescript-ava"]
}
```

Then add `__tests__` to `sources` in your `bsconfig.json`:

```diff
"sources": [
  {
    "dir": "src"
  },
+ {
+   "dir": "__tests__",
+   "type": "dev"
+ }
]
```

Then add `test` script and minimalistic configuration in your `package.json`:

```diff
{
  "name": "awesome-package",
  "scripts": {
+   "test": "ava"
  },
  "devDependencies": {
    "rescript-ava": "^1.0.0"
  },
+ "ava": {
+   "files": [
+     "__tests__/**/*_test.mjs",
+     "__tests__/**/*_test.bs.js"
+   ]
+ }
}
```

### Create your test file

Create a test file in the __tests__ directory and use the suffix `*_test.res`. When compiled they will be put in a __tests__ directory with a `*_test.bs.js` suffix, ready to be picked up when you run ava. If you're not already familiar with [Ava](https://github.com/avajs/ava), see [the Ava documentation](https://github.com/avajs/ava#documentation).


```res
// __tests__/Main_test.res

Ava.test("foo", t => {
  t->Ava.Assert.pass()
})

Ava.asyncTest("bar", t => {
  Promise.resolve("bar")->Promise.thenResolve(bar => {
    t->Ava.Assert.is(bar, "bar", ())
  })
})
```

### Running your tests

```sh
npm test
```

Or with npx:

```sh
npx ava
```

Run with the --watch flag to enable AVA's [watch mode](https://github.com/avajs/ava/blob/main/docs/recipes/watch-mode.md):

```sh
npx ava --watch
```

## Documentation

For the moment, please refer to [Ava.res](./src/Ava.res).

## Examples

Open source projects using **rescript-ava**:

- [ReScript Struct](https://github.com/DZakh/rescript-struct) - A simple and composable way to describe relationship between JavaScript and ReScript structures
- [ReScript JSON Schema](https://github.com/DZakh/rescript-json-schema) - Typesafe JSON schema for ReScript

## Changes

### 0.1.0

- Created and published (unsuccessfully)
