//
//  TodayReminderView.swift
//  Planto
//
//  Created by reyamnhf on 01/05/1447 AH.
//
import SwiftUI

private struct OnePxDivider: View {
    @Environment(\.displayScale) private var scale
    var opacity: Double = 0.30
    var body: some View {
        Rectangle()
            .fill(.white.opacity(opacity))
            .frame(height: 1 / scale)
    }
}

struct TodayReminderView: View {
    @EnvironmentObject private var vm: PlantsViewModel

    private let hPad: CGFloat = 16
    private let sectionGap: CGFloat = 14

    var body: some View {
        VStack(spacing: sectionGap) {

            // Header
            VStack(alignment: .leading, spacing: 10) {
                Text("My Plants 🌱")
                    .font(.system(size: 34, weight: .bold))
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity, alignment: .leading)

                OnePxDivider(opacity: 0.30)
            }
            .padding(.horizontal, hPad)
            .padding(.top, 8)

            // Progress or All Done
            if vm.allDone {
                allDoneCard
            } else {
                progressCard
            }

                        // LIST with swipe actions working
            // LIST: swipe works + custom middle divider between rows
            if !vm.allDone {
                List {
                    ForEach(vm.plants.indices, id: \.self) { i in
                        let plant = vm.plants[i]

                        // الصف القابل للسحب
                        PlantRow(plant: plant)
                            .environmentObject(vm)
                            .listRowInsets(EdgeInsets(top: 12, leading: 16, bottom: 12, trailing: 16))
                            .listRowBackground(Color.clear)
                            .listRowSeparator(.hidden)

                        // ✅ فاصل في "نص" المسافة بين العناصر فقط (مو بعد آخر عنصر)
                        if i < vm.plants.count - 1 {
                            MidDividerRow() // تعريفه تحت
                                .listRowInsets(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16))
                                .listRowBackground(Color.clear)
                                .listRowSeparator(.hidden)
                        }
                    }
                }
                .listStyle(.plain)
                .scrollContentBackground(.hidden)
                .background(Color.clear)
                .padding(.top, 4)
            }

            // (7) Floating + button spacing from edges
            HStack {
                Spacer()
                Button { vm.activeSheet = .add } label: {
                    Image(systemName: "plus")
                        .font(.title2.bold())
                        .foregroundStyle(.white)
                        .frame(width: 56, height: 56)
                        .background(
                            Circle()
                                .fill(Color("plantogreen"))
                                .shadow(color: Color("plantogreen").opacity(0.55), radius: 22, y: 10)
                        )
                }
                .padding(.trailing, 22) // tighter to match mock
                .padding(.bottom, 12)   // يرتفع شوي عن الحافة السفلية
            }
        }
        .background(Color.black.ignoresSafeArea())
        // (9) daily rollover: reset watered state once per day
        .onAppear { vm.rolloverIfNeeded() }
    }

    // MARK: - Progress / All Done

    // (1) Animated progress bar + reduced top padding
    private var progressCard: some View {
        let done = vm.plants.filter { $0.isWateredToday }.count
        let line = done == 0
            ? "Your plants are waiting for a sip 💦"
            : "\(done) of your plants feel loved today ✨"

        return VStack(alignment: .leading, spacing: 8) {
            Text(line)
                .foregroundStyle(.white.opacity(0.92))
                .font(.subheadline)

            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: 8)
                    .fill(.white.opacity(0.10))
                GeometryReader { geo in
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color("plantogreen"))
                        .frame(width: geo.size.width * CGFloat(vm.progress))
                        .animation(.easeInOut(duration: 0.25), value: vm.progress)
                }
            }
            .frame(height: 6)
            .padding(.top, 2) // أخف فوق
        }
        .padding(.horizontal, hPad + 4)
        .padding(.top, 2)
    }

    private var allDoneCard: some View {
        VStack(spacing: 24) {
            Spacer(minLength: 6)
            Image("cutePlantWink")
                .resizable().scaledToFit()
                .frame(height: 200)
                .shadow(radius: 12)
                .padding(.top, 50)

            Text("All Done! 🎉")
                .font(.title2).fontWeight(.semibold)
                .foregroundStyle(.white)

            Text("All Reminders Completed")
                .font(.callout)
                .foregroundStyle(.white.opacity(0.7))

            Spacer(minLength: 10)
        }
        .frame(maxWidth: .infinity, alignment: .center)
        .padding(.horizontal, 16)
    }
}

private struct MidDividerRow: View {
    var body: some View {
        VStack(spacing: 0) {
            // padding علوي
            Spacer().frame(height: 10)

            // الخط
            Rectangle()
                .fill(.white.opacity(0.25))
                .frame(height: 0.5)

            // padding سفلي
            Spacer().frame(height: 10)
        }
    }
}


#Preview {
    TodayReminderView()
        .environmentObject(PlantsViewModel())
}
