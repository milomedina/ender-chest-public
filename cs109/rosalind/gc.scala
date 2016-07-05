val F = scala.io.Source.fromFile("input.txt")
var lines = F.getLines().toArray
F.close()

var mname = ""; var max = 0.0
lines :+= ">"

var name = ""; var tmp = ""
for (i <- 0 until lines.length) {
    if (lines(i)(0) == '>') {
        var count = 0
        for (j <- 0 until tmp.length)
            if (tmp(j) == 'G' || tmp(j) == 'C')
                count += 1
        val ratio = count.toDouble / tmp.length * 100
        if (ratio > max) {
            max = ratio
            mname = name
        }
        tmp = ""
        name = lines(i).substring(1)
    } else
        tmp += lines(i)
}

println(mname + "\n" + max)