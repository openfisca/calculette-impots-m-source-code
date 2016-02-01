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
regle 507:
application : bareme , iliad , batch  ;

TAUX1 = ((TX_BAR1 * (1 - V_ANC_BAR) + TX_BAR1A * V_ANC_BAR) - TX_BAR0 ) ;
TAUX2 = (TX_BAR2  - (TX_BAR1 * (1 - V_ANC_BAR) + TX_BAR1A * V_ANC_BAR)) ;
TAUX3 = (TX_BAR3  - TX_BAR2 ) ;
TAUX4 = (TX_BAR4  - TX_BAR3 ) ;
TAUX5 = (TX_BAR5  - TX_BAR4 ) ;

regle 50700:
application : bareme , iliad , batch  ;
pour x=0,5;y=1,2;z=1,2:
DSxyz = max( QFxyz - (LIM_BAR1 * (1 - V_ANC_BAR) + LIM_BAR1A * V_ANC_BAR) , 0 ) * (TAUX1   / 100)
      + max( QFxyz - (LIM_BAR2 * (1 - V_ANC_BAR) + LIM_BAR2A * V_ANC_BAR) , 0 ) * (TAUX2   / 100)
      + max( QFxyz - (LIM_BAR3 * (1 - V_ANC_BAR) + LIM_BAR3A * V_ANC_BAR) , 0 ) * (TAUX3   / 100)
      + max( QFxyz - (LIM_BAR4 * (1 - V_ANC_BAR) + LIM_BAR4A * V_ANC_BAR) , 0 ) * (TAUX4   / 100)
      + max( QFxyz - (LIM_BAR5 * (1 - V_ANC_BAR) + LIM_BAR5A * V_ANC_BAR) , 0 ) * (TAUX5   / 100);

regle 50702:
application : iliad , batch  ;
WTXMARJ = (RB51) / ( NB1 * null(PLAFQF) + NB2 *null(1-PLAFQF)) ;
TXMARJ = max ( positif (WTXMARJ - (LIM_BAR1 * (1 - V_ANC_BAR) + LIM_BAR1A * V_ANC_BAR)) * (TX_BAR1 * (1 - V_ANC_BAR) + TX_BAR1A * V_ANC_BAR) , 
                max ( positif (WTXMARJ - (LIM_BAR2 * (1 - V_ANC_BAR) + LIM_BAR2A * V_ANC_BAR)) * TX_BAR2 , 
                      max ( positif (WTXMARJ - (LIM_BAR3 * (1 - V_ANC_BAR) + LIM_BAR3A * V_ANC_BAR)) * TX_BAR3 , 
                             max ( positif (WTXMARJ - (LIM_BAR4 * (1 - V_ANC_BAR) + LIM_BAR4A * V_ANC_BAR)) * TX_BAR4 ,
                                   max ( positif (WTXMARJ - (LIM_BAR5 * (1 - V_ANC_BAR) + LIM_BAR5A * V_ANC_BAR)) * TX_BAR5 , 0
				       )
                                 )
                          )
                     )
              )

          * ( 1 - positif ( 
                              present ( NRBASE ) 
                            + present ( NRINET ) 
                            + present ( IPTEFP ) 
                            + present ( IPTEFN ) 
                            + present ( PRODOM ) 
                            + present ( PROGUY ) 
                          )              
             )
          * (1- null(2 - V_REGCO))
  * positif(IDRS2+IPQ1);



regle 5071:
application : bareme , iliad , batch  ;
pour y=1,2:
DS0y4 = max( QF0y4 - (LIM_BAR1 * (1 - V_ANC_BAR) + LIM_BAR1A * V_ANC_BAR) , 0 ) * (TAUX1 /100)
      + max( QF0y4 - (LIM_BAR2 * (1 - V_ANC_BAR) + LIM_BAR2A * V_ANC_BAR) , 0 ) * (TAUX2 /100)
      + max( QF0y4 - (LIM_BAR3 * (1 - V_ANC_BAR) + LIM_BAR3A * V_ANC_BAR) , 0 ) * (TAUX3 /100)
      + max( QF0y4 - (LIM_BAR4 * (1 - V_ANC_BAR) + LIM_BAR4A * V_ANC_BAR) , 0 ) * (TAUX4 /100)
      + max( QF0y4 - (LIM_BAR5 * (1 - V_ANC_BAR) + LIM_BAR5A * V_ANC_BAR) , 0 ) * (TAUX5 /100);
pour x=0,5;y=1,2:
DSxy5 = max( QFxy5 - (LIM_BAR1 * (1 - V_ANC_BAR) + LIM_BAR1A * V_ANC_BAR) , 0 ) * (TAUX1 /100)
      + max( QFxy5 - (LIM_BAR2 * (1 - V_ANC_BAR) + LIM_BAR2A * V_ANC_BAR) , 0 ) * (TAUX2 /100)
      + max( QFxy5 - (LIM_BAR3 * (1 - V_ANC_BAR) + LIM_BAR3A * V_ANC_BAR) , 0 ) * (TAUX3 /100)
      + max( QFxy5 - (LIM_BAR4 * (1 - V_ANC_BAR) + LIM_BAR4A * V_ANC_BAR) , 0 ) * (TAUX4 /100)
      + max( QFxy5 - (LIM_BAR5 * (1 - V_ANC_BAR) + LIM_BAR5A * V_ANC_BAR) , 0 ) * (TAUX5 /100);
pour y=1,2:
DS0y6 = max( QF0y6 - (LIM_BAR1 * (1 - V_ANC_BAR) + LIM_BAR1A * V_ANC_BAR) , 0 ) * (TAUX1 /100)
      + max( QF0y6 - (LIM_BAR2 * (1 - V_ANC_BAR) + LIM_BAR2A * V_ANC_BAR) , 0 ) * (TAUX2 /100)
      + max( QF0y6 - (LIM_BAR3 * (1 - V_ANC_BAR) + LIM_BAR3A * V_ANC_BAR) , 0 ) * (TAUX3 /100)
      + max( QF0y6 - (LIM_BAR4 * (1 - V_ANC_BAR) + LIM_BAR4A * V_ANC_BAR) , 0 ) * (TAUX4 /100)
      + max( QF0y6 - (LIM_BAR5 * (1 - V_ANC_BAR) + LIM_BAR5A * V_ANC_BAR) , 0 ) * (TAUX5 /100);
regle 508:
application : bareme , iliad , batch  ;
NB1 = NBPT ;
NB2 = 1 + BOOL_0AM + BOOL_0AZ * V_0AV ;
regle 5080:
application : bareme , iliad , batch  ;
pour y=1,2;z=1,2:
QF0yz = arr(RB0z) / NBy;
pour y=1,2;z=1,2:
QF5yz = arr(RB5z) / NBy;
pour y=1,2:
QF0y4 = arr(RB04) / NBy;
pour x=0,5;y=1,2:
QFxy5 = arr(RBx5) / NBy;
pour y=1,2:
QF0y6 = arr(RB06) / NBy;

regle 66991:
application : iliad, batch ;

RNIBAR13 = ( (13465 * positif(positif(V_ANREV - V_0DA - 65) + positif(V_0AP + 0))
            + 12353 * (1 - positif(positif(V_ANREV - V_0DA - 65) + positif(V_0AP + 0)))) * null(NBPT - 1)
           + 14414 * null(NBPT - 1.25)
           + 15917 * null(NBPT - 1.5)
           + 17420 * null(NBPT - 1.75)
           + 18922 * null(NBPT - 2)
           + 20425 * null(NBPT - 2.25)
           + 21928 * null(NBPT - 2.5)
           + (23581 * positif(positif(V_ANREV - V_0DA - 65) + positif(V_0AP + 0)) * (1 - BOOL_0AM)
            + 23431 * (1 - positif(positif(V_ANREV - V_0DA - 65) + positif(V_0AP + 0)))) * null(NBPT - 2.75)
           + 24933 * null(NBPT - 3)
           + 26436 * null(NBPT - 3.25)
           + 27939 * null(NBPT - 3.5)
           + 29442 * null(NBPT - 3.75)
           + 30944 * null(NBPT - 4)
           + 32447 * null(NBPT - 4.25)
           + 33950 * null(NBPT - 4.5)
           + 35453 * null(NBPT - 4.75)
           + 36955 * null(NBPT - 5)
           + 38458 * null(NBPT - 5.25)
           + 39961 * null(NBPT - 5.5)
           + 41464 * null(NBPT - 5.75)
           + 42966 * null(NBPT - 6)
           + 44470 * null(NBPT - 6.25)
           + 45980 * null(NBPT - 6.5)
           + 47476 * null(NBPT - 6.75)
           + 48980 * null(NBPT - 7)
           + 50480 * null(NBPT - 7.25)
           + 51985 * null(NBPT - 7.5)
           + 53487 * null(NBPT - 7.75)
           + 54990 * null(NBPT - 8)
           + 56493 * null(NBPT - 8.25)
           + 57995 * null(NBPT - 8.5)
           + 59497 * null(NBPT - 8.75)
           + 61000 * null(NBPT - 9)
           + 62504 * null(NBPT - 9.25)
           + 64005 * null(NBPT - 9.5)
           + 65515 * null(NBPT - 9.75)
           + 67010 * null(NBPT - 10) ) ;

CODMESGOUV = positif(NBPT - 10) + positif(LIG74 + LIGTTPVQ) + null(2 - V_REGCO) + null(4 - V_REGCO) + positif(CESSASSV + CESSASSC + PCAPTAXV + PCAPTAXC + LOYELEV + 0) 
             + positif(IPROP + AVFISCOPTER + IPREP + IPPRICORSE) ;

MESGOUV = (  1 * null(IDRS3 - IDEC) * positif_ou_nul(RNI - RNIBAR13)
           + 2 * positif(IDRS3 - IDEC + 0) * positif(IDEC + 0)) * (1 - positif(CODMESGOUV)) * (1 - positif(RNIBAR13 - RNI))
           + 3 * positif(CODMESGOUV + positif(RNIBAR13 - RNI) + (1 - positif(null(IDRS3 - IDEC) * positif_ou_nul(RNI - RNIBAR13) + positif(IDRS3 - IDEC + 0) * positif(IDEC + 0)))) ;

MESGOUV2 = (  4 * null(IDRS3 - IDEC) * positif_ou_nul(RNI - RNIBAR13)
            + 5 * positif(IDRS3 - IDEC + 0) * positif(IDEC + 0)
            + 6 * positif(RNIBAR13 - RNI)) * (1 - positif(CODMESGOUV))
            + 7 * positif(CODMESGOUV + (1 - positif(null(IDRS3 - IDEC) * positif_ou_nul(RNI - RNIBAR13) + positif(IDRS3 - IDEC + 0) * positif(IDEC + 0) + positif(RNIBAR13 - RNI)))) ;


