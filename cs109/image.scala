import java.io.File
import javax.imageio.ImageIO
import java.awt.image.BufferedImage

def phototest(img: BufferedImage): BufferedImage = {
    // obtain width and height of image
    val w = img.getWidth
    val h = img.getHeight

    // create new image of the same size
    val out = new BufferedImage(w, h, BufferedImage.TYPE_INT_RGB)

    // copy pixels (mirror horizontally)
    for (x <- 0 until w)
        for (y <- 0 until h)
            out.setRGB(x, y, img.getRGB(w - x - 1, y) & 0xffffff)

    // draw red diagonal line
    for (x <- 0 until (h min w))
        out.setRGB(x, x, 0xff0000)

    out
}

def decompose(color: Int): (Int, Int, Int) = {
    return (((color & 0xff0000) / 65536), ((color & 0xff00) / 256), (color & 0xff));
}

def compose(r: Int, g: Int, b: Int): Int = {
    return r * 65536 + g * 256 + b
}

def compose(r: Double, g: Double, b: Double): Int = {
    return r.toInt * 65536 + g.toInt * 256 + b.toInt
}

def sepia(img: BufferedImage): BufferedImage = {
    val w = img.getWidth
    val h = img.getHeight

    val out = new BufferedImage(w, h, BufferedImage.TYPE_INT_RGB)

    for (x <- 0 until w) {
        for (y <- 0 until h) {
            val (red, green, blue) = decompose(img.getRGB(x, y))
            val v = 0.299 * red.toDouble + 0.587 * green.toDouble + 0.114 * blue.toDouble

            var r = v; val g = v; var b = v
            if (v <= 62) {
                r *= 1.1; b *= 0.9
            } else if (v <= 191) {
                r *= 1.15; b *= 0.85
            } else {
                r = math.min(255, r * 1.08); b *= 0.93
            }
            out.setRGB(x, y, compose(r, g, b))
        }
    }
    return out
}

def posterize(img: BufferedImage, colors: Array[Int]): BufferedImage = {
    val w = img.getWidth
    val h = img.getHeight

    val out = new BufferedImage(w, h, BufferedImage.TYPE_INT_RGB)

    for (x <- 0 until w) {
        for (y <- 0 until h) {
            val color = img.getRGB(x, y)
            val (r, g, b) = decompose(color)

            var matchC = 0; var minDist = 9999999
            for (c <- colors) {
                val (nr, ng, nb) = decompose(c)
                val dist = (nr - r) * (nr - r) + (ng - g) * (ng - g) + (nb - b) * (nb - b)
                if (dist < minDist) {
                    minDist = dist
                    matchC = compose(nr, ng, nb)
                }
            }
            out.setRGB(x, y, matchC)
        }
    }
    return out
}

def randomColor(): Int = (math.random * 0x1000000).toInt

def randomColors(k: Int): Array[Int] = {
    val colors = new Array[Int](k)
    for (i <- 0 until k)
        colors(i) = randomColor()
    return colors
}

def selectColors(img: BufferedImage, k: Int): Array[Int] = {
    val allColorsSet = scala.collection.mutable.Set[Int]()
    val w = img.getWidth; val h = img.getHeight
    for (x <- 0 until w)
        for (y <- 0 until h)
            allColorsSet += img.getRGB(x, y)

    val allColors = allColorsSet.toArray
    val colorsSet = scala.collection.mutable.Set[Int]()
    for (i <- 0 until k)
        colorsSet += allColors((math.random * allColors.size).toInt)

    var colors = colorsSet.toArray
    for (iter <- 0 until 1) {
        val nextColors = new Array[Int](k)
        for (i <- 0 until colors.size) {
            val closeColor = scala.collection.mutable.Set[Int]()
            for (ac <- allColors) {
                var closest = 0; var minDist = 9999999
                val (r, g, b) = decompose(ac)
                for (cp <- colors) {
                    val (nr, ng, nb) = decompose(cp)
                    val dist = (nr - r) * (nr - r) + (ng - g) * (ng - g) + (nb - b) * (nb - b)
                    if (dist < minDist) {
                        minDist = dist
                        closest = cp
                    }
                }
                if (closest == colors(i))
                    closeColor += ac
            }
            nextColors(i) = (closeColor.sum.toDouble / closeColor.size).toInt
        }
        colors  = nextColors.clone()
    }
    return colors
}

def newspaper(img: BufferedImage): BufferedImage = {
    val bsize = 2;
    val w = (img.getWidth / bsize).toInt * bsize
    val h = (img.getHeight / bsize).toInt * bsize

    val out = new BufferedImage(w, h, BufferedImage.TYPE_INT_RGB)

    for (bx <- 0 until w / bsize) {
        for (by <- 0 until h / bsize) {
            var colorSum = 0;
            for (x <- 0 until bsize)
                for  (y <- 0 until bsize)
                    colorSum += img.getRGB(bx * bsize + x, by * bsize + y)

            val (r, g, b) = decompose(colorSum / (bsize * bsize))
            val lu = ((0.21 * r + 0.72 * g + 0.07 * b) / 255 * bsize).toInt
            for (i <- 0 until (bsize * bsize)) {
                val x = i / bsize; val y = i % bsize;
                var color = compose(255, 255, 255)
                if (i > lu * bsize)
                    color = compose(0, 0, 0)
                out.setRGB(bx * bsize + x, by * bsize + y, color)
            }
        }
    }
    return out
}

def test() {
    val photo = ImageIO.read(new File("wallpaper.jpg"))

    //ImageIO.write(phototest(photo), "jpg", new File("mirror.jpg"))
    //ImageIO.write(sepia(photo), "jpg", new File("sepia.jpg"))
    //ImageIO.write(posterize(photo, randomColors(10)), "jpg", new File("posterize.jpg"))
    //ImageIO.write(posterize(photo, selectColors(photo, 100)), "jpg", new File("posterize2.jpg"))
    ImageIO.write(newspaper(photo), "jpg", new File("newspaper.jpg"))
}

test()