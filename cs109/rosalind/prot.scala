val F = scala.io.Source.fromFile("input.txt")
val lines = F.getLines().toArray
F.close()

val line = lines(0)
var protein = ""
for (i <- 0 until line.length / 3) {
    val str = line.substring(i * 3, i * 3 + 3)
    if (str == "UUU" || str == "UUC")
        protein += "F"
    else if (str == "UUA" || str == "UUG" || str.startsWith("CU"))
        protein += "L"
    else if (str.startsWith("UC") || str == "AGU" || str == "AGC")
        protein += "S"
    else if (str == "UAU" || str == "UAC")
        protein += "Y"
    else if (str == "UGU" || str == "UGC")
        protein += "C"
    else if (str == "UGG")
        protein += "W"
    else if (str.startsWith("CC"))
        protein += "P"
    else if (str == "CAU" || str == "CAC")
        protein += "H"
    else if (str == "CAA" || str == "CAG")
        protein += "Q"
    else if (str.startsWith("CG") || str == "AGA" || str == "AGG")
        protein += "R"
    else if (str == "AUU" || str == "AUC" || str == "AUA")
        protein += "I"
    else if (str == "AUG")
        protein += "M"
    else if (str.startsWith("AC"))
        protein += "T"
    else if (str == "AAU" || str == "AAC")
        protein += "N"
    else if (str == "AAA" || str == "AAG")
        protein += "K"
    else if (str.startsWith("GU"))
        protein += "V"
    else if (str.startsWith("GC"))
        protein += "A"
    else if (str == "GAU" || str == "GAC")
        protein += "D"
    else if (str == "GAA" || str == "GAG")
        protein += "E"
    else if (str.startsWith("GG"))
        protein +=  "G"
}

println(protein)