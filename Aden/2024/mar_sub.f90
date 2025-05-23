! 
      SUBROUTINE  MAR_SUB(nunit, marlmax, marnmax, pmax, &
            BDATA, MAR_Num, MAR_LINKs, MAR_NODEs, MAR_ORGNs, MAR_DSTNs, &
            ODFL_MAR, X, C, a1, a2, MAR_time, req, crane)
! 
      USE NW_INFO
      IMPLICIT NONE
! 
!     --- 入力変数 ---
! 
      INTEGER*4  marlmax, marnmax, pmax, nunit, I, J, L
      TYPE (BDATA_INFO) BDATA
      TYPE (MAR_Num_INFO)  MAR_Num
      TYPE (MAR_LINK_INFO) MAR_LINKs(marlmax)
      TYPE (MAR_NODE_INFO) MAR_NODEs(marnmax)
      TYPE (MAR_ORGN_INFO) MAR_ORGNs(pmax)
      TYPE (MAR_DSTN_INFO) MAR_DSTNs(pmax)
! 
      REAL*8     ODFLOW(pmax,pmax), ODFL_MAR_DIV(pmax,pmax), ODFL_MAR(pmax,pmax)
      REAL*8     U(pmax,pmax), CM(pmax,pmax), MAR_time(pmax,pmax)
      REAL*8     X(marlmax)
      REAL*8     C(marlmax) 
      REAL*8     Y(marlmax)
! 
      INTEGER*4  IT_MAR 
      REAL*8    a1, a2
      integer*4   IR, JR
      REAL*8  req(rmax), crane(rmax)
!
!      INTEGER*4 C_PATH(pmax,pmax,pmax)    
!
!
      CALL  derase1(marlmax, X)
      CALL  derase1(marlmax, C)
      CALL  derase2(pmax, pmax, U)
      CALL  derase2(pmax, pmax, CM)
!       
      IT_MAR = 0.3 * BDATA%IT_MAR_MAX
      
      !段階配分
     do I = 1, pmax
        do J = 1, pmax
         ODFL_MAR_DIV(I,J) = 0.3 * ODFL_MAR(I,J)
        end do
     end do
!
      CALL LinkCost_MAR(marlmax, MAR_Num, MAR_LINKs, X, C, a1, a2, req, crane)                 
      write(*,*) "linkcost_0 completed"
!
! -----
      CALL All_Not_SUB_MAR(nunit, marlmax, marnmax, pmax, BDATA, MAR_Num, MAR_LINKs, MAR_NODEs, MAR_ORGNs, MAR_DSTNs, &
            ODFL_MAR_DIV, C, Y, U, CM, IT_MAR)
      write(*,*) "allnot_0 completed"

!段階配分
      do L = 1, MAR_Num%T_LINK
        X(L) = X(L) + Y(L) 
      end do
!      write(*,*) Y(L)

!    LFmax = 0.0
!      DO  L = 1, MAR_Num%T_LINK
!       if (MAR_LINKs(L)%Cap * MAR_LINKs(L)%Freq .ne. 0.0) then
!             MAR_LINKs(L)%LF = X(L) / (MAR_LINKs(L)%Cap * MAR_LINKs(L)%Freq)
!       end if
!       if (MAR_LINKs(L)%LF .gt. LFmax) then
!           LFmax = MAR_LINKs(L)%LF
!       end if
!      END DO

   10 IT_MAR = IT_MAR + 1
   
   !段階配分
     do I = 1, pmax
        do J = 1, pmax
         ODFL_MAR_DIV(I,J) = ODFL_MAR(I,J) / BDATA%IT_MAR_MAX
        end do
     end do
!              
      CALL LinkCost_MAR(marlmax, MAR_Num, MAR_LINKs, X, C, a1, a2, req, crane)                 
!
! -----
      CALL All_Not_SUB_MAR(nunit, marlmax, marnmax, pmax, BDATA, MAR_Num, MAR_LINKs, MAR_NODEs, MAR_ORGNs, MAR_DSTNs, &
            ODFL_MAR_DIV, C, Y, U, CM, IT_MAR)
!       
!段階配分
      do L = 1, MAR_Num%T_LINK
        X(L) = X(L) + Y(L) 
      end do
!      write(*,*) Y(L)
! 
        WRITE(6,100) '       Iteration :',IT_MAR
        WRITE(113,100) '       Iteration :',IT_MAR
  100   format(A, I4, A, F12.10) 
! 
      if (IT_MAR .LT. BDATA%IT_MAR_MAX) then
        GO TO 10
      
      else
        do IR = 1, BDATA%NumPORT
          do JR = 1, BDATA%NumPORT
            MAR_time(IR, JR) = U(IR, JR)
          end do
        end do
      end if
!          
!        
      RETURN
      END
!
!
! ***********************************************************************
      SUBROUTINE  LinkCost_MAR(marlmax,MAR_Num,MAR_LINKs,X,C,a1,a2, req, crane)
!
      USE NW_INFO
      IMPLICIT NONE
! 
      INTEGER*4  marlmax
      TYPE (MAR_Num_INFO)  MAR_Num
      TYPE (MAR_LINK_INFO) MAR_LINKs(marlmax)
! 
      REAL*8    X(marlmax)
      REAL*8    C(marlmax), f(marlmax) 
! 
      INTEGER*4 L
      REAL*8    a1, a2
      REAL*8  req(rmax), crane(rmax)
!
!
      Do L = 1, MAR_Num%T_LINK
!
    if (MAR_LINKs(L)%TP .eq. 0) then !Others
          C(L) = MAR_LINKs(L)%Time
    elseif (MAR_LINKs(L)%TP .eq. 2) then !Berthing
	   MAR_LINKs(L)%Time = X(L+1)/(45.0 * req(MAR_LINKs(L)%R) * crane(MAR_LINKs(L)%R)) + X(L+2)/(45.0 * req(MAR_LINKs(L)%R) * crane(MAR_LINKs(L)%R)) + 2.0
          C(L) = MAR_LINKs(L)%Time
    elseif (MAR_LINKs(L)%TP .eq. 3) then !Unloading
          MAR_LINKs(L)%Time = X(L) / (45.0 * req(MAR_LINKs(L)%R) * crane(MAR_LINKs(L)%R)) + 1.0
          C(L) = MAR_LINKs(L)%Time
    elseif (MAR_LINKs(L)%TP .eq. 4) then !Loading
	   MAR_LINKs(L)%Time = 7.0 * 24.0 / (req(MAR_LINKs(L)%R) / 52.0) / 2.0 + X(L)/(45.0 * req(MAR_LINKs(L)%R) * crane(MAR_LINKs(L)%R)) + 1.0
          C(L) = MAR_LINKs(L)%Time
!          f(L) = (X(L) + X(L-2)) / (MAR_LINKs(L)%Cap * Freq(I))
!          C(L) = MAR_LINKs(L)%Time * (1.0 + a1 * f(L) ** a2) 
!          C(L) = MAR_LINKs(L)%Time * (a1 * (1 / (1 - f(L))) ** a2) 
	elseif (MAR_LINKs(L)%TP .eq. 1) then !Shipping
!          C(L) = MAR_LINKs(L)%Time
          f(L) = X(L) / (MAR_LINKs(L)%Cap * MAR_LINKs(L)%Freq)
          C(L) = MAR_LINKs(L)%Time + MAR_LINKs(L)%FreqWaitTime * a1 * f(L) ** a2
!          C(L) = MAR_LINKs(L)%Time + MAR_LINKs(L)%Time * a1 * f(L) ** a2
          if (X(L) .gt. 0.0) then
            MAR_LINKs(L)%Cost = (MAR_LINKs(L)%FC + MAR_LINKs(L)%CC + MAR_LINKs(L)%MC) / (X(L) / MAR_LINKs(L)%Freq)
          else
            MAR_LINKs(L)%Cost = 10.0 ** 10
          end if
        end if
!
        if (C(L) .gt. 10.0 ** 10) then
          C(L) = 10.0 ** 10
        end if
!      
      end do
!         
      RETURN
      END
