# JavaScript Magic Methods
This script implements some of PHP's magic methods for JavaScript classes, using a [Proxy](https://developer.mozilla.org/de/docs/Web/JavaScript/Reference/Global_Objects/Proxy).

## Example
You can use it like this:
```javascript
const Foo = magicMethods(class Foo {
  constructor () {
    this.bar = 'Bar'
  }
  
  __get (name) {
    return `[[${name}]]`
  }
})

const foo = new Foo
foo.bar // "Bar"
foo.baz // "[[baz]]"
```

If you're using a JavaScript transpiler like Babel with decorators enabled, you can also use the `magicMethods` function as a decorator:

```javascript
@magicMethods
class Foo {
  // ...
}
```

## Supported Magic Methods
Given a class `Class` and an `instance` of it, the following are the magic methods supported by this script:

### `__get(name)`
Called when trying to access `instance[name]` where `name` is not an existing property of `instance`.

**Attention:** As in PHP, the check if `name` exists in `instance` does not use any custom `__isset()` methods.

### `__set(name, value)`
Called when trying to do `instance[name] = ...` where `name` is neither set as a property of `instance`.

### `__isset(name)`
Called when trying to check existance of `name` by calling `name in instance`.

### `__unset(name)`
Called when trying to unset property `name` by calling `delete instance[name]`.

## Additional Methods
The following magic methods are made available by this script, but are not supported in PHP:

### `static __getStatic(name)`
Like `__get()`, but in the `Class` instead of the `instance`.

### `static __setStatic(name, value)`
Like `__set()`, but in the `Class` instead of the `instance`.

## Why is Magic Method `X` not supported?
They are either not necessary or not practical:

* `__construct()` is not needed, there's JavaScript's `constructor` already.
* `__destruct()`: There is no mechanism in JavaScript to hook into object destruction.
* `__call()`: Functions are first-class objects in JavaScript. That means that (as opposed to PHP) an object's methods are just regular properties in JavaScript and must first be obtained via `__get()` to be invoked subsequently. So to implement `__call()` in JavaScript, you'd simply have to implement `__get()` and return a function from there.
* `__callStatic()`: As in `__call()`, but with `__getStatic()`.
* `__sleep()`, `__wakeup()`: There's no builtin serialization/unserialization in JavaScript. You could use `JSON.stringify()`/`JSON.parse()`, but there's no mechanism to automatically trigger any methods with that.
* `__toString()` is already present in JavaScript's `toString()`
* `__invoke()`: JavaScript will throw an error if you'll try to invoke a non-function object, no way to avoid that.
* `__set_state()`: There's nothing like `var_export()` in JavaScript.
* `__clone()`: There's no builtin cloning functionality in JavaScript that can be hooked into.
* `__debugInfo()`: There's no way to hook into `console.log()` output.

## Can I extend a class with Magic Methods on it?
Yes:

```javascript
// `Bar` inherits magic methods from `Foo`
class Bar extends Foo {}
```

Or, if class `Bar` contains magic methods itself:
```
const Bar = magicMethods(class Bar extends Foo {
  // You may define `Bar`'s magic methods here
})
```
