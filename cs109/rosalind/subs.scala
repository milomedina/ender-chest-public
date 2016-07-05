val F = scala.io.Source.fromFile("input.txt")
val lines = F.getLines().toArray
F.close()

val big = lines(0)
val small = lines(1)
for (i <- 0 until big.length)
    if (big.startsWith(small, i))
        print((i + 1) + " ")