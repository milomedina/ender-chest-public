import scala.collection.mutable.ArrayBuffer

if (args.length != 3) {
    print("Usages: file.txt n m")
    System.exit(-1)
}

val n = args(1).toInt
val numWord = args(2).toInt
val F = scala.io.Source.fromFile(args(0))
val text = F.getLines().toArray.mkString(" ")

val words: ArrayBuffer[String] = new ArrayBuffer[String]()
var buf: String = ""
for (i <- 0 until text.length) {
    if (text(i).isLetterOrDigit || (text(i) == '\'' && i != text.length - 1 && text(i + 1) == 's'))
        buf += text(i).toLower
    else {
        if (buf != "")
            words += buf
        buf = ""
    }
}
if (buf != "")
    words += buf

val wordArr = words.toArray
var map = Map[List[String], Set[String]]()

var seq: List[String] = Nil
for (i <- 0 until n - 1)
    seq = wordArr(i) :: seq
seq = seq.reverse

for (i <- n - 1 until wordArr.length) {
    if (map contains seq)
        map += (seq -> (map(seq) + wordArr(i)))
    else
        map += (seq -> Set[String](wordArr(i)))
    seq = (wordArr(i) :: seq.tail.reverse).reverse
}

def write(limit: Int): Int = {
    val sp = (math.random * (wordArr.length - n)).toInt
    var seq: List[String] = Nil
    for (i <- sp until sp + n) {
        seq = wordArr(i) :: seq
        print(wordArr(i) + " ")
    }
    seq = seq.reverse.tail

    var count = n
    while (count < limit) {
        if (map contains seq) {
            val arr = map(seq).toArray
            val ele = arr((math.random * arr.length).toInt)
            print(ele + " ")
            seq = (ele :: seq.tail.reverse).reverse
            count += 1
        } else
            return count
    }
    count
}

var count = numWord
while (count > 0) {
    count -= write(count)
    println()
}