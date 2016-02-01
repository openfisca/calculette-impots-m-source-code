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
regle 801 :
application : iliad , batch  ;
BA1AF =  BAF1AP  + BAF1AC  + BAF1AV  ;
regle 840 :
application : iliad , batch  ;
BARSV = BAHREV + 4BAHREV - BAHDEV * (1 - positif(ART1731BIS*PREM8_11));
BARSREVV = BAHREV +4BAHREV;
BARSC = BAHREC + 4BAHREC - BAHDEC * (1 - positif(ART1731BIS*PREM8_11));
BARSREVC = BAHREC +4BAHREC;
BARSP = BAHREP + 4BAHREP - BAHDEP * (1 - positif(ART1731BIS*PREM8_11));
BARSREVP = BAHREP +4BAHREP;
BARAV = BACREV + 4BACREV - BACDEV * (1 - positif(ART1731BIS*PREM8_11));
BARREVAV = BACREV + 4BACREV;
BARAC = BACREC  + 4BACREC - BACDEC * (1 - positif(ART1731BIS*PREM8_11));
BARREVAC = BACREC + 4BACREC;
BARAP = BACREP + 4BACREP -BACDEP * (1 - positif(ART1731BIS*PREM8_11));
BARREVAP = BACREP + 4BACREP;
regle 8421:
application : iliad , batch  ;
pour i =V,C,P:
DEFBACREi = positif(4BACREi) * arr((((BACDEi * (1 - positif(ART1731BIS*PREM8_11)))) * BACREi) / BARREVAi) 
				   + (1 - positif(4BACREi)) * (BACDEi * (1 - positif(ART1731BIS*PREM8_11))) ;
pour i =V,C,P:
4DEFBACREi = positif(4BACREi) * (((BACDEi * (1 - positif(ART1731BIS*PREM8_11)))) - DEFBACREi);
regle 8422234:
application : iliad ;
SOMBARET = 4BACREV + 4BACREC + 4BACREP + (4BAHREV + 4BAHREC +4BAHREP) * MAJREV;
SOMBARREVT = 4BAQV + 4BAQC +4BAQP ;
PROQDEFBAT =  (max(0,SOMBARET-SOMBARREVT) / DEFBANIF ) * positif(DEFBANIF);
regle 84211:
application : iliad , batch  ;
BANV = (BACREV - DEFBACREV) * positif_ou_nul(BARAV) + BARAV * (1-positif(BARAV));
BANC = (BACREC - DEFBACREC) * positif_ou_nul(BARAC) + BARAC * (1-positif(BARAC));
BANP = (BACREP - DEFBACREP) * positif_ou_nul(BARAP) + BARAP * (1-positif(BARAP));
BAEV = (4BACREV - 4DEFBACREV) * positif_ou_nul(BARAV) + 0;
BAEC = (4BACREC - 4DEFBACREC) * positif_ou_nul(BARAC) + 0;
BAEP = (4BACREP - 4DEFBACREP) * positif_ou_nul(BARAP) + 0;
regle 842111:
application : iliad , batch  ;
pour i =V,C,P:
DEFBAHREi = positif(4BAHREi) * arr(((BAHDEi * (1 - positif(ART1731BIS*PREM8_11))) * BAHREi) / BARSREVi) 
					      + (1 - positif(4BAHREi)) * (BAHDEi * (1 - positif(ART1731BIS*PREM8_11))) ;
pour i =V,C,P:
4DEFBAHREi = positif(4BAHREi) * ((BAHDEi * (1 - positif(ART1731BIS*PREM8_11) )) - DEFBAHREi) ;
regle 843:
application : iliad , batch  ;
BAMV = arr((BAHREV - DEFBAHREV) * MAJREV) * positif_ou_nul(BARSV) + BARSV * (1-positif(BARSV));
BAMC = arr((BAHREC - DEFBAHREC) * MAJREV) * positif_ou_nul(BARSC) + BARSC * (1-positif(BARSC));
BAMP = arr((BAHREP - DEFBAHREP) * MAJREV) * positif_ou_nul(BARSP) + BARSP * (1-positif(BARSP));
BAEMV = (arr((4BAHREV - 4DEFBAHREV)* MAJREV)) * positif_ou_nul(BARSV) + 0;
BAEMC = (arr((4BAHREC - 4DEFBAHREC)* MAJREV)) * positif_ou_nul(BARSC) + 0;
BAEMP = (arr((4BAHREP - 4DEFBAHREP)* MAJREV)) * positif_ou_nul(BARSP) + 0;
regle 844:
application : iliad , batch  ;
BAFORV = arr(BAFV*MAJREV)+BAFORESTV+BAFPVV;
BAFORC = arr(BAFC*MAJREV)+BAFORESTC+BAFPVC;
BAFORP = arr(BAFP*MAJREV)+BAFORESTP+BAFPVP;
regle 8441:
application : iliad , batch  ;
BAHQV = BANV + BAMV + BAFORV;
BAHQC = BANC + BAMC + BAFORC;
BAHQP = BANP + BAMP + BAFORP;
regle 845:
application : iliad , batch  ;
4BAQV = max(0,(4BACREV - 4DEFBACREV))*positif_ou_nul(BARAV)+arr(max(0,(4BAHREV - 4DEFBAHREV))*MAJREV) * positif_ou_nul(BARSV);
4BAQC = max(0,(4BACREC - 4DEFBACREC))*positif_ou_nul(BARAC)+arr(max(0,(4BAHREC - 4DEFBAHREC))*MAJREV) * positif_ou_nul(BARSC);
4BAQP = max(0,(4BACREP - 4DEFBACREP))*positif_ou_nul(BARAP)+arr(max(0,(4BAHREP - 4DEFBAHREP))*MAJREV) * positif_ou_nul(BARSP);
regle 8451:
application : iliad , batch  ;
BAQV = BAEV + BAEMV;
BAQC = BAEC + BAEMC;
BAQP = BAEP + BAEMP;
regle 84551:
application : iliad , batch  ;
BA1V = BA1AV + BAF1AV ;
BA1C = BA1AC + BAF1AC ;
BA1P = BA1AP + BAF1AP ;
regle 84552:
application : iliad , batch  ;
BAHQT=BAHQV+BAHQC+BAHQP;
regle 8455299:
application : iliad , batch  ;
DAGRIIMP = max(0,min(BAHQV+BAHQC+BAHQP + BAQV + BAQC + BAQP,DAGRI6 +DAGRI5 +DAGRI4 + DAGRI3 + DAGRI2 + DAGRI1));
TOTDAGRI =  min(DAGRI6 +DAGRI5 +DAGRI4 + DAGRI3 + DAGRI2 + DAGRI1 ,max(DAGRIIMP1731,max(DAGRIIMP_P,DAGRIIMPP2))) * positif(ART1731BIS*(1-PREM8_11))
             + DAGRIIMP * (1-positif(ART1731BIS))
             + 0 * positif(ART1731BIS*PREM8_11);
regle 845529:
application : iliad , batch  ;
BAHQTOT=BAHQV+BAHQC+BAHQP-TOTDAGRI*(1-ART1731BIS);
BAHQTOTMAXP=positif_ou_nul(BAHQT) * (max(0,BAHQV+BAHQC+BAHQP-TOTDAGRI));
regle 8455255:
application : iliad , batch;
BAHQTOTMAXN=positif_ou_nul(BAHQT) * min(0,BAHQV+BAHQC+BAHQP-TOTDAGRI*(1-ART1731BIS));
BAHQTOTMIN=positif(-BAHQT) * BAHQT;
regle 84513:
application : iliad , batch  ;
BAQT = BAQV + BAQC + BAQP;
BAQTOT = max(0,BAQV + BAQC + BAQP + BAHQTOTMAXN);
BAQTOTN = min(0,BAQV + BAQC + BAQP + BAHQTOTMAXN);
BAQTOTMIN = min(0,BAQV + BAQC + BAQP + BAHQTOTMIN);
BAQTOTAV = positif_ou_nul(BAQT + BAHQT) * BAQTOT + (1 - positif(BAQT + BAHQT)) * 0;
regle 845138:
application : iliad , batch  ;
4BAQTOT = somme(x=V,C,P: 4BAQx) ;
4BAQTOTNET = positif(4BAQTOT) * (
                     max(0, 4BAQTOT + (BAHQTOTMIN + BAHQTOTMAXN) ) * positif((1-ART1731BIS)+(1-positif(DEFRIBASUP+DEFRIGLOBSUP))*(1-PREM8_11))
                     + max(0,min(4BAQV+4BAQC+4BAQP+arr(DEFBANIF*PROQDEFBAT)
                      ,4BACREV+4BACREC+4BACREP+(4BAHREV+4BAHREC+4BAHREP)*MAJREV ))* positif(DEFRIBASUP+DEFRIGLOBSUP)*(1-PREM8_11));
regle 845111:
application : iliad , batch  ;
BA1 = BA1V + BA1C + BA1P; 
regle 846:
application : iliad , batch  ;
BANOR = (BAHQTOTMAXP + BAQTOTMIN) * (1-ART1731BIS)
        + (BAHQTOTMAXP + BAQTOTMIN + arr(DEFBANIF * (1-PROQDEFBAT))) * ART1731BIS * (1-PREM8_11)
        + (BAHQTOTMAXP + BAQTOTMIN) * ART1731BIS * PREM8_11;

regle 847:
application : iliad , batch  ;

DEFBA2 = ((1-positif(BAHQT+BAQT)) * (DAGRI1)
                 + positif(BAHQT+BAQT) *
                 abs(min(max(BAHQT+BAQT-DAGRI6-DAGRI5-DAGRI4-DAGRI3-DAGRI2,0)-DAGRI1,DAGRI1))
                 * positif_ou_nul(DAGRI1-max(BAHQT+BAQT-DAGRI6-DAGRI5-DAGRI4-DAGRI3-DAGRI2,0))
                 * (1 - positif(IPVLOC)))
                 * (1-positif(ART1731BIS))
                  + min(DAGRI1,DAGRI-DBAIP) * positif(ART1731BIS*(1-positif(PREM8_11+null(8-CMAJ)+null(11-CMAJ))))
                  + DAGRI1 * positif(positif(ART1731BIS*PREM8_11)+null(8-CMAJ)+null(11-CMAJ));
DEFBA3 = ((1-positif(BAHQT+BAQT)) * (DAGRI2)
                 + positif(BAHQT+BAQT) *
                 abs(min(max(BAHQT+BAQT-DAGRI6-DAGRI5-DAGRI4-DAGRI3,0)-DAGRI2,DAGRI2))
                 * positif_ou_nul(DAGRI2-max(BAHQT+BAQT-DAGRI6-DAGRI5-DAGRI4-DAGRI3,0))
                 * (1 - positif(IPVLOC)))
                 * (1-positif(ART1731BIS))
                  + min(DAGRI2,DAGRI-DBAIP-DEFBA2) * positif(ART1731BIS*(1-positif(PREM8_11+null(8-CMAJ)+null(11-CMAJ))))
                  + DAGRI2 * positif(positif(ART1731BIS*PREM8_11)+null(8-CMAJ)+null(11-CMAJ));
DEFBA4 = ((1-positif(BAHQT+BAQT)) * (DAGRI3)
                 + positif(BAHQT+BAQT) *
                 abs(min(max(BAHQT+BAQT-DAGRI6-DAGRI5-DAGRI4,0)-DAGRI3,DAGRI3))
                 * positif_ou_nul(DAGRI3-max(BAHQT+BAQT-DAGRI6-DAGRI5-DAGRI4,0))
                 * (1 - positif(IPVLOC)))
                 * (1-positif(ART1731BIS))
                  + min(DAGRI3,DAGRI-DBAIP-DEFBA2-DEFBA3) * positif(ART1731BIS*(1-positif(PREM8_11+null(8-CMAJ)+null(11-CMAJ))))
                  + DAGRI3 * positif(positif(ART1731BIS*PREM8_11)+null(8-CMAJ)+null(11-CMAJ));
DEFBA5 = ((1-positif(BAHQT+BAQT)) * (DAGRI4)
                 + positif(BAHQT+BAQT) *
                 abs(min(max(BAHQT+BAQT-DAGRI6-DAGRI5,0)-DAGRI4,DAGRI4))
                 * positif_ou_nul(DAGRI4-max(BAHQT+BAQT-DAGRI6-DAGRI5,0))
                 * (1 - positif(IPVLOC)))
                 * (1-positif(ART1731BIS))
                  + min(DAGRI4,DAGRI-DBAIP-DEFBA2-DEFBA3-DEFBA4) *positif(ART1731BIS*(1-positif(PREM8_11+null(8-CMAJ)+null(11-CMAJ))))
                  + DAGRI4 * positif(positif(ART1731BIS*PREM8_11)+null(8-CMAJ)+null(11-CMAJ));

DEFBA6 = ((1-positif(BAHQT+BAQT)) * (DAGRI5)
                 + positif(BAHQT+BAQT) *
                 abs(min(max(BAHQT+BAQT-DAGRI6,0)-DAGRI5,DAGRI5))
                 * positif_ou_nul(DAGRI5-max(BAHQT+BAQT-DAGRI6,0))
                 * (1 - positif(IPVLOC)))
                 * (1-positif(ART1731BIS))
                  + min(DAGRI5,DAGRI-DBAIP-DEFBA2-DEFBA3-DEFBA4-DEFBA5)* positif(ART1731BIS*(1-positif(PREM8_11+null(8-CMAJ)+null(11-CMAJ))))
                  + DAGRI5 * positif(positif(ART1731BIS*PREM8_11)+null(8-CMAJ)+null(11-CMAJ));
DEFBA1 = ((1-positif(BAHQT+BAQT)) * (abs(BAHQT+BAQT)-abs(DEFIBA))
                 + positif(BAHQT+BAQT) *
                 positif_ou_nul(DAGRI5+DAGRI4+DAGRI3+DAGRI2+DAGRI1-BAHQT-BAQT)
                 * (DAGRI5+DAGRI4+DAGRI3+DAGRI2+DAGRI1-BAHQT-BAQT)
                  * null(DEFBA2+DEFBA3+DEFBA4+DEFBA5+DEFBA6)
                 * (1 - positif(IPVLOC)))
                 * (1-positif(ART1731BIS))
                 +  DEFBANIF * positif(ART1731BIS*(1-positif(PREM8_11+null(8-CMAJ)+null(11-CMAJ))))
                 + (BACDEV +BACDEC +BACDEP +BAHDEV +BAHDEC +BAHDEP) * positif(positif(ART1731BIS*PREM8_11)+null(8-CMAJ)+null(11-CMAJ))*(1-positif(SEUIL_IMPDEFBA + 1 - SHBA - (REVTP-BA1) - REVQTOTQHT));
regle 848:
application : iliad , batch  ;
DEFIBAANT = positif_ou_nul(BAQT+BAHQTOT-(min(DAGRI1,DAGRI11731+0) * positif(ART1731BIS) + DAGRI1 * (1 - ART1731BIS))
				       -(min(DAGRI2,DAGRI21731+0) * positif(ART1731BIS) + DAGRI2 * (1 - ART1731BIS))
				       -(min(DAGRI3,DAGRI31731+0) * positif(ART1731BIS) + DAGRI3 * (1 - ART1731BIS))
				       -(min(DAGRI4,DAGRI41731+0) * positif(ART1731BIS) + DAGRI4 * (1 - ART1731BIS))
				       -(min(DAGRI5,DAGRI51731+0) * positif(ART1731BIS) + DAGRI5 * (1 - ART1731BIS))
				       -(min(DAGRI6,DAGRI61731+0) * positif(ART1731BIS) + DAGRI6 * (1 - ART1731BIS)))
            * ((min(DAGRI1,DAGRI11731+0) * positif(ART1731BIS) + DAGRI1 * (1 - ART1731BIS))
	    -(min(DAGRI2,DAGRI21731+0) * positif(ART1731BIS) + DAGRI2 * (1 - ART1731BIS))
	    -(min(DAGRI3,DAGRI31731+0) * positif(ART1731BIS) + DAGRI3 * (1 - ART1731BIS))
	    -(min(DAGRI4,DAGRI41731+0) * positif(ART1731BIS) + DAGRI4 * (1 - ART1731BIS))
	    -(min(DAGRI5,DAGRI51731+0) * positif(ART1731BIS) + DAGRI5 * (1 - ART1731BIS))
	    -(min(DAGRI6,DAGRI61731+0) * positif(ART1731BIS) + DAGRI6 * (1 - ART1731BIS)))
            + positif_ou_nul((min(DAGRI1,DAGRI11731+0) * positif(ART1731BIS) + DAGRI1 * (1 - ART1731BIS))
	    +(min(DAGRI2,DAGRI21731+0) * positif(ART1731BIS) + DAGRI2 * (1 - ART1731BIS))
	    +(min(DAGRI3,DAGRI31731+0) * positif(ART1731BIS) + DAGRI3 * (1 - ART1731BIS))
	    +(min(DAGRI4,DAGRI41731+0) * positif(ART1731BIS) + DAGRI4 * (1 - ART1731BIS))
	    +(min(DAGRI5,DAGRI51731+0) * positif(ART1731BIS) + DAGRI5 * (1 - ART1731BIS))
	    +(min(DAGRI6,DAGRI61731+0) * positif(ART1731BIS) + DAGRI6 * (1 - ART1731BIS))-BAQT-BAHQTOT)
            * (BAQT+BAHQTOT);
regle 849:
application : iliad , batch  ;
DAGRI = DAGRI1+DAGRI2+DAGRI3+DAGRI4+DAGRI5+DAGRI6;
VAREDAGRI = min(DAGRI,BAHQV+BAHQC+BAHQP);
regle 850:
application : iliad , batch  ;
BAQTOTAVIS = 4BAQTOTNET;
regle 8509:
application : iliad , batch  ;
SOMDEFBANI = BACDEV+BAHDEV+BACDEC+BAHDEC+BACDEP+BAHDEP;
DEFBANI = (BAHQV+BAHQC+BAHQP-TOTDAGRI+4BAQV+4BAQC+4BAQP +DBAIP+SOMDEFBANI); 
DEFBANIF = positif(DEFRIBASUP+DEFRIGLOBSUP) * (1-PREM8_11) * max(0,min(SOMDEFBANI,
                                            -(max(DEFBANI1731,max(DEFBANI_P,DEFBANIP2))-SOMDEFBANI)));
