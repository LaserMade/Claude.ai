﻿BoxMuller(m,s) { ; Normally distributed random numbers of mean = m, std.dev = s by Box-Muller method
   Static i, Y
   If (i := !i) { ; every other call
      Random U, 0, 1.0
      Random V, 0, 6.2831853071795862
      U := sqrt(-2*ln(U))*s
      Y := m + U*sin(V)
      Return m + U*cos(V)
   }
   Return Y
}