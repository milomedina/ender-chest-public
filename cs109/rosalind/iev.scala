val F = scala.io.Source.fromFile("input.txt")
val lines = F.getLines().toArray
F.close()

val arg = lines(0).split(" ")

val answer = arg(0).toInt * 2 + arg(1).toInt * 2 + arg(2).toInt * 2 + arg(3).toInt * 1.5 + arg(4).toInt
println(answer)