import scala.io.StdIn.readLine
import scala.util.Random

val HAND = 7
val letterValues = scala.collection.immutable.Map(
    'A'-> 1, 'B'-> 3, 'C'-> 3, 'D'-> 2, 'E'-> 1, 'F'-> 4,
    'G'-> 2, 'H'-> 4, 'I'-> 1, 'J'-> 8, 'K'-> 5, 'L'-> 1,
    'M'-> 3, 'N'-> 1, 'O'-> 1, 'P'-> 3, 'Q'-> 10, 'R'-> 1,
    'S'-> 1, 'T'-> 1, 'U'-> 1, 'V'-> 4, 'W'-> 4, 'X'-> 8,
    'Y'-> 4, 'Z'-> 10)

var dict: Array[String] = Array.empty[String]

def generateHand(): Array[Char] = {
    var arr = Array.empty[Char]
    val nVowels = HAND / 3

    for (i <- 0 until nVowels)
        arr :+= Array('A', 'E', 'I' ,'O', 'U')(Random.nextInt(5))

    for (i <- 0 until HAND - nVowels)
        arr :+= ('A' + Random.nextInt(26)).toChar

    arr.sortWith((a, b) => a < b)
}

def validate(word: String, hand: Array[Char]): (Boolean, Array[Char], Int, String) = {
    if (!(dict contains word))
        return (false, hand, 0, word + " is not a word. Try again!")

    var newHand = hand.clone()
    var deltaScore = 0

    for (ch <- word) {
        val index = newHand.indexWhere(c => c == ch)
        if (index == -1)
            return (false, hand, 0, "You cannot make " + word + " with your hand")

        newHand  = newHand diff Array(ch)
        deltaScore += letterValues(ch)
    }
    (true, newHand, deltaScore, "")
}

def cheatKey(hand: Array[Char]): Unit = {
    var possible = Array.empty[(String, Int)]
    for (i <- 0 until dict.length) {
        var newHand = hand.clone()
        var score = 0
        var ok = true
        for (ch <- dict(i)) {
            val index = newHand.indexWhere(c => c == ch)
            if (index == -1)
                ok = false

            newHand  = newHand diff Array(ch)
            score += letterValues(ch)
        }
        if (ok)
            possible :+= (dict(i), score)
    }
    possible = possible.sortWith((a, b) => a._2 > b._2)
    for (t <- possible)
        printf("%2d %s\n", t._2, t._1)
}

def game(): Unit = {
    var hand = generateHand()
    var score = 0
    while (true) {
        print("\nHere is your hand: ")
        hand.foreach(c => print(c + " "))
        print("\n\nEnter your word: ")

        val input = readLine().trim.map(c => c.toUpper)
        if (input == "") {
            println("\nYour total score was " + score + " points.\n")
            return
        } else if (input == "?")
            cheatKey(hand)
        else {
            val (ok, newHand, deltaScore, msg) = validate(input, hand)
            if (ok) {
                if (score == 0 && newHand.length == 0)
                    score += 50

                score += deltaScore
                hand = newHand
                println(input + " is a good word and scores " + deltaScore + " points.")

                if (newHand.length == 0) {
                    println("\nYour total score was " + score + " points.\n")
                    return
                }
            } else
                println(msg)
        }
    }
}

def loop(): Unit = {
    val term = Array("n", "no", "quit", "end", "q", "exit")
    println("Welcome to KAIST Scrabble!")
    while (true) {
        game()
        print("Would you like to play again? ")
        if (term contains readLine().map(c => c.toLower)) {
            println("Good bye!")
            return
        }
    }
}

dict = scala.io.Source.fromFile("scrabble.txt").getLines.toArray
loop()