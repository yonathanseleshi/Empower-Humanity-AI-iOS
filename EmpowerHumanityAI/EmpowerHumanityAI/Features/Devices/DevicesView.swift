import SwiftUI

struct DevicesView: View {
    @Environment(AppState.self) private var appState
    @State private var devices: [ConnectedDevice] = []
    @State private var isLoading = false
    @State private var selectedDevice: ConnectedDevice? = nil

    var body: some View {
        ScrollView {
            LazyVStack(spacing: EHSpacing.sectionSpacing) {
                if isLoading {
                    EHLoadingView().frame(height: 300)
                } else if devices.isEmpty {
                    EHEmptyState(
                        systemImage: "laptopcomputer.and.iphone",
                        title: "No devices yet",
                        message: "Connect your devices to let Alex work across your entire digital world."
                    )
                } else {
                    devicesSection(title: "Online", devices: devices.filter { $0.status == .online || $0.status == .working })
                    devicesSection(title: "Offline", devices: devices.filter { $0.status == .offline })
                }
            }
            .padding(.horizontal, EHSpacing.screenHorizontal)
            .padding(.vertical, EHSpacing.md)
        }
        .background(EHColors.page)
        .navigationTitle("Devices")
        .sheet(item: $selectedDevice) { device in
            DeviceDetailView(device: device)
        }
        .task {
            guard let userId = appState.currentUser?.id else { return }
            isLoading = true
            devices = (try? await MockDeviceRepository().getDevices(userId: userId)) ?? []
            isLoading = false
        }
    }

    private func devicesSection(title: String, devices: [ConnectedDevice]) -> some View {
        Group {
            if !devices.isEmpty {
                VStack(alignment: .leading, spacing: EHSpacing.sm) {
                    EHSectionHeader(title: title)
                    ForEach(devices) { device in
                        Button { selectedDevice = device } label: {
                            deviceCard(device)
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
        }
    }

    private func deviceCard(_ device: ConnectedDevice) -> some View {
        HStack(spacing: EHSpacing.sm) {
            EHIconContainer(systemName: device.deviceType.iconName, color: statusColor(device.status), size: 44)
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(device.name)
                        .font(EHTypography.bodySmMedium)
                        .foregroundStyle(EHColors.Text.primary)
                    if device.isCurrentDevice {
                        EHStatusBadge(label: "This device", color: EHColors.trustBlue)
                    }
                }
                Text(device.role.displayName)
                    .font(EHTypography.caption)
                    .foregroundStyle(EHColors.Text.muted)
                if let work = device.activeWork {
                    Text(work)
                        .font(EHTypography.caption)
                        .foregroundStyle(EHColors.intelligenceCyan)
                        .lineLimit(1)
                }
            }
            Spacer()
            HStack(spacing: 4) {
                Circle()
                    .fill(statusColor(device.status))
                    .frame(width: 8, height: 8)
                Text(device.status.displayName)
                    .font(EHTypography.caption)
                    .foregroundStyle(EHColors.Text.muted)
            }
        }
        .padding(EHSpacing.cardPadding)
        .ehCard(level: device.status == .working ? 2 : 1)
    }

    private func statusColor(_ status: DeviceStatus) -> Color {
        switch status {
        case .online: return EHColors.progressGreen
        case .working: return EHColors.intelligenceCyan
        case .offline: return EHColors.Text.subtle
        case .idle: return EHColors.Text.subtle
        case .error: return EHColors.red
        }
    }
}

// MARK: - DeviceDetailView

struct DeviceDetailView: View {
    let device: ConnectedDevice
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: EHSpacing.sectionSpacing) {
                    // Device header
                    VStack(alignment: .leading, spacing: EHSpacing.sm) {
                        EHIconContainer(systemName: device.deviceType.iconName, color: EHColors.trustBlue, size: 60)
                        Text(device.name)
                            .font(EHTypography.h2)
                            .foregroundStyle(EHColors.Text.primary)
                        Text(device.role.displayName)
                            .font(EHTypography.bodyMd)
                            .foregroundStyle(EHColors.Text.muted)
                        EHStatusBadge(label: device.status.displayName, color: device.status == .online ? EHColors.progressGreen : EHColors.Text.subtle)
                    }

                    // Stats
                    VStack(alignment: .leading, spacing: EHSpacing.sm) {
                        EHSectionHeader(title: "Status")
                        infoRow("Type", value: device.deviceType.displayName)
                        infoRow("Role", value: device.role.displayName)
                        infoRow("Local AI", value: device.hasLocalAI ? "Enabled" : "Disabled")
                        infoRow("Last seen", value: device.lastSeenAt?.relativeString ?? "Unknown")
                    }
                    .padding(EHSpacing.cardPadding)
                    .ehCard(level: 1)

                    if let work = device.activeWork {
                        VStack(alignment: .leading, spacing: EHSpacing.sm) {
                            EHSectionHeader(title: "Active work")
                            HStack(spacing: EHSpacing.sm) {
                                ProgressView()
                                    .scaleEffect(0.8)
                                    .tint(EHColors.intelligenceCyan)
                                Text(work)
                                    .font(EHTypography.bodySm)
                                    .foregroundStyle(EHColors.Text.secondary)
                            }
                        }
                        .padding(EHSpacing.cardPadding)
                        .ehCard(level: 1)
                    }
                }
                .padding(.horizontal, EHSpacing.screenHorizontal)
                .padding(.vertical, EHSpacing.md)
            }
            .background(EHColors.page)
            .navigationTitle("Device")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") { dismiss() }
                }
            }
        }
    }

    private func infoRow(_ label: String, value: String) -> some View {
        HStack {
            Text(label)
                .font(EHTypography.bodySm)
                .foregroundStyle(EHColors.Text.muted)
            Spacer()
            Text(value)
                .font(EHTypography.bodySm)
                .foregroundStyle(EHColors.Text.secondary)
        }
    }
}
