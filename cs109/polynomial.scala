// --------------------------------------------------------------------
// Polynomials
// --------------------------------------------------------------------

class Polynomial(coeffs: Array[Int]) {
    private val A = createCoeffs(coeffs)

    private def createCoeffs(A: Array[Int]): Array[Int] = {
        var s = A.length - 1
        while (s >= 0 && A(s) == 0)
            s -= 1
        A take (s+1)
    }

    def degree: Int = A.length - 1

    def coeff(i: Int): Int = if (i < A.length) A(i) else 0

    def iszero: Boolean = A.forall(x => x == 0)

    override def toString: String = {
        var s = new StringBuilder
        var plus = ""
        var minus = "-"
        for (i <- degree to 0 by -1) {
            if (coeff(i) != 0) {
                var c = coeff(i)
                s ++= (if (c > 0) plus else minus)
                plus = " + "; minus = " - "
                c = c.abs
                if (i == 0)
                    s ++= c.toString
                else {
                    if (c != 1)
                        s ++= c.toString + " * "
                    if (i > 1)
                        s ++= "X^" + i.toString
                    else
                        s ++= "X"
                }
            }
        }
        s.toString
    }

    def + (rhs: Polynomial): Polynomial = {
        val deg = degree max rhs.degree
        val R = new Array[Int](deg + 1)
        for (i <- 0 to deg)
            R(i) = coeff(i) + rhs.coeff(i)
        new Polynomial(R)
    }

    def - (rhs: Polynomial): Polynomial = {
        val deg = degree max rhs.degree
        val R = new Array[Int](deg + 1)
        for (i <- 0 to deg)
            R(i) = coeff(i) - rhs.coeff(i)
        new Polynomial(R)
    }

    def * (rhs: Polynomial): Polynomial = {
        // first handle case if one factor is the zero polynomial
        if (degree < 0)
            this
        else if (rhs.degree < 0)
            rhs
        else {
            val deg = degree + rhs.degree
            val R = new Array[Int](deg + 1)
            for (i <- 0 to deg) {
                var sum = 0
                for (j <- 0 to i)
                    sum += coeff(j) * rhs.coeff(i - j)
                R(i) = sum
            }
            new Polynomial(R)
        }
    }

    def / (rhs: Polynomial): Polynomial = {
        if (degree < 0) new Polynomial(Array(0))
        else if (rhs.degree < 0)
            throw new ArithmeticException()
        else {
            var p = new Polynomial(A)
            var r = new Polynomial(Array(0))
            while (!p.iszero) {
                if (p.degree < rhs.degree)
                    throw new ArithmeticException()

                val cm = p.coeff(p.degree) / rhs.coeff(rhs.degree)
                val dm = p.degree - rhs.degree
                r += new Polynomial(Array(cm)) * (new Polynomial(Array(0, 1)) ^ dm)
                p -= new Polynomial(Array(cm)) * rhs * (new Polynomial(Array(0, 1)) ^ dm)
            }
            r
        }
    }

    def ^ (ex: Int): Polynomial = {
        ex match {
            case 0 => new Polynomial(Array(1))
            case 1 => this
            case 2 => this * this
            case 3 => this * this * this
            case _ => {
                val p = this ^ (ex / 2)
                if (ex % 2 == 1) p * p * this else p * p
            }
        }
    }

    def derivative: Polynomial = {
        val R = new Array[Int](degree)
        for (i <- 1 to degree)
            R(i - 1) = A(i) * i
        new Polynomial(R)
    }

    // evaluate this polynomial at x
    def apply(x: Double): Double = {
        var result = 0.0
        for (i <- degree to 0 by -1) {
            result *= x
            result += coeff(i)
        }
        result
    }
}

object Polynomial {
    def apply(a: Int) = new Polynomial(Array(a))
    def apply(a: Int, b: Int) = new Polynomial(Array(b, a))
    def apply(a: Int, b: Int, c: Int) = new Polynomial(Array(c, b, a))
    def apply(a: Int, b: Int, c: Int, d: Int) = new Polynomial(Array(d, c, b, a))
    def apply(a: Int, b: Int, c: Int, d: Int, e: Int) = new Polynomial(Array(e, d, c, b, a))

    def X: Polynomial = new Polynomial(Array(0, 1))

    def linear(a: Int, b: Int): Polynomial = new Polynomial(Array(b, a))
}