import scala.io.StdIn.{readLine,readInt}

case class Pos(row: Int, col: Int)

def makeField(rows: Int, cols: Int): Array[Array[Int]] = {
    val field = new Array[Array[Int]](rows)
    for (row <- 0 until rows)
        field(row) = new Array[Int](cols)
    for (row <- 0 until rows)
        for (col <- 0 until cols)
            field(row)(col) = row * cols + col + 1
    field(rows - 1)(cols - 1) = 0
    return field
}

def combine(left: String, sep: String, right: String): String = {
    val lseg = left.split("\n"); val rseg = right.split("\n")
    val minSize = math.min(lseg.length, rseg.length)
    var arr = Array.empty[String]
    for (i <- 0 until minSize)
        arr = arr :+ lseg(i) + sep + rseg(i)
    val remain = if (lseg.length > rseg.length) lseg else rseg
    for (i <- minSize until remain.length)
        arr = arr :+ remain(i)
    return arr.mkString("\n")
}

def getTile(num: Int): String = {
    var str = ""
    str += (if (num == 0) " " * 6 else "o----o") + "\n"
    str += (if (num == 0) " " * 6 else "|    |") + "\n"
    str += (if (num == 0) " " * 6 else "| %-2d |".format(num)) + "\n"
    str += (if (num == 0) " " * 6 else "|    |") + "\n"
    str += (if (num == 0) " " * 6 else "o----o")
    return str
}

def displayField(field: Array[Array[Int]]) = {
    var str = ""
    val rows = field.length; val cols = field(0).length
    for (row <- 0 until rows) {
        var tstr = ""
        for (col <- 0 until cols)
            tstr = combine(tstr, "", getTile(field(row)(col)))
        str += tstr + "\n"
    }
    print(str)
}

def findEmpty(field: Array[Array[Int]]): Pos = {
    val rows = field.length; val cols = field(0).length
    for (row <- 0 until rows)
        for (col <- 0 until cols)
            if (field(row)(col) == 0)
                return Pos(row, col)
    Pos(0, 0)
}

def makeMove(field: Array[Array[Int]], delta: Pos): Int = {
    val now = findEmpty(field)
    val upd = Pos(now.row + delta.row, now.col + delta.col)
    val rows = field.length; val cols = field(0).length
    if (upd.row < 0 || upd.row >= rows || upd.col < 0 || upd.col >= cols)
        return 0
    field(now.row)(now.col) = field(upd.row)(upd.col)
    field(upd.row)(upd.col) = 0
    return 1
}

def shuffle(field: Array[Array[Int]], iter: Int) {
    val moves = Array(Pos(1,0), Pos(-1,0), Pos(0,1), Pos(0,-1))
    for (i <- 1 to iter) {
        val mov = moves((math.random * 4).toInt)
        makeMove(field, mov)
    }
}

def strToMove(s: String): Pos = {
    val ps = s.trim().toLowerCase()
    ps(0) match {
        case 'l' => Pos(0, 1)
        case 'r' => Pos(0, -1)
        case 'u' => Pos(1, 0)
        case 'd' => Pos(-1, 0)
        case _ => Pos(0, 0)
    }
}

def isDone(field: Array[Array[Int]]): Boolean = {
    var count = 0
    val rows = field.length; val cols = field(0).length
    for (row <- 0 until rows) {
        for (col <- 0 until cols) {
            count += 1
            if (count != field(row)(col) && !(row == rows - 1 && col == cols - 1))
                return false
        }
    }
    return true
}

def playGame(rows: Int, cols: Int) {
    val f = makeField(rows, cols)
    shuffle(f, 1000)
    var count = 0
    while (true) {
        displayField(f)
        println("Total Moves: " + count)

        if (isDone(f)) {
            println("Congratulation! You solved this puzzle using " + count + " moves!")
            return
        }

        val s = readLine("What is your move> ")
        println()
        if (s == "quit")
            return

        val move = strToMove(s)
        val delta = makeMove(f, move)
        count += delta
    }
}

var rows = 4; var cols = 4;
if (args.length >= 1)
    rows = args(0).toInt
if (args.length >= 2)
    cols = args(1).toInt

playGame(rows, cols)