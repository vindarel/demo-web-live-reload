
Well all know that we can start a web server in the REPL and develop a
web app as interactively as any other app, we know how to [connect to
a remote Lisp
image](https://lispcookbook.github.io/cl-cookbook/debugging.html#remote-debugging)
by starting a Swank server and how to interact with it from our
favorite editor on our machine, we know we can build a self-contained
binary of the web app and simply run it, but one thing I had not
realized, despite being the basics, is that by starting the web app
with `sbcl --load app.lisp`, we are dropped into the regular Lisp
REPL, with the web server running in its own thread (as in development
mode, but unlike with the binary), and that we can consequently interact with the running app.

As a demonstration, you can clone this repository and run the example like this:

```
* rlwrap sbcl --load run.lisp

This is SBCL 1.4.5.debian, an implementation of ANSI Common Lisp.
re information about SBCL is available at <http://www.sbcl.org/>.
[…]
; Loading "web-live-reload"
..................................................
Starting the web server on port 7890
Ready. You can access the application!
*
```

it will load `project.asd`, install 3 Quicklisp dependencies (you must
have Quicklisp installed), start Hunchentoot on port 7890, and drop us
into a REPL.

You'll get this:

![](start.png)

The template prints the `*config*` variable, which you can change in the REPL:

~~~lisp
* (in-package :web-live-reload)
* (setf *config*
    '((:key "Name"
       :val "James")
      (:key "phone"
       :val "0098 007")
      (:key "secret language?"
       :val "Lisp")))
  ~~~

refresh, and voilà, your new config is live.

For functions, it is just the same (redefine the function `fn` that
returns a string, if you want to try).

If a file changes (for example after a git pull), compile it with a
usual `load`: `(load "src/web.lisp")`.

You can also reload all the app with `(ql:quickload :myproject)`,
which will install the dependencies, without needing to restart the
running image.

I was looking for a way to reload a user's config and personal data
from a running website, and this has proved very practical. I have no
downtime, it is pure Lisp, it is the workflow I am used to. I am more
cautious on using this to recompile the whole app, even though I did
it without glitches so far. The thing to *not* do is to change the
global state manually, aka to develop in production!

That's all, but that made my day.

---

Bonus points:

- after a git pull, the (Djula) templates are automatically
  updated. No operation is needed to see them live. (you can disable
  this by pushing `:djula-prod` into the features set)
- you'll understand and appreciate the difference between
  `defparameter` and `defvar`. Imagine you declare a variable with
  `(defparameter *data* nil)` and you populate it with some heavy
  computation at the application startup. Now if you `load` the file
  this declaration is in, you'll set the data back to `nil`. If you
  declare it with `defvar`, you can live-re`load` your app and the
  data doesn't go away. You can try both cases with the `*config*`
  variable.
- the app started a Swank server on port 4006, if you want to try on your VPS.
