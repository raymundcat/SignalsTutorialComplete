//
//  DownloadManager.swift
//  SignalsTutorialComplete
//
//  Created by John Raymund Catahay on 12/02/2017.
//  Copyright © 2017 John Raymund Catahay. All rights reserved.
//

import Foundation
import Signals

protocol CanDownloadItems {
    func requestDownload(item: DownloadableItem)
}

protocol CanBroadcastTasks {
    var downloadTasksSignal: Signal<[Int:DownloadItemTask]> { get set }
}

class DownloadManager: CanDownloadItems, CanBroadcastTasks{
    
    static let shared = DownloadManager()
    
    var downloadTasksSignal = Signal<[Int:DownloadItemTask]>()
    private var downloadTasks = [Int:DownloadItemTask]()
    
    private init(){
        Timer.scheduledTimer(withTimeInterval: 0.25, repeats: true, block: { [unowned self] (timer) in
            self.downloadTasksSignal.fire(self.downloadTasks)
        }).fire()
    }
    
    func requestDownload(item: DownloadableItem){
        var task = DownloadItemTask(item: item, progress: 0)
        
        Timer.scheduledTimer(withTimeInterval: 0.25, repeats: true) {[unowned self](timer) in
            if task.progress < 100{
                task.progress += 5
                self.downloadTasks[item.id] = task
            }else{
                timer.invalidate()
                self.downloadTasks.removeValue(forKey: item.id)
            }
        }
    }
}
