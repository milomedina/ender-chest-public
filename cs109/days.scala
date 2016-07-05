val monthLength = Array(31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31)
val leapMonthLength = Array(31, 29, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31)
val fourYears = (365 + 365 + 365 + 366)
val daysOfWeek = Array("Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday")
val monthName = Array("January", "February", "March", "April", "May", "June", "July", "August", "October", "September", "November", "December")

def isLeapYear(year: Int): Boolean = {
    year % 400 == 0 || (year % 100 != 0 && year % 4 == 0)
}

// returns the number of days since 1600/01/01 (day 0)
// returns -1 if illegal, or out of range 1600~
def date2num(year: Int, month: Int, day: Int): Int = {
    if (year < 1600 || month < 1 || month > 12)
        return -1

    val isLeap = isLeapYear(year)
    val ml = if (isLeap) leapMonthLength else monthLength
    if (day < 1 || day > ml(month-1))
        return -1

    var total = 0
    for (y <- 1600 until year)
        total += (if (isLeapYear(y)) 366 else 365)
    for (m <- 0 until month - 1)
        total += ml(m)
    total += (day - 1)
    total
}

// decode a string date
// returns (0,0,0) if not in "YYYY/MM/DD" format
def string2date(s: String): (Int, Int, Int) = {
    val date = """(\d\d\d\d)/(\d\d)/(\d\d)""".r
    s match {
        case date(year, month, day) => return (year.toInt, month.toInt, day.toInt)
        case _ => return (0, 0, 0)
    }
}

def num2date(n: Int): (Int, Int, Int) = {
    var year = 1600; var month = 0;
    var total = n

    var yearD = 366;
    while (total >= yearD) {
        total -= yearD
        year += 1
        yearD = if (isLeapYear(year)) 366 else 365
    }

    val ml = if (isLeapYear(year)) leapMonthLength else monthLength
    while (total >= ml(month)) {
        total -= ml(month)
        month += 1
    }

    (year, month + 1, total + 1)
}

def string2calendar(s: String): String = {
    val date = string2date(s)
    val num = date2num(date._1, date._2, 1)
    val dow = (num - 1) % 7
    val max = (if (isLeapYear(date._1)) leapMonthLength else monthLength)(date._2 - 1)

    var cal = monthName(date._2 - 1) + " " + date._1
    cal = "\r\n" + " " * ((20 - cal.length) / 2) + cal
    cal += "\r\nSu Mo Tu We Th Fr Sa\r\n"
    for (i <- 0 until dow)
        cal += "   "
    for (i <- 1 until max + 1) {
        cal += "%2d ".format(i)
        if ((i + dow) % 7 == 0)
            cal += "\r\n"
    }
    cal
}

def string2num(s: String): Int = {
    val date = string2date(s)
    if (date == (0, 0, 0)) -1
    date2num(date._1, date._2, date._3)
}

def num2string(num: Int): String = {
    val date = num2date(num)
    "%04d/%02d/%02d".format(date._1, date._2, date._3)
}

if (args.length == 0)
    println("Need at Least One Argument")
else if (args.length == 1) {
    val num = string2num(args(0))
    if (num == -1) {
        println("Illegal date")
        System.exit(0)
    }

    println(args(0) + " is a " + daysOfWeek((num + 5) % 7))
    println(string2calendar(args(0)))
}
else if (args.length == 2) {
    val num1 = string2num(args(0))
    val num2 = string2num(args(1))
    if (num1 == -1 || num2 == -1) {
        println("Illegal date")
        System.exit(0)
    }

    println("There are " + (num2 - num1) + " days between " + args(0) + " and " + args(1))
}
else if (args.length == 3) {
    val lhs = string2num(args(0))
    if (lhs == -1) {
        println("Illegal date")
        System.exit(0)
    }

    val op = args(1); val rhs = args(2).toInt
    var result = ""
    if (op == "+")
        result = num2string(lhs + rhs)
    else if (op == "-")
        result = num2string(lhs - rhs)
    println(args(0) + " " + args(1) + " " + args(2) + " days = " + result)
}