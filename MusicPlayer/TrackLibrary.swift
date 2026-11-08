//
//  TrackLibrary.swift
//  MusicPlayer
//

import Foundation

/// Весь список треков хранится здесь, в одном месте.
/// ViewController только берёт его отсюда.
enum TrackLibrary {

    /// Расширение всех аудиофайлов.
    static let audioExtension = "mp3"

    // TODO: замените названия и авторов на настоящие (со страниц Pixabay).
    static let tracks: [Track] = [
        Track(title: "Трек 1",  artist: "Исполнитель 1",  fileName: "track1",  coverImageName: "cover1"),
        Track(title: "Трек 2",  artist: "Исполнитель 2",  fileName: "track2",  coverImageName: "cover2"),
        Track(title: "Трек 3",  artist: "Исполнитель 3",  fileName: "track3",  coverImageName: "cover3"),
        Track(title: "Трек 4",  artist: "Исполнитель 4",  fileName: "track4",  coverImageName: "cover4"),
        Track(title: "Трек 5",  artist: "Исполнитель 5",  fileName: "track5",  coverImageName: "cover5"),
        Track(title: "Трек 6",  artist: "Исполнитель 6",  fileName: "track6",  coverImageName: "cover6"),
        Track(title: "Трек 7",  artist: "Исполнитель 7",  fileName: "track7",  coverImageName: "cover7"),
        Track(title: "Трек 8",  artist: "Исполнитель 8",  fileName: "track8",  coverImageName: "cover8"),
        Track(title: "Трек 9",  artist: "Исполнитель 9",  fileName: "track9",  coverImageName: "cover9"),
        Track(title: "Трек 10", artist: "Исполнитель 10", fileName: "track10", coverImageName: "cover10"),
    ]
}
