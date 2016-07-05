//
// Mastermind game
// 

val CodeLength = 5
val MaxNumGuesses = 10

// Create secret: four distinct letters from A-F.
def createSecret(): String = {
    var c = "ABCDEF"
    var secret = ""
    for (i <- 1 to CodeLength) {
        val index = (math.random * c.length).toInt
        val letter = c(index)
        secret = secret + letter
    }
    secret
}

// Check if guess is legal: Four distinct letters from A-F.
// Returns pair (ok: Boolean, message : String) 
def checkGuess(guess: String): (Boolean, String) = {
    if (guess.length != CodeLength)
        return (false, "Your guess must have " + CodeLength + " letters")
    for (i <- 0 until CodeLength) {
        val letter = guess(i)
        if (!"ABCDEF".contains(letter))
            return (false, "You can only use letters A, B, C, D, E, and F.")
    }
    return (true, "")
}

// read a guess from the terminal
def getGuess(): String = {
    while (true) {
        var guess = readLine("Enter your guess> ")
        guess = guess.trim.toUpperCase.replace(" ", "")
        val (ok, msg) = checkGuess(guess)
        if (ok)
            return guess
        println(msg)
    }
    "" // only necessary because compiler complains otherwise
}

// Compute (pos, let) where pos is the number of correct letters in
// the correct position, and let is the number of correct letters in
// the wrong position.
def evaluateGuess(secret: String, guess: String): (Int, Int) = {
    var pos = 0
    var let = 0
    var newSecret = ""
    var newGuess = ""
    for (i <- 0 until CodeLength) {
        if (guess(i) == secret(i))
            pos += 1
        else {
            newSecret += secret(i)
            newGuess += guess(i)
        }
    }

    var letters = "ABCDEF"
    for (i <- 0 until letters.length) {
        var cSecret = 0
        for (j <- 0 until newSecret.length)
            if (newSecret(j) == letters(i))
                cSecret += 1

        var cGuess = 0
        for (j <- 0 until newGuess.length)
            if (newGuess(j) == letters(i))
                cGuess += 1
        let += math.min(cSecret, cGuess)
    }
    (pos, let)
}

// Show history of guessing  
def showHistory(h: Array[String], current: Int, secret: String) {
    for (count <- 0 until current) {
        val guess = h(count)
        val (pos, let) = evaluateGuess(secret, guess)
        printf("%2d: %s : %d positions, %d letters\n", count + 1, guess, pos, let)
    }
}

// main game  
def main() {
    val secret = createSecret()
    val history = new Array[String](MaxNumGuesses)
    var current = 0
    println("Welcome to Mastermind!")
    println("I have created a secret combination:")
    println(CodeLength + " letters from A - F.")
    printf("You have %d guesses to find it.\n", MaxNumGuesses)
    println(secret)
    while (true) {
        showHistory(history, current, secret)
        if (current == MaxNumGuesses) {
            printf("My secret was %s, you failed to find it in %d guesses!\n",
                secret, current)
            return
        }
        val guess = getGuess()
        history(current) = guess
        current += 1
        val (pos, let) = evaluateGuess(secret, guess)
        if (pos == CodeLength) {
            printf("My secret was %s, you guessed correctly in %d guesses!\n",
                secret, current)
            return
        }
    }
}

main()