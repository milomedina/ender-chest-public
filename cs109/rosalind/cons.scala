val F = scala.io.Source.fromFile("input.txt")
var lines = F.getLines().toArray
F.close()
lines :+= ">"

var arr = Array.empty[String]
var matrix: Array[Array[Int]] = null
var result = ""

var tmp = ""
for (i <- 0 until lines.length) {
    if (lines(i)(0) == '>') {
        if (tmp != "")
            arr :+= tmp
        tmp = ""
    } else
        tmp += lines(i)
}

matrix = new Array[Array[Int]](arr(0).length)
for (i <- 0 until arr(0).length) {
    matrix(i) = new Array[Int](4)
    for (j <- 0 until arr.length) {
        arr(j)(i) match {
            case 'A' => matrix(i)(0) += 1
            case 'C' => matrix(i)(1) += 1
            case 'G' => matrix(i)(2) += 1
            case 'T' => matrix(i)(3) += 1
        }
    }
    val max = matrix(i).max
    if (matrix(i)(0) == max)
        result += 'A'
    else if (matrix(i)(1) == max)
        result += 'C'
    else if (matrix(i)(2) == max)
        result += 'G'
    else if (matrix(i)(3) == max)
        result += 'T'
}

println(result)
for (i <- 0 until 4) {
    i match {
        case 0 => print("A: ")
        case 1 => print("C: ")
        case 2 => print("G: ")
        case 3 => print("T: ")
    }
    for (j <- 0  until matrix.length)
        print(matrix(j)(i) + " ")
    println()
}