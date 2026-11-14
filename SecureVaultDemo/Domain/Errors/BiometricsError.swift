//
//  BiometricsError.swift
//  SecureVaultDemo
//
//  Created by hamza Ahmed on 2026-11-13.
//


enum BiometricsError: Error{
    case notAvailable
    case authenticationFailed(Error)
}
