VN 0 0 3 0 0 2
MODULE NW_INFO,0 0 0 0 0
FILE 1,NW_INFO.f90
TYPE BDATA_INFO,1,2097216,0,40
  NUMOD_SHPR(16,4,0,0,0,0,0,0): 1,3,3,0,0,0,0,0,1,0,0,0
  NUMG(20,4,0,0,0,0,0,0): 1,3,3,0,0,0,0,0,1,0,0,0
  IT_MAR_MAX(24,4,0,0,0,0,0,0): 1,3,3,0,0,0,0,0,1,0,0,0
  EPS_MAR(0,8,0,0,0,0,0,0): 2,2,5,0,0,0,0,0,1,0,0,0
  NUMPORT(28,4,0,0,0,0,0,0): 1,3,3,0,0,0,0,0,1,0,0,0
  IT_MAX(32,4,0,0,0,0,0,0): 1,3,3,0,0,0,0,0,1,0,0,0
  EPS(8,8,0,0,0,0,0,0): 2,2,5,0,0,0,0,0,1,0,0,0
ENDTYPE
TYPE PORT_INFO,1,2097216,0,88
  PNUM(72,4,0,0,0,0,0,0): 1,3,3,0,0,0,0,0,1,0,0,0
  COUN(76,4,0,0,0,0,0,0): 1,3,3,0,0,0,0,0,1,0,0,0
  TL(0,8,0,0,0,0,0,0): 2,2,5,0,0,0,0,0,1,0,0,0
  TUL(8,8,0,0,0,0,0,0): 2,2,5,0,0,0,0,0,1,0,0,0
  TRS(16,8,0,0,0,0,0,0): 2,2,5,0,0,0,0,0,1,0,0,0
  THC_EX(24,8,0,0,0,0,0,0): 2,2,5,0,0,0,0,0,1,0,0,0
  THC_IM(32,8,0,0,0,0,0,0): 2,2,5,0,0,0,0,0,1,0,0,0
  TEU_LOCAL(40,8,0,0,0,0,0,0): 2,2,5,0,0,0,0,0,1,0,0,0
  TEU_TS(48,8,0,0,0,0,0,0): 2,2,5,0,0,0,0,0,1,0,0,0
  TS_MAJOR(80,4,0,0,0,0,0,0): 1,3,3,0,0,0,0,0,1,0,0,0
  INLAND_FLAG(84,4,0,0,0,0,0,0): 1,3,3,0,0,0,0,0,1,0,0,0
  CAP(56,8,0,0,0,0,0,0): 2,2,5,0,0,0,0,0,1,0,0,0
  TERNUM(64,8,0,0,0,0,0,0): 2,2,5,0,0,0,0,0,1,0,0,0
ENDTYPE
TYPE MAR_NUM_INFO,1,2097216,0,8
  T_LINK(0,4,0,0,0,0,0,0): 1,3,3,0,0,0,0,0,1,0,0,0
  NODE(4,4,0,0,0,0,0,0): 1,3,3,0,0,0,0,0,1,0,0,0
ENDTYPE
TYPE MAR_LINK_INFO,1,2097216,0,128
  ID(80,4,0,0,0,0,0,0): 1,3,3,0,0,0,0,0,1,0,0,0
  G(84,4,0,0,0,0,0,0): 1,3,3,0,0,0,0,0,1,0,0,0
  R(88,4,0,0,0,0,0,0): 1,3,3,0,0,0,0,0,1,0,0,0
  P1(92,4,0,0,0,0,0,0): 1,3,3,0,0,0,0,0,1,0,0,0
  P2(96,4,0,0,0,0,0,0): 1,3,3,0,0,0,0,0,1,0,0,0
  PO(100,4,0,0,0,0,0,0): 1,3,3,0,0,0,0,0,1,0,0,0
  PD(104,4,0,0,0,0,0,0): 1,3,3,0,0,0,0,0,1,0,0,0
  NODE1(108,4,0,0,0,0,0,0): 1,3,3,0,0,0,0,0,1,0,0,0
  NODE2(112,4,0,0,0,0,0,0): 1,3,3,0,0,0,0,0,1,0,0,0
  NODEF(116,4,0,0,0,0,0,0): 1,3,3,0,0,0,0,0,1,0,0,0
  NODET(120,4,0,0,0,0,0,0): 1,3,3,0,0,0,0,0,1,0,0,0
  TP(124,4,0,0,0,0,0,0): 1,3,3,0,0,0,0,0,1,0,0,0
  TIME(0,8,0,0,0,0,0,0): 2,2,5,0,0,0,0,0,1,0,0,0
  PANAMA(8,8,0,0,0,0,0,0): 2,2,5,0,0,0,0,0,1,0,0,0
  SUEZ(16,8,0,0,0,0,0,0): 2,2,5,0,0,0,0,0,1,0,0,0
  COST(24,8,0,0,0,0,0,0): 2,2,5,0,0,0,0,0,1,0,0,0
  FC(32,8,0,0,0,0,0,0): 2,2,5,0,0,0,0,0,1,0,0,0
  CC(40,8,0,0,0,0,0,0): 2,2,5,0,0,0,0,0,1,0,0,0
  MC(48,8,0,0,0,0,0,0): 2,2,5,0,0,0,0,0,1,0,0,0
  CAP(56,8,0,0,0,0,0,0): 2,2,5,0,0,0,0,0,1,0,0,0
  FREQ(64,8,0,0,0,0,0,0): 2,2,5,0,0,0,0,0,1,0,0,0
  FREQWAITTIME(72,8,0,0,0,0,0,0): 2,2,5,0,0,0,0,0,1,0,0,0
ENDTYPE
TYPE MAR_NODE_INFO,1,2097216,0,9036
  ID(0,4,0,0,0,0,0,0): 1,3,3,0,0,0,0,0,1,0,0,0
  LNKIN(4,4516,0,0,0,0,0,0): 1,3,3,0,0,1,0,0,1 (1,1,1129: 1,1,0,1128),0,0,0
  LNKOUT(4520,4516,0,0,0,0,0,0): 1,3,3,0,0,1,0,0,1 (1,1,1129: 1,1,0,1128),0,0,0
ENDTYPE
TYPE MAR_ORGN_INFO,1,2097216,0,8
  NORG(0,4,0,0,0,0,0,0): 1,3,3,0,0,0,0,0,1,0,0,0
  NSEQ(4,4,0,0,0,0,0,0): 1,3,3,0,0,0,0,0,1,0,0,0
ENDTYPE
TYPE MAR_DSTN_INFO,1,2097216,0,8
  NORG(0,4,0,0,0,0,0,0): 1,3,3,0,0,0,0,0,1,0,0,0
  NSEQ(4,4,0,0,0,0,0,0): 1,3,3,0,0,0,0,0,1,0,0,0
ENDTYPE
TYPE COUN_INFO,1,2097216,0,56
  ID(32,4,0,0,0,0,0,0): 1,3,3,0,0,0,0,0,1,0,0,0
  D_EX_DOC(36,4,0,0,0,0,0,0): 1,3,3,0,0,0,0,0,1,0,0,0
  D_EX_CUS(40,4,0,0,0,0,0,0): 1,3,3,0,0,0,0,0,1,0,0,0
  D_IM_DOC(44,4,0,0,0,0,0,0): 1,3,3,0,0,0,0,0,1,0,0,0
  D_IM_CUS(48,4,0,0,0,0,0,0): 1,3,3,0,0,0,0,0,1,0,0,0
  M_EX_DOC(0,8,0,0,0,0,0,0): 2,2,5,0,0,0,0,0,1,0,0,0
  M_EX_CUS(8,8,0,0,0,0,0,0): 2,2,5,0,0,0,0,0,1,0,0,0
  M_IM_DOC(16,8,0,0,0,0,0,0): 2,2,5,0,0,0,0,0,1,0,0,0
  M_IM_CUS(24,8,0,0,0,0,0,0): 2,2,5,0,0,0,0,0,1,0,0,0
ENDTYPE
PARAMETER GMAX: 1,3,3,0,0,0,4001,1,0,0,0
= 40
PARAMETER RMAX: 1,3,3,0,0,0,4101,1,0,0,0
= 1128
END
