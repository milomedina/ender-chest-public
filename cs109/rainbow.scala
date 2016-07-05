import org.otfried.cs109.UI._
import java.awt.image.BufferedImage

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

def compose(rgb: (Int, Int, Int)): Int = {
    return rgb._1 * 65536 + rgb._2 * 256 + rgb._3
}

def makeColorPic(v: Int): BufferedImage = {
    val image = new BufferedImage(360, 256, BufferedImage.TYPE_INT_RGB)
    for (x <- 0 until 360)
        for (y <- 0 until 256)
            image.setRGB(x, y, compose(hsvtorgb(x, y, v)))
    return image
}

var v = 255
if (args.length > 0)
    v = args(0).toInt

while (v != -1) {
    setTitle("Rainbows for v = " + v.toString)
    val image = makeColorPic(v)
    show(image)
    v -= 1
    Thread.sleep(100)
}