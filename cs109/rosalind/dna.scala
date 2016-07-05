val F = scala.io.Source.fromFile("input.txt")
val lines = F.getLines().toArray
F.close()

val line = lines(0)
var a = 0; var c = 0; var g = 0; var t = 0;
for (i <- 0 until line.length)
    line(i) match {
        case 'A' => a += 1
        case 'C' => c += 1
        case 'G' => g += 1
        case 'T' => t += 1
    }

println(a + " " + c + " " + g + " " + t)