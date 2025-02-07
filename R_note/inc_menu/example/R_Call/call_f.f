c File name: call_f.f
c For dynamical load compile by g77.
c SHELL> g77 -c call_f.f ; g77 -shared -o call_f.so call_f.o

      subroutine hello(m, a, b, c, d)
        integer i, m
        real*8 a(m), b(m), c(m), d

        d = 0
        do i = 1, m
          c(i) = a(i) + b(i)
          d = d + c(i)
          a(i) = 0
        end do

        return
      end

c Output is a shared library "call_f.so" can be called by R.
