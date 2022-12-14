Alias: $VC = https://www.w3.org/2018/credentials/v1

ValueSet:      VerifiableCredentualType
Id:	       verfiable-credential-type
Title:	       "Types of Verifiable Credenitals"
Description:   "Types of Verifiable Credenitals"
* ^status = #draft
* include $VC#VC  "Verifiable Credential"



Logical:        VerifiableCredentialProof
Title:          "Logical Model for Verifiable Credential Proof"
Description:    "Logical Model for Verifiable Credential Proof"
* ^url = "http://litlfred.github.io/ig-vcs/StructureDefinition/VerifiableCredentialProof"
* ^version = "0.1"
* ^abstract = false
* ^status = #draft
* type 1..1 string "Type" "Type of proof"


Logical:        VerifiableCredentialEvidence
Title:          "Logical Model for Verifiable Credential Evidence"
Description:    "Logical Model for Verifiable Credential Evidence"
* ^url = "http://litlfred.github.io/ig-vcs/StructureDefinition/VerifiableCredentialEvidence"
* ^version = "0.1"
* ^abstract = false
* ^status = #draft
* id 0..1 url "Identifier" "URL that points to where more information about this instance of evidence can be found"
* type 1..1 string "Type" "Type of evidence"


Logical:        VerifiableCredentialRefreshService
Title:          "Logical Model for Verifiable Refresh Service"
Description:    "Logical Model for Verifiable Refresh Service"
* ^url = "http://litlfred.github.io/ig-vcs/StructureDefinition/VerifiableCredentialRefreshService"
* ^version = "0.1"
* ^abstract = false
* ^status = #draft
* id 1..1 uri "Identifier" "Identifier for the status"
* type 1..1 code "Type" "Refresh Service Type"

Logical:        VerifiableCredentialStatus
Title:          "Logical Model for Verifiable Credential Status"
Description:    "Logical Model for Verifiable Credential Status"
* ^url = "http://litlfred.github.io/ig-vcs/StructureDefinition/VerifiableCredentialStatus"
* ^version = "0.1"
* ^abstract = false
* ^status = #draft
* id 1..1 uri "Identifier" "Identifier for the status"
* type 1..1 code "Type" "Status Type"


Logical:        VerifiableCredentialSubject
Title:          "Logical Model for Verifiable Credential Subject"
Description:    "Logical Model for Verifiable Credential Subject"
* ^url = "http://litlfred.github.io/ig-vcs/StructureDefinition/VerifiableCredentialSubject"
* ^version = "0.1"
* ^abstract = false
* ^status = #draft
* id 0..1 uri "Identifier" "Identifier for the subject"

Logical:        VerifiableCredentialTermsOfUse
Title:          "Logical Model for Verifiable Credential Terms of Use"
Description:    "Logical Model for Verifiable Credential Terms of Use"
* ^url = "http://litlfred.github.io/ig-vcs/StructureDefinition/VerifiableCredentialTermsOfUse"
* ^version = "0.1"
* ^abstract = false
* ^status = #draft
* id 1..1 uri "Identifier" "Identifier for the type"
* type 1..1 code "Type" "Status Type"





Logical:        VerifiableCredentialBase
Title:          "Base Logical Model for Verifiable Credentials"
Description:    "Base Logical Model for Verifiable Credentials. Omits the credentialSubject.  Non-abstract should be instantiated for each credentialSubject schema"
* ^url = "http://litlfred.github.io/ig-vcs/StructureDefinition/VerifiableCredentialBase"
* ^version = "0.1"
* ^abstract = true
* ^status = #draft
* context 1..* uri "Context" "Sets the context of the verifiable credential" 
// * context = https://www.w3.org/2018/credentials/v1
* id 1..1 url "Identifier" "The value of the id property MUST be a single URI. It is RECOMMENDED that the URI in the id be one which, if dereferenced, results in a document containing machine-readable information about the id."
* type 1..* uri "Type"  "The value of the type property"
//* type 1..* code "Type"  "The value of the type property"
//* type from VerifiableCredenitalType (extensible) 
* credentialStatus 0..* VerifiableCredentialStatus "Verifiable Credential Status" "Verifiable Credential Status"
* expirationDate 0..1 dateTime "Expiration Date" "The date and time the credential ceases to be valid." 
* evidence 0..* VerifiableCredentialEvidence "Evidence" "Verifiable Credential Evidence" 
* holder 0..1 uri "Holder" "The holder of the credential"
* issued 0..1 dateTime "Issued" "Issued"
* issuer 1..1 url "Issue" "The entity that issued the credential"
* issuanceDate 0..1 dateTime "Issuance Date" "The date and time the credential becomes valid, which could be a date and time in the future. Note that this value represents the earliest point in time at which the information associated with the credentialSubject property becomes valid."
* proof 1..* VerifiableCredentialProof "Proof" "One or more cryptographic proofs that can be used to detect tampering and verify the authorship"
* refreshService 0..* VerifiableCredentialRefreshService "Refresh Service" "Refresh Service"
* termsofUse 0..1 VerifiableCredentialTermsOfUse "Terms of Use" "Terms of Use"
* validFrom 0..1 dateTime "Valid From" "Valid From"
* validUntil 0..1 dateTime "Valid Until" "Valid Until"

Logical:        VerifiableCredential
Parent:         VerifiableCredentialBase
Title:          "Logical Model for Verifiable Credentials"
Description:    "Logical Model for Verifiable Credentials"
* ^url = "http://litlfred.github.io/ig-vcs/StructureDefinition/VerifiableCredential"
* credentialSubject 1..* VerifiableCredentialSubject "Verifiable Credential Subject" "Verifiable Credential Subject"


Logical:        VerifiableCredentialSubjectBundle
Parent:         VerifiableCredentialSubject
Title:          "Logical Model for Verifiable Credential Subject - FHIR Bundle"
Description:    "Logical Model for Verifiable Credential Subject - FHIR Bundle"
* ^url = "http://litlfred.github.io/ig-vcs/StructureDefinition/VerifiableCredentialSubjectBundle"
* ^version = "0.1"
* ^abstract = false
* ^status = #draft
* fhirVersion 1..1 string "FHIR Version" "FHIR Version"
* fhirBundle 1..1 Bundle "FHIR Bundle"  "FHIR Bundle"


Invariant:      verifiable-credenital-subject-is-bundle
Description:    "Subject of Verifiable Credential is a FHIR Bundle with Version"
Expression:     "credentialSubject.is(FHIR.VerfiableCredenitalSubjectBundle)"
Severity:       #error


Logical:        VerifiableCredentialBundle
Parent:         VerifiableCredentialBase
Title:          "Logical Model for Verifiable Credentials - FHIR Bundle"
Description:    "Logical Model for Verifiable Credentials - FHIR Bundle"
* ^url = "http://litlfred.github.io/ig-vcs/StructureDefinition/VerifiableCredentialBundle"
* credentialSubject 1..* VerifiableCredentialSubjectBundle "Verifiable Credential Subject" "Verifiable Credential Subject"
//* obeys verifiable-credenital-subject-is-bundle
//* credentialSubject only VerifiableCredentialSubjectBundle







Logical:        VerfiableCredentialJWT
Title:          "Logical Model for Verifiable Credentials as JWT"
Description:    "Logical Model for Verifiable Credentials as JWT"
* ^url = "http://litlfred.github.io/ig-vcs/StructureDefinition/VerifiableCredentialJWT"
* ^version = "0.1"
* ^abstract = false
* ^status = #draft

* context 1..* SU url "Context" "Sets the context of the verifiable credential" 
* iss 1..1 SU url "Issuer" "The entity that issued the credential"

