//
//  ColorCubeHelper.swift
//
//  Created by Joshua Sullivan on 10/10/16.
//  Copyright © 2016 Joshua Sullivan. All rights reserved.
//
import UIKit
import Accelerate

public class ColorCubeHelper {
    
    public enum ColorCubeError: Error {
        case incorrectImageSize
        case missingImageData
        case unableToCreateDataProvider
        case unableToGetBitmpaDataBuffer
    }
    
    public static func createColorCubeData(inputImage image: UIImage, cubeDimension: Int) throws -> Data {
        
        // Set up some variables for calculating memory size.
        let imageSize = image.size
        let dim = Int(imageSize.width)
        let pixels = dim * dim
        let channels = 4
        
        // If the number of pixels doesn't match what's needed for the supplied cube dimension, abort.
        guard pixels == cubeDimension * cubeDimension * cubeDimension else {
            throw ColorCubeError.incorrectImageSize
        }
        
        // We don't need a sizeof() because uint_8t is explicitly 1 byte.
        let memSize = pixels * channels
        
        // Get the UIImage's backing CGImageRef
        guard let img = image.cgImage else {
            throw ColorCubeError.missingImageData
        }
        
        // Get a reference to the CGImage's data provider.
        guard let inProvider = img.dataProvider else {
            throw ColorCubeError.unableToCreateDataProvider
        }
        
        let inBitmapData = inProvider.data
        guard let inBuffer = CFDataGetBytePtr(inBitmapData) else {
            throw ColorCubeError.unableToGetBitmpaDataBuffer
        }
        
        // Calculate the size of the float buffer and allocate it.
        let floatSize = memSize * MemoryLayout<Float>.size
        let finalBuffer = unsafeBitCast(malloc(floatSize), to:UnsafeMutablePointer<Float>.self)
        
        // Convert the uint_8t to float. Note: a uint of 255 will convert to 255.0f.
        vDSP_vfltu8(inBuffer, 1, finalBuffer, 1, UInt(memSize))
        
        // Divide each float by 255.0 to get the 0-1 range we are looking for.
        var divisor = Float(255.0)
        vDSP_vsdiv(finalBuffer, 1, &divisor, finalBuffer, 1, UInt(memSize))
        
        // Don't copy the bytes, just have the NSData take ownership of the buffer.
        let cubeData = NSData(bytesNoCopy: finalBuffer, length: floatSize, freeWhenDone: true)
        
        return cubeData as Data
        
    }
}
