val F = scala.io.Source.fromFile("input.txt")
val lines = F.getLines().toArray
F.close()

val arg = lines(0).split(" ")
val day = arg(0).toInt; val life = arg(1).toInt

val arr = new Array[Long](life)
arr(0) = 1L

for (i <- 0 until day - 1) {
    var add = 0L
    for (j <- 1 until life)
        add += arr(j)
    for (j <- life - 1 to 1 by -1)
        arr(j) = arr(j - 1)
    arr(0) = add
}
println(arr.sum)
