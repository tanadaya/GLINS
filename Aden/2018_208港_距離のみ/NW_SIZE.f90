!     【プログラム内固定変数の宣言】
!
! --- 配列変数サイズ上限の宣言
    Module nw_size
    
      Implicit None 

      INTEGER*4  marlmax,marnmax
      INTEGER*4  pmax,pnmax,jmax,odmax,cmax
      PARAMETER (marlmax=300000,marnmax=150000)   
      PARAMETER (pmax=300, pnmax=1000, odmax=1600, jmax=30, cmax=300)
    
    End Module       
!


