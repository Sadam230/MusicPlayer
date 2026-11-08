//
//  Track.swift
//  MusicPlayer
//

import Foundation

/// Один трек: что показать на экране и какие файлы загрузить.
struct Track {
    let title: String          // название трека
    let artist: String         // исполнитель
    let fileName: String       // имя mp3-файла без расширения, например "track1"
    let coverImageName: String // имя картинки в Assets, например "cover1"
}
