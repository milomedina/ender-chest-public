import org.otfried.cs109.UI._
import java.awt.image.BufferedImage
import java.awt.{Graphics2D,Color,Font,BasicStroke}
import java.awt.geom._
import scala.io.StdIn._

def generateSequence(seqLen: Int): String = {
    var num = 0; var prev = -1
    var s = ""
    val set = "rgby"

    while (num < seqLen) {
        val g = (math.random * 4).toInt
        if (prev != g) {
            prev = g
            s += set(g)
            num += 1
        }
    }
    s
}

def draw(canvas: BufferedImage, color: Char) = {
    val cmap = Map('r' -> new Color(255, 0, 0), 'g' -> new Color(0, 255, 0), 'b' -> new Color(0, 0, 255), 'y' -> new Color(255, 255, 0))
    val lmap = Map('r' ->(0, 1), 'g' ->(0, 0), 'b' ->(1, 1), 'y' ->(1, 0))
    val g = canvas.createGraphics()
    g.setColor(new Color(238, 238, 238))
    g.fill(new Rectangle2D.Double(0.0, 0.0, 500.0, 500.0))

    val colors = if (color != '*') color + "" else "rgby"

    if (color != ' ') {
        for (ch <- colors) {
            g.setColor(cmap(ch))
            g.fill(new Rectangle2D.Double(25 + lmap(ch)._1 * 250, 25 + lmap(ch)._2 * 250, 200, 200))
        }
    }
    g.dispose()
}

def performSequence(canvas: BufferedImage, seq: String, blink: Int) = {
    for (ch <- seq) {
        draw(canvas, ch)
        show(canvas)
        Thread.sleep(blink)
    }
    draw(canvas, ' ')
    show(canvas)
    Thread.sleep(800)
    draw(canvas, '*')
    show(canvas)
}

def showReadyWait(canvas: BufferedImage, points: Int, rounds: Int): Boolean = {
    val g = canvas.createGraphics()
    g.setColor(new Color(238, 238, 238))
    g.fill(new Rectangle2D.Double(0.0, 0.0, 500.0, 500.0))

    g.setColor(new Color(0, 0, 0))
    g.setFont(new Font("Malgun Gothic", Font.PLAIN, 40))
    g.drawString("Ready?", 200, 200)

    g.setFont(new Font("Malgun Gothic", Font.PLAIN, 20))
    g.drawString("Rounds: " + rounds, 0, 50)
    g.drawString("Points: " + points, 0, 80)

    g.dispose()
    show(canvas)

    while(true) {
        val ch = waitKey()
        if (ch == 10) return true
        if (ch == 'x') return false
    }
    false
}

def validate(canvas: BufferedImage, seq: String) : Boolean = {
    val set = "rgbyx"
    for (ch <- seq) {
        var key = ' '
        while (!(set contains key))
            key = waitKey()

        if (key == 'x')
            close()
        else if (key == ch) {
            draw(canvas, ch)
            show(canvas)
            Thread.sleep(200)
            draw(canvas, ' ')
            show(canvas)
        } else
            return false
    }
    true
}

def showResult(canvas: BufferedImage, result: Boolean) = {
    val g = canvas.createGraphics()
    g.setColor(new Color(238, 238, 238))
    g.fill(new Rectangle2D.Double(0.0, 0.0, 500.0, 500.0))

    g.setColor(new Color(0, 0, 0))
    g.setFont(new Font("Malgun Gothic", Font.PLAIN, 40))
    g.drawString(if (result) "Correct" else "Wrong!", 200, 200)

    show(canvas)
    Thread.sleep(500)
}

def main(cheat: Boolean) {
    val canvas = new BufferedImage(500, 500, BufferedImage.TYPE_INT_RGB)
    var blink = 600; var seqLen = 4; var points = 0; var rounds = 0

    while (true) {
        val continue = showReadyWait(canvas, points, rounds)
        if (!continue) close()

        val seq = generateSequence(seqLen)
        performSequence(canvas, seq, blink)

        if (cheat) println(seq)

        val result = validate(canvas, seq)
        showResult(canvas, result)

        rounds += 1
        if (result) {
            points += seqLen
            seqLen += 1
            blink = (blink * 0.9).toInt
        } else {
            seqLen -= (if (seqLen < 3) 0 else 2)
            blink = (blink * 1.21).toInt
        }
    }
}

main(args.nonEmpty)