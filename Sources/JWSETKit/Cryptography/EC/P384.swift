//
//  P384.swift
//
//
//  Created by Amir Abbas Mousavian on 9/9/23.
//

import Foundation
#if canImport(CryptoKit)
import CryptoKit
#else
import Crypto
#endif

extension P384.Signing.PublicKey: CryptoECPublicKey {
    static var curve: JSONWebKeyCurve { .p384 }
}

extension P384.KeyAgreement.PublicKey: CryptoECPublicKey {
    static var curve: JSONWebKeyCurve { .p384 }
}

extension P384.Signing.PublicKey: JSONWebValidatingKey {
    public func verifySignature<S, D>(_ signature: S, for data: D, using _: JSONWebSignatureAlgorithm) throws where S: DataProtocol, D: DataProtocol {
        let ecdsaSignature: P384.Signing.ECDSASignature
        // swiftformat:disable:next redundantSelf
        if signature.count == (self.curve?.coordinateSize ?? 0) * 2 {
            ecdsaSignature = try .init(rawRepresentation: signature)
        } else {
            ecdsaSignature = try .init(derRepresentation: signature)
        }
        if !isValidSignature(ecdsaSignature, for: SHA384.hash(data: data)) {
            throw CryptoKitError.authenticationFailure
        }
    }
}

extension P384.Signing.PublicKey: CryptoECPublicKeyPortable {}

extension P384.KeyAgreement.PublicKey: CryptoECPublicKeyPortable {}

extension P384.Signing.PrivateKey: JSONWebSigningKey, CryptoECPrivateKey {
    public init(algorithm _: any JSONWebAlgorithm) throws {
        self.init(compactRepresentable: false)
    }
    
    public func signature<D>(_ data: D, using _: JSONWebSignatureAlgorithm) throws -> Data where D: DataProtocol {
        try signature(for: SHA384.hash(data: data)).rawRepresentation
    }
}

extension P384.KeyAgreement.PrivateKey: CryptoECPrivateKey {
    public init(algorithm _: any JSONWebAlgorithm) throws {
        self.init(compactRepresentable: false)
    }
}

extension P384.Signing.PrivateKey: CryptoECPrivateKeyPortable {}

extension P384.KeyAgreement.PrivateKey: CryptoECPrivateKeyPortable {}
