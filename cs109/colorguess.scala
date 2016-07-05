import org.otfried.cs109.UI._
import java.awt.image.BufferedImage
import java.awt.{Graphics2D,Color,Font,BasicStroke}
import java.awt.geom._
import scala.io.StdIn._

var correct = 0
var total = 0
var delta = 20

def hsvtorgb(h: Int, s: Int, v: Int): (Int, Int, Int) = {
    if (s == 0) {
        (v, v, v)
    } else {
        val sector = h / 60
        val f = h % 60
        val p = v * ( 255 - s ) / 255
        val q = v * ( 15300 - s * f ) / 15300
        val t = v * ( 15300 - s * ( 60 - f )) / 15300
        sector match {
            case 0 => (v, t, p)
            case 1 => (q, v, p)
            case 2 => (p, v, t)
            case 3 => (p, q, v)
            case 4 => (t, p, v)
            case 5 => (v, p, q)
        }
    }
}

def makeColor(h: Int, s: Int, v: Int): Color = {
    val (r, g, b) = hsvtorgb(h, s, v)
    return new Color(r, g, b)
}

def randomHSV(): (Int, Int, Int) = {
    ((math.random * 360).toInt,
        128 + (math.random * 128).toInt,
        128 + (math.random * 128).toInt)
}

def drawPicture(orig: (Int, Int, Int), loc: (Int, Int)): BufferedImage = {
    val image = new BufferedImage(500, 500, BufferedImage.TYPE_INT_RGB)
    val g = image.createGraphics()
    g.setColor(new Color(238, 238, 238))
    g.fill(new Rectangle2D.Double(0.0, 0.0, 500.0, 500.0))

    val (h, s, v) = orig
    var newH = 0
    if ((math.random * 2).toInt == 0)
        newH = (h + delta) % 360
    else
        newH = (h - delta) % 360

    g.setColor(Color.black) // a darker green
    g.setFont(new Font("Malgun Gothic", Font.PLAIN, 20))
    for (x <- 0 until 4)
        g.drawString((x + '1').toChar.toString, 87 + 120 * x, 20)
    for (y <- 0 until 4)
        g.drawString((y + 'a').toChar.toString, 15, 95 + 120 * y)

    for (x <- 0 until 4) {
        for (y <- 0 until 4) {
            if ((x, y) == loc)
                g.setColor(makeColor(newH, s, v))
            else
                g.setColor(makeColor(h, s, v))
            g.fill(new Rectangle2D.Double(40.0 + 120.0 * x, 40.0 + 120.0 * y, 100.0, 100.0))
        }
    }

    g.dispose()
    return image
}

def nextIteration(): Boolean = {
    val color = randomHSV()
    val loc = ((math.random * 4).toInt, (math.random * 4).toInt)
    val image = drawPicture(color, loc)
    show(image)

    print("Which square has a different color? (x to exit) ")

    val input = readLine()
    if (input == "x")
        return false

    if (input.length >= 2 && (input(0) - '1', input(1) - 'a') == loc) {
        correct += 1
        println("That is correct")
    } else {
        println("That is not correct.  Square " + (loc._1 + '1').toChar + (loc._2 + 'a').toChar + " has a different color.")
        print("Press Enter for the next question>")
        readLine()
    }
    return true
}

if (args.length > 0)
    delta = args(0).toInt

setTitle("How good is your color vision?")
while (nextIteration()) {
    total += 1
    println("You answered " + correct + " of " + total + " tests correctly.")
}

println("Program is terminated. Press Control+C to exit.")