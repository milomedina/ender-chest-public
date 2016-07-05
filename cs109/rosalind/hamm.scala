val F = scala.io.Source.fromFile(args(0))
val lines = F.getLines().toArray
F.close()

val s = lines(0)
val t = lines(1)
var count = 0
for (i <- 0 until s.length)
    if (s(i) != t(i)) count += 1
println(count)