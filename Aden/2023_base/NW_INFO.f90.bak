!     【ネットワーク構造関連情報の構造体定義】
!
! --- ネットワーク構成要素数の情報
    Module nw_info

      Implicit None

      INTEGER*4  gmax
      PARAMETER (gmax = 32) !船社の数
!
      TYPE BDATA_INFO      
        INTEGER*4   NumOD_SHPR                   
        INTEGER*4   NumG     
        INTEGER*4   IT_MAR_MAX
        REAL*8      EPS_MAR           
        INTEGER*4   NumPORT           
        INTEGER*4   IT_MAX
        REAL*8      EPS 
      END TYPE
!
! Port Data
!      
      TYPE PORT_INFO
        INTEGER*4   PNUM
        INTEGER*4   COUN
        REAL*8      TL ! Loading Time to Container Yard (Lead Time)
        REAL*8      TUL ! Unloading Time from Container Yard
        REAL*8      TRS ! Transshiping Time between Container Yards
        REAL*8      THC_Ex ! Terminal Handling Charge
        REAL*8      THC_Im
        REAL*8      TEU_LOCAL
        REAL*8      TEU_TS
        INTEGER*4   TS_MAJOR
        INTEGER*4   inland_flag
        REAL*8      CAP!容量制約
        REAL*8      TERNUM!コンテナberth数


      END TYPE
!
! Carrier Network
!
! --- Number
      TYPE MAR_NUM_INFO
        INTEGER*4   T_LINK        ! 
        INTEGER*4   NODE       !     
      END TYPE
!
! --- Link
      TYPE MAR_LINK_INFO
        INTEGER*4   ID          ! 
        INTEGER*4   G
        INTEGER*4   R 
        INTEGER*4   P1
        INTEGER*4   P2
        INTEGER*4   PO
        INTEGER*4   PD
        INTEGER   NODE1       ! 
        INTEGER   NODE2       ! 
        INTEGER   NODEF       ! 
        INTEGER   NODET       !
        INTEGER*4   TP        ! 1:Shipping, 2:Berthing, 3:Unlodaing, 4:Loading, 0:Others
        REAL*8      Time      !
        REAL*8      Panama
        REAL*8      Suez
        REAL*8      Cost
        REAL*8      FC
        REAL*8      CC
        REAL*8      MC
        REAL*8      Cap
        REAL*8      Freq
        REAL*8      FreqWaitTime
      END TYPE
!
! --- ノード属性情報
      INTEGER*4  rmax
      PARAMETER (rmax = 1128) ! 
      TYPE MAR_NODE_INFO
        INTEGER*4   ID          ! 
        INTEGER*4   LNKIN(0:rmax)     ! 
        INTEGER*4   LNKOUT(0:rmax)   ! 
      END TYPE
!
! --- 発生ノード属性情報 
      TYPE MAR_ORGN_INFO
        INTEGER*4   NORG        ! 
        INTEGER*4   NSEQ        ! 
      END TYPE
!
! --- 集中ノード属性情報
      TYPE MAR_DSTN_INFO
        INTEGER*4   NORG        ! 
        INTEGER*4   NSEQ        ! 
      END TYPE
!
! Country Data
!      
      TYPE COUN_INFO
        INTEGER*4   ID
        INTEGER*4   D_Ex_Doc
        INTEGER*4   D_Ex_Cus
        INTEGER*4   D_Im_Doc
        INTEGER*4   D_Im_Cus
        REAL*8      M_Ex_Doc
        REAL*8      M_Ex_Cus
        REAL*8      M_Im_Doc
        REAL*8      M_Im_Cus
      END TYPE

    End Module
