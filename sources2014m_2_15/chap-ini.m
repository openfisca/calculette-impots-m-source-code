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
regle irisf 1:
application : bareme,batch,iliad;
BIDON=1;

regle irisf 1000140:
application :  iliad;
APPLI_GP      = 0 ;
APPLI_ILIAD   = 1 ;
APPLI_BATCH   = 0 ;
regle irisf 1000150:
application :  batch;
APPLI_GP      = 0 ;
APPLI_ILIAD   = 0 ;
APPLI_BATCH   = 1 ;
regle 1000717:
application : batch, iliad ;
SOMMEA71701 = positif(CELLIERJA) + positif(CELLIERJB) + positif(CELLIERJD) + positif(CELLIERJE)
	     + positif(CELLIERJF) + positif(CELLIERJG) + positif(CELLIERJH) + positif(CELLIERJJ)
	     + positif(CELLIERJK) + positif(CELLIERJL) + positif(CELLIERJM) + positif(CELLIERJN)
	     + positif(CELLIERJO) + positif(CELLIERJP) + positif(CELLIERJQ) + positif(CELLIERJR) 
	     + 0 ;

SOMMEA71702 = positif(CELLIERNA) + positif(CELLIERNB) + positif(CELLIERNC) + positif(CELLIERND)
             + positif(CELLIERNE) + positif(CELLIERNF) + positif(CELLIERNG) + positif(CELLIERNH) 
	     + positif(CELLIERNI) + positif(CELLIERNJ) + positif(CELLIERNK) + positif(CELLIERNL)
	     + positif(CELLIERNM) + positif(CELLIERNN) + positif(CELLIERNO) + positif(CELLIERNP) 
	     + positif(CELLIERNQ) + positif(CELLIERNR) + positif(CELLIERNS) + positif(CELLIERNT) 
	     + 0 ;

regle 1000718:
application : batch, iliad ;

SOMMEA718 = (

   present( BAFV ) + (1 - null( V_FORVA+0 ))
 + present( BAFORESTV ) + present( BAFPVV ) + present( BAF1AV ) 
 + present( BAFC ) + (1 - null( V_FORCA+0 ))
 + present( BAFORESTC ) + present( BAFPVC ) + present( BAF1AC ) 
 + present( BAFP ) + (1 - null( V_FORPA+0 ))
 + present( BAFORESTP ) + present( BAFPVP ) + present( BAF1AP ) 
 + present( BACREV ) + present( 4BACREV ) + present( BA1AV ) + present( BACDEV ) 
 + present( BACREC ) + present( 4BACREC ) + present( BA1AC ) + present( BACDEC ) 
 + present( BACREP ) + present( 4BACREP ) + present( BA1AP ) + present( BACDEP ) 
 + present( BAHREV ) + present( 4BAHREV ) + present( BAHDEV ) 
 + present( BAHREC ) + present( 4BAHREC ) + present( BAHDEC ) 
 + present( BAHREP ) + present( 4BAHREP ) + present( BAHDEP ) 

 + present( MIBVENV ) + present( MIBPRESV ) + present( MIBPVV ) + present( MIB1AV ) + present( MIBDEV ) + present( BICPMVCTV )
 + present( MIBVENC ) + present( MIBPRESC ) + present( MIBPVC ) + present( MIB1AC ) + present( MIBDEC ) + present( BICPMVCTC )
 + present( MIBVENP ) + present( MIBPRESP ) + present( MIBPVP ) + present( MIB1AP ) + present( MIBDEP ) + present( BICPMVCTP )
 + present( BICNOV ) + present( LOCPROCGAV ) + present( BI1AV ) + present( BICDNV ) + present( LOCDEFPROCGAV )
 + present( BICNOC ) + present( LOCPROCGAC ) + present( BI1AC ) + present( BICDNC ) + present( LOCDEFPROCGAC )
 + present( BICNOP ) + present( LOCPROCGAP ) + present( BI1AP ) + present( BICDNP ) + present( LOCDEFPROCGAP )
 + present( BIHNOV ) + present( LOCPROV ) + present( BIHDNV ) + present( LOCDEFPROV )
 + present( BIHNOC ) + present( LOCPROC ) + present( BIHDNC ) + present( LOCDEFPROC )
 + present( BIHNOP ) + present( LOCPROP ) + present( BIHDNP ) + present( LOCDEFPROP )

 + present( MIBMEUV ) + present( MIBGITEV ) + present( LOCGITV ) + present( MIBNPVENV ) + present( MIBNPPRESV ) 
 + present( MIBNPPVV ) + present( MIBNP1AV ) + present( MIBNPDEV ) 
 + present( MIBMEUC ) + present( MIBGITEC ) + present( LOCGITC ) + present( MIBNPVENC ) + present( MIBNPPRESC ) 
 + present( MIBNPPVC ) + present( MIBNP1AC ) + present( MIBNPDEC ) 
 + present( MIBMEUP ) + present( MIBGITEP ) + present( LOCGITP ) + present( MIBNPVENP ) + present( MIBNPPRESP ) 
 + present( MIBNPPVP ) + present( MIBNP1AP ) + present( MIBNPDEP ) 
 + present( MIBNPDCT ) 
 + present( BICREV ) + present( LOCNPCGAV ) + present( LOCGITCV ) + present( BI2AV ) + present( BICDEV ) + present( LOCDEFNPCGAV )
 + present( BICREC ) + present( LOCNPCGAC ) + present( LOCGITCC ) + present( BI2AC ) + present( BICDEC ) + present( LOCDEFNPCGAC )
 + present( BICREP ) + present( LOCNPCGAPAC ) + present( LOCGITCP ) + present( BI2AP ) + present( BICDEP ) + present( LOCDEFNPCGAPAC )
 + present( BICHREV ) + present( LOCNPV ) + present( LOCGITHCV ) + present( BICHDEV ) + present( LOCDEFNPV )
 + present( BICHREC ) + present( LOCNPC ) + present( LOCGITHCC ) + present( BICHDEC ) + present( LOCDEFNPC )
 + present( BICHREP ) + present( LOCNPPAC ) + present( LOCGITHCP ) + present( BICHDEP ) + present( LOCDEFNPPAC )

 + present( BNCPROV ) + present( BNCPROPVV ) + present( BNCPRO1AV ) + present( BNCPRODEV ) + present( BNCPMVCTV )
 + present( BNCPROC ) + present( BNCPROPVC ) + present( BNCPRO1AC ) + present( BNCPRODEC ) + present( BNCPMVCTC )
 + present( BNCPROP ) + present( BNCPROPVP ) + present( BNCPRO1AP ) + present( BNCPRODEP ) + present( BNCPMVCTP )
 + present( BNCREV ) + present( BN1AV ) + present( BNCDEV ) 
 + present( BNCREC ) + present( BN1AC ) + present( BNCDEC ) 
 + present( BNCREP ) + present( BN1AP ) + present( BNCDEP ) 
 + present( BNHREV ) + present( BNHDEV ) 
 + present( BNHREC ) + present( BNHDEC ) 
 + present( BNHREP ) + present( BNHDEP ) 

 + present( BNCNPV ) + present( BNCNPPVV ) + present( BNCNP1AV ) + present( BNCNPDEV ) 
 + present( BNCNPC ) + present( BNCNPPVC ) + present( BNCNP1AC ) + present( BNCNPDEC ) 
 + present( BNCNPP ) + present( BNCNPPVP ) + present( BNCNP1AP ) + present( BNCNPDEP ) 
 + present( BNCNPDCT ) 
 + present ( BNCAABV ) + present( ANOCEP ) + present( PVINVE ) 
 + present( INVENTV ) + present ( BNCAADV ) + present( DNOCEP ) 
 + present ( BNCAABC ) + present( ANOVEP ) + present( PVINCE ) 
 + present( INVENTC ) + present ( BNCAADC ) + present( DNOCEPC )
 + present ( BNCAABP ) + present( ANOPEP ) + present( PVINPE ) 
 + present ( INVENTP ) + present ( BNCAADP ) + present( DNOCEPP )
 + 0
            ) ;

regle 1000719:
application : batch, iliad ;

SOMMEA719 = (

   present( BAEXV ) + present ( BACREV ) + present( 4BACREV ) + present ( BA1AV ) + present ( BACDEV ) 
 + present( BAEXC ) + present ( BACREC ) + present( 4BACREC ) + present ( BA1AC ) + present ( BACDEC ) 
 + present( BAEXP ) + present ( BACREP ) + present( 4BACREP ) + present ( BA1AP ) + present ( BACDEP ) 
 + present( BAHEXV ) + present ( BAHREV ) + present( 4BAHREV ) + present ( BAHDEV ) 
 + present( BAHEXC ) + present ( BAHREC ) + present( 4BAHREC ) + present ( BAHDEC ) 
 + present( BAHEXP ) + present ( BAHREP ) + present( 4BAHREP ) + present ( BAHDEP ) 

 + present( BICEXV ) + present ( BICNOV ) + present ( LOCPROCGAV )
 + present ( BI1AV ) + present ( BICDNV ) + present ( LOCDEFPROCGAV )
 + present( BICEXC ) + present ( BICNOC ) + present ( LOCPROCGAC )
 + present ( BI1AC ) + present ( BICDNC ) + present ( LOCDEFPROCGAC )
 + present( BICEXP ) + present ( BICNOP ) + present ( LOCPROCGAP )
 + present ( BI1AP ) + present ( BICDNP ) + present ( LOCDEFPROCGAP )
 + present( BIHEXV ) + present ( BIHNOV ) + present ( LOCPROV )
 + present ( BIHDNV ) + present ( LOCDEFPROV )
 + present( BIHEXC ) + present ( BIHNOC ) + present ( LOCPROC )
 + present ( BIHDNC ) + present ( LOCDEFPROC )
 + present( BIHEXP ) + present ( BIHNOP ) + present ( LOCPROP )
 + present ( BIHDNP ) + present ( LOCDEFPROP )

 + present( BICNPEXV ) + present ( BICREV ) + present( LOCNPCGAV )
 + present ( BI2AV ) + present ( BICDEV ) + present( LOCDEFNPCGAV )
 + present( BICNPEXC ) + present ( BICREC ) + present( LOCNPCGAC )
 + present ( BI2AC ) + present ( BICDEC ) + present( LOCDEFNPCGAC )
 + present( BICNPEXP ) + present ( BICREP ) + present( LOCNPCGAPAC )
 + present ( BI2AP ) + present ( BICDEP ) + present( LOCDEFNPCGAPAC )
 + present( BICNPHEXV ) + present ( BICHREV ) + present ( LOCNPV )
 + present ( BICHDEV ) + present ( LOCDEFNPV )
 + present( BICNPHEXC ) + present ( BICHREC ) + present ( LOCNPC )
 + present ( BICHDEC ) + present ( LOCDEFNPC )
 + present( BICNPHEXP ) + present ( BICHREP ) + present ( LOCNPPAC )
 + present ( BICHDEP ) + present ( LOCDEFNPPAC )

 + present( BNCEXV ) + present ( BNCREV ) + present ( BN1AV ) + present ( BNCDEV ) 
 + present( BNCEXC ) + present ( BNCREC ) + present ( BN1AC ) + present ( BNCDEC ) 
 + present( BNCEXP ) + present ( BNCREP ) + present ( BN1AP ) + present ( BNCDEP ) 
 + present( BNHEXV ) + present ( BNHREV ) + present ( BNHDEV ) 
 + present( BNHEXC ) + present ( BNHREC ) + present ( BNHDEC ) 
 + present( BNHEXP ) + present ( BNHREP ) + present ( BNHDEP )
 + present( XHONOAAV ) + present( XHONOV ) 
 + present( XHONOAAC ) + present( XHONOC ) 
 + present( XHONOAAP ) + present( XHONOP )

 + present ( BNCNPREXAAV ) + present ( BNCAABV )   + present ( BNCAADV )  + present ( BNCNPREXV ) 
 + present( ANOCEP ) + present( DNOCEP ) + present( PVINVE ) + present( INVENTV )
 + present ( BNCNPREXAAC ) + present ( BNCAABC ) + present ( BNCAADC ) + present ( BNCNPREXC )
 + present( ANOVEP ) + present( DNOCEPC ) + present( PVINCE ) + present( INVENTC )
 + present ( BNCNPREXAAP ) + present ( BNCAABP ) + present ( BNCAADP ) + present ( BNCNPREXP )
 + present( ANOPEP ) + present( DNOCEPP ) + present( PVINPE ) + present( INVENTP )

 + 0
        ) ;

regle 1000530:
application : batch, iliad;

SOMMEA030 =     
                somme(i=1..4: positif(TSHALLOi) + positif(ALLOi)
		+ positif(CARTSPi) + positif(REMPLAPi)
		+ positif(CARTSNBAPi) + positif(REMPLANBPi)
                + positif(PRBRi)
		+ positif(CARPEPi) + positif(CARPENBAPi)
                + positif(PALIi) + positif(FRNi) + positif(PPETPPi) + positif(PPENHPi)
		+ positif(PENSALPi) + positif(PENSALNBPi)
		)
 + positif(RSAPAC1) + positif(RSAPAC2)
 + positif(FEXP)  + positif(BAFP)  + positif(BAFORESTP) + positif(BAFPVP)  + positif(BAF1AP)
 + positif(BAEXP)  + positif(BACREP) + positif(4BACREP)  
 + positif(BA1AP)  + positif(BACDEP * (1 - positif(ART1731BIS) ))
 + positif(BAHEXP)  + positif(BAHREP) + positif(4BAHREP) 
 + positif(BAHDEP * (1 - positif(ART1731BIS) )) 
 + positif(MIBEXP) + positif(MIBVENP) + positif(MIBPRESP)  + positif(MIBPVP)  + positif(MIB1AP)  + positif(MIBDEP)
 + positif(BICPMVCTP) + positif(BICEXP) + positif(BICNOP) + positif(BI1AP)  
 + positif(BICDNP * (1 - positif(ART1731BIS) )) 
 + positif(BIHEXP) + positif(BIHNOP) + positif(BIHDNP * (1 - positif(ART1731BIS) ))  
 + positif(MIBNPEXP)  + positif(MIBNPVENP)  + positif(MIBNPPRESP)  + positif(MIBNPPVP)  + positif(MIBNP1AP)  + positif(MIBNPDEP)
 + positif(BICNPEXP)  + positif(BICREP) + positif(BI2AP)  + positif(min(BICDEP,BICDEP1731+0) * positif(ART1731BIS) + BICDEP * (1 - ART1731BIS))  
 + positif(BICNPHEXP) + positif(BICHREP) + positif(min(BICHDEP,BICHDEP1731+0) * positif(ART1731BIS) + BICHDEP * (1 - ART1731BIS)) 
 + positif(BNCPROEXP)  + positif(BNCPROP)  + positif(BNCPROPVP)  + positif(BNCPRO1AP)  + positif(BNCPRODEP) + positif(BNCPMVCTP)
 + positif(BNCEXP)  + positif(BNCREP) + positif(BN1AP) 
 + positif(BNCDEP * (1 - positif(ART1731BIS) ))
 + positif(BNHEXP)  + positif(BNHREP)  + positif(BNHDEP * (1 - positif(ART1731BIS) )) + positif(BNCCRP)
 + positif(BNCNPP)  + positif(BNCNPPVP)  + positif(BNCNP1AP)  + positif(BNCNPDEP)
 + positif(ANOPEP) + positif(PVINPE) + positif(INVENTP) + positif(min(DNOCEPP,DNOCEPP1731+0) * positif(ART1731BIS) + DNOCEPP * (1 - ART1731BIS)) + positif(BNCCRFP)
 + positif(BNCAABP) + positif(min(BNCAADP,BNCAADP1731+0) * positif(ART1731BIS) + BNCAADP * (1 - ART1731BIS))
 + positif(RCSP) + positif(PPEACP) + positif(PPENJP)
 + positif(BAPERPP) + positif(BIPERPP) 
 + positif(PERPP) + positif(PERP_COTP) + positif(RACCOTP) + positif(PLAF_PERPP)
 + somme(i=1..4: positif(PEBFi))
 + positif( COTF1 ) + positif( COTF2 ) + positif( COTF3 ) + positif( COTF4 )
 + positif (BNCNPREXAAP) + positif (BNCNPREXP)
 + positif(AUTOBICVP) + positif(AUTOBICPP) 
 + positif(AUTOBNCP) + positif(LOCPROCGAP) 
 + positif(LOCDEFPROCGAP * (1 - positif(ART1731BIS) ))
 + positif(LOCPROP) + positif(LOCDEFPROP * (1 - positif(ART1731BIS) )) 
 + positif(LOCNPCGAPAC) + positif(LOCGITCP) + positif(LOCGITHCP) 
 + positif(min(LOCDEFNPCGAPAC,LOCDEFNPCGAPAC1731+0) * positif(ART1731BIS) + LOCDEFNPCGAPAC * (1 - ART1731BIS))
 + positif(LOCNPPAC) + positif(min(LOCDEFNPPAC,LOCDEFNPPAC1731+0) * positif(ART1731BIS) + LOCDEFNPPAC * (1 - ART1731BIS)) 
 + positif(XHONOAAP) + positif(XHONOP) + positif(XSPENPP)
 + positif(BANOCGAP) + positif(MIBMEUP) + positif(MIBGITEP) + positif(LOCGITP) 
 + positif(SALEXT1) + positif(COD1CD) + positif(COD1CE) + positif(PPEXT1) + positif(COD1CH)
 + positif(SALEXT2) + positif(COD1DD) + positif(COD1DE) + positif(PPEXT2) + positif(COD1DH)
 + positif(SALEXT3) + positif(COD1ED) + positif(COD1EE) + positif(PPEXT3) + positif(COD1EH)
 + positif(SALEXT4) + positif(COD1FD) + positif(COD1FE) + positif(PPEXT4) + positif(COD1FH)
 + positif(RDSYPP)
 + positif(PENIN1) + positif(PENIN2) + positif(PENIN3) + positif(PENIN4)
 + positif(CODRCZ) + positif(CODRDZ) + positif(CODREZ) + positif(CODRFZ)
 + 0 ;

regle 1000531:
application : batch, iliad;

SOMMEA031 = (

   positif( TSHALLOC ) + positif( ALLOC ) + positif( PRBRC ) 
 + positif( PALIC ) + positif( GSALC ) + positif( TSASSUC ) + positif( XETRANC ) 
 + positif( EXOCETC ) + positif( FRNC ) 
 + positif( PPETPC ) + positif( PPENHC )  + positif( PCAPTAXC )
 + positif( CARTSC ) + positif( PENSALC ) + positif( REMPLAC ) + positif( CARPEC ) 
 + positif( GLDGRATC ) 
 + positif( GLD1C ) + positif( GLD2C ) + positif( GLD3C ) 

 + positif( BPV18C ) + positif( BPCOPTC ) + positif( BPV40C ) 
 + positif( BPCOSAC ) + positif( CVNSALAC )

 + positif( FEXC ) + positif( BAFC ) + positif( BAFORESTC ) + positif( BAFPVC ) + positif( BAF1AC ) 
 + positif( BAEXC ) + positif( BACREC ) + positif( 4BACREC ) + positif( BA1AC ) 
 + positif(BACDEC * (1 - positif(ART1731BIS) )) 
 + positif( BAHEXC ) + positif( BAHREC ) + positif( 4BAHREC ) 
 + positif (BAHDEC * (1 - positif(ART1731BIS) ))   + positif( BAPERPC ) + positif( BANOCGAC ) 
 + positif( AUTOBICVC ) + positif( AUTOBICPC ) + positif( AUTOBNCC ) 
 + positif( MIBEXC ) + positif( MIBVENC ) + positif( MIBPRESC ) + positif( MIBPVC ) 
 + positif( MIB1AC ) + positif( MIBDEC ) + positif( BICPMVCTC )
 + positif( BICEXC ) + positif( BICNOC ) + positif( LOCPROCGAC ) + positif( BI1AC ) 
 + positif (BICDNC * (1 - positif(ART1731BIS) ))  
 + positif (LOCDEFPROCGAC * (1 - positif(ART1731BIS) ))
 + positif( BIHEXC ) + positif( BIHNOC ) + positif( LOCPROC ) + positif(BIHDNC * (1 - positif(ART1731BIS) ))  
 + positif (LOCDEFPROC * (1 - positif(ART1731BIS) )) 
 + positif( BIPERPC ) 
 + positif( MIBNPEXC ) + positif( MIBNPVENC ) + positif( MIBNPPRESC ) + positif( MIBNPPVC ) + positif( MIBNP1AC ) + positif( MIBNPDEC ) 
 + positif( BICNPEXC ) + positif( BICREC ) + positif( LOCNPCGAC ) + positif( BI2AC ) 
 + positif (min(BICDEC,BICDEC1731+0) * positif(ART1731BIS) + BICDEC * (1 - ART1731BIS))
 + positif (min(LOCDEFNPCGAC,LOCDEFNPCGAC1731+0) * positif(ART1731BIS) + LOCDEFNPCGAC * (1 - ART1731BIS))
 + positif( MIBMEUC ) + positif( MIBGITEC ) + positif( LOCGITC ) + positif( LOCGITCC ) + positif( LOCGITHCC )
 + positif( BICNPHEXC ) + positif( BICHREC ) + positif( LOCNPC ) 
 + positif (min(BICHDEC,BICHDEC1731+0) * positif(ART1731BIS) + BICHDEC * (1 - ART1731BIS)) 
 + positif (min(LOCDEFNPC,LOCDEFNPC1731+0) * positif(ART1731BIS) + LOCDEFNPC * (1 - ART1731BIS)) 
 + positif( BNCPROEXC ) + positif( BNCPROC ) + positif( BNCPROPVC ) + positif( BNCPRO1AC ) + positif( BNCPRODEC ) + positif( BNCPMVCTC )
 + positif( BNCEXC ) + positif( BNCREC ) + positif( BN1AC ) 
 + positif (BNCDEC * (1 - positif(ART1731BIS) ))  
 + positif( BNHEXC ) + positif( BNHREC ) + positif (BNHDEC * (1 - positif(ART1731BIS) )) + positif( BNCCRC ) + positif( CESSASSC )
 + positif( XHONOAAC ) + positif( XHONOC ) + positif( XSPENPC )
 + positif( BNCNPC ) + positif( BNCNPPVC ) + positif( BNCNP1AC ) + positif( BNCNPDEC ) 
 + positif( BNCNPREXAAC ) + positif( BNCAABC ) + positif(min(BNCAADC,BNCAADC1731+0) * positif(ART1731BIS) + BNCAADC * (1 - ART1731BIS)) + positif( BNCNPREXC ) + positif( ANOVEP )
 + positif( PVINCE ) + positif( INVENTC ) + positif (min(DNOCEPC,DNOCEPC1731+0) * positif(ART1731BIS) + DNOCEPC * (1 - ART1731BIS)) + positif( BNCCRFC )
 + positif( RCSC ) + positif( PVSOCC ) + positif( PPEACC ) + positif( PPENJC ) 
 + positif( PEBFC ) 
 + positif( PERPC ) + positif( PERP_COTC ) + positif( RACCOTC ) + positif( PLAF_PERPC )
 + positif( PERPPLAFCC ) + positif( PERPPLAFNUC1 ) + positif( PERPPLAFNUC2 ) + positif( PERPPLAFNUC3 )
 + positif( ELURASC )
 + positif(CODDBJ) + positif(CODEBJ)  
 + positif(SALEXTC) + positif(COD1BD) + positif(COD1BE) + positif(PPEXTC) + positif(COD1BH)
 + positif(RDSYCJ)
 + positif(PENINC) + positif(CODRBZ)

 + 0 ) ;
regle 1000804:
application : iliad , batch;  


SOMMEA804 = SOMMEANOEXP 
	    + positif ( GLD1V ) + positif ( GLD2V ) + positif ( GLD3V ) 
            + positif ( GLD1C ) + positif ( GLD2C ) + positif ( GLD3C ) 
           ;

SOMMEA805 = SOMMEANOEXP + positif(CODDAJ) + positif(CODEAJ) + positif(CODDBJ) + positif(CODEBJ) 
            + positif ( CARTSV ) + positif ( CARTSNBAV ) + positif ( CARTSC ) + positif ( CARTSNBAC ) ;

regle 10009931:
application : iliad , batch;  

SOMMEA899 = present( BICEXV ) + present( BICNOV ) + present( BI1AV ) + present( BICDNV )
            + present( BICEXC ) + present( BICNOC ) + present( BI1AC ) + present( BICDNC )
	    + present( BICEXP ) + present( BICNOP ) + present( BI1AP ) + present( BICDNP )
	    + present( BIHEXV ) + present( BIHNOV ) + present( BIHDNV )
	    + present( BIHEXC ) + present( BIHNOC ) + present( BIHDNC )
	    + present( BIHEXP ) + present( BIHNOP ) + present( BIHDNP )
	    ;

SOMMEA859 = present( BICEXV ) + present( BICNOV ) + present( BI1AV ) + present( BICDNV )
            + present( BICEXC ) + present( BICNOC ) + present( BI1AC ) + present( BICDNC )
	    + present( BICEXP ) + present( BICNOP ) + present( BI1AP ) + present( BICDNP )
	    + present( BIHEXV ) + present( BIHNOV ) + present( BIHDNV )
	    + present( BIHEXC ) + present( BIHNOC ) + present( BIHDNC )
	    + present( BIHEXP ) + present( BIHNOP ) + present( BIHDNP )
	    ;

SOMMEA860 = present( BICEXV ) + present( BICNOV ) + present( BI1AV ) + present( BICDNV )
            + present( BICEXC ) + present( BICNOC ) + present( BI1AC ) + present( BICDNC )
	    + present( BICEXP ) + present( BICNOP ) + present( BI1AP ) + present( BICDNP )
	    + present( BIHEXV ) + present( BIHNOV ) + present( BIHDNV )
	    + present( BIHEXC ) + present( BIHNOC ) + present( BIHDNC )
	    + present( BIHEXP ) + present( BIHNOP ) + present( BIHDNP )
            + present( BNCEXV ) + present( BNCREV ) + present( BN1AV ) + present( BNCDEV )
	    + present( BNCEXC ) + present( BNCREC ) + present( BN1AC ) + present( BNCDEC )
	    + present( BNCEXP ) + present( BNCREP ) + present( BN1AP ) + present( BNCDEP )
	    + present( BNHEXV ) + present( BNHREV ) + present( BNHDEV )
	    + present( BNHEXC ) + present( BNHREC ) + present( BNHDEC )
	    + present( BNHEXP ) + present( BNHREP ) + present( BNHDEP )
            ;

SOMMEA895 = present( BAEXV ) + present( BACREV ) + present( 4BACREV )
            + present( BA1AV ) + present( BACDEV )
            + present( BAEXC ) + present( BACREC ) + present( 4BACREC )
            + present( BA1AC ) + present( BACDEC )
	    + present( BAEXP ) + present( BACREP ) + present( 4BACREP )
	    + present( BA1AP ) + present( BACDEP )
	    + present( BAHEXV ) + present( BAHREV ) + present( 4BAHREV )
	    + present( BAHDEV )
	    + present( BAHEXC ) + present( BAHREC ) + present( 4BAHREC )
	    + present( BAHDEC )
	    + present( BAHEXP ) + present( BAHREP ) + present( 4BAHREP )
	    + present( BAHDEP )
	    + present( FEXV ) + present( BAFV ) + (1 - null( V_FORVA+0 )) + present( BAFPVV ) + present( BAF1AV )
            + present( FEXC ) + present( BAFC ) + (1 - null( V_FORCA+0 )) + present( BAFPVC ) + present( BAF1AC )
            + present( FEXP ) + present( BAFP ) + (1 - null( V_FORPA+0 )) + present( BAFPVP ) + present( BAF1AP ) 
	    ;

SOMMEA898 = SOMMEA895 ;

SOMMEA881 =  
	     present( BAEXV ) + present( BACREV ) + present( 4BACREV ) + present( BA1AV ) + present( BACDEV )
           + present( BAEXC ) + present( BACREC ) + present( 4BACREC ) + present( BA1AC ) + present( BACDEC )
	   + present( BAEXP ) + present( BACREP ) + present( 4BACREP ) + present( BA1AP ) + present( BACDEP )
	   + present( BAHEXV ) + present( BAHREV ) + present( 4BAHREV ) + present( BAHDEV )
	   + present( BAHEXC ) + present( BAHREC ) + present( 4BAHREC ) + present( BAHDEC )
	   + present( BAHEXP ) + present( BAHREP ) + present( 4BAHREP ) + present( BAHDEP )

	   + present( BICEXV ) + present( BICNOV ) + present( BI1AV ) + present( BICDNV )
	   + present( BICEXC ) + present( BICNOC ) + present( BI1AC )
	   + present( BICDNC ) + present( BICEXP ) + present( BICNOP ) 
	   + present( BI1AP ) + present( BICDNP ) + present( BIHEXV ) + present( BIHNOV )
	   + present( BIHDNV ) + present( BIHEXC )
	   + present( BIHNOC ) + present( BIHDNC ) 
	   + present( BIHEXP ) + present( BIHNOP ) + present( BIHDNP )
	   + present( BICNPEXV ) + present( BICREV ) + present( BI2AV )
	   + present( BICDEV ) + present( BICNPEXC ) + present( BICREC ) 
	   + present( BI2AC ) + present( BICDEC ) + present( BICNPEXP ) + present( BICREP )
	   + present( BI2AP ) + present( BICDEP ) + present( BICNPHEXV )
	   + present( BICHREV ) + present( BICHDEV ) 
	   + present( BICNPHEXC ) + present( BICHREC ) + present( BICHDEC )
	   + present( BICNPHEXP ) + present( BICHREP ) 
	   + present( BICHDEP ) 
	   + present( LOCPROCGAV ) + present( LOCDEFPROCGAV ) 
	   + present( LOCPROCGAC ) + present( LOCDEFPROCGAC ) 
	   + present( LOCPROCGAP ) + present( LOCDEFPROCGAP )
	   + present( LOCPROV ) + present( LOCDEFPROV ) + present( LOCPROC )
	   + present( LOCDEFPROC ) + present( LOCPROP ) + present( LOCDEFPROP )
	   + present( LOCNPCGAV ) + present( LOCGITCV ) + present( LOCDEFNPCGAV ) 
	   + present( LOCNPCGAC ) + present( LOCGITCC ) + present( LOCDEFNPCGAC ) 
	   + present( LOCNPCGAPAC ) + present( LOCGITCP ) + present( LOCDEFNPCGAPAC )
	   + present( LOCNPV ) + present( LOCGITHCV ) + present( LOCDEFNPV ) 
	   + present( LOCNPC ) + present( LOCGITHCC ) + present( LOCDEFNPC ) 
	   + present( LOCNPPAC ) + present( LOCGITHCP ) + present( LOCDEFNPPAC )
           + present( BAPERPV ) + present( BAPERPC ) + present( BAPERPP)
           + present( BANOCGAV ) + present( BANOCGAC ) + present( BANOCGAP )

	   + present( BNCEXV ) + present( BNCREV ) + present( BN1AV ) + present( BNCDEV ) 
	   + present( BNCEXC ) + present( BNCREC ) + present( BN1AC ) + present( BNCDEC )
	   + present( BNCEXP ) + present( BNCREP ) + present( BN1AP ) + present( BNCDEP ) 
	   + present( BNHEXV ) + present( BNHREV ) + present( BNHDEV ) 
	   + present( BNHEXC ) + present( BNHREC ) + present( BNHDEC ) 
	   + present( BNHEXP ) + present( BNHREP ) + present( BNHDEP ) 
           + present( XHONOAAV ) + present( XHONOV ) 
	   + present( XHONOAAC ) + present( XHONOC ) 
	   + present( XHONOAAP ) + present( XHONOP )

	   + present ( BNCAABV ) + present ( ANOCEP ) + present ( INVENTV ) 
	   + present ( PVINVE ) + present ( BNCAADV ) + present ( DNOCEP ) 
	   + present ( BNCAABC ) + present ( ANOVEP ) + present ( INVENTC ) 
	   + present ( PVINCE ) + present ( BNCAADC ) + present ( DNOCEPC )
	   + present ( BNCAABP ) + present ( ANOPEP ) + present ( INVENTP )
	   + present ( PVINPE ) + present ( BNCAADP ) + present ( DNOCEPP )
           + present( BNCNPREXAAV ) + present( BNCNPREXAAC ) + present( BNCNPREXAAP )
           + present( BNCNPREXV ) + present( BNCNPREXC ) + present( BNCNPREXP )
	   ;

SOMMEA858 = SOMMEA881 + present(TSHALLOV) + present(TSHALLOC) + present(TSASSUV) + present(TSASSUC)
                      + present(RFMIC) + present(RFORDI) + present(RFDORD) + present(RFDHIS) ;

SOMMEA861 = SOMMEA881 ;

SOMMEA890 = SOMMEA881  + present( TSHALLOV ) + present( TSHALLOC ) 
		       + present( CARTSV ) + present( CARTSC )
		       + present( CARTSNBAV ) + present( CARTSNBAC ) ;

SOMMEA891 = SOMMEA881 ;

SOMMEA892 = SOMMEA881 ;

SOMMEA893 = SOMMEA881 ;

SOMMEA894 = SOMMEA881 ;

SOMMEA896 = SOMMEA881 ;

SOMMEA897 = SOMMEA881 ;

SOMMEA885 =  present( BA1AV ) + present( BA1AC ) + present( BA1AP )
           + present( BI1AV ) + present( BI1AC ) + present( BI1AP ) 
	   + present( BN1AV ) + present( BN1AC ) + present( BN1AP ) ;

SOMMEA880 =  present ( BICEXV ) + present ( BICNOV ) + present ( BI1AV )
           + present ( BICDNV ) + present ( BICEXC ) + present ( BICNOC )
	   + present ( BI1AC ) + present ( BICDNC ) 
	   + present ( BICEXP ) + present ( BICNOP ) + present ( BI1AP )
	   + present ( BICDNP ) + present ( BIHEXV ) + present ( BIHNOV )
           + present ( BIHDNV ) + present ( BIHEXC )
	   + present ( BIHNOC ) + present ( BIHDNC ) 
	   + present ( BIHEXP ) + present ( BIHNOP ) + present ( BIHDNP )
	   + present ( LOCPROCGAV ) + present ( LOCDEFPROCGAV ) + present ( LOCPROCGAC )
	   + present ( LOCDEFPROCGAC ) + present ( LOCPROCGAP ) + present ( LOCDEFPROCGAP )
	   + present ( LOCPROV ) + present ( LOCDEFPROV ) + present ( LOCPROC )
	   + present ( LOCDEFPROC ) + present ( LOCPROP ) + present ( LOCDEFPROP )
	   ;

SOMMEA874 =  somme(i=V,C,1,2,3,4:present(TSHALLOi) + present(ALLOi) + present(PRBRi) + present(PALIi) + present(PENINi))
            + present ( CARTSV ) + present ( CARTSC ) + present ( CARTSP1 )
            + present ( CARTSP2 ) + present ( CARTSP3) + present ( CARTSP4 )
            + present ( CARTSNBAV ) + present ( CARTSNBAC ) + present ( CARTSNBAP1 )
            + present ( CARTSNBAP2 ) + present ( CARTSNBAP3) + present ( CARTSNBAP4 )
            + present ( REMPLAV ) + present ( REMPLAC ) + present ( REMPLAP1 )
            + present ( REMPLAP2 ) + present ( REMPLAP3 ) + present ( REMPLAP4 )
            + present ( REMPLANBV ) + present ( REMPLANBC ) + present ( REMPLANBP1 )
            + present ( REMPLANBP2 ) + present ( REMPLANBP3 ) + present ( REMPLANBP4 )
            + present ( CARPEV ) + present ( CARPEC ) + present ( CARPEP1 )
            + present ( CARPEP2 ) + present ( CARPEP3 ) + present ( CARPEP4 )
            + present ( CARPENBAV ) + present ( CARPENBAC ) + present ( CARPENBAP1 )
            + present ( CARPENBAP2 ) + present ( CARPENBAP3 ) + present ( CARPENBAP4 )
            + present ( PENSALV ) + present ( PENSALC ) + present ( PENSALP1 )
            + present ( PENSALP2 ) + present ( PENSALP3 ) + present ( PENSALP4 )
            + present ( PENSALNBV ) + present ( PENSALNBC ) + present ( PENSALNBP1 )
            + present ( PENSALNBP2 ) + present ( PENSALNBP3 ) + present ( PENSALNBP4 )
	    + somme(k=V,C,P: somme (i=C,H: present(BIiNOk)  
		           + somme(j = N: present(BIiDjk))) 
	                   + somme (i = I: present(Bi1Ak)) 
		  )
            + present(CODRAZ) + present(CODRBZ) + present(CODRCZ) 
            + present(CODRDZ) + present(CODREZ) + present(CODRFZ)
	    + present ( RVB1 ) + present ( RVB2 ) + present ( RVB3 ) + present ( RVB4 )
	    + present ( RENTAX ) + present ( RENTAX5 ) + present ( RENTAX6 ) + present ( RENTAX7 )
	    + present ( RENTAXNB ) + present ( RENTAXNB5 ) + present ( RENTAXNB6 ) + present ( RENTAXNB7 )
	    + present( RCMABD ) + present( RCMHAD ) + present( REGPRIV ) + present( RCMIMPAT )
	    + present( REVACT ) + present( DISQUO ) + present( RESTUC )
	    + present( REVACTNB ) + present( DISQUONB ) + present ( RESTUCNB )
            + present( COD2FA ) + present( RCMHAB ) + present( INTERE )
	    + present ( MIBVENV ) + present ( MIBPRESV ) + present ( MIB1AV ) + present ( MIBDEV ) 
	    + present ( MIBVENC ) + present ( MIBPRESC ) + present ( MIB1AC ) + present ( MIBDEC ) 
	    + present ( MIBVENP ) + present ( MIBPRESP ) + present ( MIB1AP ) + present ( MIBDEP ) 
	    + present( LOCPROCGAV ) + present( LOCDEFPROCGAV ) + present( LOCPROCGAC )
	    + present( LOCDEFPROCGAC ) + present( LOCPROCGAP ) + present( LOCDEFPROCGAP )
	    + present( LOCPROV ) + present( LOCDEFPROV ) + present( LOCPROC )
	    + present( LOCDEFPROC ) + present( LOCPROP ) + present( LOCDEFPROP )
	    + present( BICREV ) + present( LOCNPCGAV ) + present( LOCGITCV ) + present( BI2AV ) + present( BICDEV ) + present( LOCDEFNPCGAV ) 
	    + present( BICREC ) + present( LOCNPCGAC ) + present( LOCGITCC ) + present( BI2AC ) + present( BICDEC ) + present( LOCDEFNPCGAC ) 
	    + present( BICREP ) + present( LOCNPCGAPAC ) + present( LOCGITCP ) + present( BI2AP  ) + present( BICDEP ) + present( LOCDEFNPCGAPAC )
	    + present( BICHREV ) + present( LOCNPV ) + present( LOCGITHCV ) + present( BICHDEV ) + present( LOCDEFNPV ) 
	    + present( BICHREC ) + present( LOCNPC ) + present( LOCGITHCC ) + present( BICHDEC ) + present( LOCDEFNPC ) 
	    + present( BICHREP ) + present( LOCNPPAC ) + present( LOCGITHCP ) + present( BICHDEP ) + present( LOCDEFNPPAC )
	    + present( MIBMEUV ) + present( MIBGITEV ) + present( LOCGITV ) + present( MIBNPVENV ) 
	    + present( MIBNPPRESV ) + present( MIBNP1AV ) + present( MIBNPDEV ) 
	    + present( MIBMEUC ) + present( MIBGITEC ) + present( LOCGITC ) + present( MIBNPVENC ) 
	    + present( MIBNPPRESC ) + present( MIBNP1AC ) + present( MIBNPDEC ) 
	    + present( MIBMEUP ) + present( MIBGITEP ) + present( LOCGITP ) + present( MIBNPVENP ) 
	    + present( MIBNPPRESP ) + present( MIBNP1AP ) + present( MIBNPDEP ) 
	    + present ( BNCREV ) + present ( BN1AV ) + present ( BNCDEV )
	    + present ( BNCREC ) + present ( BN1AC ) + present ( BNCDEC )
	    + present ( BNCREP ) + present ( BN1AP ) + present ( BNCDEP )
	    + present ( BNHREV ) + present ( BNHDEV )
	    + present ( BNHREC ) + present ( BNHDEC )
	    + present ( BNHREP ) + present ( BNHDEP )
            + present ( BNCPROV ) + present ( BNCPRO1AV ) + present ( BNCPRODEV ) 
	    + present ( BNCPROC ) + present ( BNCPRO1AC ) + present ( BNCPRODEC ) 
	    + present ( BNCPROP ) + present ( BNCPRO1AP ) + present ( BNCPRODEP ) 
	    + present ( BNCNPV ) + present ( BNCNP1AV ) + present ( BNCNPDEV ) 
	    + present ( BNCNPC ) + present ( BNCNP1AC ) + present ( BNCNPDEC ) 
	    + present ( BNCNPP ) + present ( BNCNP1AP ) + present ( BNCNPDEP ) 
	    + present ( BNCAABV ) + present ( ANOCEP ) + present ( INVENTV ) 
	    + present ( PVINVE ) + present ( BNCAADV ) + present ( DNOCEP ) 
	    + present ( BNCAABC ) + present ( ANOVEP ) + present ( INVENTC ) 
	    + present ( PVINCE ) + present ( BNCAADC ) + present ( DNOCEPC )
	    + present ( BNCAABP ) + present ( ANOPEP ) + present ( INVENTP )
	    + present ( PVINPE ) + present ( BNCAADP ) + present ( DNOCEPP )
	    ;

SOMMEA877 =  present ( BAEXV ) + present ( BACREV ) + present( 4BACREV ) 
	   + present ( BA1AV ) + present ( BACDEV ) + present ( BAEXC ) 
	   + present ( BACREC ) + present( 4BACREC )
	   + present ( BA1AC ) + present ( BACDEC ) + present ( BAEXP ) + present ( BACREP ) 
	   + present( 4BACREP ) + present ( BA1AP ) 
	   + present ( BACDEP ) + present ( BAHEXV ) + present ( BAHREV )  
	   + present( 4BAHREV ) + present ( BAHDEV ) + present ( BAHEXC ) 
	   + present ( BAHREC ) + present( 4BAHREC )
	   + present ( BAHDEC ) + present ( BAHEXP ) + present ( BAHREP )  
	   + present( 4BAHREP ) + present ( BAHDEP ) + present ( BICEXV ) 
	   + present ( BICNOV ) + present ( BI1AV ) + present ( BICDNV ) 
	   + present ( BICEXC ) + present ( BICNOC )  
	   + present ( BI1AC ) + present ( BICDNC ) + present ( BICEXP ) 
           + present ( BICNOP ) + present ( BI1AP ) + present ( BICDNP ) 
           + present ( BIHEXV ) + present ( BIHNOV )  
           + present ( BIHDNV ) + present ( BIHEXC ) + present ( BIHNOC ) 
	   + present ( BIHDNC ) + present ( BIHEXP ) 
	   + present ( BIHNOP ) + present ( BIHDNP ) ;

SOMMEA879 =  
	     present( BACREV ) + present( 4BACREV ) + present( BA1AV ) + present( BACDEV ) 
	   + present( BACREC ) + present( 4BACREC ) + present( BA1AC ) + present( BACDEC ) 
           + present( BACREP ) + present( 4BACREP ) + present( BA1AP ) + present( BACDEP ) 
	   + present( BAHREV ) + present( 4BAHREV ) + present( BAHDEV ) 
	   + present( BAHREC ) + present( 4BAHREC ) + present( BAHDEC ) 
           + present( BAHREP ) + present( 4BAHREP ) + present( BAHDEP ) 
	   
	   + present( BICNOV ) + present( BI1AV ) 
	   + present( BICDNV ) + present( BICNOC )  
	   + present( BI1AC ) + present( BICDNC ) + present( BICNOP ) 
	   + present( BI1AP ) + present( BICDNP )  
	   + present( BIHNOV ) + present( BIHDNV )  
	   + present( BIHNOC ) + present( BIHDNC )  
	   + present( BIHNOP ) + present( BIHDNP )  
	   + present( BICREV ) + present( BI2AV ) + present( BICDEV ) 
	   + present( BICREC ) + present( BI2AC ) 
	   + present( BICDEC ) + present( BICREP )  
	   + present( BI2AP ) + present( BICDEP ) + present( BICHREV ) 
	   + present( BICHDEV ) + present( BICHREC ) 
	   + present( BICHDEC ) + present( BICHREP ) 
	   + present( BICHDEP ) 
	   + present( LOCPROCGAV ) + present( LOCDEFPROCGAV ) + present( LOCPROCGAC )
	   + present( LOCDEFPROCGAC ) + present( LOCPROCGAP ) + present( LOCDEFPROCGAP )
	   + present( LOCPROV ) + present( LOCDEFPROV ) + present( LOCPROC )
	   + present( LOCDEFPROC ) + present( LOCPROP ) + present( LOCDEFPROP )
	   + present( LOCNPCGAV ) + present( LOCGITCV ) + present( LOCDEFNPCGAV ) 
	   + present( LOCNPCGAC ) + present( LOCGITCC ) + present( LOCDEFNPCGAC ) 
	   + present( LOCNPCGAPAC ) + present( LOCGITCP ) + present( LOCDEFNPCGAPAC )
	   + present( LOCNPV ) + present( LOCGITHCV ) + present( LOCDEFNPV ) 
	   + present( LOCNPC ) + present( LOCGITHCC ) + present( LOCDEFNPC ) 
	   + present( LOCNPPAC ) + present( LOCGITHCP ) + present( LOCDEFNPPAC )
	   + present( BNCREV ) + present( BN1AV ) + present( BNCDEV ) 
	   + present( BNCREC ) + present( BN1AC ) + present( BNCDEC ) 
	   + present( BNCREP ) + present( BN1AP ) + present( BNCDEP ) 
	   + present( BNHREV ) + present( BNHDEV ) 
	   + present( BNHREC ) + present( BNHDEC ) 
	   + present( BNHREP ) + present( BNHDEP ) 
	   + present ( BNCAABV ) + present ( ANOCEP ) + present ( INVENTV ) 
	   + present ( PVINVE ) + present ( BNCAADV ) + present ( DNOCEP ) 
	   + present ( BNCAABC ) + present ( ANOVEP ) + present ( INVENTC ) 
	   + present ( PVINCE ) + present ( BNCAADC ) + present ( DNOCEPC )
	   + present ( BNCAABP ) + present ( ANOPEP ) + present ( INVENTP )
	   + present ( PVINPE ) + present ( BNCAADP ) + present ( DNOCEPP )
	   ; 

SOMMEA884 =  present ( TSHALLOV ) + present ( TSHALLOC ) + present ( TSHALLO1 ) + present ( TSHALLO2 ) 
           + present ( TSHALLO3 ) + present ( TSHALLO4 )  
           + present ( PCAPTAXV ) + present ( PCAPTAXC )
           + present( ALLOV ) + present( ALLOC ) + present( ALLO1 ) + present( ALLO2 ) + present( ALLO3 ) + present( ALLO4 ) 
	   + present ( PALIV ) + present ( PALIC ) + present ( PALI1 ) + present ( PALI2 ) + present ( PALI3 ) + present ( PALI4 ) 
	   + present ( PRBRV ) + present ( PRBRC ) + present ( PRBR1 ) + present ( PRBR2 ) + present ( PRBR3 ) + present ( PRBR4 )  
           + present ( CARTSV ) + present ( CARTSC ) + present ( CARTSP1 )
           + present ( CARTSP2 ) + present ( CARTSP3) + present ( CARTSP4 )
           + present ( CARTSNBAV ) + present ( CARTSNBAC ) + present ( CARTSNBAP1 )
           + present ( CARTSNBAP2 ) + present ( CARTSNBAP3) + present ( CARTSNBAP4 )
           + present ( REMPLAV ) + present ( REMPLAC ) + present ( REMPLAP1 )
           + present ( REMPLAP2 ) + present ( REMPLAP3 ) + present ( REMPLAP4 )
           + present ( REMPLANBV ) + present ( REMPLANBC ) + present ( REMPLANBP1 )
           + present ( REMPLANBP2 ) + present ( REMPLANBP3 ) + present ( REMPLANBP4 )
           + present ( CARPEV ) + present ( CARPEC ) + present ( CARPEP1 )
           + present ( CARPEP2 ) + present ( CARPEP3 ) + present ( CARPEP4 )
           + present ( CARPENBAV ) + present ( CARPENBAC ) + present ( CARPENBAP1 )
           + present ( CARPENBAP2 ) + present ( CARPENBAP3 ) + present ( CARPENBAP4 )
           + present ( PENSALV ) + present ( PENSALC ) + present ( PENSALP1 )
           + present ( PENSALP2 ) + present ( PENSALP3 ) + present ( PENSALP4 )
           + present ( PENSALNBV ) + present ( PENSALNBC ) + present ( PENSALNBP1 )
           + present ( PENSALNBP2 ) + present ( PENSALNBP3 ) + present ( PENSALNBP4 )
	   + present ( REVACT ) + present ( DISQUO ) + present ( REVACTNB ) + present ( DISQUONB ) + present ( COD2FA )
	   + present ( RCMHAD )  
	   + present ( RCMABD )  
           + present(PENINV) + present(PENINC) + present(PENIN1) + present(PENIN2) + present(PENIN3) + present(PENIN4)
           + present(CODRAZ) + present(CODRBZ) + present(CODRCZ) + present(CODRDZ) + present(CODREZ) + present(CODRFZ)

	   + present( RFORDI )  + present( RFMIC ) + present( FONCI ) + present( REAMOR ) 
           + present( BPVRCM ) + present( PVTAXSB ) + present( BPVSJ ) + present( BPV18C ) + present( BPV18V ) + present( BPCOPTC )
           + present( BPCOPTV ) + present( BPV40C ) + present( BPV40V ) + present( COD3SG ) + present( ABDETPLUS ) + present( COD3SL )
           + present( ABIMPPV ) + present( PVIMMO ) + present( CODRVG )
	   + present( BACREV ) + present( 4BACREV ) + present( BAHREV ) + present( 4BAHREV ) + present( BA1AV )
	   + present( BACREC ) + present( 4BACREC ) + present( BAHREC ) + present( 4BAHREC ) + present( BA1AC )
	   + present( BACREP ) + present( 4BACREP ) + present( BAHREP ) + present( 4BAHREP ) + present( BA1AP )
	   + present( BICNOV ) + present( LOCPROCGAV ) + present( BIHNOV ) + present( LOCPROV )
	   + present( BICNOC ) + present( LOCPROCGAC ) + present( BIHNOC ) + present( LOCPROC ) 
	   + present( BICNOP ) + present( LOCPROCGAP ) + present( BIHNOP ) + present( LOCPROP )
	   + present( MIBVENV ) + present( MIBPRESV ) + present( BI1AV )
	   + present( MIBVENC ) + present( MIBPRESC ) + present( BI1AC )
	   + present( MIBVENP ) + present( MIBPRESP ) + present( BI1AP )

	   + present ( BICREV ) + present ( LOCNPCGAV ) + present ( LOCGITCV )
	   + present ( BICREC ) + present ( LOCNPCGAC ) + present ( LOCGITCC )
	   + present ( BICREP ) + present ( LOCNPCGAPAC ) + present ( LOCGITCP )
	   + present ( BICHREV ) + present ( LOCNPV ) + present ( LOCGITHCV )
	   + present ( BICHREC ) + present ( LOCNPC ) + present ( LOCGITHCC )
	   + present ( BICHREP ) + present ( LOCNPPAC ) + present ( LOCGITHCP ) 
           + present ( MIBMEUV ) + present ( MIBGITEV ) + present ( LOCGITV ) + present ( MIBNPVENV ) + present ( MIBNPPRESV ) 
	   + present ( MIBMEUC ) + present ( MIBGITEC ) + present ( LOCGITC ) + present ( MIBNPVENC ) + present ( MIBNPPRESC ) 
	   + present ( MIBMEUP ) + present ( MIBGITEP ) + present ( LOCGITP ) + present ( MIBNPVENP ) + present ( MIBNPPRESP ) 
	   + present ( BNCREV ) + present ( BNCREC ) + present ( BNCREP ) 
	   + present ( BNHREV ) + present ( BNHREC ) + present ( BNHREP ) 
	   + present ( BNCPROV ) + present ( BNCPROC ) + present ( BNCPROP ) 
           + present ( BN1AV ) + present ( BN1AC ) + present ( BN1AP )

	   + present ( BNCAABV ) + present ( ANOCEP ) + present ( INVENTV ) 
	   + present ( PVINVE ) + present ( BNCAADV ) + present ( DNOCEP ) 
	   + present ( BNCAABC ) + present ( ANOVEP ) + present ( INVENTC ) 
	   + present ( PVINCE ) + present ( BNCAADC ) + present ( DNOCEPC )
	   + present ( BNCAABP ) + present ( ANOPEP ) + present ( INVENTP )
	   + present ( PVINPE ) + present ( BNCAADP ) + present ( DNOCEPP )
	   + present ( BNCNPV ) + present ( BNCNPC ) + present ( BNCNPP ) 

	   ;

SOMMEA538VB =  present( BAFORESTV ) + present( BAFPVV ) + present( BACREV ) + present( 4BACREV ) 
	     + present( BAHREV ) + present( 4BAHREV ) + present( MIBVENV ) + present( MIBPRESV ) 
	     + present( MIBPVV ) + present( BICNOV ) + present( LOCPROCGAV ) + present( BIHNOV ) 
	     + present( LOCPROV ) + present( MIBNPVENV ) + present( MIBNPPRESV ) + present( MIBNPPVV ) 
	     + present( BICREV ) + present( LOCNPCGAV ) + present( LOCGITCV ) + present( BICHREV ) 
	     + present( LOCNPV ) + present( LOCGITHCV )
             + present( BNCPROV ) + present( BNCPROPVV ) + present( BNCREV ) + present( BNHREV ) 
	     + present( BNCNPV ) + present( BNCNPPVV ) + present( ANOCEP ) + present( BNCAABV ) 
	     + present( MIBMEUV ) + present( MIBGITEV ) + present( LOCGITV ) + present( INVENTV ) ;

SOMMEA538CB =  present( BAFORESTC ) + present( BAFPVC ) + present( BACREC ) + present( 4BACREC ) 
	     + present( BAHREC ) + present( 4BAHREC ) + present( MIBVENC ) + present( MIBPRESC )
             + present( MIBPVC ) + present( BICNOC ) + present( LOCPROCGAC ) + present( BIHNOC )
             + present( LOCPROC ) + present( MIBNPVENC ) + present( MIBNPPRESC ) + present( MIBNPPVC )
             + present( BICREC ) + present( LOCNPCGAC ) + present( LOCGITCC ) + present( BICHREC ) 
	     + present( LOCNPC ) + present( LOCGITHCC )
             + present( BNCPROC ) + present( BNCPROPVC ) + present( BNCREC ) + present( BNHREC )
	     + present( BNCNPC ) + present( BNCNPPVC ) + present( ANOVEP ) + present( BNCAABC ) 
	     + present( MIBMEUC ) + present( MIBGITEC ) + present( LOCGITC ) + present( INVENTC ) ;

SOMMEA538PB =  present( BAFORESTP ) + present( BAFPVP ) + present( BACREP ) + present( 4BACREP ) 
	     + present( BAHREP ) + present( 4BAHREP ) + present( MIBVENP ) + present( MIBPRESP )
             + present( MIBPVP ) + present( BICNOP ) + present( LOCPROCGAP ) + present( BIHNOP )
	     + present( LOCPROP ) + present( MIBNPVENP ) + present( MIBNPPRESP ) + present( MIBNPPVP )
             + present( BICREP ) + present( LOCNPCGAPAC ) + present( LOCGITCP ) + present( BICHREP ) 
	     + present( LOCNPPAC ) + present( LOCGITHCP )
	     + present( BNCPROP ) + present( BNCPROPVP ) + present( BNCREP ) + present( BNHREP )
	     + present( BNCNPP ) + present( BNCNPPVP ) + present( ANOPEP ) + present( BNCAABP ) 
	     + present( MIBMEUP ) + present( MIBGITEP ) + present( LOCGITP ) + present( INVENTP ) ;

SOMMEA538VP =  present ( BAF1AV ) + present ( BA1AV ) + present ( MIB1AV ) + present ( BI1AV )
             + present ( MIBNP1AV ) + present ( BI2AV ) + present ( BNCPRO1AV ) + present ( BN1AV )
	     + present ( BNCNP1AV ) + present ( PVINVE ) ;


SOMMEA538CP =  present ( BAF1AC ) + present ( BA1AC ) + present ( MIB1AC ) + present ( BI1AC )
             + present ( MIBNP1AC ) + present ( BI2AC ) + present ( BNCPRO1AC ) + present ( BN1AC )
	     + present ( BNCNP1AC ) + present ( PVINCE ) ;

SOMMEA538PP =  present ( BAF1AP ) + present ( BA1AP ) + present ( MIB1AP ) + present ( BI1AP )
             + present ( MIBNP1AP ) + present ( BI2AP ) + present ( BNCPRO1AP ) + present ( BN1AP )
	     + present ( BNCNP1AP ) + present ( PVINPE ) ;

SOMMEA538 = SOMMEA538VB + SOMMEA538CB + SOMMEA538PB + SOMMEA538VP + SOMMEA538CP + SOMMEA538PP ;

SOMMEA090 =  somme(i=V,C,1..4:TSHALLOi + ALLOi + DETSi + FRNi + PRBRi + PALIi)
            + somme(i=V,C:CARTSi + REMPLAi + PEBFi + CARPEi + PENSALi)
            + somme(i=1..4:CARTSPi + REMPLAPi + PEBFi + CARPEPi + PENSALPi + RVBi)
	    + somme(i=1..3:GLDiV + GLDiC)
	    + RENTAX + RENTAX5 + RENTAX6 + RENTAX7
	    + BPCOSAV + BPCOSAC + GLDGRATV + GLDGRATC
	    ; 

SOMMEA862 =  

      present( MIBEXV ) + present( MIBVENV ) + present( MIBPRESV ) 
    + present( MIBPVV ) + present( MIB1AV ) + present( MIBDEV ) + present( BICPMVCTV )
    + present( MIBEXC ) + present( MIBVENC ) + present( MIBPRESC ) 
    + present( MIBPVC ) + present( MIB1AC ) + present( MIBDEC ) + present( BICPMVCTC ) 
    + present( MIBEXP ) + present( MIBVENP ) + present( MIBPRESP ) 
    + present( MIBPVP ) + present( MIB1AP ) + present( MIBDEP ) + present( BICPMVCTP ) 
    + present( BICEXV ) + present( BICNOV ) + present( LOCPROCGAV ) 
    + present( BI1AV ) + present( BICDNV ) + present( LOCDEFPROCGAV ) 
    + present( BICEXC ) + present( BICNOC ) + present( LOCPROCGAC ) 
    + present( BI1AC ) + present( BICDNC ) + present( LOCDEFPROCGAC ) 
    + present( BICEXP ) + present( BICNOP ) + present( LOCPROCGAP ) 
    + present( BI1AP ) + present( BICDNP ) + present( LOCDEFPROCGAP ) 
    + present( BIHEXV ) + present( BIHNOV ) + present( LOCPROV ) + present( BIHDNV ) + present( LOCDEFPROV ) 
    + present( BIHEXC ) + present( BIHNOC ) + present( LOCPROC ) + present( BIHDNC ) + present( LOCDEFPROC )
    + present( BIHEXP ) + present( BIHNOP ) + present( LOCPROP ) + present( BIHDNP ) + present( LOCDEFPROP ) 

    + present( MIBMEUV ) + present( MIBGITEV ) + present( LOCGITV ) + present( MIBNPEXV ) + present( MIBNPVENV ) 
    + present( MIBNPPRESV ) + present( MIBNPPVV ) + present( MIBNP1AV ) + present( MIBNPDEV ) 
    + present( MIBMEUC ) + present( MIBGITEC ) + present( LOCGITC ) + present( MIBNPEXC ) + present( MIBNPVENC ) 
    + present( MIBNPPRESC ) + present( MIBNPPVC ) + present( MIBNP1AC ) + present( MIBNPDEC ) 
    + present( MIBMEUP ) + present( MIBGITEP ) + present( LOCGITP ) + present( MIBNPEXP ) + present( MIBNPVENP ) 
    + present( MIBNPPRESP ) + present( MIBNPPVP ) + present( MIBNP1AP ) + present( MIBNPDEP ) 
    + present( MIBNPDCT )
    + present( BICNPEXV ) + present( BICREV ) + present( LOCNPCGAV ) + present( LOCGITCV )
    + present( BI2AV ) + present( BICDEV ) + present( LOCDEFNPCGAV )
    + present( BICNPEXC ) + present( BICREC ) + present( LOCNPCGAC ) + present( LOCGITCC )
    + present( BI2AC ) + present( BICDEC ) + present( LOCDEFNPCGAC )
    + present( BICNPEXP ) + present( BICREP ) + present( LOCNPCGAPAC ) + present( LOCGITCP )
    + present( BI2AP ) + present( BICDEP ) + present( LOCDEFNPCGAPAC )
    + present( BICNPHEXV ) + present( BICHREV ) + present( LOCNPV )
    + present( LOCGITHCV ) + present( BICHDEV ) + present( LOCDEFNPV ) 
    + present( BICNPHEXC ) + present( BICHREC ) + present( LOCNPC ) 
    + present( LOCGITHCC ) + present( BICHDEC ) + present( LOCDEFNPC ) 
    + present( BICNPHEXP ) + present( BICHREP ) + present( LOCNPPAC ) 
    + present( LOCGITHCP ) + present( BICHDEP ) + present( LOCDEFNPPAC )

    + present( BNCPROEXV ) + present( BNCPROV ) + present( BNCPROPVV ) 
    + present( BNCPRO1AV ) + present( BNCPRODEV ) + present( BNCPMVCTV )
    + present( BNCPROEXC ) + present( BNCPROC ) + present( BNCPROPVC ) 
    + present( BNCPRO1AC ) + present( BNCPRODEC ) + present( BNCPMVCTC )
    + present( BNCPROEXP ) + present( BNCPROP ) + present( BNCPROPVP ) 
    + present( BNCPRO1AP ) + present( BNCPRODEP ) + present( BNCPMVCTP )
    + present( BNCPMVCTV ) 
    + present( BNCEXV ) + present( BNCREV ) + present( BN1AV ) + present( BNCDEV ) 
    + present( BNCEXC ) + present( BNCREC ) + present( BN1AC ) + present( BNCDEC )
    + present( BNCEXP ) + present( BNCREP ) + present( BN1AP ) + present( BNCDEP ) 
    + present( BNHEXV ) + present( BNHREV ) + present( BNHDEV ) 
    + present( BNHEXC ) + present( BNHREC ) + present( BNHDEC ) 
    + present( BNHEXP ) + present( BNHREP ) + present( BNHDEP ) 

    + present( XSPENPV ) + present( BNCNPV ) + present( BNCNPPVV ) + present( BNCNP1AV ) + present( BNCNPDEV )
    + present( XSPENPC ) + present( BNCNPC ) + present( BNCNPPVC ) + present( BNCNP1AC ) + present( BNCNPDEC ) 
    + present( XSPENPP ) + present( BNCNPP ) + present( BNCNPPVP ) + present( BNCNP1AP ) + present( BNCNPDEP ) 
    + present( BNCNPDCT ) 
    + present( BNCNPREXAAV ) + present( BNCAABV ) + present( BNCAADV ) + present( BNCNPREXV )
    + present( ANOCEP ) + present( DNOCEP ) + present( PVINVE ) + present( INVENTV )
    + present( BNCNPREXAAC ) + present( BNCAABC ) + present( BNCAADC ) + present( BNCNPREXC ) 
    + present( ANOVEP ) + present( DNOCEPC ) + present( PVINCE ) + present( INVENTC )
    + present( BNCNPREXAAP ) + present( BNCAABP ) + present( BNCAADP ) + present( BNCNPREXP ) 
    + present( ANOPEP ) + present( DNOCEPP ) + present( PVINPE ) + present( INVENTP )
	    ;

SOMMEDD55 =

 somme(i=V,C,1,2,3,4: present(TSHALLOi) + present(ALLOi) +  present(PRBRi) + present(PALIi) + present(PENINi))
 + present ( CARTSV ) + present ( CARTSC ) + present ( CARTSP1 )
 + present ( CARTSP2 ) + present ( CARTSP3) + present ( CARTSP4 )
 + present ( CARTSNBAV ) + present ( CARTSNBAC ) + present ( CARTSNBAP1 )
 + present ( CARTSNBAP2 ) + present ( CARTSNBAP3) + present ( CARTSNBAP4 )
 + present ( REMPLAV ) + present ( REMPLAC ) + present ( REMPLAP1 )
 + present ( REMPLAP2 ) + present ( REMPLAP3 ) + present ( REMPLAP4 )
 + present ( REMPLANBV ) + present ( REMPLANBC ) + present ( REMPLANBP1 )
 + present ( REMPLANBP2 ) + present ( REMPLANBP3 ) + present ( REMPLANBP4 )
 + present ( CARPEV ) + present ( CARPEC ) + present ( CARPEP1 )
 + present ( CARPEP2 ) + present ( CARPEP3 ) + present ( CARPEP4 )
 + present ( CARPENBAV ) + present ( CARPENBAC ) + present ( CARPENBAP1 )
 + present ( CARPENBAP2 ) + present ( CARPENBAP3 ) + present ( CARPENBAP4 )
 + present ( PENSALV ) + present ( PENSALC ) + present ( PENSALP1 )
 + present ( PENSALP2 ) + present ( PENSALP3 ) + present ( PENSALP4 )
 + present ( PENSALNBV ) + present ( PENSALNBC ) + present ( PENSALNBP1 )
 + present ( PENSALNBP2 ) + present ( PENSALNBP3 ) + present ( PENSALNBP4 )
 + present ( PCAPTAXV ) + present ( PCAPTAXC )
 + present(CODRAZ) + present(CODRBZ) + present(CODRCZ) + present(CODRDZ) + present(CODREZ) + present(CODRFZ)

 + present ( BACREV ) + present ( 4BACREV ) + present ( BA1AV ) + present ( BACDEV )
 + present ( BACREC ) + present ( 4BACREC ) + present ( BA1AC ) + present ( BACDEC )
 + present ( BACREP ) + present ( 4BACREP ) + present ( BA1AP ) + present ( BACDEP )
 + present ( BAHREV ) + present ( 4BAHREV ) + present ( BAHDEV ) 
 + present ( BAHREC ) + present ( 4BAHREC ) + present ( BAHDEC ) 
 + present ( BAHREP ) + present ( 4BAHREP ) + present ( BAHDEP )

 + present ( BICNOV ) + present ( BI1AV )
 + present ( BICDNV ) + present ( BICNOC )
 + present ( BI1AC ) + present ( BICDNC )
 + present ( BICNOP ) 
 + present ( BI1AP ) + present ( BICDNP ) 
 + present ( BIHNOV ) + present ( BIHDNV )
 + present ( BIHNOC ) 
 + present ( BIHDNC ) + present ( BIHNOP )
 + present ( BIHDNP ) 
 + present ( MIBVENV ) + present ( MIBPRESV ) + present ( MIB1AV )
 + present ( MIBDEV ) + present ( MIBVENC ) + present ( MIBPRESC )
 + present ( MIB1AC ) + present ( MIBDEC ) + present ( MIBVENP )
 + present ( MIBPRESP ) + present ( MIB1AP ) + present ( MIBDEP )
 + present(LOCPROCGAV) + present(LOCDEFPROCGAV) + present( LOCPROCGAC)
 + present(LOCDEFPROCGAC) + present(LOCPROCGAP) + present(LOCDEFPROCGAP)
 + present(LOCPROV) + present(LOCDEFPROV) + present(LOCPROC)
 + present(LOCDEFPROC) + present(LOCPROP) + present(LOCDEFPROP)

 + present(BICREV) + present(LOCNPCGAV) + present ( BI2AV ) + present ( BICDEV ) + present(LOCDEFNPCGAV) 
 + present(BICREC) + present(LOCNPCGAC) + present ( BI2AC ) + present ( BICDEC ) + present(LOCDEFNPCGAC)
 + present(BICREP) + present(LOCNPCGAPAC) + present ( BI2AP ) + present ( BICDEP ) + present(LOCDEFNPCGAPAC)
 + present(BICHREV) + present(LOCNPV) + present(BICHDEV) + present(LOCDEFNPV)
 + present(BICHREC) + present(LOCNPC) + present(BICHDEC) + present(LOCDEFNPC)
 + present(BICHREP) + present(LOCNPPAC) + present(BICHDEP) + present(LOCDEFNPPAC) 
 + present(MIBNPVENV) + present(MIBNPPRESV) + present(MIBNP1AV) + present(MIBNPDEV) 
 + present(MIBNPVENC) + present(MIBNPPRESC) + present(MIBNP1AC) + present(MIBNPDEC) 
 + present(MIBNPVENP) + present(MIBNPPRESP) + present(MIBNP1AP) + present(MIBNPDEP)
 + present(MIBMEUV) + present(MIBGITEV)
 + present(MIBMEUC) + present(MIBGITEC)
 + present(MIBMEUP) + present(MIBGITEP)
 + present(LOCGITCV ) + present(LOCGITCC) + present(LOCGITCP)
 + present(LOCGITHCV) + present(LOCGITHCC) + present(LOCGITHCP)
 + present(LOCGITV) + present(LOCGITC) + present(LOCGITP)

 + present ( BNCREV ) + present ( BN1AV ) + present ( BNCDEV )
 + present ( BNCREC ) + present ( BN1AC ) + present ( BNCDEC )
 + present ( BNCREP ) + present ( BN1AP ) + present ( BNCDEP )
 + present ( BNHREV ) + present ( BNHDEV ) 
 + present ( BNHREC ) + present ( BNHDEC ) 
 + present ( BNHREP ) + present ( BNHDEP )
 + present ( BNCPROV ) + present ( BNCPRO1AV ) + present ( BNCPRODEV )
 + present ( BNCPROC ) + present ( BNCPRO1AC ) + present ( BNCPRODEC )
 + present ( BNCPROP ) + present ( BNCPRO1AP ) + present ( BNCPRODEP )

 + present ( BNCNPV ) + present ( BNCNP1AV ) + present ( BNCNPDEV )
 + present ( BNCNPC ) + present ( BNCNP1AC ) + present ( BNCNPDEC )
 + present ( BNCNPP ) + present ( BNCNP1AP ) + present ( BNCNPDEP )
 + present ( BNCAABV ) + present ( ANOCEP ) + present ( PVINVE ) + present ( BNCAADV ) + present ( DNOCEP )
 + present ( BNCAABC ) + present ( ANOVEP ) + present ( PVINCE ) + present ( BNCAADC ) + present ( DNOCEPC )
 + present ( BNCAABP ) + present ( ANOPEP ) + present ( PVINPE ) + present ( BNCAADP ) + present ( DNOCEPP )
 + present ( INVENTV ) + present ( INVENTC ) + present ( INVENTP )

 ;

SOMMEA802 = present( AUTOBICVV ) + present ( AUTOBICPV ) + present ( AUTOBICVC ) + present ( AUTOBICPC )
	    + present( AUTOBICVP ) + present ( AUTOBICPP ) 
	    + present( AUTOBNCV ) + present ( AUTOBNCC ) + present ( AUTOBNCP ) 
	    + present ( XHONOAAV ) + present ( XHONOV )
	    + present( XHONOAAC ) + present ( XHONOC ) + present ( XHONOAAP ) + present ( XHONOP ) 
            + present(SALEXTV) + present(SALEXTC) + present(SALEXT1) + present(SALEXT2) + present(SALEXT3) + present(SALEXT4)
            + present(COD1AE) + present(COD1BE) + present(COD1CE) + present(COD1DE) + present(COD1EE) + present(COD1FE)
            + present(COD1AH) + present(COD1BH) + present(COD1CH) + present(COD1DH) + present(COD1EH) + present(COD1FH)
            ;

regle 10009932:
application : iliad , batch;  
SOMMEANOEXP = positif ( PEBFV ) + positif ( COTFV ) + positif ( PEBFC ) + positif ( COTFC ) 
              + positif ( PEBF1 ) + positif ( COTF1 ) + positif ( PEBF2 ) + positif ( COTF2 ) 
              + positif ( PEBF3 ) + positif ( COTF3 ) + positif ( PEBF4 ) + positif ( COTF4 ) 
              + positif ( PENSALV ) + positif ( PENSALNBV ) + positif ( PENSALC ) + positif ( PENSALNBC )
              + positif ( PENSALP1 ) + positif ( PENSALNBP1 ) + positif ( PENSALP2 ) + positif ( PENSALNBP2 )
              + positif ( PENSALP3 ) + positif ( PENSALNBP3 ) + positif ( PENSALP4 ) + positif ( PENSALNBP4 )
              + positif ( CARPEV ) + positif ( CARPENBAV ) + positif ( CARPEC ) + positif ( CARPENBAC )
              + positif ( CARPEP1 ) + positif ( CARPENBAP1 ) + positif ( CARPEP2 ) + positif ( CARPENBAP2 )
              + positif ( CARPEP3 ) + positif ( CARPENBAP3 ) + positif ( CARPEP4 ) + positif ( CARPENBAP4 )
              + positif ( CARTSP1 ) + positif ( CARTSNBAP1 ) + positif ( CARTSP2 ) + positif ( CARTSNBAP2 ) 
              + positif ( CARTSP3 ) + positif ( CARTSNBAP3 ) + positif ( CARTSP4 ) + positif ( CARTSNBAP4 ) 
              + positif ( REMPLAV ) + positif ( REMPLANBV ) + positif ( REMPLAC ) + positif ( REMPLANBC )
              + positif ( REMPLAP1 ) + positif ( REMPLANBP1 ) + positif ( REMPLAP2 ) + positif ( REMPLANBP2 )
              + positif ( REMPLAP3 ) + positif ( REMPLANBP3 ) + positif ( REMPLAP4 ) + positif ( REMPLANBP4 )
              + positif ( RENTAX ) + positif ( RENTAX5 ) + positif ( RENTAX6 ) + positif ( RENTAX7 )
              + positif ( RENTAXNB ) + positif ( RENTAXNB5 ) + positif ( RENTAXNB6 ) + positif ( RENTAXNB7 )
              + positif ( FONCI ) + positif ( FONCINB ) + positif ( REAMOR ) + positif ( REAMORNB )
              + positif ( REVACT ) + positif ( REVACTNB ) + positif ( REVPEA ) + positif ( REVPEANB )
              + positif ( PROVIE ) + positif ( PROVIENB ) + positif ( DISQUO ) + positif ( DISQUONB )
              + positif ( RESTUC ) + positif ( RESTUCNB ) + positif ( INTERE ) + positif ( INTERENB )
              + positif( 4BACREV ) + positif( 4BAHREV ) + positif( 4BACREC )
              + positif( 4BAHREC ) + positif( 4BACREP ) + positif( 4BAHREP )
              + positif(CODRAZ) + positif(CODRBZ) + positif(CODRCZ) + positif(CODRDZ) + positif(CODREZ) + positif(CODRFZ)
              + positif(CODNAZ) + positif(CODNBZ) + positif(CODNCZ) + positif(CODNDZ) + positif(CODNEZ) + positif(CODNFZ)
              + positif(CODRVG) + positif(CODNVG)
              + 0
             ;

regle 10009933:
application : iliad , batch;  

SOMMEA709 = positif(RINVLOCINV) + positif(RINVLOCREA) + positif(REPINVTOU) 
            + positif(INVLOGREHA) + positif(INVLOCXN) + positif(INVLOCXV) + positif(COD7UY) + positif(COD7UZ)
            + 0
	    ;
regle 10739:
application : iliad , batch ;  

SOMMEA739 = positif(INVSOCNRET) + positif(INVOMSOCKH) + positif(INVOMSOCKI) + positif(INVSOC2010) + positif(INVOMSOCQU) 
	    + positif(INVLOGSOC) + positif(INVOMSOCQJ) + positif(INVOMSOCQS) + positif(INVOMSOCQW) + positif(INVOMSOCQX) 
	    + positif(NRETROC40) + positif(NRETROC50) + positif(RETROCOMMB) + positif(RETROCOMMC) + positif(RETROCOMLH) 
	    + positif(RETROCOMLI) + positif(INVRETRO2) + positif(INVDOMRET60) + positif(INVRETRO1) + positif(INVDOMRET50) 
	    + positif(INVOMRETPO) + positif(INVOMRETPT) + positif(INVOMRETPN) + positif(INVOMRETPP) + positif(INVOMRETPS) 
	    + positif(INVOMRETPU) + positif(INVENDI) + positif(INVOMENTKT) + positif(INVOMENTKU) + positif(INVIMP) 
	    + positif(INVDIR2009) + positif(INVOMRETPR) + positif(INVOMRETPW) + positif(INVLGAUTRE) + positif(INVLGDEB2010) 
	    + positif(INVLOG2009) + positif(INVOMLOGOB) + positif(INVOMLOGOC) + positif(INVOMLOGOM) + positif(INVOMLOGON)
	    + positif(INVOMRETPB) + positif(INVOMRETPF) + positif(INVOMRETPJ) + positif(INVOMRETPA) + positif(INVOMRETPE) 
	    + positif(INVOMRETPI) + positif(INVOMRETPY) + positif(INVOMRETPX) + positif(INVOMENTRG) + positif(INVOMRETPD) 
	    + positif(INVOMRETPH) + positif(INVOMRETPL) + positif(INVOMENTRI) + positif(INVOMLOGOI) + positif(INVOMLOGOJ) 
	    + positif(INVOMLOGOK) + positif(INVOMLOGOP) + positif(INVOMLOGOQ) + positif(INVOMLOGOR) + positif(INVOMENTRL) 
	    + positif(INVOMENTRQ) + positif(INVOMENTRV) + positif(INVOMENTNV) + positif(INVOMENTRK) + positif(INVOMENTRP)
	    + positif(INVOMENTRU) + positif(INVOMENTNU) + positif(INVOMENTRM) + positif(INVOMENTRR) + positif(INVOMENTRW) 
	    + positif(INVOMENTNW) + positif(INVOMENTRO) + positif(INVOMENTRT) + positif(INVOMENTRY) + positif(INVOMENTNY) 
	    + positif(INVOMLOGOT) + positif(INVOMLOGOU) + positif(INVOMLOGOV) + positif(INVOMLOGOW)
            + positif(CODHOD) + positif(CODHOE) + positif(CODHOF) + positif(CODHOG) + positif(CODHOX) + positif(CODHOY)
            + positif(CODHOZ) + positif(CODHRA) + positif(CODHRB) + positif(CODHRC) + positif(CODHRD)
            + positif(CODHSA) + positif(CODHSB) + positif(CODHSC) + positif(CODHSE) + positif(CODHSF) + positif(CODHSG)
            + positif(CODHSH) + positif(CODHSJ) + positif(CODHSK) + positif(CODHSL) + positif(CODHSM) + positif(CODHSO)
            + positif(CODHSP) + positif(CODHSQ) + positif(CODHSR) + positif(CODHST) + positif(CODHSU) + positif(CODHSV)
            + positif(CODHSW) + positif(CODHSY) + positif(CODHSZ) + positif(CODHTA) + positif(CODHTB) + positif(CODHTD) 
            + positif(CODHAA) + positif(CODHAB) + positif(CODHAC) + positif(CODHAE) + positif(CODHAF) + positif(CODHAG)
            + positif(CODHAH) + positif(CODHAJ) + positif(CODHAK) + positif(CODHAL) + positif(CODHAM) + positif(CODHAO)
            + positif(CODHAP) + positif(CODHAQ) + positif(CODHAR) + positif(CODHAT) + positif(CODHAU) + positif(CODHAV)
            + positif(CODHAW) + positif(CODHAY) + positif(CODHBA) + positif(CODHBB) 
            + positif(CODHBE) + positif(CODHBF) + positif(CODHBG)
            + positif(CODHUA) + positif(CODHUB) + positif(CODHUC) + positif(CODHUD) + positif(CODHUE) + positif(CODHUF)
            + positif(CODHUG)
            + positif(CODHXA) + positif(CODHXB) + positif(CODHXC) + positif(CODHXE) 
	    + 0 ;
regle 10009935:
application : iliad,  batch ;  

SOMMEA700 = 
          (
   present ( BAEXV ) + present ( BACREV ) + present ( 4BACREV ) + present ( BA1AV ) + present ( BACDEV ) 
 + present ( BAEXC ) + present ( BACREC ) + present ( 4BACREC ) + present ( BA1AC ) + present ( BACDEC ) 
 + present ( BAEXP ) + present ( BACREP ) + present ( 4BACREP ) + present ( BA1AP ) + present ( BACDEP ) 
 + present ( BAPERPV ) + present ( BAPERPC ) + present ( BAPERPP )
 + present ( BANOCGAV ) + present ( BANOCGAC ) + present ( BANOCGAP )
 + present ( BAHEXV ) + present ( BAHREV ) + present ( 4BAHREV )
 + present ( BAHEXC ) + present ( BAHREC ) + present ( 4BAHREC )
 + present ( BAHEXP ) + present ( BAHREP ) + present ( 4BAHREP )

 + present (BICEXV ) + present ( BICNOV ) + present ( LOCPROCGAV )
 + present ( BI1AV ) + present ( BICDNV ) + present ( LOCDEFPROCGAV )
 + present (BICEXC ) + present ( BICNOC ) + present ( LOCPROCGAC )
 + present ( BI1AC ) + present ( BICDNC ) + present ( LOCDEFPROCGAC )
 + present (BICEXP ) + present ( BICNOP ) + present ( LOCPROCGAP )
 + present ( BI1AP ) + present ( BICDNP ) + present ( LOCDEFPROCGAP )

 + present (BICNPEXV ) + present ( BICREV ) + present ( LOCNPCGAV ) + present ( LOCGITCV )
 + present ( BI2AV ) + present ( BICDEV ) + present ( LOCDEFNPCGAV )
 + present (BICNPEXC ) + present ( BICREC ) + present ( LOCNPCGAC ) + present ( LOCGITCC )
 + present ( BI2AC ) + present ( BICDEC ) + present ( LOCDEFNPCGAC )
 + present (BICNPEXP ) + present ( BICREP ) + present ( LOCNPCGAPAC ) + present ( LOCGITCP )
 + present ( BI2AP ) + present ( BICDEP ) + present ( LOCDEFNPCGAPAC )

 + present (BNCEXV ) + present ( BNCREV ) + present ( BN1AV ) + present ( BNCDEV )
 + present (BNCEXC ) + present ( BNCREC ) + present ( BN1AC ) + present ( BNCDEC )
 + present (BNCEXP ) + present ( BNCREP ) + present ( BN1AP ) + present ( BNCDEP )
 + present ( BNHEXV ) + present ( BNHREV ) 
 + present ( BNHEXC ) + present ( BNHREC ) 
 + present ( BNHEXP ) + present ( BNHREP ) 
 + present ( XHONOAAV ) + present ( XHONOAAC ) + present ( XHONOAAP )

 + present ( BNCNPREXAAV ) + present ( BNCNPREXV ) + present ( BNCNPREXAAC )
 + present ( BNCNPREXC ) + present ( BNCNPREXAAP ) + present ( BNCNPREXP )
 + present ( BNCAABV ) + present ( BNCAADV ) + present ( ANOCEP ) 
 + present ( PVINVE ) + present ( INVENTV )
 + present ( BNCAABC ) + present ( BNCAADC ) + present ( DNOCEP ) 
 + present ( ANOVEP ) + present ( PVINCE ) + present ( INVENTC )
 + present ( BNCAABP ) + present ( BNCAADP ) + present ( DNOCEPC )
 + present ( ANOPEP ) + present ( PVINPE ) + present ( INVENTP )
 + present ( DNOCEPP )
          ) ;

regle 10009936:
application : iliad , batch;  
V_CNR  =   (V_REGCO+0) dans (2,4);
V_CNR2 =   (V_REGCO+0) dans (2,3,4);
V_CR2  =   (V_REGCO+0) dans (2);
V_EAD  =   (V_REGCO+0) dans (5);
V_EAG  =   (V_REGCO+0) dans (6,7);
regle 10009950:
application : iliad , batch;  
VARIPTEFN =  (max(0,(IPTEFN * (1 - positif(SOMMEMOND_2) )*(1-PREM8_11)) - DEFZU*positif(SOMMEMOND_2)*(1-PREM8_11)-DEFZU*PREM8_11) * present (IPTEFN)) ;
VARIPTEFP = (IPTEFP + max(0,DEFZU*positif(SOMMEMOND_2)*(1-PREM8_11)+DEFZU*PREM8_11 - IPTEFN )) * positif(present(IPTEFP)+present(IPTEFN));

VARDMOND = max(0,(DMOND * (1 - positif(SOMMEMOND_2)) )*(1-PREM8_11)- DEFZU*positif(SOMMEMOND_2)*(1-PREM8_11)-DEFZU*PREM8_11)  * present(DMOND);

VARRMOND = (RMOND + max(0,DEFZU*positif(SOMMEMOND_2)*(1-PREM8_11)+DEFZU*PREM8_11 - DMOND)) * positif(present(RMOND)+present(DMOND));

regle 10009960:
application : iliad , batch;  
FLAGRETARD = FLAG_RETARD+0;
FLAGRETARD08 = FLAG_RETARD08+0;
FLAGDEFAUT = FLAG_DEFAUT+0;
FLAGDEFAUT10 = FLAG_DEFAUT10+0;
FLAGDEFAUT11 = FLAG_DEFAUT11+0;
regle 1011005:
application : iliad , batch;  
INDCODDAJ = positif(present(CODDAJ)+present(CODDBJ)+present(CODEAJ)+present(CODEBJ));
regle 1000200:
application : iliad , batch;  

DEFRIBIS = positif( RIDEFRIBIS 
                 + DEFRIGLOBSUPBIS + DEFRIGLOBINFBIS + DEFRIBASUPBIS + DEFRIBAINFBIS + DEFRIBICBIS 
                 + DEFRILOCBIS + DEFRIBNCBIS + DEFRIRFBIS + DEFRIRCMBIS + DEFRITSBIS + DEFRIMONDBIS + 0) ;

regle 1000290:
application : iliad , batch;  


SOMMEBA = 
  BAFV
 + BAFC
 + BAFP
 + BAFORESTV
 + BAFORESTC
 + BAFORESTP
 + BAFPVV
 + BAFPVC
 + BAFPVP
 + BACREV
 + BAHREV
 + BACREC
 + BAHREC
 + BACREP
 + BAHREP +0;
SOMMEBIC =
  MIBNPVENV
 + MIBNPVENC
 + MIBNPVENP
 + MIBNPPRESV
 + MIBNPPRESC
 + MIBNPPRESP
 + MIBNPPVV
 + MIBNPPVC
 + MIBNPPVP
 + BICREV
 + BICHREV
 + BICREC
 + BICHREC
 + BICREP
 + BICHREP+0;
SOMMELOC = 
  MIBMEUV
 + MIBMEUC
 + MIBMEUP
 + MIBGITEV
 + MIBGITEC
 + MIBGITEP
 + LOCGITV
 + LOCGITC
 + LOCGITP
 + LOCNPCGAV
 + LOCNPV
 + LOCNPCGAC
 + LOCNPC
 + LOCNPCGAPAC
 + LOCNPPAC
 + LOCGITCV
 + LOCGITHCV
 + LOCGITCC
 + LOCGITHCC
 + LOCGITCP
 + LOCGITHCP+0;
SOMMEBNC =
  BNCNPV
 + BNCNPC
 + BNCNPP
 + BNCNPPVV
 + BNCNPPVC
 + BNCNPPVP
 + BNCAABV
 + ANOCEP
 + BNCAABC
 + ANOVEP
 + BNCAABP
 + ANOPEP+0;
SOMMERF =
  RFORDI
 + RFMIC
 + FONCI
 + REAMOR+0;
SOMMERCM =
  RCMAV
 + RCMABD
 + RCMTNC
 + REGPRIV
 + RCMHAB
 + RCMHAD
 + PROVIE
 + REVACT
 + REVPEA
 + RESTUC
 + INTERE
 + DISQUO+0;
SOMDEFBASUP =
   (BACDEV
 + BAHDEV
 + BACDEC
 + BAHDEC
 + BACDEP
 + BAHDEP)
     * positif(SEUIL_IMPDEFBA + 1 - SHBA - (REVTP-BA1) -(
                somme(i=1..3 : GLNi) +max(0,4BAQV+4BAQC+4BAQP + BAHQTOTMIN + BAHQTOTMAXN) +GLN4V + GLN4C+ somme (i=V,C,1..4: PENALIMi)+
                somme(i=V,C,1..4: PENFi)+somme (i=V,C,1..4:TSNN2TSi)+somme (i=V,C,1..4:TSNN2REMPi)
               +somme (i=V,C,1..4:PRR2i)+T2RV+2RCM + 3RCM + 4RCM + 5RCM + 6RCM + 7RCM+2REVF+3REVF ))+0
+ 
   (BACDEV
 + BAHDEV
 + BACDEC
 + BAHDEC
 + BACDEP
 + BAHDEP 
 - DEFBANIF) * 
   (1-positif(SEUIL_IMPDEFBA + 1 - SHBA - (REVTP-BA1) -(
                somme(i=1..3 : GLNi) +max(0,4BAQV+4BAQC+4BAQP + BAHQTOTMIN + BAHQTOTMAXN) +GLN4V + GLN4C+ somme (i=V,C,1..4: PENALIMi)+
                somme(i=V,C,1..4: PENFi)+somme (i=V,C,1..4:TSNN2TSi)+somme (i=V,C,1..4:TSNN2REMPi)
               +somme (i=V,C,1..4:PRR2i)+T2RV+2RCM + 3RCM + 4RCM + 5RCM + 6RCM + 7RCM+2REVF+3REVF ))+0)
;
SOMDEFTS =
   FRNV * positif (FRNV - 10MINSV)
 + FRNC * positif (FRNC - 10MINSC)
 + FRN1 * positif (FRN1 - 10MINS1)
 + FRN2 * positif (FRN2 - 10MINS2)
 + FRN3 * positif (FRN3 - 10MINS3)
 + FRN4 * positif (FRN4 - 10MINS4);
SOMDEFBIC =
   BICDNV
 + BIHDNV
 + BICDNC
 + BIHDNC
 + BICDNP
 + BIHDNP;
SOMDEFBNC =
   BNCDEV
 + BNHDEV
 + BNCDEC
 + BNHDEC
 + BNCDEP
 + BNHDEP;
SOMDEFLOC =
   LOCDEFPROCGAV
 + LOCDEFPROV
 + LOCDEFPROCGAC
 + LOCDEFPROC
 + LOCDEFPROCGAP
 + LOCDEFPROP;
SOMDEFANT =
   DEFAA5
 + DEFAA4
 + DEFAA3
 + DEFAA2
 + DEFAA1
 + DEFAA0;
SOMDEFICIT =SOMDEFANT+SOMDEFLOC+SOMDEFBNC+SOMDEFBASUP+SOMDEFTS+SOMDEFBIC+RFDHIS; 
SOMDEFICITHTS =SOMDEFANT+SOMDEFLOC+SOMDEFBNC+SOMDEFBASUP+SOMDEFBIC+RFDHIS; 



regle 1000320:
application : iliad;
ART1731 = positif( FLAG_1731)
                      +  positif(DEFRIBIS) * (
                       positif(positif(PREM8_11) * null(VARR30R32) 
                         + null(CODERAPHOR)))
                                                ;
 # ======================================================================
