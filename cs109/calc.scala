import scala.io.StdIn.{readLine,readInt}
println("Shopping Calculator V0.2\n")

var sum = 0
var arr = Array.empty[(String, Int, Int)]

var continue = true;
while (continue) {
    print("What did you buy? ")
    val item = readLine()

    if (item == "")
        continue = false
    else {
        print("How many " + item + " did you buy? ")
        val num = readInt()
        print("What is the price of one " + item + "? ")
        val price = readInt()
        println("You bought " + num + " " + item + " for " + (num * price) + " KRW.")
        sum += (num * price)
        arr = arr :+(item, num, price)
    }
}
println("Your purchases:")
println("--------------------------------------------------")
for (i <- 0 until arr.length)
    println("%-20s%3d x %5d KRW   %8d KRW".format(arr(i)._1, arr(i)._2, arr(i)._3, arr(i)._2 * arr(i)._3))
println("--------------------------------------------------")
println("Total price: %33d KRW".format(sum))
println("--------------------------------------------------")