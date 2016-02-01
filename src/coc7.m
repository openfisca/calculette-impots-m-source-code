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
verif 9611:
application : iliad , batch ;
si
	( 
	CMAJ != 7 et ((APPLI_BATCH = 1 et APPLI_COLBERT = 0)
                    ou APPLI_OCEANS = 1
                    ou (APPLI_ILIAD = 1 et
                          non ( V_CALCULIR+0=1
                               ou (V_NOTRAIT+0) dans (16,23,26,33,36,43,46,53,56)
                              )
                        )
	             )
	)
	ou
	( 
	CMAJ2 != 7 et CMAJ2 != 0 et ((APPLI_BATCH = 1 et APPLI_COLBERT = 0)
                                   ou APPLI_OCEANS = 1
                                   ou (APPLI_ILIAD = 1 et
                                       non ( V_CALCULIR+0=1
                                            ou (V_NOTRAIT+0) dans (16,23,26,33,36,43,46,53,56)
                              )
                        )
	             )
        )
        
alors erreur A96101;
verif 9612:
application : batch , iliad ;
si
       (
       CMAJ non dans ( 7..8 ) et CMAJ non dans (10..11) et CMAJ non dans (17..18)  
     et (  (APPLI_ILIAD = 1 et
                   ( V_CALCULIR + 0 = 1 ou (V_NOTRAIT + 0) dans (16,23,26,33,36,43,46,53,56))
           )
           ou APPLI_COLBERT = 1)
       )
       ou
       (
       CMAJ2 non dans ( 7..8 ) et CMAJ2 non dans (10..11) et CMAJ2 non dans (17..18) et CMAJ2 != 0
     et (  (APPLI_ILIAD = 1 et
                   ( V_CALCULIR + 0 = 1 ou (V_NOTRAIT + 0) dans (16,23,26,33,36,43,46,53,56))
           )
           ou APPLI_COLBERT = 1)
       )
alors erreur A96102;
verif isf 9613:
application : batch , iliad ;

si  
       (
       		( CMAJ_ISF non dans ( 7,8,17,18,34 )  et V_IND_TRAIT+0 = 4 )
   
                ou

       		( CMAJ_ISF non dans ( 0,7,8,17,18,34 )  et V_IND_TRAIT+0 = 5 )
       )
alors erreur A96103;
verif 9621:
application : iliad , batch ;
si
          ( present(CMAJ)=1 et present(MOISAN)=0 )
          ou
          ( present(CMAJ2)=1 et present(MOISAN2)=0 )

alors erreur A96201 ;
verif 9622:
application : iliad , batch ;
si
          (  present(CMAJ)=0 et present(MOISAN)=1)
          ou
          (  present(CMAJ2)=0 et present(MOISAN2)=1)

alors erreur A96202 ;
verif isf 9623:
application : iliad , batch ;
si
          ( present(CMAJ_ISF)=1 et present(MOISAN_ISF)=0 )

alors erreur A96203 ;
verif isf 9624:
application : iliad , batch ;
si
          (  present(CMAJ_ISF)=0 et present(MOISAN_ISF)=1)

alors erreur A96204;
verif 9631:
application : iliad , batch ;
si
        (V_IND_TRAIT > 0 )
       et
        (
        inf(MOISAN/10000) non dans (01..12)
        ou
        inf(MOISAN2/10000) non dans (00..12)
        )
alors erreur A96301;
verif 9632:
application : iliad ;

si (APPLI_COLBERT=0) et (
   (
 arr( (MOISAN/10000 - inf(MOISAN/10000))*10000 ) != V_ANREV+1
et
 arr( (MOISAN/10000 - inf(MOISAN/10000))*10000 ) != V_ANREV+2
et
 arr( (MOISAN/10000 - inf(MOISAN/10000))*10000 ) != V_ANREV+3
et
 arr( (MOISAN/10000 - inf(MOISAN/10000))*10000 ) != V_ANREV+4
   )
   ou
   (
 arr( (MOISAN2/10000 - inf(MOISAN2/10000))*10000 ) != V_ANREV+1
et
 arr( (MOISAN2/10000 - inf(MOISAN2/10000))*10000 ) != V_ANREV+2
et
 arr( (MOISAN2/10000 - inf(MOISAN2/10000))*10000 ) != V_ANREV+3
et
 arr( (MOISAN2/10000 - inf(MOISAN2/10000))*10000 ) != V_ANREV+4
et
 arr( (MOISAN2/10000 - inf(MOISAN2/10000))*10000 ) != 0
   ))
alors erreur A96302 ;
verif 7317:
application : batch ;

si
   APPLI_COLBERT = 1
   et
   (
    arr( (MOISAN/10000 - inf(MOISAN/10000))*10000 ) != V_ANREV+1
    et
    arr( (MOISAN/10000 - inf(MOISAN/10000))*10000 ) != V_ANREV+2
    et
    arr( (MOISAN/10000 - inf(MOISAN/10000))*10000 ) != V_ANREV+3
   )

alors erreur A96302 ;
verif isf 9633:
application : iliad , batch ;
si
        (
                (V_IND_TRAIT+0 = 4 et inf(MOISAN_ISF/10000) non dans (01..12) )
                ou
                (V_IND_TRAIT+0 = 5 et inf(MOISAN_ISF/10000) non dans (01..12) et MOISAN_ISF != 0 )
        )
alors erreur A96303 ;
verif isf 9634:
application : iliad , batch ;
si (APPLI_OCEANS = 0) et
   (
 arr( (MOISAN_ISF/10000 - inf(MOISAN_ISF/10000))*10000 ) != V_ANREV+1
et
 arr( (MOISAN_ISF/10000 - inf(MOISAN_ISF/10000))*10000 ) != V_ANREV+2
et
 arr( (MOISAN_ISF/10000 - inf(MOISAN_ISF/10000))*10000 ) != V_ANREV+3
et
 arr( (MOISAN_ISF/10000 - inf(MOISAN_ISF/10000))*10000 ) != V_ANREV+4
   )

alors erreur A96304 ;
verif isf 73171:
application : batch ;
si (APPLI_COLBERT=1) et  (
 arr( (MOISAN_ISF/10000 - inf(MOISAN_ISF/10000))*10000 ) != V_ANREV+1
et
 arr( (MOISAN_ISF/10000 - inf(MOISAN_ISF/10000))*10000 ) != V_ANREV+2
et
 arr( (MOISAN_ISF/10000 - inf(MOISAN_ISF/10000))*10000 ) != V_ANREV+3
   )
alors erreur A96304 ;
verif 9641:
application : iliad , batch ;
si
	(
       ((inf( DATDEPETR/1000000 ) non dans (01..31)) et V_IND_TRAIT+0 = 4)
ou
       ((inf( DATDEPETR/1000000 ) non dans (01..31)) et V_IND_TRAIT = 5 et DATDEPETR != 0)
	) 
alors erreur A96401;
verif 9642:
application : iliad , batch ;
si
	(
       ((inf( (DATDEPETR/1000000 - inf(DATDEPETR/1000000))*100 ) non dans (01..12)) et (V_IND_TRAIT+0= 4))
ou
       ((inf( (DATDEPETR/1000000 - inf(DATDEPETR/1000000))*100 ) non dans (01..12)) 
		et V_IND_TRAIT = 5 et DATDEPETR != 0)
	) 
alors erreur A96402;
verif 9643:
application : iliad , batch ;
si (
 ((arr( (DATDEPETR/10000 - inf(DATDEPETR/10000))*10000 ) != V_ANREV) et V_IND_TRAIT+0 = 4)
ou
 ((arr( (DATDEPETR/10000 - inf(DATDEPETR/10000))*10000 ) != V_ANREV) 
		et V_IND_TRAIT = 5 et DATDEPETR != 0)
   ) 
alors erreur A96403;
verif 9651:
application : iliad , batch ;
si
	(
       ((inf( DATRETETR/1000000) non dans (01..31)) et V_IND_TRAIT+0 = 4)
	ou
       ((inf( DATRETETR/1000000) non dans (01..31)) et V_IND_TRAIT = 5 et DATRETETR != 0)
	) 
alors erreur A96501;
verif 9652:
application : iliad , batch ;
si
	(
       ((inf( (DATRETETR/1000000 - inf(DATRETETR/1000000))*100 ) non dans (01..12)) et V_IND_TRAIT+0 = 4)
	ou
       ((inf( (DATRETETR/1000000 - inf(DATRETETR/1000000))*100 ) non dans (01..12)) 
	et V_IND_TRAIT = 5 et DATRETETR != 0)
	) 
alors erreur A96502 ;
verif 9653:
application : iliad , batch ;
si (
 ((arr( (DATRETETR/10000 - inf(DATRETETR/10000))*10000 ) != V_ANREV) et V_IND_TRAIT+0 = 4)
ou
 ((arr( (DATRETETR/10000 - inf(DATRETETR/10000))*10000 ) != V_ANREV) 
            et V_IND_TRAIT = 5 et DATRETETR != 0)
   ) 
alors erreur A96503 ;
verif 966:
application : iliad , batch ;

si
   DATDEPETR > 0 
   et 
   DATRETETR > 0
	 
alors erreur A966 ;
verif isf 967:
application : iliad , batch ;

si
   V_ZDC = 4
   et
   positif(V_0AZ + 0) = 1
   et
   positif(ISFBASE + 0) = 1

alors erreur A967 ;
verif isf 9801:
application : iliad , batch ;

si
   V_NOTRAIT + 0 < 14
   et
   V_IND_TRAIT + 0 = 4
   et
   ISFBASE <= LIM_ISFINF

alors erreur A98001 ;
verif isf 9802:
application :  iliad , batch ;

si
   V_NOTRAIT + 0 < 14
   et
   V_IND_TRAIT + 0 = 4
   et
   ISFBASE >= LIM_ISFSUP

alors erreur A98002 ;
verif isf 9803:
application : iliad ;

si
   ((V_NOTRAIT + 0 = 14) ou (V_NOTRAIT+0 = 16))
   et
   present(ISFBASE) = 1
   et
   ISFBASE + 0 <= LIM_ISFINF

alors erreur A98003 ;
verif isf 9804:
application : iliad ;

si
   ISFBASE + 0 != 0
   et
   V_NOTRAIT + 0 > 20
   et
   ISFBASE + 0 <= LIM_ISFINF

alors erreur A98004 ;
verif isf 9805:
application : iliad ;

si
   V_NOTRAIT + 0 > 13
   et
   ISFBASE + 0 >= LIM_ISFSUP

alors erreur A98005 ;
verif isf 981:
application : iliad , batch ;


si
   present(ISFBASE) = 0
   et
   (ISFPMEDI + ISFPMEIN + ISFFIP + ISFFCPI + ISFDONF + ISFPLAF + ISFVBPAT + ISFDONEURO + ISFETRANG + ISFCONCUB + ISFPART + 0) > 0

alors erreur A981 ;
verif isf 982:
application : batch ,iliad ;

si
   V_IND_TRAIT + 0 > 0
   et
   positif(ISF_LIMINF + 0) + positif(ISF_LIMSUP + 0) = 2

alors erreur A982 ;
verif isf 983:
application : batch , iliad ;

si (APPLI_OCEANS=0) et
      (
                  (V_IND_TRAIT + 0 = 4)
                  et
                  (
                  positif(ISFCONCUB + 0 ) = 1
                  et
                        (positif(V_0AM + V_0AO + 0 ) = 1
                         ou
                                (positif(V_0AC + V_0AD + V_0AV + 0 )=1
                                 et
                                 positif(V_0AB + 0)= 1
                                )
                        )
                  )
        )
alors erreur A983 ;
verif isf 984:
application : batch , iliad ;

si
      (
                  (V_IND_TRAIT + 0 = 4)
                  et
                  (
                  positif(ISFPART + 0 ) = 1
                  et
                        (positif(V_0AM + V_0AO + 0 ) = 1
                         ou
                                (positif(V_0AC + V_0AD + V_0AV + 0 )=1
                                 et
                                 positif(V_0AB + 0)= 0
                                )
                        )
                   )
        )
alors erreur A984 ;
verif isf 985:
application : batch , iliad ;

si
      positif(ISF_LIMINF + ISF_LIMSUP + 0) = 1
      et
      ISFBASE > LIM_ISFINF
      et
      ISFBASE < LIM_ISFSUP

alors erreur A985 ;
verif isf 986:
application : batch , iliad ;

si
   APPLI_OCEANS = 0
   et
   V_NOTRAIT > 13
   et
   ISFCONCUB + 0 > 0
   et
   ISFPART + 0 > 0

alors erreur A986 ;
verif isf 9871:
application : batch , iliad ;

si
   APPLI_OCEANS = 0
   et
   V_NOTRAIT + 0 = 14
   et
   V_ETCVL + 0 = 1
   et
   ISFCONCUB + ISFPART + 0 = 0

alors erreur A98701 ;
verif isf 9872:
application : batch , iliad ;

si
   APPLI_OCEANS = 0
   et
   V_NOTRAIT + 0 = 14
   et
   present(V_ETCVL) = 1
   et
   V_ETCVL + 0 = 0
   et
   ISFCONCUB + ISFPART + 0 > 0

alors erreur A98702 ;
verif 990:
application : iliad ;

si
   positif(present(RE168) + present(TAX1649)) = 1
   et
   present(IPVLOC) = 1

alors erreur A990 ;
verif 991:
application : iliad ;

si
   positif(FLAGDERNIE+0) = 1
   et
   positif(null(V_NOTRAIT - 23) + null(V_NOTRAIT - 33) + null(V_NOTRAIT - 43) + null(V_NOTRAIT - 53) + null(V_NOTRAIT - 63)) = 1
   et
   NAPCR61 > V_ANTCR

alors erreur A991 ;
verif 9921:
application : iliad ;
si
                      ((DEFRI = 1)  et (PREM8_11 >0) et (VARR30R32>0))
alors erreur A992 ;
verif 9922:
application : iliad ;
si
                      ((DEFRI = 1) et (PREM8_11 =0) et (CODERAPHOR>0))
alors erreur A992 ;
verif 9923:
application : iliad ;
si
                     ( ((DEFRITS = 1) ou (DEFRIGLOBSUP = 1) ou (DEFRIGLOBINF = 1))et
                   (
  SALEXTV
 + COD1AD
 + COD1AE
 + PPEXTV
 + COD1AH
 + COD1BH
 + COD1CH
 + COD1DH
 + COD1EH
 + COD1FH
 + AUTOBICVV
 + AUTOBICPV
 + AUTOBNCV
 + AUTOBICVC
 + AUTOBICPC
 + AUTOBNCC
 + AUTOBICVP
 + AUTOBICPP
 + AUTOBNCP
 + XHONOAAV
 + XHONOV
 + XHONOAAC
 + XHONOC
 + XHONOAAP
 + XHONOP > 0) )

alors erreur A992 ;
verif 10000:
application : iliad ;

   si positif( 4BACREC ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 4BACREC ;
   si positif( 4BACREP ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 4BACREP ;
   si positif( 4BACREV ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0
      alors erreur A99301 4BACREV ;
   si positif( 4BAHREC ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 4BAHREC ;
   si positif( 4BAHREP ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 4BAHREP ;
   si positif( 4BAHREV ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0
      alors erreur A99301 4BAHREV ;
   si positif( ABDETMOINS ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 ABDETMOINS ;
   si positif( ABDETPLUS ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 ABDETPLUS ;
   si positif( ABIMPMV ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0
      alors erreur A99301 ABIMPMV ;
   si positif( ABIMPPV ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 ABIMPPV ;
   si positif( ABPVNOSURSIS ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 ABPVNOSURSIS ;
   si positif( ACODELAISINR ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 ACODELAISINR ;
   si positif( ALLECS ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 ALLECS ;
   si positif( ALLO1 ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0
      alors erreur A99301 ALLO1 ;
   si positif( ALLO2 ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 ALLO2 ;
   si positif( ALLO3 ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 ALLO3 ;
   si positif( ALLO4 ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0
      alors erreur A99301 ALLO4 ;
   si positif( ALLOC ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 ALLOC ;
   si positif( ALLOV ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 ALLOV ;
   si positif( ANOCEP ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0
      alors erreur A99301 ANOCEP ;
   si positif( ANOPEP ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 ANOPEP ;
   si positif( ANOVEP ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 ANOVEP ;
   si positif( ASCAPA ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0
      alors erreur A99301 ASCAPA ;
   si positif( AUTOBICPC ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 AUTOBICPC ;
   si positif( AUTOBICPP ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 AUTOBICPP ;
   si positif( AUTOBICPV ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0
      alors erreur A99301 AUTOBICPV ;
   si positif( AUTOBICVC ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 AUTOBICVC ;
   si positif( AUTOBICVP ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 AUTOBICVP ;
   si positif( AUTOBICVV ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0
      alors erreur A99301 AUTOBICVV ;
   si positif( AUTOBNCC ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 AUTOBNCC ;
   si positif( AUTOBNCP ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 AUTOBNCP ;
   si positif( AUTOBNCV ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0
      alors erreur A99301 AUTOBNCV ;
   si positif( AUTOVERSLIB ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 AUTOBNCV ;
   si positif( AUTOVERSSUP ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 AUTOVERSSUP ;
   si positif( AVETRAN ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0
      alors erreur A99301 AVETRAN ;
   si positif( BA1AC ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 BA1AC ;
   si positif( BA1AP ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 BA1AP ;
   si positif( BA1AV ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0
      alors erreur A99301 BA1AV ;
   si positif( BACDEC ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 BACDEC ;
   si positif( BACDEP ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 BACDEP ;
   si positif( BACDEV ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0
      alors erreur A99301 BACDEV ;
   si positif( BACREC ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 BACREC ;
   si positif( BACREP ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 BACREP ;
   si positif( BACREV ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0
      alors erreur A99301 BACREV ;
   si positif( BAEXC ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 BAEXC ;
   si positif( BAEXP ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 BAEXP ;
   si positif( BAEXV ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0
      alors erreur A99301 BAEXV ;
   si positif( BAF1AC ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 BAF1AC ;
   si positif( BAF1AP ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 BAF1AP ;
   si positif( BAF1AV ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0
      alors erreur A99301 BAF1AV ;
   si positif( BAFC ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 BAFC ;
   si positif( BAFORESTC ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 BAFORESTC ;
   si positif( BAFORESTP ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0
      alors erreur A99301 BAFORESTP ;
   si positif( BAFORESTV ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 BAFORESTV ;
   si positif( BAFP ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 BAFP ;
   si positif( BAFPVC ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0
      alors erreur A99301 BAFPVC ;
   si positif( BAFPVP ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 BAFPVP ;
   si positif( BAFPVV ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 BAFPVV ;
   si positif( BAFV ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0
      alors erreur A99301 BAFV ;
   si positif( BAHDEC ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 BAHDEC ;
   si positif( BAHDEP ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 BAHDEP ;
   si positif( BAHDEV ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0
      alors erreur A99301 BAHDEV ;
   si positif( BAHEXC ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 BAHEXC ;
   si positif( BAHEXP ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 BAHEXP ;
   si positif( BAHEXV ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0
      alors erreur A99301 BAHEXV ;
   si positif( BAHREC ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 BAHREC ;
   si positif( BAHREP ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 BAHREP ;
   si positif( BAHREV ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0
      alors erreur A99301 BAHREV ;
   si positif( BAILOC98 ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 BAILOC98 ;
   si positif( BANOCGAC ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 BANOCGAC ;
   si positif( BANOCGAP ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0
      alors erreur A99301 BANOCGAP ;
   si positif( BANOCGAV ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 BANOCGAV ;
   si positif( BAPERPC ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 BAPERPC ;
   si positif( BAPERPP ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0
      alors erreur A99301 BAPERPP ;
   si positif( BAPERPV ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 BAPERPV ;
   si positif( BASRET ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 BASRET ;
   si positif( BI1AC ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0
      alors erreur A99301 BI1AC ;
   si positif( BI1AP ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 BI1AP ;
   si positif( BI1AV ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 BI1AV ;
   si positif( BI2AC ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0
      alors erreur A99301 BI2AC ;
   si positif( BI2AP ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 BI2AP ;
   si positif( BI2AV ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 BI2AV ;
   si positif( BICDEC ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 BICDEC ;
   si positif( BICDEP ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 BICDEP ;
   si positif( BICDEV ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 BICDEV ;
   si positif( BICDNC ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0
      alors erreur A99301 BICDNC ;
   si positif( BICDNP ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 BICDNP ;
   si positif( BICDNV ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0
      alors erreur A99301 BICDNV ;
   si positif( BICEXC ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0
      alors erreur A99301 BICEXC ;
   si positif( BICEXP ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 BICEXP ;
   si positif( BICEXV ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 BICEXV ;
   si positif( BICHDEC ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0
      alors erreur A99301 BICHDEC ;
   si positif( BICHDEP ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 BICHDEP ;
   si positif( BICHDEV ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0
      alors erreur A99301 BICHDEV ;
   si positif( BICHREC ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0
      alors erreur A99301 BICHREC ;
   si positif( BICHREP ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 BICHREP ;
   si positif( BICHREV ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 BICHREV ;
   si positif( BICNOC ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0
      alors erreur A99301 BICNOC ;
   si positif( BICNOP ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 BICNOP ;
   si positif( BICNOV ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 BICNOV ;
   si positif( BICNPEXC ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0
      alors erreur A99301 BICNPEXC ;
   si positif( BICNPEXP ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 BICNPEXP ;
   si positif( BICNPEXV ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 BICNPEXV ;
   si positif( BICNPHEXC ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0
      alors erreur A99301 BICNPHEXC ;
   si positif( BICNPHEXP ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 BICNPHEXP ;
   si positif( BICNPHEXV ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 BICNPHEXV ;
   si positif( BICPMVCTC ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0
      alors erreur A99301 BICPMVCTC ;
   si positif( BICPMVCTP ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 BICPMVCTP ;
   si positif( BICPMVCTV ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 BICPMVCTV ;
   si positif( BICREC ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0
      alors erreur A99301 BICREC ;
   si positif( BICREP ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 BICREP ;
   si positif( BICREV ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 BICREV ;
   si positif( BIGREST ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0
      alors erreur A99301 BIGREST ;
   si positif( BIHDNC ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 BIHDNC ;
   si positif( BIHDNP ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 BIHDNP ;
   si positif( BIHDNV ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0
      alors erreur A99301 BIHDNV ;
   si positif( BIHEXC ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 BIHEXC ;
   si positif( BIHEXP ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 BIHEXP ;
   si positif( BIHEXV ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0
      alors erreur A99301 BIHEXV ;
   si positif( BIHNOC ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 BIHNOC ;
   si positif( BIHNOP ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 BIHNOP ;
   si positif( BIHNOV ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0
      alors erreur A99301 BIHNOV ;
   si positif( BIPERPC ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 BIPERPC ;
   si positif( BIPERPP ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 BIPERPP ;
   si positif( BIPERPV ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0
      alors erreur A99301 BIPERPV ;
   si positif( BN1AC ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 BN1AC ;
   si positif( BN1AP ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 BN1AP ;
   si positif( BN1AV ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0
      alors erreur A99301 BN1AV ;
   si positif( BNCAABC ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 BNCAABC ;
   si positif( BNCAABP ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 BNCAABP ;
   si positif( BNCAABV ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0
      alors erreur A99301 BNCAABV ;
   si positif( BNCAADC ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0
      alors erreur A99301 BNCAADC ;
   si positif( BNCAADP ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 BNCAADP ;
   si positif( BNCAADV ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0
      alors erreur A99301 BNCAADV ;
   si positif( BNCCRC ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 BNCCRC ;
   si positif( BNCCRFC ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 BNCCRFC ;
   si positif( BNCCRFP ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0
      alors erreur A99301 BNCCRFP ;
   si positif( BNCCRFV ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 BNCCRFV ;
   si positif( BNCCRP ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 BNCCRP ;
   si positif( BNCCRV ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0
      alors erreur A99301 BNCCRV ;
   si positif( BNCDEC ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0
      alors erreur A99301 BNCDEC ;
   si positif( BNCDEP ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 BNCDEP ;
   si positif( BNCDEV ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0
      alors erreur A99301 BNCDEV ;
   si positif( BNCEXC ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 BNCEXC ;
   si positif( BNCEXP ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 BNCEXP ;
   si positif( BNCEXV ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0
      alors erreur A99301 BNCEXV ;
   si positif( BNCNP1AC ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 BNCNP1AC ;
   si positif( BNCNP1AP ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 BNCNP1AP ;
   si positif( BNCNP1AV ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0
      alors erreur A99301 BNCNP1AV ;
   si positif( BNCNPC ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 BNCNPC ;
   si positif( BNCNPDCT ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 BNCNPDCT ;
   si positif( BNCNPDEC ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0
      alors erreur A99301 BNCNPDEC ;
   si positif( BNCNPDEP ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 BNCNPDEP ;
   si positif( BNCNPDEV ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 BNCNPDEV ;
   si positif( BNCNPP ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0
      alors erreur A99301 BNCNPP ;
   si positif( BNCNPPVC ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 BNCNPPVC ;
   si positif( BNCNPPVP ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 BNCNPPVP ;
   si positif( BNCNPPVV ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0
      alors erreur A99301 BNCNPPVV ;
   si positif( BNCNPREXAAC ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 BNCNPREXAAC ;
   si positif( BNCNPREXAAP ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 BNCNPREXAAP ;
   si positif( BNCNPREXAAV ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0
      alors erreur A99301 BNCNPREXAAV ;
   si positif( BNCNPREXC ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 BNCNPREXC ;
   si positif( BNCNPREXP ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 BNCNPREXP ;
   si positif( BNCNPREXV ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0
      alors erreur A99301 BNCNPREXV ;
   si positif( BNCNPV ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 BNCNPV ;
   si positif( BNCPMVCTC ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 BNCPMVCTC ;
   si positif( BNCPMVCTP ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0
      alors erreur A99301 BNCPMVCTP ;
   si positif( BNCPMVCTV ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 BNCPMVCTV ;
   si positif( BNCPRO1AC ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 BNCPRO1AC ;
   si positif( BNCPRO1AP ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0
      alors erreur A99301 BNCPRO1AP ;
   si positif( BNCPRO1AV ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 BNCPRO1AV ;
   si positif( BNCPROC ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 BNCPROC ;
   si positif( BNCPRODEC ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0
      alors erreur A99301 BNCPRODEC ;
   si positif( BNCPRODEP ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 BNCPRODEP ;
   si positif( BNCPRODEV ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 BNCPRODEV ;
   si positif( BNCPROEXC ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0
      alors erreur A99301 BNCPROEXC ;
   si positif( BNCPROEXP ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 BNCPROEXP ;
   si positif( BNCPROEXV ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 BNCPROEXV ;
   si positif( BNCPROP ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0
      alors erreur A99301 BNCPROP ;
   si positif( BNCPROPVC ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 BNCPROPVC ;
   si positif( BNCPROPVP ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 BNCPROPVP ;
   si positif( BNCPROPVV ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0
      alors erreur A99301 BNCPROPVV ;
   si positif( BNCPROV ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 BNCPROV ;
   si positif( BNCREC ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 BNCREC ;
   si positif( BNCREP ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0
      alors erreur A99301 BNCREP ;
   si positif( BNCREV ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 BNCREV ;
   si positif( BNHDEC ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 BNHDEC ;
   si positif( BNHDEP ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0
      alors erreur A99301 BNHDEP ;
   si positif( BNHDEV ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0
      alors erreur A99301 BNHDEV ;
   si positif( BNHEXC ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 BNHEXC ;
   si positif( BNHEXP ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0
      alors erreur A99301 BNHEXP ;
   si positif( BNHEXV ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 BNHEXV ;
   si positif( BNHREC ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 BNHREC ;
   si positif( BNHREP ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0
      alors erreur A99301 BNHREP ;
   si positif( BNHREV ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 BNHREV ;
   si positif( BPCOPTC ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 BPCOPTC ;
   si positif( BPCOPTV ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0
      alors erreur A99301 BPCOPTV ;
   si positif( BPCOSAC ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 BPCOSAC ;
   si positif( BPCOSAV ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 BPCOSAV ;
   si positif( BPV18C ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0
      alors erreur A99301 BPV18C ;
   si positif( BPV18V ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 BPV18V ;
   si positif( BPV40C ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 BPV40C ;
   si positif( BPV40V ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 BPV40V ;
   si positif( BPVRCM ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 BPVRCM ;
   si positif( BPVSJ ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 BPVSJ ;
   si positif( BPVSK ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0
      alors erreur A99301 BPVSK ;
   si positif( BRAS ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 BRAS ;
   si positif( CARPEC ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 CARPEC ;
   si positif( CARPENBAC ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0
      alors erreur A99301 CARPENBAC ;
   si positif( CARPENBAP1 ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 CARPENBAP1 ;
   si positif( CARPENBAP2 ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 CARPENBAP2 ;
   si positif( CARPENBAP3 ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0
      alors erreur A99301 CARPENBAP3 ;
   si positif( CARPENBAP4 ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 CARPENBAP4 ;
   si positif( CARPENBAV ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 CARPENBAV ;
   si positif( CARPEP1 ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0
      alors erreur A99301 CARPEP1 ;
   si positif( CARPEP2 ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 CARPEP2 ;
   si positif( CARPEP3 ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 CARPEP3 ;
   si positif( CARPEP4 ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0
      alors erreur A99301 CARPEP4 ;
   si positif( CARPEV ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 CARPEV ;
   si positif( CARTSC ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 CARTSC ;
   si positif( CARTSNBAC ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0
      alors erreur A99301 CARTSNBAC ;
   si positif( CARTSNBAP1 ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 CARTSNBAP1 ;
   si positif( CARTSNBAP2 ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 CARTSNBAP2 ;
   si positif( CARTSNBAP3 ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0
      alors erreur A99301 CARTSNBAP3 ;
   si positif( CARTSNBAP4 ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 CARTSNBAP4 ;
   si positif( CARTSNBAV ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 CARTSNBAV ;
   si positif( CARTSP1 ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0
      alors erreur A99301 CARTSP1 ;
   si positif( CARTSP2 ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 CARTSP2 ;
   si positif( CARTSP3 ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 CARTSP3 ;
   si positif( CARTSP4 ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0
      alors erreur A99301 CARTSP4 ;
   si positif( CARTSV ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 CARTSV ;
   si positif( CASECHR ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 CASECHR ;
   si positif( CASEPRETUD ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0
      alors erreur A99301 CASEPRETUD ;
   si positif( CBETRAN ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 CBETRAN ;
   si positif( CELLIERHJ ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 CELLIERHJ ;
   si positif( CELLIERHK ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0
      alors erreur A99301 CELLIERHK ;
   si positif( CELLIERHL ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 CELLIERHL ;
   si positif( CELLIERHM ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 CELLIERHM ;
   si positif( CELLIERHN ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0
      alors erreur A99301 CELLIERHN ;
   si positif( CELLIERHO ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 CELLIERHO ;
   si positif( CELLIERJA ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 CELLIERJA ;
   si positif( CELLIERJB ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0
      alors erreur A99301 CELLIERJB ;
   si positif( CELLIERJD ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 CELLIERJD ;
   si positif( CELLIERJE ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 CELLIERJE ;
   si positif( CELLIERJF ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0
      alors erreur A99301 CELLIERJF ;
   si positif( CELLIERJG ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 CELLIERJG ;
   si positif( CELLIERJH ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 CELLIERJH ;
   si positif( CELLIERJJ ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0
      alors erreur A99301 CELLIERJJ ;
   si positif( CELLIERJK ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 CELLIERJK ;
   si positif( CELLIERJL ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 CELLIERJL ;
   si positif( CELLIERJM ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0
      alors erreur A99301 CELLIERJM ;
   si positif( CELLIERJN ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 CELLIERJN ;
   si positif( CELLIERJO ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 CELLIERJO ;
   si positif( CELLIERJP ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0
      alors erreur A99301 CELLIERJP ;
   si positif( CELLIERJQ ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 CELLIERJQ ;
   si positif( CELLIERJR ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 CELLIERJR ;
   si positif( CELLIERNA ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0
      alors erreur A99301 CELLIERNA ;
   si positif( CELLIERNB ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 CELLIERNB ;
   si positif( CELLIERNC ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 CELLIERNC ;
   si positif( CELLIERND ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0
      alors erreur A99301 CELLIERND ;
   si positif( CELLIERNE ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 CELLIERNE ;
   si positif( CELLIERNF ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 CELLIERNF ;
   si positif( CELLIERNG ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0
      alors erreur A99301 CELLIERNG ;
   si positif( CELLIERNH ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 CELLIERNH ;
   si positif( CELLIERNI ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 CELLIERNI ;
   si positif( CELLIERNJ ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0
      alors erreur A99301 CELLIERNJ ;
   si positif( CELLIERNK ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 CELLIERNK ;
   si positif( CELLIERNL ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 CELLIERNL ;
   si positif( CELLIERNM ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0
      alors erreur A99301 CELLIERNM ;
   si positif( CELLIERNN ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 CELLIERNN ;
   si positif( CELLIERNO ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 CELLIERNO ;
   si positif( CELLIERNP ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0
      alors erreur A99301 CELLIERNP ;
   si positif( CELLIERNQ ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 CELLIERNQ ;
   si positif( CELLIERNR ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 CELLIERNR ;
   si positif( CELLIERNS ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0
      alors erreur A99301 CELLIERNS ;
   si positif( CELLIERNT ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 CELLIERNT ;
   si positif( CELLIERFA ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 CELLIERFA ;
   si positif( CELLIERFB) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0
      alors erreur A99301 CELLIERFB ;
   si positif( CELLIERFC) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 CELLIERFC ;
   si positif( CELLIERFD) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0
      alors erreur A99301 CELLIERFD ;
   si positif( CELREPGJ ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 CELREPGJ ;
   si positif( CELREPGK ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 CELREPGK ;
   si positif( CELREPGL ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0
      alors erreur A99301 CELREPGL ;
   si positif( CELREPGP ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 CELREPGP ;
   si positif( CELREPGS ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 CELREPGS ;
   si positif( CELREPGT ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0
      alors erreur A99301 CELREPGT ;
   si positif( CELREPGU ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 CELREPGU ;
   si positif( CELREPGV ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 CELREPGV ;
   si positif( CELREPGW ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0
      alors erreur A99301 CELREPGW ;
   si positif( CELREPGX ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0
      alors erreur A99301 CELREPGX ;
   si positif( CELREPHA ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 CELREPHA ;
   si positif( CELREPHB ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0
      alors erreur A99301 CELREPHB ;
   si positif( CELREPHD ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 CELREPHD ;
   si positif( CELREPHE ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 CELREPHE ;
   si positif( CELREPHF ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0
      alors erreur A99301 CELREPHF ;
   si positif( CELREPHG ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 CELREPHG ;
   si positif( CELREPHH ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 CELREPHH ;
   si positif( CELREPHR ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0
      alors erreur A99301 CELREPHR ;
   si positif( CELREPHS ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 CELREPHS ;
   si positif( CELREPHT ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 CELREPHT ;
   si positif( CELREPHU ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0
      alors erreur A99301 CELREPHU ;
   si positif( CELREPHV ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 CELREPHV ;
   si positif( CELREPHW ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 CELREPHW ;
   si positif( CELREPHX ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0
      alors erreur A99301 CELREPHX ;
   si positif( CELREPHZ ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 CELREPHZ ;
   si positif( CELRREDLA ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 CELRREDLA ;
   si positif( CELRREDLB ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0
      alors erreur A99301 CELRREDLB ;
   si positif( CELRREDLC ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 CELRREDLC ;
   si positif( CELRREDLD ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 CELRREDLD ;
   si positif( CELRREDLE ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0
      alors erreur A99301 CELRREDLE ;
   si positif( CELRREDLF ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 CELRREDLF ;
   si positif( CELRREDLM ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 CELRREDLM ;
   si positif( CELRREDLS ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0
      alors erreur A99301 CELRREDLS ;
   si positif( CELRREDLZ ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 CELRREDLZ ;
   si positif( CELRREDMG ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0
      alors erreur A99301 CELRREDMG ;
   si positif( CESSASSC ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 CESSASSC ;
   si positif( CESSASSV ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0
      alors erreur A99301 CESSASSV ;
   si positif( CHAUBOISN ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 CHAUBOISN ;
   si positif( CHAUFSOL ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0
      alors erreur A99301 CHAUFSOL ;
   si positif( CHENF1 ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 CHENF1 ;
   si positif( CHENF2 ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 CHENF2 ;
   si positif( CHENF3 ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0
      alors erreur A99301 CHENF3 ;
   si positif( CHENF4 ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 CHENF4 ;
   si positif( CHNFAC ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 CHNFAC ;
   si positif( CHRDED ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0
      alors erreur A99301 CHRDED ;
   si positif( CHRFAC ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 CHRFAC ;
   si positif( CIAQCUL ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 CIAQCUL ;
   si positif( CIBOIBAIL ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0
      alors erreur A99301 CIBOIBAIL ;
   si positif( CICORSENOW ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 CICORSENOW ;
   si positif( CIDEP15 ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0
      alors erreur A99301 CIDEP15 ;
   si positif( CIIMPPRO ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 CIIMPPRO ;
   si positif( CIIMPPRO2 ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 CIIMPPRO2 ;
   si positif( CIINVCORSE ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0
      alors erreur A99301 CIINVCORSE ;
   si positif( CINE1 ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 CINE1 ;
   si positif( CINE2 ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 CINE2 ;
   si positif( CINRJ ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0
      alors erreur A99301 CINRJ ;
   si positif( CINRJBAIL ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 CINRJBAIL ;
   si positif( CMAJ ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 CMAJ ;
   si positif( CMAJ_ISF ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0
      alors erreur A99301 CMAJ_ISF ;
   si positif( CO2044P ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 CO2044P ;
   si positif( CO2047 ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 CO2047 ;
   si positif( CO2102 ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0
      alors erreur A99301 CO2102 ;
   si positif( CODCHA ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 CODCHA ;
   si positif( CODSIR ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 CODSIR ;
   si positif( CONVCREA ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0
      alors erreur A99301 CONVCREA ;
   si positif( CONVHAND ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 CONVHAND ;
   si positif( COTF1 ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 COTF1 ;
   si positif( COTF2 ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0
      alors erreur A99301 COTF2 ;
   si positif( COTF3 ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 COTF3 ;
   si positif( COTF4 ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 COTF4 ;
   si positif( COTFC ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0
      alors erreur A99301 COTFC ;
   si positif( COTFORET ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 COTFORET ;
   si positif( COTFV ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 COTFV ;
   si positif( CREAGRIBIO ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0
      alors erreur A99301 CREAGRIBIO ;
   si positif( CREAIDE ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 CREAIDE ;
   si positif( CREAPP ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 CREAPP ;
   si positif( CREARTS ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0
      alors erreur A99301 CREARTS ;
   si positif( CRECHOBOI ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 CRECHOBOI ;
   si positif( CRECONGAGRI ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 CRECONGAGRI ;
   si positif( CREDPVREP ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 CREDPVREP ;
   si positif( CREFAM ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0
      alors erreur A99301 CREFAM ;
   si positif( CREFORMCHENT ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 CREFORMCHENT ;
   si positif( CREINTERESSE ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 CREINTERESSE ;
   si positif( CRENRJ ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0
      alors erreur A99301 CRENRJ ;
   si positif( CREPROSP ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 CREPROSP ;
   si positif( CRERESTAU ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0
      alors erreur A99301 CRERESTAU ;
   si positif( CRIGA ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 CRIGA ;
   si positif( CVNSALAC ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 CVNSALAC ;
   si positif( CVNSALAV ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0
      alors erreur A99301 CVNSALAV ;
   si positif( DABNCNP1 ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 DABNCNP1 ;
   si positif( DABNCNP2 ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 DABNCNP2 ;
   si positif( DABNCNP3 ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0
      alors erreur A99301 DABNCNP3 ;
   si positif( DABNCNP4 ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 DABNCNP4 ;
   si positif( DABNCNP5 ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 DABNCNP5 ;
   si positif( DABNCNP6 ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0
      alors erreur A99301 DABNCNP6 ;
   si positif( DAGRI1 ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0
      alors erreur A99301 DAGRI1 ;
   si positif( DAGRI2 ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 DAGRI2 ;
   si positif( DAGRI3 ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0
      alors erreur A99301 DAGRI3 ;
   si positif( DAGRI4 ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 DAGRI4 ;
   si positif( DAGRI5 ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 DAGRI5 ;
   si positif( DAGRI6 ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0
      alors erreur A99301 DAGRI6 ;
   si positif( DATDEPETR ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 DATDEPETR ;
   si positif( DATOCEANS ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 DATOCEANS ;
   si positif( DATRETETR ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0
      alors erreur A99301 DATRETETR ;
   si positif( DCSG ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 DCSG ;
   si positif( DEFAA0 ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0
      alors erreur A99301 DEFAA0 ;
   si positif( DEFAA1 ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0
      alors erreur A99301 DEFAA1 ; 
   si positif( DEFAA2 ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 DEFAA2 ;
   si positif( DEFAA3 ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 DEFAA3 ;
   si positif( DEFAA4 ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0
      alors erreur A99301 DEFAA4 ;
   si positif( DEFAA5 ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0
      alors erreur A99301 DEFAA5 ;
   si positif( DEFBIC1 ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 DEFBIC1 ;
   si positif( DEFBIC2 ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0
      alors erreur A99301 DEFBIC2 ;
   si positif( DEFBIC3 ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 DEFBIC3 ;
   si positif( DEFBIC4 ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 DEFBIC4 ;
   si positif( DEFBIC5 ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0
      alors erreur A99301 DEFBIC5 ;
   si positif( DEFBIC6 ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 DEFBIC6 ;
   si positif( DEFRCM ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0
      alors erreur A99301 DEFRCM ;
   si positif( DEFRCM2 ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0
      alors erreur A99301 DEFRCM2 ;
   si positif( DEFRCM3 ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 DEFRCM3 ;
   si positif( DEFRCM4 ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 DEFRCM4 ;
   si positif( DEFRCM5 ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0
      alors erreur A99301 DEFRCM5 ;
   si positif( DEFZU ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0
      alors erreur A99301 DEFZU ;
   si positif( DEPCHOBAS ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0
      alors erreur A99301 DEPCHOBAS ;
   si positif( DEPMOBIL ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 DEPMOBIL ;
   si positif( DETS1 ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0
      alors erreur A99301 DETS1 ;
   si positif( DETS2 ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 DETS2 ;
   si positif( DETS3 ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 DETS3 ;
   si positif( DETS4 ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0
      alors erreur A99301 DETS4 ;
   si positif( DETSC ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 DETSC ;
   si positif( DETSV ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 DETSV ;
   si positif( DIAGPERF ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0
      alors erreur A99301 DIAGPERF ;
   si positif( DIREPARGNE ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 DIREPARGNE ;
   si positif( DISQUO ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 DISQUO ;
   si positif( DISQUONB ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0
      alors erreur A99301 DISQUONB ;
   si positif ( DNOCEP ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0
      alors erreur A99301 DNOCEP ;
   si positif ( DNOCEPC ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 DNOCEPC ;
   si positif ( DNOCEPP ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0
      alors erreur A99301 DNOCEPP ;
   si positif( DONAUTRE ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 DONAUTRE ;
   si positif( DONETRAN ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 DONETRAN ;
   si positif( DPVRCM ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0
      alors erreur A99301 DPVRCM ;
   si positif( ELURASC ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0
      alors erreur A99301 ELURASC ;
   si positif( ELURASV ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 ELURASV ;
   si positif( ENERGIEST ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 ENERGIEST ;
   si positif( ESFP ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0
      alors erreur A99301 ESFP ;
   si positif( EXOCETC ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 EXOCETC ;
   si positif( EXOCETV ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 EXOCETV ;
   si positif( FCPI ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0
      alors erreur A99301 FCPI ;
   si positif( FEXC ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 FEXC ;
   si positif( FEXP ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 FEXP ;
   si positif( FEXV ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0
      alors erreur A99301 FEXV ;
   si positif( FFIP ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 FFIP ;
   si positif( FIPCORSE ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 FIPCORSE ;
   si positif( FIPDOMCOM ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0
      alors erreur A99301 FIPDOMCOM ;
   si positif( FONCI ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 FONCI ;
   si positif( FONCINB ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 FONCINB ;
   si positif( FORET ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0
      alors erreur A99301 FORET ;
   si positif( FRN1 ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 FRN1 ;
   si positif( FRN2 ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 FRN2 ;
   si positif( FRN3 ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0
      alors erreur A99301 FRN3 ;
   si positif( FRN4 ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 FRN4 ;
   si positif( FRNC ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 FRNC ;
   si positif( FRNV ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0
      alors erreur A99301 FRNV ;
   si positif( GAINABDET ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 GAINABDET ;
   si positif( GAINPEA ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 GAINPEA ;
   si positif( GLD1C ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 GLD1C ;
   si positif( GLD1V ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0
      alors erreur A99301 GLD1V ;
   si positif( GLD2C ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 GLD2C ;
   si positif( GLD2V ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 GLD2V ;
   si positif( GLD3C ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0
      alors erreur A99301 GLD3C ;
   si positif( GLD3V ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 GLD3V ;
   si positif( GLDGRATC ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 GLDGRATC ;
   si positif( GLDGRATV ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0
      alors erreur A99301 GLDGRATV ;
   si positif( GSALC ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 GSALC ;
   si positif( GSALV ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 GSALV ;
   si positif( IMPRET ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0
      alors erreur A99301 IMPRET ;
   si positif( INAIDE ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 INAIDE ;
   si positif( INDECS ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 INDECS ;
   si positif( INDJNONIMPC ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0
      alors erreur A99301 INDJNONIMPC ;
   si positif( INDJNONIMPV ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 INDJNONIMPV ;
   si positif( INDPVSURSI ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 INDPVSURSI ;
   si positif( IND_TDR ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0
      alors erreur A99301 IND_TDR ;
   si positif( INTDIFAGRI ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 INTDIFAGRI ;
   si positif( INTERE ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 INTERE ;
   si positif( INTERENB ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0
      alors erreur A99301 INTERENB ;
   si positif( INVDIR2009 ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 INVDIR2009 ;
   si positif( INVDOMRET50 ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 INVDOMRET50 ;
   si positif( INVDOMRET60 ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0
      alors erreur A99301 INVDOMRET60 ;
   si positif( INVENDEB2009 ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 INVENDEB2009 ;
   si positif( INVENDI ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 INVENDI ;
   si positif( INVENTC ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0
      alors erreur A99301 INVENTC ;
   si positif( INVENTP ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 INVENTP ;
   si positif( INVENTV ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 INVENTV ;
   si positif( INVIMP ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0
      alors erreur A99301 INVIMP ;
   si positif( INVLGAUTRE ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 INVLGAUTRE ;
   si positif( INVLGDEB ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 INVLGDEB ;
   si positif( INVLGDEB2009 ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0
      alors erreur A99301 INVLGDEB2009 ;
   si positif( INVLGDEB2010 ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 INVLGDEB2010 ;
   si positif( INVLOCHOTR ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 INVLOCHOTR ;
   si positif( INVLOCXN ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 INVLOCXN ;
   si positif( INVLOCXV ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 INVLOCXV ;
   si positif( COD7UY ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0
      alors erreur A99301 COD7UY ;
   si positif( COD7UZ ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 COD7UZ ;
   si positif( INVLOG2008 ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 INVLOG2008 ;
   si positif( INVLOG2009 ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0
      alors erreur A99301 INVLOG2009 ;
   si positif( INVLOGHOT ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 INVLOGHOT ;
   si positif( INVLOGREHA ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 INVLOGREHA ;
   si positif( INVLOGSOC ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0
      alors erreur A99301 INVLOGSOC ;
   si positif( INVNPROF1 ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 INVNPROF1 ;
   si positif( INVNPROF2 ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 INVNPROF2 ;
   si positif( INVNPROREP ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0
      alors erreur A99301 INVNPROREP ;
   si positif( INVOMENTKT ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 INVOMENTKT ;
   si positif( INVOMENTKU ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 INVOMENTKU ;
   si positif( INVOMENTMN ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0
      alors erreur A99301 INVOMENTMN ;
   si positif( INVOMENTNU ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 INVOMENTNU ;
   si positif( INVOMENTNV ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 INVOMENTNV ;
   si positif( INVOMENTNW ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0
      alors erreur A99301 INVOMENTNW ;
   si positif( INVOMENTNY ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 INVOMENTNY ;
   si positif( INVOMENTRG ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0
      alors erreur A99301 INVOMENTRG ;
   si positif( INVOMENTRI ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 INVOMENTRI ;
   si positif( INVOMENTRJ ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0
      alors erreur A99301 INVOMENTRJ ;
   si positif( INVOMENTRK ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 INVOMENTRK ;
   si positif( INVOMENTRL ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 INVOMENTRL ;
   si positif( INVOMENTRM ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0
      alors erreur A99301 INVOMENTRM ;
   si positif( INVOMENTRO ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 INVOMENTRO ;
   si positif( INVOMENTRP ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0
      alors erreur A99301 INVOMENTRP ;
   si positif( INVOMENTRQ ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 INVOMENTRQ ;
   si positif( INVOMENTRR ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 INVOMENTRR ;
   si positif( INVOMENTRT ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 INVOMENTRT ;
   si positif( INVOMENTRU ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 INVOMENTRU ;
   si positif( INVOMENTRV ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0
      alors erreur A99301 INVOMENTRV ;
   si positif( INVOMENTRW ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 INVOMENTRW ;
   si positif( INVOMENTRY ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0
      alors erreur A99301 INVOMENTRY ;
   si positif( INVOMLOGOA ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 INVOMLOGOA ;
   si positif( INVOMLOGOB ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 INVOMLOGOB ;
   si positif( INVOMLOGOC ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0
      alors erreur A99301 INVOMLOGOC ;
   si positif( INVOMLOGOH ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 INVOMLOGOH ;
   si positif( INVOMLOGOI ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 INVOMLOGOI ;
   si positif( INVOMLOGOJ ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0
      alors erreur A99301 INVOMLOGOJ ;
   si positif( INVOMLOGOK ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 INVOMLOGOK ;
   si positif( INVOMLOGOL ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 INVOMLOGOL ;
   si positif( INVOMLOGOM ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0
      alors erreur A99301 INVOMLOGOM ;
   si positif( INVOMLOGON ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 INVOMLOGON ;
   si positif( INVOMLOGOO ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 INVOMLOGOO ;
   si positif( INVOMLOGOP ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0
      alors erreur A99301 INVOMLOGOP ;
   si positif( INVOMLOGOQ ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 INVOMLOGOQ ;
   si positif( INVOMLOGOR ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 INVOMLOGOR ;
   si positif( INVOMLOGOS ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0
      alors erreur A99301 INVOMLOGOS ;
   si positif( INVOMLOGOT ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 INVOMLOGOT ;
   si positif( INVOMLOGOU ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 INVOMLOGOU ;
   si positif( INVOMLOGOV ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0
      alors erreur A99301 INVOMLOGOV ;
   si positif( INVOMLOGOW ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 INVOMLOGOW ;
   si positif( INVOMQV ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 INVOMQV ;
   si positif( INVOMREP ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0
      alors erreur A99301 INVOMREP ;
   si positif( INVOMRETPA ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 INVOMRETPA ;
   si positif( INVOMRETPB ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 INVOMRETPB ;
   si positif( INVOMRETPD ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0
      alors erreur A99301 INVOMRETPD ;
   si positif( INVOMRETPE ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 INVOMRETPE ;
   si positif( INVOMRETPF ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 INVOMRETPF ;
   si positif( INVOMRETPH ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0
      alors erreur A99301 INVOMRETPH ;
   si positif( INVOMRETPI ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 INVOMRETPI ;
   si positif( INVOMRETPJ ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 INVOMRETPJ ;
   si positif( INVOMRETPL ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0
      alors erreur A99301 INVOMRETPL ;
   si positif( INVOMRETPM ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 INVOMRETPM ;
   si positif( INVOMRETPN ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 INVOMRETPN ;
   si positif( INVOMRETPO ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0
      alors erreur A99301 INVOMRETPO ;
   si positif( INVOMRETPP ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 INVOMRETPP ;
   si positif( INVOMRETPR ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0
      alors erreur A99301 INVOMRETPR ;
   si positif( INVOMRETPS ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 INVOMRETPS ;
   si positif( INVOMRETPT ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 INVOMRETPT ;
   si positif( INVOMRETPU ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0
      alors erreur A99301 INVOMRETPU ;
   si positif( INVOMRETPW ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 INVOMRETPW ;
   si positif( INVOMRETPX ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0
      alors erreur A99301 INVOMRETPX ;
   si positif( INVOMRETPY ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 INVOMRETPY ;
   si positif( INVOMSOCKH ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 INVOMSOCKH ;
   si positif( INVOMSOCKI ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0
      alors erreur A99301 INVOMSOCKI ;
   si positif( INVOMSOCQJ ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 INVOMSOCQJ ;
   si positif( INVOMSOCQS ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 INVOMSOCQS ;
   si positif( INVOMSOCQU ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0
      alors erreur A99301 INVOMSOCQU ;
   si positif( INVOMSOCQW ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 INVOMSOCQW ;
   si positif( INVOMSOCQX ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 INVOMSOCQX ;
   si positif( INVREDMEU ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0
      alors erreur A99301 INVREDMEU ;
   si positif( INVREPMEU ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 INVREPMEU ;
   si positif( INVREPNPRO ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 INVREPNPRO ;
   si positif( INVRETRO1 ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0
      alors erreur A99301 INVRETRO1 ;
   si positif( INVRETRO2 ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 INVRETRO2 ;
   si positif( INVSOC2010 ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 INVSOC2010 ;
   si positif( INVSOCNRET ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0
      alors erreur A99301 INVSOCNRET ;
   si positif( IPBOCH ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 IPBOCH ;
   si positif( IPCHER ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 IPCHER ;
   si positif( IPELUS ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0
      alors erreur A99301 IPELUS ;
   si positif( IPMOND ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 IPMOND ;
   si positif( IPPNCS ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 IPPNCS ;
   si positif( IPPRICORSE ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0
      alors erreur A99301 IPPRICORSE ;
   si positif( IPRECH ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 IPRECH ;
   si positif( IPREP ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 IPREP ;
   si positif( IPREPCORSE ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0
      alors erreur A99301 IPREPCORSE ;
   si positif( IPSOUR ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 IPSOUR ;
   si positif( IPSURSI ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 IPSURSI ;
   si positif( VARIPTEFN ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 VARIPTEFN ;
   si positif( VARIPTEFP ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 VARIPTEFP ;
   si positif( IPTXMO ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 IPTXMO ;
   si positif( IPVLOC ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0
      alors erreur A99301 IPVLOC ;
   si positif( ISFBASE ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 ISFBASE ;
   si positif( ISFCONCUB ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 ISFCONCUB ;
   si positif( ISFDONEURO ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0
      alors erreur A99301 ISFDONEURO ;
   si positif( ISFDONF ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 ISFDONF ;
   si positif( ISFETRANG ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 ISFETRANG ;
   si positif( ISFFCPI ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0
      alors erreur A99301 ISFFCPI ;
   si positif( ISFFIP ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 ISFFIP ;
   si positif( ISFPART ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 ISFPART ;
   si positif( ISFPLAF ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0
      alors erreur A99301 ISFPLAF ;
   si positif( ISFPMEDI ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 ISFPMEDI ;
   si positif( ISFPMEIN ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 ISFPMEIN ;
   si positif( ISFVBPAT ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0
      alors erreur A99301 ISFVBPAT ;
   si positif( ISF_LIMINF ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 ISF_LIMINF ;
   si positif( ISF_LIMSUP ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 ISF_LIMSUP ;
   si positif ( LNPRODEF1 ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 LNPRODEF1 ;
   si positif ( LNPRODEF10 ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 LNPRODEF10 ;
   si positif ( LNPRODEF2 ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0
      alors erreur A99301 LNPRODEF2 ;
   si positif ( LNPRODEF3 ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 LNPRODEF3 ;
   si positif ( LNPRODEF4 ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 LNPRODEF4 ;
   si positif ( LNPRODEF5 ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0
      alors erreur A99301 LNPRODEF5 ;
   si positif ( LNPRODEF6 ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 LNPRODEF6 ;
   si positif ( LNPRODEF7 ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 LNPRODEF7 ;
   si positif ( LNPRODEF8 ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0
      alors erreur A99301 LNPRODEF8 ;
   si positif ( LNPRODEF9 ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 LNPRODEF9 ;
   si positif ( LOCDEFNPC ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0
      alors erreur A99301 LOCDEFNPC ;
   si positif ( LOCDEFNPCGAC ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0
      alors erreur A99301 LOCDEFNPCGAC ;
   si positif ( LOCDEFNPCGAPAC ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0
      alors erreur A99301 LOCDEFNPCGAPAC ;
   si positif ( LOCDEFNPCGAV ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0
      alors erreur A99301 LOCDEFNPCGAV ;
   si positif ( LOCDEFNPPAC ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0
      alors erreur A99301 LOCDEFNPPAC ;
   si positif ( LOCDEFNPV ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0
      alors erreur A99301 LOCDEFNPV ;
   si positif( LOCDEFPROCGAC ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0
      alors erreur A99301 LOCDEFPROCGAC ;
   si positif( LOCDEFPROCGAP ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 LOCDEFPROCGAP ;
   si positif( LOCDEFPROCGAV ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 LOCDEFPROCGAV ;
   si positif( LOCDEFPROC ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 LOCDEFPROC ;
   si positif( LOCDEFPROP ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0
      alors erreur A99301 LOCDEFPROP ;
   si positif( LOCDEFPROV ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0
      alors erreur A99301 LOCDEFPROV ;
   si positif( LOCGITC ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 LOCGITC ;
   si positif( LOCGITCC ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0
      alors erreur A99301 LOCGITCC ;
   si positif( LOCGITCP ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 LOCGITCP ;
   si positif( LOCGITCV ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 LOCGITCV ;
   si positif( LOCGITHCC ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0
      alors erreur A99301 LOCGITHCC ;
   si positif( LOCGITHCP ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 LOCGITHCP ;
   si positif( LOCGITHCV ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 LOCGITHCV ;
   si positif( LOCGITP ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0
      alors erreur A99301 LOCGITP ;
   si positif( LOCGITV ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 LOCGITV ;
   si positif( LOCMEUBIA ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 LOCMEUBIA ;
   si positif( LOCMEUBIB ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0
      alors erreur A99301 LOCMEUBIB ;
   si positif( LOCMEUBIC ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 LOCMEUBIC ;
   si positif( LOCMEUBID ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 LOCMEUBID ;
   si positif( LOCMEUBIE ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0
      alors erreur A99301 LOCMEUBIE ;
   si positif( LOCMEUBIF ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 LOCMEUBIF ;
   si positif( LOCMEUBIG ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 LOCMEUBIG ;
   si positif( LOCMEUBIH ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0
      alors erreur A99301 LOCMEUBIH ;
   si positif( LOCMEUBII ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 LOCMEUBII ;
   si positif( LOCMEUBIX ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 LOCMEUBIX ;
   si positif( LOCMEUBIZ ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0
      alors erreur A99301 LOCMEUBIZ ;
   si positif( LOCMEUBJV ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 LOCMEUBJV ;
   si positif( LOCMEUBJW ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 LOCMEUBJW ;
   si positif( LOCMEUBJX ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 LOCMEUBJX ;
   si positif( LOCMEUBJY ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0
      alors erreur A99301 LOCMEUBJY ;
   si positif( LOCNPC ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 LOCNPC ;
   si positif( LOCNPCGAC ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 LOCNPCGAC ;
   si positif( LOCNPCGAPAC ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0
      alors erreur A99301 LOCNPCGAPAC ;
   si positif( LOCNPCGAV ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 LOCNPCGAV ;
   si positif( LOCNPPAC ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 LOCNPPAC ;
   si positif( LOCNPV ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0
      alors erreur A99301 LOCNPV ;
   si positif( LOCPROC ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 LOCPROC ;
   si positif( LOCPROCGAC ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 LOCPROCGAC ;
   si positif( LOCPROCGAP ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0
      alors erreur A99301 LOCPROCGAP ;
   si positif( LOCPROCGAV ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 LOCPROCGAV ;
   si positif( LOCPROP ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 LOCPROP ;
   si positif( LOCPROV ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0
      alors erreur A99301 LOCPROV ;
   si positif( LOCRESINEUV ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 LOCRESINEUV ;
   si positif( LOYELEV ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 LOYELEV ;
   si positif( LOYIMP ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0
      alors erreur A99301 LOYIMP ;
   si positif( MATISOSI ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 MATISOSI ;
   si positif( MATISOSJ ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 MATISOSJ ;
   si positif( MEUBLENP ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0
      alors erreur A99301 MEUBLENP ;
   si positif( MIB1AC ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 MIB1AC ;
   si positif( MIB1AP ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 MIB1AP ;
   si positif( MIB1AV ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0
      alors erreur A99301 MIB1AV ;
   si positif( MIBDEC ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 MIBDEC ;
   si positif( MIBDEP ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 MIBDEP ;
   si positif( MIBDEV ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0
      alors erreur A99301 MIBDEV ;
   si positif( MIBEXC ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 MIBEXC ;
   si positif( MIBEXP ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 MIBEXP ;
   si positif( MIBEXV ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0
      alors erreur A99301 MIBEXV ;
   si positif( MIBGITEC ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 MIBGITEC ;
   si positif( MIBGITEP ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 MIBGITEP ;
   si positif( MIBGITEV ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0
      alors erreur A99301 MIBGITEV ;
   si positif( MIBMEUC ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 MIBMEUC ;
   si positif( MIBMEUP ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 MIBMEUP ;
   si positif( MIBMEUV ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0
      alors erreur A99301 MIBMEUV ;
   si positif( MIBNP1AC ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 MIBNP1AC ;
   si positif( MIBNP1AP ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 MIBNP1AP ;
   si positif( MIBNP1AV ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0
      alors erreur A99301 MIBNP1AV ;
   si positif( MIBNPDCT ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 MIBNPDCT ;
   si positif( MIBNPDEC ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 MIBNPDEC ;
   si positif( MIBNPDEP ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0
      alors erreur A99301 MIBNPDEP ;
   si positif( MIBNPDEV ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 MIBNPDEV ;
   si positif( MIBNPEXC ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 MIBNPEXC ;
   si positif( MIBNPEXP ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0
      alors erreur A99301 MIBNPEXP ;
   si positif( MIBNPEXV ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 MIBNPEXV ;
   si positif( MIBNPPRESC ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 MIBNPPRESC ;
   si positif( MIBNPPRESP ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0
      alors erreur A99301 MIBNPPRESP ;
   si positif( MIBNPPRESV ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 MIBNPPRESV ;
   si positif( MIBNPPVC ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 MIBNPPVC ;
   si positif( MIBNPPVP ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0
      alors erreur A99301 MIBNPPVP ;
   si positif( MIBNPPVV ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 MIBNPPVV ;
   si positif( MIBNPVENC ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 MIBNPVENC ;
   si positif( MIBNPVENP ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0
      alors erreur A99301 MIBNPVENP ;
   si positif( MIBNPVENV ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 MIBNPVENV ;
   si positif( MIBPRESC ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 MIBPRESC ;
   si positif( MIBPRESP ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0
      alors erreur A99301 MIBPRESP ;
   si positif( MIBPRESV ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 MIBPRESV ;
   si positif( MIBPVC ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 MIBPVC ;
   si positif( MIBPVP ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0
      alors erreur A99301 MIBPVP ;
   si positif( MIBPVV ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 MIBPVV ;
   si positif( MIBVENC ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 MIBVENC ;
   si positif( MIBVENP ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0
      alors erreur A99301 MIBVENP ;
   si positif( MIBVENV ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 MIBVENV ;
   si positif( MOISAN ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 MOISAN ;
   si positif( MOISAN_ISF ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0
      alors erreur A99301 MOISAN_ISF ;
   si positif( NBACT ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 NBACT ;
   si positif( NCHENF1 ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 NCHENF1 ;
   si positif( NCHENF2 ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0
      alors erreur A99301 NCHENF2 ;
   si positif( NCHENF3 ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 NCHENF3 ;
   si positif( NCHENF4 ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 NCHENF4 ;
   si positif( NRBASE ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0
      alors erreur A99301 NRBASE ;
   si positif( NRETROC40 ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 NRETROC40 ;
   si positif( NRETROC50 ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 NRETROC50 ;
   si positif( NRINET ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0
      alors erreur A99301 NRINET ;
   si positif( NUPROP ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 NUPROP ;
   si positif( OPTPLAF15 ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 OPTPLAF15 ;
   si positif( PAAP ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0
      alors erreur A99301 PAAP ;
   si positif( PAAV ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 PAAV ;
   si positif( PALI1 ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 PALI1 ;
   si positif( PALI2 ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0
      alors erreur A99301 PALI2 ;
   si positif( PALI3 ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 PALI3 ;
   si positif( PALI4 ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 PALI4 ;
   si positif( PALIC ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0
      alors erreur A99301 PALIC ;
   si positif( PALIV ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 PALIV ;
   si positif( PATNAT1 ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 PATNAT1 ;
   si positif( PATNAT2 ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 PATNAT2 ;
   si positif( PCAPTAXC ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0
      alors erreur A99301 PCAPTAXC ;
   si positif( PCAPTAXV ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 PCAPTAXV ;
   si positif( PEA ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 PEA ;
   si positif( PEBF1 ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0
      alors erreur A99301 PEBF1 ;
   si positif( PEBF2 ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 PEBF2 ;
   si positif( PEBF3 ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 PEBF3 ;
   si positif( PEBF4 ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0
      alors erreur A99301 PEBF4 ;
   si positif( PEBFC ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 PEBFC ;
   si positif( PEBFV ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 PEBFV ;
   si positif( PENECS ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0
      alors erreur A99301 PENECS ;
   si positif( PENSALC ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 PENSALC ;
   si positif( PENSALNBC ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 PENSALNBC ;
   si positif( PENSALNBP1 ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0
      alors erreur A99301 PENSALNBP1 ;
   si positif( PENSALNBP2 ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 PENSALNBP2 ;
   si positif( PENSALNBP3 ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 PENSALNBP3 ;
   si positif( PENSALNBP4 ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0
      alors erreur A99301 PENSALNBP4 ;
   si positif( PENSALNBV ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 PENSALNBV ;
   si positif( PENSALP1 ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 PENSALP1 ;
   si positif( PENSALP2 ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0
      alors erreur A99301 PENSALP2 ;
   si positif( PENSALP3 ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 PENSALP3 ;
   si positif( PENSALP4 ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 PENSALP4 ;
   si positif( PENSALV ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0
      alors erreur A99301 PENSALV ;
   si positif( PERPC ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 PERPC ;
   si positif( PERPIMPATRIE ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 PERPIMPATRIE ;
   si positif( PERPMUTU ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0
      alors erreur A99301 PERPMUTU ;
   si positif( PERPP ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 PERPP ;
   si positif( PERPPLAFCC ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 PERPPLAFCC ;
   si positif( PERPPLAFCP ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0
      alors erreur A99301 PERPPLAFCP ;
   si positif( PERPPLAFCV ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 PERPPLAFCV ;
   si positif( PERPPLAFNUC1 ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 PERPPLAFNUC1 ;
   si positif( PERPPLAFNUC2 ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0
      alors erreur A99301 PERPPLAFNUC2 ;
   si positif( PERPPLAFNUC3 ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 PERPPLAFNUC3 ;
   si positif( PERPPLAFNUP1 ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 PERPPLAFNUP1 ;
   si positif( PERPPLAFNUP2 ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0
      alors erreur A99301 PERPPLAFNUP2 ;
   si positif( PERPPLAFNUP3 ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 PERPPLAFNUP3 ;
   si positif( PERPPLAFNUV1 ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 PERPPLAFNUV1 ;
   si positif( PERPPLAFNUV2 ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0
      alors erreur A99301 PERPPLAFNUV2 ;
   si positif( PERPPLAFNUV3 ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 PERPPLAFNUV3 ;
   si positif( PERPV ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 PERPV ;
   si positif( PERP_COTC ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0
      alors erreur A99301 PERP_COTC ;
   si positif( PERP_COTP ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 PERP_COTP ;
   si positif( PERP_COTV ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 PERP_COTV ;
   si positif( PLAF_PERPC ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 PLAF_PERPC ;
   si positif( PLAF_PERPP ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 PLAF_PERPP ;
   si positif( PLAF_PERPV ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0
      alors erreur A99301 PLAF_PERPV ;
   si positif( POMPESP ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 POMPESP ;
   si positif( POMPESQ ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 POMPESQ ;
   si positif( POMPESR ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0
      alors erreur A99301 POMPESR ;
   si positif( PORENT ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 PORENT ;
   si positif( PPEACC ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 PPEACC ;
   si positif( PPEACP ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 PPEACP ;
   si positif( PPEACV ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0
      alors erreur A99301 PPEACV ;
   si positif( PPEISFPIR ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 PPEISFPIR ;
   si positif( PPENHC ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 PPENHC ;
   si positif( PPENHP1 ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0
      alors erreur A99301 PPENHP1 ;
   si positif( PPENHP2 ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 PPENHP2 ;
   si positif( PPENHP3 ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 PPENHP3 ;
   si positif( PPENHP4 ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0
      alors erreur A99301 PPENHP4 ;
   si positif( PPENHV ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 PPENHV ;
   si positif( PPENJC ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 PPENJC ;
   si positif( PPENJP ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0
      alors erreur A99301 PPENJP ;
   si positif( PPENJV ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 PPENJV ;
   si positif( PPEREVPRO ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 PPEREVPRO ;
   si positif( PPETPC ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0
      alors erreur A99301 PPETPC ;
   si positif( PPETPP1 ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 PPETPP1 ;
   si positif( PPETPP2 ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 PPETPP2 ;
   si positif( PPETPP3 ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0
      alors erreur A99301 PPETPP3 ;
   si positif( PPETPP4 ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 PPETPP4 ;
   si positif( PPETPV ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 PPETPV ;
   si positif( PPLIB ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0
      alors erreur A99301 PPLIB ;
   si positif( PRBR1 ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 PRBR1 ;
   si positif( PRBR2 ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 PRBR2 ;
   si positif( PRBR3 ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0
      alors erreur A99301 PRBR3 ;
   si positif( PRBR4 ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 PRBR4 ;
   si positif( PRBRC ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 PRBRC ;
   si positif( PRBRV ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0
      alors erreur A99301 PRBRV ;
   si positif( PREHABT ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 PREHABT ;
   si positif( PREHABT2 ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0
      alors erreur A99301 PREHABT2 ;
   si positif( PREHABTN ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 PREHABTN ;
   si positif( PREHABTN1 ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 PREHABTN1 ;
   si positif( PREHABTN2 ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0
      alors erreur A99301 PREHABTN2 ;
   si positif( PREHABTVT ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 PREHABTVT ;
   si positif( PRELIBXT ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 PRELIBXT ;
   si positif( PREMAIDE ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0
      alors erreur A99301 PREMAIDE ;
   si positif( PREREV ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 PREREV ;
   si positif( PRESCOMP2000 ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 PRESCOMP2000 ;
   si positif( PRESCOMPJUGE ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0
      alors erreur A99301 PRESCOMPJUGE ;
   si positif( PRESINTER ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 PRESINTER ;
   si positif( PRETUD ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 PRETUD ;
   si positif( PRETUDANT ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0
      alors erreur A99301 PRETUDANT ;
   si positif( PRODOM ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 PRODOM ;
   si positif( PROGUY ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 PROGUY ;
   si positif( PROVIE ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0
      alors erreur A99301 PROVIE ;
   si positif( PROVIENB ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 PROVIENB ;
   si positif( PTZDEVDUR ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 PTZDEVDUR ;
   si positif( PTZDEVDURN ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0
      alors erreur A99301 PTZDEVDURN ;
   si positif( PVEXOSEC ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 PVEXOSEC ;
   si positif( PVIMMO ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0
      alors erreur A99301 PVIMMO ;
   si positif( PVIMPOS ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 PVIMPOS ;
   si positif( PVINCE ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 PVINCE ;
   si positif( PVINPE ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0
      alors erreur A99301 PVINPE ;
   si positif( PVINVE ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 PVINVE ;
   si positif( PVMOBNR ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0
      alors erreur A99301 PVMOBNR ;
   si positif( PVREP8 ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 PVREP8 ;
   si positif( PVREPORT ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0
      alors erreur A99301 PVREPORT ;
   si positif( PVSOCC ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 PVSOCC ;
   si positif( PVSOCV ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 PVSOCV ;
   si positif( PVSURSI ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0
      alors erreur A99301 PVSURSI ;
   si positif( PVTAXSB ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0
      alors erreur A99301 PVTAXSB ;
   si positif( PVTITRESOC ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 PVTITRESOC ;
   si positif( R1649 ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0
      alors erreur A99301 R1649 ;
   si positif( RACCOTC ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 RACCOTC ;
   si positif( RACCOTP ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 RACCOTP ;
   si positif( RACCOTV ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0
      alors erreur A99301 RACCOTV ;
   si positif( RCCURE ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 RCCURE ;
   si positif( RCMABD ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 RCMABD ;
   si positif( RCMAV ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0
      alors erreur A99301 RCMAV ;
   si positif( RCMAVFT ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 RCMAVFT ;
   si positif( RCMFR ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 RCMFR ;
   si positif( RCMHAB ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0
      alors erreur A99301 RCMHAB ;
   si positif( RCMHAD ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 RCMHAD ;
   si positif( RCMIMPAT ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 RCMIMPAT ;
   si positif( RCMLIB ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0
      alors erreur A99301 RCMLIB ;
   si positif( RCMRDS ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 RCMRDS ;
   si positif( RCMSOC ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0
      alors erreur A99301 RCMSOC ;
   si positif( RCMTNC ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 RCMTNC ;
   si positif( RCSC ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 RCSC ;
   si positif( RCSP ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0
      alors erreur A99301 RCSP ;
   si positif( RCSV ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 RCSV ;
   si positif( RDCOM ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 RDCOM ;
   si positif( RDDOUP ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0
      alors erreur A99301 RDDOUP ;
   si positif( RDENL ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 RDENL ;
   si positif( RDENLQAR ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 RDENLQAR ;
   si positif( RDENS ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0
      alors erreur A99301 RDENS ;
   si positif( RDENSQAR ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 RDENSQAR ;
   si positif( RDENU ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 RDENU ;
   si positif( RDENUQAR ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0
      alors erreur A99301 RDENUQAR ;
   si positif( RDEQPAHA ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 RDEQPAHA ;
   si positif( RDFOREST ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 RDFOREST ;
   si positif( RDFORESTGES ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0
      alors erreur A99301 RDFORESTGES ;
   si positif( RDFORESTRA ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 RDFORESTRA ;
   si positif( RDGARD1 ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0
      alors erreur A99301 RDGARD1 ;
   si positif( RDGARD1QAR ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 RDGARD1QAR ;
   si positif( RDGARD2 ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 RDGARD2 ;
   si positif( RDGARD2QAR ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0
      alors erreur A99301 RDGARD2QAR ;
   si positif( RDGARD3 ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 RDGARD3 ;
   si positif( RDGARD3QAR ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 RDGARD3QAR ;
   si positif( RDGARD4 ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0
      alors erreur A99301 RDGARD4 ;
   si positif( RDGARD4QAR ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 RDGARD4QAR ;
   si positif( RDMECENAT ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0
      alors erreur A99301 RDMECENAT ;
   si positif( RDPRESREPORT ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 RDPRESREPORT ;
   si positif( RDREP ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 RDREP ;
   si positif( RDRESU ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0
      alors erreur A99301 RDRESU ;
   si positif( RDSNO ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 RDSNO ;
   si positif( RDSYCJ ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 RDSYCJ ;
   si positif( RDSYPP ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0
      alors erreur A99301 RDSYPP ;
   si positif( RDSYVO ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 RDSYVO ;
   si positif( RDTECH ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 RDTECH ;
   si positif( RE168 ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0
      alors erreur A99301 RE168 ;
   si positif( REAMOR ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 REAMOR ;
   si positif( REAMORNB ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 REAMORNB ;
   si positif( REDMEUBLE ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0
      alors erreur A99301 REDMEUBLE ;
   si positif( REDREPNPRO ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 REDREPNPRO ;
   si positif( REGCI ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 REGCI ;
   si positif( REGPRIV ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0
      alors erreur A99301 REGPRIV ;
   si positif( REMPLAC ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 REMPLAC ;
   si positif( REMPLANBC ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 REMPLANBC ;
   si positif( REMPLANBP1 ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0
      alors erreur A99301 REMPLANBP1 ;
   si positif( REMPLANBP2 ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 REMPLANBP2 ;
   si positif( REMPLANBP3 ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 REMPLANBP3 ;
   si positif( REMPLANBP4 ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0
      alors erreur A99301 REMPLANBP4 ;
   si positif( REMPLANBV ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 REMPLANBV ;
   si positif( REMPLAP1 ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 REMPLAP1 ;
   si positif( REMPLAP2 ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0
      alors erreur A99301 REMPLAP2 ;
   si positif( REMPLAP3 ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 REMPLAP3 ;
   si positif( REMPLAP4 ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 REMPLAP4 ;
   si positif( REMPLAV ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0
      alors erreur A99301 REMPLAV ;
   si positif( RENTAX ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 RENTAX ;
   si positif( RENTAX5 ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 RENTAX5 ;
   si positif( RENTAX6 ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0
      alors erreur A99301 RENTAX6 ;
   si positif( RENTAX7 ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 RENTAX7 ;
   si positif( RENTAXNB ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 RENTAXNB ;
   si positif( RENTAXNB5 ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0
      alors erreur A99301 RENTAXNB5 ;
   si positif( RENTAXNB6 ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 RENTAXNB6 ;
   si positif( RENTAXNB7 ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 RENTAXNB7 ;
   si positif( REPDON03 ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0
      alors erreur A99301 REPDON03 ;
   si positif( REPDON04 ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 REPDON04 ;
   si positif( REPDON05 ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 REPDON05 ;
   si positif( REPDON06 ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0
      alors erreur A99301 REPDON06 ;
   si positif( REPDON07 ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 REPDON07 ;
   si positif( REPFOR ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 REPFOR ;
   si positif( REPFOR1 ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0
      alors erreur A99301 REPFOR1 ;
   si positif( REPFOR2 ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 REPFOR2 ;
   si positif( REPGROREP1 ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 REPGROREP1 ;
   si positif( REPGROREP11 ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 REPGROREP11 ;
   si positif( REPGROREP12 ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0
      alors erreur A99301 REPGROREP12 ;
   si positif( REPGROREP2 ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 REPGROREP2 ;
   si positif( REPINVTOU ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0
      alors erreur A99301 REPINVTOU ;
   si positif( REPMEUBLE ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 REPMEUBLE ;
   si positif( REPSINFOR ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 REPSINFOR ;
   si positif( REPSINFOR1 ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0
      alors erreur A99301 REPSINFOR1 ;
   si positif( REPSINFOR2 ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 REPSINFOR2 ;
   si positif( REPSNO1 ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 REPSNO1 ;
   si positif( REPSNO2 ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0
      alors erreur A99301 REPSNO2 ;
   si positif( REPSNO3 ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 REPSNO3 ;
   si positif( REPSNON ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 REPSNON ;
   si positif( REPSOF ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0
      alors erreur A99301 REPSOF ;
   si positif( RESCHAL ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 RESCHAL ;
   si positif( RESIVIANT ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 RESIVIANT ;
   si positif( RESIVIEU ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0
      alors erreur A99301 RESIVIEU ;
   si positif( RESTIMOPPAU ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 RESTIMOPPAU ;
   si positif( RESTIMOSAUV ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 RESTIMOSAUV ;
   si positif( RESTUC ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0
      alors erreur A99301 RESTUC ;
   si positif( RESTUCNB ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 RESTUCNB ;
   si positif( RETROCOMLH ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 RETROCOMLH ;
   si positif( RETROCOMLI ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0
      alors erreur A99301 RETROCOMLI ;
   si positif( RETROCOMMB ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 RETROCOMMB ;
   si positif( RETROCOMMC ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 RETROCOMMC ;
   si positif( REVACT ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0
      alors erreur A99301 REVACT ;
   si positif( REVACTNB ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 REVACTNB ;
   si positif( REVCSXA ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 REVCSXA ;
   si positif( REVCSXB ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0
      alors erreur A99301 REVCSXB ;
   si positif( REVCSXC ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 REVCSXC ;
   si positif( REVCSXD ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 REVCSXD ;
   si positif( REVCSXE ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0
      alors erreur A99301 REVCSXE ;
   si positif( REVFONC ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 REVFONC ;
   si positif( REVMAR1 ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 REVMAR1 ;
   si positif( REVMAR2 ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0
      alors erreur A99301 REVMAR2 ;
   si positif( REVMAR3 ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 REVMAR3 ;
   si positif( REVPEA ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 REVPEA ;
   si positif( REVPEANB ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0
      alors erreur A99301 REVPEANB ;
   si positif( RFDANT ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 RFDANT ;
   si positif( RFDHIS ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 RFDHIS ;
   si positif( RFDORD ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0
      alors erreur A99301 RFDORD ;
   si positif( RFMIC ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 RFMIC ;
   si positif( RFORDI ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 RFORDI ;
   si positif( RFRH1 ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0
      alors erreur A99301 RFRH1 ;
   si positif( RFRH2 ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 RFRH2 ;
   si positif( RFRN2 ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 RFRN2 ;
   si positif( RFRN3 ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0
      alors erreur A99301 RFRN3 ;
   si positif( RFROBOR ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 RFROBOR ;
   si positif( RIMOPPAUANT ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 RIMOPPAUANT ;
   si positif( RIMOPPAURE ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0
      alors erreur A99301 RIMOPPAURE ;
   si positif( RIMOSAUVANT ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 RIMOSAUVANT ;
   si positif( RIMOSAUVRF ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 RIMOSAUVRF ;
   si positif( RINVLOCINV ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0
      alors erreur A99301 RINVLOCINV ;
   si positif( COD7SY ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 COD7SY ;
   si positif( COD7SX ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0
      alors erreur A99301 COD7SX ;
   si positif( RINVLOCREA ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 RINVLOCREA ;
   si positif( RISKTEC ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0
      alors erreur A99301 RISKTEC ;
   si positif( VARRMOND ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 VARRMOND ;
   si positif( RSAFOYER ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 RSAFOYER ;
   si positif( RSAPAC1 ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0
      alors erreur A99301 RSAPAC1 ;
   si positif( RSAPAC2 ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 RSAPAC2 ;
   si positif( RSOCREPRISE ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 RSOCREPRISE ;
   si positif( RVAIDAS ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0
      alors erreur A99301 RVAIDAS ;
   si positif( RVAIDE ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 RVAIDE ;
   si positif( RVB1 ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 RVB1 ;
   si positif( RVB2 ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0
      alors erreur A99301 RVB2 ;
   si positif( RVB3 ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 RVB3 ;
   si positif( RVB4 ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 RVB4 ;
   si positif( RVCURE ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0
      alors erreur A99301 RVCURE ;
   si positif( SALECS ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 SALECS ;
   si positif( SALECSG ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 SALECSG ;
   si positif( SINISFORET ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 SINISFORET ;
   si positif( SUBSTITRENTE ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0
      alors erreur A99301 SUBSTITRENTE ;
   si positif( TAX1649 ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 TAX1649 ;
   si positif( TEFFHRC ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 TEFFHRC ;
   si positif( TRAMURWC ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0
      alors erreur A99301 TRAMURWC ;
   si positif( TRATOIVG ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 TRATOIVG ;
   si positif( TRAVITWT ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 TRAVITWT ;
   si positif( TSASSUC ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0
      alors erreur A99301 TSASSUC ;
   si positif( TSASSUV ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 TSASSUV ;
   si positif( TSHALLO1 ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 TSHALLO1 ;
   si positif( TSHALLO2 ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 TSHALLO2 ;
   si positif( TSHALLO3 ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0
      alors erreur A99301 TSHALLO3 ;
   si positif( TSHALLO4 ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 TSHALLO4 ;
   si positif( TSHALLOC ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 TSHALLOC ;
   si positif( TSHALLOV ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0
      alors erreur A99301 TSHALLOV ;
   si positif( VIEUMEUB ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 VIEUMEUB ;
   si positif( VOLISO ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 VOLISO ;
   si positif( XETRANC ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 XETRANC ;
   si positif( XETRANV ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0
      alors erreur A99301 XETRANV ;
   si positif( XHONOAAC ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 XHONOAAC ;
   si positif( XHONOAAP ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 XHONOAAP ;
   si positif( XHONOAAV ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0
      alors erreur A99301 XHONOAAV ;
   si positif( XHONOC ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 XHONOC ;
   si positif( XHONOP ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 XHONOP ;
   si positif( XHONOV ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0
      alors erreur A99301 XHONOV ;
   si positif( XSPENPC ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 XSPENPC ;
   si positif( XSPENPP ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 XSPENPP ;
   si positif( XSPENPV ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0
      alors erreur A99301 XSPENPV ;
   si positif( COD1AD ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 COD1AD ;
   si positif( COD1AE ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 COD1AE ;
   si positif( COD1AH ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 COD1AH ;
   si positif( COD1BD ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0
      alors erreur A99301 COD1BD ;
   si positif( COD1BE ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 COD1BE ;
   si positif( COD1BH ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 COD1BH ;
   si positif( COD1CD ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 COD1CD ;
   si positif( COD1CE ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0
      alors erreur A99301 COD1CE ;
   si positif( COD1CH ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 COD1CH ;
   si positif( COD1DD ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 COD1DD ;
   si positif( COD1DE ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 COD1DE ;
   si positif( COD1DH ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0
      alors erreur A99301 COD1DH ;
   si positif( COD1ED ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 COD1ED ;
   si positif( COD1EE ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 COD1EE ;
   si positif( COD1EH ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 COD1EH ;
   si positif( COD1FD ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0
      alors erreur A99301 COD1FD ;
   si positif( COD1FE ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 COD1FE ;
   si positif( COD1FH ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0
      alors erreur A99301 COD1FH ;
   si positif( COD2CK ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 COD2CK ;
   si positif( COD2FA ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0
      alors erreur A99301 COD2FA ;
   si positif( COD3SG ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 COD3SG ;
   si positif( COD3SH ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 COD3SH ;
   si positif( COD3SL ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 COD3SL ;
   si positif( COD3SM ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0
      alors erreur A99301 COD3SM ;
   si positif( COD3VE ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 COD3VE ;
   si positif( COD7CQ ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 COD7CQ ;
   si positif( COD7UH ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 COD7UH ;
   si positif( COD7WD ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0
      alors erreur A99301 COD7WD ;
   si positif( COD8PA ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 COD8PA ;
   si positif( COD8TL ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 COD8TL ;
   si positif( COD8UW ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0
      alors erreur A99301 COD8UW ;
   si positif( COD8XF ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 COD8XF ;
   si positif( COD8XG ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 COD8XG ;
   si positif( COD8XH ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 COD8XH ;
   si positif( COD8XK ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0
      alors erreur A99301 COD8XK ;
   si positif( COD8XV ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 COD8XV ;
   si positif( COD8YJ ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 COD8YJ ;
   si positif( COD8YK ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 COD8YK ;
   si positif( COD8YL ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0
      alors erreur A99301 COD8YL ;
   si positif( COD8YT ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0
      alors erreur A99301 COD8YT ;
   si positif( CODDAJ ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 CODDAJ ;
   si positif( CODDBJ ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 CODDBJ ;
   si positif( CODEAJ ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 CODEAJ ;
   si positif( CODEBJ ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0
      alors erreur A99301 CODEBJ ;
   si positif( CODHOD ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 CODHOD ;
   si positif( CODHOE ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 CODHOE ;
   si positif( CODHOF ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 CODHOF ;
   si positif( CODHOG ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0
      alors erreur A99301 CODHOG ;
   si positif( CODHOX ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 CODHOX ;
   si positif( CODHOY ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 CODHOY ;
   si positif( CODHOZ ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 CODHOZ ;
   si positif( CODHRA ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0
      alors erreur A99301 CODHRA ;
   si positif( CODHRB ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 CODHRB ;
   si positif( CODHRC ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 CODHRC ;
   si positif( CODHRD ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 CODHRD ;
   si positif( CODHSA ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0
      alors erreur A99301 CODHSA ;
   si positif( CODHSB ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 CODHSB ;
   si positif( CODHSC ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 CODHSC ;
   si positif( CODHSE ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0
      alors erreur A99301 CODHSE ;
   si positif( CODHSF ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 CODHSF ;
   si positif( CODHSG ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 CODHSG ;
   si positif( CODHSH ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 CODHSH ;
   si positif( CODHSJ ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 CODHSJ ;
   si positif( CODHSK ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 CODHSK ;
   si positif( CODHSL ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 CODHSL ;
   si positif( CODHSM ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0
      alors erreur A99301 CODHSM ;
   si positif( CODHSO ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 CODHSO ;
   si positif( CODHSP ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 CODHSP ;
   si positif( CODHSQ ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0
      alors erreur A99301 CODHSQ ;
   si positif( CODHSR ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 CODHSR ;
   si positif( CODHST ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 CODHST ;
   si positif( CODHSU ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0
      alors erreur A99301 CODHSU ;
   si positif( CODHSV ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 CODHSV ;
   si positif( CODHSW ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 CODHSW ;
   si positif( CODHSY ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0
      alors erreur A99301 CODHSY ;
   si positif( CODHSZ ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 CODHSZ ;
   si positif( CODHTA ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 CODHTA ;
   si positif( CODHTB ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 CODHTB ;
   si positif( CODHTD ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0
      alors erreur A99301 CODHTD ;
   si positif( DUFLOGH ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 DUFLOGH ;
   si positif( DUFLOGI ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0
      alors erreur A99301 DUFLOGI ;
   si positif( LOCMEUBIY ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 LOCMEUBIY ;
   si positif( LOCMEUBJC ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 LOCMEUBJC ;
   si positif( LOCMEUBJI ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0
      alors erreur A99301 LOCMEUBJI ;
   si positif( LOCMEUBJS ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 LOCMEUBJS ;
   si positif( LOCMEUBJT ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 LOCMEUBJT ;
   si positif( LOCMEUBJU ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0
      alors erreur A99301 LOCMEUBJU ;
   si positif( PATNAT3 ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0
      alors erreur A99301 PATNAT3 ;
   si positif( PPEXT1 ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 PPEXT1 ;
   si positif( PPEXT2 ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 PPEXT2 ;
   si positif( PPEXT3 ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0
      alors erreur A99301 PPEXT3 ;
   si positif( PPEXT4 ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 PPEXT4 ;
   si positif( PPEXTC ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 PPEXTC ;
   si positif( PPEXTV ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0
      alors erreur A99301 PPEXTV ;
   si positif( REPFOR3 ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 REPFOR3 ;
   si positif( REPSINFOR3 ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0
      alors erreur A99301 REPSINFOR3 ;
   si positif( SALEXT1 ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 SALEXT1 ;
   si positif( SALEXT2 ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 SALEXT2 ;
   si positif( SALEXT3 ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0
      alors erreur A99301 SALEXT3 ;
   si positif( SALEXT4 ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 SALEXT4 ;
   si positif( SALEXTC ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 SALEXTC ;
   si positif( SALEXTV ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0
      alors erreur A99301 SALEXTV ;
   si positif( CELREPYA ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 CELREPYA ;
   si positif( CELREPYB ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 CELREPYB ;
   si positif( CELREPYC ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 CELREPYC ;
   si positif( CELREPYD ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 CELREPYD ;
   si positif( CELREPYE ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 CELREPYE ;
   si positif( CELREPYF ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 CELREPYF ;
   si positif( CELREPYG ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 CELREPYG ;
   si positif( CELREPYH ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 CELREPYH ;
   si positif( CELREPYI ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 CELREPYI ;
   si positif( CELREPYJ ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 CELREPYJ ;
   si positif( CELREPYK ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 CELREPYK ;
   si positif( CELREPYL ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 CELREPYL ;
   si positif( CELRREDLN ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 CELRREDLN ;
   si positif( CELRREDLX ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 CELRREDLX ;
   si positif( CELRREDLZ ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 CELRREDLZ ;
   si positif( CELRREDMH ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 CELRREDMH ;
   si positif( COD2LA ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 COD2LA ;
   si positif( COD2LB ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 COD2LB ;
   si positif( COD3UA ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 COD3UA ;
   si positif( COD3UL ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 COD3UL ;
   si positif( COD3UV ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 COD3UV ;
   si positif( COD7CR ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 COD7CR ;
   si positif( COD7CY ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 COD7CY ;
   si positif( COD7OA ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 COD7OA ;
   si positif( COD7OB ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 COD7OB ;
   si positif( COD7OC ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 COD7OC ;
   si positif( COD7OE ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 COD7OE ;
   si positif( COD7OU ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 COD7OU ;
   si positif( COD7PA ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 COD7PA ;
   si positif( COD7PB ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 COD7PB ;
   si positif( COD7PC ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 COD7PC ;
   si positif( COD7PD ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 COD7PD ;
   si positif( COD7PE ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 COD7PE ;
   si positif( COD7RG ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 COD7RG ;
   si positif( COD7RH ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 COD7RH ;
   si positif( COD7RI ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 COD7RI ;
   si positif( COD7RJ ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 COD7RJ ;
   si positif( COD7RK ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 COD7RK ;
   si positif( COD7RL ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 COD7RL ;
   si positif( COD7RN ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 COD7RN ;
   si positif( COD7RP ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 COD7RP ;
   si positif( COD7RQ ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 COD7RQ ;
   si positif( COD7RR ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 COD7RR ;
   si positif( COD7RS ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 COD7RS ;
   si positif( COD7RT ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 COD7RT ;
   si positif( COD7RV ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 COD7RV ;
   si positif( COD7RW ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 COD7RW ;
   si positif( COD7RX ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 COD7RX ;
   si positif( COD7SA ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 COD7SA ;
   si positif( COD7SB ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 COD7SB ;
   si positif( COD7SC ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 COD7SC ;
   si positif( COD7TV ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 COD7TV ;
   si positif( COD7TW ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 COD7TW ;
   si positif( COD7UA ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 COD7UA ;
   si positif( COD7UB ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 COD7UB ;
   si positif( COD7UI ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 COD7UI ;
   si positif( COD7VH ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 COD7VH ;
   si positif( COD7WB ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 COD7WB ;
   si positif( COD7WU ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 COD7WU ;
   si positif( COD7WX ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 COD7WX ;
   si positif( COD8XY ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 COD8XY ;
   si positif( COD8YM ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 COD8YM ;
   si positif( ACODELAISINR ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 ACODELAISINR ;
   si positif( CODHAA ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 CODHAA ;
   si positif( CODHAB ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 CODHAB ;
   si positif( CODHAC ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 CODHAC ;
   si positif( CODHAD ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 CODHAD ;
   si positif( CODHAE ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 CODHAE ;
   si positif( CODHAF ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 CODHAF ;
   si positif( CODHAG ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 CODHAG ;
   si positif( CODHAH ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 CODHAH ;
   si positif( CODHAI ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 CODHAI ;
   si positif( CODHAJ ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 CODHAJ ;
   si positif( CODHAK ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 CODHAK ;
   si positif( CODHAL ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 CODHAL ;
   si positif( CODHAM ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 CODHAM ;
   si positif( CODHAN ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 CODHAN ;
   si positif( CODHAO ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 CODHAO ;
   si positif( CODHAP ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 CODHAP ;
   si positif( CODHAQ ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 CODHAQ ;
   si positif( CODHAR ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 CODHAR ;
   si positif( CODHAS ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 CODHAS ;
   si positif( CODHAT ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 CODHAT ;
   si positif( CODHAU ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 CODHAU ;
   si positif( CODHAV ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 CODHAV ;
   si positif( CODHAW ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 CODHAW ;
   si positif( CODHAX ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 CODHAX ;
   si positif( CODHAY ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 CODHAY ;
   si positif( CODHBA ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 CODHBA ;
   si positif( CODHBB ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 CODHBB ;
   si positif( CODHBE ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 CODHBE ;
   si positif( CODHBF ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 CODHBF ;
   si positif( CODHBG ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 CODHBG ;
   si positif( CODHUG ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 CODHUG ;
   si positif( CODHXA ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 CODHXA ;
   si positif( CODHXB ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 CODHXB ;
   si positif( CODHXC ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 CODHXC ;
   si positif( CODHXE ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 CODHXE ;
   si positif( CODNAZ ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 CODNAZ ;
   si positif( CODNBZ ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 CODNBZ ;
   si positif( CODNCZ ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 CODNCZ ;
   si positif( CODNDZ ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 CODNDZ ;
   si positif( CODNEZ ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 CODNEZ ;
   si positif( CODNFZ ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 CODNFZ ;
   si positif( CODNVG ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 CODNVG ;
   si positif( CODRAZ ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 CODRAZ ;
   si positif( CODRBZ ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 CODRBZ ;
   si positif( CODRCZ ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 CODRCZ ;
   si positif( CODRDZ ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 CODRDZ ;
   si positif( CODREZ ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 CODREZ ;
   si positif( CODRFZ ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 CODRFZ ;
   si positif( CODRVG ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 CODRVG ;
   si positif( DUFLOFI ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 DUFLOFI ;
   si positif( DUFLOGH ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 DUFLOGH ;
   si positif( DUFLOGI ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 DUFLOGI ;
   si positif( PATNAT4 ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 PATNAT4 ;
   si positif( PENIN1 ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 PENIN1 ;
   si positif( PENIN2 ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 PENIN2 ;
   si positif( PENIN3 ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 PENIN3 ;
   si positif( PENIN4 ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 PENIN4 ;
   si positif( PENINC ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 PENINC ;
   si positif( PENINV ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 PENINV ;
   si positif( PINELQA ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 PINELQA ;
   si positif( PINELQB ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 PINELQB ;
   si positif( PINELQC ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 PINELQC ;
   si positif( PINELQD ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 PINELQD ;
   si positif( REPGROREP13 ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 REPGROREP13 ;
   si positif( REPSINFOR4 ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 REPSINFOR4 ;
   si positif( RFRN3 ) = 1 et positif(ANNUL2042) = 1 et APPLI_OCEANS = 0 
      alors erreur A99301 RFRN3 ;

verif 3041:
application : batch , iliad ;
si
   APPLI_COLBERT + APPLI_ILIAD = 1
   et
   V_ZDC + 0 = 0
   et
   V_0AC = 1
   et
   V_0AZ + 0 > 0

alors erreur AS0101 ;
verif 3042:
application : batch , iliad ;
si
   APPLI_COLBERT + APPLI_ILIAD = 1
   et
   V_ZDC + 0 = 0
   et
   BOOL_0AM = 1
   et
   V_0AX + 0 > 0
   et
   V_0AB + 0 > 0

alors erreur AS0102 ;
verif 3043:
application : batch , iliad ;
si
   APPLI_COLBERT + APPLI_ILIAD = 1
   et
   V_ZDC + 0 = 0
   et
   V_0AC + V_0AD + V_0AV + 0 = 1
   et
   V_0AX + 0 > 0
   et
   positif(V_0AB + 0) = 0

alors erreur AS0103 ;
verif 3044:
application : batch , iliad ;
si
   APPLI_COLBERT + APPLI_ILIAD = 1
   et
   V_ZDC + 0 = 0
   et
   BOOL_0AM = 1
   et
   V_0AY + 0 > 0

alors erreur AS0104 ;
verif 3045:
application : batch , iliad ;
si
   APPLI_COLBERT + APPLI_ILIAD = 1
   et
   V_ZDC + 0 = 0
   et
   V_0AM = 1
   et
   V_0AY + 0 > 0
   et
   V_0AZ + 0 > 0

alors erreur AS0105 ;
verif 3046:
application : batch , iliad ;
si
   APPLI_COLBERT + APPLI_ILIAD = 1
   et
   V_ZDC + 0 = 0
   et
   V_0AD = 1
   et
   V_0AZ + 0 > 0

alors erreur AS0106 ;
verif 3511:
application : iliad , batch ;
si (APPLI_OCEANS+APPLI_COLBERT = 0) et
   (( pour un i dans 0, 1, 2, 3, 4, 5, 6, 7: V_0Fi + 0 > V_ANREV )
   ou
   ( pour un j dans G, J, N, H, I, P et un i dans 0, 1, 2, 3: V_0ji + 0 > V_ANREV ))
 ou (APPLI_COLBERT+APPLI_OCEANS=1) et
   (( pour un i dans 0, 1, 2, 3, 4, 5, 6, 7: V_0Fi + 0 > V_ANREV )
   ou
   ( pour un j dans 0, 1, 2, 3: V_0Hj + 0 > V_ANREV ))

alors erreur AS02;
verif 3047:
application : batch ;
si
   APPLI_COLBERT = 1
   et
   positif(V_IND_TRAIT + 0) = 1
   et
   V_NOTRAIT + 0 < 14
   et
   present(V_ANTIR) = 0
   et
   positif(V_0DA + 0) = 0

alors erreur AS11 ;
