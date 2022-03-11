import SwiftUI

struct Arrow: Shape {
    // 1.
    func path(in rect: CGRect) -> Path {
        Path { path in
            let width = rect.width
            let height = rect.height
            
            // 2.
            path.addLines( [
                CGPoint(x: width * 0.45, y: height),
                CGPoint(x: width * 0.45, y: height * 0.4),
                CGPoint(x: width * 0.35, y: height * 0.4),
                CGPoint(x: width * 0.5, y: height * 0.0),
                CGPoint(x: width * 0.65, y: height * 0.4),
                CGPoint(x: width * 0.55, y: height * 0.4),
                CGPoint(x: width * 0.55, y: height),
                
            ])
            // 3.
            path.closeSubpath()
        }
    }
}

struct Arrow_Previews: PreviewProvider {
    static var previews: some View {
        Arrow()
            .rotationEffect(.degrees(90))
            .frame(width: 60, height: 60)
    }
}
