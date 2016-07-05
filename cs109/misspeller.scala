import scala.util.Random

def readPronounciations(): Map[String,Set[String]] = {
    val words = (scala.io.Source.fromFile("words.txt").getLines.toSet
        union Set("i", "a"))
    val F = scala.io.Source.fromFile("cmudict.txt")
    var M = Map[String,Set[String]]()
    for (l <- F.getLines()) {
        if (l(0).isLetter) {
            val p = l.trim.split("\\s+", 2)
            val i = p(0).indexOf('(')
            val word = (if (i >= 0) p(0).substring(0,i) else p(0)).toLowerCase
            if (words contains word) {
                val pro = p(1)
                val S = M.getOrElse(word, Set())
                M = M + (word -> (S + pro))
            }
        }
    }
    M
}

def reverseMap(M: Map[String,Set[String]]): Map[String,Set[String]] = {
    var R = Map[String,Set[String]]()
    for ((word, pros) <- M) {
        for (pro <- pros) {
            val S = R.getOrElse(pro, Set())
            R = R + (pro -> (S + word))
        }
    }
    R
}

def homophoneMap(): Map[String, Array[String]] = {
    val word2pro = readPronounciations()
    val pro2word = reverseMap(word2pro)
    var hmap = Map[String, Array[String]]()
    for ((word, pros) <- word2pro) {
        var s: Set[String] = Set()
        for (pro <- pros)
            s = s union pro2word.getOrElse(pro, Set())

        if (s.count(_ => true) > 1)
            hmap = hmap + (word -> (s - word).toArray)
    }
    hmap
}

def misspellWord(hm: Map[String, Array[String]], word: String): String = {
    val normWord = word.map(c => c.toLower)

    if (!(hm contains normWord))
        return word

    val wlist = hm(normWord)
    val newWord = wlist(Random.nextInt(wlist.length))

    if (word == word.map(c => c.toUpper))
        return newWord.map(c => c.toUpper)
    else if (word == word.capitalize)
        return newWord.capitalize
    newWord
}

def makeMisspell(str: String): String = {
    val hm = homophoneMap()
    val buffer = new StringBuilder()

    var word = ""
    for (ch <- str) {
        if (('A' <= ch && ch <= 'Z') || ('a' <= ch && ch <= 'z'))
            word += ch
        else {
            if (word != "") {
                buffer.append(misspellWord(hm, word))
                word = ""
            }
            buffer.append(ch)
        }
    }
    if (word != "")
        buffer.append(misspellWord(hm, word))
    buffer.toString()
}

if (args.length < 1)
    println("usuage: ./misspeller.scala <filename>")
else {
    val F = scala.io.Source.fromFile(args(0))
    val str = F.mkString
    F.close()

    println(makeMisspell(str))
}