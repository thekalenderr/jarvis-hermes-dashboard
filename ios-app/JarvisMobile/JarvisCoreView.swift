import SwiftUI

struct JarvisCoreView: View {
    var body: some View {
        TimelineView(.animation(minimumInterval: 1.0 / 30.0)) { timeline in
            let time = timeline.date.timeIntervalSinceReferenceDate
            GeometryReader { proxy in
                let side = min(proxy.size.width, proxy.size.height)
                let pulse = 1.0 + sin(time * 2.1) * 0.018

                ZStack {
                    Image("JarvisCore")
                        .resizable()
                        .scaledToFill()
                        .frame(width: proxy.size.width, height: proxy.size.height)
                        .clipped()
                        .saturation(1.12)
                        .contrast(1.08)
                        .brightness(-0.06)
                        .scaleEffect(pulse)

                    RadialGradient(
                        colors: [.clear, .clear, Color(red: 0.0, green: 0.03, blue: 0.06).opacity(0.80)],
                        center: .center,
                        startRadius: side * 0.16,
                        endRadius: side * 0.61
                    )

                    ForEach(0..<4, id: \.self) { index in
                        Circle()
                            .stroke(
                                index == 2 ? Color.mint.opacity(0.68) : Color.cyan.opacity(0.50),
                                style: StrokeStyle(
                                    lineWidth: index == 0 ? 1.8 : 1.1,
                                    dash: [CGFloat(6 + index * 3), CGFloat(8 + index * 2)],
                                    dashPhase: CGFloat(time * Double(index.isMultiple(of: 2) ? 18 : -14))
                                )
                            )
                            .frame(
                                width: side * (0.45 + CGFloat(index) * 0.13),
                                height: side * (0.45 + CGFloat(index) * 0.13)
                            )
                            .rotationEffect(.degrees(time * Double(index.isMultiple(of: 2) ? 13 : -10)))
                            .shadow(color: .cyan.opacity(0.55), radius: index == 0 ? 8 : 3)
                    }

                    Circle()
                        .fill(
                            RadialGradient(
                                colors: [.white.opacity(0.94), .cyan.opacity(0.50), .blue.opacity(0.08), .clear],
                                center: .center,
                                startRadius: 1,
                                endRadius: side * 0.21
                            )
                        )
                        .frame(width: side * 0.38, height: side * 0.38)
                        .scaleEffect(pulse)
                        .blendMode(.screen)

                    ForEach(0..<18, id: \.self) { index in
                        Capsule()
                            .fill(index.isMultiple(of: 4) ? Color.mint : Color.cyan)
                            .frame(width: index.isMultiple(of: 4) ? 14 : 5, height: 2)
                            .offset(y: -side * 0.44)
                            .rotationEffect(.degrees(Double(index) * 20 + time * 5))
                            .opacity(index.isMultiple(of: 3) ? 0.88 : 0.45)
                            .shadow(color: .cyan, radius: 4)
                    }

                    VStack(spacing: 4) {
                        Spacer()
                        Text("NEURAL CORE // SECURE LINK")
                            .font(.system(size: 9, weight: .bold, design: .monospaced))
                            .tracking(1.5)
                            .foregroundStyle(Color.mint)
                            .shadow(color: .cyan, radius: 7)
                        HStack(spacing: 5) {
                            Circle().fill(Color.green).frame(width: 5, height: 5)
                                .shadow(color: .green, radius: 5)
                            Text("SYSTEM ONLINE")
                                .font(.system(size: 8, weight: .medium, design: .monospaced))
                                .tracking(1.2)
                                .foregroundStyle(.white.opacity(0.76))
                        }
                    }
                    .padding(.bottom, 13)
                }
                .frame(width: proxy.size.width, height: proxy.size.height)
                .background(Color.black)
                .clipShape(RoundedRectangle(cornerRadius: 28, style: .continuous))
                .overlay(
                    RoundedRectangle(cornerRadius: 28, style: .continuous)
                        .stroke(
                            LinearGradient(
                                colors: [.cyan.opacity(0.72), .mint.opacity(0.20), .cyan.opacity(0.48)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 1
                        )
                )
                .shadow(color: .cyan.opacity(0.24), radius: 28)
            }
        }
        .frame(height: 250)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("JARVIS yeni nesil enerji çekirdeği, sistem çevrimiçi")
        .accessibilityIdentifier("jarvisCore")
    }
}
