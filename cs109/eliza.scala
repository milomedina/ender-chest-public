import scala.util.Random

val conjugations = Map("are" -> "am",
    "were" -> "was",
    "i" -> "you",
    "im" -> "you are",
    "my" -> "your",
    "me" -> "you",
    "ive" -> "you've",
    "you" -> "I",
    "your" -> "my",
    "myself" -> "yourself",
    "yourself" -> "myself")

def readReplies() : (List[String], Map[String, Set[String]]) = {
    val F = scala.io.Source.fromFile("replies.txt")
    var L = List[String]()
    var M = Map[String,Set[String]]()

    var curl = ""
    var set = Set[String]()

    for (l <- F.getLines()) {
        if (l.endsWith(":")) {
            M = M + (curl -> set)

            curl = l.substring(0, l.length - 1)
            set = Set[String]()
            L = L ++ curl.split('|').toList
        } else
            set += l
    }
    (L, M + (curl -> set))
}

def sanitize(s: String): String = {
    var news = " "
    var isw = false
    for (ch <- s) {
        if (ch.isLetter) {
            news += ch.toLower
            isw = false
        } else if (ch == ' ' && !isw) {
            news += ch
            isw = true
        }
    }
    news + " "
}

def findKeyword(s: String, kwds: List[String]): String = {
    for (key <- kwds)
        if (s contains (" " + key + " "))
            return key
    ""
}

def loop() : Unit = {
    val (kwds, db) = readReplies()

    println("Hi! I'm Eliza, what is your problem?")
    var prev = "#"
    while (true) {
        print("> ")
        val s = sanitize(readLine())
        if (s == " shut up ")
            return
        else if (s == prev)
            println("Please do not repeat yourself!")
        else {
            prev = s

            val keyword = findKeyword(s, kwds)
            val replies = db.filter(p => p._1 contains keyword).head._2.toArray
            val reply = replies(Random.nextInt(replies.length))

            if (reply contains "*") {
                var response = reply.substring(0, reply.length - 1)
                val arr = s.substring(s.indexOf(keyword)).split(' ').tail
                for (word <- arr) {
                    if (conjugations contains word)
                        response += " " + conjugations(word)
                    else
                        response += " " + word
                }
                println(response)
            } else
                println(reply)
        }
    }
}

loop()