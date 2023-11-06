abstract class AlarmStates{}

class AlarmInitialState extends AlarmStates{}
class AlarmChangeIndexState extends AlarmStates{}

class CreateDataBaseSuccessState extends AlarmStates{}

class OpenDataBaseSuccessState extends AlarmStates{}

class InsertToDataBaseSuccessState extends AlarmStates{}
class InsertToDataBaseErrorState extends AlarmStates{}


class GetDataBaseLoadingState extends AlarmStates{}
class GetDataBaseSuccessState extends AlarmStates{}
class GetDataBaseErrorState extends AlarmStates{}

class UpdateDataSuccessBaseState extends AlarmStates{}
class DeleteFromDataBaseSuccessState extends AlarmStates{}
