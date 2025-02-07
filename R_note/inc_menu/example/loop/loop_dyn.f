c File name: lood_dyn.f
c For dynamical load compile by g77.
c SHELL> g77 -c loop_dyn.f ; g77 -shared -o loop_dyn.so loop_dyn.o

      subroutine dynsum(nrow, ncol, m, ret)
        integer i, j, nrow, ncol
        real*8 m(nrow, ncol), ret

        ret = 0
        do j = 1, ncol
          do i = 1, nrow
            ret = ret + m(i, j) 
          end do
        end do

        return
      end

c Output is a shared library "loop_dyn.so" can called by R.

