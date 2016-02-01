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
regle 99991000:
application : iliad , batch ;

pour i = V,C,P:
TMIB_TVENi = MIBVENi + AUTOBICVi + MIBNPVENi + MIBGITEi+LOCGITi;

pour i = V,C,P:
TMIB_TPRESi = MIBPRESi + AUTOBICPi + MIBNPPRESi + MIBMEUi;

pour i = V,C,P:
TMIB_TTi = TMIB_TVENi + TMIB_TPRESi;
regle 99991004:
application : iliad , batch ;


pour i = V,C,P:
TMIB_AVi = min ( TMIB_TVENi,
                         (max(MIN_MBIC,
                              arr( (TMIB_TVENi)*TX_MIBVEN/100))
                         )
              );
pour i = V,C,P:
TMIB_VENTAi = min ( (MIBVENi + MIBNPVENi),
                         (max(MIN_MBIC,
                              arr( (MIBVENi + MIBNPVENi)*TX_MIBVEN/100))
                         )
              );
pour i = V,C,P:
TMIB_AUTOAVi= TMIB_AVi - TMIB_VENTAi; 


pour i = V,C,P:
TMIB_APi = min ( TMIB_TPRESi,
                         (max(MIN_MBIC,
                              arr( (TMIB_TPRESi)*TX_MIBPRES/100))
                         )
               );
pour i = V,C,P:
TMIB_PRESAi = min ( (MIBPRESi + MIBNPPRESi),
                         (max(MIN_MBIC,
                              arr( (MIBPRESi + MIBNPPRESi)*TX_MIBPRES/100))
                         )
               );
pour i = V,C,P:
TMIB_AUTOAPi= TMIB_APi - TMIB_PRESAi; 
pour i = V,C,P:
TPMIB_AVi = min ( (MIBVENi + AUTOBICVi),
                         (max(MIN_MBIC,
                              arr( (MIBVENi+ AUTOBICVi)*TX_MIBVEN/100))
                         )
              );
pour i = V,C,P:
TPMIB_APi = min ( (MIBPRESi+ AUTOBICPi),
                         (max(MIN_MBIC,
                              arr( (MIBPRESi+ AUTOBICPi)*TX_MIBPRES/100))
                         )
               );


regle 99991005:
application : iliad , batch ;

pour i = V,C,P:
TMIB_ABVi = max(0,arr(TMIB_AVi * (MIBVENi + AUTOBICVi)/ (TMIB_TVENi)));
pour i = V,C,P:
TMIB_ABNPVi = max(0,arr(TMIB_AVi * MIBNPVENi / TMIB_TVENi))* positif(present(MIBGITEi)+present(LOCGITi))
	      + (TMIB_AVi - TMIB_ABVi) * (1 - positif(present(MIBGITEi)+present(LOCGITi)));
pour i = V,C,P:
TMIB_ABNPVLi = (TMIB_AVi - TMIB_ABVi - TMIB_ABNPVi) *  positif(present(MIBGITEi)+present(LOCGITi));

pour i = V,C,P:
TMIB_ABPi = max(0,arr(TMIB_APi * (MIBPRESi + AUTOBICPi)/ (TMIB_TPRESi)));
pour i = V,C,P:
TMIB_ABNPPi = max(0,arr(TMIB_APi * MIBNPPRESi / (TMIB_TPRESi))) * present(MIBMEUi)
	      + (TMIB_APi - TMIB_ABPi) * (1 - present(MIBMEUi));
pour i = V,C,P:
TMIB_ABNPPLi = (TMIB_APi - TMIB_ABPi - TMIB_ABNPPi) *  present(MIBMEUi);


regle 99991006:
application : iliad , batch ;
pour i = V,C,P:
TPMIB_NETVi = MIBVENi + AUTOBICVi - TPMIB_AVi;
pour i = V,C,P:
TPMIB_NETPi = MIBPRESi + AUTOBICPi - TPMIB_APi;

pour i = V,C,P:
TMIB_NETVi = MIBVENi + AUTOBICVi - TMIB_ABVi;
TMIBNETVF = somme(i=V,C,P:TMIB_NETVi) ;
pour i = V,C,P:
TMIB_NETNPVi = MIBNPVENi - TMIB_ABNPVi;
TMIBNETNPVF = somme(i=V,C,P:TMIB_NETNPVi);

pour i = V,C,P:
TMIB_NETPi = MIBPRESi + AUTOBICPi - TMIB_ABPi;
TMIBNETPF = somme(i=V,C,P:TMIB_NETPi) ;
pour i = V,C,P:
TMIB_NETNPPi = MIBNPPRESi - TMIB_ABNPPi;
TMIBNETNPPF = somme(i=V,C,P:TMIB_NETNPPi);

TBICPABV =   arr((TMIB_ABVV * AUTOBICVV/(MIBVENV+AUTOBICVV))
          + (TMIB_ABPV * AUTOBICPV/(MIBPRESV+AUTOBICPV)));

TBICPROVC = max(0,arr((TMIB_ABVC * AUTOBICVC/(MIBVENC+AUTOBICVC)) + (TMIB_ABPC * AUTOBICPC/(MIBPRESC+AUTOBICPC))));

TBICPABC =  min(TBICPROVC,arr((TMIB_ABVC * AUTOBICVC/(MIBVENC+AUTOBICVC))
          + (TMIB_ABPC * AUTOBICPC/(MIBPRESC+AUTOBICPC))));

TBICPROVP = max(0,arr((TMIB_ABVP * AUTOBICVP/(MIBVENP+AUTOBICVP)) + (TMIB_ABPP * AUTOBICPP/(MIBPRESP+AUTOBICPP))));

TBICPABP =  min(TBICPROVP,arr((TMIB_ABVP * AUTOBICVP/(MIBVENP+AUTOBICVP))
          + (TMIB_ABPP* AUTOBICPP/(MIBPRESP+AUTOBICPP))));

TBICNPABV = arr((TMIB_ABNPVV /(MIBNPVENV))
          + (TMIB_ABNPPV /(MIBNPPRESV)));
TBICNPPROVC = max(0,arr((TMIB_ABNPVC /(MIBNPVENC)) + (TMIB_ABNPPC /(MIBNPPRESC))));
TBICNPABC = min(TBICNPPROVC,arr((TMIB_ABNPVC /(MIBNPVENC))
          + (TMIB_ABNPPC /(MIBNPPRESC))));
TBICNPPROVP = max(0,arr((TMIB_ABNPVP /(MIBNPVENP)) + (TMIB_ABNPPP /(MIBNPPRESP))));
TBICNPABP = min(TBICNPPROVP,arr((TMIB_ABNPVP /(MIBNPVENP))
          + (TMIB_ABNPPP /(MIBNPPRESP))));
ABICPDECV = AUTOBICVV + AUTOBICPV;
ABICPDECC = AUTOBICVC + AUTOBICPC;
ABICPDECP = AUTOBICVP + AUTOBICPP;
ABICPNETV =  AUTOBICVV + AUTOBICPV - max(0,TMIB_AUTOAVV-TMIB_ABNPVLV) -max(0,TMIB_AUTOAPV-TMIB_ABNPPLV);
ABICPNETC =  AUTOBICVC + AUTOBICPC - max(0,TMIB_AUTOAVC-TMIB_ABNPVLC) -max(0,TMIB_AUTOAPC-TMIB_ABNPPLC);
ABICPNETP =  AUTOBICVP + AUTOBICPP - max(0,TMIB_AUTOAVP-TMIB_ABNPVLP) -max(0,TMIB_AUTOAPP-TMIB_ABNPPLP);

AUTOBICPNET = ABICPNETV + ABICPNETC + ABICPNETP;
regle 99991009:                                                                    
application : iliad , batch  ;                          
pour i = V,C,P:                                                                 
TSPETOTi = BNCPROi + AUTOBNCi + BNCNPi ;
regle 99991010:
application : iliad , batch  ;                          
pour i = V,C,P:                                                                 
TSPEBASABi=TSPETOTi;
pour i = V,C,P:                                                                 
TSPEABi = arr((max(MIN_SPEBNC,(TSPEBASABi * SPETXAB/100))) * 
                       positif_ou_nul(TSPETOTi - MIN_SPEBNC)) +
          arr((min(MIN_SPEBNC,TSPEBASABi )) * 
                       positif(MIN_SPEBNC - TSPETOTi)); 
regle 99991011:
application : iliad , batch  ;                          
pour i = V,C,P:                                                                 
TSPEABPi = arr((TSPEABi * (BNCPROi + AUTOBNCi))/TSPETOTi);                                  
pour i = V,C,P:                                                                 
TBNCPABi = arr(TSPEABPi * AUTOBNCi/(BNCPROi+AUTOBNCi)); 
pour i = V,C,P:                                                                 
TBNCTOTABi = arr(TSPEABi * (AUTOBNCi)/(TSPETOTi)); 

pour i = V,C,P:                                                                 
TSPEABNPi = TSPEABi - TSPEABPi;                                  
pour i = V,C,P:                                                                 
TBNCNPABi = (TBNCTOTABi - TBNCPABi) ;

pour i = V,C,P:                                                                 
ABNCPDECi =  AUTOBNCi; 
pour i = V,C,P:                                                                 
ABNCPNETi =  AUTOBNCi - TBNCPABi; 
pour i = V,C,P:                                                                 
HONODECi = XHONOi + XHONOAAi;
pour i = V,C,P:                                                                 
HONONETi = arr(XHONOi * MAJREV) + XHONOAAi ;
AUTOBNCPNET = ABNCPNETV + ABNCPNETC + ABNCPNETP;
HONONET = HONONETV + HONONETC + HONONETP;
regle 99991012:
application : iliad , batch  ;                          
pour i = V,C,P:                                                                 
TSPENETPi = max (0,(BNCPROi  + AUTOBNCi - TSPEABPi));
pour i = V,C,P:                                                                 
TSPENETNPi = max (0,(BNCNPi - TSPEABNPi));
pour i = V,C,P:                                                                 
TSPENETi = TSPENETPi + TSPENETNPi;
TSPENET = somme(i=V,C,P:(TSPENETi));
regle 99991020:
application : iliad , batch  ;                          
pour i = V,C,P:                                                                 
TXSPEAAi = BNCREi + XHONOAAi - (BNCDEi * (1 - positif(ART1731BIS) ));
regle 99991022:
application : iliad , batch  ;                          
pour i = V,C,P:                                                                 
TXSPEHi = max(0,arr((BNHREi + XHONOi - (BNHDEi * (1 - positif(ART1731BIS) )))*MAJREV))
	 + min(0,(BNHREi + XHONOi - (BNHDEi * (1 - positif(ART1731BIS) ))));
regle 99991024:
application : iliad , batch  ;                          
pour i = V,C,P:                                                                 
TXSPENETi = TXSPEAAi + TXSPEHi;
regle 99991026:
application : iliad , batch  ;                          
TXSPENET = somme(i=V,C,P:(TXSPENETi));
 #
 #                         REVENUS CATEGORIELS NETS
 #                 TS
 #
regle 99992000:
application : iliad , batch  ;
TTSBNV = TSHALLOV + ALLOV+max(0,SALEXTV - COD1AD);
TTSBNC = TSHALLOC + ALLOC+max(0,SALEXTC - COD1BD);
TTSBN1 = TSHALLO1 + ALLO1+max(0,SALEXT1 - COD1CD);
TTSBN2 = TSHALLO2 + ALLO2+max(0,SALEXT2 - COD1DD);
TTSBN3 = TSHALLO3 + ALLO3+max(0,SALEXT3 - COD1ED);
TTSBN4 = TSHALLO4 + ALLO4+max(0,SALEXT4 - COD1FD);
TTSHALLOP=TSHALLO1+TSHALLO2+TSHALLO3+TSHALLO4;
TALLOP=ALLO1+ALLO2+ALLO3+ALLO4;
TTSBNP=TTSHALLOP+TALLOP;

pour i=V,C:
T2TSNi = CARTSi + REMPLAi;
pour i=1,2,3,4:
T2TSNi = CARTSPi + REMPLAPi;
TEXTSV = TTSBNV + BPCOSAV + GLDGRATV + T2TSNV;
TEXTSC = TTSBNC + BPCOSAC + GLDGRATC + T2TSNC;
TGATASAV = BPCOSAV + GLDGRATV ;
TGATASAC = BPCOSAC + GLDGRATC ;

pour i=1..4:
TEXTSi = TTSBNi + T2TSNi;
TTSBV = TEXTSV + somme(x=1..3:GLDxV)+CODDAJ+CODEAJ ;
TTSBC = TEXTSC + somme(x=1..3:GLDxC)+CODDBJ+CODEBJ ;
pour i=1,2,3,4:
TTSBi = TEXTSi;
TTSBP = somme(i=1..4:TTSBi);
pour i=V,C,1..4:
TPRBi = PRBRi + PALIi + PENINi;

T2PRBV = CARPEV + PENSALV + CODRAZ;
T2PRBC = CARPEC + PENSALC + CODRBZ;
T2PRB1 = CARPEP1 + PENSALP1 + CODRCZ;
T2PRB2 = CARPEP2 + PENSALP2 + CODRDZ;
T2PRB3 = CARPEP3 + PENSALP3 + CODREZ;
T2PRB4 = CARPEP4 + PENSALP4 + CODRFZ;
TEXPRV = TPRBV + COD1AH + T2PRBV + PEBFV;
TEXPRC = TPRBC + COD1BH + T2PRBC + PEBFC;
TEXPR1 = TPRB1 + COD1CH + T2PRB1 + PEBF1;
TEXPR2 = TPRB2 + COD1DH + T2PRB2 + PEBF2;
TEXPR3 = TPRB3 + COD1EH + T2PRB3 + PEBF3;
TEXPR4 = TPRB4 + COD1FH + T2PRB4 + PEBF4;
pour i = V,C,1..4:
TEXSPBi = TEXTSi + TEXPRi ;
regle 99992100:
application : iliad , batch  ;
pour i = V,C,1..4:
TTPS10i = arr (TTSBi * TX_DEDFORFTS /100);
pour i = V,C,1..4:
TDFNi =  min( PLAF_DEDFORFTS , TTPS10i );
regle 99992200:
application : iliad , batch  ;
pour i = V,C,1..4:
TDEDMINi = positif(DETSi)* MIN_DEMEMPLOI + (1- positif(DETSi))* MIN_DEDSFORFTS;
pour i = V,C,1..4:
T10MINSi= max( min(TTSBi,TDEDMINi) , TDFNi );
pour i = V,C,1..4:
TIND_10MIN_0i = positif(TDEDMINi - TDFNi ) * positif (TTSBi );
pour i = V,C,1..4 :
TIND_MINi = 1 - positif( TIND_10MIN_0i );
regle 99992300:
application : iliad , batch  ;
T10MINSP = T10MINS1 + T10MINS2 + T10MINS3 + T10MINS4;
TFRDPROVV = TTSBNV + TPRV + PALIV - TAPRV;
TFRDPROVC = TTSBNC + TPRC + PALIC - TAPRC;
TFRDPROV1 = TTSBN1 + PRBR1 + PALI1 - TAPR1;
TFRDPROV2 = TTSBN2 + PRBR2 + PALI2 - TAPR2;
TFRDPROV3 = TTSBN3 + PRBR3 + PALI3 - TAPR3;
TFRDPROV4 = TTSBN4 + PRBR4 + PALI4 - TAPR4;
TFRDPROVP = TFRDPROV1 +TFRDPROV2 +TFRDPROV3 +TFRDPROV4;
TFRDP = (1-positif(PREM8_11)) * (FRNP+COD1CE+COD1DE+COD1EE+COD1FE) * positif(FRNP+COD1CE+COD1DE+COD1EE+COD1FE - T10MINSP)
      + null(4-V_IND_TRAIT) * positif(PREM8_11) * min(FRNP+COD1CE+COD1DE+COD1EE+COD1FE,TFRDPROVP)
      + null(5-V_IND_TRAIT) * positif(PREM8_11) * min(FRNP+COD1CE+COD1DE+COD1EE+COD1FE,max(TFRDPROVPP2,TFRDPROVP1731));

TFRDV = (1-positif(PREM8_11)) * (FRNV+COD1AE) * positif(FRNV+COD1AE - T10MINSV)
                + null(4-V_IND_TRAIT) * positif(PREM8_11) * min(FRNV+COD1AE,TFRDPROVV)
                + null(5-V_IND_TRAIT) * positif(PREM8_11) * min(FRNV+COD1AE,min(TFRDPROVV,max(TFRDPROVVP2,TFRDPROVV1731)));

TFRDC = (1-positif(ART1731BIS)) * (FRNC+COD1BE) * positif(FRNC+COD1BE - T10MINSC)
        + null(4-V_IND_TRAIT) * positif(PREM8_11) * min(FRNC+COD1BE,TFRDPROVC)
        + null(5-V_IND_TRAIT) * positif(PREM8_11) * min(FRNC+COD1BE,min(TFRDPROVC,max(TFRDPROVCP2,TFRDPROVC1731)));



TFRD1 = (1-positif(PREM8_11)) * (FRN1+COD1CE) * positif(FRN1+COD1CE - T10MINS1)
        + null(4-V_IND_TRAIT) * (positif(PREM8_11) * min(FRN1+COD1CE,TFRDPROV1) * positif(FRN2+FRN3+FRN4+COD1DE+COD1EE+COD1FE)
                                        + positif(PREM8_11) * max(0,TFRDP) * (1-positif(FRN2+FRN3+FRN4+COD1DE+COD1EE+COD1FE)))
        + null(5-V_IND_TRAIT) * (positif(PREM8_11) * min(FRN1+COD1CE,min(TFRDPROV1,max(TFRDPROV1P2,TFRDPROV11731))) * positif(FRN2+FRN3+FRN4+COD1DE+COD1EE+COD1FE)
                                        + positif(PREM8_11) * max(0,TFRDP) * (1-positif(FRN2+FRN3+FRN4+COD1DE+COD1EE+COD1FE)));



TFRD2 = (1-positif(PREM8_11)) * (FRN2+COD1DE) * positif(FRN2+COD1DE - T10MINS2)
        + null(4-V_IND_TRAIT) * (positif(PREM8_11) * min(FRN2+COD1DE,TFRDPROV2) * positif(FRN3+FRN4+COD1EE+COD1FE)
                                        + positif(PREM8_11) * max(0,TFRDP-TFRD1) * (1-positif(FRN3+FRN4+COD1EE+COD1FE)))
        + null(5-V_IND_TRAIT) * (positif(PREM8_11) * min(FRN2+COD1DE,min(TFRDPROV2,max(TFRDPROV2P2,TFRDPROV21731))) * positif(FRN3+FRN4+COD1EE+COD1FE)
                                        + positif(PREM8_11) * max(0,TFRDP-TFRD1) * (1-positif(FRN3+FRN4+COD1EE+COD1FE)));



TFRD3 = (1-positif(PREM8_11)) * (FRN3+COD1EE) * positif(FRN3+COD1EE - T10MINS3)
        + null(4-V_IND_TRAIT) * (positif(PREM8_11) * min(FRN3+COD1EE,TFRDPROV3) * positif(FRN4+COD1FE)
                                        + positif(PREM8_11) * max(0,TFRDP-TFRD1-TFRD2) * (1-positif(FRN4+COD1FE)))
        + null(5-V_IND_TRAIT) * (positif(PREM8_11) * min(FRN3+COD1EE,min(TFRDPROV3,max(TFRDPROV3P2,TFRDPROV31731))) * positif(FRN4+COD1FE)
                                        + positif(PREM8_11) * max(0,TFRDP-TFRD1-TFRD2) * (1-positif(FRN4+COD1FE)));



TFRD4 =  max(0,TFRDP - TFRD1 - TFRD2 - TFRD3);

TIND_10V = positif_ou_nul( T10MINSV - (TFRDV+COD1AE) ) ;
TIND_10C = positif_ou_nul( T10MINSC - (TFRDC+COD1BE) ) ;
TIND_101 = positif_ou_nul( T10MINS1 - (TFRD1+COD1CE) ) ;
TIND_102 = positif_ou_nul( T10MINS2 - (TFRD2+COD1DE) ) ;
TIND_103 = positif_ou_nul( T10MINS3 - (TFRD3+COD1EE) ) ;
TIND_104 = positif_ou_nul( T10MINS4 - (TFRD4+COD1FE) ) ;
pour i = V,C,1..4:
TFPTi = max(TFRDi, T10MINSi);
pour i = V,C,1..4:
TD10Mi = TIND_MINi *TDFNi 
        + (1 - TIND_MINi)* T10MINSi ; 
pour i = V,C,1..4:
TREP10i =  TIND_10i * TD10Mi + (1-TIND_10i) * TFPTi ;
TABTS1AJ=positif(SALEXTV+ALLOV+BPCOSAV+GLDGRATV+CARTSV+REMPLAV+CODDAJ+CODEAJ+GLD1V+GLD2V+GLD3V) * arr(TREP10V*(TSHALLOV)/TTSBV)
        + (1-positif(SALEXTV+ALLOV+BPCOSAV+GLDGRATV+CARTSV+REMPLAV+CODDAJ+CODEAJ+GLD1V+GLD2V+GLD3V)) * TREP10V;
TABTS1AC=positif(ALLOV+BPCOSAV+GLDGRATV+CARTSV+REMPLAV+CODDAJ+CODEAJ+GLD1V+GLD2V+GLD3V) * arr(TREP10V*(max(0,SALEXTV-COD1AD))/TTSBV)
        + (1-positif(ALLOV+BPCOSAV+GLDGRATV+CARTSV+REMPLAV+CODDAJ+CODEAJ+GLD1V+GLD2V+GLD3V)) * max(0,TREP10V-TABTS1AJ);
TABTS1AP=positif(BPCOSAV+GLDGRATV+CARTSV+REMPLAV+CODDAJ+CODEAJ+GLD1V+GLD2V+GLD3V) * arr(TREP10V*(ALLOV)/TTSBV)
        + (1-positif(BPCOSAV+GLDGRATV+CARTSV+REMPLAV+CODDAJ+CODEAJ+GLD1V+GLD2V+GLD3V)) * max(0,TREP10V-TABTS1AJ-TABTS1AC);
TABTS3VJ=positif(GLDGRATV+CARTSV+REMPLAV+CODDAJ+CODEAJ+GLD1V+GLD2V+GLD3V) * arr(TREP10V*(BPCOSAV)/TTSBV)
        + (1-positif(GLDGRATV+CARTSV+REMPLAV+CODDAJ+CODEAJ+GLD1V+GLD2V+GLD3V)) * max(0,TREP10V-TABTS1AJ-TABTS1AC-TABTS1AP);
TABTS1TT=positif(CARTSV+REMPLAV+CODDAJ+CODEAJ+GLD1V+GLD2V+GLD3V) * arr(TREP10V*(GLDGRATV)/TTSBV)
        + (1-positif(CARTSV+REMPLAV+CODDAJ+CODEAJ+GLD1V+GLD2V+GLD3V)) * max(0,TREP10V-TABTS1AJ-TABTS1AC-TABTS1AP-TABTS3VJ);
TABTSRAJ=positif(REMPLAV+CODDAJ+CODEAJ+GLD1V+GLD2V+GLD3V) * arr(TREP10V*(CARTSV)/TTSBV)
        + (1-positif(REMPLAV+CODDAJ+CODEAJ+GLD1V+GLD2V+GLD3V)) * max(0,TREP10V-TABTS1AJ-TABTS1AC-TABTS1AP-TABTS3VJ-TABTS1TT);
TABTSRAP=positif(REMPLAV+CODDAJ+CODEAJ+GLD1V+GLD2V+GLD3V) * arr(TREP10V*(REMPLAV)/TTSBV)
        + (1-positif(REMPLAV+CODDAJ+CODEAJ+GLD1V+GLD2V+GLD3V)) * max(0,TREP10V-TABTS1AJ-TABTS1AC-TABTS1AP-TABTS3VJ-TABTS1TT-TABTSRAJ);
TABTSV = TABTS1AJ + TABTS1AC +TABTS1AP +TABTS3VJ +TABTS1TT +TABTSRAJ+TABTSRAP;
TABTS1BJ=positif(SALEXTC+ALLOC+BPCOSAC+GLDGRATC+CARTSC+REMPLAC+CODDBJ+CODEBJ+GLD1C+GLD2C+GLD3C) * arr(TREP10C*(TSHALLOC)/TTSBC)
        + (1-positif(SALEXTC+ALLOC+BPCOSAC+GLDGRATC+CARTSC+REMPLAC+CODDBJ+CODEBJ+GLD1C+GLD2C+GLD3C)) * TREP10C;
TABTS1BC=positif(ALLOC+BPCOSAC+GLDGRATC+CARTSC+REMPLAC+CODDBJ+CODEBJ+GLD1C+GLD2C+GLD3C) * arr(TREP10C*(max(0,SALEXTC-COD1BD))/TTSBC)
        + (1-positif(ALLOC+BPCOSAC+GLDGRATC+CARTSC+REMPLAC+CODDBJ+CODEBJ+GLD1C+GLD2C+GLD3C)) * max(0,TREP10C-TABTS1BJ);
TABTS1BP=positif(BPCOSAC+GLDGRATC+CARTSC+REMPLAC+CODDBJ+CODEBJ+GLD1C+GLD2C+GLD3C) * arr(TREP10C*(ALLOC)/TTSBC)
        + (1-positif(BPCOSAC+GLDGRATC+CARTSC+REMPLAC+CODDBJ+CODEBJ+GLD1C+GLD2C+GLD3C)) * max(0,TREP10C-TABTS1BJ-TABTS1BC);
TABTS3VK=positif(GLDGRATC+CARTSC+REMPLAC+CODDBJ+CODEBJ+GLD1C+GLD2C+GLD3C) * arr(TREP10C*(BPCOSAC)/TTSBC)
        + (1-positif(GLDGRATC+CARTSC+REMPLAC+CODDBJ+CODEBJ+GLD1C+GLD2C+GLD3C)) * max(0,TREP10C-TABTS1BJ-TABTS1BC-TABTS1BP);
TABTS1UT=positif(CARTSC+REMPLAC+CODDBJ+CODEBJ+GLD1C+GLD2C+GLD3C) * arr(TREP10C*(GLDGRATC)/TTSBC)
        + (1-positif(CARTSC+REMPLAC+CODDBJ+CODEBJ+GLD1C+GLD2C+GLD3C)) * max(0,TREP10C-TABTS1BJ-TABTS1BC-TABTS1BP-TABTS3VK);
TABTSRBJ=positif(REMPLAC+CODDBJ+CODEBJ+GLD1C+GLD2C+GLD3C) * arr(TREP10C*(CARTSC)/TTSBC)
        + (1-positif(REMPLAC+CODDBJ+CODEBJ+GLD1C+GLD2C+GLD3C)) * max(0,TREP10C-TABTS1BJ-TABTS1BC-TABTS1BP-TABTS3VK-TABTS1UT);
TABTSRBP=positif(CODDBJ+CODEBJ+GLD1C+GLD2C+GLD3C) * arr(TREP10C*(REMPLAC)/TTSBC)
        + (1-positif(CODDBJ+CODEBJ+GLD1C+GLD2C+GLD3C)) * max(0,TREP10C-TABTS1BJ-TABTS1BC-TABTS1BP-TABTS3VK-TABTS1UT-TABTSRBJ);
TABTSC = TABTS1BJ + TABTS1BC +TABTS1BP +TABTS3VK +TABTS1UT +TABTSRBJ+TABTSRBP;
regle 99992500:
application : iliad , batch  ;
TABDOMDAJ = positif(CODDAJ) *
           (positif(CODEAJ+GLD1V+GLD2V+GLD3V) * arr(TREP10V*CODDAJ/TTSBV)
           + (1-positif(CODEAJ+GLD1V+GLD2V+GLD3V)) * max(0,TREP10V-TABTSV))+0;
TABDOMEAJ = positif(CODEAJ) *
           (positif(GLD1V+GLD2V+GLD3V) * arr(TREP10V*CODEAJ/TTSBV)
           + (1-positif(GLD1V+GLD2V+GLD3V)) * max(0,TREP10V-TABTSV-TABDOMDAJ))+0;
TABDOMDBJ = positif(CODDBJ) *
           (positif(CODEBJ+GLD1C+GLD2C+GLD3C) * arr(TREP10C*CODDBJ/TTSBC)
           + (1-positif(CODEBJ+GLD1C+GLD2C+GLD3C)) * max(0,TREP10C-TABTSC))+0;
TABDOMEBJ = positif(CODEBJ) *
           (positif(GLD1C+GLD2C+GLD3C) * arr(TREP10C*CODEBJ/TTSBC)
           + (1-positif(GLD1C+GLD2C+GLD3C)) * max(0,TREP10C-TABTSC-TABDOMDBJ))+0;
TABGL1V = positif(GLD1V) *
           (positif(GLD2V+GLD3V) * arr(TREP10V*GLD1V/TTSBV)
           + (1-positif(GLD2V+GLD3V)) * max(0,TREP10V-TABTSV-TABDOMDAJ-TABDOMEAJ))+0;
TABGL1C = positif(GLD1C) *
           (positif(GLD2C+GLD3C) * arr(TREP10C*GLD1C/TTSBC)
           + (1-positif(GLD2C+GLD3C)) * max(0,TREP10C-TABTSC-TABDOMDBJ-TABDOMEBJ))+0;
TABGL2V = positif(GLD2V) *
           (positif(GLD3V) * arr(TREP10V*GLD2V/TTSBV)
           + (1-positif(GLD3V)) * max(0,TREP10V-TABTSV-TABDOMDAJ-TABDOMEAJ-TABGL1V))+0;
TABGL2C = positif(GLD2C) *
           (positif(GLD3C) * arr(TREP10C*GLD2C/TTSBC)
           + (1-positif(GLD3C)) * max(0,TREP10C-TABTSC-TABDOMDBJ-TABDOMEBJ-TABGL1C))+0;
TABGL3V = positif(GLD3V) * max(0,TREP10V-TABTSV-TABDOMDAJ-TABDOMEAJ-TABGL1V-TABGL2V)+0;
TABGL3C = positif(GLD3C) * max(0,TREP10C-TABTSC-TABDOMDBJ-TABDOMEBJ-TABGL1C-TABGL2C)+0;
TABTS1CJ=arr(TREP101*(TSHALLO1)/TTSB1);
TABTS1CC=positif(ALLO1+CARTSP1+REMPLAP1) * arr(TREP101*(max(0,SALEXT1-COD1CD))/TTSB1)
        + (1-positif(ALLO1+CARTSP1+REMPLAP1)) * max(0,TREP101-TABTS1CJ);
TABTS1CP=positif(CARTSP1+REMPLAP1) * arr(TREP101*(ALLO1)/TTSB1)
        + (1-positif(CARTSP1+REMPLAP1)) * max(0,TREP101-TABTS1CJ-TABTS1CC);
TABTSRCJ=positif(REMPLAP1) * arr(TREP101*(CARTSP1)/TTSB1)
        + (1-positif(REMPLAP1)) * max(0,TREP101-TABTS1CJ-TABTS1CC-TABTS1CP);
TABTSRCP=max(0,TREP101 -TABTS1CJ  -TABTS1CC-TABTS1CP -TABTSRCJ);
TABTS1DJ=arr(TREP102*(TSHALLO2)/TTSB2);
TABTS1DC=positif(ALLO2+CARTSP2+REMPLAP2) * arr(TREP102*(max(0,SALEXT2-COD1DD))/TTSB2)
        + (1-positif(ALLO2+CARTSP2+REMPLAP2)) * max(0,TREP102-TABTS1DJ);
TABTS1DP=positif(CARTSP2+REMPLAP2) * arr(TREP102*(ALLO2)/TTSB2)
        + (1-positif(CARTSP2+REMPLAP2)) * max(0,TREP102-TABTS1DJ-TABTS1DC);
TABTSRDJ=positif(REMPLAP2) * arr(TREP102*(CARTSP2)/TTSB2)
        + (1-positif(REMPLAP2)) * max(0,TREP102-TABTS1DJ-TABTS1DC-TABTS1DP);
TABTSRDP=max(0,TREP102- TABTS1DJ  -TABTS1DC-TABTS1DP -TABTSRDJ);
TABTS1EJ=arr(TREP103*(TSHALLO3)/TTSB3);
TABTS1EC=positif(ALLO3+CARTSP3+REMPLAP3) * arr(TREP103*(max(0,SALEXT3-COD1ED))/TTSB3)
        + (1-positif(ALLO3+CARTSP3+REMPLAP3)) * max(0,TREP103-TABTS1EJ);
TABTS1EP=positif(CARTSP3+REMPLAP3) * arr(TREP103*(ALLO3)/TTSB3)
        + (1-positif(CARTSP3+REMPLAP3)) * max(0,TREP103-TABTS1EJ-TABTS1EC);
TABTSREJ=positif(REMPLAP3) * arr(TREP103*(CARTSP3)/TTSB3)
        + (1-positif(REMPLAP3)) * max(0,TREP103-TABTS1EJ-TABTS1EC-TABTS1EP);
TABTSREP=max(0,TREP103- TABTS1EJ  -TABTS1EC-TABTS1EP -TABTSREJ);
TABTS1FJ=arr(TREP104*(TSHALLO4)/TTSB4);
TABTS1FC=positif(ALLO4+CARTSP4+REMPLAP4) * arr(TREP104*(max(0,SALEXT4-COD1FD))/TTSB4)
        + (1-positif(ALLO4+CARTSP4+REMPLAP4)) * max(0,TREP104-TABTS1FJ);
TABTS1FP=positif(CARTSP4+REMPLAP4) * arr(TREP104*(ALLO4)/TTSB4)
        + (1-positif(CARTSP4+REMPLAP4)) * max(0,TREP104-TABTS1FJ-TABTS1FC);
TABTSRFJ=positif(REMPLAP4) * arr(TREP104*(CARTSP4)/TTSB4)
        + (1-positif(REMPLAP4)) * max(0,TREP104-TABTS1FJ-TABTS1FC-TABTS1FP);
TABTSRFP=max(0,TREP104 - TABTS1FJ  -TABTS1FC-TABTS1FP -TABTSRFJ);
regle 99992600:
application : iliad , batch  ;
TABGLTV = somme (x=1..3: TABGLxV)+TABDOMDAJ + TABDOMEAJ;
TABGLTC = somme (x=1..3: TABGLxC)+TABDOMDBJ + TABDOMEBJ;
regle 899999999:
application : iliad , batch  ;
TTSN1AJ = TSHALLOV - TABTS1AJ;
TTSN1AC = max(0,SALEXTV-COD1AD)- TABTS1AC;
TTSN1AP = ALLOV - TABTS1AP;
TTSN3VJ = BPCOSAV - TABTS3VJ;
TTSN1TT = GLDGRATV - TABTS1TT;
TTSNRAJ = (CARTSV - TABTSRAJ) ;
TTSNRAP = (REMPLAV - TABTSRAP);
TTSNDAJ = (CODDAJ - TABDOMDAJ);
TTSNEAJ = (CODEAJ - TABDOMEAJ);
TTSNGL1V = (GLD1V - TABGL1V);
TTSNGL2V = (GLD2V - TABGL2V);
TTSNGL3V = (GLD3V - TABGL3V);
TTSN1BJ = TSHALLOC - TABTS1BJ;
TTSN1BC = max(0,SALEXTC-COD1BD)- TABTS1BC;
TTSN1BP = ALLOC - TABTS1BP;
TTSN3VK = BPCOSAC - TABTS3VK;
TTSN1UT = GLDGRATC - TABTS1UT;
TTSNRBJ = (CARTSC - TABTSRBJ);
TTSNRBP = (REMPLAC - TABTSRBP);
TTSNDBJ = (CODDBJ - TABDOMDBJ);
TTSNEBJ = (CODEBJ - TABDOMEBJ);
TTSNGL1C = (GLD1C - TABGL1C);
TTSNGL2C = (GLD2C - TABGL2C);
TTSNGL3C = (GLD3C - TABGL3C);
TTSN1CJ = TSHALLO1 - TABTS1CJ;
TTSN1CC = max(0,SALEXT1-COD1CD)- TABTS1CC;
TTSN1CP = ALLO1 - TABTS1CP;
TTSNRCJ = (CARTSP1 - TABTSRCJ);
TTSNRCP = (REMPLAP1 - TABTSRCP);
TTSN1DJ = TSHALLO2 - TABTS1DJ;
TTSN1DC = max(0,SALEXT2-COD1DD)- TABTS1DC;
TTSN1DP = ALLO2 - TABTS1DP;
TTSNRDJ = (CARTSP2 - TABTSRDJ);
TTSNRDP = (REMPLAP2 - TABTSRDP);
TTSN1EJ = TSHALLO3 - TABTS1EJ;
TTSN1EC = max(0,SALEXT3-COD1ED)- TABTS1EC;
TTSN1EP = ALLO3 - TABTS1EP;
TTSNREJ = (CARTSP3 - TABTSREJ);
TTSNREP = (REMPLAP3 - TABTSREP);
TTSN1FJ = TSHALLO4 - TABTS1FJ;
TTSN1FC = max(0,SALEXT4-COD1FD)- TABTS1FC;
TTSN1FP = ALLO4 - TABTS1FP;
TTSNRFJ = (CARTSP4 - TABTSRFJ);
TTSNRFP = (REMPLAP4 - TABTSRFP);

CUMSALEXTEF = TTSN1AC + TTSN1BC + TTSN1CC + TTSN1DC + TTSN1EC + TTSN1FC ;
regle 99992700:
application : iliad , batch  ;
pour i = V,C,1,2,3,4:
TPLRi = min ( MIN_DEDPR , TEXPRi );
pour i = V,C,1,2,3,4:
TAPBi = max( TPLRi , (TEXPRi*TX_DEDPER/100));
pour i = V,C,1,2,3,4:
TIND_APBi = positif_ou_nul(TPLRi- (TEXPRi * TX_DEDPER/100));
TPL_PB = arr(PLAF_DEDPRFOYER -somme (i=V,C,1..4: TAPBi * TIND_APBi));
regle 99992800:
application : iliad , batch  ;
TABPRV = arr ( (1 - TIND_APBV) * 
             min(TAPBV,(TPL_PB * TAPBV / somme(x=V,C,1..4:TAPBx * (1 - TIND_APBx))))
           + TIND_APBV * TAPBV );
TABPRC = arr ( (1 - TIND_APBC) * 
             min(TAPBC,
                       positif(TEXPR1+TEXPR2+TEXPR3+TEXPR4)*(TPL_PB * TAPBC / somme(x=V,C,1..4:TAPBx * (1 - TIND_APBx)))
                     + (1-positif(TEXPR1+TEXPR2+TEXPR3+TEXPR4))* (max(0,TPL_PB - TABPRV)))
           + TIND_APBC * TAPBC );
TABPR1 = arr ( (1 - TIND_APB1) * 
             min(TAPB1,
                       positif(TEXPR2+TEXPR3+TEXPR4)*(TPL_PB * TAPB1 / somme(x=V,C,1..4:TAPBx * (1 - TIND_APBx)))
                     + (1-positif(TEXPR2+TEXPR3+TEXPR4))* (max(0,TPL_PB - TABPRV-TABPRC)))
           + TIND_APB1 * TAPB1 );
TABPR2 = arr ( (1 - TIND_APB2) * 
             min(TAPB2,
                       positif(TEXPR3+TEXPR4)*(TPL_PB * TAPB2 / somme(x=V,C,1..4:TAPBx * (1 - TIND_APBx)))
                     + (1-positif(TEXPR3+TEXPR4))* (max(0,TPL_PB - TABPRV-TABPRC-TABPR1)))
           + TIND_APB2 * TAPB2 );
TABPR3 = arr ( (1 - TIND_APB3) * 
             min(TAPB3,
                       positif(TEXPR4)*(TPL_PB * TAPB3 / somme(x=V,C,1..4:TAPBx * (1 - TIND_APBx)))
                     + (1-positif(TEXPR4))* (max(0,TPL_PB - TABPRV-TABPRC-TABPR1-TABPR2)))
           + TIND_APB3 * TAPB3 );
TABPR4 = arr ( (1 - TIND_APB4) * 
             min(TAPB4,(max(0,TPL_PB -TABPRV-TABPRC-TABPR1-TABPR2-TABPR3)))
           + TIND_APB4 * TAPB4 );
regle 99992900:
application : iliad , batch  ;
TAPRV  =  TIND_APBV * TABPRV 
       + (1-TIND_APBV)* min ( TABPRV , TPL_PB); 
TAPRC  =  TIND_APBC * TABPRC 
       + (1-TIND_APBC)* min ( TABPRC , TPL_PB - (1-TIND_APBV)*TAPRV ); 
TAPR1  =  TIND_APB1 * TABPR1 
       + (1-TIND_APB1)* min ( TABPR1 , TPL_PB - (1-TIND_APBV)*TAPRV 
			- (1-TIND_APBC)*TAPRC);
TAPR2  =  TIND_APB2 * TABPR2
       + (1-TIND_APB2)* min ( TABPR2 , TPL_PB - (1-TIND_APBV)*TAPRV 
                       - (1-TIND_APBC)*TAPRC - (1-TIND_APB1)*TAPR1 ); 
TAPR3  =  TIND_APB3 * TABPR3
       + (1-TIND_APB3)* min ( TABPR3 , TPL_PB - (1-TIND_APBV)*TAPRV 
                       - (1-TIND_APBC)*TAPRC - (1-TIND_APB1)*TAPR1  
                       - (1-TIND_APB2)*TAPR2 ); 
TAPR4  =  TIND_APB4 * TABPR4 
       + (1-TIND_APB4)* min ( TABPR4 , TPL_PB - (1-TIND_APBV)*TAPRV 
                       - (1-TIND_APBC)*TAPRC - (1-TIND_APB1)*TAPR1  
                       - (1-TIND_APB2)*TAPR2 - (1-TIND_APB3)*TAPR3 ); 
regle 99992110:
application : iliad , batch  ;
pour i = V,C,1,2,3,4:
TPRNNi = TEXPRi - TAPRi;
regle 99992120:
application : iliad , batch  ;
TTSNTV =  TTSN1AJ+TTSN1AC+TTSN1AP+TTSN3VJ+TTSN1TT+TTSNRAJ+TTSNRAP
        +TTSNDAJ+TTSNEAJ+TTSNGL1V+TTSNGL2V+TTSNGL3V ;
TTSNTC = TTSN1BJ+TTSN1BC+TTSN1BP+TTSN3VK+TTSN1UT+TTSNRBJ+TTSNRBP
       +TTSNDBJ+TTSNEBJ+TTSNGL1C+TTSNGL2C+TTSNGL3C ;
TTSNT1 =  TTSN1CJ +TTSN1CC+ TTSN1CP + TTSNRCJ + TTSNRCP;
TTSNT2 =  TTSN1DJ +TTSN1DC+ TTSN1DP + TTSNRDJ + TTSNRDP;
TTSNT3 =  TTSN1EJ+TTSN1EC+ TTSN1EP+ TTSNREJ+ TTSNREP ;
TTSNT4 =  TTSN1FJ+TTSN1FC+ TTSN1FP+ TTSNRFJ+ TTSNRFP ;
regle 99992130:
application : iliad , batch  ;
pour i =V,C,1,2,3,4:
TTSNi = positif (-TTSNTi) * min (0 , TTSNTi + TPRNNi)
     + positif_ou_nul (TTSNTi) * TTSNTi;
pour i =V,C,1,2,3,4:
TPRNi = positif (-TTSNTi) * positif (TTSNTi + TPRNNi) * (TTSNTi + TPRNNi)
       + positif_ou_nul (TTSNTi) * TPRNNi;

regle 99992210:
application : iliad , batch  ;
pour i = V,C;x=1..3:
TGLNAVxi = max (GLDxi - TABGLxi,0);
TGLDOMAVDAJV = max (CODDAJ - TABDOMDAJ,0);
TGLDOMAVEAJV = max (CODEAJ - TABDOMEAJ,0);
TGLDOMAVDBJC = max (CODDBJ - TABDOMDBJ,0);
TGLDOMAVEBJC = max (CODEBJ - TABDOMEBJ,0);
TGLN1V = max (GLD1V - TABGL1V,0);
TGLN2V = max (GLD2V - TABGL2V,0);
TGLN3V = max (GLD3V - TABGL3V,0);
TGLN4V = max(CODDAJ - TABDOMDAJ,0)+max(CODEAJ - TABDOMEAJ,0);
TGLN1C = max (GLD1C - TABGL1C,0);
TGLN2C = max (GLD2C - TABGL2C,0);
TGLN3C = max (GLD3C - TABGL3C,0);
TGLN4C = max(CODDBJ - TABDOMDBJ,0)+max(CODEBJ - TABDOMEBJ,0);
regle 99992230:
application : iliad , batch  ;
TTSV = TTSNV - somme(x=1..3: max(0,GLDxV - TABGLxV))-max(CODDAJ - TABDOMDAJ,0)-max(CODEAJ - TABDOMEAJ,0);
TTSC = TTSNC - somme(x=1..3: max(0,GLDxC - TABGLxC))-max(CODDBJ - TABDOMDBJ,0)-max(CODEBJ - TABDOMEBJ,0);
pour i=1..4:
TTSi = TTSNi;
pour i=V,C:
TTPRi = TTSNi + TPRNi - somme(x=1..3: TGLNxi);
pour i=1..4:
TTPRi = TTSNi + TPRNi;
pour i = V,C :
TTSNNi =  positif(TTSi) *arr(TTSi *(TTSBNi + BPCOSAi + GLDGRATi)/TEXTSi )
          + (1 -positif(TTSi)) * TTSi ;
pour i = 1..4 :
TTSNNi = (positif(TTSi) * arr(TTSi * TTSBNi /TEXTSi )
            + (1 -positif(TTSi)) * TTSi)  ;
pour i = V,C :
TTSNN2i = ( positif(TTSi)
                * ( positif(CARTSi+REMPLAi) 
                          * arr(TTSi * T2TSNi / TEXTSi )
                    + (1 -positif(CARTSi+REMPLAi)) 
                          * (TTSi - TTSNNi))) ;
pour i = 1..4 :
TTSNN2i = ( positif(TTSi)
               * ( positif(CARTSPi+REMPLAPi) 
                          * arr(TTSi * T2TSNi /TEXTSi )
                    + (1 -positif(CARTSPi+REMPLAPi)) 
                          * (TTSi - TTSNNi))) ;
pour i = V,C :
TTSNN2TSi = ( positif(TTSi)
                * ( positif(REMPLAi) 
                          * arr(TTSi * CARTSi / TEXTSi )
                    + (1 -positif(REMPLAi)) 
                          * (TTSi - TTSNNi))) ;
pour i = 1..4 :
TTSNN2TSi = ( positif(TTSi)
               * ( positif(REMPLAPi) 
                          * arr(TTSi * CARTSPi /TEXTSi )
                    + (1 -positif(REMPLAPi)) 
                          * (TTSi - TTSNNi))) ;
pour i = V,C :
TTSNN2REMPi = (positif(TTSi) * (TTSi - TTSNNi-TTSNN2TSi)) ;
pour i = 1..4 :
TTSNN2REMPi = (positif(TTSi) * (TTSi - TTSNNi-TTSNN2TSi)) ;

TFRDVREP =  positif(ART1731BIS) *  max(0,FRNV - TFRDV) * null(TIND_10V);
TFRDCREP =  positif(ART1731BIS) *  max(0,FRNC - TFRDC) * null(TIND_10C);
TFRD1REP =  positif(ART1731BIS) *  max(0,(max(0,(FRN1-TFRD1)) - TPRN1 * (1-positif(FRN1-TFRD1)))* null(TIND_101)
                                       +(max(0,(FRN2-TFRD2)) - TPRN2 * (1-positif(FRN2-TFRD2)) )* null(TIND_102)
                                       +(max(0,(FRN3-TFRD3)) - TPRN3 * (1-positif(FRN3-TFRD3)))* null(TIND_103)
                                       +(max(0,(FRN4-TFRD4)) - TPRN4 * (1-positif(FRN4-TFRD4)))* null(TIND_104) )
                                     ;
TFRDREPTOT =   positif(ART1731BIS) *  (TFRDVREP + TFRDCREP + TFRD1REP);
regle 99992240:
application : iliad , batch  ;
TPRRV = arr(TPRNV * PRBV / TEXPRV) +  arr(TPRNV * COD1AH / TEXPRV);
TPRRC = arr(TPRNC * PRBC / TEXPRC) +  arr(TPRNC * COD1BH / TEXPRC);
TPRR1 = arr(TPRN1 * PRB1 / TEXPR1) +  arr(TPRN1 * COD1CH / TEXPR1);
TPRR2 = arr(TPRN2 * PRB2 / TEXPR2) +  arr(TPRN2 * COD1DH / TEXPR2);
TPRR3 = arr(TPRN3 * PRB3 / TEXPR3) +  arr(TPRN3 * COD1EH / TEXPR3);
TPRR4 = arr(TPRN4 * PRB4 / TEXPR4) +  arr(TPRN4 * COD1FH / TEXPR4);
TPRR2V = positif(PEBFV+PENSALV+CODRAZ) * arr(TPRNV * CARPEV / TEXPRV)
           +  (1 -positif(PEBFV+PENSALV+CODRAZ)) * (TPRNV -TPRRV)   ;
TPRR2C = positif(PEBFC+PENSALC+CODRBZ) * arr(TPRNC * CARPEC / TEXPRC)
           +  (1 -positif(PEBFC+PENSALC+CODRBZ)) * (TPRNC -TPRRC)   ;
TPRR21 = positif(PEBF1+PENSALP1+CODRCZ) * arr(TPRN1 * CARPEP1 / TEXPR1 )
           +  (1 -positif(PEBF1+PENSALP1+CODRCZ)) * (TPRN1 -TPRR1);
TPRR22 = positif(PEBF2+PENSALP2+CODRDZ) * arr(TPRN2 * CARPEP2 / TEXPR2 )
           +  (1 -positif(PEBF2+PENSALP2+CODRDZ)) * (TPRN2 -TPRR2);
TPRR23 = positif(PEBF3+PENSALP3+CODREZ) * arr(TPRN3 * CARPEP3 / TEXPR3 )
           +  (1 -positif(PEBF3+PENSALP3+CODREZ)) * (TPRN3 -TPRR3);
TPRR24 = positif(PEBF4+PENSALP4+CODRFZ) * arr(TPRN4 * CARPEP4 / TEXPR4 )
           +  (1 -positif(PEBF4+PENSALP4+CODRFZ)) * (TPRN4 -TPRR4);
TPRR2ZV = positif(PEBFV+PENSALV) * arr(TPRNV * CODRAZ / TEXPRV)
           +  (1 -positif(PEBFV+PENSALV)) * (TPRNV -TPRRV-TPRR2V)   ;
TPRR2ZC = positif(PEBFC+PENSALC) * arr(TPRNC * CODRBZ / TEXPRC)
           +  (1 -positif(PEBFC+PENSALC)) * (TPRNC -TPRRC-TPRR2C)   ;
TPRR2Z1 = positif(PEBF1+PENSALP1) * arr(TPRN1 * CODRCZ / TEXPR1)
           +  (1 -positif(PEBF1+PENSALP1)) * (TPRN1 -TPRR1-TPRR21)   ;
TPRR2Z2 = positif(PEBF2+PENSALP2) * arr(TPRN2 * CODRDZ / TEXPR2)
           +  (1 -positif(PEBF2+PENSALP2)) * (TPRN2 -TPRR2-TPRR22)   ;
TPRR2Z3 = positif(PEBF3+PENSALP3) * arr(TPRN3 * CODREZ / TEXPR3)
           +  (1 -positif(PEBF3+PENSALP3)) * (TPRN3 -TPRR3-TPRR23)   ;
TPRR2Z4 = positif(PEBF4+PENSALP4) * arr(TPRN4 * CODRFZ / TEXPR4 )
           +  (1 -positif(PEBF4+PENSALP4)) * (TPRN4 -TPRR4-TPRR24);
pour i = V,C:
TPENFi =  positif(PENSALi) * arr(TPRNi * PEBFi / TEXPRi)
       + (1 - positif(PENSALi)) * max(0,(TPRNi -TPRRi -TPRR2i-TPRR2Zi));
pour i = 1..4:
TPENFi =  positif(PENSALPi) * arr(TPRNi * PEBFi / TEXPRi)
        + (1- positif(PENSALPi)) * (TPRNi -TPRRi -TPRR2i-TPRR2Zi);
pour i = V,C:
TPENALIMi = positif(TEXPRi) * (TPRNi -TPRRi -TPRR2i -TPRR2Zi- TPENFi) ;
pour i = 1..4:
TPENALIMi = positif(TEXPRi) * (TPRNi -TPRRi -TPRR2i -TPRR2Zi- TPENFi) ;
CUMPENEXTEF = somme (i = V,C,1..4 : TPRRi) ;
regle 99992310:
application : iliad , batch  ;
TTSPRT = (TTSNNV + TPRRV 
        + TTSNNC + TPRRC
        + TTSNN1 + TPRR1
        + TTSNN2 + TPRR2
        + TTSNN3 + TPRR3
        + TTSNN4 + TPRR4);
TTSPRT1731 = max(0,TTSPRV) + max(0,TTSPRC) + max(0,TTSPR1) + max(0,TTSPR2)+ max(0,TTSPR3)+ max(0,TTSPR4);
TTSPR = TTSPRT * (1-ART1731BIS) + TTSPRT1731 * ART1731BIS + RVTOT;
regle 99992320:
application : iliad , batch  ;
pour i=V,C,1..4:
TTSPRi = (TTSNNi + TPRRi) * (1-PREM8_11) + max(0,TTSNNi + TPRRi) * PREM8_11;
pour i=V,C,1..4:
TTSPRDi = min(0,TTSNNi + TPRRi)* ART1731BIS ;
TTSPRP = somme(i=1..4:TTSPRi) ;
TTSPRDP = somme(i=1..4:TTSPRDi) ;
pour i=V,C,1..4:
TFRNRETENUi = max(0,TFRNRETi + TSPRDi);
regle 99991030:
application : iliad , batch  ;                          
TEFFBENEFTOT =  TSPENET + TXSPENET + TMIBNETVF + TMIBNETNPVF + TMIBNETPF + TMIBNETNPPF 
			      * (1 - positif((VARIPTEFP * positif(ART1731BIS) + IPTEFP * (1 - ART1731BIS)) 
					      + (VARIPTEFN * positif(ART1731BIS) + IPTEFN * (1 - ART1731BIS)) + IPMOND));
regle 99991040:
application : iliad , batch  ;
TBICPF = TMIBNETVF + TMIBNETPF + MIB_NETCT  ;
TBICNPF =max(0,somme(i=V,C,P:BINTAi+BINHTAi)+TMIBNETNPVF + TMIBNETNPPF +MIB_NETNPCT - DEFNP);
TBNN =  somme(i=V,C,P:TSPENETPi) + TXSPENET + max(0,somme(i=V,C,P:TSPENETNPi) 
				 + NOCEPIMP-(min(DABNCNP6,DABNCNP61731+0) * positif(ART1731BIS) + DABNCNP6 * (1 - ART1731BIS))
			 -(min(DABNCNP5,DABNCNP51731+0) * positif(ART1731BIS) + DABNCNP5 * (1 - ART1731BIS))
				 -(min(DABNCNP4,DABNCNP41731+0) * positif(ART1731BIS) + DABNCNP4 * (1 - ART1731BIS))
				 -(min(DABNCNP3,DABNCNP31731+0) * positif(ART1731BIS) + DABNCNP3 * (1 - ART1731BIS))
				 -(min(DABNCNP2,DABNCNP21731+0) * positif(ART1731BIS) + DABNCNP2 * (1 - ART1731BIS))
				 -(min(DABNCNP1,DABNCNP11731+0) * positif(ART1731BIS) + DABNCNP1 * (1 - ART1731BIS))) + SPENETCT + SPENETNPCT ;
regle 99991055:
application :  iliad , batch  ;                          
TEFFREV =   INDTEFF *
                  (
                  (TBICPF + TBICNPF + TBNN
                  + BIHTAV + BIHTAC + BIHTAP
                  + BIPTAV + BIPTAC + BIPTAP
                  + ESFP + TTSPR + RCM + PLOCNETF + NPLOCNETF
                  + RFNTEO * V_INDTEO + RRFI * (1-V_INDTEO)
                  + BPVRCM + PVTAXSB + PVIMPOS * null(1-FLAG_EXIT) + COD3VE + (PVIMPOS+PVSURSI) * null(2 -FLAG_EXIT)
                  + max(BANOR,0) + REB +
                  min(BANOR,0) *
                  positif(SEUIL_IMPDEFBA + 1
                  -SHBA- (REVTP-BA1)
                  - REVQTOTQHT))
                  + R1649
                  );
TEFFREVRFR =   INDTEFF *
                  (
                  (TBICPF + TBICNPF + TBNN
                  + BIHTAV + BIHTAC + BIHTAP
                  + BIPTAV + BIPTAC + BIPTAP
                  + ESFP + TTSPR + RCM + PLOCNETF + NPLOCNETF
                  + RFNTEO * V_INDTEO + RRFI * (1-V_INDTEO)
                  + PVBAR
                  + max(BANOR,0) + REB +
                  min(BANOR,0) *
                  positif(SEUIL_IMPDEFBA + 1
                  -SHBA- (REVTP-BA1)
                  - REVQTOTQHT))
                  + R1649
                  );
RBGTEF = (1 - positif(TEFFREV  +PREREV- DAR)) * min( 0 , TEFFREV  +PREREV- DAR + TOTALQUO )
                  + positif(TEFFREV+PREREV - DAR) * (TEFFREV +PREREV - DAR);
RBGTEFRFR = (1 - positif(TEFFREVRFR  +PREREV- DAR)) * min( 0 , TEFFREVRFR  +PREREV- DAR + TOTALQUO )
                  + positif(TEFFREVRFR+PREREV - DAR) * (TEFFREVRFR +PREREV - DAR);
RPALETEF = max(0,min(somme(i=1..4:min(NCHENFi,LIM_PENSALENF)+min(arr(CHENFi*MAJREV),LIM_PENSALENF)),
                                    RBGTEF-DDCSG+TOTALQUO-SDD)) *(1-V_CNR);
RPALETEFRFR = max(0,min(somme(i=1..4:min(NCHENFi,LIM_PENSALENF)+min(arr(CHENFi*MAJREV),LIM_PENSALENF)),
                                    RBGTEFRFR-DDCSG+TOTALQUO-SDD)) *(1-V_CNR);
RPALPTEF = max( min(TOTPA,RBGTEF - RPALETEF - DDCSG + TOTALQUO - SDD) , 0 ) * (1 -V_CNR);
RPALPTEFRFR = max( min(TOTPA,RBGTEFRFR - RPALETEFRFR - DDCSG + TOTALQUO - SDD) , 0 ) * (1 -V_CNR);
RFACCTEF = max( min(DFA,RBGTEF - RPALETEF - RPALPTEF  - DDCSG + TOTALQUO - SDD) , 0);
RFACCTEFRFR = max( min(DFA,RBGTEFRFR - RPALETEFRFR - RPALPTEFRFR  - DDCSG + TOTALQUO - SDD) , 0);
RDDIVTEF = max( min(DEDIV * (1 - V_CNR),RBGTEF - RPALETEF - RPALPTEF - RFACCTEF - DDCSG + TOTALQUO - SDD ) , 0 );
RDDIVTEFRFR = max( min(DEDIV * (1 - V_CNR),RBGTEFRFR - RPALETEFRFR - RPALPTEFRFR - RFACCTEFRFR - DDCSG + TOTALQUO - SDD ) , 0 );
APERPVTEF = (1 - V_CNR) * max(min(RPERPV,RBGTEF - RPALETEF - RPALPTEF - RFACCTEF
                                    - RDDIVTEF - DDCSG + TOTALQUO -SDD), 0);
APERPVTEFRFR = (1 - V_CNR) * max(min(RPERPV,RBGTEFRFR - RPALETEFRFR - RPALPTEFRFR - RFACCTEFRFR
                                    - RDDIVTEFRFR - DDCSG + TOTALQUO -SDD), 0);
APERPCTEF = (1 - V_CNR) * max(min(RPERPC,RBGTEF - RPALETEF - RPALPTEF  - RFACCTEF
                                    - RDDIVTEF - DDCSG + TOTALQUO -SDD - APERPVTEF), 0);
APERPCTEFRFR = (1 - V_CNR) * max(min(RPERPC,RBGTEFRFR - RPALETEFRFR - RPALPTEFRFR  - RFACCTEFRFR
                                    - RDDIVTEFRFR - DDCSG + TOTALQUO -SDD - APERPVTEFRFR), 0);
APERPPTEF = (1 - V_CNR) * max(min(RPERPP,RBGTEF - RPALETEF - RPALPTEF  - RFACCTEF
                                    - RDDIVTEF - DDCSG + TOTALQUO -SDD - APERPVTEF - APERPCTEF), 0);
APERPPTEFRFR = (1 - V_CNR) * max(min(RPERPP,RBGTEFRFR - RPALETEFRFR - RPALPTEFRFR  - RFACCTEFRFR
                                    - RDDIVTEFRFR - DDCSG + TOTALQUO -SDD - APERPVTEFRFR - APERPCTEFRFR), 0);
RRBGTEF = (TEFFREV - DAR ) *(1-positif(RE168+TAX1649)) + positif(RE168+TAX1649) * (RE168+TAX1649);
RRBGTEFRFR = (TEFFREVRFR - DAR ) *(1-positif(RE168+TAX1649)) + positif(RE168+TAX1649) * (RE168+TAX1649);
NUREPARTEF = min(NUPROPT , max(0,min(PLAF_NUREPAR, RRBGTEF - RPALETEF - RPALPTEF - RFACCTEF
                                    - RDDIVTEF - APERPVTEF - APERPCTEF - APERPPTEF - DDCSG + TOTALQUO - SDD)))
                                    * (1 - V_CNR) ;
NUREPARTEFRFR = min(NUPROPT , max(0,min(PLAF_NUREPAR, RRBGTEFRFR - RPALETEFRFR - RPALPTEFRFR - RFACCTEFRFR
                                    - RDDIVTEFRFR - APERPVTEFRFR - APERPCTEFRFR - APERPPTEFRFR - DDCSG + TOTALQUO - SDD)))
                                    * (1 - V_CNR) ;
RBG2TEF = RBGTEF - max(0,min(RBGTEF , DDCSG));
RBG2TEFRFR = RBGTEFRFR - max(0,min(RBGTEFRFR , DDCSG));
RBLTEF =  ( RBG2TEF - max(0,min( RBG2TEF , ( DPA + DFA + DEDIV + APERPVTEF + APERPCTEF + APERPPTEF + NUREPARTEF ))) * ( 1 - V_CNR )
                                    - min( RBG2TEF , V_8ZT) * V_CR2
                                    ) * (1 - positif(RE168+TAX1649));
RBLTEFRFR =  ( RBG2TEFRFR - max(0,min( RBG2TEFRFR , ( DPA + DFA + DEDIV + APERPVTEFRFR + APERPCTEFRFR + APERPPTEFRFR + NUREPARTEFRFR ))) * ( 1 - V_CNR )
                                    - min( RBG2TEFRFR , V_8ZT) * V_CR2
                                    ) * (1 - positif(RE168+TAX1649));
RNGTEF = (     null(V_REGCO - 4)
                  * null(V_CNR   - 1)
                  * null(V_CNR2  - 1)
                  * null(V_CR2   - 1)
                  * IPVLOC
                  )
                  +
                  (1 -   null(V_REGCO - 4)
                  * null(V_CNR   - 1)
                  * null(V_CNR2  - 1)
                  * null(V_CR2   - 1)
                  )
                  * RBLTEF ;
RNGTEFRFR = (     null(V_REGCO - 4)
                  * null(V_CNR   - 1)
                  * null(V_CNR2  - 1)
                  * null(V_CR2   - 1)
                  * IPVLOC
                  )
                  +
                  (1 -   null(V_REGCO - 4)
                  * null(V_CNR   - 1)
                  * null(V_CNR2  - 1)
                  * null(V_CR2   - 1)
                  )
                  * RBLTEFRFR ;
NABTEF =   min( max( LIM_ABTRNGDBL + 1  - (RNGTEF+ TOTALQUO- SDD- SDC), 0 ), 1 )
                  + min( max( LIM_ABTRNGSIMP + 1 - (RNGTEF+ TOTALQUO- SDD- SDC), 0 ), 1 );
NABTEFRFR =   min( max( LIM_ABTRNGDBL + 1  - (RNGTEFRFR+ TOTALQUO- SDD- SDC), 0 ), 1 )
                  + min( max( LIM_ABTRNGSIMP + 1 - (RNGTEFRFR+ TOTALQUO- SDD- SDC), 0 ), 1 );
ABTPATEF = NDA * NABTEF * ABAT_UNVIEUX * (1-V_CNR);
ABTPATEFRFR = NDA * NABTEFRFR * ABAT_UNVIEUX * (1-V_CNR);
TEFFREVINTER =    INDTEFF *
                  (
                  (TBICPF + TBICNPF + TBNN
                  + BIHTAV + BIHTAC + BIHTAP
                  + BIPTAV + BIPTAC + BIPTAP 
                  + ESFP + TTSPR + RCM + PLOCNETF + NPLOCNETF 
                  + RFNTEO * V_INDTEO + RRFI * (1-V_INDTEO)
                  + PVBAR
                  + max(BANOR,0) + REB +
                  min(BANOR,0) *
                  positif(SEUIL_IMPDEFBA + 1
                  -SHBA- (REVTP-BA1)
                  - REVQTOTQHT))
                  + R1649 - DAR
                  );
TEFFREVTOT =    INDTEFF *
                  (
                  (TBICPF + TBICNPF + TBNN
                  + BIHTAV + BIHTAC + BIHTAP
                  + BIPTAV + BIPTAC + BIPTAP 
                  + ESFP + TTSPR + RCM + PLOCNETF + NPLOCNETF 
                  + RFNTEO * V_INDTEO + RRFI * (1-V_INDTEO)
                  + BPVRCM + PVTAXSB + PVIMPOS * null(1-FLAG_EXIT) + COD3VE + (PVIMPOS+PVSURSI) * null(2 -FLAG_EXIT)
                  + max(BANOR,0) + REB +
                  min(BANOR,0) *
                  positif(SEUIL_IMPDEFBA + 1
                  -SHBA- (REVTP-BA1)
                  - REVQTOTQHT))
                  + R1649 - DAR - max(0,min(TEFFREVINTER,DPA + DFA + DEDIV + APERPVTEF + APERPCTEF + APERPPTEF + NUREPARTEF + ABTPATEF + ABTMA+DDCSG))
                  )
                  ;
TEFFREVTOTRFR =    INDTEFF *
                  (
                  (TBICPF + TBICNPF + TBNN
                  + BIHTAV + BIHTAC + BIHTAP
                  + BIPTAV + BIPTAC + BIPTAP 
                  + ESFP + TTSPR + RCM + PLOCNETF + NPLOCNETF
                  + RFNTEO * V_INDTEO + RRFI * (1-V_INDTEO)
                  + PVBAR
                  + max(BANOR,0) + REB +
                  min(BANOR,0) *
                  positif(SEUIL_IMPDEFBA + 1
                  -SHBA- (REVTP-BA1)
                  - REVQTOTQHT))
                  + R1649 - DAR - max(0,min(TEFFREVINTER,DPA + DFA + DEDIV + APERPVTEFRFR + APERPCTEFRFR + APERPPTEFRFR + NUREPARTEFRFR + ABTPATEFRFR + ABTMA+DDCSG))
                  )
                  ;
TEFFREVTOTRFRHR =    INDTEFF *
                  (
                  (TBICPF + TBICNPF + TBNN
                  + BIHTAV + BIHTAC + BIHTAP
                  + BIPTAV + BIPTAC + BIPTAP 
                  + ESFP + TTSPR + RCM + PLOCNETF + NPLOCNETF
                  + RFNTEO * V_INDTEO + RRFI * (1-V_INDTEO)
                  + PVBARHR
                  + max(BANOR,0) + REB +
                  min(BANOR,0) *
                  positif(SEUIL_IMPDEFBA + 1
                  -SHBA- (REVTP-BA1)
                  - REVQTOTQHT))
                  + R1649 - DAR - max(0,min(TEFFREVINTER,DPA + DFA + DEDIV + APERPVTEFRFR + APERPCTEFRFR + APERPPTEFRFR + NUREPARTEFRFR + ABTPATEFRFR + ABTMA+DDCSG))
                  )
                  ;
