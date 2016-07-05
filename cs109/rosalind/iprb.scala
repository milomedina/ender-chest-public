val F = scala.io.Source.fromFile("input.txt")
val lines = F.getLines().toArray
F.close()

val arg = lines(0).split(" ")
val hd = arg(0).toDouble; val ht = arg(1).toDouble; val hr = arg(2).toDouble

val total = (hd + ht + hr) * (hd + ht + hr - 1) / 2
val suc = hd * (hd - 1) / 2 +
    hd * ht +
    hd * hr +
    ht * (ht - 1) * 3 / 8 +
    ht * hr / 2

println(suc / total)