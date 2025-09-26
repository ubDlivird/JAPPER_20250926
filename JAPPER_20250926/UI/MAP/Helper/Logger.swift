// MARK: - Logger.swift
// このファイルは、アプリケーションのデバッグログを管理します。

import Foundation // DateとDateFormatterを使用するために追加
import CoreLocation

// MARK: - Logger
/// アプリケーションのデバッグログを管理するシングルトンクラス
class Logger {

    // MARK: - プロパティ
    static let shared = Logger()
    private init() {} // シングルトン

    // 処理: タイムスタンプのフォーマットを定義 (効率化のため静的プロパティとして定義)
    private static var logDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS"
        return formatter
    }()
    
    // MARK: - メソッド

    /// 呼び出し元: 主要なイベントのログを出力
    func logEvent(event: String, status: String, duration: Double? = nil, data: Any? = nil) {
        // 処理: デバッグモードが有効な場合のみログを出力
        guard DebugSettings.enableLogging else { return }

        // 処理: タイムスタンプを取得
        let timestamp = Logger.logDateFormatter.string(from: Date())
        
        // 処理: ログメッセージを組み立て
        var logMessage = "[\(timestamp)] [\(event)] \(status)"
        if let duration = duration {
            logMessage += String(format: " (duration: %.3fs)", duration)
        }
        if let data = data {
            logMessage += " - Data: \(data)"
        }
        
        // 処理: ログを出力
        print(logMessage)
    }

    /// 呼び出し元: 処理開始時間を記録
    func startTimer() -> Date {
        return Date()
    }
    
    /// 呼び出し元: 処理終了時の経過時間を計算
    func getDuration(from startDate: Date) -> Double {
        return Date().timeIntervalSince(startDate)
    }
}
