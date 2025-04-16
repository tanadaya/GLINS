
!**************************************************************
      SUBROUTINE derase1(A,X)
!
      IMPLICIT NONE
!
      INTEGER*4 A, I
      REAL*8    X(A)
!
      DO I = 1, A
        X(I)=0.0D0
      END DO
!
      RETURN
      END
!
!***************************************************************
      SUBROUTINE derase2(A, B, X)
!
      IMPLICIT NONE
!
      INTEGER*4 A, B, I, J
      REAL*8    X(A,B)
!
      DO I = 1, A
        DO J = 1, B 
          X(I,J)=0.0D0
        END DO 
      END DO
!
      RETURN
      END
!
!***************************************************************
      SUBROUTINE derase3(A, B, C, X)
!
      IMPLICIT NONE
!
      INTEGER*4 A, B, C, I, J, K
      REAL*8    X(A,B,C)
!
      DO I = 1, A
        DO J = 1, B 
          DO K = 1, C  
            X(I,J,K)=0.0D0
          END DO
        END DO 
      END DO
!
      RETURN
      END
!
!**************************************************************
      SUBROUTINE derase1n(A,X)
!
      IMPLICIT NONE
!
      INTEGER*4 A, I, X(A)    
!
      DO I = 1, A
        X(I) = 0
      END DO
!
      RETURN
      END
!
!***************************************************************
      SUBROUTINE derase2n(A, B, X)
!
      IMPLICIT NONE
!
      INTEGER*4 A, B, I, J, X(A,B)   
!
      DO I = 1, A
        DO J = 1, B 
          X(I,J) = 0
        END DO 
      END DO
!
      RETURN
      END
!
!*************************************************************** 
! 
