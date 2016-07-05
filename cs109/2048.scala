import scala.util.Random
import org.otfried.cs109.UI._
import java.awt.image.BufferedImage
import java.awt.{Graphics2D,Color,Font,BasicStroke}
import java.awt.geom._

class Board() {
    private var items: Array[Array[Int]] = Array.ofDim[Int](4, 4)

    private val backgroundColor = new Color(0xbbada0)
    private val tileColors = Map(0 -> new Color(205, 192, 180),
        2 -> new Color(0xeee4da),
        4 -> new Color(0xede0c8),
        8 -> new Color(0xf2b179),
        16 -> new Color(0xf59563),
        32 -> new Color(0xf67c5f),
        64 -> new Color(0xf65e3b),
        128 -> new Color(0xedcf72),
        256 -> new Color(0xedcc61),
        512 -> new Color(0xedc850),
        1024 -> new Color(0xedc53f),
        2048 -> new Color(0xedc22e))
    private val otherTileColor = new Color(0x3c3a32)
    private val lightTextColor = new Color(119, 110, 101)
    private val darkTextColor = new Color(0xf9f6f2)

    private def textColor(tileValue: Int) =
        if (tileValue <= 4) lightTextColor else darkTextColor

    private def textSize(tileValue: Int) =
        if (tileValue <= 64) 55
        else if (tileValue <= 512) 45
        else if (tileValue <= 2048) 35
        else 30

    def draw(canvas: BufferedImage) = {
        val g = canvas.createGraphics()
        g.setColor(backgroundColor)
        g.fill(new Rectangle2D.Double(0.0, 0.0, 500.0, 500.0))

        for (i <- 0 until 4) {
            for (j <- 0 until 4) {
                val tile = items(i)(j)
                g.setColor(tileColors(tile))
                g.fill(new Rectangle2D.Double(122 * j + 15, 122 * i + 15, 107, 107))

                if (tile != 0) {
                    g.setColor(textColor(tile))
                    g.setFont(new Font("sans-serif", Font.PLAIN, textSize(tile)))
                    val w = g.getFontMetrics().stringWidth(tile + "")
                    g.drawString(tile + "", 122 * j + 68 - w / 2, 122 * i + 90)
                }
            }
        }
        show(canvas)
    }

    def insert() : Unit = {
        if (isFull()) return

        var empty = List[(Int, Int)]()
        for (i <- 0 until 4)
            for (j <- 0 until 4)
                if (items(i)(j) == 0)
                    empty = (i, j) :: empty

        val loc = empty(Random.nextInt(empty.length))
        val value = if (Random.nextInt(10) < 1) 4 else 2
        items(loc._1)(loc._2) = value
    }

    def push(ch: Char) : Int = {
        if (ch == 'l')
            return pushLeft()
        else if (ch == 'r') {
            mirror()
            val point = pushLeft()
            mirror()
            return point
        } else if (ch == 'u') {
            transpose()
            val point = pushLeft()
            transpose()
            return point
        } else if (ch == 'd') {
            transpose(); mirror()
            val point = pushLeft()
            mirror(); transpose()
            return point
        }
        0
    }

    def isFull() : Boolean = {
        for (i <- 0 until 4)
            for (j <- 0 until 4)
                if (items(i)(j) == 0)
                    return false
        true
    }

    override def toString() : String = {
        var result = ""
        val sep = "o----o----o----o----o"
        val empty = "|    |    |    |    |"

        for (i <- 0 until 4) {
            result += sep + "\n"
            result += empty + "\n"
            for (j <- 0 until 4) {
                if (items(i)(j) == 0)
                    result += "|    "
                else
                    result += "|%3d ".format(items(i)(j))
            }
            result += "|\n"
            result += empty + "\n"
        }
        result += sep
        result
    }

    private def pushBlock(row: Int, target: Int, isMerged: Array[Boolean]) : (Array[Boolean], Int) = {
        for (i <- target - 1 to 0 by -1) {
            if (items(row)(i) != 0) {
                if (items(row)(i) == items(row)(target) && !isMerged(i)) {
                    items(row)(i) *= 2
                    if (target != i) items(row)(target) = 0
                    isMerged(i) = true
                    return (isMerged, items(row)(i))
                } else {
                    items(row)(i + 1) = items(row)(target)
                    if (target != i + 1) items(row)(target) = 0
                    return (isMerged, 0)
                }
            }
        }
        items(row)(0) = items(row)(target)
        if (target != 0) items(row)(target) = 0
        (isMerged, 0)
    }

    private def pushLeft() : Int = {
        var point = 0
        for (i <- 0 until 4) {
            var isMerged = Array(false, false, false, false)
            for (j <- 0 until 4) {
                if (items(i)(j) != 0) {
                    val result = pushBlock(i, j, isMerged)
                    isMerged = result._1
                    point += result._2
                }
            }
        }
        point
    }

    private def transpose() : Unit = {
        var tmp = 0
        for (i <- 0 until 4) {
            for (j <- 0 until 4) {
                if (i < j) {
                    tmp = items(i)(j)
                    items(i)(j) = items(j)(i)
                    items(j)(i) = tmp
                }
            }
        }
    }

    private def mirror() : Unit = {
        var tmp = 0
        for (i <- 0 until 4) {
            for (j <- 0 until 2) {
                tmp = items(i)(j)
                items(i)(j) = items(i)(3 - j)
                items(i)(3 - j) = tmp
            }
        }
    }
}

def play() {
    val b = new Board
    b.insert()
    b.insert()

    while (true) {
        println(b)
        val s = readLine("What is your move: ").toLowerCase.trim
        println()

        if (s == "x") sys.exit(0)
        if (s.length == 1 && ("lrud" contains s)) {
            b.push(s(0))
            b.insert()
        }
    }
}

def playUI() {
    val b = new Board
    b.insert()
    b.insert()

    val canvas = new BufferedImage(500, 500, BufferedImage.TYPE_INT_RGB)
    var score = 0
    while (true) {
        setTitle("2048 - Current Point: " + score)
        b.draw(canvas)
        show(canvas)

        val ch = waitKey()
        if (ch == 'x') sys.exit(0)
        if ("lrud" contains ch) {
            score += b.push(ch)
            if (b.isFull()) {
                showMessage("Game over. You archieved " + score + " points.")
                sys.exit(0)
            }
            b.insert()
        }
    }
}

//play()
playUI()