val digits =
    Array(Array(true, true, true, true, true, true, false),      // 0
        Array(true, true, false, false, false, false, false),  // 1
        Array(true, false, true, true, false, true, true),     // 2
        Array(true, true, true, false, false, true, true),     // 3
        Array(true, true, false, false, true, false, true),    // 4
        Array(false, true, true, false, true, true, true),     // 5
        Array(false, true, true, true, true, true, true),      // 6
        Array(true, true, false, false, false, true, false),   // 7
        Array(true, true, true, true, true, true, true),       // 8
        Array(true, true, true, false, true, true, true),      // 9
        Array(false, false, false, false, false, false, false)) // Blank

def lcdDigit(digit: Char, k: Int, c: Char): String = {
    val d = if ('0' <= digit && digit <= '9') digit - '0' else 10
    val seg = digits(d)
    var str = ""
    str += " " + (if (seg(5)) c.toString * k else " " * k) + " \n"
    for (i <- 0 until k)
        str += (if (seg(4)) c else " ") + (" " * k) + (if (seg(0)) c else " ") + "\n"
    str += " " + (if (seg(6)) c.toString * k else " " * k) + " \n"
    for (i <- 0 until k)
        str += (if (seg(3)) c else " ") + (" " * k) + (if (seg(1)) c else " ") + "\n"
    str += " " + (if (seg(2)) c.toString * k else " " * k) + " "
    str
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
    arr.mkString("\n")
}

def lcd(s: String, k: Int, c: Char, sep: String): String = {
    var result = lcdDigit(s(0), k, c)
    for (i <- 1 until s.length)
        result = combine(result, sep, lcdDigit(s(i), k, c))
    result
}

def clearScreen() {
    println("\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n")
}

def clock() {
    val form = new java.text.SimpleDateFormat("HH mm ss")
    var current = form.format(java.util.Calendar.getInstance().getTime)
    clearScreen()
    println(lcd(current, 4, '#', " "))
    while (true) {
        Thread.sleep(100)
        val ntime = form.format(java.util.Calendar.getInstance().getTime)
        if (ntime != current) {
            current = ntime
            clearScreen()
            println(lcd(current, 4, '#', " "))
        }
    }
}

clock()