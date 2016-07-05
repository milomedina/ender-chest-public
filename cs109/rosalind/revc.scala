val F = scala.io.Source.fromFile("input.txt")
val lines = F.getLines().toArray
F.close()

val line = lines(0).reverse
var comp = ""
for (i <- 0 until line.length)
    line(i) match {
        case 'A' => comp += 'T'
        case 'C' => comp += 'G'
        case 'G' => comp += 'C'
        case 'T' => comp += 'A'
    }

println(comp)