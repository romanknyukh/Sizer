typealias AppContext = DashboardContainer
    & RootContainer
    & OnboardingContainer
    & PremiumContainer
    & SettingsContainer
    & MainContainer
    & SavedContainer
    & TutorialContainer
    & DeleteAlertContainer
    & NameAlertContainer

final class AppContextImpl: AppContext {
    let userDefaultsStore: UserDefaultsStore
    let historyRecordRepository: HistoryRecordRepository

    init() {
        userDefaultsStore = UserDefaultsStoreImpl()
        let historyRecordStorage = HistoryRecordStorageImpl()
        historyRecordRepository = HistoryRecordRepositoryImpl(sizersStorage: historyRecordStorage)
    }
}
