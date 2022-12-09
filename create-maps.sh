#!/bin/bash
set -e

#this script assumes jq is installed See: https://stedolan.github.io/jq/download/
#this script assumes matchboxes is running on localhost at port 8080 See: https://github.com/ahdis/matchbox
#intended to be run after sushi has been run with contents in fsh-generated

### @host = http://localhost:8080/hapi-fhir-jpavalidator/fhir
### @host = http://test.ahdis.ch/hapi-fhir-jpavalidator/fhir
### @host = https://ehealthsuisse.ihe-europe.net/hapi-fhir-jpavalidator/fhir


#HOST="http://127.0.0.1:8080/matchbox/fhir"
#HOST="http://hapi.fhir.org/baseR4"
HOST="https://test.ahdis.ch/matchbox/fhir" 


SKIP=2
while getopts :nyh: FLAG ;  do
    case "${FLAG}" in
        n)
	    SKIP=0 ;
	    ;;
        y)
	    SKIP=1 ;
	    ;;
	h)
	    HOST="$OPTARG" ; 
	    ;;
    esac
done

echo "Accessing $HOST/metadata"

### Get capability statement
#curl --request GET $HOST/metadata \
#     -H "Accept: application/fhir+json" 


#make sure all our structure definitions are loaded up
#SDS=( "fsh-generated/resources/StructureDefinition-VerifiableCredentialEvidence.json"        "fsh-generated/resources/StructureDefinition-VerifiableCredentialSubject.json" "fsh-generated/resources/StructureDefinition-VerfiableCredentialJWT.json"      "fsh-generated/resources/StructureDefinition-VerifiableCredentialProof.json"           "fsh-generated/resources/StructureDefinition-VerifiableCredentialSubjectBundle.json" "fsh-generated/resources/StructureDefinition-VerifiableCredential.json"        "fsh-generated/resources/StructureDefinition-VerifiableCredentialRefreshService.json"  "fsh-generated/resources/StructureDefinition-VerifiableCredentialTermsOfUse.json" "fsh-generated/resources/StructureDefinition-VerifiableCredentialBundle.json"  "fsh-generated/resources/StructureDefinition-VerifiableCredentialStatus.json"          )


DOSUSHI=""
DOLOADSD=""
if [ $SKIP -eq 2 ] ; then
   printf 'Run sushi (y/n)? '
   read DOSUSHI
   printf 'Load Structure Definitions (y/n)? '
   read DOLOADSD
fi


if [ $SKIP -eq 1 ] || [ "$DOSUSHI" != "${DOSUSHI#[Yy]}" ] ;then
    echo "Generateing resources"
    sushi
fi


if [ $SKIP -eq 1 ] || [ "$DOLOADSD" != "${DOLOADSD#[Yy]}" ] ;then
    set +e
    SDS=$(ls fsh-generated/resources/StructureDefinition-*json input/resources/StructureDefinition-*json 2> /dev/null)
    set -e
    echo "Found structure definitions:" $SDS


    for SD in ${SDS[@]}
    do
	ID=$(jq -r '.id' $SD)
	echo Loading $SD with $ID
	curl -sS --request PUT $HOST/StructureDefinition/$ID \
	     --data-binary @$SD \
	     -H "Accept: application/fhir+json"  -H "Content-Type: application/fhir+json"
    done
fi
  

#transform all fhir mapping language files in a maps-src directory to json structure maps in a maps directory
RDIR="input"
mkdir -p $RDIR/resources
FILES=`ls $RDIR/maps-src/*.map`
SMAPS=( )
for FILE in $FILES
do
    NAME=${FILE##*/}
    NAME=${NAME%.*}
    SMAP="$RDIR/resources/StructureMap-$NAME.json"
    SMAPS+=($SMAP)
    echo "Crearing structure map $NAME from FHIR Mapping Language in $FILE to $SMAP"
    RESULT=$(curl -sS  --request PUT $HOST/StructureMap/$NAME \
      --data-binary @$FILE \
      -H "Accept: application/fhir+json"  -H "Content-Type: text/fhir-mapping" )
    set +e
    SEVERITY=$(echo $RESULT | jq -e -r '.issue[0].severity' )
    set -e
    if [ "$SEVERITY" != "error"  ]; then
	echo "Generation of $NAME succeeded"
	echo $RESULT > $SMAP
    else
	echo "Generation of $NAME failed: $RESULT"
    fi
done



