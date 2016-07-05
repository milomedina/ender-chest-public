import org.scalatest.FunSuite
import scala.language.implicitConversions

class PolynomialCheckSuite extends FunSuite {
    implicit def intToPolynomial(a: Int): Polynomial = {
        new Polynomial(Array(a))
    }

    test("creating polynomials") {
        val p1 = new Polynomial(Array(3))
        assert(p1.degree == 0)
        assert(p1.toString == "3")
        val p2 = new Polynomial(Array(-1, 3, -4, 0, -6))
        assert(p2.degree == 4)
        assert(p2.toString == "-6 * X^4 - 4 * X^2 + 3 * X - 1")
        val p3 = new Polynomial(Array(0, 0, 1))
        assert(p3.degree == 2)
        assert(p3.toString == "X^2")

        val p0 = new Polynomial(Array(0))
        assert(p0.degree == -1)
    }

    test("addition and subtraction") {
        val p1 = new Polynomial(Array(3))
        val p2 = new Polynomial(Array(-1, 3, -4, 0, -6))
        val p3 = new Polynomial(Array(5, 0, 4, 0, -6))

        val q1 = p1 + p2
        val q2 = p2 - p3
        assert(q1.toString == "-6 * X^4 - 4 * X^2 + 3 * X + 2")
        assert(q2.degree == 2)
        assert(q2.toString == "-8 * X^2 + 3 * X - 6")
    }

    test("multiplication and power") {
        val p1 = new Polynomial(Array(3))
        val p2 = new Polynomial(Array(-1, 3, -4, 0, -6))
        val p3 = new Polynomial(Array(0, 0, 5))
        val p4 = new Polynomial(Array(2, -4, 6, 8))

        val q1 = p1 * p2
        val q2 = p1^5
        val q3 = p3^5
        val q4 = p2 * p3
        val q5 = p2 * p4
        assert(q1.toString == "-18 * X^4 - 12 * X^2 + 9 * X - 3")
        assert(q2.degree == 0)
        assert(q2.coeff(0) == 3*3*3*3*3)
        assert(q3.degree == 10)
        assert(q3.toString == "3125 * X^10")
        assert(q4.degree == 6)
        assert(q4.toString == "-30 * X^6 - 20 * X^4 + 15 * X^3 - 5 * X^2")
        assert(q5.toString == "-48 * X^7 - 36 * X^6 - 8 * X^5 - 12 * X^4 + 26 * X^3 - 26 * X^2 + 10 * X - 2")
    }

    test("division") {
        val X = Polynomial.X
        val p1 = 5 * (X^8) - 7 * (X^5) - (X^4) + 4 * (X^2) - 1
        val r1 = p1 / (X-1)
        assert(r1.toString == "5 * X^7 + 5 * X^6 + 5 * X^5 - 2 * X^4 - 3 * X^3 - 3 * X^2 + X + 1")
        val p2 = 3
        intercept[ArithmeticException] {
            val r2 = p2 / (X-1)
            fail("3 is not divisible by (X-1)")
        }
    }

    test("creating polynomials using X") {
        val X = new Polynomial(Array(0, 1))
        assert(X.toString == "X")
        val p4 = -1 * (X^5) + 3 * (X^3) - (X^2) + 5
        assert(p4.toString == "-X^5 + 3 * X^3 - X^2 + 5")
        val p5 = (X - 1) * (X - 3) * (X + 5)^2
        assert(p5.toString == "X^6 + 2 * X^5 - 33 * X^4 - 4 * X^3 + 319 * X^2 - 510 * X + 225")
    }

    test("simple polynomial init") {
        val X = Polynomial.X
        assert(X.toString == "X")
        val p = Polynomial.linear(3, 5)
        assert(p.toString == "3 * X + 5")
        val const = Polynomial(3)
        assert(const.toString == "3")
        val lin = Polynomial(3, -7)
        assert(lin.toString == "3 * X - 7")
        val quad = Polynomial(2, 3, -7)
        assert(quad.toString == "2 * X^2 + 3 * X - 7")
        val cubic = Polynomial(-1, 2, 3, -7)
        assert(cubic.toString == "-X^3 + 2 * X^2 + 3 * X - 7")
        val p4 = Polynomial(9, -1, 2, 3, -7)
        assert(p4.toString == "9 * X^4 - X^3 + 2 * X^2 + 3 * X - 7")
    }

    test("evaluation") {
        val X = new Polynomial(Array(0, 1))
        val p1 = new Polynomial(Array(3))
        val p2 = new Polynomial(Array(-1, 3, -4, 0, -6))
        val p3 = new Polynomial(Array(0, 0, 1))
        val p4 = -1 * (X^5) + 3 * (X^3) - (X^2) + 5
        val p5 = (X - 1) * (X - 3) * (X + 5)^2

        assertResult(3.0) { p1(5) }
        assertResult(-1.0) { p2(0) }
        assertResult(4.0) { p3(2) }
        assertResult(0.0) { p5(-5.0) }
    }

    test("derivatives") {
          val X = new Polynomial(Array(0, 1))
          val p1 = (X - 1) * (X - 3) * ((X + 5)^2)
          val q1 = p1.derivative
          assert(q1.degree == 3)
          assert(q1.toString == "4 * X^3 + 18 * X^2 - 24 * X - 70")
          val q2 = q1.derivative
          assert(q2.degree == 2)
          assert(q2.toString == "12 * X^2 + 36 * X - 24")
    }
}
