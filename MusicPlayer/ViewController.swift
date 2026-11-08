//
//  ViewController.swift
//  MusicPlayer
//

import UIKit
import AVFoundation

class ViewController: UIViewController {

    // MARK: - Outlets (связи с элементами из Main.storyboard)

    @IBOutlet weak var coverImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var artistLabel: UILabel!
    @IBOutlet weak var playPauseButton: UIButton!

    // MARK: - Состояние (всё в одном месте)

    private let tracks = TrackLibrary.tracks
    private var currentIndex = 0      // какой трек сейчас выбран
    private var isPlaying = false     // играет ли музыка

    /// Плеер хранится в свойстве, чтобы жить столько же, сколько экран.
    /// Если создать его локальной переменной внутри метода,
    /// он удалится в конце метода, и музыка сразу замолчит.
    private var player: AVAudioPlayer?

    // MARK: - Жизненный цикл

    override func viewDidLoad() {
        super.viewDidLoad()
        setupAudioSession()
        loadCurrentTrack()
        updateUI()
    }

    // MARK: - Actions (нажатия на кнопки)

    @IBAction func previousTapped(_ sender: UIButton) {
        switchTrack(by: -1)
    }

    @IBAction func playPauseTapped(_ sender: UIButton) {
        if isPlaying {
            player?.pause()
            isPlaying = false
        } else {
            // Если файл раньше не загрузился — пробуем ещё раз.
            if player == nil {
                loadCurrentTrack()
            }
            // play() возвращает true, если музыка действительно заиграла.
            isPlaying = player?.play() ?? false
        }
        updateUI()
    }

    @IBAction func nextTapped(_ sender: UIButton) {
        switchTrack(by: 1)
    }

    // MARK: - Логика

    /// Переключает трек вперёд (+1) или назад (-1) по кругу.
    /// Если музыка играла — новый трек тоже сразу играет.
    private func switchTrack(by step: Int) {
        guard !tracks.isEmpty else { return }

        // Остаток от деления делает список «кольцом»:
        // после последнего идёт первый, перед первым — последний.
        currentIndex = (currentIndex + step + tracks.count) % tracks.count

        loadCurrentTrack()
        if isPlaying {
            isPlaying = player?.play() ?? false
        }
        updateUI()
    }

    /// Загружает mp3 текущего трека в новый плеер.
    private func loadCurrentTrack() {
        player?.stop()
        player = nil

        guard !tracks.isEmpty else { return }
        let track = tracks[currentIndex]
        let fullName = "\(track.fileName).\(TrackLibrary.audioExtension)"

        // 1. Ищем файл внутри приложения (bundle).
        //    Если файла нет или у него не стоит Target Membership — url будет nil.
        guard let url = Bundle.main.url(forResource: track.fileName,
                                        withExtension: TrackLibrary.audioExtension) else {
            showError("Файл \(fullName) не найден в приложении. Проверьте Target Membership.")
            return
        }

        // 2. Создаём плеер. Если файл битый — будет ошибка, ловим её в catch.
        do {
            let newPlayer = try AVAudioPlayer(contentsOf: url)
            newPlayer.delegate = self   // чтобы узнать, когда трек доиграет
            newPlayer.prepareToPlay()
            player = newPlayer
        } catch {
            showError("Не удалось открыть \(fullName): \(error.localizedDescription)")
        }
    }

    /// Обновляет весь экран по текущему состоянию.
    /// Вызывается после каждого нажатия.
    private func updateUI() {
        guard !tracks.isEmpty else { return }
        let track = tracks[currentIndex]

        coverImageView.image = UIImage(named: track.coverImageName)
        titleLabel.text = track.title
        artistLabel.text = track.artist

        let iconName = isPlaying ? "pause.fill" : "play.fill"
        playPauseButton.configuration?.image = UIImage(systemName: iconName)
    }

    /// Чтобы звук играл, даже если на iPhone включён беззвучный режим.
    private func setupAudioSession() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback)
        } catch {
            print("⚠️ Audio session error: \(error.localizedDescription)")
        }
    }

    /// Ошибку всегда печатаем в консоль, а если экран уже на виду — ещё и показываем алерт.
    private func showError(_ message: String) {
        print("⚠️ \(message)")

        guard viewIfLoaded?.window != nil, presentedViewController == nil else { return }
        let alert = UIAlertController(title: "Ошибка", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

// MARK: - AVAudioPlayerDelegate

extension ViewController: AVAudioPlayerDelegate {

    /// Вызывается, когда трек доиграл до конца.
    nonisolated func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        // Этот метод может прийти не из главного потока,
        // а экран можно менять только из главного — поэтому переключаемся на него.
        Task { @MainActor in
            // isPlaying всё ещё true, поэтому следующий трек сразу заиграет.
            self.switchTrack(by: 1)
        }
    }
}
