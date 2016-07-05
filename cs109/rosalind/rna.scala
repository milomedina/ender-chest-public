val F = scala.io.Source.fromFile("input.txt")
val lines = F.getLines().toArray
F.close()

val line = lines(0)
var rna = ""
for (i <- 0 until line.length)
    line(i) match {
        case 'T' => rna += "U"
        case _ => rna += line(i)
    }

println(rna)