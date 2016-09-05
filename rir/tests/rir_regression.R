f1 <- rir.compile(function() {
    a <- 1
    class(a) <- "asdf"
    b <- a
    class(b) <- NULL
    class(a)
})

stopifnot(f1() == "asdf")

f2 <- rir.compile(function() {
    a <- c(1)
    a <- c(quote(a))
    a[[1]] <- quote(b)
    a[[1]]
})

stopifnot(f2() == quote(b))

f <- rir.compile(function() {
    b0 <- gl(3,4, labels=letters[1:3])
    bf <- setNames(b0, paste0("o", seq_along(b0)))
    df  <- data.frame(a = 1, B = b0, f = gl(4,3))
})
f()
