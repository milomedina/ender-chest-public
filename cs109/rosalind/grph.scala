val F = scala.io.Source.fromFile("input.txt")
var lines = F.getLines().toArray
F.close()
lines :+= ">"

var names = Array.empty[String]
var dnas = Array.empty[String]

var tmp = ""
for (i <- 0 until lines.length) {
    if (lines(i)(0) == '>') {
        if (tmp != "") {
            dnas = dnas :+ tmp; tmp = ""
        }
        val name = lines(i).substring(1)
        if (name != "")
            names = names :+ name
    } else
        tmp += lines(i)
}

var map = Array.empty[(String, String)]
for (i <- 0 until names.length) {
    for (j <- 0 until names.length) {
        if (i != j) {
            val sub = dnas(i).substring(dnas(i).length - 3)
            val sub2 = dnas(j).substring(0, 3)
            if (sub == sub2)
                map = map :+ (names(i), names(j))
        }
    }
}
for (i <- 0 until map.length)
    println(map(i)._1 + " " + map(i)._2)