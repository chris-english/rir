f <- pir.compile(rir.compile(function(a) a(b=1, 2)))
a <- function(a,b) c(a,b)
stopifnot(c(2,1) == pir.compile(rir.compile(function()f(a)))())

# forcing a promise can inspect the whole call stack
f <- pir.compile(rir.compile(function(x) sys.frame(x)))
g <- pir.compile(rir.compile(function(y) y))
h <- pir.compile(rir.compile(function() g(f(2))))
h()  # aborts if g's environment got elided




{
  f <- pir.compile(rir.compile(function(gpars) {
    numnotnull <- function(gparname) {
      match(gparname, names(gpars))
      gpars[[gparname]]
    }
    numnotnull('a')
    numnotnull('c')
  }))
  fc <- pir.compile(rir.compile(function() {
   f(list(a=1))
  }))
  fc()
}




{
  validGP <- pir.compile(rir.compile(function(gpars) {
    check.length <- function(gparname) {
        NULL
    }
    numnotnull <- function(gparname) {
      if (match(gparname, names(gpars))) {
          check.length(gparname)
      }   
    }
    numnotnull('a')
  }))
  
  rir.compile(function() {
     validGP(list(a=1))
  })()
}

# speculative binop with deopt
rir.compile(function(){
    f <- rir.compile(function(a) a+2);
    f(1);
    f <- pir.compile(f);
    f(structure(1, class="foo"))
})()


# inlined frameStates:
f <- rir.compile(function(x) g(x))
g <- rir.compile(function(x) h(x))
h <- rir.compile(function(x) 1+i(x))
i <- rir.compile(function(x) 40-x)

stopifnot(f(-1) == 42)

hc1 = .Call("rir_invocation_count", h)
ic1 = .Call("rir_invocation_count", i)
g <- pir.compile(g)
stopifnot(f(-1) == 42)

## Assert we are really inlined (ie. h and i are not called)
hc2 = .Call("rir_invocation_count", h)
ic2 = .Call("rir_invocation_count", i)
stopifnot(hc1 == hc2)
stopifnot(ic1 == ic2)

## Assert we deopt (ie. base version of h and i are invoked)
stopifnot(f(structure(-1, class="asdf")) == 42)
hc3 = .Call("rir_invocation_count", h)
ic3 = .Call("rir_invocation_count", i)
stopifnot(hc3 == hc2+c(1,0))
stopifnot(ic3 == ic2+c(1,0))
