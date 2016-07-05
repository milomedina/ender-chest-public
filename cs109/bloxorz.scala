import org.otfried.cs109.UI._
import java.awt.image.BufferedImage
import java.awt.{Graphics2D,Color,Font,BasicStroke}
import java.awt.geom._
import scala.io.StdIn._

case class Pos(x: Int, y: Int) {
    def dx(d: Int): Pos = Pos(x + d, y)
    def dy(d: Int): Pos = Pos(x, y + d)
}

class Block(p: Pos) {
    private var loc = p
    private var state = 'N'

    override def toString: String = {
        "Block{%s}".format(positions.map(_.toString).mkString(","))
    }

    def positions: List[Pos] = {
        state match {
            case 'N' => loc :: Nil
            case 'V' => loc :: Pos(loc.x, loc.y + 1) :: Nil
            case 'H' => loc :: Pos(loc.x + 1, loc.y) :: Nil
            case _ => Nil
        }
    }

    def getState: Char = state
    def isStanding: Boolean = state == 'N'

    def left(): Unit = {
        state match {
            case 'N' => state = 'H'; loc = loc.dx(-2)
            case 'V' => loc = loc.dx(-1)
            case 'H' => state = 'N'; loc = loc.dx(-1)
        }
    }

    def right(): Unit = {
        state match {
            case 'N' => state = 'H'; loc = loc.dx(1)
            case 'V' => loc = loc.dx(1)
            case 'H' => state = 'N'; loc = loc.dx(2)
        }
    }

    def up(): Unit = {
        state match {
            case 'N' => state = 'V'; loc = loc.dy(-2)
            case 'V' => state = 'N'; loc = loc.dy(-1)
            case 'H' => loc = loc.dy(-1)
        }
    }

    def down(): Unit = {
        state match {
            case 'N' => state = 'V'; loc = loc.dy(1)
            case 'V' => state = 'N'; loc = loc.dy(2)
            case 'H' => loc = loc.dy(1)
        }
    }
}

class Terrain(fname: String) {
    private var map = Array[Array[Char]]()
    private var sw = Map[Char, (Boolean, Boolean, Char)]() // symbol, heavy, turn on/off, target
    private var bridge = Map[Char, Boolean]()
    parse()

    private def parse(): Unit = {
        val F = scala.io.Source.fromFile(fname)
        val lines = F.getLines().toArray; F.close()
        val rmap = lines.filterNot(_(0) == '#').filterNot(_ == "")
        val height = rmap.length; var width = 0
        for (str <- rmap)
            width = Math.max(str.length, width)

        map = new Array[Array[Char]](width)
        for (i <- 0 until width)
            map(i) = new Array[Char](height)

        for (i <- 0 until width) {
            for (j <- 0 until height) {
                if (rmap(j).length <= i)
                    map(i)(j) = '-'
                else
                    map(i)(j) = rmap(j)(i)
            }
        }

        val swline = lines.filter(_(0) == '#')
        val stline = lines.filter(_(0) == '%').map(x => x(1))

        for (i <- 0 until swline.length) {
            val target =  swline(i)(swline(i).length - 1)
            sw += (swline(i)(1) -> (swline(i)(2) == 'X',
                swline(i).length == 4 || (swline(i).length == 5 && swline(i)(3) == '-'), target))
            bridge += (target -> (stline contains target))
        }
    }

    def start: Pos = {
        for (i <- 0 until width)
            for (j <- 0 until height)
                if (map(i)(j) == 'S')
                    return Pos(i, j)
        Pos(-1, -1)
    }

    def target: Pos = {
        for (i <- 0 until width)
            for (j <- 0 until height)
                if (map(i)(j) == 'T')
                    return Pos(i, j)
        Pos(-1, -1)
    }

    def width: Int = map.length
    def height: Int = map(0).length

    def apply(p: Pos): Int = {
        if (!inBoundary(p)) return 0

        val target = map(p.x)(p.y)
        if (target == 'o' || (target >= 'A' && target <= 'Z') ||
            (target.isLetter && (bridge contains target) && bridge(target))) return 2
        else if (target == '.') return 1
        0
    }

    def inBoundary(p: Pos): Boolean = {
        !(p.x < 0 || p.y < 0 || p.x >= width || p.y >= height)
    }

    def canHold(b: Block): Boolean = {
        val l = b.positions
        if (b.isStanding) {
            val v = if (inBoundary(l.head)) map(l.head.x)(l.head.y) else '0'
            if (v >= 'A' && v <= 'Z' && v != 'S' && v != 'T')
                bridge += (sw(v)._3 -> sw(v)._2)
        } else {
            val v1 = if (inBoundary(l.head)) map(l.head.x)(l.head.y) else '0'
            val v2 = if (inBoundary(l.tail.head)) map(l.tail.head.x)(l.tail.head.y) else '0'
            if (v1 >= 'A' && v1 <= 'Z' && v1 != 'S' && v1 != 'T' && !sw(v1)._1)
                bridge += (sw(v1)._3 -> sw(v1)._2)
            if (v2 >= 'A' && v2 <= 'Z' && v2 != 'S' && v2 != 'T' && !sw(v2)._1)
                bridge += (sw(v2)._3 -> sw(v2)._2)
        }
        if (b.isStanding)
            this(l.head) == 2
        else
            this(l.head) > 0 && this(l.tail.head) > 0
    }

    def isHeavy(c: Char): Boolean = sw(c)._1
    def isBridgeEnabled(c: Char): Boolean = bridge(c)
    def get(x: Int, y: Int): Char = map(x)(y)
}

object Bloxorz {
    def tileSize(t: Terrain): Int = {
        var ts = 60
        while (ts > 5) {
            if (t.width * ts <= 800 && t.height * ts <= 640)
                return ts
            ts -= 2
        }
        ts
    }

    def draw(canvas: BufferedImage, terrain: Terrain, ts: Int, block: Block): Unit = {
        val g = canvas.createGraphics()
        g.setColor(Color.white)
        g.fill(new Rectangle2D.Double(0, 0, canvas.getWidth, canvas.getHeight))

        for (i <- 0 until terrain.width) {
            for (j <- 0 until terrain.height) {
                terrain.get(i, j) match {
                    case 'o' | 'S' => g.setColor(Color.blue)
                    case '.' => g.setColor(Color.orange)
                    case 'T' => g.setColor(Color.green)
                    case '-' => g.setColor(Color.white)
                    case v if v >= 'A' && v <= 'Z' && terrain.isHeavy(v) =>
                        g.setColor(Color.black)
                    case v if v >= 'A' && v <= 'Z' && !terrain.isHeavy(v) =>
                        g.setColor(Color.gray)
                    case v if v >= 'a' && v <= 'z' && terrain.isBridgeEnabled(v)
                        => g.setColor(Color.blue)
                    case _ => g.setColor(Color.white)
                }
                g.fill(new Rectangle2D.Double(i * ts + 1, j * ts + 1, ts - 2, ts - 2))
            }
        }

        g.setColor(Color.red)
        val pos = block.positions.head
        block.getState match {
            case 'N' =>
                g.fill(new Rectangle2D.Double(pos.x * ts, pos.y * ts, ts, ts))
            case 'V' =>
                g.fill(new Rectangle2D.Double(pos.x * ts, pos.y * ts, ts, ts * 2))
            case 'H' =>
                g.fill(new Rectangle2D.Double(pos.x * ts, pos.y * ts, ts * 2, ts))
        }
    }

    def makeMove(block: Block, ch: Char): Unit = {
        ch match {
            case 'l' => block.left()
            case 'r' => block.right()
            case 'u' => block.up()
            case 'd' => block.down()
        }
    }

    def playLevel(level: Int) {
        val terrain = new Terrain("bloxorz\\level%02d.txt".format(level))
        val ts = tileSize(terrain)
        val canvas = new BufferedImage(ts * terrain.width + 20,
            ts * terrain.height + 20,
            BufferedImage.TYPE_INT_RGB)
        var block = new Block(terrain.start)
        var moves = 0
        while (true) {
            setTitle("Bloxorz Level %d (%d moves)".format(level, moves))
            draw(canvas, terrain, ts, block)
            show(canvas)
            val ch = waitKey()
            if ("lurd" contains ch) {
                makeMove(block, ch)
                moves += 1
            }
            if (block.isStanding && block.positions.head == terrain.target) {
                showMessage("Congratulations, you solved level %d".format(level))
                return
            }
            if (!terrain.canHold(block)) {
                showMessage("You fell off the terrain")
                block = new Block(terrain.start)
            }
        }
    }
}

for (i <- 1 to 9)
    Bloxorz.playLevel(i)