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

regle 8200:
application : iliad , batch  ;
LIMIT12 = 18000 + max(0, arr( max(0, RI1 + TONEQUO1) * (4/100))) 
		     * (1 - positif((VARRMOND * positif(ART1731BIS) + RMOND * (1 - ART1731BIS))))
	        + max(0, 
		      arr( max(0, 
				(VARRMOND * positif(ART1731BIS) + RMOND * (1 - ART1731BIS)) 
				 + TONEQUOM1
			      )* (4/100))
		      ) 
		      * positif( (VARRMOND * positif(ART1731BIS) + RMOND * (1 - ART1731BIS)) );
LIMIT11 = 18000 + max(0, arr( max(0, RI1 + TONEQUO1) * (6/100))) 
		     * (1 - positif( (VARRMOND * positif(ART1731BIS) + RMOND * (1 - ART1731BIS))))
	        + max(0, 
		      arr( max(0, 
			        (VARRMOND * positif(ART1731BIS) + RMOND * (1 - ART1731BIS)) 
				  + TONEQUOM1
			      ) * (6/100))
		      ) 
		      * positif( (VARRMOND * positif(ART1731BIS) + RMOND * (1 - ART1731BIS)) );
LIMIT10 = 20000 + max(0, arr( max(0, RI1 + TONEQUO1) * (8/100))) 
		     * (1 - positif( (VARRMOND * positif(ART1731BIS) + RMOND * (1 - ART1731BIS))))
	        + max(0, 
		      arr( max(0,
				(VARRMOND * positif(ART1731BIS) + RMOND * (1 - ART1731BIS))
				  + TONEQUOM1
			      ) * (8/100))
		     ) 
		     * positif( (VARRMOND * positif(ART1731BIS) + RMOND * (1 - ART1731BIS)));
LIMIT9 = 25000 + max(0, arr( max(0, RI1 + TONEQUO1) * (10/100))) 
		    * (1 - positif( (VARRMOND * positif(ART1731BIS) + RMOND * (1 - ART1731BIS))))
               + max(0, 
		     arr( max(0,
			       (VARRMOND * positif(ART1731BIS) + RMOND * (1 - ART1731BIS))
				 + TONEQUOM1
			     ) * (10/100))
		    ) 
		    * positif( (VARRMOND * positif(ART1731BIS) + RMOND * (1 - ART1731BIS)));
		     
regle 8201:
application : iliad , batch  ;
NAPSANSPENA = NAPTIR - (PIR+PTAXA+PPCAP+PHAUTREV+PTAXLOY) * positif(abs(NAPTIR)) ; 
AVFISCO = V_NAPTEO * (1 - 2 * V_NEGTEO) - NAPSANSPENA ;

regle 8202:
application : iliad , batch  ;
AVFISCOPTER = AVPLAF9 + AVPLAF10 + AVPLAF11 + AVPLAF12 + AVPLAF13 ;
regle 82463:
application : iliad , batch  ;

A13RSOC = max(0, arr( RSOC4+RSOC8 + RSOC34+RSOC38 - ( RSOC4+RSOC8 + RSOC34+RSOC38 )*(TX65/100))
             ) * (1 - V_CNR) * (1-ART1731BIS) ;

regle 82462:
application : iliad , batch  ;


A12RSOC = max(0, arr(RSOC3+RSOC7 + RSOC26+RSOC30 + RSOC33+RSOC37 
                      - ( RSOC3+RSOC7 + RSOC26+RSOC30 + RSOC33+RSOC37 )*(TX65/100))
             ) * (1 - V_CNR) * (1-ART1731BIS); 

regle 82461:
application : iliad , batch  ;

A11RSOC = max(0, arr( RSOC2+RSOC6 + RSOC19+RSOC22 + RSOC25+RSOC29 + RSOC32+RSOC36
                      - (RSOC2+RSOC6 + RSOC19+RSOC22 + RSOC25+RSOC29 + RSOC32+RSOC36)*(TX65/100))

             ) * (1-ART1731BIS) * (1 - V_CNR);


regle 8246:
application :  iliad , batch  ;

A10RSOC = max(0, arr( RSOC1+RSOC5 + RSOC14+RSOC16 + RSOC18+RSOC21 + RSOC24+RSOC28 + RSOC31+RSOC35
                      - (RSOC1+RSOC5 + RSOC14+RSOC16 + RSOC18+RSOC21 + RSOC24+RSOC28 + RSOC31+RSOC35)*(TX65/100)) 

             )*(1-ART1731BIS) * (1 - V_CNR);


regle 82473:
application : iliad , batch  ;


A13RENT1 = ( RENT18 + RENT24 + RLOC106 + RLOC112  
           + max (0 , RENT12+RENT36 + RENT06+RENT30 +
                      RLOC100+RLOC124 + RLOC94+RLOC120
                    - ( arr((RENT12+RENT36)*(5263/10000)) + arr((RENT06+RENT30)*(625/1000)) +
                        arr((RLOC100+RLOC124)*(5263/10000)) + arr((RLOC94+RLOC120)*(625/1000))
                       ))
             ) * (1 - V_CNR);

A13RENT = max(0, A13RENT1 * (1-ART1731BIS) + min( A13RENT1731+0 , A13RENT1 ) *ART1731BIS ) * (1 - V_CNR);


regle 82472:
application : iliad , batch  ;


A12RENT1 = ( RENT17 + RENT23 + RLOC105 + RLOC111 + RLOC67 + RLOC74
           + max (0 , RENT11+RENT35 + RENT05+RENT29
                    + RLOC60+RLOC88 + RLOC53+RLOC81 + RLOC99+RLOC123 + RLOC93+RLOC119
                    - (arr((RENT11+RENT35)*(5263/10000)) + arr((RENT05+RENT29)*(625/1000)) +
                       arr((RLOC60+RLOC88)*(5263/10000)) + arr((RLOC53+RLOC81)*(625/1000)) +
                       arr((RLOC99+RLOC123)*(5263/10000)) + arr((RLOC93+RLOC119)*(625/1000))))
            ) * (1 - V_CNR);

A12RENT = max(0, A12RENT1 * (1-ART1731BIS) + min( A12RENT1731+0 , A12RENT1 ) *ART1731BIS ) * (1 - V_CNR);

regle 82471:
application : iliad , batch  ;

A11RENT1 = ( RENT14+RENT20+RENT16+RENT22+RLOC102+RLOC108+RLOC104+RLOC110  
            +RLOC34+RLOC63+RLOC70+RLOC66+RLOC73 
           + max (0 , RLOC29+RLOC44 + RLOC24+RLOC39 + RLOC56+RLOC84 + RLOC49+RLOC77
                    + RLOC59+RLOC87 + RLOC52+RLOC80
                    + RENT08+RENT32 + RENT02+RENT26 + RENT10+RENT34 + RENT04+RENT28
                    + RLOC96+RLOC116 + RLOC90+RLOC114 + RLOC98+RLOC122 + RLOC92+RLOC118

                   - ( arr((RLOC29+RLOC44)*(5263/10000)) + arr((RLOC24+RLOC39)*(625/1000)) +
                       arr((RLOC56+RLOC84)*(5263/10000)) + arr((RLOC49+RLOC77)*(625/1000)) +
                       arr((RLOC59+RLOC87)*(5263/10000)) + arr((RLOC52+RLOC80)*(625/1000)) +
                       arr((RENT08+RENT32)*(5263/10000)) + arr((RENT02+RENT26)*(625/1000)) +
                       arr((RENT10+RENT34)*(5263/10000)) + arr((RENT04+RENT28)*(625/1000)) +
                       arr((RLOC96+RLOC116)*(5263/10000))+ arr((RLOC90+RLOC114)*(625/1000))+
                       arr((RLOC98+RLOC122)*(5263/10000))+ arr((RLOC92+RLOC118)*(625/1000))))
            ) * (1 - V_CNR);

A11RENT = max(0, A11RENT1 * (1-ART1731BIS) + min( A11RENT1731+0 , A11RENT1 ) *ART1731BIS ) * (1 - V_CNR);

regle 8247:
application : iliad , batch  ;

A10RENT1 = ( RENT13+RENT19+RENT15+RENT21+RLOC101+RLOC107+RLOC103+RLOC109 
             +RLOC13+RLOC31+RLOC33+RLOC62+RLOC69+RLOC65+RLOC72 
           + max (0 , RLOC11+RLOC17 + RLOC09+RLOC15 + RLOC26+RLOC41 + RLOC21+RLOC36 + RLOC28+RLOC43 
                    + RLOC55+RLOC83 + RLOC48+RLOC76 + RLOC58+RLOC86 + RLOC51+RLOC79 + RLOC23+RLOC38
                    + RENT07+RENT31 + RENT01+RENT25 + RENT09+RENT33 + RENT03+RENT27
                    + RLOC95+RLOC115 + RLOC89+RLOC113 + RLOC97+RLOC121 + RLOC91+RLOC117

                    - (arr((RLOC11+RLOC17)*(50/100)) + arr((RLOC09+RLOC15)*(60/100)) +
                       arr((RLOC26+RLOC41)*(50/100)) + arr((RLOC21+RLOC36)*(60/100)) +
                       arr((RLOC55+RLOC83)*(50/100)) + arr((RLOC48+RLOC76)*(60/100)) +
                       arr((RLOC28+RLOC43)*(5263/10000)) + arr((RLOC23+RLOC38)*(625/1000)) +
                       arr((RLOC58+RLOC86)*(5263/10000)) + arr((RLOC51+RLOC79)*(625/1000)) +
                       arr((RENT07+RENT31)*(5263/10000)) + arr((RENT01+RENT25)*(625/1000))+
                       arr((RENT09+RENT33)*(5263/10000)) + arr((RENT03+RENT27)*(625/1000))+
                       arr((RLOC95+RLOC115)*(5263/10000)) + arr((RLOC89+RLOC113)*(625/1000)) +
                       arr((RLOC97+RLOC121)*(5263/10000)) + arr((RLOC91+RLOC117)*(625/1000))))
            ) * (1 - V_CNR);

A10RENT = max(0, A10RENT1 * (1-ART1731BIS) + min( A10RENT1731+0 , A10RENT1 ) *ART1731BIS ) * (1 - V_CNR);

regle 82492:
application : iliad , batch  ;

PLAFRED_FORTRA = max( 0, PLAF_FOREST1 * (1 + BOOL_0AM) - ACOTFOR);

BASE7UXI = max(0, min (REPSINFOR+REPFOR + REPSINFOR1+REPFOR1 + REPSINFOR2 + REPFOR2+REPSINFOR2+ REPFOR3+REPSINFOR4 , PLAFRED_FORTRA)
			   - (REPSINFOR+REPFOR + REPSINFOR1+REPFOR1 + REPSINFOR2 + REPFOR2+REPSINFOR2)) * (1 - V_CNR) ;

BA13UXI = arr((BASE7UXI)* TX18 / 100 );
regle 824921:
application : iliad , batch  ;
A13UXI = max(0, min( BA13UXI ,IDOM11-DEC11-RCOTFOR-RREPA-RAIDE-RDIFAGRI-RFORET-RFIPDOM-RFIPC-RCINE
                                          -RRESTIMO-RSOCREPR-RRPRESCOMP-RHEBE-RSURV-RINNO-RSOUFIP-RRIRENOV
                                          -RLOGDOM-RCREAT-RCOMP-RRETU-RDONS-RDUFLOTOT-RPINELTOT-RNOUV-RPLAFREPME4
                                          -A9RFOR-A10RFOR-A11RFOR-A12RFOR )
             ) * (1-ART1731BIS) ;

regle 824922:
application : iliad , batch  ;

BASE7UN = (min (RDFOREST, PLAF_FOREST * (1 + BOOL_0AM))) * (1 - V_CNR) ;
BA14UN  = arr(BASE7UN * TX18 / 100 ) ;

A14UN = max(0,
	       min( BA14UN ,IDOM11-DEC11-RCOTFOR-RREPA-RAIDE-RDIFAGRI-RFORET-RFIPDOM-RFIPC-RCINE
                                          -RRESTIMO-RSOCREPR-RRPRESCOMP-RHEBE-RSURV-RINNO-RSOUFIP-RRIRENOV
                                          -RLOGDOM-RCREAT-RCOMP-RRETU-RDONS-RDUFLOTOT-RPINELTOT-RNOUV-RPLAFREPME4
                                          -A9RFOR-A10RFOR-A11RFOR-A12RFOR-A13UXI) 
             ) * (1-ART1731BIS) ;



regle 824923:
application : iliad , batch  ;
A13RFOR = ( A13UXI + A14UN ) * (1-ART1731BIS) ; 


        
regle 824910:
application : iliad , batch  ;

BASE7UWH = max(0, min (REPFOR+REPSINFOR + REPFOR1+REPSINFOR1 + REPFOR2+REPSINFOR2+REPSINFOR3 , PLAFRED_FORTRA)
			   - (REPFOR+REPSINFOR + REPFOR1+REPSINFOR1+REPSINFOR2)) * (1 - V_CNR) ;

BA12RFOR  = arr(BASE7UWH * TX18 / 100 ) ;

A12RFOR = max(0,
	       min( BA12RFOR ,IDOM11-DEC11-RCOTFOR-RREPA-RAIDE-RDIFAGRI-RFORET-RFIPDOM-RFIPC-RCINE
                                          -RRESTIMO-RSOCREPR-RRPRESCOMP-RHEBE-RSURV-RINNO-RSOUFIP-RRIRENOV
                                          -RLOGDOM-RCREAT-RCOMP-RRETU-RDONS-RDUFLOTOT-RPINELTOT-RNOUV-RPLAFREPME4
                                          -A9RFOR-A10RFOR-A11RFOR)

             ) * (1-ART1731BIS) ;

regle 82491:
application : iliad , batch  ;

BASE7UVG = max(0, min (REPFOR + REPSINFOR + REPFOR1 + REPSINFOR1 + REPSINFOR2 , PLAFRED_FORTRA)
			   - (REPFOR + REPSINFOR + REPSINFOR1)) * (1 - V_CNR) ;

BA11RFOR  = arr(BASE7UVG * TX22 / 100 ) ;

A11RFOR = max(0,
	       min( BA11RFOR ,IDOM11-DEC11-RCOTFOR-RREPA-RAIDE-RDIFAGRI-RFORET-RFIPDOM-RFIPC-RCINE
                                          -RRESTIMO-RSOCREPR-RRPRESCOMP-RHEBE-RSURV-RINNO-RSOUFIP-RRIRENOV
                                          -RLOGDOM-RCREAT-RCOMP-RRETU-RDONS-RDUFLOTOT-RPINELTOT-RNOUV-RPLAFREPME4
                                          -A9RFOR-A10RFOR)
             ) * (1-ART1731BIS) ;


regle 8249:
application : iliad , batch  ;
BASE7UTF = max(0, min (REPFOR + REPSINFOR + REPSINFOR1, PLAFRED_FORTRA) - REPSINFOR)
            * (1 - V_CNR) ;

BA10RFOR  = arr(BASE7UTF * TX25 / 100 ) ;

A10RFOR = max(0,
	       min( BA10RFOR ,IDOM11-DEC11-RCOTFOR-RREPA-RAIDE-RDIFAGRI-RFORET-RFIPDOM-RFIPC-RCINE
                                          -RRESTIMO-RSOCREPR-RRPRESCOMP-RHEBE-RSURV-RINNO-RSOUFIP-RRIRENOV
                                          -RLOGDOM-RCREAT-RCOMP-RRETU-RDONS-RDUFLOTOT-RPINELTOT-RNOUV-RPLAFREPME4
                                          -A9RFOR )
             ) * (1-ART1731BIS) ;


regle 82500:
application : iliad , batch  ;

BA9RFOR  = arr( min ( REPSINFOR , PLAFRED_FORTRA) * TX25 / 100 ) * (1 - V_CNR) ;

A9RFOR = max(0,
	       min( BA9RFOR ,IDOM11-DEC11-RCOTFOR-RREPA-RAIDE-RDIFAGRI-RFORET-RFIPDOM-RFIPC-RCINE
                                          -RRESTIMO-RSOCREPR-RRPRESCOMP-RHEBE-RSURV-RINNO-RSOUFIP-RRIRENOV
                                          -RLOGDOM-RCREAT-RCOMP-RRETU-RDONS-RDUFLOTOT-RPINELTOT-RNOUV-RPLAFREPME4) 
             ) * (1-ART1731BIS) ;



regle 8252:
application : iliad , batch  ;
A10TOURSOC_1 = RTOURREP*positif(REPINVTOU)
             + RTOUHOTR*positif(INVLOGHOT) * (1-positif(null(2-V_REGCO)+null(4-V_REGCO)))
             + RTOUREPA*positif(INVLOGREHA);

A10TOURSOC = max(0, A10TOURSOC_1 * (1-ART1731BIS)
                  + min(A10TOURSOC1731+0 , A10TOURSOC_1) * ART1731BIS
                );

regle 8250:
application : iliad , batch  ;

A13REELA =  RCOTFOR
         + RFIPDOM + RAIDE
	 + RFIPC  
         + RINNO + RSOUFIP + RRIRENOV 
         + RDUFLOEKL
         + RPINELTOT
         + A13RFOR 
           + arr(RSNCF + RSNCU + RSNCC + RSNCR + RPLAFREPME4)
	 + RCODOU
           + CIDEVDUR + CIGARD + CIADCRE 
	   + CIHABPRIN + CILOYIMP 
           + CIFORET


         +  RDUFREPFI
         +  RDUFLOGIH
	 + RCODJT
         + RILMPE + RILMOA
        + RPATNAT ;


A13REELB = RCINE 
           + RLOG32 + RLOG39
           + A13RSOC
           + A13RENT ;

regle 8254:
application : iliad , batch  ;


AUBAINE13A = max(0, min(V_A13REELA, V_DIFTEOREEL)) ;
AUBAINE13B = max(0, min(V_A13REELB, V_DIFTEOREEL - AUBAINE13A)) ;

regle 8255:
application : iliad , batch  ;

A12REEL = A12RFOR 

          + A12RRESTIMO

         + RLOG25 * (1-ART1731BIS) + min (RLOG251731+0 , RLOG25) * ART1731BIS
         + RLOG31 * (1-ART1731BIS)
         + RLOG38 * (1-ART1731BIS)

         + RTOURREP * positif(COD7UY) + RTOUREPA * positif(COD7UZ)

          + arr( RSNCN + RSNCQ )

         + RCELRREDMG + RCELRREDMH
         + RCELREPGV + RCELREPGJ
         + RCELREPYJ + RCELREPYB + RCELREPYI + RCELREPYA
         + RCELJOQR + RCEL2012 + RCELFD + RCELFABC 

         + RCODIF + RCODIG + RCODID
         + RILMJV + RILMJS + RCODJU
         + RILMPD + RILMOB

        + RPATNAT3

        + A12RSOC   

        + A12RENT ;

regle 8256:
application : iliad , batch  ;

AUBAINE12 = max( 0, min( V_A12REEL , V_DIFTEOREEL - AUBAINE13A - AUBAINE13B ))   ;

regle 8260:
application : iliad , batch  ;
A11REEL = (RLOG16 + RLOG21 + RLOG24) * (1 - ART1731BIS)
	  + (min(RLOG161731+0,RLOG16) + min(RLOG211731+0,RLOG21) + min(RLOG241731+0, RLOG24)) * ART1731BIS
          + RLOG28 + RLOG30
          + RLOG35 +RLOG37


        + A11RSOC

         + arr( RSNCM )

        + RCELRREDLF + RCELRREDLZ + RCELRREDLX
        + RCELREPHG + RCELREPHA + RCELREPGW + RCELREPGL + RCELREPGK 
        + RCELREPYK + RCELREPYD + RCELREPYC
        + RCELCOM + RCEL + RCELJP + RCELJBGL

        + RCODIE + RCODIN + RCODIV + RCODIJ
        + RILMIZ + RILMIA  
        + RILMJI + RILMJW
        + RILMPC + RILMOC

         + RTOURREP*positif(INVLOCXN) + RTOUREPA*positif(INVLOCXV)

        + RPATNAT2  

        + A11RENT

        + A11RFOR ;
regle 8261:
application : iliad , batch  ;

AUBAINE11 = max( 0, min( V_A11REEL , V_DIFTEOREEL - AUBAINE13A-AUBAINE13B-AUBAINE12 ));
regle 8262:
application : iliad , batch  ;


A10REEL = (RLOG11 + RLOG13 + RLOG15 + RLOG18 + RLOG20 + RLOG23 + RLOG26 + RLOG27 + RLOG29) * (1-ART1731BIS)
	  + (min(RLOG111731+0, RLOG11) + min(RLOG131731+0 , RLOG13) + min(RLOG151731+0, RLOG15)
	    + min(RLOG181731+0, RLOG18) + min(RLOG201731+0, RLOG20) + min(RLOG231731+0, RLOG23)) * ART1731BIS
          + RLOG33 + RLOG34 + RLOG36
          

         + A10RSOC  

          + arr( RSNCL ) 

         + A10RENT 

         + RCELRREDLC + RCELRREDLD + RCELRREDLS + RCELRREDLT
         + RCELREPHW + RCELREPHV + RCELREPHD + RCELREPHH 
         + RCELREPHB + RCELREPGX + RCELREPGS + RCELREPGP 
         + RCELREPYL + RCELREPYF + RCELREPYE
	 + RCELHJK + RCELNQ + RCELNBGL

         + RINVRED + RREPMEU + RCODIM
	 + RCODIL 
	 + RILMIH + RILMIB + RILMJC +RILMJX 
         + RILMPB + RILMOD

         + A10TOURSOC

	 + RPATNAT1

         + A10RFOR ;

regle 8263:
application : iliad , batch  ;
 
AUBAINE10 = max( 0, min( V_A10REEL , V_DIFTEOREEL - AUBAINE13A-AUBAINE13B-AUBAINE12-AUBAINE11 ));

regle 8280:
application : iliad , batch  ;

AUBAINE9 = max(0, V_DIFTEOREEL - AUBAINE13A - AUBAINE13B - AUBAINE12 - AUBAINE11 - AUBAINE10);
regle 8290:
application : iliad , batch  ;
AVPLAF13A = max(0, AUBAINE13A - LIM10000 ) * positif(V_DIFTEOREEL) ;

AVPLAF13B = max(0, min(AUBAINE13A , LIM10000) + AUBAINE13B - LIM18000 ) * positif(V_DIFTEOREEL) ;

AVPLAF13 = AVPLAF13A + AVPLAF13B;

AVPLAF12 = max(0, AUBAINE13A + AUBAINE13B + AUBAINE12 
                  - AVPLAF13 - LIMIT12) * positif(V_DIFTEOREEL);

AVPLAF11 = max(0, AUBAINE13A + AUBAINE13B + AUBAINE12 + AUBAINE11 
                  - AVPLAF13 - AVPLAF12 - LIMIT11) * positif(V_DIFTEOREEL);

AVPLAF10 = max(0, AUBAINE13A + AUBAINE13B + AUBAINE12 + AUBAINE11 + AUBAINE10 
                  - AVPLAF13 - AVPLAF12 - AVPLAF11 - LIMIT10) * positif(V_DIFTEOREEL);

AVPLAF9  = max(0, AUBAINE13A + AUBAINE13B + AUBAINE12 + AUBAINE11 + AUBAINE10 + AUBAINE9 
                  - AVPLAF13 - AVPLAF12 - AVPLAF11 - AVPLAF10 - LIMIT9) * positif(V_DIFTEOREEL);

regle 8321:
application : iliad , batch  ;
RFTEO = RFORDI + RFROBOR; 
regle 8331:
application : iliad , batch  ;


RFNTEO = (RFORDI + RFROBOR - min(
                                     min(RFDORD,RFDORD1731+0) * positif(ART1731BIS) + RFDORD * (1 - ART1731BIS)
                          
			           + min(RFDANT,RFDANT1731+0) * positif(ART1731BIS) + RFDANT * (1 - ART1731BIS) ,
                              
                                    RFORDI + RFROBOR
                                ) 
                           - RFDHIS * (1 - ART1731BIS)      

         ) * present(RFROBOR) + RRFI * (1-present(RFROBOR));

regle 8341:
application : iliad , batch  ;
RRFTEO = RFNTEO;
 



