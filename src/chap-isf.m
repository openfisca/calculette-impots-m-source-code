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
regle isf 77001:
application : iliad , batch  ;
DISFBASE =  ISFBASE;  
		     
regle isf 77010:
application : iliad , batch ;
TR2_ISF = arr( max(0, min( DISFBASE , LIM_TR2_ISF ) - (LIM_TR1_ISF)) * (TX_TR2_ISF/10000)) ;
TR3_ISF = arr( max(0, min( DISFBASE , LIM_TR3_ISF ) - (LIM_TR2_ISF)) * (TX_TR3_ISF/10000)) ;
TR4_ISF = arr( max(0, min( DISFBASE , LIM_TR4_ISF  ) - (LIM_TR3_ISF)) * (TX_TR4_ISF/100)) ;
TR5_ISF = arr( max(0, min( DISFBASE , LIM_TR5_ISF  ) - (LIM_TR4_ISF)) * (TX_TR5_ISF/10000)) ;
TR6_ISF = arr( max(0, DISFBASE - LIM_TR5_ISF) * (TX_TR6_ISF/1000)) ;

ISF1 = TR2_ISF + TR3_ISF + TR4_ISF + TR5_ISF + TR6_ISF;

regle isf 77015:
application :  iliad , batch ;
ISFDEC = arr((17500 - ( (TX_TR5_ISF/10000) * ISFBASE)) 
		  * positif(ISFBASE-LIM_ISFINF)*positif(LIM_ISFDEC - ISFBASE))
	 * positif(ISF1); 

DISFDEC = ISFDEC;

regle isf 77020:
application :  iliad , batch ;
ISFBRUT = arr((ISF1 - ISFDEC) * positif( LIM_ISFDEC - 1 - ISFBASE )
	     + ISF1 * (1-positif(LIM_ISFDEC - 1 - ISFBASE))) ;

regle isf 77030:
application : iliad , batch  ;
DISFPMED = ISFPMEDI ;
DISFPMEI = ISFPMEIN ;
AISFPMED = arr(ISFPMEDI * (TX50/100)) ;
AISFPMEI = arr(ISFPMEIN * (TX50/100)) ;
RISFPMED_1 = min(45000, AISFPMED);
RISFPMEI_1 = max(0, min(45000 - RISFPMED_1, AISFPMEI));


DISFFIP = ISFFIP ;
DISFFCPI = ISFFCPI ;
AISFFIP = arr(ISFFIP * (TX50/100)) ;
AISFFCPI = arr(ISFFCPI * (TX50/100)) ;
RISFFIP_1 = min(18000, AISFFIP);
RISFFCPI_1 = max(0, min(18000 -  RISFFIP_1, AISFFCPI));

regle isf 77040:
application : iliad , batch  ;
PLAF_ISFRED = 50000 * (1-positif(ISFPMEDI+ISFPMEIN+ISFFIP+ISFFCPI))
	      + 45000 * positif(ISFPMEDI+ISFPMEIN+ISFFIP+ISFFCPI) ;

DISFDONF = ISFDONF ;
DISFDONCEE = ISFDONEURO ;

AISFDONF =arr(ISFDONF * (TX75/100)) ;
AISFDONCEE = arr(ISFDONEURO * (TX75/100)) ;

RISFDONF_1 = min( PLAF_ISFRED , AISFDONF);
RISFDONCEE_1 = max(0, min( PLAF_ISFRED - RISFDONF_1, AISFDONCEE)); 

regle isf 77050:
application : iliad , batch  ;
RISFDONF_2 = min(PLAF_ISFRED, RISFDONF_1);
RISFDONCEE_2 = max(0, min(PLAF_ISFRED - RISFDONF_1, RISFDONCEE_1));
RISFPMED_2 = max(0, min(PLAF_ISFRED - RISFDONF_1 - RISFDONCEE_1, RISFPMED_1));
RISFPMEI_2 = max(0, min(PLAF_ISFRED - RISFDONF_1 - RISFDONCEE_1 - RISFPMED_1, RISFPMEI_1));
RISFFIP_2 = max(0, min(PLAF_ISFRED - RISFDONF_1 - RISFDONCEE_1 - RISFPMED_1 - RISFPMEI_1, 
		     RISFFIP_1));
RISFFCPI_2 = max(0, min(PLAF_ISFRED - RISFDONF_1 - RISFDONCEE_1 - RISFPMED_1 - RISFPMEI_1 
		       - RISFFIP_1, RISFFCPI_1 ));





RISFDONF = max( min( RISFDONF_2, ISFBRUT) , 0) 
             * positif(( 1 - null( CODE_2042 - 8 )) * ( 1 - null( CMAJ_ISF - 8)) * ( 1 - null( CMAJ_ISF -34)))
         + max( min( RISFDONF_2, ISFBRUT) , 0) 
             * (1 - positif(( 1-null( CODE_2042 - 8 )) * ( 1-null( CMAJ_ISF - 8)) * ( 1-null( CMAJ_ISF -34)))) * COD9ZA ;
           

RISFDONCEE = max( min( RISFDONCEE_2, ISFBRUT - RISFDONF), 0)
             * positif(( 1 - null( CODE_2042 - 8 )) * ( 1 - null( CMAJ_ISF - 8)) * ( 1 - null( CMAJ_ISF -34)))
           + max( min( RISFDONCEE_2, ISFBRUT - RISFDONF), 0)
             * (1 - positif(( 1-null( CODE_2042 - 8 )) * ( 1-null( CMAJ_ISF - 8)) * ( 1-null( CMAJ_ISF -34)))) * COD9ZA ;



RISFPMED = max( min( RISFPMED_2, ISFBRUT - RISFDONF - RISFDONCEE), 0)
             * positif(( 1 - null( CODE_2042 - 8 )) * ( 1 - null( CMAJ_ISF - 8)) * ( 1 - null( CMAJ_ISF -34)))
         + max( min( RISFPMED_2, ISFBRUT - RISFDONF - RISFDONCEE), 0) 
             * (1 - positif(( 1-null( CODE_2042 - 8 )) * ( 1-null( CMAJ_ISF - 8)) * ( 1-null( CMAJ_ISF -34)))) * COD9ZA ;
            



RISFPMEI = max( min( RISFPMEI_2, ISFBRUT - RISFDONF - RISFDONCEE - RISFPMED), 0)
             * positif(( 1 - null( CODE_2042 - 8 )) * ( 1 - null( CMAJ_ISF - 8)) * ( 1 - null( CMAJ_ISF -34)))
         + max( min( RISFPMEI_2, ISFBRUT - RISFDONF - RISFDONCEE - RISFPMED), 0) 
             * (1 - positif(( 1-null( CODE_2042 - 8 )) * ( 1-null( CMAJ_ISF - 8)) * ( 1-null( CMAJ_ISF -34)))) * COD9ZA ;



RISFFIP = max( min( RISFFIP_2, ISFBRUT - RISFDONF - RISFDONCEE - RISFPMED - RISFPMEI), 0)
             * positif(( 1 - null( CODE_2042 - 8 )) * ( 1 - null( CMAJ_ISF - 8)) * ( 1 - null( CMAJ_ISF -34)))
         + max( min( RISFFIP_2, ISFBRUT - RISFDONF - RISFDONCEE - RISFPMED - RISFPMEI), 0) 
             * (1 - positif(( 1-null( CODE_2042 - 8 )) * ( 1-null( CMAJ_ISF - 8)) * ( 1-null( CMAJ_ISF -34)))) * COD9ZA ;



RISFFCPI = max( min( RISFFCPI_2, ISFBRUT - RISFDONF - RISFDONCEE 
		                         - RISFPMED - RISFPMEI - RISFFIP ), 0)
             * positif(( 1 - null( CODE_2042 - 8 )) * ( 1 - null( CMAJ_ISF - 8)) * ( 1 - null( CMAJ_ISF -34)))
         + max( min( RISFFCPI_2, ISFBRUT - RISFDONF - RISFDONCEE
		                         - RISFPMED - RISFPMEI - RISFFIP ), 0)
             * (1 - positif(( 1-null( CODE_2042 - 8 )) * ( 1-null( CMAJ_ISF - 8)) * ( 1-null( CMAJ_ISF -34)))) * COD9ZA ;



regle isf 77066:
application : iliad , batch  ;
REDISF = RISFDONF + RISFDONCEE + RISFPMED
         + RISFPMEI + RISFFIP + RISFFCPI ;

TXTOISF = RETXISF + COPETOISF ;

regle isf 77065:
application : iliad , batch  ;
ISFTRED =  RISFDONF + RISFDONCEE + RISFPMED
         + RISFPMEI + RISFFIP + RISFFCPI + RISFE ;

regle isf 77070:
application : iliad , batch  ;
ISFNETRED = max(0, ISFBRUT - RISFDONF - RISFDONCEE - RISFPMED - RISFPMEI - RISFFIP - RISFFCPI) ;   

regle isf 77075:
application : iliad , batch  ;
DISFPLAF = ISFPLAF ; 

RISFPLAF = max(0,  ISFNETRED * positif(ISFPLAF - ISFNETRED)
		 + ISFPLAF * (1-positif(ISFPLAF - ISFNETRED)));

regle isf 77076:
application : iliad , batch  ;
ISFPOSTPLAF = max(0, ISFNETRED - RISFPLAF); 

regle isf 77080:
application : iliad , batch  ;
DISFE = ISFETRANG ;

RISFE = positif(DISFBASE)*positif(ISFETRANG)*( min(ISFPOSTPLAF , ISFETRANG));

regle isf 77090:
application : iliad , batch  ;

ISF5 = max(0, ISFPOSTPLAF - RISFE) ;

regle isf 77200:
application : iliad , batch  ;

COPETOISF = si (CMAJ_ISF = 7 ou CMAJ_ISF = 17 ou CMAJ_ISF = 18)
            alors (10)
	    sinon
		 ( si (CMAJ_ISF = 8 ou CMAJ_ISF = 34)
		       alors (40)
		       finsi )
            finsi;

NMAJISF1 = max (0, MAJO1728ISF + arr(ISF5 * COPETOISF/100) * positif_ou_nul(ISF5 - SEUIL_12)
                + FLAG_TRTARDIF * MAJOISFTARDIF_D 
               + FLAG_TRTARDIF_F * MAJOISFTARDIF_D
	       - FLAG_TRTARDIF_F * ( positif(FLAG_RECTIF) * MAJOISFTARDIF_R
				    + (1 - positif(FLAG_RECTIF)) * MAJOISFTARDIF_A)
	       );



TXPF1728ISF =si (V_CODPF1728ISF=07 ou V_CODPF1728ISF=17 ou V_CODPF1728ISF=18)
	     alors (10)
	     sinon
	          (si (V_CODPF1728ISF=08 ou V_CODPF1728ISF=34)
	           alors (40)
		   finsi)
	     finsi ;


MAJTXISF1 = (1 - positif(V_NBCOD1728ISF))
             * ((1 - positif(CMAJ_ISF)) * positif(NMAJISF1) * TXPF1728ISF + positif(CMAJ_ISF) * COPETOISF)
             + positif(V_NBCOD1728ISF) * (-1) ;
regle isf 77210:
application : iliad , batch  ;
INTMSISF = inf( MOISAN_ISF / 10000 );
INTANISF = (( MOISAN_ISF/10000 - INTMSISF )*10000)  * present(MOISAN_ISF) ;
TXINTISF =  (max(0, (INTANISF - (V_ANREV+1) )* 12 + INTMSISF - 6 ) * TXMOISRETARD2)
	    * present(MOISAN_ISF);
PTOISF = arr(ISF5 * COPETOISF / 100) + arr(ISF5 * TXINTISF / 100) ;
RETISF = (RETISF2 + arr(ISF5 * TXINTISF/100))* positif_ou_nul(ISF4BIS - SEUIL_12) ;
RETXISF = positif(CMAJ_ISF) * TXINTISF
               + (TXINRISF * (1-positif(TXINRISF_A)) + (-1) * positif(TXINRISF_A) * positif(TXINRISF) 
		   * positif(positif(TXINRISF - TXINRISF_A)+positif(TXINRISF_A-TXINRISF)))
               + (TXINRISF * positif(TXINRISF_A) * null(TXINRISF - TXINRISF_A))
               ;


NATMAJISF = positif(positif(RETISF) * positif(NMAJISF1)+positif(NMAJISF1))
	    + 2 * positif(RETISF) * (1-positif(NMAJISF1));

regle isf 77215:
application : iliad , batch  ;



PISF = ( INCISF_NET 
	 + NMAJISF1 
         + arr(ISF5 * TXINTISF / 100) * (1-positif(FLAG_PRIM+FLAG_RETARD+FLAG_DEFAUT))) ;

regle isf 77219 :
application : iliad , batch ;

NAPISFTOT = ISF5 + PISF ;

regle isf 77220:
application : iliad , batch ;

ISFNET = NAPISFTOT ; 

regle isf 77221:
application : iliad , batch ;

ISFNAP = ISFCUM - V_ANTISF ;

regle isf 77230:
application : iliad, batch ;

ILI_SYNT_ISF = (1 - positif_ou_nul(ISF4BIS - SEUIL_12)) * null(V_ANTISF+0) * ISF4BIS
               + positif_ou_nul(ISF4BIS - SEUIL_12) * ISF4BIS ;
               

regle isf 77270:
application : iliad, batch ;


ISF4BIS= max( 0, ISF5 ) ; 

