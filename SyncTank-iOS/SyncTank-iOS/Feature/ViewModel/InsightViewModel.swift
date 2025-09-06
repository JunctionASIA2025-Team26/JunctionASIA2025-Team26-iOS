//
//  InsightViewModel.swift
//  SyncTank
//
//  Created by Demian Yoo on 8/23/25.
//

import SwiftUI
import UserNotifications


@MainActor
final class InsightViewModel: ObservableObject {
    enum Tab: String, CaseIterable { case plans = "Urgent", insight = "Insight" }
    
    @Published var isFetching: Bool = false
    @Published var minSkeletonShown: Bool = false
    @Published var fetchSuccessText: String? = nil
    
    @Published var selected: Tab = .plans
    @Published var page: Int = 0
    @Published var items: [DashItem] = []
    
    let pageSize = 6   // 3열 × 2행
    
    var filtered: [DashItem] {
        switch selected {
        case .plans: return items.filter { $0.kind == .plan }
        case .insight: return items.filter { $0.kind == .insight }
        }
    }
    
    var pageCount: Int {
        let c = filtered.count
        return max(1, Int(ceil(Double(c) / Double(pageSize))))
    }
    
    var pageItems: [DashItem] {
        let start = page * pageSize
        let end = min(filtered.count, start + pageSize)
        guard start < end else { return [] }
        return Array(filtered[start..<end])
    }
    
    func goPrev() { page = max(0, page - 1) }
    func goNext() { page = min(pageCount - 1, page + 1) }
    
    func categoryOnChangeTab(_ t: Tab) {
        selected = t
        page = 0
        
    }
    
    func remove(_ item: DashItem) {
        withAnimation(.spring(response: 0.25, dampingFraction: 0.9)) {
            items.removeAll { $0.id == item.id }
        }
        page = min(page, max(0, pageCount - 1))
    }
    
    func fetchAllDocs() async {
        isFetching = true
        
        do {
            let fetchDocsResult = await APIService.shared.fetchDocs()
            switch fetchDocsResult {
            case .success(let docs):
                await MainActor.run {
                    // 디버깅 로그 추가
                    print(" 받아온 데이터 개수: \(docs.count)")
                    for (index, doc) in docs.enumerated() {
                        print("📱 [\(index)] ID: \(doc.id), Kind: \(doc.kind), Title: \(doc.title), tile: \(doc.leftTime)")
                    }
                    
                    withAnimation {
                        self.items = docs
                    }
                    
                    // items 시간순 정렬
                    let times = self.items.filter({
                        $0.leftTime != nil
                    })
                    
                    let remains = self.items.filter({
                        $0.leftTime == nil
                    })
                    
                    self.items = times.sorted(by: { $0.leftTime! < $1.leftTime! }) + remains
                    
                    let firstItem = times.first
                    
                    guard let firstItem = firstItem else { return }
                    
                    sendLocalNotification(item: firstItem)
                    
                    // 필터링된 데이터 확인
                    print("🔍 Urgent 탭 데이터: \(self.items.filter { $0.kind == .plan }.count)개")
                    print("🔍 Insight 탭 데이터: \(self.items.filter { $0.kind == .insight }.count)개")
                    
                    self.fetchSuccessText = "요청이 완료되었습니다."
                }
            case .failure(let error):
                print("❌ Fetch 실패: \(error)")
            }
        }
        isFetching = false
    }
    
    func testPostToSavedocs(with url: URL) {
        Task {
            guard let payload = makeBase64PreviewPayload(from: url) else {
                print("❌ base64 생성 실패")
                return
            }
            let sample = DashItemRequest(
                id: UUID().uuidString,
                content: "string",
                attachment: payload.toRequest()
            )
            do {
                let response = try await APIService.shared.saveDocs(sample)
                print("✅ POST 성공: \(response)")
            } catch {
                print("❌ 실패: \(error)")
            }
        }
    }

    func sendLocalNotification(item: DashItem) {
        let content = UNMutableNotificationContent()
        content.title = "'\(item.title!)' 일정이 있어요!"
        content.body = "까먹지 않도록 잘 기억하세요!!!"
        content.sound = .default

        // 3초 뒤 발송
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 3, repeats: false)

        let request = UNNotificationRequest(identifier: UUID().uuidString,
                                            content: content,
                                            trigger: trigger)

        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("알림 등록 실패: \(error.localizedDescription)")
            }
        }
    }
    
    @MainActor
    func uploadAndRefresh(text: String, attachment: AttachmentPayload?) async {
        do {
            isFetching = true
            let request = DashItemRequest(
                id: UUID().uuidString,
                content: text.isEmpty ? "No message" : text,
                attachment: attachment?.toRequest()
            )
            
            let result = await APIService.shared.saveDocs(request)
            switch result {
            case .success(let success):
                print("success: \(success)")
            case .failure(let failure):
                print("failure: \(failure)")
            }
            
            await fetchAllDocs()  // 서버 기준으로 다시 가져오기
            isFetching = false
        } catch {
            print("❌ 저장 실패: \(error)")
            isFetching = false
        }
    }
}
