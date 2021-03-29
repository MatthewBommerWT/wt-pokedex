//
//  TypeColors.swift
//  Pokedex
//
//  Created by Matt Bommer on 2/25/21.
//

import Foundation
import UIKit

enum PokemonType: String {
    case normal
    case fire
    case water
    case electric
    case grass
    case ice
    case fighting
    case poison
    case ground
    case flying
    case psychic
    case bug
    case rock
    case ghost
    case dragon
    case dark
    case steel
    case fairy
    case unknown

//    Hex Code Values for all types
//    Normal Type: A8A77A
//    Fire Type:  EE8130
//    Water Type:  6390F0
//    Electric Type:  F7D02C
//    Grass Type:  7AC74C
//    Ice Type:  96D9D6
//    Fighting Type:  C22E28
//    Poison Type:  A33EA1
//    Ground Type:  E2BF65
//    Flying Type:  A98FF3
//    Psychic Type:  F95587
//    Bug Type:  A6B91A
//    Rock Type:  B6A136
//    Ghost Type:  735797
//    Dragon Type:  6F35FC
//    Dark Type:  705746
//    Steel Type:  B7B7CE
//    Fairy Type:  D685AD
//    Unknown Type: 7D9D92
    var color: UIColor {
        switch self {
        case .normal:
            return #colorLiteral(red: 0.6588235294, green: 0.6588235294, blue: 0.4705882353, alpha: 1)
        case .fire:
            return #colorLiteral(red: 0.9411764706, green: 0.5019607843, blue: 0.1882352941, alpha: 1)
        case .water:
            return #colorLiteral(red: 0.4078431373, green: 0.5647058824, blue: 0.9411764706, alpha: 1)
        case .electric:
            return #colorLiteral(red: 0.9725490196, green: 0.8156862745, blue: 0.1882352941, alpha: 1)
        case .grass:
            return #colorLiteral(red: 0.4784313725, green: 0.7803921569, blue: 0.2980392157, alpha: 1)
        case .ice:
            return #colorLiteral(red: 0.5882352941, green: 0.8509803922, blue: 0.8392156863, alpha: 1)
        case .fighting:
            return #colorLiteral(red: 0.7607843137, green: 0.1803921569, blue: 0.1568627451, alpha: 1)
        case .poison:
            return #colorLiteral(red: 0.6392156863, green: 0.2431372549, blue: 0.631372549, alpha: 1)
        case .ground:
            return #colorLiteral(red: 0.8862745098, green: 0.7490196078, blue: 0.3960784314, alpha: 1)
        case .flying:
            return #colorLiteral(red: 0.662745098, green: 0.5607843137, blue: 0.9529411765, alpha: 1)
        case .psychic:
            return #colorLiteral(red: 0.9764705882, green: 0.3333333333, blue: 0.5294117647, alpha: 1)
        case .bug:
            return #colorLiteral(red: 0.6509803922, green: 0.7254901961, blue: 0.1019607843, alpha: 1)
        case .rock:
            return #colorLiteral(red: 0.7137254902, green: 0.631372549, blue: 0.2117647059, alpha: 1)
        case .ghost:
            return #colorLiteral(red: 0.4509803922, green: 0.3411764706, blue: 0.5921568627, alpha: 1)
        case .dragon:
            return #colorLiteral(red: 0.4352941176, green: 0.2078431373, blue: 0.9882352941, alpha: 1)
        case .dark:
            return #colorLiteral(red: 0.4392156863, green: 0.3411764706, blue: 0.2745098039, alpha: 1)
        case .steel:
            return #colorLiteral(red: 0.7176470588, green: 0.7176470588, blue: 0.8078431373, alpha: 1)
        case .fairy:
            return #colorLiteral(red: 0.8392156863, green: 0.5215686275, blue: 0.6784313725, alpha: 1)
        case .unknown:
            return #colorLiteral(red: 0.4901960784, green: 0.6156862745, blue: 0.5725490196, alpha: 1)
        }
    }
}
