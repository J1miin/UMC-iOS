import SwiftUI
import Vision

enum ImageSource {
    case camera
    case photoLibrary
}

@Observable
class ReceiptViewModel {
    
    var images: [UIImage] = [] {
        didSet {
            if let lastImage = images.last {
                processReceipt(lastImage)
            }
        }
    }
    var receipts: [ReceiptModel] = []
    var currentReceipt: ReceiptModel?
    var isProcessing: Bool = false
    
    func addImage(_ image: UIImage, from source: ImageSource) {
        images.append(image)
    }
    
    func processReceipt(_ image: UIImage) {
        guard let cgImage = image.cgImage else {
            print("이미지 변환 실패")
            return
        }
        
        isProcessing = true
        
        let request = VNRecognizeTextRequest { [weak self] request, error in
            guard let self = self,
                  let observations = request.results as? [VNRecognizedTextObservation],
                  error == nil else {
                self?.isProcessing = false
                print("OCR 처리 실패: \(error?.localizedDescription ?? "알 수 없는 오류")")
                return
            }
            
            let recognizedStrings = observations.compactMap { $0.topCandidates(1).first?.string }
            let fullText = recognizedStrings.joined(separator: "\n")
            
            let parsed = self.parseWithoutRegex(from: fullText, image: image)
            
            DispatchQueue.main.async {
                self.currentReceipt = parsed
                if let receipt = parsed {
                    self.receipts.append(receipt)
                }
                self.isProcessing = false
            }
        }
        
        request.recognitionLevel = .accurate
        request.recognitionLanguages = ["ko-KR"]
        
        DispatchQueue.global(qos: .userInitiated).async {
            let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
            try? handler.perform([request])
        }
    }
    
    func deleteReceipt(_ receipt: ReceiptModel) {
        if let index = receipts.firstIndex(where: { $0.id == receipt.id }) {
            receipts.remove(at: index)
        }
    }
    
    private func parseWithoutRegex(from text: String, image: UIImage) -> ReceiptModel? {
        let lines = text.components(separatedBy: .newlines)
        
        var store = "장소 없음"
        var totalAmount = 0
        var orderDate: Date?
        
        var i = 0
        
        print("===== OCR 디버그 시작 =====")
        
        while i < lines.count {
            let trimmed = lines[i].trimmingCharacters(in: .whitespacesAndNewlines)
            print("🔹 [\(i)] \(trimmed)")
            
            // 장소
            if store == "장소 없음", trimmed.contains("점") {
                store = "스타벅스 " + trimmed
            }
            
            // 결제 금액
            if trimmed.contains("결제금액"), i + 2 < lines.count {
                let priceLine = lines[i + 2].trimmingCharacters(in: .whitespaces)
                let numberOnly = priceLine.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
                if let amount = Int(numberOnly) {
                    totalAmount = amount
                }
            }
            
            // 주문 날짜 (yyyy.MM.dd 패턴 또는 yyyy-MM-dd 패턴)
            if orderDate == nil {
                // 날짜 포맷에 맞는 문자열 찾기
                if let datePattern = findDatePattern(in: trimmed) {
                    if let date = parseDate(from: datePattern) {
                        orderDate = date
                        print("📅 주문 날짜 발견: \(datePattern) -> \(date)")
                    }
                }
            }
            
            i += 1
        }
        
        print("===== OCR 디버그 끝 =====")
        print("🏪 매장명: \(store)")
        print("💰 결제 금액: \(totalAmount)")
        print("📅 주문 날짜: \(orderDate?.description ?? "인식 실패")")
        
        let newReceipt = ReceiptModel(
            store: store,
            totalPrice: totalAmount,
            orderDate: orderDate ?? Date(),
            createdAt: Date(),
            image: image
        )
        
        return newReceipt
    }
    
    // 문자열에서 날짜 패턴 찾기
    private func findDatePattern(in text: String) -> String? {
        // yyyy.MM.dd 패턴 (2023.05.15 같은 형식)
        let dotPattern = #"\d{4}[.]\d{2}[.]\d{2}"#
        
        // yyyy-MM-dd 패턴 (2023-05-15 같은 형식)
        let dashPattern = #"\d{4}[-]\d{2}[-]\d{2}"#
        
        // yy.MM.dd 패턴 (23.05.15 같은 형식)
        let shortPattern = #"\d{2}[.]\d{2}[.]\d{2}"#
        
        // MM월 dd일 패턴 (5월 15일 같은 형식)
        let koreanPattern = #"\d{1,2}월\s*\d{1,2}일"#
        
        if let range = text.range(of: dotPattern, options: .regularExpression) {
            return String(text[range])
        } else if let range = text.range(of: dashPattern, options: .regularExpression) {
            return String(text[range])
        } else if let range = text.range(of: shortPattern, options: .regularExpression) {
            return String(text[range])
        } else if let range = text.range(of: koreanPattern, options: .regularExpression) {
            return String(text[range])
        }
        
        return nil
    }
    
    // 날짜 문자열 파싱
    private func parseDate(from dateString: String) -> Date? {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        
        // 다양한 포맷 시도
        let formats = [
            "yyyy.MM.dd",
            "yyyy-MM-dd",
            "yy.MM.dd",
            "M월 d일"
        ]
        
        for format in formats {
            formatter.dateFormat = format
            if let date = formatter.date(from: dateString) {
                return date
            }
        }
        
        return nil
    }
    
    func saveReceipt(_ receipt: ReceiptModel) {
        receipts.append(receipt)
    }
    
    func deleteReceipt(at index: Int) {
        guard index < receipts.count else { return }
        receipts.remove(at: index)
    }
    
    func clearImages() {
        images.removeAll()
    }
}
