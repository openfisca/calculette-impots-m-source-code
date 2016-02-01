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
regle 80000:
application : iliad , batch  ;
HRBTRFR1 = V_BTRFRHR1 * (1-positif_ou_nul(RFRH1)) + RFRH1;
HRBTRFR2 = V_BTRFRHR2 * (1-positif_ou_nul(RFRH2)) + RFRH2;
HRNBTRFR = positif_ou_nul(V_BTRFRHR1 * (1-positif(RFRH1)) + RFRH1) + positif_ou_nul(V_BTRFRHR2 * (1-positif(RFRH2)) + RFRH2);
HRMOYBTRFR = arr((HRBTRFR1 + HRBTRFR2) /2);
HRLIM15 = positif_ou_nul(REVKIREHR - (1.5 * HRMOYBTRFR));
HRLIMBTRFR2 = positif_ou_nul(LIMHR1 * (1+BOOL_0AM) - HRBTRFR2);
HRLIMBTRFR1 = positif_ou_nul(LIMHR1 * (1+BOOL_0AM) - HRBTRFR1);
HRCONDTHEO = positif(null(2-HRNBTRFR)*positif(HRLIM15)*positif(HRLIMBTRFR1*HRLIMBTRFR2)* (1-positif(CASECHR+0)));
HRBASEFRAC = arr((REVKIREHR - HRMOYBTRFR) / 2);
HRBASELISSE = HRBASEFRAC + HRMOYBTRFR;
CHRREEL1 = positif_ou_nul(LIMHRTX1 * (1+BOOL_0AM)-REVKIREHR) * ((REVKIREHR - LIMHR1 * (1+BOOL_0AM))*TXHR1/100)
                       + (LIMHR1 * (1+BOOL_0AM) * TXHR1/100) * positif(REVKIREHR - LIMHRTX1 * (1+BOOL_0AM));
CHRREEL2 = max(0,(REVKIREHR - LIMHR2*(1+BOOL_0AM))*TXHR2/100);
CHRREELTOT = arr(max(0,CHRREEL1 + CHRREEL2));
CHRTHEO11 = arr(positif_ou_nul(LIMHRTX1 * (1+BOOL_0AM)-HRBASELISSE) * ((HRBASELISSE - LIMHR1 * (1+BOOL_0AM))*TXHR1/100)
                        + (LIMHR1 * (1+BOOL_0AM) * TXHR1/100)* positif(HRBASELISSE - LIMHRTX1 * (1+BOOL_0AM)));
CHRTHEO21 = arr(max(0,(HRBASELISSE - LIMHR2*(1+BOOL_0AM))*TXHR2/100));
CHRTHEOTOT = arr(max(0,CHRTHEO11 + CHRTHEO21)*2);
BHAUTREV = max(0 , REVKIREHR - LIMHR1 * (1 + BOOL_0AM)) ;
CHRAVANT = (max(0,min(CHRREELTOT,CHRTHEOTOT)) * HRCONDTHEO
                     + CHRREELTOT * (1-HRCONDTHEO) ) ;
CHRTEFF = arr(CHRAVANT * (REVKIREHR - TEFFHRC+COD8YJ)/ REVKIREHR);
CHRAPRES = CHRAVANT * (1-positif(positif(IPMOND)+positif(INDTEFF))) + CHRTEFF * positif(positif(IPMOND)+positif(INDTEFF));
regle 80005:
application : iliad , batch  ;
IHAUTREVT = max(0,CHRAPRES - CICHR);
