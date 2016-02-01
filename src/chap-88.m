#*************************************************************************************************************************
#
#Copyright or © or Copr.[DGFIP][2015]
#
#Ce logiciel a été initialement développé par la Direction Générale des 
#Finances Publiques pour permettre le calcul de l'impôt sur le revenu 2015 
#au titre des revenus perçus en 2014. La présente version a permis la 
#génération du moteur de calcul des chaînes de taxation des rôles d'impôt 
#sur le revenu de ce millésime.
#
#Ce logiciel est régi par la licence CeCILL 2.1 soumise au droit français 
#et respectant les principes de diffusion des logiciels libres. Vous pouvez 
#utiliser, modifier et/ou redistribuer ce programme sous les conditions de 
#la licence CeCILL 2.1 telle que diffusée par le CEA, le CNRS et l'INRIA  sur 
#le site "http://www.cecill.info".
#
#Le fait que vous puissiez accéder à cet en-tête signifie que vous avez pris 
#connaissance de la licence CeCILL 2.1 et que vous en avez accepté les termes.
#
#**************************************************************************************************************************
regle 881:
application : iliad , batch  ;
pour i = V,C;x=1..3:
GLNAVxi = max (GLDxi - ABGLxi,0) * INDEFTSi;
GLDOMAVDAJV = max (CODDAJ - ABDOMDAJ,0) * INDEFTSV;
GLDOMAVEAJV = max (CODEAJ - ABDOMEAJ,0) * INDEFTSV;
GLDOMAVDBJC = max (CODDBJ - ABDOMDBJ,0) * INDEFTSC;
GLDOMAVEBJC = max (CODEBJ - ABDOMEBJ,0) * INDEFTSC;
GLN1V = max (GLD1V - ABGL1V,0) * INDEFTSV;
GLN2V = max (GLD2V - ABGL2V,0) * INDEFTSV;
GLN3V = max (GLD3V - ABGL3V,0) * INDEFTSV;
GLN4DAJV = max(CODDAJ - ABDOMDAJ,0) * INDEFTSV;
GLN4V = (max(CODDAJ - ABDOMDAJ,0)+max(CODEAJ - ABDOMEAJ,0)) * INDEFTSV;
GLN1C = max (GLD1C - ABGL1C,0) * INDEFTSC;
GLN2C = max (GLD2C - ABGL2C,0) * INDEFTSC;
GLN3C = max (GLD3C - ABGL3C,0) * INDEFTSC;
GLN4DBJC = max(CODDBJ - ABDOMDBJ,0) * INDEFTSC;
GLN4C = (max(CODDBJ - ABDOMDBJ,0)+max(CODEBJ - ABDOMEBJ,0)) * INDEFTSC;
regle 882:
application : iliad , batch  ;
TSV = TSNV - somme(x=1..3: max(0,GLDxV - ABGLxV))-max(CODDAJ - ABDOMDAJ,0)-max(CODEAJ - ABDOMEAJ,0);
TSC = TSNC - somme(x=1..3: max(0,GLDxC - ABGLxC))-max(CODDBJ - ABDOMDBJ,0)-max(CODEBJ - ABDOMEBJ,0);
pour i=1..4:
TSi = TSNi;
pour i=V,C:
TPRi = TSNi + PRNi - somme(x=1..3: GLNxi);
pour i=1..4:
TPRi = TSNi + PRNi;
pour i = V,C :
TSNNi =  positif(TSi) *arr(TSi *(TSBNi + BPCOSAi + GLDGRATi)/EXTSi )
          + (1 -positif(TSi)) * TSi ;
pour i = 1..4 :
TSNNi = (positif(TSi) * arr(TSi * TSBNi /EXTSi )
            + (1 -positif(TSi)) * TSi)  ;
pour i = V,C :
TSNN2i = ( positif(TSi)
                * ( positif(CARTSi+REMPLAi) 
                          * arr(TSi * 2TSNi / EXTSi )
                    + (1 -positif(CARTSi+REMPLAi)) 
                          * (TSi - TSNNi)));
TSNN2VAFF = ( positif(TSV)
                * ( positif(CARTSV+REMPLAV) 
                          * arr(TSV * 2TSNV / EXTSV )
                    + (1 -positif(CARTSV+REMPLAV)) 
                          * (TSV - TSNNV))
         + positif(CODDAJ + CODEAJ) * (max(CODDAJ - ABDOMDAJ,0)+max(CODEAJ - ABDOMEAJ,0))) ;
TSNN2CAFF = ( positif(TSC)
                * ( positif(CARTSC+REMPLAC) 
                          * arr(TSC * 2TSNC / EXTSC )
                    + (1 -positif(CARTSC+REMPLAC)) 
                          * (TSC - TSNNC))
         + positif(CODDBJ + CODEBJ) * (max(CODDBJ - ABDOMDBJ,0)+max(CODEBJ - ABDOMEBJ,0))) ;
pour i = 1..4 :
TSNN2i = ( positif(TSi)
               * ( positif(CARTSPi+REMPLAPi) 
                          * arr(TSi * 2TSNi /EXTSi )
                    + (1 -positif(CARTSPi+REMPLAPi)) 
                          * (TSi - TSNNi))) ;
pour i = 1..4 :
TSNN2iAFF = ( positif(TSi)
               * ( positif(CARTSPi+REMPLAPi) 
                          * arr(TSi * 2TSNi /EXTSi )
                    + (1 -positif(CARTSPi+REMPLAPi)) 
                          * (TSi - TSNNi))) ;

TSNN2PAFF = somme(i=1..4:TSNN2iAFF) ;

pour i = V,C :
TSNN2TSi = ( positif(TSi)
                * ( positif(REMPLAi) 
                          * arr(TSi * CARTSi / EXTSi )
                    + (1 -positif(REMPLAi)) 
                          * (TSi - TSNNi))) ;
pour i = 1..4 :
TSNN2TSi = ( positif(TSi)
               * ( positif(REMPLAPi) 
                          * arr(TSi * CARTSPi /EXTSi )
                    + (1 -positif(REMPLAPi)) 
                          * (TSi - TSNNi))) ;
pour i = V,C :
TSNN2REMPi = (positif(TSi) * (TSi - TSNNi-TSNN2TSi)) ;
pour i = 1..4 :
TSNN2REMPi = (positif(TSi) * (TSi - TSNNi-TSNN2TSi)) ;

regle 883:
application : iliad , batch  ;
pour i = V,C,1..4:
PRRi = arr(PRNi * PRBi / EXPRi);
PRR2V = positif(PEBFV+PENSALV+CODRAZ) * arr(PRNV * CARPEV / EXPRV)
           +  (1 -positif(PEBFV+PENSALV+CODRAZ)) * (PRNV -PRRV)   ;
PRR2C = positif(PEBFC+PENSALC+CODRBZ) * arr(PRNC * CARPEC / EXPRC)
           +  (1 -positif(PEBFC+PENSALC+CODRBZ)) * (PRNC -PRRC)   ;
PRR21 = positif(PEBF1+PENSALP1+CODRCZ) * arr(PRN1 * CARPEP1 / EXPR1 )
           +  (1 -positif(PEBF1+PENSALP1+CODRCZ)) * (PRN1 -PRR1);
PRR22 = positif(PEBF2+PENSALP2+CODRDZ) * arr(PRN2 * CARPEP2 / EXPR2 )
           +  (1 -positif(PEBF2+PENSALP2+CODRDZ)) * (PRN2 -PRR2);
PRR23 = positif(PEBF3+PENSALP3+CODREZ) * arr(PRN3 * CARPEP3 / EXPR3 )
           +  (1 -positif(PEBF3+PENSALP3+CODREZ)) * (PRN3 -PRR3);
PRR24 = positif(PEBF4+PENSALP4+CODRFZ) * arr(PRN4 * CARPEP4 / EXPR4 )
           +  (1 -positif(PEBF4+PENSALP4+CODRFZ)) * (PRN4 -PRR4);
PRR2ZV = positif(PEBFV+PENSALV) * arr(PRNV * CODRAZ / EXPRV)
           +  (1 -positif(PEBFV+PENSALV)) * (PRNV -PRRV-PRR2V)   ;
PRR2ZC = positif(PEBFC+PENSALC) * arr(PRNC * CODRBZ / EXPRC)
           +  (1 -positif(PEBFC+PENSALC)) * (PRNC -PRRC-PRR2C)   ;
PRR2Z1 = positif(PEBF1+PENSALP1) * arr(PRN1 * CODRCZ / EXPR1 )
           +  (1 -positif(PEBF1+PENSALP1)) * (PRN1 -PRR1-PRR21);
PRR2Z2 = positif(PEBF2+PENSALP2) * arr(PRN2 * CODRDZ / EXPR2 )
           +  (1 -positif(PEBF2+PENSALP2)) * (PRN2 -PRR2-PRR22);
PRR2Z3 = positif(PEBF3+PENSALP3) * arr(PRN3 * CODREZ / EXPR3 )
           +  (1 -positif(PEBF3+PENSALP3)) * (PRN3 -PRR3-PRR23);
PRR2Z4 = positif(PEBF4+PENSALP4) * arr(PRN4 * CODRFZ / EXPR4 )
           +  (1 -positif(PEBF4+PENSALP4)) * (PRN4 -PRR4-PRR24);
PRR2ZP = PRR2Z1 + PRR2Z2 + PRR2Z3 + PRR2Z4;
pour i = V,C:
PENFi =  positif(PENSALi) * arr(PRNi * PEBFi / EXPRi)
       + (1 - positif(PENSALi)) * max(0,(PRNi -PRRi -PRR2i-PRR2Zi));
pour i = 1..4:
PENFi =  positif(PENSALPi) * arr(PRNi * PEBFi / EXPRi)
        + (1- positif(PENSALPi)) * (PRNi -PRRi -PRR2i-PRR2Zi);
pour i = V,C:
PENALIMi = positif(EXPRi) * (PRNi -PRRi -PRR2i -PRR2Zi- PENFi) ;
pour i = 1..4:
PENALIMi = positif(EXPRi) * (PRNi -PRRi -PRR2i -PRR2Zi- PENFi) ;
regle 884:
application : iliad , batch  ;
pour i = 1,2,3,4:
RVi = arr(RVBi * TXRVTi / 100);
RVTOT = RV1 + RV2 + RV3 + RV4;
regle 885:
application : iliad , batch  ;
2RV1 = arr(RENTAX * TXRVT1 / 100);
2RV2 = arr(RENTAX5 * TXRVT2 / 100);
2RV3 = arr(RENTAX6 * TXRVT3 / 100);
2RV4 = arr(RENTAX7 * TXRVT4 / 100);
T2RV = 2RV1 + 2RV2 + 2RV3 + 2RV4;
regle 886:
application : iliad , batch  ;
RVBCSG = arr((RVB1 + RENTAX) * TXRVT1 / 100) 
       + arr((RVB2 + RENTAX5) * TXRVT2 / 100) 
       + arr((RVB3 + RENTAX6) * TXRVT3 / 100) 
       + arr((RVB4 + RENTAX7) * TXRVT4 / 100) ;

regle 887:
application : iliad , batch  ;
TSPR = TSPRT + RVTOT ;
regle 888:
application : iliad , batch  ;
pour i=V,C,1..4:
TSPRi = (TSNNi + PRRi) * (1-PREM8_11) + max(0,TSNNi + PRRi) * PREM8_11;
pour i=V,C,1..4:
TSPRDi = min(0,TSNNi + PRRi)* ART1731BIS ;
TSPRP = somme(i=1..4:TSPRi) * (1-PREM8_11) + max(0,TSNN1+PRR1+TSNN2+PRR2+TSNN3+PRR3+TSNN4+PRR4) * PREM8_11 ;
TSPRTOT = somme(i=V,C,1..4:TSPRi)*(1-ART1731BIS) + max(0,TSNNV+PRRV+TSNNC+PRRC+TSNN1+PRR1+TSNN2+PRR2+TSNN3+PRR3+TSNN4+PRR4)*ART1731BIS;
TSPRDP = somme(i=1..4:TSPRDi) ;
TSNNT = abs(TSNNV + PRRV
          + TSNNC + PRRC
          + TSNN1 + PRR1
          + TSNN2 + PRR2
          + TSNN3 + PRR3
          + TSNN4 + PRR4) 
         * (1-positif(TSNNV + PRRV + TSNNC + PRRC+ TSNN1 + PRR1 + TSNN2 + PRR2 + TSNN3 + PRR3 + TSNN4 + PRR4 ));
regle 8887:
application : iliad , batch  ;
pour i=V,C,1..4:
FRNRETENUi = max(0,FRNRETi + TSPRDi);
regle 8810:
application : iliad , batch  ;
TSNN2P = somme(i=1..4: TSNN2i);
PRR2P =somme(i=1..4: PRR2i);
PENFP = PENF1 + PENF2 + PENF3 + PENF4 ;
PENALIMP = PENALIM1 + PENALIM2 + PENALIM3 + PENALIM4;

regle 8811:
application : iliad , batch ;
TSQVO = 2TSNV+CODDAJ+CODEAJ;
TSQCJ = 2TSNC+CODDBJ+CODEBJ;
TSQPC = somme(i=1..4: 2TSNi ) ;
PRQVO =  CARPEV + PEBFV;
PRQCJ =  CARPEC + PEBFC; 
PRQPC =  CARPEP1+PEBF1 
      +  CARPEP2+PEBF2
      +  CARPEP3+PEBF3
      +  CARPEP4+PEBF4;
PRQZV =  CODRAZ;
PRQZC =  CODRBZ; 
PRQZP =  CODRCZ +CODRDZ+CODREZ+CODRFZ;
PENSALP = PENSALP1 + PENSALP2 + PENSALP3 + PENSALP4;
regle 8812:
application : iliad , batch ;
PRQNV = 2PRBV;
PRQNC = 2PRBC; 
PRQNP = somme(i=1..4: 2PRBi) ;
PENSTOTV = PRR2V + PRR2ZV + PENALIMV;
PENSTOTC = PRR2C + PRR2ZC + PENALIMC;
PENSTOTP = PRR2P + PRR2Z1 + PRR2Z2 + PRR2Z3 + PRR2Z4 + PENALIMP;
regle 8815:
application : iliad , batch ;
pour i=V,C:
BPCAPTAXi = PCAPTAXi - arr(PCAPTAXi * TX_DEDPER/100);
pour i=V,C:
IPCAPTAXi = arr(BPCAPTAXi * T_PCAPTAX/100);
IPCAPTAXTOT = somme(i=V,C:IPCAPTAXi);
regle 8816:
application : iliad , batch ;
IPCAPTAXT = IPCAPTAXTOT - CICAP;
