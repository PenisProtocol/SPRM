# SPRM

Yuki Aoki (AokiApp Inc., University of Tsukuba)

## Abstract

This prpduct presents SPRM (State of Primary Elements that is Rolled-up and Merged), a novel optimization technique designed to enhance hash value calculations involving sensitive data. Traditional hashing mechanisms require the entire message, including confidential information, to compute the hash, raising significant privacy concerns. SPRM addresses this by consolidating the initial blocks containing sensitive data into a compact intermediate state, reducing data exposure and computational overhead in the hashing process.

By leveraging the structural properties of hash functions like SHA-256, SPRM efficiently processes contiguous blocks of sensitive information, creating a smaller data footprint while maintaining hash integrity. This approach allows for the validation of data integrity without revealing or transmitting sensitive content. SPRM is particularly useful in scenarios requiring the verification of DID, VC, X.509 Certificates or other cryptographic proofs, and holder-exclusive NFT contents where both data hiding and transparency are required.

## Introduction

Hash functions are essential cryptographic tools used to verify data integrity and ensure secure communication. These functions generate a fixed-size hash value from an input message of arbitrary length, which is then used to verify the message's integrity. Hash functions are widely used in various applications, including digital signatures, blockchain, and secure communication protocols.

However, traditional hashing mechanisms have limitations when dealing with sensitive data. When hashing a message containing confidential information, the entire message must be processed, exposing the sensitive content to the hashing algorithm. This raises significant privacy concerns, especially when dealing with personal data or other sensitive information.

SPRM addresses this issue by consolidating the initial blocks containing sensitive data into a compact intermediate state. This intermediate state is then used as the input to the hash function, reducing data exposure and computational overhead in the hashing process. By leveraging the structural properties of hash functions like SHA-256, SPRM efficiently processes contiguous blocks of sensitive information, creating a smaller data footprint while maintaining hash integrity.

## Related Work

### DID/VC primitives

Verifiable Credentials is the digital representation of credentials that are issued by an entity to a subject. The credentials are cryptographically signed by the issuer and can be verified by anyone who has access to the issuer's public key. Verifiable Credentials are used to prove the authenticity of the subject's identity, qualifications, or other attributes.

Decentralized Identifiers (DIDs) are one of the key components of the Verifiable Credentials ecosystem. DIDs are unique identifiers that are associated with a subject and can be used to reference the subject's credentials. DIDs are designed to be self-sovereign, meaning that the subject has full control over their DIDs and the associated credentials.

VCs usually contains the following information:

- **Who you are**: The subject's identity information, such as name, date of birth, and address.
- **What you have**: The entitlements or qualifications that the subject possesses, such as a TOEIC score or a driver's license. For DID, it is the liveness of the subject.
- **Claims**: Additional information that is relevant to the subject's identity or qualifications, such as a photo or a signature.
- **Proof**: A cryptographic proof that the credential was issued by a trusted issuer and has not been tampered with.

The problem with traditional VCs is the privacy concerns. When a subject presents a VC to a verifier, the verifier can see all the information contained in the VC, including sensitive information such as the subject's address, face photo. This raises significant privacy concerns, especially when dealing with personal data or other sensitive information. To address this issue, privacy-preserving methods for VCs have been proposed in the literature.

### Privacy Preserving method for Distributed IDs or Verifiable Credentials

Privacy-preserving methods for distributed IDs or verifiable credentials have been extensively studied in the literature. Various techniques have been proposed to protect the privacy of sensitive information while still allowing for verification of data integrity. These techniques include zero-knowledge proofs, homomorphic encryption, and secure multi-party computation.

#### Selective Disclosure

Selective disclosure is a privacy-preserving method that allows a subject to reveal only the necessary information to a verifier. Instead of presenting the entire VC to the verifier, the subject can selectively disclose specific attributes or claims from the VC. This allows the subject to protect their sensitive information while still proving the authenticity of their credentials.

The weakness of selective disclosure compared to SPRM is that it is not compatible with the existing protocol. Selective Disclosure is not yet standardized and requires additional implementation effort to integrate with existing systems. The issuer must adopt and replace the existing system. In contrast, SPRM is a drop-in replacement for the existing hashing mechanism.

#### Zero-Knowledge Proofs

Zero-knowledge proofs are a privacy-preserving method that allows a subject to prove the authenticity of their credentials without revealing any sensitive information. Zero-knowledge proofs are based on the concept of zero-knowledge, which allows a prover to convince a verifier of a statement's truth without revealing any information about the statement itself.

Zero-knowledge proofs are powerful tools for privacy-preserving authentication, but they can be computationally expensive and complex to implement. Zero-knowledge proofs require specialized cryptographic techniques and protocols, making them challenging to integrate with existing systems.

Also, Zero-Knowledge Proofs are not yet standardized and require additional implementation effort to integrate with existing systems. The issuer must adopt and replace the existing system.

Compared to this, SPRM is lightweight, efficient, and easy to integrate with existing systems. Also, the returning value is a hash value, which enables the other usecase of cryptographic hash, such as hash comparison, hash search. ZKP is not suitable for this usecase since the returning value is a boolean value of successing the proof.

### X.509 Certificates

X.509 Certificates are digital certificates that are used to verify the authenticity of a public key. X.509 Certificates are widely used in various applications, including SSL/TLS certificates, code signing certificates, and email certificates.

X.509 is the traditional way before the era of DID/VC. It shares the same privacy concerns as VCs. When a subject presents an X.509 certificate to a verifier, the verifier can see all the information contained in the certificate, including sensitive information such as the subject's name, organization, and email address.

### Non-Fungible Tokens (NFTs)

Non-Fungible Tokens (NFTs) are unique digital assets that are stored on a blockchain. Usually NFTs have metadata, which will be such as artwork, music, videos, or other digital files. Transparency is important for NFTs, so the metadata is made public, even for those who don't own the NFT. However, there are many cases where the metadata should be exclusive to the owner of the NFT, and usually requires purchase from marketplace in order to view the metadata. This is where SPRM can be useful. By using SPRM, the metadata can be hashed and stored in the NFT, and the owner can prove the integrity of the metadata without revealing the content. The hash value don't change even if the metadata is changed, so the owner can prove the integrity of the metadata with the full content, while non-holders can verify from the public area.

## Proposed Method

SPRM is a novel optimization technique designed to enhance hash value calculations involving sensitive data. The key idea behind SPRM is to consolidate the initial blocks containing sensitive data into a compact intermediate state (or IV; Initial Vector), reducing data exposure and computational overhead in the hashing process.

The SPRM algorithm consists of the following steps:

1. **Initialization**: Initialize the SPRM state with the initial blocks containing sensitive data.
2. **Rollup**: Rollup the initial block segments.
3. **Merge**: Merge the rolled-up segments into a compact intermediate state as an IV.
4. **Continue Hashing**: Continue hashing the remaining message blocks using the compact intermediate state as the IV.

The SPRM algorithm is designed to be 100% compatible with existing hash functions like SHA-256. It means that the SPRM algorithm can be used as a drop-in replacement for the existing hashing mechanism without any changes to the hash function itself. So the existing DID/VC/X.509/NFT systems can adopt SPRM without any changes to the existing system.

## Use cases

### DID/VC/X.509 Certificates

SPRM can be used to enhance the privacy of Verifiable Credentials where sensitive information is involved in the first block segment of the whole VC data vector. By using SPRM, the initial block segment can be consolidated into a compact intermediate state, reducing data exposure and computational overhead in the hashing process. This allows the subject to prove the authenticity of their credentials without revealing any sensitive information.

### NFT Metadata

SPRM can be used to hide the metadata of NFTs from non-holders. Think of the sexually explicit artwork. The artwork has two variant. One is the full artwork, and the other is the censored artwork. The censoring is done with black rectangles masking the explicit parts. If you purchages the NFT, you can see the full artwork. If you don't, you can only see the censored artwork. By using SPRM, the full artwork can be hashed and stored in the NFT. The owner can get the full artwork and verify the integrity of the artwork by hashing this full artwork. The non-holders can verify the integrity of the artwork by hashing the censored artwork, but with the same hash value powered by SPRM.

## Discussion

SPRM makes use of the structural characteristics of SHA-256. The SHA-256 algorithm processes the input message in 512-bit blocks, which are then processed in a series of rounds to produce the final hash value. The structure of SHA-256 allows for the efficient processing of contiguous blocks of data, making it suitable for the SPRM algorithm.

It can generate the same hash from the full data and the masked data, but it is not the hash collision. The hash collision is the phenomenon where two different data produce the same hash. In the case of SPRM, the full data and the masked data are the same data, but the masked data is the full data with the sensitive data masked. In other words, it is the same data with the same hash, but the sensitive part is hidden.

## Conclusion

SPRM is a novel optimization technique designed to enhance hash value calculations involving sensitive data. By consolidating the initial blocks containing sensitive data into a compact intermediate state, SPRM reduces data exposure and computational overhead in the hashing process. SPRM is compatible with existing hash functions like SHA-256 and can be used as a drop-in replacement for the existing hashing mechanism. This makes SPRM an attractive option for enhancing privacy and data integrity in applications requiring the verification of DID, VC, X.509 Certificates, and holder-exclusive NFT contents.

## References

- [Verifiable Credentials Data Model 1.0](https://www.w3.org/TR/vc-data-model/)
- [Decentralized Identifiers (DIDs) v1.0](https://www.w3.org/TR/did-core/)
- [X.509 Certificates](https://en.wikipedia.org/wiki/X.509)
- [Non-Fungible Tokens (NFTs)](https://en.wikipedia.org/wiki/Non-fungible_token)
- [SHA-256](https://en.wikipedia.org/wiki/SHA-2)

## Acknowledgements

This work was supported by AokiApp Inc. and the University of Tsukuba.
