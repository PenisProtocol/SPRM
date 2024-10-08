# SPRM

Yuki Aoki (AokiApp Inc., University of Tsukuba)

## Abstract

This product presents SPRM (State of Primary Elements that is Rolled-up and Merged), a novel optimization technique designed to enhance hash value calculations involving sensitive data. Traditional hashing mechanisms require the entire message, including confidential information, to compute the hash, raising significant privacy concerns. SPRM addresses this by consolidating the initial blocks containing sensitive data into a compact intermediate state, reducing data exposure and computational overhead in the hashing process.

By leveraging the structural properties of hash functions like SHA-256, SPRM efficiently processes contiguous blocks of sensitive information, creating a smaller data footprint while maintaining hash integrity. This approach allows for the validation of data integrity without revealing or transmitting sensitive content. SPRM is particularly useful in scenarios requiring the verification of DID, VC, X.509 Certificates or other cryptographic proofs where both data hiding and transparency are required, and holder-exclusive NFT contents in decentralized manner.

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

#### NFT Metadata

NFTs are unique digital assets that are stored on a blockchain. NFTs can represent a wide range of digital assets, including artwork, music, videos, and other digital files. NFTs are typically associated with metadata that describes the asset, such as the artist's name, title, and description.

The metadata of an NFT is kept public. This is because transparency is important for NFTs, and users need to be able to verify the authenticity and provenance of the asset. However, there are cases where the metadata should be exclusive to the owner of the NFT. For example, an NFT metadata is disclosed only after the purchase of the NFT.

#### Metadata Protection: SBINFT Co., Ltd.

SBINFT Co., Ltd.. has a patent on the NFT access restriction system and NFT access restriction program. The system and program restrict access to the metadata of an NFT to only the owner of the NFT. Only after the authentication of the owner, the metadata is disclosed. This is done by centralized content distribution, which is not a manner of decentralization. Also, the mechanism is patented, so the use of the mechanism may be limited.

## Proposed Method

SPRM is a novel optimization technique designed to enhance hash value calculations involving sensitive data. The key idea behind SPRM is to consolidate the initial blocks containing sensitive data into a compact intermediate state (or IV; Initial Vector), reducing data exposure and computational overhead in the hashing process.

The SPRM algorithm consists of the following steps:

1. **Initialization**: Initialize the SPRM state with the initial blocks containing sensitive data.
2. **Rollup**: Rollup the initial block segments.
3. **Merge**: Merge the rolled-up segments into a compact intermediate state as an IV.
4. **Continue Hashing**: Continue hashing the remaining message blocks using the compact intermediate state as the IV.

The SPRM algorithm is designed to be 100% compatible with existing hash functions like SHA-256. It means that the SPRM algorithm can be used as a drop-in replacement for the existing hashing mechanism without any changes to the hash function itself. So the existing DID/VC/X.509/NFT systems can adopt SPRM without any changes to the existing system.

We prepared the Solidity library for EVM-compatible systems. The contract can verify the data via the library contract. Also we prepared the NFT contract which has the metadata hashed by SPRM. The owner can verify the metadata by hashing the full metadata, while the non-holders can verify the metadata by hashing the masked metadata.

## Use cases

### DID/VC/X.509 Certificates

SPRM can be used to enhance the privacy of Verifiable Credentials where sensitive information is involved in the first block segment of the whole VC data vector. By using SPRM, the initial block segment can be consolidated into a compact intermediate state, reducing data exposure and computational overhead in the hashing process. This allows the subject to prove the authenticity of their credentials without revealing any sensitive information.

### NFT Metadata

SPRM can be used to hide the metadata of NFTs from non-holders. Think of the sexually explicit artwork. The artwork has two variant. One is the full artwork, and the other is the censored artwork. The censoring is done with black rectangles masking the explicit parts. If you purchages the NFT, you can see the full artwork. If you don't, you can only see the censored artwork. By using SPRM, the full artwork can be hashed and stored in the NFT. The owner can get the full artwork and verify the integrity of the artwork by hashing this full artwork. The non-holders can verify the integrity of the artwork by hashing the censored artwork, but with the same hash value powered by SPRM.

In short, SPRM enables NFT metadata access control with the decentralized manner.

## Discussion

SPRM makes use of the structural characteristics of SHA-256. The SHA-256 algorithm processes the input message in 512-bit blocks, which are then processed in a series of rounds to produce the final hash value. The structure of SHA-256 allows for the efficient processing of contiguous blocks of data, making it suitable for the SPRM algorithm.

It can generate the same hash from the full data and the masked data, but it is not the hash collision. The hash collision is the phenomenon where two different data produce the same hash. In the case of SPRM, the full data and the masked data are the same data, but the masked data is the full data with the sensitive data masked. In other words, it is the same data with the same hash, but the sensitive part is hidden.

There is a weakness in SPRM. The SPRM is not suitable for the data that is not continuous. For example, if the sensitive data is not in the first block, but in the middle of the data, the SPRM is not suitable. The SPRM is designed to hide the sensitive data in the first block, and it is not suitable for the data that is not continuous. Also, the mechanism is novel, not matured, not standardized, and not widely adopted, so the security is not fully evaluated yet. But on the other hand, the SPRM is neither a slight evolution of the existing mechanism nor the combination of libraries, but a revolutionary original mechanism, so it has a potential to be a new standard.

## Conclusion

SPRM is a novel optimization technique designed to enhance hash value calculations involving sensitive data. By consolidating the initial blocks containing sensitive data into a compact intermediate state, SPRM reduces data exposure and computational overhead in the hashing process. SPRM is compatible with existing hash functions like SHA-256 and can be used as a drop-in replacement for the existing hashing mechanism. This makes SPRM an attractive option for enhancing privacy and data integrity in applications requiring the verification of DID, VC, X.509 Certificates, and holder-exclusive NFT contents.

For the future work, we plan to extend the usecases other than the topic described before, and to integrate it with many systems.

## References

- [Verifiable Credentials Data Model 1.0](https://www.w3.org/TR/vc-data-model/)
- [Decentralized Identifiers (DIDs) v1.0](https://www.w3.org/TR/did-core/)
- [X.509 Certificates](https://en.wikipedia.org/wiki/X.509)
- [Non-Fungible Tokens (NFTs)](https://en.wikipedia.org/wiki/Non-fungible_token)
- [SHA-256](https://en.wikipedia.org/wiki/SHA-2)
- NFT アクセス制限システムおよび NFT アクセス制限プログラム, 特許第 7133589 号

## Acknowledgements

This work was supported by AokiApp Inc. and the University of Tsukuba.

## Preferred track

We would like to present this work in the following tracks:

- Main Prize: Freedom to Transact
  - We believe that our work helps the freedom to transact by enhancing the privacy. It will enable the censorship-resistant transaction around the sensitive data.
- GMO Internet Group Prize: DID に関する何かおもしろプロダクト
  - We believe that our work is related to the DID/VC ecosystem and incorporates a interesting mechanism and feature.
- Metamask/Linea Prize: Build a DeFi, DeSoc, or Gaming App on Linea
  - We believe that our work around VC relates to DeSoc, and that of NFT relates to DeFi or Gaming App.
  - Deployed contract: 0x8FAC3AbfBfD92BeB634ba598af9b66a433e46d65 (Linea Sepolia Testnet)
  - See: https://sepolia.lineascan.build/address/0x8FAC3AbfBfD92BeB634ba598af9b66a433e46d65#code
- NERO Prize: Build dApps or tools using NERO Chain
  - We believe that our work can be integrated with NERO Chain to enhance the privacy of the data.
  - Deployed contract: 0x8FAC3AbfBfD92BeB634ba598af9b66a433e46d65 (NERO Chain Testnet)
  - see: https://testnetscan.nerochain.io/address/0x8FAC3AbfBfD92BeB634ba598af9b66a433e46d65/contracts#address-tabs
- NEO-X Prize
  - Deployed on NEO-X Testnet
  - Deployed contract: 0x8FAC3AbfBfD92BeB634ba598af9b66a433e46d65 (NEO-X Testnet)
  - https://xt4scan.ngd.network/address/0x8FAC3AbfBfD92BeB634ba598af9b66a433e46d65

Other tracks are also welcome.

- Mercoin
  - Mercoin focuses on NFTs, and our work is related to NFTs.
