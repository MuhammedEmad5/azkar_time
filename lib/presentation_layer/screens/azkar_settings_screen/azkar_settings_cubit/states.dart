abstract class AzkarSettingsStates{}

class AzkarSettingsInitialState extends AzkarSettingsStates{}

class ShowDefaultDialogState extends AzkarSettingsStates{}
class CheckIfStartTimeBeforeEndTimeState extends AzkarSettingsStates{}
class GetStartAndEndTimeState extends AzkarSettingsStates{}

class DailyAzkarAlarmState extends AzkarSettingsStates{}

class CheckIfTimeNowBeforeStartTimeState extends AzkarSettingsStates{}
class CheckIfTimeNowAfterEndTimeState extends AzkarSettingsStates{}


class StartAzkarPeriodSuccessState extends AzkarSettingsStates{}
class StartAzkarPeriodErrorState extends AzkarSettingsStates{}

class UpdateStartAzkarPeriodSuccessState extends AzkarSettingsStates{}
class UpdateStartAzkarPeriodErrorState extends AzkarSettingsStates{}

class EndAzkarPeriodSuccessState extends AzkarSettingsStates{}


