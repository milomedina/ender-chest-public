val F = scala.io.Source.fromFile("input.txt")
val lines = F.getLines().toArray
F.close()

val arg = lines(0).split(" ")
val day = arg(0).toInt; val mul = arg(1).toInt

var f1 = 0L; var f2 = 1L
for (i <- 0 until day) {
    val tmp = f2
    f2 = f2 + f1 * mul
    f1 = tmp
}
println(f1)