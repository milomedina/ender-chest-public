import scala.io.StdIn._
import scala.util.Random

case class Pos(row: Int, col: Int)

var bombs = Set[Pos]()
var field: Array[Array[Char]] = null

def init(rows: Int, cols: Int, mines: Int) = {
    if (mines >= rows * cols) {
        println("Too many mines!!!!")
        System.exit(0)
    }

    field = new Array[Array[Char]](rows)
    for (row <- 0 until rows) {
        field(row) = new Array[Char](cols)
        for (col <- 0 until cols)
            field(row)(col) = '.'
    }

    val random = new Random()
    for (i <- 0 until mines) {
        var nr = random.nextInt(rows)
        var nc = random.nextInt(cols)
        while (bombs.contains(Pos(nr, nc))) {
            nr = random.nextInt(rows)
            nc = random.nextInt(cols)
        }
        bombs += Pos(nr, nc)
    }
}

def displayField(showBomb: Boolean) = {
    val rows = field.length; val cols = field(0).length
    var up = " "; var down = " "
    for (i <- 1 until cols + 1) {
        up += " " + (if (i < 10) " " else (i / 10))
        down += " " + (i % 10)
    }
    println(up + "\n" + down)
    for (i <- 0 until rows) {
        var str = ""
        str += ('A' + i).toChar + " "
        for (j <- 0 until cols)
            str += (if (showBomb && bombs.contains(Pos(i, j))) "*" else field(i)(j)) + " "
        println(str)
    }
    println()
}

def isDone(rows: Int, cols: Int, mines: Int): Boolean = {
    var count = 0
    for (row <- 0 until rows) {
        for (col <- 0 until cols) {
            if (field(row)(col) == '.') return false
            else if (field(row)(col) == '#') count += 1
        }
    }
    return count == mines
}

def parse(s: String): (Int, Int, Int) = {
    val p = """(#?)([a-z])(\d+)""".r
    var mstr = "E"; var mode = 0; var row = 0; var col = 0
    val rows = field.length; val cols = field(0).length

    s match {
        case p(m, r, c) => mstr = m; row = r(0) - 'a'; col = c.toInt - 1
        case _ => mstr = "E"
    }

    if (row < 0 || row >= rows || col < 0 || col >= cols) mstr = "E"

    mstr match {
        case "" => mode = 0
        case "#" => mode = 1
        case _ => mode = -1
    }

    return (mode, row, col)
}

def uncover(row: Int, col: Int): Boolean = {
    if (field(row)(col) == '#') {
        println("You need to unflag first!")
        return false
    } else if (field(row)(col) != '.') {
        println("Already uncoverd!")
        return false
    } else if (bombs.contains(Pos(row, col)))
        return true

    var numBomb = 0
    for (i <- -1 until 2)
        for (j <- -1 until 2)
            if (bombs.contains(Pos(row + i, col + j)))
                numBomb += 1

    if (numBomb == 0)
        field(row)(col) = ' '
    else
        field(row)(col) = (numBomb + '0').toChar
    return false
}

def flag(row: Int, col: Int) = {
    if (field(row)(col) == '.')
        field(row)(col) = '#'
    else if (field(row)(col) == '#')
        field(row)(col) = '.'
    else
        println("Already uncovered!")
}

def game(rows: Int, cols: Int, mines: Int) {
    init(rows, cols, mines)
    displayField(true)
    while (true) {
        displayField(false)

        if (isDone(rows, cols, mines)) {
            println("YOU WIN")
            return
        }

        val s = readLine("What cell do you want to check? ")
        if (s == "quit")
            return

        val (mode, row, col) = parse(s)

        if (mode == 0 && uncover(row, col)) {
            println("BOOM BOOM BOOM BOOM BOOM!!!! YOU DIED")
            displayField(true)
            return
        } else if (mode == 1)
            flag(row, col)
        else if (mode == -1)
            println("I don't understand.")
    }
}


if (args.length != 3) {
    println("#row #col #mine")
    System.exit(0)
}

val rows = args(0).toInt
val cols = args(1).toInt
val mines = args(2).toInt

game(rows, cols, mines)