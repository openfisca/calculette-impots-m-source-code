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
regle 82000:
application : iliad , batch  ;
RCMRABD = arr(RCMABD * 40/100);

2RCMRABD = arr(REVACT * 40/100);

TRCMRABD = RCMRABD + 2RCMRABD;
RCMRTNC = arr(RCMTNC * 40/100);

2RCMRTNC = arr(REVPEA * 40/100);

TRCMRTNC = RCMRTNC + 2RCMRTNC;
RCMRNABD = RCMABD - RCMRABD;

2RCMRNABD = REVACT - 2RCMRABD;
RCMRNTNC = RCMTNC - RCMRTNC ;

2RCMRNTNC = REVPEA - 2RCMRTNC ;
REGPRIVM = arr(REGPRIV * MAJREV);

2REGPRIVM = arr(RESTUC * MAJREV);
TRCMABD = RCMABD + REVACT;
RCMAB = RCMRNABD + 2RCMRNABD ;
DRTNC = RCMTNC + REVPEA;
RTNC = RCMRNTNC + 2RCMRNTNC ;
RAVC = RCMAV + PROVIE;
RCMNAB = RCMHAD + DISQUO ;
RTCAR = RCMHAB + INTERE;
RCMPRIV = REGPRIV + RESTUC;
RCMPRIVM = REGPRIVM + 2REGPRIVM ;
RCMFRTEMP = min(RCMAB + RTNC + RAVC + RCMNAB + RTCAR + RCMPRIVM,RCMFR);
BRCMBIS = RCMAB + RTNC + RAVC + RCMNAB + RTCAR + RCMPRIVM;
regle 82001:
application : iliad , batch ;
FRAN = positif(RCMABD) * 
          (null(4-V_IND_TRAIT) * (
                                   positif(REVACT+RTCAR+RCMNAB) *
                                     arr((RCMFR*(1-positif(ART1731BIS))+min(RCMFR,BRCMTOT+0)*ART1731BIS) * RCMABD / max (1,TRCMABD + RTCAR+RCMNAB))
                                + (1 - positif(REVACT+RTCAR+RCMNAB)) *
                                    (RCMFR*(1-positif(ART1731BIS))+min(RCMFR,BRCMTOT+0)*ART1731BIS)
                                 )
         + null(5-V_IND_TRAIT) * (
                                   positif(REVACT+RTCAR+RCMNAB) *
                                     arr((RCMFR*(1-positif(ART1731BIS))+min(RCMFR,max(max(BRCMTOTP2,BRCMTOT_P),BRCMTOT1731+0))*ART1731BIS
                                         ) * RCMABD / max (1,TRCMABD + RTCAR+RCMNAB)
                                        )
                                  + (1 - positif(REVACT+RTCAR+RCMNAB)) *
                                      (RCMFR*(1-positif(ART1731BIS))+min(RCMFR,max(max(BRCMTOTP2,BRCMTOT_P),BRCMTOT1731+0))*ART1731BIS)
                                 )
          ) ;


2FRAN = positif(REVACT) * (
          null(4-V_IND_TRAIT) * (
                                  positif(RTCAR+RCMNAB) * 
                                    arr((RCMFR*(1-positif(ART1731BIS))+min(RCMFR,BRCMTOT+0)*ART1731BIS) * REVACT/ max (1,TRCMABD + RTCAR+RCMNAB) ) 
                               + (1 - positif(RTCAR+RCMNAB)) *
                                  ((RCMFR*(1-positif(ART1731BIS))+min(RCMFR,BRCMTOT+0)*ART1731BIS) - FRAN)
                                )
        + null(5-V_IND_TRAIT) * (
                                  positif(RTCAR+RCMNAB)* 
                                    arr((RCMFR*(1-positif(ART1731BIS))+min(RCMFR,max(max(BRCMTOTP2,BRCMTOT_P+0),BRCMTOT1731+0))*ART1731BIS
                                        ) * REVACT/ max (1,TRCMABD + RTCAR+RCMNAB) 
                                       ) 
                                + (1 - positif(RTCAR+RCMNAB)) *
                                    ((RCMFR*(1-positif(ART1731BIS))+min(RCMFR,max(max(BRCMTOTP2,BRCMTOT_P+0),BRCMTOT1731+0))*ART1731BIS) - FRAN)
                                )
               );

FRAR = positif(RCMHAB) * (
        null(4-V_IND_TRAIT) * (
            positif(INTERE+RCMNAB) * arr((RCMFR*(1-positif(ART1731BIS))+min(RCMFR,BRCMTOT+0)*ART1731BIS) * RCMHAB / max (1,TRCMABD + RTCAR+RCMNAB) ) +
                  (1 - positif(INTERE+RCMNAB))
                 * ((RCMFR*(1-positif(ART1731BIS))+min(RCMFR,BRCMTOT+0)*ART1731BIS) - FRAN - 2FRAN))
        + null(5-V_IND_TRAIT) * (
            positif(INTERE+RCMNAB) * arr((RCMFR*(1-positif(ART1731BIS))+min(RCMFR,max(max(BRCMTOTP2,BRCMTOT_P),BRCMTOT1731+0))*ART1731BIS) * RCMHAB / max (1,TRCMABD + RTCAR+RCMNAB) ) +
                     (1 - positif(INTERE+RCMNAB))
                          * ((RCMFR*(1-positif(ART1731BIS))+min(RCMFR,max(max(BRCMTOTP2,BRCMTOT_P),BRCMTOT1731+0))*ART1731BIS) - FRAN - 2FRAN)));
2FRAR = positif(INTERE) * (
        null(4-V_IND_TRAIT) * (
              positif(RCMNAB)* arr((RCMFR*(1-positif(ART1731BIS))+min(RCMFR,BRCMTOT+0)*ART1731BIS) * INTERE/ max (1,TRCMABD + RTCAR+RCMNAB) ) +
              (1 - positif(RCMNAB)) * ((RCMFR*(1-positif(ART1731BIS))+min(RCMFR,BRCMTOT+0)*ART1731BIS) -FRAN-2FRAN-FRAR))
        + null(5-V_IND_TRAIT) * (
              positif(RCMNAB)* arr((RCMFR*(1-positif(ART1731BIS))+min(RCMFR,max(max(BRCMTOTP2,BRCMTOT_P),BRCMTOT1731+0))*ART1731BIS) * INTERE/ max (1,TRCMABD + RTCAR+RCMNAB) ) +
              (1 - positif(RCMNAB)) * ((RCMFR*(1-positif(ART1731BIS))+min(RCMFR,max(max(BRCMTOTP2,BRCMTOT_P),BRCMTOT1731+0))*ART1731BIS) -FRAN-2FRAN-FRAR)));
FRAU = positif(RCMHAD) * (
        null(4-V_IND_TRAIT) * (
                   positif(DISQUO) * arr((RCMFR*(1-positif(ART1731BIS))+min(RCMFR,BRCMTOT+0)*ART1731BIS) * RCMHAD / max (1,TRCMABD + RTCAR + RCMNAB)) 
                + (1 - positif(DISQUO)) * ((RCMFR*(1-positif(ART1731BIS))+min(RCMFR,BRCMTOT+0)*ART1731BIS) - FRAN - 2FRAN - FRAR - 2FRAR))

      + null(5-V_IND_TRAIT) * (
          positif(DISQUO) * arr((RCMFR*(1-positif(ART1731BIS))+min(RCMFR,max(max(BRCMTOTP2,BRCMTOT_P),BRCMTOT1731+0))*ART1731BIS
                                ) * RCMHAD / max (1,TRCMABD + RTCAR + RCMNAB) 
                               ) 
        + (1 - positif(DISQUO)) * ((RCMFR*(1-positif(ART1731BIS))+min(RCMFR,max(max(BRCMTOTP2,BRCMTOT_P),BRCMTOT1731+0))*ART1731BIS) 
                                     - FRAN - 2FRAN - FRAR - 2FRAR
                                  )
                             )
                        );
2FRAU = null(4-V_IND_TRAIT) * (((RCMFR*(1-positif(ART1731BIS))+min(RCMFR,BRCMTOT+0)*ART1731BIS) - FRAN - 2FRAN - FRAR - 2FRAR - FRAU ) * positif(DISQUO))
        + null(5-V_IND_TRAIT) * (
               ((RCMFR*(1-positif(ART1731BIS))+min(RCMFR,max(max(BRCMTOTP2,BRCMTOT_P),BRCMTOT1731+0))*ART1731BIS) - FRAN - 2FRAN - FRAR - 2FRAR - FRAU ) * positif(DISQUO));

regle 82002:
application : iliad , batch ;
1RAN = (1 - positif(EXFR)) * (RCMRNABD - FRAN)
	+ positif(EXFR) * 0;
2RAN = (1 - positif(EXFR)) * (2RCMRNABD - 2FRAN)
	+ positif(EXFR) * 0;
TRAN = 1RAN + 2RAN ;
1RAR = (1 - positif(EXFR)) * (RCMHAB - FRAR)
	+ positif(EXFR) * 0;
2RAR = (1 - positif(EXFR)) * (INTERE - 2FRAR) + positif(EXFR) * 0;
TRAR = 1RAR + 2RAR ;
1RAU = (1 - positif(EXFR)) * (RCMHAD - FRAU)
	+ positif(EXFR) * 0;
2RAU = (1 - positif(EXFR)) * (DISQUO - 2FRAU) + positif(EXFR) * 0;
TRAU = 1RAU + 2RAU ;
regle 82003:
application : iliad , batch ;
ABRCM2 = min( ABTAV , RAVC);
regle 82007:
application : iliad , batch ;
ABAVC = positif(RCMAV) * arr( ABRCM2 * RCMAV / RAVC );
2ABAVC = positif(PROVIE) * min(arr( ABRCM2 * PROVIE / RAVC ) , ABRCM2 - ABAVC);
TABAVC = ABAVC + 2ABAVC ;
regle 82008:
application : iliad , batch ;
RNTNC = RTNC ;
RNAVC = RAVC - TABAVC;
regle 820091:
application : iliad , batch ;
RCMFRART1731 = null(4- V_IND_TRAIT)* PREM8_11 * max( 0, min(RCMFR,BRCMBIS))
             + null(5-V_IND_TRAIT) * max( 0, min(RCMFR,max(BRCM1731,max(BRCM_P,BRCMP2))));
regle 820093:
application : iliad , batch ;
EXFR =  max( 0, RCMFR*(1-positif(ART1731BIS))+min(RCMFR,max(max(BRCMTOTP2,BRCMTOT_P),BRCMTOT1731+0))*ART1731BIS - RCMAB - RTCAR - RCMNAB);
regle 82010:
application : iliad , batch ;
1RIA = 1RAN ;
2RIA = 2RAN ;
1RNC = RCMRNTNC ;
2RNC = 2RCMRNTNC ;
RCAV = max ( 0 , RCMAV-ABAVC) ;
2RCAV = max ( 0 , PROVIE-2ABAVC) ;
1RAO = max( 0 , REGPRIVM);
2RAO = max( 0 , 2REGPRIVM);
R2FA = max(0,COD2FA);
TRCM1 = 1RNC + RCAV + 1RAO;
TRCM = TRCM1 + 2RNC + 2RCAV + 2RAO ;
regle 82011:
application : iliad , batch ;
FRG1 = positif(EXFR) * arr( (EXFR * TRCM1)/ TRCM)
	+ (1 - positif(EXFR)) * 0 ;
FRG2 = positif(EXFR) * min(arr(EXFR * 2RNC/ TRCM), EXFR - FRG1)
        + (1 - positif(EXFR)) * 0 ;
FRG3 = positif(EXFR) * min(arr(EXFR * 2RCAV/ TRCM), EXFR - FRG1 - FRG2)
        + (1 - positif(EXFR)) * 0 ;
FRG5 = positif(EXFR) * max(0,EXFR - FRG1 -FRG2 - FRG3)
        + (1 - positif(EXFR)) * 0 ;
regle 82012:
application : iliad , batch ;
DFRCMNBIS = (positif(RCMAB + RTCAR + RCMNAB)
        * (1 - positif(RTNC+RAVC+RCMPRIVM))
        * max(0, RCMFR
                        - RCMAB
                        - RTCAR
                        - RCMNAB)

+ (1 - positif(RCMAB + RTCAR + RCMNAB))
        * positif(RTNC+RAVC+RCMPRIVM)
        * max(0, RCMFR
                        - RTNC
                        - (RAVC - TABAVC)
                        - RCMPRIVM)
+ positif(RCMAB + RTCAR + RCMNAB)
   * positif(RTNC+RAVC+RCMPRIVM)
   * max(0, RCMFR
                        - RCMAB
                        - RCMNAB
                        - RTNC
                        - (RAVC - TABAVC)
                        - RTCAR
                        - RCMPRIVM)
+ (1 - positif(RCMAB + RTCAR + RCMNAB))
        * (1 - positif(RTNC+RAVC+RCMPRIVM))
        * max(0, RCMFR))  ;
DFRCMN = DFRCMNBIS * (1-positif(ART1731BIS)) 
        + (RCMFR - RCMFRART1731) * positif(ART1731BIS) ;
regle 82013:
application : iliad , batch ;
1RCM_I = si( (V_REGCO + 0) dans (1,3,5,6,7) )
alors  (((1-positif(DFRCMN)) * (1RIA+1RNC+1RAR+1RAU+1RAO+RCAV-FRG1) -positif(DFRCMN)*0 ) * (1-positif(ART1731BIS))
       + (positif(ART1731BIS) * (1RIA+1RNC+1RAR+1RAU+1RAO+RCAV-FRG1) -positif(DFRCMN)*0))
sinon (0)
finsi;

2RCM_I =  si( (V_REGCO + 0)  dans (1,3,5,6,7))
              alors ((1- positif(DFRCMN)) * 2RIA * (1-positif(ART1731BIS))
                   + 2RIA * positif(ART1731BIS))
              sinon (0)
          finsi;
3RCM_I = si( (V_REGCO + 0)  dans (1,3,5,6,7))
             alors  ((1- positif(DFRCMN)) * (2RNC-FRG2) * (1-positif(ART1731BIS))
                   + (2RNC-FRG2) * positif(ART1731BIS))
             sinon (0)
         finsi;
4RCM_I = si( (V_REGCO + 0)  dans (1,3,5,6,7))
             alors  ((1- positif(DFRCMN)) * (2RCAV-FRG3) * (1-positif(ART1731BIS))
                  +  (2RCAV-FRG3) * positif(ART1731BIS))
             sinon (0)
         finsi;
5RCM_I = si( (V_REGCO + 0)  dans (1,3,5,6,7))
             alors ((1- positif(DFRCMN)) * 2RAU * (1-positif(ART1731BIS))
                  + 2RAU * positif(ART1731BIS))
             sinon (0)
         finsi;
6RCM_I = si( (V_REGCO + 0)  dans (1,3,5,6,7))
             alors  ((1- positif(DFRCMN)) * (2RAO-FRG5) * (1-positif(ART1731BIS))
                 +   (2RAO-FRG5) * positif(ART1731BIS))
             sinon (0)
         finsi;
7RCM_I = si( (V_REGCO + 0)  dans (1,3,5,6,7))
             alors  ((1- positif(DFRCMN)) * 2RAR * (1-positif(ART1731BIS))
                 +   2RAR * positif(ART1731BIS))
             sinon (0)
         finsi;
RCM_I = 1RCM_I + 2RCM_I + 3RCM_I + 4RCM_I + 5RCM_I + 6RCM_I + 7RCM_I;
regle 82014:
application : iliad , batch ;
REPRCM = (DEFRCM + DEFRCM2 + DEFRCM3 + DEFRCM4 + DEFRCM5 + DEFRCM6);
REPRCMB =  max(0,BRCM + BRCMQ - RCMFR);
REPRCMBIS = (DEFRCM + DEFRCM2 + DEFRCM3 + DEFRCM4 + DEFRCM5 + DEFRCM6) * (1-positif(ART1731BIS))
         +  min(DEFRCM + DEFRCM2 + DEFRCM3 + DEFRCM4 + DEFRCM5 + DEFRCM6,max(REPRCM1731,max(REPRCM_P,REPRCMP2))) * ART1731BIS * (1-PREM8_11)
         +  0 * ART1731BIS * PREM8_11;
REPRCM1 = positif(REPRCMBIS) * arr( (REPRCMBIS * 1RCM_I)/ RCM_I)
	+ (1 - positif(REPRCMBIS)) * 0 ;
REPRCM2 = positif(REPRCMBIS) * min(arr((REPRCMBIS * 2RCM_I)/ RCM_I), REPRCMBIS - REPRCM1)
        + (1 - positif(REPRCMBIS)) * 0 ;
REPRCM3 = positif(REPRCMBIS) * min(arr((REPRCMBIS * 3RCM_I)/ RCM_I), REPRCMBIS - REPRCM1 - REPRCM2)
        + (1 - positif(REPRCMBIS)) * 0 ;
REPRCM4 = positif(REPRCMBIS) * min(arr((REPRCMBIS * 4RCM_I)/ RCM_I), REPRCMBIS - REPRCM1 - REPRCM2 - REPRCM3)
        + (1 - positif(REPRCMBIS)) * 0 ;
REPRCM5 = positif(REPRCMBIS) * min(arr((REPRCMBIS * 5RCM_I)/ RCM_I), REPRCMBIS - REPRCM1 - REPRCM2 - REPRCM3 - REPRCM4)
        + (1 - positif(REPRCMBIS)) * 0 ;
REPRCM6 = positif(REPRCMBIS) * min(arr((REPRCMBIS * 6RCM_I)/ RCM_I), REPRCMBIS - REPRCM1 - REPRCM2 - REPRCM3 - REPRCM4 - REPRCM5)
        + (1 - positif(REPRCMBIS)) * 0 ;
REPRCM7 = positif(REPRCMBIS) * max(0,REPRCMBIS - REPRCM1 -REPRCM2 - REPRCM3 - REPRCM4 - REPRCM5  - REPRCM6 )
        + (1 - positif(REPRCMBIS)) * 0 ;
regle 82015:
application : iliad , batch ;
DFRCM5 =  (DEFRCM6 * positif(DFRCMN)
         + DEFRCM6 * positif(DEFRCM+DEFRCM2+DEFRCM3+DEFRCM4+DEFRCM5- RCM_I) * (1-positif(DFRCMN))
         + max( 0, DEFRCM6 - (RCM_I -DEFRCM- DEFRCM2-DEFRCM3-DEFRCM4-DEFRCM5))
         * positif_ou_nul(RCM_I -DEFRCM-DEFRCM2-DEFRCM3-DEFRCM4-DEFRCM5) * (1-positif(DFRCMN)))
	 * (1-positif(ART1731BIS))
           + min(DEFRCM6,REPRCM - REPRCMBIS) * positif(ART1731BIS*(1-PREM8_11))
           + DEFRCM6 * positif(ART1731BIS*PREM8_11);
DFRCM4 =  (DEFRCM5 * positif(DFRCMN)
         + DEFRCM5 * positif(DEFRCM+DEFRCM2+DEFRCM3+DEFRCM4- RCM_I) * (1-positif(DFRCMN))
         + max( 0, DEFRCM5 - (RCM_I -DEFRCM- DEFRCM2-DEFRCM3-DEFRCM4))
         * positif_ou_nul(RCM_I -DEFRCM- DEFRCM2-DEFRCM3-DEFRCM4) * (1-positif(DFRCMN)))
	 * (1-positif(ART1731BIS))
           + min(DEFRCM5,REPRCM - REPRCMBIS - DFRCM5 ) * positif(ART1731BIS*(1-PREM8_11))
           + DEFRCM5 * positif(ART1731BIS*PREM8_11);
DFRCM3 =  (DEFRCM4 * positif(DFRCMN)
         + DEFRCM4 * positif(DEFRCM+DEFRCM2+DEFRCM3- RCM_I) * (1-positif(DFRCMN))
         + max( 0, DEFRCM4 - (RCM_I -DEFRCM)) * positif_ou_nul(RCM_I -DEFRCM-DEFRCM2-DEFRCM3) * (1-positif(DFRCMN)))
	 * (1-positif(ART1731BIS))
           + min(DEFRCM4,REPRCM - REPRCMBIS - DFRCM5 - DFRCM4 ) * positif(ART1731BIS*(1-PREM8_11))
           + DEFRCM4 * positif(ART1731BIS*PREM8_11);
DFRCM2 =  (DEFRCM3 * positif(DFRCMN)
         + DEFRCM3 * positif(DEFRCM+DEFRCM2- RCM_I) * (1-positif(DFRCMN))
         + max( 0, DEFRCM3 - (RCM_I -DEFRCM)) * positif_ou_nul(RCM_I -DEFRCM-DEFRCM2) * (1-positif(DFRCMN)))
	 * (1-positif(ART1731BIS))
           + min(DEFRCM3,REPRCM - REPRCMBIS - DFRCM5 - DFRCM4-DFRCM3) * positif(ART1731BIS*(1-PREM8_11))
           + DEFRCM3 * positif(ART1731BIS*PREM8_11);
DFRCM1 =  (DEFRCM2 * positif(DFRCMN)
           + DEFRCM2 * positif(DEFRCM - RCM_I) * (1-positif(DFRCMN))
           + max( 0, DEFRCM2 - (RCM_I-DEFRCM)) * positif_ou_nul(RCM_I-DEFRCM) * (1-positif(DFRCMN)))
	 * (1-positif(ART1731BIS)) 
           + min(DEFRCM2,REPRCM - REPRCMBIS  - DFRCM5 - DFRCM4-DFRCM3-DFRCM2) * positif(ART1731BIS*(1-PREM8_11))
           + DEFRCM2 * positif(ART1731BIS*PREM8_11);
regle 82016:
application : iliad , batch ;
RCM = si( (V_REGCO + 0)  dans (1,3,5,6,7))
alors (( (1-positif(DFRCM1+DFRCM2+DFRCM3+DFRCM4+DFRCM5)) * max(0,(1RCM_I-REPRCM1))
         -positif(DFRCM1+DFRCM2+DFRCM3+DFRCM4+DFRCM5)*0 
      ) * (1-positif(ART1731BIS))
      + positif(ART1731BIS) * max(0,(1RCM_I-REPRCM1))
      )
sinon (0)
finsi;
RCM2FA = COD2FA * (1 - positif(null(2-V_REGCO) + null(4-V_REGCO))); 
2RCM = si( (V_REGCO + 0)  dans (1,3,5,6,7))
alors (( (1- positif(DFRCM1+DFRCM2+DFRCM3+DFRCM4+DFRCM5)) * max(0,(2RCM_I-REPRCM2))
      ) * (1-positif(ART1731BIS))
      + positif(ART1731BIS) * max(0,(2RCM_I-REPRCM2))
      )
sinon (0)
finsi;
3RCM = si( (V_REGCO + 0)  dans (1,3,5,6,7))
alors (( (1- positif(DFRCM1+DFRCM2+DFRCM3+DFRCM4+DFRCM5)) * max(0,(3RCM_I-REPRCM3))
      ) * (1-positif(ART1731BIS))
      + positif(ART1731BIS) * max(0,(3RCM_I-REPRCM3))
      )
sinon (0)
finsi;
4RCM = si( (V_REGCO + 0)  dans (1,3,5,6,7))
alors (( (1- positif(DFRCM1+DFRCM2+DFRCM3+DFRCM4+DFRCM5)) * max(0,(4RCM_I-REPRCM4))
      ) * (1-positif(ART1731BIS))
      + positif(ART1731BIS) * max(0,(4RCM_I-REPRCM4))
      )
sinon (0)
finsi;
5RCM = si( (V_REGCO + 0)  dans (1,3,5,6,7))
alors (( (1- positif(DFRCM1+DFRCM2+DFRCM3+DFRCM4+DFRCM5)) * max(0,(5RCM_I-REPRCM5))
      ) * (1-positif(ART1731BIS))
      + positif(ART1731BIS) * max(0,(5RCM_I-REPRCM5))
      )
sinon (0)
finsi;
6RCM = si( (V_REGCO + 0)  dans (1,3,5,6,7))
alors (( (1- positif(DFRCM1+DFRCM2+DFRCM3+DFRCM4+DFRCM5)) * max(0,(6RCM_I-REPRCM6))
      ) * (1-positif(ART1731BIS))
      + positif(ART1731BIS) * max(0,(6RCM_I-REPRCM6))
      )
sinon (0)
finsi;
7RCM = si( (V_REGCO + 0)  dans (1,3,5,6,7))
alors (( (1- positif(DFRCM1+DFRCM2+DFRCM3+DFRCM4+DFRCM5)) * max(0,(7RCM_I-REPRCM7))
      ) * (1-positif(ART1731BIS))
      + positif(ART1731BIS) * max(0,(7RCM_I-REPRCM7))
      )
sinon (0)
finsi;
DFRCM = (DFRCMN + DFRCM1+DFRCM2+DFRCM3+DFRCM4+DFRCM5) * (1-positif(null(2-V_REGCO)+null(4-V_REGCO)));
RCMEXCREF = max(0,TRCMRABD + TRCMRTNC) * (1 - positif(null(2-V_REGCO) + null(4-V_REGCO)));
regle 82100:
application : iliad , batch ;
ABTAV = PLAF_RCMAV1 * (1 + BOOL_0AM) ;
regle 82107:
application : iliad , batch ;
BPLIB = (min( RCMLIB, max(0 , ABTAV - RAVC) ) * (1 - V_CNR));
regle 82110:
application : iliad , batch ;
EPAV = arr(BPLIB * TX_PREVLIB/100);
regle 82111:
application : iliad , batch ;
VAREPRCM = min(DEFRCM + DEFRCM2 + DEFRCM3 + DEFRCM4 + DEFRCM5 + DEFRCM6,1RCM_I + 2RCM_I +3RCM_I +4RCM_I +5RCM_I +6RCM_I +7RCM_I );
