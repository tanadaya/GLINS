! 
      SUBROUTINE All_Not_SUB_MAR(nunit, marlmax, marnmax, pmax, BDATA, MAR_Num, MAR_LINKs, MAR_NODEs, &
             MAR_ORGNs, MAR_DSTNs, ODFLOW, DIST, Y, U, CM, IT_MAR)
! 
      USE NW_INFO
      IMPLICIT NONE
! 
!     --- 入力変数 ---
      INTEGER*4  marlmax, marnmax, pmax, nunit 
      TYPE (BDATA_INFO) BDATA
      TYPE (MAR_NUM_INFO)  MAR_Num
      TYPE (MAR_LINK_INFO) MAR_LINKs(marlmax)
      TYPE (MAR_NODE_INFO) MAR_NODEs(marnmax)
      TYPE (MAR_ORGN_INFO) MAR_ORGNs(pmax)
      TYPE (MAR_DSTN_INFO) MAR_DSTNs(pmax)
! 
      REAL*8    DIST(marlmax)
      REAL*8    ODFLOW(pmax,pmax)
      INTEGER*4 NARABI(marnmax)      
!
      REAL*8    XSUM, ODF
      INTEGER*4 NBK, NPRE
       
!     --- 出力変数 ---
      REAL*8    Y(marlmax)
      REAL*8    U(pmax,pmax), CM(pmax,pmax)
      REAL*8    PLABEL(marnmax)      
! 
!     --- 作業変数 ---
      INTEGER*4 IPREDE(marnmax),ISQLST(marnmax)
      REAL*8    RMIN(marnmax), CMJ(marnmax)
      REAL*8    XO(pmax, marlmax)
! 
      INTEGER*4 status
      INTEGER*4 ISQT, ISQB, NSQ, NLO, NLI
      INTEGER*4 I, LL, INFNT, IR, jj, ORIGN
      REAL*8    P 
      INTEGER*4  J, JR, K, IORIGN, IT_MAR, NN, NL, L, NR, LI, LO, ND
      integer*4 first, last!分割していく過程での左端と右端、再帰で使う
	  integer*4 node_left_value, node_right_value
	  integer*4 total_node, left_index, right_index
	  real*8 average, pivot, left_value, right_value

! 
! --- フロー・コスト配列などを初期化
	  Y = 0.0
	  U = 0.0
	  CM = 0.0
      XO = 0.000
!      
      open (nunit, file='path.dat',status='unknown') 
!   
!$omp parallel num_threads(6) default(shared), private(RMIN,IORIGN,status,NSQ,ORIGN,ISQT,I,ISQLST,L,LL,J,P,PLABEL,ISQB,IPREDE,NARABI,NBK,XSUM,ODF,NPRE,NR,LO,K,LI,first,last,node_left_value,node_right_value,total_node,left_index,right_index,average,pivot,left_value,right_value,JR,NN,NL,ND,CMJ,jj,NLO,NLI)
!$omp do
      do IR = 1, BDATA%NumPORT       
!		  write(*,*) IR
! ------- 起点ノードから各ノードへの最短距離を計算
          RMIN = 0.0
!     --- 対象発ノードの全ノード内連番をセット
          IORIGN = MAR_ORGNs(IR)%NSEQ
!     --- 全ノードを最短経路探索対象となる着ノードに設定
!          DO   K = 1, MAR_Num%NODE
!            DESTN(K) = K
!          END DO
! 
!     --- 最短経路探索実行
          NN = MAR_Num%NODE
          NL = MAR_Num%T_LINK
          CALL SPATHr_MAR(marnmax, marlmax, pmax, NN, NL, IORIGN, BDATA%NumPORT, MAR_LINKs, &
               MAR_NODEs, DIST, RMIN, IPREDE, ISQLST, CMJ, IT_MAR, IR)

! 
!     --- 各ＯＤペアの最短経路コストを記憶
          DO  JR = 1, BDATA%NumPORT
            J = MAR_DSTNs(JR)%NSEQ
            U(IR,JR) = RMIN(J)
            CM(IR,JR) = CMJ(J)
          END DO        
! 
!          close(23)
! ------- リンクフローを計算
          NR = MAR_ORGNs(IR)%NSEQ
          CALL  AN_Flow_MAR(nunit, IR, NR, marlmax, marnmax, pmax, &
                BDATA, MAR_Num, MAR_NODEs, MAR_LINKs, MAR_DSTNs, ODFLOW, RMIN, IPREDE, XO, ISQLST, IT_MAR)

!                
      end do
      close(nunit)
!$omp end do
!$omp end parallel
! 
  998 FORMAT(A)
  999 FORMAT(A,I4,A,I4)

		!  他の発ノードによるリンクフローと重ねあわせ
		   DO L = 1, MAR_Num%T_LINK
		     do IR = 1, BDATA%NumPORT 
		        Y(L) = Y(L) + XO(IR,L) 
		     end do
		   end do
		   
      RETURN
      END
! 
! 

! **************************************************************
      SUBROUTINE SPATHr_MAR(marnmax, marlmax, pmax, NN, NL, ORIGN, ND, MAR_LINKs, MAR_NODEs, &
          DIST, PLABEL, IPREDE, ISQLST, CMJ, IT_MAR, IR)
! 
      USE NW_INFO
      Implicit None
! 
!     --- 入力変数 ---
      INTEGER*4  marlmax, marnmax, pmax! 
      INTEGER*4 NN, NL, ND, ORIGN
      TYPE (MAR_NODE_INFO) MAR_NODEs(marnmax)
      TYPE (MAR_LINK_INFO) MAR_LINKs(marlmax)
! 
      REAL*8    DIST(marlmax)
! 
!     --- 出力変数 ---
      REAL*8    PLABEL(marnmax), CMJ(marnmax)
      INTEGER*4 IPREDE(marnmax)
! 
!     --- 作業変数 ---
      INTEGER*4 ISQLST(marnmax)
! 
      INTEGER*4 status
      INTEGER*4 ISQT, ISQB, NSQ, NLO
      INTEGER*4 I, J, K, L, LL, INFNT,IT_MAR,IR,jj
      REAL*8    P
! 
! ---------------! 
! 引数のチェック
! ---------------! 
! 
      IF (marlmax .LT. NL) THEN
	  write(*,*) 'status error 11'
          status = -1
          RETURN
      END IF
      IF (marnmax .LT. NN) THEN
	  write(*,*) 'status error 22'
          status = -2
          RETURN
      END IF
! 
      IF (pmax .LT. ND) THEN
	  write(*,*) 'status error 33'
          status = -3
          RETURN
      END IF
! 
! ---------! 
! 初期設定
! ---------! 
      INFNT=99999999
! 
      DO 30  K = 1, NN
        PLABEL(K) = 1.0D10
        IPREDE(K) = 0
        ISQLST(K) = 0
        CMJ(K) = 0.0D0
   30 CONTINUE
! 
      PLABEL(ORIGN) = 0.0D0
      CMJ(ORIGN) = 0.0D0
      ISQLST(ORIGN) = INFNT
      ISQT = ORIGN
      ISQB = ORIGN
      NSQ = 1
! 
! -----------! 
! ラベリング
! -----------! 
!     ◆連続リストは空か？
      jj=0
! 
   50 IF (NSQ .EQ. 0) THEN
!         ◇リストが空の場合
      ELSE
      jj=jj+1
!         ◇リストが空でない場合
!         ○連続リストの先頭にあるノードをノードｉとする
          I = ISQT
!         ○ノードｉを連続リストから取り除く
          IF (NSQ .EQ. 1) THEN
              ISQT = 0
            ELSE
              ISQT = ISQLST(I)
          END IF
          ISQLST(I) = -1
          NSQ = NSQ - 1
!         ●ノードｉから到達可能なノードｊをすべて走査
          NLO = MAR_NODEs(I)%LNKOUT(0)
          DO 60  L = 1, NLO
             LL = MAR_NODEs(I)%LNKOUT(L)
             J = MAR_LINKs(LL)%NODET
             P = PLABEL(I) + DIST(LL)
!            ◆◆ノードｊのラベルは改善可能か？
             IF (P .LT. PLABEL(J)) THEN
!                ◇◇ラベルを改訂する場合
                 PLABEL(J) = P
                 CMJ(J) = CMJ(I) + MAR_LINKs(LL)%Cost 
                 IPREDE(J) = I
!                ◆◆◆ノードｊが連続リスト上に現在あるか？
                 IF (ISQLST(J) .LE. 0) THEN
!                    ◇◇◇連続リスト上にない場合
!                    ◆◆◆◆連続リストの要素数が０か？
                     IF (NSQ .EQ. 0) THEN
!                        ノードｊを連続リストに置く
                         ISQLST(J) = INFNT
                         ISQT = J
                         ISQB = J
                       ELSE
!                        ◆◆◆◆◆ノードｊが連続リスト上に
!                                            以前あったか？
                         IF (ISQLST(J) .EQ. -1) THEN
!                            ノードｊを連続リストの先頭に置く
                             ISQLST(J) = ISQT
                             ISQT = J
                           ELSE
!                            ノードｊを連続リストの最後に置く
                             ISQLST(ISQB) = J
                             ISQLST(J) = INFNT
                             ISQB = J
                         END IF
                     END IF
                     NSQ = NSQ + 1
                   ELSE
!                    ◇◇◇連続リスト上にある場合
                     CONTINUE
                 END IF
               ELSE
!                ◇◇ラベルそのままの場合
                 CONTINUE
             END IF
   60     CONTINUE
!         ○ノードｉからの走査完了
          GO TO 50
      END IF
! 
   70 CONTINUE
! 
      status = 0
! 
      RETURN
      END
! 
! 
!***************************************************************
      SUBROUTINE  AN_Flow_MAR(nunit, IR, NR, marlmax, marnmax, pmax, &
      BDATA, MAR_Num, MAR_NODEs, MAR_LINKs, MAR_DSTNs, ODFLOW, RMIN, IPREDE, XO, NARABI, IT_MAR)
! 
      USE NW_INFO
      Implicit None
! 
      INTEGER*4  marlmax, marnmax, pmax, nunit
! 
      TYPE (BDATA_INFO) BDATA
      TYPE (MAR_NUM_INFO)  MAR_Num
      TYPE (MAR_NODE_INFO) MAR_NODEs(marnmax)
      TYPE (MAR_LINK_INFO) MAR_LINKs(marlmax)
      TYPE (MAR_DSTN_INFO) MAR_DSTNs(pmax)
! 
      INTEGER*4 IR
      REAL*8    ODFLOW(pmax,pmax)
      REAL*8    RMIN(marnmax)
      INTEGER*4 IPREDE(marnmax)
! 
      REAL*8    XO(pmax, marlmax)
!      REAL*8    path(pmax,marlmax)
! 
!     --- 作業変数 ---
      INTEGER*4 NARABI(marnmax)
! 
      REAL*8    XSUM, ODF
      INTEGER*4 J, K, L, LI, LO, NLI, NLO, NR, NN, IT_MAR, i
      INTEGER*4 NBK, NPRE
! 
! ------------------------------------
! R(*)の大きいもの順にノードを並べる
! ------------------------------------
      
      NN = MAR_Num%NODE
       NARABI = 0!これで初期化できる
      
	  do i = 1, NN
	    NARABI(i) = i
	  enddo 
      
      CALL DSORTd_MAR_quick(marnmax, NN, RMIN, NARABI, 1, NN)
! 
! -------------------
! リンクフローを計算
! -------------------
!  
!
      if (IT_MAR .ne. 1000) then
! 
!      call derase1(marlmax, XR)
! 
      DO 30  J = 1, MAR_Num%NODE - 1
        XSUM = 0.0D0
        ODF  = 0.0D0
        NBK  = NARABI(J)
        NPRE = IPREDE(NBK)
!
!       *発ノードから遠いノードから順に戻って行き，
        IF (NBK .EQ. NR) goto 99
!       *発ノードまで戻ったら終了
! 
!       *ノードNBKについて
! 
!       **ノードNBKから流出するリンク交通量の合計
        NLO = MAR_NODEs(NBK)%LNKOUT(0)
        DO 50  L = 1, NLO
          LO = MAR_NODEs(NBK)%LNKOUT(L)
          XSUM = XSUM + XO(IR,LO)
! 
   50   CONTINUE
!       **ノードNBKへ流入するＯＤ交通量
        DO 60 K = 1, BDATA%NumPORT
          IF (MAR_DSTNs(K)%NSEQ .EQ. NBK)  THEN
              ODF = ODFLOW(IR,K)
              GO TO 65
          END IF
   60   CONTINUE
   65   CONTINUE
! 
!       **ノードNBKへ流入するリンクのうち，そのリンク始点が
!         最短経路上に含まれるリンクにのみ交通量をロ−ド **
        NLI = MAR_NODEs(NBK)%LNKIN(0)
        DO 70  L = 1, NLI
          LI = MAR_NODEs(NBK)%LNKIN(L)
          IF (MAR_LINKs(LI)%NODEF .EQ. NPRE)  THEN
              XO(IR,LI) = XSUM + ODF
              GO TO 75
          END IF
   70   CONTINUE
   75   CONTINUE
! 
   30 CONTINUE
! 
!  他の発ノードによるリンクフローと重ねあわせ
!   99 DO 90  L = 1, MAR_Num%T_LINK
!        X(L) = X(L) + XR(L) 
!   90 CONTINUE
!
!
      else
!
!       if (((IR .ge. 59) .and. (IR .le. 63)) .or. (IR .eq. 68)) then
!       call  derase2(pmax, marlmax, path)
!       do D = 1, BDATA%NumPORT
! 
!        DO J = 1, MAR_Num%NODE - 1
!         XSUM = 0.0D0
!         ODF  = 0.0D0
!         NBK  = NARABI(J)
!         NPRE = IPREDE(NBK)
!
!         IF (NBK .EQ. NR) goto 175
!
!         NLO = MAR_NODEs(NBK)%LNKOUT(0)
!         DO L = 1, NLO
!          LO = MAR_NODEs(NBK)%LNKOUT(L)
!          XSUM = XSUM + path(D, LO)
!         end do
!       
!         IF (MAR_DSTNs(D)%NSEQ .EQ. NBK)  THEN
!          ODF = 1.0
!         END IF
! 
!         NLI = MAR_NODEs(NBK)%LNKIN(0)
!         DO 170  L = 1, NLI
!          LI = MAR_NODEs(NBK)%LNKIN(L)
!          IF (MAR_LINKs(LI)%NODEF .EQ. NPRE)  THEN
!             path(D, LI) = XSUM + ODF
!             GO TO 175
!          END IF
!  170    CONTINUE
!  175    CONTINUE
! 
!        end do
!        write (*,*) IR, D
!        
!       end do 
!     
!       do L = 1, MAR_Num%T_LINK
!       XSUM = 0.0
!         do D = 59, 63
!           XSUM = XSUM + path(D,L)
!         end do
!         XSUM = XSUM + path(68,L)
!         
!         if (XSUM .gt. 0.0) then  
!           write (nunit,*) IR, L, MAR_LINKs(L)%P1, MAR_LINKs(L)%P2, MAR_LINKs(L)%NODE1, MAR_LINKs(L)%NODE2, &
!                        (path(D,L), D=59,63), path(68,L)
!         end if
!       end do 
!       write (*,*) IR
!
!       end if
!      
 99   end if
!
!      open(16,file='Link_Check.dat',status='unknown')
!        do L=1, MAR_Num%T_LINK	
!          write(16,*) L, XR(L), X(L)      
!        end do         
!      close(16)
!
!      open(16,file='NODE_Check.dat',status='unknown')
!        do J=1, MAR_Num%NODE	
!          write(16,*) J, RMIN(J), NARABI(J), IPREDE(J)      
!        end do         
!      close(16)
! 
      RETURN
      END
! 
! 
! **************************************************************
      recursive SUBROUTINE DSORTd_MAR_quick(marnmax, total_node, RMIN, NARABI, first, last)!クイックソート、再帰subroutine
!     RMINは各ノードへの距離、NARABIは距離を降順に並べてノード番号を格納      
! 
	  implicit none
	  integer*4 first, last!分割していく過程での左端と右端、再帰で使う
	  integer*4 node_left_value, node_right_value
	  integer*4 marnmax, total_node, left_index, right_index
	  real*8 average, pivot, left_value, right_value
	  real*8 RMIN(marnmax)
	  integer*4 NARABI(marnmax)
	  
	  if (size(RMIN) .le. 1) return
	   
	  left_index = first
	  right_index = last
	  
! --------------------- -- pivot決め（三つの中央値) --------------------
	!  pivot = x(first)!一番基本的な決め方
	  average = (RMIN(first) + RMIN((first+last)/2) + RMIN(last))/3
	  pivot = RMIN(first)!temporary
	  if (abs(RMIN((first+last)/2) - average) .lt. abs(pivot - average)) then
	    pivot = RMIN((first+last)/2)
	    if (abs(RMIN(last) - average) .lt. abs(pivot - average)) then
	      pivot = RMIN(last)
	    endif
	  endif
! -----------------------------------------------------------------------
	  
	  do 
		  if (left_index .ge. right_index) exit
		  
		    left_value = RMIN(left_index)
	        right_value = RMIN(right_index)
		  
		    if (left_value .eq. right_value) then!例外処理
		      right_index = right_index - 1
			  right_value = RMIN(right_index)
		    endif
	
			  do
			    if (RMIN(left_index) .le. pivot) exit!視点の数字がピボット以下になるまで視点を右に動かす
			      left_index = left_index + 1
			      left_value = RMIN(left_index)
			  enddo
			  
			  do
			    if (RMIN(right_index) .ge. pivot) exit!視点の数字がピボット以上になるまで視点を左に動かす
			      right_index = right_index - 1
			      right_value = RMIN(right_index)
			  enddo
	! ------------------ 視点移動終了 -------------------		  
			  
			  RMIN(left_index) = right_value
			  RMIN(right_index) = left_value
			  
			  node_left_value = NARABI(left_index)!元の連番を保存
			  node_right_value = NARABI(right_index)!元の連番を保存		  
			  NARABI(left_index) = node_right_value
			  NARABI(right_index) = node_left_value
			  
			  
	! ------------------ 入れ替え完了 -------------------    
	  enddo !left_index = right_indexになっているはず
	  
	  if (first .lt. left_index - 1) then
	    call DSORTd_MAR_quick(marnmax, total_node, RMIN, NARABI, first, left_index - 1)
	  endif
	  if (right_index + 1 .lt. last) then
	    call DSORTd_MAR_quick(marnmax, total_node, RMIN, NARABI, right_index + 1, last)
	  endif
		  
	end subroutine    
	  
	! ***************************************************
